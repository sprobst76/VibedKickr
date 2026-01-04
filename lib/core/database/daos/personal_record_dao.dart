import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/personal_record_table.dart';

part 'personal_record_dao.g.dart';

/// Domain-Modell für Personal Records
class PersonalRecord {
  final int? id;
  final RecordType recordType;
  final int powerWatts;
  final DateTime achievedAt;
  final String? sessionId;
  final int? previousPowerWatts;

  const PersonalRecord({
    this.id,
    required this.recordType,
    required this.powerWatts,
    required this.achievedAt,
    this.sessionId,
    this.previousPowerWatts,
  });

  /// Verbesserung gegenüber dem vorherigen PR
  int? get improvement =>
      previousPowerWatts != null ? powerWatts - previousPowerWatts! : null;

  /// Prozentuale Verbesserung
  double? get improvementPercent => previousPowerWatts != null
      ? ((powerWatts - previousPowerWatts!) / previousPowerWatts! * 100)
      : null;
}

@DriftAccessor(tables: [PersonalRecords])
class PersonalRecordDao extends DatabaseAccessor<AppDatabase>
    with _$PersonalRecordDaoMixin {
  PersonalRecordDao(super.db);

  /// Speichert einen neuen PR
  Future<int> insertRecord(PersonalRecord record) async {
    return await into(personalRecords).insert(
      PersonalRecordsCompanion.insert(
        recordType: record.recordType.name,
        powerWatts: record.powerWatts,
        achievedAt: record.achievedAt,
        sessionId: Value(record.sessionId),
        previousPowerWatts: Value(record.previousPowerWatts),
      ),
    );
  }

  /// Lädt den aktuellen PR für einen Typ
  Future<PersonalRecord?> getCurrentRecord(RecordType type) async {
    final entity = await (select(personalRecords)
          ..where((t) => t.recordType.equals(type.name))
          ..orderBy([(t) => OrderingTerm.desc(t.powerWatts)])
          ..limit(1))
        .getSingleOrNull();

    return entity != null ? _entityToRecord(entity) : null;
  }

  /// Lädt alle aktuellen PRs
  Future<Map<RecordType, PersonalRecord>> getAllCurrentRecords() async {
    final records = <RecordType, PersonalRecord>{};

    for (final type in RecordType.values) {
      final record = await getCurrentRecord(type);
      if (record != null) {
        records[type] = record;
      }
    }

    return records;
  }

  /// Beobachtet alle aktuellen PRs
  Stream<Map<RecordType, PersonalRecord>> watchAllCurrentRecords() {
    return select(personalRecords).watch().asyncMap((_) async {
      return getAllCurrentRecords();
    });
  }

  /// Lädt die PR-History für einen Typ
  Future<List<PersonalRecord>> getRecordHistory(RecordType type,
      {int limit = 10}) async {
    final entities = await (select(personalRecords)
          ..where((t) => t.recordType.equals(type.name))
          ..orderBy([(t) => OrderingTerm.desc(t.achievedAt)])
          ..limit(limit))
        .get();

    return entities.map(_entityToRecord).toList();
  }

  /// Prüft ob ein neuer Wert ein PR ist
  Future<bool> isNewRecord(RecordType type, int powerWatts) async {
    final current = await getCurrentRecord(type);
    return current == null || powerWatts > current.powerWatts;
  }

  /// Konvertiert eine Entity zu einem Domain-Objekt
  PersonalRecord _entityToRecord(PersonalRecordEntity entity) {
    return PersonalRecord(
      id: entity.id,
      recordType: RecordType.values.firstWhere(
        (t) => t.name == entity.recordType,
        orElse: () => RecordType.peak5s,
      ),
      powerWatts: entity.powerWatts,
      achievedAt: entity.achievedAt,
      sessionId: entity.sessionId,
      previousPowerWatts: entity.previousPowerWatts,
    );
  }
}
