import 'package:drift/drift.dart';

/// Tabelle für Kraft-Übungen
@DataClassName('StrengthExerciseEntity')
class StrengthExercises extends Table {
  /// Eindeutige ID
  TextColumn get id => text()();

  /// Name der Übung
  TextColumn get name => text()();

  /// Beschreibung
  TextColumn get description => text()();

  /// Primäre Muskelgruppen als JSON Array
  TextColumn get primaryMusclesJson => text()();

  /// Sekundäre Muskelgruppen als JSON Array
  TextColumn get secondaryMusclesJson => text()();

  /// Equipment-Typ
  TextColumn get equipment => text()();

  /// Form-Hinweise
  TextColumn get formCues => text()();

  /// Video URL (optional)
  TextColumn get videoUrl => text().nullable()();

  /// Schwierigkeitsgrad
  TextColumn get difficulty => text()();

  /// Ist es eine Compound-Übung?
  BoolColumn get isCompound => boolean().withDefault(const Constant(false))();

  /// Minimum Alter für diese Übung
  IntColumn get minimumAge => integer().withDefault(const Constant(18))();

  /// Maximum Alter (optional)
  IntColumn get maximumAge => integer().nullable()();

  /// Benötigt Modifikation für 50+?
  BoolColumn get requiresModification50Plus =>
      boolean().withDefault(const Constant(false))();

  /// Modifikations-Notizen für 50+
  TextColumn get modification50PlusNotes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
