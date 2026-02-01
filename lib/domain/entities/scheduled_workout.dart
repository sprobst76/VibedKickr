import 'package:freezed_annotation/freezed_annotation.dart';
import 'workout.dart';
import 'strength_workout.dart';

part 'scheduled_workout.freezed.dart';

enum ScheduledWorkoutStatus {
  pending,
  completed,
  skipped,
}

@freezed
class ScheduledWorkout with _$ScheduledWorkout {
  const ScheduledWorkout._();

  const factory ScheduledWorkout({
    required String id,
    required String workoutId,
    required String workoutType, // 'cycling' or 'strength'
    Workout? cyclingWorkout,
    StrengthWorkout? strengthWorkout,
    required DateTime scheduledDate,
    int? scheduledTimeMinutes,
    required ScheduledWorkoutStatus status,
    String? completedSessionId,
    required DateTime createdAt,
  }) = _ScheduledWorkout;

  // Helper: Get workout name
  String get workoutName {
    if (workoutType == 'cycling' && cyclingWorkout != null) {
      return cyclingWorkout!.name;
    } else if (workoutType == 'strength' && strengthWorkout != null) {
      return strengthWorkout!.name;
    }
    return 'Unknown Workout';
  }

  // Helper: Get workout duration
  int? get estimatedDurationMinutes {
    if (workoutType == 'cycling' && cyclingWorkout != null) {
      return cyclingWorkout!.totalDuration.inMinutes;
    } else if (workoutType == 'strength' && strengthWorkout != null) {
      return strengthWorkout!.estimatedDurationMinutes;
    }
    return null;
  }

  // Helper: Is workout today?
  bool isToday() {
    final now = DateTime.now();
    return scheduledDate.year == now.year &&
        scheduledDate.month == now.month &&
        scheduledDate.day == now.day;
  }

  // Helper: Format time
  String get formattedTime {
    if (scheduledTimeMinutes == null) return 'Ganztägig';
    final hours = scheduledTimeMinutes! ~/ 60;
    final minutes = scheduledTimeMinutes! % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} Uhr';
  }
}
