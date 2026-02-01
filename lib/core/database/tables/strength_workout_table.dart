import 'package:drift/drift.dart';

/// Tabelle für Kraft-Workouts
@DataClassName('StrengthWorkoutEntity')
class StrengthWorkouts extends Table {
  /// Eindeutige ID
  TextColumn get id => text()();

  /// Name des Workouts
  TextColumn get name => text()();

  /// Beschreibung
  TextColumn get description => text()();

  /// Intervalle als JSON Array (StrengthInterval objects)
  TextColumn get intervalsJson => text()();

  /// Workout-Typ
  TextColumn get workoutType => text()();

  /// Geschätzte Dauer in Minuten
  IntColumn get estimatedDurationMinutes => integer()();

  /// Schwierigkeitsgrad
  TextColumn get difficulty => text()();

  /// Ist es ein Custom Workout?
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();

  /// Erstellungsdatum
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
