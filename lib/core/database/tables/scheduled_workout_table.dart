import 'package:drift/drift.dart';

@DataClassName('ScheduledWorkoutEntity')
class ScheduledWorkouts extends Table {
  TextColumn get id => text()();
  TextColumn get workoutId => text()();
  TextColumn get workoutType => text()(); // 'cycling' or 'strength'
  DateTimeColumn get scheduledDate => dateTime()();
  IntColumn get scheduledTimeMinutes => integer().nullable()();
  TextColumn get status => text()(); // 'pending', 'completed', 'skipped'
  TextColumn get completedSessionId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
