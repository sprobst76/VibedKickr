import '../../core/database/app_database.dart';
import '../../core/database/mappers/session_mapper.dart';
import '../../domain/entities/training_session.dart';
import '../../domain/repositories/session_repository.dart';

/// Implementierung des SessionRepository mit Drift
class SessionRepositoryImpl implements SessionRepository {
  final AppDatabase _db;

  SessionRepositoryImpl(this._db);

  @override
  Future<void> saveSession(TrainingSession session) async {
    // Session speichern
    await _db.sessionDao.insertSession(
      SessionMapper.toCompanion(session),
    );

    // DataPoints batch-insert
    if (session.dataPoints.isNotEmpty) {
      await _db.sessionDao.insertDataPointsBatch(
        SessionMapper.dataPointsToCompanions(session.dataPoints, session.id),
      );
    }
  }

  @override
  Future<void> updateSession(TrainingSession session) async {
    // Session aktualisieren
    await _db.sessionDao.updateSession(
      SessionMapper.toCompanion(session),
    );

    // DataPoints: alte löschen, neue einfügen
    await _db.sessionDao.deleteDataPointsForSession(session.id);
    if (session.dataPoints.isNotEmpty) {
      await _db.sessionDao.insertDataPointsBatch(
        SessionMapper.dataPointsToCompanions(session.dataPoints, session.id),
      );
    }
  }

  @override
  Future<void> deleteSession(String id) async {
    await _db.sessionDao.deleteSession(id);
  }

  @override
  Future<TrainingSession?> getSession(String id) async {
    final dbSession = await _db.sessionDao.getSessionById(id);
    if (dbSession == null) return null;

    final dbPoints = await _db.sessionDao.getDataPointsForSession(id);
    final domainPoints = SessionMapper.dataPointsToDomain(dbPoints);

    return SessionMapper.toDomain(dbSession, dataPoints: domainPoints);
  }

  @override
  Future<TrainingSession?> getSessionById(String id) => getSession(id);

  @override
  Future<TrainingSession?> getSessionMetadata(String id) async {
    final dbSession = await _db.sessionDao.getSessionById(id);
    if (dbSession == null) return null;

    return SessionMapper.toDomain(dbSession);
  }

  @override
  Future<List<TrainingSession>> getAllSessions() async {
    final dbSessions = await _db.sessionDao.getAllSessions();
    return dbSessions.map((s) => SessionMapper.toDomain(s)).toList();
  }

  @override
  Stream<List<TrainingSession>> watchAllSessions() {
    return _db.sessionDao.watchAllSessions().map(
      (dbSessions) => dbSessions.map((s) => SessionMapper.toDomain(s)).toList(),
    );
  }

  @override
  Future<List<TrainingSession>> getSessionsPaginated({
    required int limit,
    required int offset,
  }) async {
    final dbSessions = await _db.sessionDao.getSessionsPaginated(
      limit: limit,
      offset: offset,
    );
    return dbSessions.map((s) => SessionMapper.toDomain(s)).toList();
  }

  @override
  Future<List<TrainingSession>> getSessionsInRange(
    DateTime start,
    DateTime end,
  ) async {
    final dbSessions = await _db.sessionDao.getSessionsInRange(start, end);
    return dbSessions.map((s) => SessionMapper.toDomain(s)).toList();
  }

  @override
  Future<int> getSessionCount() async {
    return _db.sessionDao.getSessionCount();
  }

  @override
  Future<int> getTotalTssLastDays(int days) async {
    return _db.sessionDao.getTotalTssLastDays(days);
  }

  @override
  Future<Duration> getTotalDurationLastDays(int days) async {
    return _db.sessionDao.getTotalDurationLastDays(days);
  }
}
