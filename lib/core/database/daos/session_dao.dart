import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/training_session_table.dart';
import '../tables/data_point_table.dart';

part 'session_dao.g.dart';

@DriftAccessor(tables: [TrainingSessions, DataPoints])
class SessionDao extends DatabaseAccessor<AppDatabase> with _$SessionDaoMixin {
  SessionDao(super.db);

  // ============================================================================
  // Training Sessions CRUD
  // ============================================================================

  /// Alle Sessions abrufen (sortiert nach Startzeit, neueste zuerst)
  Future<List<TrainingSessionEntity>> getAllSessions() {
    return (select(trainingSessions)
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)]))
        .get();
  }

  /// Watch alle Sessions (reaktiv)
  Stream<List<TrainingSessionEntity>> watchAllSessions() {
    return (select(trainingSessions)
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)]))
        .watch();
  }

  /// Sessions mit Limit und Offset (für Pagination)
  Future<List<TrainingSessionEntity>> getSessionsPaginated({
    required int limit,
    required int offset,
  }) {
    return (select(trainingSessions)
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)])
          ..limit(limit, offset: offset))
        .get();
  }

  /// Einzelne Session abrufen
  Future<TrainingSessionEntity?> getSessionById(String id) {
    return (select(trainingSessions)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Session erstellen
  Future<void> insertSession(TrainingSessionsCompanion session) {
    return into(trainingSessions).insert(session);
  }

  /// Session aktualisieren
  Future<bool> updateSession(TrainingSessionsCompanion session) {
    return update(trainingSessions).replace(session);
  }

  /// Session löschen (mit zugehörigen DataPoints)
  Future<void> deleteSession(String id) async {
    // Erst DataPoints löschen
    await (delete(dataPoints)..where((t) => t.sessionId.equals(id))).go();
    // Dann Session löschen
    await (delete(trainingSessions)..where((t) => t.id.equals(id))).go();
  }

  /// Sessions nach Zeitraum abrufen
  Future<List<TrainingSessionEntity>> getSessionsInRange(
    DateTime start,
    DateTime end,
  ) {
    return (select(trainingSessions)
          ..where((t) => t.startTime.isBiggerOrEqualValue(start.millisecondsSinceEpoch))
          ..where((t) => t.startTime.isSmallerOrEqualValue(end.millisecondsSinceEpoch))
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)]))
        .get();
  }

  // ============================================================================
  // Data Points CRUD
  // ============================================================================

  /// Alle DataPoints einer Session abrufen
  Future<List<DataPointEntity>> getDataPointsForSession(String sessionId) {
    return (select(dataPoints)
          ..where((t) => t.sessionId.equals(sessionId))
          ..orderBy([(t) => OrderingTerm.asc(t.timestampMs)]))
        .get();
  }

  /// Einzelnen DataPoint einfügen
  Future<int> insertDataPoint(DataPointsCompanion dataPoint) {
    return into(dataPoints).insert(dataPoint);
  }

  /// Batch-Insert für DataPoints (viel effizienter)
  Future<void> insertDataPointsBatch(List<DataPointsCompanion> points) {
    return batch((batch) {
      batch.insertAll(dataPoints, points);
    });
  }

  /// DataPoints einer Session löschen
  Future<int> deleteDataPointsForSession(String sessionId) {
    return (delete(dataPoints)..where((t) => t.sessionId.equals(sessionId))).go();
  }

  // ============================================================================
  // Statistik-Abfragen
  // ============================================================================

  /// Anzahl aller Sessions
  Future<int> getSessionCount() async {
    final countExp = trainingSessions.id.count();
    final query = selectOnly(trainingSessions)..addColumns([countExp]);
    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  /// Gesamt-TSS der letzten X Tage
  Future<int> getTotalTssLastDays(int days) async {
    final cutoff = DateTime.now().subtract(Duration(days: days)).millisecondsSinceEpoch;
    final tssSum = trainingSessions.statsTss.sum();
    final query = selectOnly(trainingSessions)
      ..addColumns([tssSum])
      ..where(trainingSessions.startTime.isBiggerOrEqualValue(cutoff));
    final result = await query.getSingle();
    return result.read(tssSum)?.toInt() ?? 0;
  }

  /// Gesamt-Trainingszeit der letzten X Tage
  Future<Duration> getTotalDurationLastDays(int days) async {
    final cutoff = DateTime.now().subtract(Duration(days: days)).millisecondsSinceEpoch;
    final durationSum = trainingSessions.statsDurationMs.sum();
    final query = selectOnly(trainingSessions)
      ..addColumns([durationSum])
      ..where(trainingSessions.startTime.isBiggerOrEqualValue(cutoff));
    final result = await query.getSingle();
    return Duration(milliseconds: result.read(durationSum)?.toInt() ?? 0);
  }

  /// Sessions nach Typ zählen
  Future<Map<String, int>> getSessionCountByType() async {
    final query = selectOnly(trainingSessions)
      ..addColumns([trainingSessions.sessionType, trainingSessions.id.count()]);
    query.groupBy([trainingSessions.sessionType]);

    final results = await query.get();
    return {
      for (final row in results)
        row.read(trainingSessions.sessionType)!: row.read(trainingSessions.id.count()) ?? 0,
    };
  }
}
