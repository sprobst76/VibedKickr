import '../entities/scheduled_workout.dart';

abstract class ScheduledWorkoutRepository {
  Stream<List<ScheduledWorkout>> watchAllScheduledWorkouts();
  Stream<List<ScheduledWorkout>> watchPendingScheduledWorkouts();
  Future<List<ScheduledWorkout>> getScheduledWorkoutsForDate(DateTime date);
  Future<List<ScheduledWorkout>> getScheduledWorkoutsInRange(
    DateTime start,
    DateTime end,
  );
  Future<void> scheduleWorkout({
    required String workoutId,
    required String workoutType,
    required DateTime scheduledDate,
    int? scheduledTimeMinutes,
  });
  Future<void> updateScheduledWorkout(ScheduledWorkout scheduledWorkout);
  Future<void> deleteScheduledWorkout(String id);
  Future<void> markAsCompleted(String id, String sessionId);
  Future<void> markAsSkipped(String id);
}
