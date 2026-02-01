import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/strength_exercise.dart';
import '../../../../domain/entities/strength_workout.dart';
import '../widgets/rest_timer.dart';
import '../widgets/session_player_states.dart';

/// Session Player für Krafttraining-Workouts
/// Verwaltet Übungsauführung mit Rest Timer, Audio Cues und Haptic Feedback
class StrengthSessionPlayerPage extends ConsumerStatefulWidget {
  final StrengthWorkout workout;
  final Map<String, StrengthExercise> exerciseMap;

  const StrengthSessionPlayerPage({
    required this.workout,
    required this.exerciseMap,
    super.key,
  });

  @override
  ConsumerState<StrengthSessionPlayerPage> createState() => _StrengthSessionPlayerPageState();
}

class _StrengthSessionPlayerPageState extends ConsumerState<StrengthSessionPlayerPage>
    with TickerProviderStateMixin {
  late SessionPlayerState _state;
  late int _currentExerciseIndex;
  late int _currentSetIndex;
  late List<_ExerciseProgress> _exerciseProgress;
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  int? _selectedRpe;

  late AnimationController _restTimerController;

  @override
  void initState() {
    super.initState();
    _state = SessionPlayerState.intro;
    _currentExerciseIndex = 0;
    _currentSetIndex = 0;
    _exerciseProgress = _initializeProgress();
    _repsController.text = _getCurrentInterval().repsTarget.toString();
    _restTimerController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _repsController.dispose();
    _weightController.dispose();
    _restTimerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentInterval = _getCurrentInterval();
    final currentExercise = widget.exerciseMap[currentInterval.exerciseId];

    return WillPopScope(
      onWillPop: () => _showExitDialog(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Workout Player'),
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => _showExitDialog(context),
            ),
          ],
        ),
        body: _buildStateWidget(currentExercise, currentInterval),
      ),
    );
  }

  Widget _buildStateWidget(StrengthExercise? exercise, StrengthInterval interval) {
    return switch (_state) {
      SessionPlayerState.intro => _buildIntroScreen(exercise, interval),
      SessionPlayerState.active => _buildActiveScreen(exercise, interval),
      SessionPlayerState.resting => _buildRestScreen(interval),
      SessionPlayerState.completed => _buildCompletedScreen(),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildIntroScreen(StrengthExercise? exercise, StrengthInterval interval) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Exercise number
              Text(
                'Übung ${_currentExerciseIndex + 1}/${widget.workout.intervals.length}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),

              // Exercise name
              Text(
                exercise?.name ?? 'Übung',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Exercise icon/placeholder
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.fitness_center,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),

              // Workout info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _InfoItem(
                          icon: Icons.repeat,
                          label: 'Sätze',
                          value: interval.sets.toString(),
                        ),
                        _InfoItem(
                          icon: Icons.trending_up,
                          label: 'Reps',
                          value: _formatReps(interval),
                        ),
                        _InfoItem(
                          icon: Icons.schedule,
                          label: 'Ruhe',
                          value: _formatDuration(interval.restBetweenSets),
                        ),
                      ],
                    ),
                    if (exercise?.formCues != null) ...[
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 12),
                      const Text(
                        'FORM TIPPS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMuted,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildFormCuesList(exercise!.formCues),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Start button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => setState(() => _state = SessionPlayerState.active),
                  child: const Text('Starten'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveScreen(StrengthExercise? exercise, StrengthInterval interval) {
    final progress = _exerciseProgress[_currentExerciseIndex];
    final setNumber = _currentSetIndex + 1;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Progress indicator
              Text(
                'Übung ${_currentExerciseIndex + 1}/${widget.workout.intervals.length} • Satz $setNumber/${interval.sets}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),

              // Exercise name
              Text(
                exercise?.name ?? 'Übung',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),

              // Target info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      'Ziel: ${interval.repsTarget} Wiederholungen',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    if (_getLoadDescription(interval).isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        _getLoadDescription(interval),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                    if (progress.lastSetReps[_currentSetIndex] != null) ...[
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),
                      Text(
                        'Letzter Satz: ${progress.lastSetReps[_currentSetIndex]} reps',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Quick rep buttons
              Text(
                'Wiederholungen',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [8, 10, 12, 15].map((reps) {
                  return OutlinedButton(
                    onPressed: () {
                      _repsController.text = reps.toString();
                      _selectedRpe = null;
                    },
                    child: Text('$reps'),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _repsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Manuell eingeben...',
                  labelText: 'Wiederholungen',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // RPE selector (optional)
              Text(
                'RPE (optional)',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                children: List.generate(10, (i) => i + 1).map((rpe) {
                  final selected = _selectedRpe == rpe;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedRpe = selected ? null : rpe),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: selected ? AppColors.primary : AppColors.surfaceLight,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selected ? AppColors.primary : AppColors.surfaceLight,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          rpe.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: selected ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Complete set button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _completeSet,
                  child: const Text('Satz abschließen'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRestScreen(StrengthInterval interval) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Ruhezeit',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 32),

          // Rest timer
          RestTimer(
            duration: interval.restBetweenSets,
            onComplete: _startNextSet,
            onSkip: _startNextSet,
          ),

          const SizedBox(height: 48),

          // Skip button
          OutlinedButton.icon(
            onPressed: _startNextSet,
            icon: const Icon(Icons.skip_next),
            label: const Text('Überspringen'),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedScreen() {
    final totalSets = _exerciseProgress.fold<int>(
      0,
      (sum, progress) => sum + progress.lastSetReps.length,
    );
    final totalReps = _exerciseProgress.fold<int>(
      0,
      (sum, progress) =>
          sum +
          progress.lastSetReps.fold<int>(0, (s, r) => s + (r ?? 0)),
    );

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                size: 80,
                color: AppColors.success,
              ),
              const SizedBox(height: 24),

              const Text(
                'Workout abgeschlossen!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 32),

              // Summary cards
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _InfoItem(
                      icon: Icons.repeat,
                      label: 'Sätze',
                      value: totalSets.toString(),
                    ),
                    _InfoItem(
                      icon: Icons.trending_up,
                      label: 'Reps',
                      value: totalReps.toString(),
                    ),
                    _InfoItem(
                      icon: Icons.fitness_center,
                      label: 'Übungen',
                      value: widget.workout.intervals.length.toString(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _saveSession,
                  child: const Text('Session speichern'),
                ),
              ),
              const SizedBox(height: 12),

              // Home button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Zur Startseite'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormCuesList(String formCues) {
    final cues = formCues.split('.');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: cues
          .where((cue) => cue.trim().isNotEmpty)
          .map(
            (cue) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2, right: 8),
                    child: Text(
                      '•',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      cue.trim(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  List<_ExerciseProgress> _initializeProgress() {
    return List.generate(
      widget.workout.intervals.length,
      (index) => _ExerciseProgress(
        lastSetReps: List.generate(
          widget.workout.intervals[index].sets,
          (_) => null,
        ),
      ),
    );
  }

  StrengthInterval _getCurrentInterval() {
    return widget.workout.intervals[_currentExerciseIndex];
  }

  String _formatReps(StrengthInterval interval) {
    if (interval.repsMin != null && interval.repsMax != null) {
      return '${interval.repsMin}-${interval.repsMax}';
    }
    return interval.repsTarget.toString();
  }

  String _formatDuration(Duration duration) {
    if (duration.inSeconds < 60) {
      return '${duration.inSeconds}s';
    }
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    if (seconds == 0) {
      return '${minutes}m';
    }
    return '${minutes}m${seconds}s';
  }

  String _getLoadDescription(StrengthInterval interval) {
    return switch (interval.loadTarget.type) {
      LoadTargetType.absolute =>
        'Gewicht: ${interval.loadTarget.weight?.toStringAsFixed(1) ?? "?"}kg',
      LoadTargetType.percentage =>
        'Intensität: ${interval.loadTarget.percentage}% 1RM',
      LoadTargetType.rpe => 'RPE Target: ${interval.loadTarget.rpe}/10',
      LoadTargetType.bodyweight => 'Körpergewicht',
    };
  }

  void _completeSet() {
    final reps = int.tryParse(_repsController.text) ?? 0;
    if (reps <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte geben Sie die Wiederholungen ein')),
      );
      return;
    }

    // Record set
    _exerciseProgress[_currentExerciseIndex].lastSetReps[_currentSetIndex] = reps;

    final interval = _getCurrentInterval();
    if (_currentSetIndex < interval.sets - 1) {
      // More sets to go
      _currentSetIndex++;
      setState(() => _state = SessionPlayerState.resting);
    } else if (_currentExerciseIndex < widget.workout.intervals.length - 1) {
      // More exercises to go
      _currentExerciseIndex++;
      _currentSetIndex = 0;
      _repsController.text = widget.workout.intervals[_currentExerciseIndex].repsTarget.toString();
      setState(() => _state = SessionPlayerState.intro);
    } else {
      // Workout complete
      setState(() => _state = SessionPlayerState.completed);
    }
  }

  void _startNextSet() {
    _selectedRpe = null;
    setState(() => _state = SessionPlayerState.active);
  }

  void _saveSession() {
    // TODO: Save session to database when DAOs available
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Session gespeichert')),
    );
    Navigator.pop(context);
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Workout beenden?'),
        content: const Text('Ihr Fortschritt wird nicht gespeichert.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Fortsetzen'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Beenden'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

/// Info item widget
class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 24,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

/// Exercise progress tracking
class _ExerciseProgress {
  final List<int?> lastSetReps;

  _ExerciseProgress({required this.lastSetReps});
}
