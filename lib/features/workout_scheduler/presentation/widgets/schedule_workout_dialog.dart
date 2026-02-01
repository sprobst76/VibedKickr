import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/workout.dart';
import '../../../../domain/entities/strength_workout.dart';
import '../../../../providers/providers.dart';

Future<void> showScheduleWorkoutDialog({
  required BuildContext context,
  required WidgetRef ref,
  Workout? cyclingWorkout,
  StrengthWorkout? strengthWorkout,
}) {
  return showDialog(
    context: context,
    builder: (context) => _ScheduleWorkoutDialog(
      cyclingWorkout: cyclingWorkout,
      strengthWorkout: strengthWorkout,
    ),
  );
}

class _ScheduleWorkoutDialog extends ConsumerStatefulWidget {
  final Workout? cyclingWorkout;
  final StrengthWorkout? strengthWorkout;

  const _ScheduleWorkoutDialog({
    this.cyclingWorkout,
    this.strengthWorkout,
  });

  @override
  ConsumerState<_ScheduleWorkoutDialog> createState() =>
      __ScheduleWorkoutDialogState();
}

class __ScheduleWorkoutDialogState
    extends ConsumerState<_ScheduleWorkoutDialog> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    final workoutName = widget.cyclingWorkout?.name ??
        widget.strengthWorkout?.name ??
        'Workout';

    return AlertDialog(
      title: const Text('Workout planen'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            workoutName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),

          // Date Picker
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_today),
            title: Text(
              _selectedDate == null
                  ? 'Datum wählen'
                  : _formatDate(_selectedDate!),
            ),
            onTap: _pickDate,
          ),

          // Time Picker (optional)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.access_time),
            title: Text(
              _selectedTime == null
                  ? 'Zeit wählen (optional)'
                  : _selectedTime!.format(context),
            ),
            onTap: _pickTime,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        ElevatedButton(
          onPressed: _selectedDate == null ? null : _scheduleWorkout,
          child: const Text('Planen'),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('de', 'DE'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            useMaterial3: true,
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 8,
              headerBackgroundColor: AppColors.primary,
              headerForegroundColor: Colors.white,
              weekdayStyle: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              dayStyle: const TextStyle(color: AppColors.textPrimary),
              yearStyle: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
          child: child ?? const SizedBox(),
        );
      },
    );

    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            useMaterial3: true,
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              hourMinuteTextColor: AppColors.textPrimary,
              hourMinuteColor: AppColors.primary.withValues(alpha: 0.1),
              dialHandColor: AppColors.primary,
              dialBackgroundColor: AppColors.surfaceLight,
              entryModeIconColor: AppColors.textSecondary,
              helpTextStyle: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
          child: child ?? const SizedBox(),
        );
      },
    );

    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  void _scheduleWorkout() async {
    if (_selectedDate == null) return;

    final repository = ref.read(scheduledWorkoutRepositoryProvider);

    int? timeMinutes;
    if (_selectedTime != null) {
      timeMinutes = _selectedTime!.hour * 60 + _selectedTime!.minute;
    }

    if (widget.cyclingWorkout != null) {
      await repository.scheduleWorkout(
        workoutId: widget.cyclingWorkout!.id,
        workoutType: 'cycling',
        scheduledDate: _selectedDate!,
        scheduledTimeMinutes: timeMinutes,
      );
    } else if (widget.strengthWorkout != null) {
      await repository.scheduleWorkout(
        workoutId: widget.strengthWorkout!.id,
        workoutType: 'strength',
        scheduledDate: _selectedDate!,
        scheduledTimeMinutes: timeMinutes,
      );
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workout geplant!')),
      );
    }
  }

  String _formatDate(DateTime date) {
    final weekDays = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
    final weekDay = weekDays[date.weekday - 1];
    return '$weekDay, ${date.day}.${date.month}.${date.year}';
  }
}
