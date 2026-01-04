import '../../core/database/app_database.dart';
import '../../core/database/mappers/session_mapper.dart';
import '../../domain/entities/training_session.dart';
import '../../domain/repositories/session_repository.dart';

/// Implementierung des SessionRepository mit Drift
class SessionRepositoryImpl implements SessionRepository {
  final AppDatabase _db;

  SessionRepositoryImpl(this._db);

  @override
  Future<List<TrainingSession>> getAllSessions() async {
    final dbSessions = await _db.sessionDao.getAllSessions();
    return dbSessions.map((s) => SessionMapper.fromDbSession(s)).toList();
  }

  @override
  Future<TrainingSession?> getSessionById(String id) async {
    final dbSession = await _db.sessionDao.getSessionById(id);
    if (dbSession == null) return null;

    // DataPoints laden
    final dbPoints = await _db.sessionDao.getDataPointsForSession(id);
    final dataPoints = SessionMapper.fromDbDataPoints(dbPoints);

    return SessionMapper.fromDbSession(dbSession, dataPoints: dataPoints);
  }

  @override
  Future<List<TrainingSession>> getSessionsInRange(
    DateTime start,
    DateTime end,
  ) async {
    final dbSessions = await _db.sessionDao.getSessionsInRange(start, end);
    return dbSessions.map((s) => SessionMapper.fromDbSession(s)).toList();
  }

  @override
  Future<void> saveSession(TrainingSession session) async {
    final sessionCompanion = SessionMapper.toCompanion(session);
    final pointCompanions = SessionMapper.dataPointsToCompanions(
      session.id,
      session.dataPoints,
    );

    await _db.sessionDao.saveSessionWithDataPoints(
      sessionCompanion,
      pointCompanions,
    );
  }

  @override
  Future<void> updateSession(TrainingSession session) async {
    final companion = SessionMapper.toCompanion(session);
    await _db.sessionDao.updateSession(companion);
  }

  @override
  Future<void> deleteSession(String id) async {
    await _db.sessionDao.deleteSession(id);
  }

  @override
  Future<int> getSessionCount() async {
    return _db.sessionDao.getSessionCount();
  }

  @override
  Future<int> getTotalTrainingTimeMs() async {
    return _db.sessionDao.getTotalTrainingTimeMs();
  }

  @override
  Stream<List<TrainingSession>> watchAllSessions() {
    return _db.sessionDao.watchAllSessions().map(
          (dbSessions) =>
              dbSessions.map((s) => SessionMapper.fromDbSession(s)).toList(),
        );
  }
}
