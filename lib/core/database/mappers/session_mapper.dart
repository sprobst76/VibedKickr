import 'dart:convert';

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../../../domain/entities/training_session.dart' as domain;

/// Mapper zwischen Domain-Entities und Drift-Modellen
class SessionMapper {
  /// Domain TrainingSession → Drift Companion
  static TrainingSessionsCompanion toCompanion(domain.TrainingSession session) {
    return TrainingSessionsCompanion(
      id: Value(session.id),
      startTime: Value(session.startTime.millisecondsSinceEpoch),
      endTime: Value(session.endTime?.millisecondsSinceEpoch),
      sessionType: Value(session.type.name),
      workoutId: Value(session.workoutId),
      routeId: Value(session.routeId),
      // SessionStats
      statsDurationMs: Value(session.stats?.duration.inMilliseconds ?? 0),
      statsAvgPower: Value(session.stats?.avgPower ?? 0),
      statsMaxPower: Value(session.stats?.maxPower ?? 0),
      statsNormalizedPower: Value(session.stats?.normalizedPower ?? 0),
      statsIntensityFactor: Value(session.stats?.intensityFactor ?? 0.0),
      statsTss: Value(session.stats?.tss ?? 0),
      statsTotalWork: Value(session.stats?.totalWork ?? 0),
      statsAvgCadence: Value(session.stats?.avgCadence),
      statsMaxCadence: Value(session.stats?.maxCadence),
      statsAvgHeartRate: Value(session.stats?.avgHeartRate),
      statsMaxHeartRate: Value(session.stats?.maxHeartRate),
      statsCalories: Value(session.stats?.calories),
      statsDistance: Value(session.stats?.distance),
      // Sync Status
      syncStatusJson: Value(jsonEncode(
        session.syncStatus.map((k, v) => MapEntry(k, v.name)),
      )),
    );
  }

  /// Drift TrainingSessionEntity → Domain TrainingSession
  static domain.TrainingSession fromDbSession(
    TrainingSessionEntity dbSession, {
    List<domain.DataPoint> dataPoints = const [],
  }) {
    // Parse sync status
    final syncStatusMap = <String, domain.SyncStatus>{};
    try {
      final decoded = jsonDecode(dbSession.syncStatusJson) as Map<String, dynamic>;
      for (final entry in decoded.entries) {
        syncStatusMap[entry.key] = domain.SyncStatus.values.firstWhere(
          (s) => s.name == entry.value,
          orElse: () => domain.SyncStatus.notSynced,
        );
      }
    } catch (_) {
      // Ignore JSON parsing errors
    }

    // Parse session type
    final sessionType = domain.SessionType.values.firstWhere(
      (t) => t.name == dbSession.sessionType,
      orElse: () => domain.SessionType.freeRide,
    );

    // Build stats if present
    domain.SessionStats? stats;
    if (dbSession.statsDurationMs > 0 || dbSession.statsAvgPower > 0) {
      stats = domain.SessionStats(
        duration: Duration(milliseconds: dbSession.statsDurationMs),
        avgPower: dbSession.statsAvgPower,
        maxPower: dbSession.statsMaxPower,
        normalizedPower: dbSession.statsNormalizedPower,
        intensityFactor: dbSession.statsIntensityFactor,
        tss: dbSession.statsTss,
        totalWork: dbSession.statsTotalWork,
        avgCadence: dbSession.statsAvgCadence,
        maxCadence: dbSession.statsMaxCadence,
        avgHeartRate: dbSession.statsAvgHeartRate,
        maxHeartRate: dbSession.statsMaxHeartRate,
        calories: dbSession.statsCalories,
        distance: dbSession.statsDistance,
      );
    }

    return domain.TrainingSession(
      id: dbSession.id,
      startTime: DateTime.fromMillisecondsSinceEpoch(dbSession.startTime),
      endTime: dbSession.endTime != null
          ? DateTime.fromMillisecondsSinceEpoch(dbSession.endTime!)
          : null,
      type: sessionType,
      workoutId: dbSession.workoutId,
      routeId: dbSession.routeId,
      dataPoints: dataPoints,
      stats: stats,
      syncStatus: syncStatusMap,
    );
  }

  /// Domain DataPoint → Drift Companion
  static DataPointsCompanion dataPointToCompanion(
    String sessionId,
    domain.DataPoint point,
  ) {
    return DataPointsCompanion(
      sessionId: Value(sessionId),
      timestampMs: Value(point.timestamp),
      power: Value(point.power),
      cadence: Value(point.cadence),
      heartRate: Value(point.heartRate),
      speed: Value(point.speed),
      distance: Value(point.distance),
      grade: Value(point.grade),
      targetPower: Value(point.targetPower),
    );
  }

  /// Drift DataPointEntity → Domain DataPoint
  static domain.DataPoint fromDbDataPoint(DataPointEntity dbPoint) {
    return domain.DataPoint(
      timestamp: dbPoint.timestampMs,
      power: dbPoint.power,
      cadence: dbPoint.cadence,
      heartRate: dbPoint.heartRate,
      speed: dbPoint.speed,
      distance: dbPoint.distance,
      grade: dbPoint.grade,
      targetPower: dbPoint.targetPower,
    );
  }

  /// Liste von Domain DataPoints → Liste von Drift Companions
  static List<DataPointsCompanion> dataPointsToCompanions(
    String sessionId,
    List<domain.DataPoint> points,
  ) {
    return points.map((p) => dataPointToCompanion(sessionId, p)).toList();
  }

  /// Liste von Drift DataPointEntities → Liste von Domain DataPoints
  static List<domain.DataPoint> fromDbDataPoints(List<DataPointEntity> dbPoints) {
    return dbPoints.map(fromDbDataPoint).toList();
  }
}
