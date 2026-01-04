import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/workout.dart';
import '../../../domain/entities/training_session.dart';
import '../../../providers/providers.dart';

enum WorkoutPlayerState {
  idle,
  ready,
  running,
  paused,
  finished,
}

class WorkoutPlayerData {
  final WorkoutPlayerState state;
  final Workout? workout;
  final int currentIntervalIndex;
  final Duration intervalElapsed;
  final Duration totalElapsed;
  final int currentTargetPower;

  const WorkoutPlayerData({
    this.state = WorkoutPlayerState.idle,
    this.workout,
    this.currentIntervalIndex = 0,
    this.intervalElapsed = Duration.zero,
    this.totalElapsed = Duration.zero,
    this.currentTargetPower = 0,
  });

  WorkoutInterval? get currentInterval {
    if (workout == null || currentIntervalIndex >= workout!.intervals.length) {
      return null;
    }
    return workout!.intervals[currentIntervalIndex];
  }

  WorkoutInterval? get nextInterval {
    if (workout == null || currentIntervalIndex + 1 >= workout!.intervals.length) {
      return null;
    }
    return workout!.intervals[currentIntervalIndex + 1];
  }

  double get intervalProgress {
    final interval = currentInterval;
    if (interval == null) return 0;
    return intervalElapsed.inMilliseconds / interval.duration.inMilliseconds;
  }

  Duration get intervalRemaining {
    final interval = currentInterval;
    if (interval == null) return Duration.zero;
    final remaining = interval.duration - intervalElapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  WorkoutPlayerData copyWith({
    WorkoutPlayerState? state,
    Workout? workout,
    int? currentIntervalIndex,
    Duration? intervalElapsed,
    Duration? totalElapsed,
    int? currentTargetPower,
  }) {
    return WorkoutPlayerData(
      state: state ?? this.state,
      workout: workout ?? this.workout,
      currentIntervalIndex: currentIntervalIndex ?? this.currentIntervalIndex,
      intervalElapsed: intervalElapsed ?? this.intervalElapsed,
      totalElapsed: totalElapsed ?? this.totalElapsed,
      currentTargetPower: currentTargetPower ?? this.currentTargetPower,
    );
  }
}

final workoutPlayerProvider =
    StateNotifierProvider<WorkoutPlayerNotifier, WorkoutPlayerData>((ref) {
  final notifier = WorkoutPlayerNotifier(ref);
  ref.onDispose(() => notifier.dispose());
  return notifier;
});

class WorkoutPlayerNotifier extends StateNotifier<WorkoutPlayerData> {
  final Ref _ref;
  Timer? _timer;
  DateTime? _intervalStartTime;
  DateTime? _sessionStartTime;

  WorkoutPlayerNotifier(this._ref) : super(const WorkoutPlayerData());

  void loadWorkout(Workout workout) {
    state = WorkoutPlayerData(
      state: WorkoutPlayerState.ready,
      workout: workout,
      currentIntervalIndex: 0,
    );
  }

  void start() {
    if (state.workout == null && state.state != WorkoutPlayerState.ready) {
      // Free Ride
      state = state.copyWith(state: WorkoutPlayerState.running);
      _startSession(SessionType.freeRide);
      _startTimer();
      return;
    }

    if (state.state != WorkoutPlayerState.ready) return;

    final ftp = _ref.read(athleteProfileProvider).ftp;
    final interval = state.currentInterval;
    final targetPower = interval?.powerTarget.resolveWatts(ftp) ?? 0;

    state = state.copyWith(
      state: WorkoutPlayerState.running,
      intervalElapsed: Duration.zero,
      currentTargetPower: targetPower,
    );

    _intervalStartTime = DateTime.now();
    _sessionStartTime = DateTime.now();

    // Session starten
    _startSession(SessionType.workout, workoutId: state.workout?.id);

    // Trainer steuern
    _setTrainerPower(targetPower);

    // Timer starten
    _startTimer();
  }

  void pause() {
    if (state.state != WorkoutPlayerState.running) return;

    _timer?.cancel();
    _ref.read(activeSessionProvider.notifier).pauseSession();

    state = state.copyWith(state: WorkoutPlayerState.paused);
  }

  void resume() {
    if (state.state != WorkoutPlayerState.paused) return;

    _ref.read(activeSessionProvider.notifier).resumeSession();
    _intervalStartTime = DateTime.now().subtract(state.intervalElapsed);

    state = state.copyWith(state: WorkoutPlayerState.running);
    _startTimer();
  }

  void stop() {
    _timer?.cancel();
    state = state.copyWith(state: WorkoutPlayerState.finished);
  }

  void skipInterval() {
    if (state.state != WorkoutPlayerState.running) return;
    _nextInterval();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      _tick();
    });
  }

  void _tick() {
    if (state.state != WorkoutPlayerState.running) return;

    // Update elapsed time
    final now = DateTime.now();
    final intervalElapsed = now.difference(_intervalStartTime ?? now);
    final totalElapsed = now.difference(_sessionStartTime ?? now);

    state = state.copyWith(
      intervalElapsed: intervalElapsed,
      totalElapsed: totalElapsed,
    );

    // Update target power in live data
    _ref.read(liveTrainingDataProvider.notifier).setTargetPower(
          state.currentTargetPower,
        );

    // Check if interval is complete
    final interval = state.currentInterval;
    if (interval != null && intervalElapsed >= interval.duration) {
      _nextInterval();
    }
  }

  void _nextInterval() {
    final nextIndex = state.currentIntervalIndex + 1;

    if (state.workout == null || nextIndex >= state.workout!.intervals.length) {
      // Workout complete
      _timer?.cancel();
      state = state.copyWith(state: WorkoutPlayerState.finished);
      return;
    }

    final ftp = _ref.read(athleteProfileProvider).ftp;
    final nextInterval = state.workout!.intervals[nextIndex];
    final targetPower = nextInterval.powerTarget.resolveWatts(ftp);

    _intervalStartTime = DateTime.now();

    state = state.copyWith(
      currentIntervalIndex: nextIndex,
      intervalElapsed: Duration.zero,
      currentTargetPower: targetPower,
    );

    // Trainer steuern
    _setTrainerPower(targetPower);

    // TODO: Audio Cue abspielen
  }

  void _startSession(SessionType type, {String? workoutId}) {
    _ref.read(activeSessionProvider.notifier).startSession(
          type: type,
          workoutId: workoutId,
        );
  }

  void _setTrainerPower(int watts) {
    final bleManager = _ref.read(bleManagerProvider);
    final ftmsService = bleManager.ftmsService;

    if (ftmsService != null && watts > 0) {
      ftmsService.setTargetPower(watts);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
