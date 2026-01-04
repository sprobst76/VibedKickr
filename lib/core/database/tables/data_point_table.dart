import 'package:drift/drift.dart';

import 'training_session_table.dart';

/// Tabelle für einzelne Datenpunkte einer Session
@DataClassName('DataPointEntity')
class DataPoints extends Table {
  // Auto-increment Primary Key
  IntColumn get id => integer().autoIncrement()();

  // Foreign Key zu TrainingSessions
  TextColumn get sessionId =>
      text().references(TrainingSessions, #id, onDelete: KeyAction.cascade)();

  // Zeitstempel (Millisekunden seit Session-Start)
  IntColumn get timestampMs => integer()();

  // Messwerte
  IntColumn get power => integer()();
  IntColumn get cadence => integer().nullable()();
  IntColumn get heartRate => integer().nullable()();
  RealColumn get speed => real().nullable()();
  IntColumn get distance => integer().nullable()();
  RealColumn get grade => real().nullable()();
  IntColumn get targetPower => integer().nullable()();

  // Index für schnelle Abfragen nach Session
  @override
  List<Set<Column>> get uniqueKeys => [];
}
