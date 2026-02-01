import 'package:drift/drift.dart';

/// Tabelle für Kraft-Training Sessions
@DataClassName('StrengthSessionEntity')
class StrengthSessions extends Table {
  /// Eindeutige ID
  TextColumn get id => text()();

  /// Start-Zeitpunkt (Millisekunden seit Epoch)
  IntColumn get startTimeMs => integer()();

  /// End-Zeitpunkt (optional, Millisekunden seit Epoch)
  IntColumn get endTimeMs => integer().nullable()();

  /// Link zum Workout (optional)
  TextColumn get workoutId => text().nullable()();

  /// Übungen mit ihren Sets als JSON Array (StrengthExerciseRecord objects)
  TextColumn get exercisesJson => text()();

  /// Session Stats: Gesamtdauer in Sekunden
  IntColumn get statsDurationSecs => integer().withDefault(const Constant(0))();

  /// Session Stats: Gesamtanzahl Sets
  IntColumn get statsTotalSets => integer().withDefault(const Constant(0))();

  /// Session Stats: Gesamtanzahl Wiederholungen
  IntColumn get statsTotalReps => integer().withDefault(const Constant(0))();

  /// Session Stats: Gesamtvolumen (kg)
  RealColumn get statsTotalVolume =>
      real().withDefault(const Constant(0.0))();

  /// Session Stats: Durchschnittliches RPE
  IntColumn get statsAvgRpe => integer().nullable()();

  /// Session Stats: Anzahl absolvierter Übungen
  IntColumn get statsExercisesCompleted =>
      integer().withDefault(const Constant(0))();

  /// Session Stats: Volumen pro Muskelgruppe als JSON Object
  TextColumn get statsMuscleGroupWorkJson =>
      text().withDefault(const Constant('{}'))();

  /// Notizen zur Session
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
