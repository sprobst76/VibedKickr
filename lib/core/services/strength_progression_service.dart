import 'package:kickr_trainer/core/database/daos/strength_pr_dao.dart';
import 'package:kickr_trainer/core/database/daos/strength_session_dao.dart';
import 'package:kickr_trainer/domain/entities/strength_session.dart';
import 'package:kickr_trainer/domain/entities/strength_workout.dart';

/// Empfehlung für Progression
class ProgressionRecommendation {
  final String message;
  final LoadTarget? suggestedLoad;
  final bool shouldDeload;
  final double estimatedOneRepMax;

  const ProgressionRecommendation({
    required this.message,
    this.suggestedLoad,
    this.shouldDeload = false,
    required this.estimatedOneRepMax,
  });
}

/// Service für intelligente Progressions-Berechnung
class StrengthProgressionService {
  // ignore: unused_field
  final StrengthSessionDao _sessionDao;
  final StrengthPRDao _prDao;

  StrengthProgressionService(this._sessionDao, this._prDao);

  /// Linear Progression: +2.5kg wenn alle Sätze bei Zielwiederholungen erfolgreich
  Future<LoadTarget?> calculateNextLoad(
    String exerciseId,
    List<StrengthSession> recentSessions, {
    int requiredSessions = 3,
  }) async {
    if (recentSessions.length < requiredSessions) {
      return null; // Zu wenig Daten für Empfehlung
    }

    // Letzte n sessions für diesen exercise filtern
    final exerciseSessions = recentSessions
        .where((session) =>
            session.exercises
                .any((ex) => ex.exerciseId == exerciseId))
        .toList();

    if (exerciseSessions.length < requiredSessions) {
      return null;
    }

    // Letzten PR laden (von den verfügbaren reps)
    StrengthPR? currentPR;
    for (final reps in [1, 3, 5, 10]) {
      currentPR = await _prDao.getCurrentRecord(exerciseId, reps);
      if (currentPR != null) break;
    }

    if (currentPR == null) {
      return null; // Kein PR vorhanden
    }

    // Prüfen ob letzte 3 Sessions mit aktuellem Gewicht alle Zielwiederholungen erfolgreich waren
    bool allSuccessful = true;
    for (final session in exerciseSessions.take(requiredSessions)) {
      final exerciseRecord = session.exercises
          .firstWhere((ex) => ex.exerciseId == exerciseId);

      // Alle sets mit der aktuellen rep-zahl prüfen
      final targetSets = exerciseRecord.sets
          .where((set) => set.repsCompleted == currentPR!.reps)
          .toList();

      if (targetSets.isEmpty) {
        allSuccessful = false;
        break;
      }

      // Alle sets sollten das aktuelle Gewicht oder höher sein
      for (final set in targetSets) {
        if (set.weightUsed == null || set.weightUsed! < currentPR.weightKg) {
          allSuccessful = false;
          break;
        }
      }

      if (!allSuccessful) break;
    }

    if (allSuccessful) {
      // Progression: +2.5kg
      final nextWeight = currentPR.weightKg + 2.5;
      return LoadTarget.weight(nextWeight);
    }

    return null; // Noch nicht ready für progression
  }

  /// Deload Detection: 2+ fehlgeschlagene Sessions in Folge → reduzieren um 10%
  Future<bool> shouldDeload(
    String exerciseId,
    List<StrengthSession> sessions,
  ) async {
    if (sessions.length < 2) return false;

    // Aktuelle PR für relevante rep-zahl laden
    StrengthPR? currentPR;
    for (final reps in [1, 3, 5, 10]) {
      currentPR = await _prDao.getCurrentRecord(exerciseId, reps);
      if (currentPR != null) break;
    }

    if (currentPR == null) return false;

    // Letzten 2 Sessions prüfen
    int failedCount = 0;
    for (final session in sessions.take(2)) {
      final exerciseRecord = session.exercises
          .cast<StrengthExerciseRecord?>()
          .firstWhere((ex) => ex?.exerciseId == exerciseId, orElse: () => null);

      if (exerciseRecord == null) {
        failedCount++;
        continue;
      }

      // Zielwiederholungen mit aktuellem Gewicht
      final targetSets = exerciseRecord.sets
          .where((set) => set.repsCompleted == currentPR!.reps)
          .toList();

      if (targetSets.isEmpty) {
        failedCount++;
        continue;
      }

      // Wenn kein Set das aktuelle Gewicht erreicht: fehlgeschlagen
      bool sessionFailed = true;
      for (final set in targetSets) {
        if (set.weightUsed != null && set.weightUsed! >= currentPR.weightKg) {
          sessionFailed = false;
          break;
        }
      }

      if (sessionFailed) {
        failedCount++;
      }
    }

    return failedCount >= 2;
  }

  /// Wöchentliches Volumen berechnen: sets × reps × weight
  Future<double> calculateWeeklyVolume(
    List<StrengthSession> weekSessions, {
    Duration? timeWindow,
  }) async {
    final cutoffTime = timeWindow != null
        ? DateTime.now().subtract(timeWindow)
        : DateTime.now().subtract(const Duration(days: 7));

    double totalVolume = 0;

    for (final session in weekSessions) {
      if (session.startTime.isBefore(cutoffTime)) continue;

      for (final exerciseRecord in session.exercises) {
        for (final set in exerciseRecord.sets) {
          if (set.weightUsed != null) {
            totalVolume += set.weightUsed! * set.repsCompleted;
          }
        }
      }
    }

    return totalVolume;
  }

  /// Progressions-Empfehlung basierend auf Performance
  Future<ProgressionRecommendation> getRecommendation(
    String exerciseId,
    List<StrengthSession> history,
  ) async {
    if (history.isEmpty) {
      return ProgressionRecommendation(
        message: 'Starten Sie Ihr erstes Training für diese Übung',
        estimatedOneRepMax: 0,
      );
    }

    // Aktuellen PR laden
    StrengthPR? currentPR;
    for (final reps in [1, 3, 5, 10]) {
      currentPR = await _prDao.getCurrentRecord(exerciseId, reps);
      if (currentPR != null) break;
    }

    if (currentPR == null) {
      return ProgressionRecommendation(
        message:
            'Bauen Sie einen PR auf, indem Sie die Übung regelmäßig trainieren',
        estimatedOneRepMax: 0,
      );
    }

    // Geschätztes 1RM berechnen
    final estimatedOneRM = currentPR.weightKg * (1 + currentPR.reps / 30);

    // Deload-Warnung prüfen
    final needsDeload = await shouldDeload(exerciseId, history.take(5).toList());
    if (needsDeload) {
      return ProgressionRecommendation(
        message:
            'Sie brauchen einen Deload-Woche. Reduzieren Sie das Gewicht um 10%.',
        suggestedLoad: LoadTarget.weight(currentPR.weightKg * 0.9),
        shouldDeload: true,
        estimatedOneRepMax: estimatedOneRM,
      );
    }

    // Progression prüfen
    final nextLoad = await calculateNextLoad(exerciseId, history);
    if (nextLoad != null) {
      return ProgressionRecommendation(
        message:
            'Ausgezeichnet! Sie sind bereit für +2,5kg. Erhöhen Sie das Gewicht in der nächsten Session.',
        suggestedLoad: nextLoad,
        estimatedOneRepMax: estimatedOneRM,
      );
    }

    // Standard-Empfehlung
    return ProgressionRecommendation(
      message:
          'Weiterhin ${currentPR.reps} Wiederholungen bei ${currentPR.weightKg}kg trainieren',
      estimatedOneRepMax: estimatedOneRM,
    );
  }
}
