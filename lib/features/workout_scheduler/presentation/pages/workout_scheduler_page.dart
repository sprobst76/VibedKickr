import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../providers/providers.dart';
import '../widgets/week_calendar_view.dart';
import '../widgets/scheduled_workout_list.dart';

class WorkoutSchedulerPage extends ConsumerWidget {
  const WorkoutSchedulerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Planer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Week Calendar View
            const WeekCalendarView(),
            const SizedBox(height: 24),

            // Scheduled Workouts List
            const Text(
              'GEPLANTE WORKOUTS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textMuted,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),
            const ScheduledWorkoutList(),
          ],
        ),
      ),
    );
  }
}
