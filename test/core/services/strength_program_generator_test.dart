import 'package:flutter_test/flutter_test.dart';
import 'package:kickr_trainer/core/services/strength_program_generator.dart';
import 'package:kickr_trainer/domain/entities/strength_exercise.dart';
import 'package:kickr_trainer/domain/entities/strength_workout.dart';

void main() {
  group('StrengthProgramGenerator - Beginner Full Body', () {
    test('generateBeginnerFullBody should create valid workout', () {
      final workout = StrengthProgramGenerator.generateBeginnerFullBody(
        age: 55,
        equipment: EquipmentType.bodyweight,
      );

      expect(workout.name, isNotEmpty);
      expect(workout.description, isNotEmpty);
      expect(workout.intervals, isNotEmpty);
      expect(workout.type, equals(WorkoutType.fullBody));
      expect(workout.difficulty, equals(DifficultyLevel.beginner));
    });

    test('generateBeginnerFullBody should have 5 intervals for full body', () {
      final workout = StrengthProgramGenerator.generateBeginnerFullBody(
        age: 55,
        equipment: EquipmentType.bodyweight,
      );

      expect(workout.intervals.length, equals(5));
    });

    test('generateBeginnerFullBody with bodyweight equipment', () {
      final workout = StrengthProgramGenerator.generateBeginnerFullBody(
        age: 55,
        equipment: EquipmentType.bodyweight,
      );

      // Should have bodyweight-only movements
      expect(workout.intervals.first.exerciseId, equals('ex_bodyweight_squat'));
      expect(workout.intervals[1].exerciseId, equals('ex_pushup'));
    });

    test('generateBeginnerFullBody with dumbbell equipment', () {
      final workout = StrengthProgramGenerator.generateBeginnerFullBody(
        age: 55,
        equipment: EquipmentType.dumbbells,
      );

      // Should have dumbbell movements
      expect(workout.intervals.first.exerciseId, equals('ex_goblet_squat'));
    });

    test('generateBeginnerFullBody should set appropriate rest periods', () {
      final workout = StrengthProgramGenerator.generateBeginnerFullBody(
        age: 55,
        equipment: EquipmentType.bodyweight,
      );

      // Rest should be 60-120 seconds
      for (final interval in workout.intervals) {
        expect(
          interval.restBetweenSets.inSeconds,
          allOf(
            greaterThanOrEqualTo(60),
            lessThanOrEqualTo(120),
          ),
        );
      }
    });

    test('generateBeginnerFullBody should estimate 45 minute duration', () {
      final workout = StrengthProgramGenerator.generateBeginnerFullBody(
        age: 55,
        equipment: EquipmentType.bodyweight,
      );

      expect(workout.estimatedDurationMinutes, equals(45));
    });

    test('generateBeginnerFullBody with different equipment types', () {
      final equipmentTypes = [
        EquipmentType.bodyweight,
        EquipmentType.dumbbells,
        EquipmentType.barbell,
        EquipmentType.kettlebell,
        EquipmentType.resistanceBand,
      ];

      for (final equipment in equipmentTypes) {
        final workout = StrengthProgramGenerator.generateBeginnerFullBody(
          age: 55,
          equipment: equipment,
        );

        expect(workout.intervals, isNotEmpty);
        expect(workout.type, equals(WorkoutType.fullBody));
      }
    });
  });

  group('StrengthProgramGenerator - Weekly Program', () {
    test('generateWeeklyProgram50Plus should create 2 workouts', () {
      final programs = StrengthProgramGenerator.generateWeeklyProgram50Plus(
        age: 55,
        equipment: EquipmentType.bodyweight,
      );

      expect(programs.length, equals(2));
    });

    test('generateWeeklyProgram50Plus workouts should have similar structure', () {
      final programs = StrengthProgramGenerator.generateWeeklyProgram50Plus(
        age: 55,
        equipment: EquipmentType.bodyweight,
      );

      expect(programs.first.intervals.length, equals(programs.last.intervals.length));
      expect(programs.first.type, equals(programs.last.type));
      expect(programs.first.difficulty, equals(programs.last.difficulty));
    });
  });

  group('StrengthProgramGenerator - Progressive Programs', () {
    test('generateProgressiveProgram for beginners', () {
      final programs = StrengthProgramGenerator.generateProgressiveProgram(
        age: 55,
        currentLevel: DifficultyLevel.beginner,
        equipment: EquipmentType.bodyweight,
      );

      expect(programs, isNotEmpty);
      expect(programs.first.difficulty, equals(DifficultyLevel.beginner));
    });

    test('generateProgressiveProgram for different ages', () {
      final ages = [40, 55, 65, 75];

      for (final age in ages) {
        final programs = StrengthProgramGenerator.generateProgressiveProgram(
          age: age,
          currentLevel: DifficultyLevel.beginner,
          equipment: EquipmentType.bodyweight,
        );

        expect(programs, isNotEmpty);
      }
    });
  });

  group('StrengthProgramGenerator - Modification Notes', () {
    test('getModificationNotes for age <50', () {
      final notes = StrengthProgramGenerator.getModificationNotes(40);
      expect(notes, contains('Standard'));
    });

    test('getModificationNotes for age 50-60', () {
      final notes = StrengthProgramGenerator.getModificationNotes(55);
      expect(notes, contains('50-60'));
    });

    test('getModificationNotes for age 60-70', () {
      final notes = StrengthProgramGenerator.getModificationNotes(65);
      expect(notes, contains('60-70'));
    });

    test('getModificationNotes for age 70+', () {
      final notes = StrengthProgramGenerator.getModificationNotes(75);
      expect(notes, contains('70+'));
    });
  });

  group('StrengthProgramGenerator - Evidence-Based Principles', () {
    test('intervals should include tempo recommendations', () {
      final workout = StrengthProgramGenerator.generateBeginnerFullBody(
        age: 55,
        equipment: EquipmentType.bodyweight,
      );

      // Should have tempo for controlled movement
      final intervalsWithTempo =
          workout.intervals.where((i) => i.tempo != null).length;
      expect(intervalsWithTempo, greaterThan(0));
    });

    test('sets should be 2-3 for 50+', () {
      final workout = StrengthProgramGenerator.generateBeginnerFullBody(
        age: 55,
        equipment: EquipmentType.bodyweight,
      );

      for (final interval in workout.intervals) {
        expect(
          interval.sets,
          allOf(
            greaterThanOrEqualTo(2),
            lessThanOrEqualTo(3),
          ),
        );
      }
    });
  });
}
