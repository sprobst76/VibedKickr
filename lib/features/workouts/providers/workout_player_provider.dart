import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/audio/audio_cue_service.dart';
import '../../../core/ble/models/connection_state.dart';
import '../../../core/services/health_safety_monitor.dart';
import '../../../domain/entities/workout.dart';
import '../../../domain/entities/training_session.dart';
import '../../../main.dart';
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
  final int? countdownSeconds; // Countdown vor Intervallwechsel (3, 2, 1)
  final HrMonitoringStatus? hrStatus; // HR Safety Monitoring Status (für Health Training)
  final bool hrAutoPaused; // Ob Training wegen HR-Limit pausiert wurde

  const WorkoutPlayerData({
    this.state = WorkoutPlayerState.idle,
    this.workout,
    this.currentIntervalIndex = 0,
    this.intervalElapsed = Duration.zero,
    this.totalElapsed = Duration.zero,
    this.currentTargetPower = 0,
    this.countdownSeconds,
    this.hrStatus,
    this.hrAutoPaused = false,
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
    int? countdownSeconds,
    bool clearCountdown = false,
    HrMonitoringStatus? hrStatus,
    bool? hrAutoPaused,
  }) {
    return WorkoutPlayerData(
      state: state ?? this.state,
      workout: workout ?? this.workout,
      currentIntervalIndex: currentIntervalIndex ?? this.currentIntervalIndex,
      intervalElapsed: intervalElapsed ?? this.intervalElapsed,
      totalElapsed: totalElapsed ?? this.totalElapsed,
      currentTargetPower: currentTargetPower ?? this.currentTargetPower,
      countdownSeconds: clearCountdown ? null : (countdownSeconds ?? this.countdownSeconds),
      hrStatus: hrStatus ?? this.hrStatus,
      hrAutoPaused: hrAutoPaused ?? this.hrAutoPaused,
    );
  }
}

enum HapticType {
  countdown,
  intervalStart,
  workoutComplete,
  workoutStart,
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
  int? _lastCountdownPlayed; // Verhindert doppelte Audio-Cues

  // Power deviation tracking
  DateTime? _lastPowerWarning;
  int _consecutiveLowPowerTicks = 0;
  int _consecutiveHighPowerTicks = 0;
  static const int _warningCooldownSeconds = 10;
  static const int _ticksBeforeWarning = 30; // 3 Sekunden bei 100ms Intervallen

  // HR safety monitoring
  DateTime? _lastHrInfoWarning;
  DateTime? _lastHrWarningWarning;
  int? _peakHrInInterval;

  // BLE connection monitoring
  StreamSubscription<BleConnectionState>? _bleConnectionSubscription;
  bool _pausedDueToDisconnect = false;

  WorkoutPlayerNotifier(this._ref) : super(const WorkoutPlayerData()) {
    // Audio Service initialisieren
    _initAudio();
    // BLE connection monitoring für auto-pause bei Disconnect
    _initBleMonitoring();
  }

  Future<void> _initAudio() async {
    try {
      final audioService = _ref.read(audioCueServiceProvider);
      await audioService.initialize();
    } catch (_) {
      // Audio nicht verfügbar - silent fail
    }
  }

  Future<void> _initBleMonitoring() async {
    try {
      final bleManager = _ref.read(bleManagerProvider);
      _bleConnectionSubscription = bleManager.connectionState.listen(
        _handleConnectionStateChange,
      );
    } catch (e) {
      logger.w('Failed to initialize BLE monitoring: $e');
    }
  }

  void _handleConnectionStateChange(BleConnectionState connectionState) {
    // Nur während aktivem Workout interessant
    if (state.state != WorkoutPlayerState.running) return;

    if (connectionState.isDisconnected || connectionState.hasError) {
      // Trainer ist disconnected - pausiere automatisch
      if (!_pausedDueToDisconnect) {
        logger.w('Trainer disconnected during workout - auto-pausing');
        _pausedDueToDisconnect = true;
        pause();
      }
    } else if (connectionState.isConnected && _pausedDueToDisconnect) {
      // Trainer ist reconnected - halte aber pausiert bis Benutzer resumen will
      logger.i('Trainer reconnected - keeping paused until user resumes');
      _pausedDueToDisconnect = false;
    }
  }

  bool get _soundEnabled => _ref.read(soundEnabledProvider);

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
    _lastCountdownPlayed = null;

    // Session starten
    _startSession(SessionType.workout, workoutId: state.workout?.id);

    // Trainer steuern
    _setTrainerPower(targetPower);

    // Audio Cue: Workout startet
    _playAudioCue(AudioCueType.intervalStart);
    _triggerHaptic(HapticType.workoutStart);

    // Timer starten
    _startTimer();
  }

  void pause() {
    if (state.state != WorkoutPlayerState.running) return;

    _timer?.cancel();
    _ref.read(activeSessionProvider.notifier).pauseSession();

    // Reset power deviation tracking
    _consecutiveLowPowerTicks = 0;
    _consecutiveHighPowerTicks = 0;

    // Store peak HR for recovery analysis if available
    if (_peakHrInInterval != null && state.hrStatus?.currentHr != null) {
      // HR peak is already stored in _peakHrInInterval for later analysis
    }

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
    // Reset power deviation tracking
    _consecutiveLowPowerTicks = 0;
    _consecutiveHighPowerTicks = 0;
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

    // Countdown-Logik für Intervallwechsel
    final interval = state.currentInterval;
    int? countdown;

    if (interval != null && state.nextInterval != null) {
      final remaining = interval.duration - intervalElapsed;
      final remainingSeconds = remaining.inSeconds;

      // Countdown bei 3, 2, 1 Sekunden
      if (remainingSeconds <= 3 && remainingSeconds >= 0) {
        countdown = remainingSeconds;

        // Audio Cue nur einmal pro Sekunde
        if (_soundEnabled && _lastCountdownPlayed != remainingSeconds) {
          _lastCountdownPlayed = remainingSeconds;
          if (remainingSeconds > 0) {
            _playAudioCue(AudioCueType.countdown);
            _triggerHaptic(HapticType.countdown);
          }
        }
      }
    }

    state = state.copyWith(
      intervalElapsed: intervalElapsed,
      totalElapsed: totalElapsed,
      countdownSeconds: countdown,
      clearCountdown: countdown == null,
    );

    // Update target power in live data
    _ref.read(liveTrainingDataProvider.notifier).setTargetPower(
          state.currentTargetPower,
        );

    // Check power deviation and alert if needed
    _checkPowerDeviation();

    // Check HR safety (for Health Training programs)
    _checkHrSafety();

    // Check if interval is complete
    if (interval != null && intervalElapsed >= interval.duration) {
      _nextInterval();
    }
  }

  void _nextInterval() {
    final nextIndex = state.currentIntervalIndex + 1;

    if (state.workout == null || nextIndex >= state.workout!.intervals.length) {
      // Workout complete
      _timer?.cancel();
      _playAudioCue(AudioCueType.workoutComplete);
      _triggerHaptic(HapticType.workoutComplete);
      state = state.copyWith(
        state: WorkoutPlayerState.finished,
        clearCountdown: true,
      );
      return;
    }

    final ftp = _ref.read(athleteProfileProvider).ftp;
    final nextInterval = state.workout!.intervals[nextIndex];
    final targetPower = nextInterval.powerTarget.resolveWatts(ftp);

    _intervalStartTime = DateTime.now();
    _lastCountdownPlayed = null;

    // Reset HR peak for next interval (for recovery tracking)
    _peakHrInInterval = null;

    state = state.copyWith(
      currentIntervalIndex: nextIndex,
      intervalElapsed: Duration.zero,
      currentTargetPower: targetPower,
      clearCountdown: true,
    );

    // Trainer steuern
    _setTrainerPower(targetPower);

    // Audio Cue: Neues Intervall startet
    _playAudioCue(AudioCueType.intervalStart);
    _triggerHaptic(HapticType.intervalStart);
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

  void _playAudioCue(AudioCueType type) {
    if (!_soundEnabled) return;

    try {
      final audioService = _ref.read(audioCueServiceProvider);
      audioService.playCue(type);
    } catch (_) {
      // Audio nicht verfügbar - silent fail
    }
  }

  void _triggerHaptic(HapticType type) {
    if (!_hapticsEnabled) return;

    try {
      switch (type) {
        case HapticType.countdown:
          HapticFeedback.lightImpact(); // Subtiles Ticken für Countdown
          break;
        case HapticType.intervalStart:
          HapticFeedback.mediumImpact(); // Spürbarer Buzz bei Intervallwechsel
          break;
        case HapticType.workoutComplete:
          HapticFeedback.heavyImpact(); // Starker Buzz zum Abschluss
          break;
        case HapticType.workoutStart:
          HapticFeedback.mediumImpact(); // Motivierender Start
          break;
      }
    } catch (_) {
      // Haptic nicht verfügbar - silent fail
    }
  }

  bool get _hapticsEnabled => _ref.read(hapticsEnabledProvider);

  void _checkPowerDeviation() {
    if (!_powerDeviationAlertsEnabled) return;
    if (state.currentTargetPower == 0) {
      // Kein Ziel gesetzt - Counter zurücksetzen
      _consecutiveLowPowerTicks = 0;
      _consecutiveHighPowerTicks = 0;
      return;
    }

    final liveData = _ref.read(liveTrainingDataProvider);
    final currentPower = liveData.avgPower3s; // Use 3s average to reduce noise
    final targetPower = state.currentTargetPower;

    // Berechne Abweichung in Prozent
    final deviation = (currentPower - targetPower) / targetPower;
    final threshold = _powerDeviationThreshold;

    // Track consecutive deviation ticks
    if (deviation < -threshold / 100) {
      // Zu niedrig
      _consecutiveLowPowerTicks++;
      _consecutiveHighPowerTicks = 0;

      if (_consecutiveLowPowerTicks >= _ticksBeforeWarning && _canPlayWarning()) {
        _playAudioCue(AudioCueType.powerTooLow);
        _lastPowerWarning = DateTime.now();
        _consecutiveLowPowerTicks = 0; // Reset nach Warning
      }
    } else if (deviation > threshold / 100) {
      // Zu hoch
      _consecutiveHighPowerTicks++;
      _consecutiveLowPowerTicks = 0;

      if (_consecutiveHighPowerTicks >= _ticksBeforeWarning && _canPlayWarning()) {
        _playAudioCue(AudioCueType.powerTooHigh);
        _lastPowerWarning = DateTime.now();
        _consecutiveHighPowerTicks = 0; // Reset nach Warning
      }
    } else {
      // Im Bereich - Counter zurücksetzen
      _consecutiveLowPowerTicks = 0;
      _consecutiveHighPowerTicks = 0;
    }
  }

  bool _canPlayWarning() {
    if (_lastPowerWarning == null) return true;
    final timeSinceWarning = DateTime.now().difference(_lastPowerWarning!);
    return timeSinceWarning.inSeconds >= _warningCooldownSeconds;
  }

  bool get _powerDeviationAlertsEnabled => _ref.read(powerDeviationAlertsProvider);
  int get _powerDeviationThreshold => _ref.read(powerDeviationThresholdProvider);

  void _checkHrSafety() {
    final liveData = _ref.read(liveTrainingDataProvider);
    final currentHr = liveData.heartRate;
    final athlete = _ref.read(athleteProfileProvider);

    // Berechne HR Monitoring Status
    final hrStatus = HealthTrainingSafetyMonitor.calculateHrStatus(
      currentHr: currentHr,
      athlete: athlete,
      lastInfoWarningTime: _lastHrInfoWarning,
      lastWarningWarningTime: _lastHrWarningWarning,
    );

    // Update state mit HR Status
    state = state.copyWith(hrStatus: hrStatus);

    // Tracke Peak HR für Recovery-Analyse später
    if (currentHr != null && ((_peakHrInInterval ?? 0) < currentHr)) {
      _peakHrInInterval = currentHr;
    }

    // Check if we should pause due to critical HR
    if (hrStatus.shouldAutoPause && !state.hrAutoPaused) {
      _pauseForHrLimit();
      return;
    }

    // Play audio warning wenn nötig
    if (HealthTrainingSafetyMonitor.shouldPlayAudioWarning(
      hrStatus.warningLevel,
      hrStatus.warningLevel == HrWarningLevel.info
          ? _lastHrInfoWarning
          : _lastHrWarningWarning,
    )) {
      if (hrStatus.warningLevel == HrWarningLevel.info) {
        _playAudioCue(AudioCueType.hrWarning);
        _lastHrInfoWarning = DateTime.now();
      } else if (hrStatus.warningLevel == HrWarningLevel.warning) {
        _playAudioCue(AudioCueType.hrWarning);
        _lastHrWarningWarning = DateTime.now();
      } else if (hrStatus.warningLevel == HrWarningLevel.critical) {
        _playAudioCue(AudioCueType.hrCritical);
        _lastHrWarningWarning = DateTime.now();
      }
    }
  }

  void _pauseForHrLimit() {
    // Automatisch pausieren wenn HR-Limit überschritten
    pause();
    state = state.copyWith(hrAutoPaused: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _bleConnectionSubscription?.cancel();
    super.dispose();
  }
}
