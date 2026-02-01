import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:kickr_trainer/domain/entities/strength_exercise.dart';
import 'package:kickr_trainer/domain/entities/strength_workout.dart';

import '../app_database.dart';
import '../tables/strength_workout_table.dart';

part 'strength_workout_dao.g.dart';

@DriftAccessor(tables: [StrengthWorkouts])
class StrengthWorkoutDao extends DatabaseAccessor<AppDatabase>
    with _$StrengthWorkoutDaoMixin {
  StrengthWorkoutDao(super.db);

  /// Speichert ein neues Workout
  Future<void> insertWorkout(StrengthWorkout workout) async {
    await into(strengthWorkouts).insert(
      StrengthWorkoutsCompanion.insert(
        id: workout.id,
        name: workout.name,
        description: workout.description,
        intervalsJson: jsonEncode(
          workout.intervals.map((i) => i.toJson()).toList(),
        ),
        workoutType: workout.type.name,
        estimatedDurationMinutes: workout.estimatedDurationMinutes,
        difficulty: workout.difficulty.name,
        isCustom: Value(workout.isCustom),
        createdAt: workout.createdAt ?? DateTime.now(),
      ),
    );
  }

  /// Lädt alle Workouts
  Future<List<StrengthWorkout>> getAllWorkouts() async {
    final entities = await select(strengthWorkouts).get();
    return entities.map(_entityToWorkout).toList();
  }

  /// Lädt ein Workout nach ID
  Future<StrengthWorkout?> getWorkoutById(String id) async {
    final entity = await (select(strengthWorkouts)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return entity != null ? _entityToWorkout(entity) : null;
  }

  /// Lädt alle Custom Workouts
  Future<List<StrengthWorkout>> getCustomWorkouts() async {
    final entities = await (select(strengthWorkouts)
          ..where((t) => t.isCustom.equals(true)))
        .get();
    return entities.map(_entityToWorkout).toList();
  }

  /// Lädt Workouts nach Schwierigkeitsgrad
  Future<List<StrengthWorkout>> getWorkoutsByDifficulty(
      DifficultyLevel difficulty) async {
    final entities = await (select(strengthWorkouts)
          ..where((t) => t.difficulty.equals(difficulty.name)))
        .get();
    return entities.map(_entityToWorkout).toList();
  }

  /// Beobachtet alle Workouts
  Stream<List<StrengthWorkout>> watchWorkouts() {
    return select(strengthWorkouts).watch().map((entities) {
      return entities.map(_entityToWorkout).toList();
    });
  }

  /// Beobachtet Custom Workouts
  Stream<List<StrengthWorkout>> watchCustomWorkouts() {
    return (select(strengthWorkouts)..where((t) => t.isCustom.equals(true)))
        .watch()
        .map((entities) {
      return entities.map(_entityToWorkout).toList();
    });
  }

  /// Aktualisiert ein Workout
  Future<bool> updateWorkout(StrengthWorkout workout) async {
    return await update(strengthWorkouts).replace(
      StrengthWorkoutsCompanion(
        id: Value(workout.id),
        name: Value(workout.name),
        description: Value(workout.description),
        intervalsJson: Value(
          jsonEncode(workout.intervals.map((i) => i.toJson()).toList()),
        ),
        workoutType: Value(workout.type.name),
        estimatedDurationMinutes: Value(workout.estimatedDurationMinutes),
        difficulty: Value(workout.difficulty.name),
        isCustom: Value(workout.isCustom),
        createdAt: Value(workout.createdAt ?? DateTime.now()),
      ),
    );
  }

  /// Löscht ein Workout
  Future<bool> deleteWorkout(String id) async {
    return await (delete(strengthWorkouts)
          ..where((t) => t.id.equals(id)))
        .go() >
        0;
  }

  /// Konvertiert Entity zu Domain-Objekt
  StrengthWorkout _entityToWorkout(StrengthWorkoutEntity entity) {
    try {
      final intervalsData = jsonDecode(entity.intervalsJson) as List;
      final intervals = intervalsData
          .map((i) => StrengthInterval.fromJson(i as Map<String, dynamic>))
          .toList();

      return StrengthWorkout(
        id: entity.id,
        name: entity.name,
        description: entity.description,
        intervals: intervals,
        type: WorkoutType.values.firstWhere(
          (t) => t.name == entity.workoutType,
          orElse: () => WorkoutType.fullBody,
        ),
        estimatedDurationMinutes: entity.estimatedDurationMinutes,
        difficulty: DifficultyLevel.values.firstWhere(
          (d) => d.name == entity.difficulty,
          orElse: () => DifficultyLevel.beginner,
        ),
        isCustom: entity.isCustom,
        createdAt: entity.createdAt,
      );
    } catch (e) {
      rethrow;
    }
  }
}
