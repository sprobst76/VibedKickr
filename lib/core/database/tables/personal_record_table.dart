import 'package:drift/drift.dart';

/// Tabelle für Personal Records (beste Leistungswerte)
@DataClassName('PersonalRecordEntity')
class PersonalRecords extends Table {
  /// Auto-increment ID
  IntColumn get id => integer().autoIncrement()();

  /// Typ des PR (5s, 1min, 5min, 20min, etc.)
  TextColumn get recordType => text()();

  /// Power in Watt
  IntColumn get powerWatts => integer()();

  /// Datum des PR
  DateTimeColumn get achievedAt => dateTime()();

  /// Session ID (optional, für Verlinkung)
  TextColumn get sessionId => text().nullable()();

  /// Vorheriger PR (für History)
  IntColumn get previousPowerWatts => integer().nullable()();
}

/// Typen von Personal Records
enum RecordType {
  /// 5 Sekunden Peak Power
  peak5s('5s Peak', Duration(seconds: 5)),

  /// 30 Sekunden Power
  peak30s('30s', Duration(seconds: 30)),

  /// 1 Minute Power
  peak1min('1 Min', Duration(minutes: 1)),

  /// 5 Minuten Power
  peak5min('5 Min', Duration(minutes: 5)),

  /// 10 Minuten Power
  peak10min('10 Min', Duration(minutes: 10)),

  /// 20 Minuten Power (FTP Test)
  peak20min('20 Min', Duration(minutes: 20)),

  /// 60 Minuten Power
  peak60min('60 Min', Duration(minutes: 60));

  final String displayName;
  final Duration duration;

  const RecordType(this.displayName, this.duration);
}
