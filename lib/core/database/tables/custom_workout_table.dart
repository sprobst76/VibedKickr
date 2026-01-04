import 'package:drift/drift.dart';

/// Tabelle für benutzerdefinierte Workouts
/// Speichert das Workout als JSON für Flexibilität
@DataClassName('CustomWorkoutEntity')
class CustomWorkouts extends Table {
  /// Workout ID (UUID)
  TextColumn get id => text()();

  /// Name des Workouts
  TextColumn get name => text()();

  /// Beschreibung
  TextColumn get description => text().withDefault(const Constant(''))();

  /// Workout-Typ (enum als String)
  TextColumn get workoutType => text()();

  /// Intervalle als JSON
  TextColumn get intervalsJson => text()();

  /// Erstellungsdatum
  DateTimeColumn get createdAt => dateTime()();

  /// Letztes Update
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
