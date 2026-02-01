import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/scheduled_workout.dart';
import '../../../../providers/providers.dart';

class ScheduledWorkoutList extends ConsumerWidget {
  const ScheduledWorkoutList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduledWorkouts = ref.watch(pendingScheduledWorkoutsProvider);

    return scheduledWorkouts.when(
      data: (workouts) {
        if (workouts.isEmpty) {
          return const _EmptyState();
        }

        return Column(
          children: workouts
              .map((workout) => _ScheduledWorkoutCard(workout: workout))
              .toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Fehler: $error'),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.event_busy,
            size: 64,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 16),
          Text(
            'Keine geplanten Workouts',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Plane dein erstes Workout in der Workouts Liste',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ScheduledWorkoutCard extends ConsumerWidget {
  final ScheduledWorkout workout;

  const _ScheduledWorkoutCard({required this.workout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('EEE, dd. MMM', 'de_DE');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          workout.workoutType == 'cycling'
              ? Icons.directions_bike
              : Icons.fitness_center,
          color: AppColors.primary,
        ),
        title: Text(
          workout.workoutName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(dateFormat.format(workout.scheduledDate)),
            Text(workout.formattedTime),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'skip',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cancel_outlined),
                  SizedBox(width: 8),
                  Text('Überspringen'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.delete_outline),
                  SizedBox(width: 8),
                  Text('Löschen'),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'skip') {
              _skipWorkout(ref, workout.id);
            } else if (value == 'delete') {
              _deleteWorkout(ref, workout.id);
            }
          },
        ),
      ),
    );
  }

  void _skipWorkout(WidgetRef ref, String id) {
    final repository = ref.read(scheduledWorkoutRepositoryProvider);
    repository.markAsSkipped(id);
  }

  void _deleteWorkout(WidgetRef ref, String id) {
    final repository = ref.read(scheduledWorkoutRepositoryProvider);
    repository.deleteScheduledWorkout(id);
  }
}
