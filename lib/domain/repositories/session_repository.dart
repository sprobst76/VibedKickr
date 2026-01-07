import '../entities/training_session.dart';

/// Repository Interface für Training Sessions
abstract class SessionRepository {
  /// Speichert eine neue Session mit allen DataPoints
  Future<void> saveSession(TrainingSession session);

  /// Aktualisiert eine bestehende Session
  Future<void> updateSession(TrainingSession session);

  /// Löscht eine Session mit allen DataPoints
  Future<void> deleteSession(String id);

  /// Ruft eine einzelne Session mit DataPoints ab
  Future<TrainingSession?> getSession(String id);

  /// Alias für getSession (für Kompatibilität)
  Future<TrainingSession?> getSessionById(String id);

  /// Ruft eine Session nur mit Metadaten ab (ohne DataPoints)
  Future<TrainingSession?> getSessionMetadata(String id);

  /// Ruft alle Sessions ab (nur Metadaten, ohne DataPoints)
  Future<List<TrainingSession>> getAllSessions();

  /// Watch alle Sessions (reaktiv, für UI-Updates)
  Stream<List<TrainingSession>> watchAllSessions();

  /// Ruft Sessions paginiert ab
  Future<List<TrainingSession>> getSessionsPaginated({
    required int limit,
    required int offset,
  });

  /// Ruft Sessions in einem Zeitraum ab
  Future<List<TrainingSession>> getSessionsInRange(DateTime start, DateTime end);

  /// Anzahl aller Sessions
  Future<int> getSessionCount();

  /// Gesamt-TSS der letzten X Tage
  Future<int> getTotalTssLastDays(int days);

  /// Gesamt-Trainingszeit der letzten X Tage
  Future<Duration> getTotalDurationLastDays(int days);
}
