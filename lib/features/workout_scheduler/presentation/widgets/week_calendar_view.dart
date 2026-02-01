import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/scheduled_workout.dart';
import '../../../../providers/providers.dart';

class WeekCalendarView extends ConsumerWidget {
  const WeekCalendarView({super.key});

  static const _weekDays = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekWorkouts = ref.watch(weekScheduledWorkoutsProvider);

    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Diese Woche',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: List.generate(7, (index) {
                final date = startOfWeek.add(Duration(days: index));
                final dayWorkouts = weekWorkouts
                    .where((w) =>
                        w.scheduledDate.year == date.year &&
                        w.scheduledDate.month == date.month &&
                        w.scheduledDate.day == date.day)
                    .toList();

                return _DayCard(
                  dayLabel: _weekDays[index],
                  date: date,
                  workouts: dayWorkouts,
                  isToday: _isToday(date),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}

class _DayCard extends StatelessWidget {
  final String dayLabel;
  final DateTime date;
  final List<ScheduledWorkout> workouts;
  final bool isToday;

  const _DayCard({
    required this.dayLabel,
    required this.date,
    required this.workouts,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isToday
            ? AppColors.primary.withValues(alpha: 0.2)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isToday ? AppColors.primary : AppColors.surfaceLight,
          width: isToday ? 2 : 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dayLabel,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isToday ? AppColors.primary : AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              color: isToday ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          if (workouts.isNotEmpty)
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
