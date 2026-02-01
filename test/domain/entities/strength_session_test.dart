import 'package:flutter_test/flutter_test.dart';
import 'package:kickr_trainer/domain/entities/strength_exercise.dart';
import 'package:kickr_trainer/domain/entities/strength_session.dart';

void main() {
  group('StrengthSetRecord', () {
    final testSet = StrengthSetRecord(
      setNumber: 1,
      repsCompleted: 10,
      weightUsed: 50.0,
      rpe: 7,
      timestamp: DateTime(2026, 2, 1, 10, 0),
      restAfter: const Duration(seconds: 90),
    );

    test('should create StrengthSetRecord with correct properties', () {
      expect(testSet.setNumber, 1);
      expect(testSet.repsCompleted, 10);
      expect(testSet.weightUsed, 50.0);
      expect(testSet.rpe, 7);
      expect(testSet.restAfter?.inSeconds, 90);
    });

    test('should support optional weight and RPE', () {
      final setNoWeight = StrengthSetRecord(
        setNumber: 1,
        repsCompleted: 10,
        timestamp: DateTime.now(),
      );
      expect(setNoWeight.weightUsed, null);
      expect(setNoWeight.rpe, null);
    });

    group('JSON serialization', () {
      test('should serialize to JSON', () {
        final json = testSet.toJson();
        expect(json['setNumber'], 1);
        expect(json['repsCompleted'], 10);
        expect(json['weightUsed'], 50.0);
        expect(json['rpe'], 7);
        expect(json['restAfterSecs'], 90);
      });

      test('should deserialize from JSON', () {
        final json = testSet.toJson();
        final deserialized = StrengthSetRecord.fromJson(json);
        expect(deserialized.setNumber, testSet.setNumber);
        expect(deserialized.repsCompleted, testSet.repsCompleted);
        expect(deserialized.weightUsed, testSet.weightUsed);
        expect(deserialized.rpe, testSet.rpe);
      });
    });
  });

  group('StrengthExerciseRecord', () {
    final set1 = StrengthSetRecord(
      setNumber: 1,
      repsCompleted: 10,
      weightUsed: 50.0,
      rpe: 6,
      timestamp: DateTime.now(),
    );
    final set2 = StrengthSetRecord(
      setNumber: 2,
      repsCompleted: 10,
      weightUsed: 50.0,
      rpe: 7,
      timestamp: DateTime.now(),
    );
    final set3 = StrengthSetRecord(
      setNumber: 3,
      repsCompleted: 8,
      weightUsed: 50.0,
      rpe: 8,
      timestamp: DateTime.now(),
    );

    final testExRecord = StrengthExerciseRecord(
      exerciseId: 'ex_squat',
      exerciseName: 'Bodyweight Squat',
      sets: [set1, set2, set3],
    );

    test('should create StrengthExerciseRecord with correct properties', () {
      expect(testExRecord.exerciseId, 'ex_squat');
      expect(testExRecord.exerciseName, 'Bodyweight Squat');
      expect(testExRecord.sets.length, 3);
    });

    test('should calculate average weight', () {
      final avgWeight = testExRecord.avgWeight;
      expect(avgWeight, 50.0);
    });

    test('should return null average weight when no weights recorded', () {
      final noWeightSet = StrengthSetRecord(
        setNumber: 1,
        repsCompleted: 10,
        timestamp: DateTime.now(),
      );
      final record = StrengthExerciseRecord(
        exerciseId: 'ex_pullup',
        exerciseName: 'Pull Up',
        sets: [noWeightSet],
      );
      expect(record.avgWeight, null);
    });

    test('should calculate total volume', () {
      // 10*50 + 10*50 + 8*50 = 500 + 500 + 400 = 1400
      final volume = testExRecord.totalVolume;
      expect(volume, 1400.0);
    });

    test('should calculate average RPE', () {
      final avgRpe = testExRecord.avgRpe;
      expect(avgRpe, 7); // (6 + 7 + 8) / 3 = 7
    });

    test('should return null average RPE when no RPE recorded', () {
      final noRpeSet = StrengthSetRecord(
        setNumber: 1,
        repsCompleted: 10,
        weightUsed: 50.0,
        timestamp: DateTime.now(),
      );
      final record = StrengthExerciseRecord(
        exerciseId: 'ex_test',
        exerciseName: 'Test Exercise',
        sets: [noRpeSet],
      );
      expect(record.avgRpe, null);
    });

    group('JSON serialization', () {
      test('should serialize to JSON', () {
        final json = testExRecord.toJson();
        expect(json['exerciseId'], 'ex_squat');
        expect(json['exerciseName'], 'Bodyweight Squat');
        expect((json['sets'] as List).length, 3);
      });

      test('should deserialize from JSON', () {
        final json = testExRecord.toJson();
        final deserialized = StrengthExerciseRecord.fromJson(json);
        expect(deserialized.exerciseId, testExRecord.exerciseId);
        expect(deserialized.exerciseName, testExRecord.exerciseName);
        expect(deserialized.sets.length, testExRecord.sets.length);
      });
    });
  });

  group('StrengthSessionStats', () {
    final testStats = StrengthSessionStats(
      duration: const Duration(minutes: 45),
      totalSets: 9,
      totalReps: 90,
      totalVolume: 4500.0,
      avgRpe: 7,
      exercisesCompleted: 3,
      muscleGroupWork: {
        MuscleGroup.legs: 2000,
        MuscleGroup.core: 1500,
        MuscleGroup.back: 1000,
      },
    );

    test('should create StrengthSessionStats with correct properties', () {
      expect(testStats.duration.inMinutes, 45);
      expect(testStats.totalSets, 9);
      expect(testStats.totalReps, 90);
      expect(testStats.totalVolume, 4500.0);
      expect(testStats.avgRpe, 7);
      expect(testStats.exercisesCompleted, 3);
      expect(testStats.muscleGroupWork.length, 3);
    });

    test('should track volume by muscle group', () {
      expect(testStats.muscleGroupWork[MuscleGroup.legs], 2000);
      expect(testStats.muscleGroupWork[MuscleGroup.core], 1500);
      expect(testStats.muscleGroupWork[MuscleGroup.back], 1000);
    });

    group('JSON serialization', () {
      test('should serialize to JSON', () {
        final json = testStats.toJson();
        expect(json['durationSecs'], 2700);
        expect(json['totalSets'], 9);
        expect(json['totalReps'], 90);
        expect(json['totalVolume'], 4500.0);
        expect(json['avgRpe'], 7);
      });

      test('should deserialize from JSON', () {
        final json = testStats.toJson();
        final deserialized = StrengthSessionStats.fromJson(json);
        expect(deserialized.duration, testStats.duration);
        expect(deserialized.totalSets, testStats.totalSets);
        expect(deserialized.totalVolume, testStats.totalVolume);
      });
    });
  });

  group('StrengthSession', () {
    final set1 = StrengthSetRecord(
      setNumber: 1,
      repsCompleted: 10,
      weightUsed: 50.0,
      rpe: 7,
      timestamp: DateTime(2026, 2, 1, 10, 0),
    );
    final exRecord = StrengthExerciseRecord(
      exerciseId: 'ex_squat',
      exerciseName: 'Squat',
      sets: [set1],
    );

    final testSession = StrengthSession(
      id: 'session_001',
      startTime: DateTime(2026, 2, 1, 10, 0),
      endTime: DateTime(2026, 2, 1, 10, 45),
      workoutId: 'workout_001',
      exercises: [exRecord],
      notes: 'Good session',
    );

    test('should create StrengthSession with correct properties', () {
      expect(testSession.id, 'session_001');
      expect(testSession.workoutId, 'workout_001');
      expect(testSession.exercises.length, 1);
      expect(testSession.notes, 'Good session');
    });

    test('should calculate duration from start and end time', () {
      expect(testSession.duration.inMinutes, 45);
    });

    test('should calculate duration from now if endTime is null', () {
      final now = DateTime.now();
      final sessionWithoutEnd = testSession.copyWith(endTime: null);
      final duration = sessionWithoutEnd.duration;
      expect(duration.inSeconds, greaterThan(0));
    });

    test('should calculate total volume from exercises', () {
      final volume = testSession.totalVolume;
      expect(volume, greaterThan(0));
    });

    test('should calculate average RPE', () {
      final avgRpe = testSession.avgRpe;
      expect(avgRpe, 7);
    });

    test('should support multiple exercises', () {
      final set2 = StrengthSetRecord(
        setNumber: 1,
        repsCompleted: 12,
        weightUsed: 40.0,
        rpe: 6,
        timestamp: DateTime(2026, 2, 1, 10, 20),
      );
      final exRecord2 = StrengthExerciseRecord(
        exerciseId: 'ex_pushup',
        exerciseName: 'Push Up',
        sets: [set2],
      );

      final multiExSession = testSession.copyWith(
        exercises: [testSession.exercises[0], exRecord2],
      );
      expect(multiExSession.exercises.length, 2);
    });

    group('copyWith', () {
      test('should copy with modified notes', () {
        final modified = testSession.copyWith(notes: 'Great session!');
        expect(modified.notes, 'Great session!');
        expect(modified.id, testSession.id);
        expect(modified.workoutId, testSession.workoutId);
      });

      test('should copy with modified exercises', () {
        final newSet = StrengthSetRecord(
          setNumber: 2,
          repsCompleted: 8,
          timestamp: DateTime.now(),
        );
        final newExRecord = StrengthExerciseRecord(
          exerciseId: 'ex_deadlift',
          exerciseName: 'Deadlift',
          sets: [newSet],
        );
        final modified = testSession.copyWith(exercises: [newExRecord]);
        expect(modified.exercises.length, 1);
        expect(modified.exercises[0].exerciseId, 'ex_deadlift');
      });
    });

    group('JSON serialization', () {
      test('should serialize to JSON', () {
        final json = testSession.toJson();
        expect(json['id'], 'session_001');
        expect(json['workoutId'], 'workout_001');
        expect((json['exercises'] as List).length, 1);
        expect(json['notes'], 'Good session');
      });

      test('should deserialize from JSON', () {
        final json = testSession.toJson();
        final deserialized = StrengthSession.fromJson(json);
        expect(deserialized.id, testSession.id);
        expect(deserialized.workoutId, testSession.workoutId);
        expect(deserialized.exercises.length, testSession.exercises.length);
      });

      test('should handle session without stats', () {
        expect(testSession.stats, null);
        final json = testSession.toJson();
        final deserialized = StrengthSession.fromJson(json);
        expect(deserialized.stats, null);
      });

      test('should handle session with stats', () {
        final stats = StrengthSessionStats(
          duration: const Duration(minutes: 45),
          totalSets: 3,
          totalReps: 30,
          totalVolume: 1500.0,
          avgRpe: 7,
          exercisesCompleted: 1,
          muscleGroupWork: {MuscleGroup.legs: 1500},
        );
        final sessionWithStats = testSession.copyWith(stats: stats);
        final json = sessionWithStats.toJson();
        final deserialized = StrengthSession.fromJson(json);
        expect(deserialized.stats, isNotNull);
        expect(deserialized.stats!.totalVolume, 1500.0);
      });
    });

    test('should track workout ID relationship', () {
      expect(testSession.workoutId, 'workout_001');
      // Verify that when copying without specifying workoutId, it preserves the original
      final sameTechnically = testSession.copyWith(notes: 'Updated');
      expect(sameTechnically.workoutId, 'workout_001');
    });
  });
}
