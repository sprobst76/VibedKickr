import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/scheduled_workout_table.dart';

part 'scheduled_workout_dao.g.dart';

@DriftAccessor(tables: [ScheduledWorkouts])
class ScheduledWorkoutDao extends DatabaseAccessor<AppDatabase>
    with _$ScheduledWorkoutDaoMixin {
  ScheduledWorkoutDao(AppDatabase db) : super(db);

  // Get all scheduled workouts
  Stream<List<ScheduledWorkoutEntity>> watchAllScheduledWorkouts() {
    return (select(scheduledWorkouts)
      ..orderBy([
        (t) => OrderingTerm.asc(t.scheduledDate),
        (t) => OrderingTerm.asc(t.scheduledTimeMinutes),
      ]))
        .watch();
  }

  // Get scheduled workouts for specific date
  Future<List<ScheduledWorkoutEntity>> getScheduledWorkoutsForDate(
    DateTime date,
  ) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(scheduledWorkouts)
      ..where((t) =>
          t.scheduledDate.isBiggerOrEqualValue(startOfDay) &
          t.scheduledDate.isSmallerThanValue(endOfDay))
      ..orderBy([(t) => OrderingTerm.asc(t.scheduledTimeMinutes)]))
        .get();
  }

  // Get scheduled workouts in date range
  Future<List<ScheduledWorkoutEntity>> getScheduledWorkoutsInRange(
    DateTime start,
    DateTime end,
  ) {
    return (select(scheduledWorkouts)
      ..where((t) =>
          t.scheduledDate.isBiggerOrEqualValue(start) &
          t.scheduledDate.isSmallerOrEqualValue(end))
      ..orderBy([
        (t) => OrderingTerm.asc(t.scheduledDate),
        (t) => OrderingTerm.asc(t.scheduledTimeMinutes),
      ]))
        .get();
  }

  // Get pending workouts only
  Stream<List<ScheduledWorkoutEntity>> watchPendingScheduledWorkouts() {
    return (select(scheduledWorkouts)
      ..where((t) => t.status.equals('pending'))
      ..orderBy([
        (t) => OrderingTerm.asc(t.scheduledDate),
        (t) => OrderingTerm.asc(t.scheduledTimeMinutes),
      ]))
        .watch();
  }

  // Insert scheduled workout
  Future<int> insertScheduledWorkout(ScheduledWorkoutEntity entity) {
    return into(scheduledWorkouts).insert(entity);
  }

  // Update scheduled workout
  Future<bool> updateScheduledWorkout(ScheduledWorkoutEntity entity) {
    return update(scheduledWorkouts).replace(entity);
  }

  // Delete scheduled workout
  Future<int> deleteScheduledWorkout(String id) {
    return (delete(scheduledWorkouts)..where((t) => t.id.equals(id))).go();
  }

  // Mark as completed
  Future<void> markAsCompleted(String id, String sessionId) {
    return (update(scheduledWorkouts)..where((t) => t.id.equals(id))).write(
      ScheduledWorkoutsCompanion(
        status: const Value('completed'),
        completedSessionId: Value(sessionId),
      ),
    );
  }

  // Mark as skipped
  Future<void> markAsSkipped(String id) {
    return (update(scheduledWorkouts)..where((t) => t.id.equals(id))).write(
      const ScheduledWorkoutsCompanion(
        status: Value('skipped'),
      ),
    );
  }
}
