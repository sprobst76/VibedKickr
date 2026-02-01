import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/scheduled_workout.dart';
import '../../../../providers/providers.dart';
import '../../../../routing/app_router.dart';

class ScheduledWorkoutsCard extends ConsumerWidget {
  const ScheduledWorkoutsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayWorkouts = ref.watch(todayScheduledWorkoutsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Geplante Workouts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => context.push(AppRoutes.workoutScheduler),
                  icon: const Icon(Icons.calendar_month, size: 18),
                  label: const Text('Kalender'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (todayWorkouts.isEmpty)
              const _EmptyState()
            else
              ...todayWorkouts.map((workout) => _WorkoutTile(workout: workout)),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.event_available,
            size: 48,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 12),
          Text(
            'Keine Workouts für heute geplant',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutTile extends ConsumerWidget {
  final ScheduledWorkout workout;

  const _WorkoutTile({required this.workout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            workout.workoutType == 'cycling'
                ? Icons.directions_bike
                : Icons.fitness_center,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout.workoutName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  workout.formattedTime,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _startWorkout(context, ref, workout),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Starten'),
          ),
        ],
      ),
    );
  }

  void _startWorkout(
    BuildContext context,
    WidgetRef ref,
    ScheduledWorkout scheduled,
  ) {
    if (scheduled.workoutType == 'cycling' && scheduled.cyclingWorkout != null) {
      context.push(
        '${AppRoutes.workoutPlayer}?workoutId=${scheduled.cyclingWorkout!.id}',
      );
    }
  }
}
