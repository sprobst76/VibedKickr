import 'package:drift/drift.dart';
import 'package:kickr_trainer/domain/entities/strength_exercise.dart';

import '../app_database.dart';
import '../tables/strength_exercise_table.dart';

part 'strength_exercise_dao.g.dart';

@DriftAccessor(tables: [StrengthExercises])
class StrengthExerciseDao extends DatabaseAccessor<AppDatabase>
    with _$StrengthExerciseDaoMixin {
  StrengthExerciseDao(super.db);

  /// Speichert eine neue Übung
  Future<void> insertExercise(StrengthExercise exercise) async {
    await into(strengthExercises).insert(
      StrengthExercisesCompanion.insert(
        id: exercise.id,
        name: exercise.name,
        description: exercise.description,
        primaryMusclesJson: _encodeEnumList(exercise.primaryMuscles),
        secondaryMusclesJson: _encodeEnumList(exercise.secondaryMuscles),
        equipment: exercise.equipment.name,
        formCues: exercise.formCues,
        videoUrl: Value(exercise.videoUrl),
        difficulty: exercise.difficulty.name,
        isCompound: Value(exercise.isCompound),
        minimumAge: Value(exercise.minimumAge),
        maximumAge: Value(exercise.maximumAge),
        requiresModification50Plus: Value(exercise.requiresModification50Plus),
        modification50PlusNotes: Value(exercise.modification50PlusNotes),
      ),
    );
  }

  /// Lädt alle Übungen
  Future<List<StrengthExercise>> getAllExercises() async {
    final entities = await select(strengthExercises).get();
    return entities.map(_entityToExercise).toList();
  }

  /// Lädt eine Übung nach ID
  Future<StrengthExercise?> getExerciseById(String id) async {
    final entity = await (select(strengthExercises)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return entity != null ? _entityToExercise(entity) : null;
  }

  /// Lädt Übungen nach Muskelgruppe
  Future<List<StrengthExercise>> getExercisesByMuscleGroup(
      MuscleGroup muscleGroup) async {
    final exercises = await getAllExercises();
    return exercises
        .where((ex) =>
            ex.primaryMuscles.contains(muscleGroup) ||
            ex.secondaryMuscles.contains(muscleGroup))
        .toList();
  }

  /// Lädt Übungen nach Equipment
  Future<List<StrengthExercise>> getExercisesByEquipment(
      EquipmentType equipment) async {
    final exercises = await getAllExercises();
    return exercises.where((ex) => ex.equipment == equipment).toList();
  }

  /// Beobachtet alle Übungen
  Stream<List<StrengthExercise>> watchExercises() {
    return select(strengthExercises).watch().map((entities) {
      return entities.map(_entityToExercise).toList();
    });
  }

  /// Löscht eine Übung
  Future<bool> deleteExercise(String id) async {
    return await (delete(strengthExercises)
          ..where((t) => t.id.equals(id)))
        .go() >
        0;
  }

  /// Konvertiert Entity zu Domain-Objekt
  StrengthExercise _entityToExercise(StrengthExerciseEntity entity) {
    return StrengthExercise(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      primaryMuscles: _decodeEnumList<MuscleGroup>(
        entity.primaryMusclesJson,
        MuscleGroup.values,
      ),
      secondaryMuscles: _decodeEnumList<MuscleGroup>(
        entity.secondaryMusclesJson,
        MuscleGroup.values,
      ),
      equipment: EquipmentType.values.firstWhere(
        (e) => e.name == entity.equipment,
        orElse: () => EquipmentType.bodyweight,
      ),
      formCues: entity.formCues,
      videoUrl: entity.videoUrl,
      difficulty: DifficultyLevel.values.firstWhere(
        (d) => d.name == entity.difficulty,
        orElse: () => DifficultyLevel.beginner,
      ),
      isCompound: entity.isCompound,
      minimumAge: entity.minimumAge,
      maximumAge: entity.maximumAge,
      requiresModification50Plus: entity.requiresModification50Plus,
      modification50PlusNotes: entity.modification50PlusNotes,
    );
  }

  /// Kodiert eine Liste von Enums zu JSON
  String _encodeEnumList<T extends Enum>(List<T> values) {
    return '[${values.map((v) => '"${v.name}"').join(',')}]';
  }

  /// Dekodiert JSON zu einer Liste von Enums
  List<T> _decodeEnumList<T extends Enum>(
    String json,
    List<T> enumValues,
  ) {
    try {
      final values = json
          .replaceAll('[', '')
          .replaceAll(']', '')
          .replaceAll('"', '')
          .split(',')
          .where((s) => s.isNotEmpty)
          .toList();

      return enumValues
          .where((e) => values.contains(e.name))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
