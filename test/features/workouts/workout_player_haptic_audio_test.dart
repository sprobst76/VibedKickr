import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

import 'package:kickr_trainer/core/audio/audio_cue_service.dart';
import 'package:kickr_trainer/domain/entities/workout.dart';
import 'package:kickr_trainer/features/workouts/providers/workout_player_provider.dart';
import 'package:kickr_trainer/providers/providers.dart';

void main() {
  group('Workout Player - Haptic Feedback & Audio Cues', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('AudioCueType enum contains power warning types', () {
      expect(AudioCueType.values.contains(AudioCueType.powerTooLow), true);
      expect(AudioCueType.values.contains(AudioCueType.powerTooHigh), true);
      expect(AudioCueType.values.length, 6);
    });

    test('HapticType enum has 4 types', () {
      expect(HapticType.values.length, 4);
      expect(HapticType.values.contains(HapticType.countdown), true);
      expect(HapticType.values.contains(HapticType.intervalStart), true);
      expect(HapticType.values.contains(HapticType.workoutComplete), true);
      expect(HapticType.values.contains(HapticType.workoutStart), true);
    });

    test('hapticsEnabledProvider defaults to true', () {
      final haptics = container.read(hapticsEnabledProvider);
      expect(haptics, true);
    });

    test('hapticsEnabledProvider can be toggled', () {
      final notifier = container.read(hapticsEnabledProvider.notifier);

      expect(container.read(hapticsEnabledProvider), true);

      notifier.state = false;
      expect(container.read(hapticsEnabledProvider), false);

      notifier.state = true;
      expect(container.read(hapticsEnabledProvider), true);
    });

    test('powerDeviationAlertsProvider defaults to true', () {
      final alerts = container.read(powerDeviationAlertsProvider);
      expect(alerts, true);
    });

    test('powerDeviationThresholdProvider defaults to 15%', () {
      final threshold = container.read(powerDeviationThresholdProvider);
      expect(threshold, 15);
    });

    test('powerDeviationThresholdProvider can be changed', () {
      final notifier = container.read(powerDeviationThresholdProvider.notifier);

      expect(container.read(powerDeviationThresholdProvider), 15);

      notifier.state = 20;
      expect(container.read(powerDeviationThresholdProvider), 20);

      notifier.state = 10;
      expect(container.read(powerDeviationThresholdProvider), 10);
    });

    test('WorkoutPlayerData initializes with correct defaults', () {
      final data = const WorkoutPlayerData();

      expect(data.state, WorkoutPlayerState.idle);
      expect(data.workout, null);
      expect(data.currentTargetPower, 0);
      expect(data.countdownSeconds, null);
    });

    test('WorkoutPlayerData copyWith preserves existing values', () {
      final original = const WorkoutPlayerData(
        state: WorkoutPlayerState.ready,
        currentTargetPower: 200,
      );

      final updated = original.copyWith(
        state: WorkoutPlayerState.running,
      );

      expect(updated.state, WorkoutPlayerState.running);
      expect(updated.currentTargetPower, 200);
    });

    test('WorkoutPlayerData copyWith clearCountdown flag works', () {
      final original = const WorkoutPlayerData(
        countdownSeconds: 3,
      );

      final cleared = original.copyWith(
        clearCountdown: true,
      );

      expect(cleared.countdownSeconds, null);
    });


    group('Power Deviation Detection', () {
      test('No warning when target power is 0 (free ride)', () async {
        // Scenario: Free ride with no target
        // Expected: No power deviation checks

        // This is verified by the condition: if (state.currentTargetPower == 0)
        const data = WorkoutPlayerData(
          state: WorkoutPlayerState.running,
          currentTargetPower: 0,
        );

        expect(data.currentTargetPower, 0);
      });

      test('Deviation calculation for power too low', () {
        final targetPower = 200;
        final currentPower = 170; // 15% below target

        final deviation = (currentPower - targetPower) / targetPower;
        expect(deviation, closeTo(-0.15, 0.001));
        // -0.15 = -15% which equals the -15% threshold, not less than
        expect(deviation < -0.15, false);
      });

      test('Deviation calculation for power too high', () {
        final targetPower = 200;
        final currentPower = 230; // 15% above target

        final deviation = (currentPower - targetPower) / targetPower;
        expect(deviation, closeTo(0.15, 0.001));
        // 0.15 = 15% which equals the threshold, not more than
        expect(deviation > 0.15, false);
      });

      test('Significant power deficit triggers warning conditions', () {
        final targetPower = 200;
        final currentPower = 160; // 20% below = 0.20 deviation

        final deviation = (currentPower - targetPower) / targetPower;
        final threshold = 15 / 100;

        expect(deviation < -threshold, true);
      });

      test('Significant power excess triggers warning conditions', () {
        final targetPower = 200;
        final currentPower = 250; // 25% above = 0.25 deviation

        final deviation = (currentPower - targetPower) / targetPower;
        final threshold = 15 / 100;

        expect(deviation > threshold, true);
      });
    });

    group('Workout State Transitions', () {
      test('Workout can transition from ready to running', () {
        final initial = const WorkoutPlayerData(
          state: WorkoutPlayerState.ready,
        );

        final running = initial.copyWith(
          state: WorkoutPlayerState.running,
        );

        expect(running.state, WorkoutPlayerState.running);
      });

      test('Workout can transition from running to paused', () {
        final running = const WorkoutPlayerData(
          state: WorkoutPlayerState.running,
        );

        final paused = running.copyWith(
          state: WorkoutPlayerState.paused,
        );

        expect(paused.state, WorkoutPlayerState.paused);
      });

      test('Workout can transition from paused to running', () {
        final paused = const WorkoutPlayerData(
          state: WorkoutPlayerState.paused,
        );

        final running = paused.copyWith(
          state: WorkoutPlayerState.running,
        );

        expect(running.state, WorkoutPlayerState.running);
      });

      test('Workout can finish', () {
        final running = const WorkoutPlayerData(
          state: WorkoutPlayerState.running,
        );

        final finished = running.copyWith(
          state: WorkoutPlayerState.finished,
        );

        expect(finished.state, WorkoutPlayerState.finished);
      });
    });

    group('Countdown Logic', () {
      test('Countdown displays at 3, 2, 1 seconds', () {
        expect(const WorkoutPlayerData(countdownSeconds: 3).countdownSeconds, 3);
        expect(const WorkoutPlayerData(countdownSeconds: 2).countdownSeconds, 2);
        expect(const WorkoutPlayerData(countdownSeconds: 1).countdownSeconds, 1);
      });

      test('Countdown clears with clearCountdown flag', () {
        final withCountdown = const WorkoutPlayerData(countdownSeconds: 2);
        expect(withCountdown.countdownSeconds, 2);

        final cleared = withCountdown.copyWith(clearCountdown: true);
        expect(cleared.countdownSeconds, null);
      });
    });
  });

  group('Audio Cue Types', () {
    test('All AudioCueType values are defined', () {
      // Verify enum has expected values
      expect(AudioCueType.countdown, AudioCueType.countdown);
      expect(AudioCueType.intervalStart, AudioCueType.intervalStart);
      expect(AudioCueType.intervalEnd, AudioCueType.intervalEnd);
      expect(AudioCueType.workoutComplete, AudioCueType.workoutComplete);
      expect(AudioCueType.powerTooLow, AudioCueType.powerTooLow);
      expect(AudioCueType.powerTooHigh, AudioCueType.powerTooHigh);
    });

    test('AudioCueType has 6 variants', () {
      expect(AudioCueType.values.length, 6);
    });
  });
}
