import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../domain/entities/workout.dart';
import '../app_database.dart';
import '../tables/custom_workout_table.dart';

part 'workout_dao.g.dart';

@DriftAccessor(tables: [CustomWorkouts])
class WorkoutDao extends DatabaseAccessor<AppDatabase> with _$WorkoutDaoMixin {
  WorkoutDao(super.db);

  /// Speichert ein neues Workout
  Future<void> insertWorkout(Workout workout) async {
    await into(customWorkouts).insert(
      CustomWorkoutsCompanion.insert(
        id: workout.id,
        name: workout.name,
        description: Value(workout.description),
        workoutType: workout.type.name,
        intervalsJson: _encodeIntervals(workout.intervals),
        createdAt: workout.createdAt ?? DateTime.now(),
        updatedAt: const Value(null),
      ),
    );
  }

  /// Aktualisiert ein bestehendes Workout
  Future<void> updateWorkout(Workout workout) async {
    await (update(customWorkouts)..where((t) => t.id.equals(workout.id))).write(
      CustomWorkoutsCompanion(
        name: Value(workout.name),
        description: Value(workout.description),
        workoutType: Value(workout.type.name),
        intervalsJson: Value(_encodeIntervals(workout.intervals)),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Löscht ein Workout
  Future<void> deleteWorkout(String id) async {
    await (delete(customWorkouts)..where((t) => t.id.equals(id))).go();
  }

  /// Lädt alle benutzerdefinierten Workouts
  Future<List<Workout>> getAllWorkouts() async {
    final entities = await select(customWorkouts).get();
    return entities.map(_entityToWorkout).toList();
  }

  /// Beobachtet alle Workouts
  Stream<List<Workout>> watchAllWorkouts() {
    return select(customWorkouts).watch().map(
          (entities) => entities.map(_entityToWorkout).toList(),
        );
  }

  /// Lädt ein einzelnes Workout
  Future<Workout?> getWorkout(String id) async {
    final entity = await (select(customWorkouts)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return entity != null ? _entityToWorkout(entity) : null;
  }

  /// Konvertiert eine Entity zu einem Domain Workout
  Workout _entityToWorkout(CustomWorkoutEntity entity) {
    return Workout(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      type: WorkoutType.values.firstWhere(
        (t) => t.name == entity.workoutType,
        orElse: () => WorkoutType.interval,
      ),
      intervals: _decodeIntervals(entity.intervalsJson),
      createdAt: entity.createdAt,
    );
  }

  /// Kodiert Intervalle als JSON
  String _encodeIntervals(List<WorkoutInterval> intervals) {
    return jsonEncode(intervals.map((i) => i.toJson()).toList());
  }

  /// Dekodiert Intervalle aus JSON
  List<WorkoutInterval> _decodeIntervals(String json) {
    final list = jsonDecode(json) as List;
    return list
        .map((item) => WorkoutInterval.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
