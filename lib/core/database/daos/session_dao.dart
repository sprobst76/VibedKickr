import 'package:drift/drift.dart';

import '../app_database.dart';

/// Data Access Object für Training Sessions
class SessionDao {
  final AppDatabase _db;

  SessionDao(this._db);

  // === Sessions ===

  /// Alle Sessions abrufen, neueste zuerst
  Future<List<TrainingSessionEntity>> getAllSessions() async {
    return (_db.select(_db.trainingSessions)
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)]))
        .get();
  }

  /// Session nach ID abrufen
  Future<TrainingSessionEntity?> getSessionById(String id) async {
    return (_db.select(_db.trainingSessions)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Sessions innerhalb eines Zeitraums
  Future<List<TrainingSessionEntity>> getSessionsInRange(
    DateTime start,
    DateTime end,
  ) async {
    return (_db.select(_db.trainingSessions)
          ..where((t) => t.startTime.isBetweenValues(
                start.millisecondsSinceEpoch,
                end.millisecondsSinceEpoch,
              ))
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)]))
        .get();
  }

  /// Session einfügen
  Future<void> insertSession(TrainingSessionsCompanion session) async {
    await _db.into(_db.trainingSessions).insert(session);
  }

  /// Session aktualisieren
  Future<void> updateSession(TrainingSessionsCompanion session) async {
    await (_db.update(_db.trainingSessions)
          ..where((t) => t.id.equals(session.id.value)))
        .write(session);
  }

  /// Session löschen (DataPoints werden durch CASCADE gelöscht)
  Future<void> deleteSession(String id) async {
    await (_db.delete(_db.trainingSessions)..where((t) => t.id.equals(id))).go();
  }

  // === DataPoints ===

  /// Alle DataPoints einer Session
  Future<List<DataPointEntity>> getDataPointsForSession(String sessionId) async {
    return (_db.select(_db.dataPoints)
          ..where((t) => t.sessionId.equals(sessionId))
          ..orderBy([(t) => OrderingTerm.asc(t.timestampMs)]))
        .get();
  }

  /// Batch-Insert für DataPoints (effizient für viele Punkte)
  Future<void> insertDataPoints(List<DataPointsCompanion> points) async {
    await _db.batch((b) {
      b.insertAll(_db.dataPoints, points);
    });
  }

  /// DataPoints einer Session löschen
  Future<void> deleteDataPointsForSession(String sessionId) async {
    await (_db.delete(_db.dataPoints)..where((t) => t.sessionId.equals(sessionId)))
        .go();
  }

  // === Kombinierte Operationen ===

  /// Session mit allen DataPoints speichern (Transaktion)
  Future<void> saveSessionWithDataPoints(
    TrainingSessionsCompanion session,
    List<DataPointsCompanion> points,
  ) async {
    await _db.transaction(() async {
      await _db.into(_db.trainingSessions).insert(session);
      if (points.isNotEmpty) {
        await _db.batch((b) {
          b.insertAll(_db.dataPoints, points);
        });
      }
    });
  }

  /// Anzahl der Sessions
  Future<int> getSessionCount() async {
    final count = _db.trainingSessions.id.count();
    final query = _db.selectOnly(_db.trainingSessions)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Gesamte Trainingszeit
  Future<int> getTotalTrainingTimeMs() async {
    final sum = _db.trainingSessions.statsDurationMs.sum();
    final query = _db.selectOnly(_db.trainingSessions)..addColumns([sum]);
    final result = await query.getSingle();
    return result.read(sum) ?? 0;
  }

  /// Sessions als Stream (für Live-Updates)
  Stream<List<TrainingSessionEntity>> watchAllSessions() {
    return (_db.select(_db.trainingSessions)
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)]))
        .watch();
  }
}
