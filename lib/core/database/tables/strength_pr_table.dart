import 'package:drift/drift.dart';

/// Tabelle für Kraft-Training Personal Records
@DataClassName('StrengthPREntity')
class StrengthPersonalRecords extends Table {
  /// Auto-increment ID
  IntColumn get id => integer().autoIncrement()();

  /// Übungs-ID (Link zur StrengthExercise)
  TextColumn get exerciseId => text()();

  /// Gewicht in kg
  RealColumn get weightKg => real()();

  /// Wiederholungen (für Tracking: 1RM, 3RM, 5RM, 10RM)
  IntColumn get reps => integer()();

  /// Datum des PR
  DateTimeColumn get achievedAt => dateTime()();

  /// Session-ID (optional, für Verlinkung)
  TextColumn get sessionId => text().nullable()();

  /// Vorheriges PR-Gewicht in kg (optional, für History)
  RealColumn get previousWeightKg => real().nullable()();
}
