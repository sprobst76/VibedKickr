import 'package:flutter_test/flutter_test.dart';
import 'package:kickr_trainer/domain/entities/workout.dart';

void main() {
  group('PowerTarget', () {
    group('resolveWatts', () {
      test('absolute returns exact watts regardless of ftp', () {
        final target = PowerTarget.absolute(150);
        expect(target.resolveWatts(200), 150);
        expect(target.resolveWatts(300), 150);
      });

      test('ftpPercent calculates percentage of ftp', () {
        final target = PowerTarget.ftpPercent(75);
        expect(target.resolveWatts(200), 150);
      });

      test('ftpPercent of 100 returns ftp', () {
        final target = PowerTarget.ftpPercent(100);
        expect(target.resolveWatts(250), 250);
      });

      test('range returns average of min and max', () {
        final target = PowerTarget.range(100, 200);
        expect(target.resolveWatts(200), 150);
      });

      test('free returns 0', () {
        final target = PowerTarget.free();
        expect(target.resolveWatts(200), 0);
        expect(target.resolveWatts(0), 0);
      });
    });

    group('toJson / fromJson', () {
      test('roundtrip for absolute target', () {
        final original = PowerTarget.absolute(200);
        final json = original.toJson();
        final restored = PowerTarget.fromJson(json);
        expect(restored, equals(original));
      });

      test('roundtrip for ftpPercent target', () {
        final original = PowerTarget.ftpPercent(90);
        final json = original.toJson();
        final restored = PowerTarget.fromJson(json);
        expect(restored, equals(original));
      });

      test('roundtrip for range target', () {
        final original = PowerTarget.range(100, 200);
        final json = original.toJson();
        final restored = PowerTarget.fromJson(json);
        expect(restored, equals(original));
      });

      test('roundtrip for free target', () {
        final original = PowerTarget.free();
        final json = original.toJson();
        final restored = PowerTarget.fromJson(json);
        expect(restored, equals(original));
      });
    });

    group('equality', () {
      test('same absolute targets are equal', () {
        expect(PowerTarget.absolute(150), equals(PowerTarget.absolute(150)));
      });

      test('different absolute targets are not equal', () {
        expect(
          PowerTarget.absolute(150),
          isNot(equals(PowerTarget.absolute(200))),
        );
      });
    });
  });

  group('WorkoutInterval', () {
    WorkoutInterval createTestInterval() {
      return WorkoutInterval(
        name: 'Test Interval',
        duration: const Duration(minutes: 5),
        type: IntervalType.work,
        powerTarget: PowerTarget.ftpPercent(90),
        cadenceMin: 85,
        cadenceMax: 95,
        instructions: 'Push hard',
        targetHeartRate: 160,
        maxHeartRate: 180,
        monitorRecovery: true,
      );
    }

    test('creates with all fields', () {
      final interval = createTestInterval();
      expect(interval.name, 'Test Interval');
      expect(interval.duration, const Duration(minutes: 5));
      expect(interval.type, IntervalType.work);
      expect(interval.cadenceMin, 85);
      expect(interval.cadenceMax, 95);
      expect(interval.instructions, 'Push hard');
      expect(interval.targetHeartRate, 160);
      expect(interval.maxHeartRate, 180);
      expect(interval.monitorRecovery, true);
    });

    test('defaults monitorRecovery to false', () {
      final interval = WorkoutInterval(
        name: 'Simple',
        duration: const Duration(minutes: 3),
        type: IntervalType.warmup,
        powerTarget: PowerTarget.ftpPercent(50),
      );
      expect(interval.monitorRecovery, false);
    });

    group('toJson / fromJson', () {
      test('roundtrip preserves all fields', () {
        final original = createTestInterval();
        final json = original.toJson();
        final restored = WorkoutInterval.fromJson(json);
        expect(restored, equals(original));
      });

      test('roundtrip preserves duration in milliseconds', () {
        final original = WorkoutInterval(
          name: 'Short',
          duration: const Duration(seconds: 30),
          type: IntervalType.rest,
          powerTarget: PowerTarget.ftpPercent(40),
        );
        final json = original.toJson();
        expect(json['durationMs'], 30000);
        final restored = WorkoutInterval.fromJson(json);
        expect(restored.duration, const Duration(seconds: 30));
      });
    });

    group('copyWith', () {
      test('changes specified fields only', () {
        final original = createTestInterval();
        final modified = original.copyWith(
          name: 'Modified',
          duration: const Duration(minutes: 10),
        );
        expect(modified.name, 'Modified');
        expect(modified.duration, const Duration(minutes: 10));
        expect(modified.type, original.type);
        expect(modified.powerTarget, original.powerTarget);
        expect(modified.cadenceMin, original.cadenceMin);
        expect(modified.instructions, original.instructions);
      });

      test('returns equal object when no changes specified', () {
        final original = createTestInterval();
        final copy = original.copyWith();
        expect(copy, equals(original));
      });
    });
  });

  group('Workout', () {
    Workout createTestWorkout() {
      return Workout(
        id: 'test_workout',
        name: 'Test Workout',
        description: 'A test workout',
        type: WorkoutType.interval,
        intervals: [
          WorkoutInterval(
            name: 'Warmup',
            duration: const Duration(minutes: 5),
            type: IntervalType.warmup,
            powerTarget: PowerTarget.ftpPercent(50),
          ),
          WorkoutInterval(
            name: 'Work',
            duration: const Duration(minutes: 20),
            type: IntervalType.work,
            powerTarget: PowerTarget.ftpPercent(90),
          ),
          WorkoutInterval(
            name: 'Cooldown',
            duration: const Duration(minutes: 5),
            type: IntervalType.cooldown,
            powerTarget: PowerTarget.ftpPercent(40),
          ),
        ],
        createdAt: DateTime(2026, 1, 15),
        isCustom: true,
      );
    }

    group('totalDuration', () {
      test('sums all interval durations', () {
        final workout = createTestWorkout();
        expect(workout.totalDuration, const Duration(minutes: 30));
      });

      test('returns zero for empty intervals', () {
        const workout = Workout(
          id: 'empty',
          name: 'Empty',
          description: '',
          type: WorkoutType.freeRide,
          intervals: [],
        );
        expect(workout.totalDuration, Duration.zero);
      });
    });

    group('estimateTss', () {
      test('returns a non-negative value', () {
        final workout = createTestWorkout();
        final tss = workout.estimateTss(200);
        expect(tss, greaterThanOrEqualTo(0));
      });

      test('returns reasonable TSS for a 30 min workout', () {
        final workout = createTestWorkout();
        final tss = workout.estimateTss(200);
        // 30 min workout with mix of intensities should produce reasonable TSS
        expect(tss, greaterThan(0));
        expect(tss, lessThan(200));
      });

      test('higher FTP reduces TSS for same absolute power', () {
        final workout = Workout(
          id: 'abs_test',
          name: 'Absolute Test',
          description: '',
          type: WorkoutType.endurance,
          intervals: [
            WorkoutInterval(
              name: 'Work',
              duration: const Duration(minutes: 60),
              type: IntervalType.work,
              powerTarget: PowerTarget.absolute(200),
            ),
          ],
        );
        final tssLowFtp = workout.estimateTss(200);
        final tssHighFtp = workout.estimateTss(300);
        expect(tssHighFtp, lessThan(tssLowFtp));
      });
    });

    group('toJson / fromJson', () {
      test('roundtrip preserves all fields', () {
        final original = createTestWorkout();
        final json = original.toJson();
        final restored = Workout.fromJson(json);
        expect(restored.id, original.id);
        expect(restored.name, original.name);
        expect(restored.description, original.description);
        expect(restored.type, original.type);
        expect(restored.intervals.length, original.intervals.length);
        expect(restored.isCustom, original.isCustom);
        expect(restored.createdAt, original.createdAt);
      });

      test('handles null createdAt', () {
        const workout = Workout(
          id: 'no_date',
          name: 'No Date',
          description: '',
          type: WorkoutType.freeRide,
          intervals: [],
        );
        final json = workout.toJson();
        final restored = Workout.fromJson(json);
        expect(restored.createdAt, isNull);
      });
    });

    group('copyWith', () {
      test('changes specified fields only', () {
        final original = createTestWorkout();
        final modified = original.copyWith(
          name: 'Modified Workout',
          isCustom: false,
        );
        expect(modified.name, 'Modified Workout');
        expect(modified.isCustom, false);
        expect(modified.id, original.id);
        expect(modified.intervals, original.intervals);
      });
    });
  });

  group('PredefinedWorkouts', () {
    test('all returns exactly 5 workouts', () {
      expect(PredefinedWorkouts.all.length, 5);
    });

    test('all workouts have non-empty names', () {
      for (final workout in PredefinedWorkouts.all) {
        expect(workout.name, isNotEmpty);
      }
    });

    test('all workouts have non-empty ids', () {
      for (final workout in PredefinedWorkouts.all) {
        expect(workout.id, isNotEmpty);
      }
    });

    test('all workouts have at least one interval', () {
      for (final workout in PredefinedWorkouts.all) {
        expect(workout.intervals, isNotEmpty);
      }
    });

    test('all workouts start with a warmup interval', () {
      for (final workout in PredefinedWorkouts.all) {
        expect(workout.intervals.first.type, IntervalType.warmup);
      }
    });

    test('all workouts end with a cooldown interval', () {
      for (final workout in PredefinedWorkouts.all) {
        expect(workout.intervals.last.type, IntervalType.cooldown);
      }
    });

    test('all workouts contain at least one work or rest interval', () {
      for (final workout in PredefinedWorkouts.all) {
        final hasWorkOrRest = workout.intervals.any(
          (i) => i.type == IntervalType.work || i.type == IntervalType.rest,
        );
        expect(hasWorkOrRest, isTrue);
      }
    });

    test('all workouts have positive total duration', () {
      for (final workout in PredefinedWorkouts.all) {
        expect(workout.totalDuration, greaterThan(Duration.zero));
      }
    });

    test('all workout ids are unique', () {
      final ids = PredefinedWorkouts.all.map((w) => w.id).toSet();
      expect(ids.length, PredefinedWorkouts.all.length);
    });
  });
}
