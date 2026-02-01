import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/strength_exercise.dart';
import '../../../../domain/entities/strength_workout.dart';
import '../widgets/exercise_picker_modal.dart';
import '../widgets/interval_config_widget.dart';

/// Workout Builder für Krafttraining
/// Ermöglicht das Erstellen und Bearbeiten von Custom Workouts
class StrengthWorkoutBuilderPage extends ConsumerStatefulWidget {
  final StrengthWorkout? initialWorkout;

  const StrengthWorkoutBuilderPage({
    this.initialWorkout,
    super.key,
  });

  @override
  ConsumerState<StrengthWorkoutBuilderPage> createState() =>
      _StrengthWorkoutBuilderPageState();
}

class _StrengthWorkoutBuilderPageState extends ConsumerState<StrengthWorkoutBuilderPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  String _workoutType = 'fullBody'; // fullBody, upper, lower, pushPull, core
  final List<_WorkoutIntervalData> _intervals = [];
  int? _draggedIndex;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialWorkout?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.initialWorkout?.description ?? '');
    _workoutType = _getWorkoutTypeString(widget.initialWorkout?.type ?? 'fullBody');

    // Load existing intervals if editing
    if (widget.initialWorkout != null) {
      // Note: Loading existing workouts requires fetching exercise details from exerciseId
      // This is handled in a future phase when routes are available
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final estimatedDuration = _calculateDuration();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Builder'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Workout Metadata Section
              _buildMetadataSection(),
              const SizedBox(height: 24),

              // Workout Type Section
              _buildWorkoutTypeSection(),
              const SizedBox(height: 24),

              // Exercises Section
              _buildExercisesSection(),
              const SizedBox(height: 24),

              // Duration Estimate
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Geschätzte Dauer',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            estimatedDuration,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _intervals.isEmpty ? null : _saveWorkout,
                  child: const Text('Workout speichern'),
                ),
              ),
              const SizedBox(height: 8),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Abbrechen'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetadataSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'WORKOUT DETAILS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textMuted,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),

        // Name
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'z.B. Ganzkörper-Montag',
            labelText: 'Workout Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Description
        TextField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Optionale Beschreibung...',
            labelText: 'Beschreibung',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'WORKOUT TYP',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textMuted,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _workoutType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: const [
            DropdownMenuItem(value: 'fullBody', child: Text('Ganzkörper')),
            DropdownMenuItem(value: 'upper', child: Text('Oberkörper')),
            DropdownMenuItem(value: 'lower', child: Text('Unterkörper')),
            DropdownMenuItem(value: 'pushPull', child: Text('Push/Pull')),
            DropdownMenuItem(value: 'core', child: Text('Core')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => _workoutType = value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildExercisesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ÜBUNGEN',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textMuted,
                letterSpacing: 0.8,
              ),
            ),
            Text(
              '${_intervals.length} ${_intervals.length == 1 ? 'Übung' : 'Übungen'}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Add Exercise Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _showExercisePicker,
            icon: const Icon(Icons.add),
            label: const Text('Übung hinzufügen'),
          ),
        ),
        const SizedBox(height: 12),

        // Exercises List
        if (_intervals.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.surfaceLight,
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.fitness_center,
                    size: 32,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Keine Übungen hinzugefügt',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _intervals.length,
            itemBuilder: (context, index) {
              return _buildExerciseItem(index);
            },
          ),
      ],
    );
  }

  Widget _buildExerciseItem(int index) {
    final interval = _intervals[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.surfaceLight,
        ),
      ),
      child: Column(
        children: [
          // Header with drag handle and delete
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(
                  Icons.drag_handle,
                  color: AppColors.textMuted,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        interval.exercise.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${interval.sets} × ${interval.repsMin}${interval.repsMax != interval.repsMin ? "-${interval.repsMax}" : ""} reps',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  color: AppColors.error,
                  onPressed: () => setState(() => _intervals.removeAt(index)),
                ),
              ],
            ),
          ),

          // Config Button
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _showConfigModal(index),
                child: const Text('Konfigurieren'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showExercisePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ExercisePickerModal(
        onExercisesSelected: _addExercises,
      ),
    );
  }

  void _addExercises(List<StrengthExercise> exercises) {
    setState(() {
      for (final exercise in exercises) {
        // Check if exercise already added
        if (!_intervals.any((i) => i.exercise.id == exercise.id)) {
          _intervals.add(
            _WorkoutIntervalData(
              exercise: exercise,
              sets: 3,
              repsMin: 10,
              repsMax: 12,
              loadTarget: LoadTarget.bodyweight(),
              restBetweenSets: const Duration(seconds: 90),
            ),
          );
        }
      }
    });
    Navigator.pop(context);
  }

  void _showConfigModal(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => IntervalConfigWidget(
        exercise: _intervals[index].exercise,
        initialData: _intervals[index],
        onSave: (data) {
          setState(() => _intervals[index] = data);
          Navigator.pop(context);
        },
      ),
    );
  }

  String _calculateDuration() {
    int totalSeconds = 0;

    for (final interval in _intervals) {
      // Assume ~45 seconds per set
      final workSeconds = interval.sets * 45;
      final restSeconds = interval.restBetweenSets.inSeconds * (interval.sets - 1);
      totalSeconds += workSeconds + restSeconds;
    }

    // Add 5 minutes warmup/cooldown
    totalSeconds += 300;

    final minutes = (totalSeconds / 60).round();
    return '$minutes Minuten';
  }

  String _getWorkoutTypeString(dynamic type) {
    if (type is String) return type;
    return 'fullBody';
  }

  void _saveWorkout() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte geben Sie einen Workout-Namen ein')),
      );
      return;
    }

    if (_intervals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte fügen Sie mindestens eine Übung hinzu')),
      );
      return;
    }

    // TODO: Save workout to database when routes are available
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Workout "$name" gespeichert'),
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }
}

/// Datenklasse für Workout-Intervalle
class _WorkoutIntervalData {
  final StrengthExercise exercise;
  int sets;
  int repsMin;
  int repsMax;
  LoadTarget loadTarget;
  Duration restBetweenSets;
  String? tempo;
  String? instructions;

  _WorkoutIntervalData({
    required this.exercise,
    required this.sets,
    required this.repsMin,
    required this.repsMax,
    required this.loadTarget,
    required this.restBetweenSets,
    this.tempo,
    this.instructions,
  });

  _WorkoutIntervalData copyWith({
    StrengthExercise? exercise,
    int? sets,
    int? repsMin,
    int? repsMax,
    LoadTarget? loadTarget,
    Duration? restBetweenSets,
    String? tempo,
    String? instructions,
  }) {
    return _WorkoutIntervalData(
      exercise: exercise ?? this.exercise,
      sets: sets ?? this.sets,
      repsMin: repsMin ?? this.repsMin,
      repsMax: repsMax ?? this.repsMax,
      loadTarget: loadTarget ?? this.loadTarget,
      restBetweenSets: restBetweenSets ?? this.restBetweenSets,
      tempo: tempo ?? this.tempo,
      instructions: instructions ?? this.instructions,
    );
  }
}
