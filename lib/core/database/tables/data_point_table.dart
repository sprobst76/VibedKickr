import 'package:drift/drift.dart';

import 'training_session_table.dart';

/// Tabelle für Datenpunkte (Power, Cadence, HR, etc.)
@DataClassName('DataPointEntity')
class DataPoints extends Table {
  // Auto-increment Primary Key
  IntColumn get id => integer().autoIncrement()();

  // Foreign Key zu TrainingSessions
  TextColumn get sessionId => text().references(TrainingSessions, #id)();

  // Zeitstempel (ms seit Session-Start)
  IntColumn get timestampMs => integer()();

  // Messwerte
  IntColumn get power => integer()(); // Watt
  IntColumn get cadence => integer().nullable()(); // RPM
  IntColumn get heartRate => integer().nullable()(); // BPM
  RealColumn get speed => real().nullable()(); // km/h
  IntColumn get distance => integer().nullable()(); // Meter (kumulativ)
  RealColumn get grade => real().nullable()(); // Steigung %
  IntColumn get targetPower => integer().nullable()(); // Soll-Watt
}
