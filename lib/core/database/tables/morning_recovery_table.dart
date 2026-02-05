import 'package:drift/drift.dart';

@DataClassName('MorningRecoveryScoreEntity')
class MorningRecoveryScores extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get peakHr => integer()();
  IntColumn get hrAfter1Min => integer()();
  IntColumn get hrAfter2Min => integer()();
  IntColumn get drop1Min => integer()();
  IntColumn get drop2Min => integer()();
  IntColumn get recoveryScore => integer()(); // 0-100
  TextColumn get assessment => text()();
  TextColumn get sessionId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}
