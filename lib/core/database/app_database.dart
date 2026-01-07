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
import 'daos/session_dao.dart';
import 'daos/workout_dao.dart';
import 'daos/gpx_route_dao.dart';
import 'daos/personal_record_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    TrainingSessions,
    DataPoints,
    CustomWorkouts,
    GpxRoutes,
    PersonalRecords,
  ],
  daos: [
    SessionDao,
    WorkoutDao,
    GpxRouteDao,
    PersonalRecordDao,
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
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Zukünftige Migrationen hier
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
