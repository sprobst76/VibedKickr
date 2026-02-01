import 'package:kickr_trainer/core/database/daos/strength_pr_dao.dart';
import 'package:kickr_trainer/domain/entities/strength_session.dart';

/// Service für die Verwaltung von Kraft-Training Personal Records
class StrengthRecordService {
  final StrengthPRDao _prDao;

  StrengthRecordService(this._prDao);

  /// Berechnet das geschätzte 1RM mit Epley-Formel: weight × (1 + reps/30)
  ///
  /// Beispiele:
  /// - 100kg × 1 rep = 100kg (1 + 1/30 = 1.033)
  /// - 80kg × 5 reps = 93.3kg (1 + 5/30 = 1.167)
  /// - 60kg × 10 reps = 80kg (1 + 10/30 = 1.333)
  double calculateOneRepMax(double weight, int reps) {
    if (reps < 1) return weight;
    return weight * (1 + reps / 30);
  }

  /// Analysiert eine Session auf neue PRs (1RM, 3RM, 5RM, 10RM pro Übung)
  Future<List<StrengthPR>> analyzeSession(StrengthSession session) async {
    final newRecords = <StrengthPR>[];

    for (final exerciseRecord in session.exercises) {
      // Für jede mögliche Wiederholungszahl prüfen
      for (final reps in [1, 3, 5, 10]) {
        // Sets mit dieser Wiederholungszahl finden
        final relevantSets = exerciseRecord.sets
            .where((set) => set.repsCompleted == reps && set.weightUsed != null)
            .toList();

        if (relevantSets.isEmpty) continue;

        // Maximum weight für diese rep-zahl in der session
        final maxWeight = relevantSets
            .map((set) => set.weightUsed!)
            .reduce((a, b) => a > b ? a : b);

        // Prüfen ob neuer PR
        final isNewRecord = await _prDao.isNewRecord(
          exerciseRecord.exerciseId,
          reps,
          maxWeight,
        );

        if (isNewRecord) {
          // Vorheriges PR laden
          final previousRecord = await _prDao.getCurrentRecord(
            exerciseRecord.exerciseId,
            reps,
          );

          final record = StrengthPR(
            exerciseId: exerciseRecord.exerciseId,
            weightKg: maxWeight,
            reps: reps,
            achievedAt: session.startTime,
            sessionId: session.id,
            previousWeightKg: previousRecord?.weightKg,
          );

          await _prDao.insertRecord(record);
          newRecords.add(record);
        }
      }
    }

    return newRecords;
  }

  /// Lädt alle aktuellen PRs (1RM, 3RM, 5RM, 10RM pro Übung)
  Future<Map<String, Map<int, StrengthPR>>> getAllRecords() async {
    return _prDao.getAllCurrentRecordsAllExercises();
  }

  /// Beobachtet PRs für eine bestimmte Übung
  Stream<List<StrengthPR>> watchExerciseRecords(String exerciseId) {
    return _prDao.watchRecordsByExercise(exerciseId).map((records) {
      return records.values.toList();
    });
  }

  /// Lädt PR-History für eine Übung und Wiederholungszahl
  Future<List<StrengthPR>> getRecordHistory(
    String exerciseId,
    int reps, {
    int limit = 10,
  }) async {
    return _prDao.getRecordHistory(exerciseId, reps, limit: limit);
  }

  /// Lädt aktuellen PR für eine Übung und Wiederholungszahl
  Future<StrengthPR?> getCurrentRecord(String exerciseId, int reps) async {
    return _prDao.getCurrentRecord(exerciseId, reps);
  }

  /// Löscht einen PR-Eintrag
  Future<bool> deleteRecord(int id) async {
    return _prDao.deleteRecord(id);
  }
}
