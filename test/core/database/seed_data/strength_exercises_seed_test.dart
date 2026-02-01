import 'package:flutter_test/flutter_test.dart';
import 'package:kickr_trainer/core/database/seed_data/strength_exercises.dart';
import 'package:kickr_trainer/domain/entities/strength_exercise.dart';

void main() {
  group('StrengthExerciseSeedData - Exercise Library', () {
    test('should have at least 15 exercises', () {
      final exercises = StrengthExerciseSeedData.defaultExercises;
      expect(exercises.length, greaterThanOrEqualTo(15));
    });

    test('should have 19 exercises', () {
      final exercises = StrengthExerciseSeedData.defaultExercises;
      expect(exercises.length, equals(19));
    });

    test('all exercises should have unique IDs', () {
      final exercises = StrengthExerciseSeedData.defaultExercises;
      final ids = exercises.map((e) => e.id).toList();
      final uniqueIds = ids.toSet();
      expect(uniqueIds.length, equals(ids.length));
    });

    test('all exercises should have names', () {
      final exercises = StrengthExerciseSeedData.defaultExercises;
      for (final exercise in exercises) {
        expect(exercise.name, isNotEmpty);
        expect(exercise.name.length, greaterThan(0));
      }
    });

    test('all exercises should have descriptions', () {
      final exercises = StrengthExerciseSeedData.defaultExercises;
      for (final exercise in exercises) {
        expect(exercise.description, isNotEmpty);
        expect(exercise.description.length, greaterThan(10));
      }
    });

    test('all exercises should have at least one primary muscle', () {
      final exercises = StrengthExerciseSeedData.defaultExercises;
      for (final exercise in exercises) {
        expect(exercise.primaryMuscles, isNotEmpty);
      }
    });

    test('all exercises should have equipment type', () {
      final exercises = StrengthExerciseSeedData.defaultExercises;
      for (final exercise in exercises) {
        expect(exercise.equipment, isNotNull);
      }
    });

    test('all exercises should have form cues', () {
      final exercises = StrengthExerciseSeedData.defaultExercises;
      for (final exercise in exercises) {
        expect(exercise.formCues, isNotEmpty);
        expect(exercise.formCues.length, greaterThan(20));
      }
    });

    test('all exercises should have difficulty level', () {
      final exercises = StrengthExerciseSeedData.defaultExercises;
      for (final exercise in exercises) {
        expect(exercise.difficulty, isNotNull);
      }
    });

    test('all exercises should have isCompound flag', () {
      final exercises = StrengthExerciseSeedData.defaultExercises;
      for (final exercise in exercises) {
        expect(exercise.isCompound, isNotNull);
      }
    });

    test('all exercises should have minimum age', () {
      final exercises = StrengthExerciseSeedData.defaultExercises;
      for (final exercise in exercises) {
        expect(exercise.minimumAge, greaterThanOrEqualTo(18));
      }
    });

    test('all exercises should have 50+ modification flag', () {
      final exercises = StrengthExerciseSeedData.defaultExercises;
      for (final exercise in exercises) {
        expect(exercise.requiresModification50Plus, isNotNull);
      }
    });

    test('exercises with 50+ modifications should have notes', () {
      final exercises = StrengthExerciseSeedData.defaultExercises;
      for (final exercise in exercises) {
        if (exercise.requiresModification50Plus) {
          expect(exercise.modification50PlusNotes, isNotEmpty);
        }
      }
    });
  });

  group('StrengthExerciseSeedData - Exercise Categories', () {
    test('should have compound movements', () {
      final exercises = StrengthExerciseSeedData.defaultExercises;
      final compounds = exercises.where((e) => e.isCompound).toList();
      expect(compounds.length, greaterThan(0));
    });

    test('should have isolation exercises', () {
      final exercises = StrengthExerciseSeedData.defaultExercises;
      final isolations = exercises.where((e) => !e.isCompound).toList();
      expect(isolations.length, greaterThan(0));
    });

    test('should have lower body exercises', () {
      final exercises = StrengthExerciseSeedData.defaultExercises;
      final lowerBody = exercises.where(
        (e) => e.primaryMuscles.contains(MuscleGroup.legs),
      );
      expect(lowerBody.length, greaterThan(0));
    });

    test('should have upper body exercises', () {
      final exercises = StrengthExerciseSeedData.defaultExercises;
      final upperBody = exercises.where(
        (e) => e.primaryMuscles.contains(MuscleGroup.chest) ||
            e.primaryMuscles.contains(MuscleGroup.back) ||
            e.primaryMuscles.contains(MuscleGroup.shoulders) ||
            e.primaryMuscles.contains(MuscleGroup.arms),
      );
      expect(upperBody.length, greaterThan(0));
    });

    test('should have core exercises', () {
      final exercises = StrengthExerciseSeedData.defaultExercises;
      final core = exercises.where(
        (e) => e.primaryMuscles.contains(MuscleGroup.core),
      );
      expect(core.length, greaterThan(0));
    });

    test('should have bodyweight exercises', () {
      final exercises = StrengthExerciseSeedData.defaultExercises;
      final bodyweight = exercises.where(
        (e) => e.equipment == EquipmentType.bodyweight,
      );
      expect(bodyweight.length, greaterThan(0));
    });

    test('should have dumbbell exercises', () {
      final exercises = StrengthExerciseSeedData.defaultExercises;
      final dumbbells = exercises.where(
        (e) => e.equipment == EquipmentType.dumbbells,
      );
      expect(dumbbells.length, greaterThan(0));
    });
  });

  group('StrengthExerciseSeedData - Age-Appropriate Programming', () {
    test('should have exercises suitable for beginners', () {
      final exercises = StrengthExerciseSeedData.defaultExercises;
      final beginners = exercises.where(
        (e) => e.difficulty == DifficultyLevel.beginner,
      );
      expect(beginners.length, greaterThan(0));
    });

    test('should have exercises for 50+ users', () {
      final exercises = StrengthExerciseSeedData.defaultExercises;
      final modifications50Plus = exercises.where(
        (e) => e.requiresModification50Plus,
      );
      expect(modifications50Plus.length, greaterThan(0));
    });

    test('compound movements should have 50+ modifications', () {
      final exercises = StrengthExerciseSeedData.defaultExercises;
      final compounds = exercises.where((e) => e.isCompound).toList();

      // Most compound movements should have 50+ modifications
      final withModifications = compounds
          .where((e) => e.requiresModification50Plus)
          .length;
      expect(withModifications, greaterThanOrEqualTo(compounds.length ~/ 2));
    });
  });

  group('StrengthExerciseSeedData - Exercise Quality', () {
    test('each exercise should have detailed form cues', () {
      final exercises = StrengthExerciseSeedData.defaultExercises;
      for (final exercise in exercises) {
        final cueList = exercise.formCues.split('.');
        expect(cueList.length, greaterThanOrEqualTo(2));
      }
    });

    test('primary muscles should match exercise type', () {
      final exercises = StrengthExerciseSeedData.defaultExercises;

      // Squat variants should have legs as primary
      final squats = exercises.where((e) => e.name.contains('Squat'));
      for (final squat in squats) {
        expect(squat.primaryMuscles, contains(MuscleGroup.legs));
      }

      // Pressing should have chest/shoulders as primary
      final presses = exercises.where((e) => e.name.contains('Press'));
      for (final press in presses) {
        expect(
          press.primaryMuscles.any((m) =>
              m == MuscleGroup.chest || m == MuscleGroup.shoulders),
          true,
        );
      }

      // Rowing should have back as primary
      final rows = exercises.where((e) => e.name.contains('Row'));
      for (final row in rows) {
        expect(row.primaryMuscles, contains(MuscleGroup.back));
      }
    });

    test('secondary muscles should not duplicate primary muscles', () {
      final exercises = StrengthExerciseSeedData.defaultExercises;
      for (final exercise in exercises) {
        for (final secondary in exercise.secondaryMuscles) {
          expect(exercise.primaryMuscles.contains(secondary), false);
        }
      }
    });
  });

  group('StrengthExerciseSeedData - Equipment Variety', () {
    test('should support multiple equipment types', () {
      final exercises = StrengthExerciseSeedData.defaultExercises;
      final equipmentTypes = exercises.map((e) => e.equipment).toSet();
      expect(equipmentTypes.length, greaterThan(1));
    });

    test('all equipment types should be valid', () {
      final exercises = StrengthExerciseSeedData.defaultExercises;
      final validEquipment = [
        EquipmentType.bodyweight,
        EquipmentType.dumbbells,
        EquipmentType.barbell,
        EquipmentType.kettlebell,
        EquipmentType.resistanceBand,
        EquipmentType.none,
      ];

      for (final exercise in exercises) {
        expect(validEquipment.contains(exercise.equipment), true);
      }
    });
  });

  group('StrengthExerciseSeedData - Beginner Progression', () {
    test('should support full-body beginner program', () {
      final exercises = StrengthExerciseSeedData.defaultExercises;
      final beginnerCompounds = exercises.where(
        (e) =>
            e.difficulty == DifficultyLevel.beginner &&
            e.isCompound &&
            e.equipment == EquipmentType.bodyweight,
      );

      // Should have at least: squat, push, pull, hinge, core
      expect(beginnerCompounds.length, greaterThanOrEqualTo(5));
    });

    test('should have clear progression paths', () {
      final exercises = StrengthExerciseSeedData.defaultExercises;

      // Push-up variations for progression
      final pushups = exercises.where((e) => e.name.contains('Push'));
      expect(pushups.length, greaterThan(0));

      // Squat variations
      final squats = exercises.where((e) => e.name.contains('Squat'));
      expect(squats.length, greaterThanOrEqualTo(2));

      // Row variations
      final rows = exercises.where((e) => e.name.contains('Row'));
      expect(rows.length, greaterThan(0));
    });
  });
}
