import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/training_session_table.dart';
import 'tables/data_point_table.dart';
import 'tables/custom_workout_table.dart';
import 'tables/gpx_route_table.dart';
import 'tables/personal_record_table.dart';
import 'tables/strength_exercise_table.dart';
import 'tables/strength_workout_table.dart';
import 'tables/strength_session_table.dart';
import 'tables/strength_pr_table.dart';
import 'tables/scheduled_workout_table.dart';
import 'tables/morning_recovery_table.dart';
import 'daos/session_dao.dart';
import 'daos/workout_dao.dart';
import 'daos/gpx_route_dao.dart';
import 'daos/personal_record_dao.dart';
import 'daos/strength_exercise_dao.dart';
import 'daos/strength_workout_dao.dart';
import 'daos/strength_session_dao.dart';
import 'daos/strength_pr_dao.dart';
import 'daos/scheduled_workout_dao.dart';
import 'daos/morning_recovery_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    TrainingSessions,
    DataPoints,
    CustomWorkouts,
    GpxRoutes,
    PersonalRecords,
    StrengthExercises,
    StrengthWorkouts,
    StrengthSessions,
    StrengthPersonalRecords,
    ScheduledWorkouts,
    MorningRecoveryScores,
  ],
  daos: [
    SessionDao,
    WorkoutDao,
    GpxRouteDao,
    PersonalRecordDao,
    StrengthExerciseDao,
    StrengthWorkoutDao,
    StrengthSessionDao,
    StrengthPRDao,
    ScheduledWorkoutDao,
    MorningRecoveryDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // Für Tests
  AppDatabase.forTesting(super.e);

  // DAO Getter
  @override
  SessionDao get sessionDao => SessionDao(this);
  @override
  WorkoutDao get workoutDao => WorkoutDao(this);
  @override
  GpxRouteDao get gpxRouteDao => GpxRouteDao(this);
  @override
  PersonalRecordDao get personalRecordDao => PersonalRecordDao(this);
  @override
  StrengthExerciseDao get strengthExerciseDao => StrengthExerciseDao(this);
  @override
  StrengthWorkoutDao get strengthWorkoutDao => StrengthWorkoutDao(this);
  @override
  StrengthSessionDao get strengthSessionDao => StrengthSessionDao(this);
  @override
  StrengthPRDao get strengthPRDao => StrengthPRDao(this);
  @override
  ScheduledWorkoutDao get scheduledWorkoutDao => ScheduledWorkoutDao(this);
  @override
  MorningRecoveryDao get morningRecoveryDao => MorningRecoveryDao(this);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        // Create indexes for new tables
        await customStatement(
          'CREATE INDEX idx_scheduled_workouts_date ON scheduled_workouts(scheduled_date);',
        );
        await customStatement(
          'CREATE INDEX idx_scheduled_workouts_status ON scheduled_workouts(status);',
        );
        await customStatement(
          'CREATE INDEX idx_morning_recovery_date ON morning_recovery_scores(date);',
        );
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // v1 → v2: Add strength training tables
        if (from < 2) {
          await m.create(strengthExercises);
          await m.create(strengthWorkouts);
          await m.create(strengthSessions);
          await m.create(strengthPersonalRecords);
        }
        // v2 → v3: Add scheduled workouts table
        if (from < 3) {
          await m.create(scheduledWorkouts);
          await customStatement(
            'CREATE INDEX idx_scheduled_workouts_date ON scheduled_workouts(scheduled_date);',
          );
          await customStatement(
            'CREATE INDEX idx_scheduled_workouts_status ON scheduled_workouts(status);',
          );
        }
        // v3 → v4: Add morning recovery scores table
        if (from < 4) {
          await m.create(morningRecoveryScores);
          await customStatement(
            'CREATE INDEX idx_morning_recovery_date ON morning_recovery_scores(date);',
          );
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'kickr_trainer.db'));
    return NativeDatabase.createInBackground(file);
  });
}
