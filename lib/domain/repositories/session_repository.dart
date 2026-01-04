import '../entities/training_session.dart';

/// Repository Interface für Training Sessions
abstract class SessionRepository {
  /// Alle Sessions abrufen (ohne DataPoints)
  Future<List<TrainingSession>> getAllSessions();

  /// Session nach ID abrufen (mit DataPoints)
  Future<TrainingSession?> getSessionById(String id);

  /// Sessions innerhalb eines Zeitraums
  Future<List<TrainingSession>> getSessionsInRange(DateTime start, DateTime end);

  /// Session speichern (mit allen DataPoints)
  Future<void> saveSession(TrainingSession session);

  /// Session aktualisieren (ohne DataPoints)
  Future<void> updateSession(TrainingSession session);

  /// Session löschen
  Future<void> deleteSession(String id);

  /// Anzahl der Sessions
  Future<int> getSessionCount();

  /// Gesamte Trainingszeit in Millisekunden
  Future<int> getTotalTrainingTimeMs();

  /// Sessions als Stream beobachten
  Stream<List<TrainingSession>> watchAllSessions();
}
