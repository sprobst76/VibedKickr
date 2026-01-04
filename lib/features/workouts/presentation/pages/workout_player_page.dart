import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/duration_formatter.dart';
import '../../../../domain/entities/workout.dart';
import '../../../../providers/providers.dart';
import '../../providers/workout_player_provider.dart';
import '../widgets/interval_progress_bar.dart';
import '../widgets/workout_timeline.dart';

class WorkoutPlayerPage extends ConsumerStatefulWidget {
  final String? workoutId;

  const WorkoutPlayerPage({super.key, this.workoutId});

  @override
  ConsumerState<WorkoutPlayerPage> createState() => _WorkoutPlayerPageState();
}

class _WorkoutPlayerPageState extends ConsumerState<WorkoutPlayerPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeWorkout();
    });
  }

  void _initializeWorkout() {
    if (widget.workoutId != null) {
      // Workout laden
      final workout = PredefinedWorkouts.all.firstWhere(
        (w) => w.id == widget.workoutId,
        orElse: () => PredefinedWorkouts.endurance30,
      );
      ref.read(workoutPlayerProvider.notifier).loadWorkout(workout);
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(workoutPlayerProvider);
    final liveData = ref.watch(liveTrainingDataProvider);
    final profile = ref.watch(athleteProfileProvider);
    final connectionState = ref.watch(bleConnectionStateProvider);

    final isConnected = connectionState.maybeWhen(
      data: (state) => state.isConnected,
      orElse: () => false,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _PlayerHeader(
              workout: playerState.workout,
              state: playerState.state,
              onClose: () => _handleClose(context, ref),
            ),

            // Main Content
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 900) {
                    return _DesktopLayout(
                      playerState: playerState,
                      liveData: liveData,
                      profile: profile,
                      isConnected: isConnected,
                    );
                  }
                  return _MobileLayout(
                    playerState: playerState,
                    liveData: liveData,
                    profile: profile,
                    isConnected: isConnected,
                  );
                },
              ),
            ),

            // Controls
            _PlayerControls(
              state: playerState.state,
              isConnected: isConnected,
              onStart: () => ref.read(workoutPlayerProvider.notifier).start(),
              onPause: () => ref.read(workoutPlayerProvider.notifier).pause(),
              onResume: () => ref.read(workoutPlayerProvider.notifier).resume(),
              onStop: () => _handleStop(context, ref),
              onSkip: () => ref.read(workoutPlayerProvider.notifier).skipInterval(),
            ),
          ],
        ),
      ),
    );
  }

  void _handleClose(BuildContext context, WidgetRef ref) {
    final state = ref.read(workoutPlayerProvider).state;
    if (state == WorkoutPlayerState.running || state == WorkoutPlayerState.paused) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Training beenden?'),
          content: const Text('Möchtest du das aktuelle Training wirklich beenden?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Abbrechen'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _handleStop(context, ref);
              },
              child: const Text('Beenden'),
            ),
          ],
        ),
      );
    } else {
      context.pop();
    }
  }

  Future<void> _handleStop(BuildContext context, WidgetRef ref) async {
    ref.read(workoutPlayerProvider.notifier).stop();
    final result = await ref.read(activeSessionProvider.notifier).finishSession();

    if (result != null && result.session.dataPoints.isNotEmpty) {
      if (context.mounted) {
        // Standard Snackbar für Session-Statistiken
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Training gespeichert: ${result.session.stats?.avgPower ?? 0}W Durchschnitt, '
              '${result.session.stats?.tss ?? 0} TSS',
            ),
          ),
        );

        // PR Dialog anzeigen, wenn neue Records aufgestellt wurden
        if (result.hasNewRecords) {
          await _showNewRecordsDialog(context, result.newRecords);
        }
      }
    }

    if (context.mounted) {
      context.pop();
    }
  }

  Future<void> _showNewRecordsDialog(
      BuildContext context, List<PersonalRecord> records) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.emoji_events, color: Colors.amber, size: 28),
            const SizedBox(width: 8),
            Text('${records.length == 1 ? "Neuer" : "Neue"} Personal Record${records.length > 1 ? "s" : ""}!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: records.map((record) {
            final improvement = record.improvement;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      record.recordType.displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${record.powerWatts}W',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (improvement != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      '+${improvement}W',
                      style: const TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Super!'),
          ),
        ],
      ),
    );
  }
}

class _PlayerHeader extends StatelessWidget {
  final Workout? workout;
  final WorkoutPlayerState state;
  final VoidCallback onClose;

  const _PlayerHeader({
    required this.workout,
    required this.state,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.surfaceLight),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClose,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout?.name ?? 'Free Ride',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _stateText(state),
                  style: TextStyle(
                    color: _stateColor(state),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _stateText(WorkoutPlayerState state) {
    return switch (state) {
      WorkoutPlayerState.idle => 'Bereit',
      WorkoutPlayerState.ready => 'Startbereit',
      WorkoutPlayerState.running => 'Läuft',
      WorkoutPlayerState.paused => 'Pausiert',
      WorkoutPlayerState.finished => 'Beendet',
    };
  }

  Color _stateColor(WorkoutPlayerState state) {
    return switch (state) {
      WorkoutPlayerState.idle => AppColors.textMuted,
      WorkoutPlayerState.ready => AppColors.warning,
      WorkoutPlayerState.running => AppColors.success,
      WorkoutPlayerState.paused => AppColors.warning,
      WorkoutPlayerState.finished => AppColors.primary,
    };
  }
}

class _MobileLayout extends StatelessWidget {
  final WorkoutPlayerData playerState;
  final LiveTrainingData liveData;
  final dynamic profile;
  final bool isConnected;

  const _MobileLayout({
    required this.playerState,
    required this.liveData,
    required this.profile,
    required this.isConnected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Current Interval
          if (playerState.currentInterval != null)
            IntervalProgressBar(
              interval: playerState.currentInterval!,
              elapsed: playerState.intervalElapsed,
              ftp: profile.ftp,
            ),
          const SizedBox(height: 24),

          // Power Display
          _PowerDisplay(
            power: liveData.power,
            targetPower: playerState.currentTargetPower,
            zone: liveData.currentZone,
            countdown: playerState.countdownSeconds,
            nextInterval: playerState.nextInterval,
            ftp: profile.ftp,
          ),
          const SizedBox(height: 24),

          // Metrics Row
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  label: 'Kadenz',
                  value: liveData.cadence?.toString() ?? '--',
                  unit: 'rpm',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricTile(
                  label: 'Herzfrequenz',
                  value: liveData.heartRate?.toString() ?? '--',
                  unit: 'bpm',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricTile(
                  label: 'Zeit',
                  value: liveData.elapsed.toTimerString(),
                  unit: '',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Workout Timeline
          if (playerState.workout != null)
            WorkoutTimeline(
              workout: playerState.workout!,
              currentIntervalIndex: playerState.currentIntervalIndex,
              ftp: profile.ftp,
            ),
        ],
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  final WorkoutPlayerData playerState;
  final LiveTrainingData liveData;
  final dynamic profile;
  final bool isConnected;

  const _DesktopLayout({
    required this.playerState,
    required this.liveData,
    required this.profile,
    required this.isConnected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // Left: Timeline
          if (playerState.workout != null)
            SizedBox(
              width: 300,
              child: WorkoutTimeline(
                workout: playerState.workout!,
                currentIntervalIndex: playerState.currentIntervalIndex,
                ftp: profile.ftp,
              ),
            ),
          const SizedBox(width: 24),

          // Center: Main Display
          Expanded(
            child: Column(
              children: [
                if (playerState.currentInterval != null)
                  IntervalProgressBar(
                    interval: playerState.currentInterval!,
                    elapsed: playerState.intervalElapsed,
                    ftp: profile.ftp,
                  ),
                const Spacer(),
                _PowerDisplay(
                  power: liveData.power,
                  targetPower: playerState.currentTargetPower,
                  zone: liveData.currentZone,
                  countdown: playerState.countdownSeconds,
                  nextInterval: playerState.nextInterval,
                  ftp: profile.ftp,
                ),
                const Spacer(),
              ],
            ),
          ),
          const SizedBox(width: 24),

          // Right: Metrics
          SizedBox(
            width: 200,
            child: Column(
              children: [
                _MetricTile(
                  label: 'Kadenz',
                  value: liveData.cadence?.toString() ?? '--',
                  unit: 'rpm',
                ),
                const SizedBox(height: 12),
                _MetricTile(
                  label: 'Herzfrequenz',
                  value: liveData.heartRate?.toString() ?? '--',
                  unit: 'bpm',
                ),
                const SizedBox(height: 12),
                _MetricTile(
                  label: 'Trainingszeit',
                  value: liveData.elapsed.toTimerString(),
                  unit: '',
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PowerDisplay extends StatelessWidget {
  final int power;
  final int targetPower;
  final int zone;
  final int? countdown;
  final WorkoutInterval? nextInterval;
  final int ftp;

  const _PowerDisplay({
    required this.power,
    required this.targetPower,
    required this.zone,
    this.countdown,
    this.nextInterval,
    this.ftp = 200,
  });

  @override
  Widget build(BuildContext context) {
    final zoneColor = ZoneColors.forZone(zone);
    final diff = power - targetPower;
    final isOnTarget = targetPower == 0 || diff.abs() <= targetPower * 0.05;

    // Countdown aktiv?
    if (countdown != null && countdown! > 0 && nextInterval != null) {
      return _CountdownOverlay(
        countdown: countdown!,
        nextInterval: nextInterval!,
        ftp: ftp,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Zone Indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: zoneColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Zone $zone',
            style: TextStyle(
              color: zoneColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Power Value
        Text(
          power.toString(),
          style: TextStyle(
            fontSize: 96,
            fontWeight: FontWeight.bold,
            color: zoneColor,
            height: 1,
          ),
        ),
        const Text(
          'WATT',
          style: TextStyle(
            fontSize: 24,
            color: AppColors.textSecondary,
            letterSpacing: 4,
          ),
        ),

        // Target Indicator
        if (targetPower > 0) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isOnTarget
                    ? Icons.check_circle
                    : (diff < 0 ? Icons.arrow_upward : Icons.arrow_downward),
                color: isOnTarget ? AppColors.success : AppColors.warning,
              ),
              const SizedBox(width: 8),
              Text(
                'Ziel: ${targetPower}W',
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.textSecondary,
                ),
              ),
              if (!isOnTarget) ...[
                const SizedBox(width: 8),
                Text(
                  '(${diff > 0 ? '+' : ''}$diff)',
                  style: TextStyle(
                    fontSize: 18,
                    color: diff < 0 ? AppColors.warning : AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

/// Countdown-Overlay vor Intervallwechsel
class _CountdownOverlay extends StatelessWidget {
  final int countdown;
  final WorkoutInterval nextInterval;
  final int ftp;

  const _CountdownOverlay({
    required this.countdown,
    required this.nextInterval,
    required this.ftp,
  });

  @override
  Widget build(BuildContext context) {
    final nextPower = nextInterval.powerTarget.resolveWatts(ftp);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Nächstes Intervall Info
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.warning.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Nächstes Intervall: ${nextPower}W',
            style: const TextStyle(
              color: AppColors.warning,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Countdown Zahl
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 1.2, end: 1.0),
          duration: const Duration(milliseconds: 200),
          key: ValueKey(countdown),
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: Text(
                '$countdown',
                style: const TextStyle(
                  fontSize: 144,
                  fontWeight: FontWeight.bold,
                  color: AppColors.warning,
                  height: 1,
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 16),
        Text(
          nextInterval.name,
          style: const TextStyle(
            fontSize: 24,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    unit,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _PlayerControls extends StatelessWidget {
  final WorkoutPlayerState state;
  final bool isConnected;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onStop;
  final VoidCallback onSkip;

  const _PlayerControls({
    required this.state,
    required this.isConnected,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onStop,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.surfaceLight),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (state == WorkoutPlayerState.running) ...[
            // Skip Button
            IconButton(
              onPressed: onSkip,
              icon: const Icon(Icons.skip_next),
              tooltip: 'Intervall überspringen',
            ),
            const SizedBox(width: 16),
            // Pause Button
            ElevatedButton.icon(
              onPressed: onPause,
              icon: const Icon(Icons.pause),
              label: const Text('Pause'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.warning,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
            const SizedBox(width: 16),
            // Stop Button
            OutlinedButton.icon(
              onPressed: onStop,
              icon: const Icon(Icons.stop),
              label: const Text('Stop'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
              ),
            ),
          ] else if (state == WorkoutPlayerState.paused) ...[
            // Resume Button
            ElevatedButton.icon(
              onPressed: onResume,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Fortsetzen'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
            const SizedBox(width: 16),
            // Stop Button
            OutlinedButton.icon(
              onPressed: onStop,
              icon: const Icon(Icons.stop),
              label: const Text('Beenden'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
              ),
            ),
          ] else ...[
            // Start Button
            ElevatedButton.icon(
              onPressed: isConnected ? onStart : null,
              icon: const Icon(Icons.play_arrow),
              label: Text(isConnected ? 'Start' : 'Trainer verbinden'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
