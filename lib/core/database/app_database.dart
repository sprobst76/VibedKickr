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
import 'daos/session_dao.dart';
import 'daos/workout_dao.dart';
import 'daos/gpx_route_dao.dart';
import 'daos/personal_record_dao.dart';
import 'daos/strength_exercise_dao.dart';
import 'daos/strength_workout_dao.dart';
import 'daos/strength_session_dao.dart';
import 'daos/strength_pr_dao.dart';

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
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // v1 → v2: Add strength training tables
        if (from == 1 && to == 2) {
          await m.create(strengthExercises);
          await m.create(strengthWorkouts);
          await m.create(strengthSessions);
          await m.create(strengthPersonalRecords);
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
