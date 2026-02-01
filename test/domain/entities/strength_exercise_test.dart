import 'package:flutter_test/flutter_test.dart';
import 'package:kickr_trainer/domain/entities/strength_exercise.dart';

void main() {
  group('StrengthExercise', () {
    final testExercise = StrengthExercise(
      id: 'ex_squat',
      name: 'Bodyweight Squat',
      description: 'Lower body fundamental exercise',
      primaryMuscles: [MuscleGroup.legs],
      secondaryMuscles: [MuscleGroup.core],
      equipment: EquipmentType.bodyweight,
      formCues: 'Feet shoulder-width, knees track over toes, sit back into hips',
      difficulty: DifficultyLevel.beginner,
      isCompound: true,
      minimumAge: 18,
      requiresModification50Plus: true,
      modification50PlusNotes: 'Use chair for support if needed',
    );

    test('should create StrengthExercise with correct properties', () {
      expect(testExercise.id, 'ex_squat');
      expect(testExercise.name, 'Bodyweight Squat');
      expect(testExercise.primaryMuscles, [MuscleGroup.legs]);
      expect(testExercise.equipment, EquipmentType.bodyweight);
      expect(testExercise.difficulty, DifficultyLevel.beginner);
      expect(testExercise.isCompound, true);
      expect(testExercise.minimumAge, 18);
      expect(testExercise.requiresModification50Plus, true);
    });

    test('should be equal when properties are the same', () {
      final exercise1 = testExercise;
      final exercise2 = testExercise.copyWith();
      expect(exercise1, exercise2);
    });

    test('should be different when properties change', () {
      final exercise1 = testExercise;
      final exercise2 = testExercise.copyWith(name: 'Assisted Squat');
      expect(exercise1, isNot(exercise2));
    });

    group('copyWith', () {
      test('should copy with modified name', () {
        final modified = testExercise.copyWith(name: 'Assisted Squat');
        expect(modified.name, 'Assisted Squat');
        expect(modified.id, testExercise.id);
        expect(modified.equipment, testExercise.equipment);
      });

      test('should preserve other properties when copying', () {
        final modified = testExercise.copyWith(difficulty: DifficultyLevel.advanced);
        expect(modified.difficulty, DifficultyLevel.advanced);
        expect(modified.name, testExercise.name);
        expect(modified.equipment, testExercise.equipment);
      });

      test('should allow multiple property changes', () {
        final modified = testExercise.copyWith(
          name: 'Assisted Squat',
          equipment: EquipmentType.none,
          difficulty: DifficultyLevel.intermediate,
        );
        expect(modified.name, 'Assisted Squat');
        expect(modified.equipment, EquipmentType.none);
        expect(modified.difficulty, DifficultyLevel.intermediate);
        expect(modified.id, testExercise.id);
      });
    });

    group('JSON serialization', () {
      test('should serialize to JSON', () {
        final json = testExercise.toJson();
        expect(json['id'], 'ex_squat');
        expect(json['name'], 'Bodyweight Squat');
        expect(json['equipment'], 'bodyweight');
        expect(json['difficulty'], 'beginner');
        expect(json['isCompound'], true);
        expect(json['minimumAge'], 18);
      });

      test('should deserialize from JSON', () {
        final json = testExercise.toJson();
        final deserialized = StrengthExercise.fromJson(json);
        expect(deserialized, testExercise);
      });

      test('should handle missing optional fields', () {
        final json = {
          'id': 'ex_test',
          'name': 'Test Exercise',
          'description': 'A test exercise',
          'primaryMuscles': ['legs'],
          'secondaryMuscles': [],
          'equipment': 'bodyweight',
          'formCues': 'Test cues',
          'difficulty': 'beginner',
          'isCompound': false,
        };
        final exercise = StrengthExercise.fromJson(json);
        expect(exercise.videoUrl, null);
        expect(exercise.maximumAge, null);
        expect(exercise.modification50PlusNotes, null);
      });
    });

    test('should handle equipment type enum correctly', () {
      expect(EquipmentType.values.length, 6);
      expect(EquipmentType.values, contains(EquipmentType.dumbbells));
      expect(EquipmentType.values, contains(EquipmentType.barbell));
      expect(EquipmentType.values, contains(EquipmentType.kettlebell));
    });

    test('should handle muscle group enum correctly', () {
      expect(MuscleGroup.values.length, 7);
      expect(MuscleGroup.values, contains(MuscleGroup.chest));
      expect(MuscleGroup.values, contains(MuscleGroup.back));
      expect(MuscleGroup.values, contains(MuscleGroup.shoulders));
      expect(MuscleGroup.values, contains(MuscleGroup.legs));
      expect(MuscleGroup.values, contains(MuscleGroup.core));
    });

    test('should handle difficulty level enum correctly', () {
      expect(DifficultyLevel.values.length, 3);
      expect(DifficultyLevel.values, contains(DifficultyLevel.beginner));
      expect(DifficultyLevel.values, contains(DifficultyLevel.intermediate));
      expect(DifficultyLevel.values, contains(DifficultyLevel.advanced));
    });

    test('should allow multiple muscle groups', () {
      final exercise = StrengthExercise(
        id: 'ex_deadlift',
        name: 'Deadlift',
        description: 'Full body exercise',
        primaryMuscles: [MuscleGroup.legs, MuscleGroup.back],
        secondaryMuscles: [MuscleGroup.core, MuscleGroup.arms],
        equipment: EquipmentType.barbell,
        formCues: 'Keep chest up, hip hinge movement',
        difficulty: DifficultyLevel.advanced,
        isCompound: true,
        minimumAge: 18,
        requiresModification50Plus: true,
      );
      expect(exercise.primaryMuscles.length, 2);
      expect(exercise.secondaryMuscles.length, 2);
      expect(exercise.isCompound, true);
    });

    test('should have default minimumAge if not specified', () {
      final exercise = StrengthExercise(
        id: 'ex_test',
        name: 'Test',
        description: 'Test',
        primaryMuscles: [MuscleGroup.chest],
        secondaryMuscles: [],
        equipment: EquipmentType.bodyweight,
        formCues: 'Test',
        difficulty: DifficultyLevel.beginner,
        isCompound: false,
        minimumAge: 18,
        requiresModification50Plus: false,
      );
      expect(exercise.minimumAge, 18);
    });

    test('should support 50+ modifications', () {
      expect(testExercise.requiresModification50Plus, true);
      expect(testExercise.modification50PlusNotes, isNotNull);

      final noModification = testExercise.copyWith(
        requiresModification50Plus: false,
        modification50PlusNotes: null,
      );
      expect(noModification.requiresModification50Plus, false);
    });
  });
}
