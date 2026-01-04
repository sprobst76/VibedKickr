import 'package:drift/drift.dart';

/// Tabelle für Training Sessions
@DataClassName('TrainingSessionEntity')
class TrainingSessions extends Table {
  // Primary Key - UUID
  TextColumn get id => text()();

  // Timestamps
  IntColumn get startTime => integer()(); // Unix timestamp ms
  IntColumn get endTime => integer().nullable()(); // Unix timestamp ms

  // Session Info
  TextColumn get sessionType => text()(); // 'workout', 'freeRide', etc.
  TextColumn get workoutId => text().nullable()();
  TextColumn get routeId => text().nullable()();

  // Eingebettete SessionStats
  IntColumn get statsDurationMs => integer().withDefault(const Constant(0))();
  IntColumn get statsAvgPower => integer().withDefault(const Constant(0))();
  IntColumn get statsMaxPower => integer().withDefault(const Constant(0))();
  IntColumn get statsNormalizedPower =>
      integer().withDefault(const Constant(0))();
  RealColumn get statsIntensityFactor =>
      real().withDefault(const Constant(0.0))();
  IntColumn get statsTss => integer().withDefault(const Constant(0))();
  IntColumn get statsTotalWork => integer().withDefault(const Constant(0))();
  IntColumn get statsAvgCadence => integer().nullable()();
  IntColumn get statsMaxCadence => integer().nullable()();
  IntColumn get statsAvgHeartRate => integer().nullable()();
  IntColumn get statsMaxHeartRate => integer().nullable()();
  IntColumn get statsCalories => integer().nullable()();
  RealColumn get statsDistance => real().nullable()();

  // Sync Status (JSON encoded)
  TextColumn get syncStatusJson =>
      text().withDefault(const Constant('{}'))();

  @override
  Set<Column> get primaryKey => {id};
}
