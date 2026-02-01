import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:kickr_trainer/domain/entities/strength_exercise.dart';
import 'package:kickr_trainer/domain/entities/strength_session.dart';

import '../app_database.dart';
import '../tables/strength_session_table.dart';

part 'strength_session_dao.g.dart';

@DriftAccessor(tables: [StrengthSessions])
class StrengthSessionDao extends DatabaseAccessor<AppDatabase>
    with _$StrengthSessionDaoMixin {
  StrengthSessionDao(super.db);

  /// Speichert eine neue Session
  Future<void> insertSession(StrengthSession session) async {
    await into(strengthSessions).insert(
      StrengthSessionsCompanion.insert(
        id: session.id,
        startTimeMs: session.startTime.millisecondsSinceEpoch,
        endTimeMs: Value(session.endTime?.millisecondsSinceEpoch),
        workoutId: Value(session.workoutId),
        exercisesJson: jsonEncode(
          session.exercises.map((e) => e.toJson()).toList(),
        ),
        statsDurationSecs: Value(session.stats?.duration.inSeconds ?? 0),
        statsTotalSets: Value(session.stats?.totalSets ?? 0),
        statsTotalReps: Value(session.stats?.totalReps ?? 0),
        statsTotalVolume: Value(session.stats?.totalVolume ?? 0.0),
        statsAvgRpe: Value(session.stats?.avgRpe),
        statsExercisesCompleted: Value(session.stats?.exercisesCompleted ?? 0),
        statsMuscleGroupWorkJson: Value(
          jsonEncode(session.stats?.muscleGroupWork
              .map((k, v) => MapEntry(k.name, v)) ??
              {}),
        ),
        notes: Value(session.notes),
      ),
    );
  }

  /// Lädt alle Sessions
  Future<List<StrengthSession>> getAllSessions() async {
    final entities = await select(strengthSessions).get();
    return entities.map(_entityToSession).toList();
  }

  /// Lädt eine Session nach ID
  Future<StrengthSession?> getSessionById(String id) async {
    final entity = await (select(strengthSessions)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return entity != null ? _entityToSession(entity) : null;
  }

  /// Lädt neueste Sessions
  Future<List<StrengthSession>> getRecentSessions({int limit = 10}) async {
    final entities = await (select(strengthSessions)
          ..orderBy([(t) => OrderingTerm.desc(t.startTimeMs)])
          ..limit(limit))
        .get();
    return entities.map(_entityToSession).toList();
  }

  /// Lädt Sessions innerhalb eines Datumbereichs
  Future<List<StrengthSession>> getSessionsInDateRange(
    DateTime startDate,
    DateTime endDate, {
    int limit = 100,
  }) async {
    final entities = await (select(strengthSessions)
          ..where(
            (t) =>
                t.startTimeMs.isBiggerOrEqualValue(startDate.millisecondsSinceEpoch) &
                t.startTimeMs.isSmallerOrEqualValue(endDate.millisecondsSinceEpoch),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.startTimeMs)])
          ..limit(limit))
        .get();
    return entities.map(_entityToSession).toList();
  }

  /// Lädt Sessions für ein bestimmtes Workout
  Future<List<StrengthSession>> getSessionsByWorkout(String workoutId) async {
    final entities = await (select(strengthSessions)
          ..where((t) => t.workoutId.equals(workoutId))
          ..orderBy([(t) => OrderingTerm.desc(t.startTimeMs)]))
        .get();
    return entities.map(_entityToSession).toList();
  }

  /// Beobachtet neueste Sessions
  Stream<List<StrengthSession>> watchRecentSessions({int limit = 20}) {
    return (select(strengthSessions)
          ..orderBy([(t) => OrderingTerm.desc(t.startTimeMs)])
          ..limit(limit))
        .watch()
        .map((entities) {
      return entities.map(_entityToSession).toList();
    });
  }

  /// Aktualisiert eine Session
  Future<bool> updateSession(StrengthSession session) async {
    return await update(strengthSessions).replace(
      StrengthSessionsCompanion(
        id: Value(session.id),
        startTimeMs: Value(session.startTime.millisecondsSinceEpoch),
        endTimeMs: Value(session.endTime?.millisecondsSinceEpoch),
        workoutId: Value(session.workoutId),
        exercisesJson: Value(
          jsonEncode(session.exercises.map((e) => e.toJson()).toList()),
        ),
        statsDurationSecs: Value(session.stats?.duration.inSeconds ?? 0),
        statsTotalSets: Value(session.stats?.totalSets ?? 0),
        statsTotalReps: Value(session.stats?.totalReps ?? 0),
        statsTotalVolume: Value(session.stats?.totalVolume ?? 0.0),
        statsAvgRpe: Value(session.stats?.avgRpe),
        statsExercisesCompleted: Value(session.stats?.exercisesCompleted ?? 0),
        statsMuscleGroupWorkJson: Value(
          jsonEncode(session.stats?.muscleGroupWork
              .map((k, v) => MapEntry(k.name, v)) ??
              {}),
        ),
        notes: Value(session.notes),
      ),
    );
  }

  /// Löscht eine Session
  Future<bool> deleteSession(String id) async {
    return await (delete(strengthSessions)
          ..where((t) => t.id.equals(id)))
        .go() >
        0;
  }

  /// Konvertiert Entity zu Domain-Objekt
  StrengthSession _entityToSession(StrengthSessionEntity entity) {
    try {
      // Decode exercises
      final exercisesData = jsonDecode(entity.exercisesJson) as List;
      final exercises = exercisesData
          .map((e) => StrengthExerciseRecord.fromJson(e as Map<String, dynamic>))
          .toList();

      // Decode muscle group work
      final muscleGroupWorkData = jsonDecode(entity.statsMuscleGroupWorkJson) as Map;
      final muscleGroupWork = muscleGroupWorkData.cast<String, int>().map(
        (k, v) => MapEntry(
          MuscleGroup.values.firstWhere(
            (mg) => mg.name == k,
            orElse: () => MuscleGroup.fullBody,
          ),
          v,
        ),
      );

      // Build stats if available
      final stats = entity.statsTotalSets > 0
          ? StrengthSessionStats(
              duration: Duration(seconds: entity.statsDurationSecs),
              totalSets: entity.statsTotalSets,
              totalReps: entity.statsTotalReps,
              totalVolume: entity.statsTotalVolume,
              avgRpe: entity.statsAvgRpe,
              exercisesCompleted: entity.statsExercisesCompleted,
              muscleGroupWork: muscleGroupWork,
            )
          : null;

      return StrengthSession(
        id: entity.id,
        startTime: DateTime.fromMillisecondsSinceEpoch(entity.startTimeMs),
        endTime: entity.endTimeMs != null
            ? DateTime.fromMillisecondsSinceEpoch(entity.endTimeMs!)
            : null,
        workoutId: entity.workoutId,
        exercises: exercises,
        stats: stats,
        notes: entity.notes,
      );
    } catch (e) {
      rethrow;
    }
  }
}
