import 'package:flutter_test/flutter_test.dart';
import 'package:kickr_trainer/domain/entities/strength_exercise.dart';
import 'package:kickr_trainer/domain/entities/strength_workout.dart';

void main() {
  group('LoadTarget', () {
    test('should create absolute weight LoadTarget', () {
      final target = LoadTarget.weight(50.0);
      expect(target.type, LoadTargetType.absolute);
      expect(target.weight, 50.0);
      expect(target.rpe, null);
    });

    test('should create RPE LoadTarget', () {
      final target = LoadTarget.rpe(7);
      expect(target.type, LoadTargetType.rpe);
      expect(target.rpe, 7);
      expect(target.weight, null);
    });

    test('should create bodyweight LoadTarget', () {
      final target = LoadTarget.bodyweight();
      expect(target.type, LoadTargetType.bodyweight);
      expect(target.bodyweightVariation, 'standard');
    });

    test('should create assisted bodyweight LoadTarget', () {
      final target = LoadTarget.bodyweight(variation: 'assisted');
      expect(target.type, LoadTargetType.bodyweight);
      expect(target.bodyweightVariation, 'assisted');
    });

    test('should create percentage LoadTarget', () {
      final target = LoadTarget.percentage(80, 100.0);
      expect(target.type, LoadTargetType.percentage);
      expect(target.percentage, 80);
      expect(target.weight, 80.0);
    });

    test('should resolve weight correctly', () {
      final target = LoadTarget.weight(50.0);
      expect(target.resolveWeight(), 50.0);
    });

    test('should resolve null weight for bodyweight', () {
      final target = LoadTarget.bodyweight();
      expect(target.resolveWeight(), null);
    });

    group('JSON serialization', () {
      test('should serialize absolute weight LoadTarget', () {
        final target = LoadTarget.weight(50.0);
        final json = target.toJson();
        expect(json['type'], 'absolute');
        expect(json['weight'], 50.0);
      });

      test('should deserialize absolute weight LoadTarget', () {
        final original = LoadTarget.weight(50.0);
        final json = original.toJson();
        final deserialized = LoadTarget.fromJson(json);
        expect(deserialized, original);
      });

      test('should serialize and deserialize RPE LoadTarget', () {
        final original = LoadTarget.rpe(7);
        final json = original.toJson();
        final deserialized = LoadTarget.fromJson(json);
        expect(deserialized, original);
      });

      test('should serialize and deserialize bodyweight LoadTarget', () {
        final original = LoadTarget.bodyweight(variation: 'assisted');
        final json = original.toJson();
        final deserialized = LoadTarget.fromJson(json);
        expect(deserialized, original);
      });
    });

    test('should be equal when type and values are same', () {
      final target1 = LoadTarget.weight(50.0);
      final target2 = LoadTarget.weight(50.0);
      expect(target1, target2);
    });

    test('should be different when values differ', () {
      final target1 = LoadTarget.weight(50.0);
      final target2 = LoadTarget.weight(60.0);
      expect(target1, isNot(target2));
    });
  });

  group('StrengthInterval', () {
    final testInterval = StrengthInterval(
      exerciseId: 'ex_squat',
      sets: 3,
      repsTarget: 10,
      repsMin: 8,
      repsMax: 12,
      loadTarget: LoadTarget.weight(50.0),
      restBetweenSets: const Duration(seconds: 90),
      tempo: '3-1-1',
      instructions: 'Keep chest up',
    );

    test('should create StrengthInterval with correct properties', () {
      expect(testInterval.exerciseId, 'ex_squat');
      expect(testInterval.sets, 3);
      expect(testInterval.repsTarget, 10);
      expect(testInterval.repsMin, 8);
      expect(testInterval.repsMax, 12);
      expect(testInterval.restBetweenSets.inSeconds, 90);
      expect(testInterval.tempo, '3-1-1');
    });

    test('should support rep ranges', () {
      expect(testInterval.repsMin, isNotNull);
      expect(testInterval.repsMax, isNotNull);
      expect(testInterval.repsMin! < testInterval.repsTarget, true);
      expect(testInterval.repsMax! > testInterval.repsTarget, true);
    });

    group('copyWith', () {
      test('should copy with modified sets', () {
        final modified = testInterval.copyWith(sets: 4);
        expect(modified.sets, 4);
        expect(modified.exerciseId, testInterval.exerciseId);
        expect(modified.repsTarget, testInterval.repsTarget);
      });

      test('should copy with modified load', () {
        final newLoad = LoadTarget.weight(60.0);
        final modified = testInterval.copyWith(loadTarget: newLoad);
        expect(modified.loadTarget, newLoad);
        expect(modified.sets, testInterval.sets);
      });
    });

    group('JSON serialization', () {
      test('should serialize to JSON', () {
        final json = testInterval.toJson();
        expect(json['exerciseId'], 'ex_squat');
        expect(json['sets'], 3);
        expect(json['repsTarget'], 10);
        expect(json['restBetweenSetsSecs'], 90);
      });

      test('should deserialize from JSON', () {
        final json = testInterval.toJson();
        final deserialized = StrengthInterval.fromJson(json);
        expect(deserialized.exerciseId, testInterval.exerciseId);
        expect(deserialized.sets, testInterval.sets);
        expect(deserialized.repsTarget, testInterval.repsTarget);
      });
    });

    test('should support different rest durations', () {
      final interval1 = testInterval;
      final interval2 = testInterval.copyWith(
        restBetweenSets: const Duration(seconds: 120),
      );
      expect(interval1.restBetweenSets.inSeconds, 90);
      expect(interval2.restBetweenSets.inSeconds, 120);
    });
  });

  group('StrengthWorkout', () {
    final testInterval = StrengthInterval(
      exerciseId: 'ex_squat',
      sets: 3,
      repsTarget: 10,
      loadTarget: LoadTarget.weight(50.0),
      restBetweenSets: const Duration(seconds: 90),
    );

    final testWorkout = StrengthWorkout(
      id: 'workout_beginner_fullbody',
      name: 'Beginner Full Body',
      description: 'Complete full body workout for beginners',
      intervals: [testInterval],
      type: WorkoutType.fullBody,
      estimatedDurationMinutes: 45,
      difficulty: DifficultyLevel.beginner,
      isCustom: false,
    );

    test('should create StrengthWorkout with correct properties', () {
      expect(testWorkout.id, 'workout_beginner_fullbody');
      expect(testWorkout.name, 'Beginner Full Body');
      expect(testWorkout.type, WorkoutType.fullBody);
      expect(testWorkout.estimatedDurationMinutes, 45);
      expect(testWorkout.difficulty, DifficultyLevel.beginner);
      expect(testWorkout.isCustom, false);
      expect(testWorkout.intervals.length, 1);
    });

    test('should calculate estimated total duration', () {
      final duration = testWorkout.estimatedTotalDuration;
      expect(duration.inMinutes, greaterThan(0));
    });

    test('should support multiple intervals', () {
      final interval2 = StrengthInterval(
        exerciseId: 'ex_pushup',
        sets: 3,
        repsTarget: 12,
        loadTarget: LoadTarget.bodyweight(),
        restBetweenSets: const Duration(seconds: 60),
      );

      final multiInterval = testWorkout.copyWith(
        intervals: [testInterval, interval2],
      );
      expect(multiInterval.intervals.length, 2);
    });

    test('should support different workout types', () {
      expect(WorkoutType.values.length, 5);
      expect(WorkoutType.values, contains(WorkoutType.fullBody));
      expect(WorkoutType.values, contains(WorkoutType.upperBody));
      expect(WorkoutType.values, contains(WorkoutType.lowerBody));
      expect(WorkoutType.values, contains(WorkoutType.pushPull));
      expect(WorkoutType.values, contains(WorkoutType.core));
    });

    group('copyWith', () {
      test('should copy with modified name', () {
        final modified = testWorkout.copyWith(name: 'Advanced Full Body');
        expect(modified.name, 'Advanced Full Body');
        expect(modified.id, testWorkout.id);
      });

      test('should preserve other properties when copying', () {
        final modified = testWorkout.copyWith(difficulty: DifficultyLevel.advanced);
        expect(modified.difficulty, DifficultyLevel.advanced);
        expect(modified.name, testWorkout.name);
      });
    });

    group('JSON serialization', () {
      test('should serialize to JSON', () {
        final json = testWorkout.toJson();
        expect(json['id'], 'workout_beginner_fullbody');
        expect(json['name'], 'Beginner Full Body');
        expect(json['type'], 'fullBody');
        expect(json['difficulty'], 'beginner');
        expect(json['isCustom'], false);
      });

      test('should deserialize from JSON', () {
        final json = testWorkout.toJson();
        final deserialized = StrengthWorkout.fromJson(json);
        expect(deserialized.id, testWorkout.id);
        expect(deserialized.name, testWorkout.name);
        expect(deserialized.type, testWorkout.type);
        expect(deserialized.intervals.length, testWorkout.intervals.length);
      });
    });

    test('should support custom workouts', () {
      final custom = testWorkout.copyWith(isCustom: true);
      expect(custom.isCustom, true);
    });

    test('should track creation timestamp', () {
      final now = DateTime.now();
      final workout = testWorkout.copyWith(createdAt: now);
      expect(workout.createdAt, now);
    });
  });
}
