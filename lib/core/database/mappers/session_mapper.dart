import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../domain/entities/training_session.dart' as domain;
import '../app_database.dart';

/// Mapper zwischen Drift-Entitäten und Domain-Modellen
class SessionMapper {
  // ============================================================================
  // TrainingSession: DB -> Domain
  // ============================================================================

  static domain.TrainingSession toDomain(
    TrainingSessionEntity dbSession, {
    List<domain.DataPoint>? dataPoints,
  }) {
    return domain.TrainingSession(
      id: dbSession.id,
      startTime: DateTime.fromMillisecondsSinceEpoch(dbSession.startTime),
      endTime: dbSession.endTime != null
          ? DateTime.fromMillisecondsSinceEpoch(dbSession.endTime!)
          : null,
      type: _parseSessionType(dbSession.sessionType),
      workoutId: dbSession.workoutId,
      routeId: dbSession.routeId,
      dataPoints: dataPoints ?? const [],
      stats: _toStats(dbSession),
      syncStatus: _parseSyncStatus(dbSession.syncStatusJson),
    );
  }

  static domain.SessionStats _toStats(TrainingSessionEntity dbSession) {
    return domain.SessionStats(
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

  static domain.SessionType _parseSessionType(String type) {
    return domain.SessionType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => domain.SessionType.freeRide,
    );
  }

  static Map<String, domain.SyncStatus> _parseSyncStatus(String json) {
    try {
      final Map<String, dynamic> decoded = jsonDecode(json);
      return decoded.map((key, value) => MapEntry(
            key,
            domain.SyncStatus.values.firstWhere(
              (e) => e.name == value,
              orElse: () => domain.SyncStatus.notSynced,
            ),
          ));
    } catch (_) {
      return {};
    }
  }

  // ============================================================================
  // TrainingSession: Domain -> DB
  // ============================================================================

  static TrainingSessionsCompanion toCompanion(domain.TrainingSession session) {
    final stats = session.stats;
    return TrainingSessionsCompanion(
      id: Value(session.id),
      startTime: Value(session.startTime.millisecondsSinceEpoch),
      endTime: Value(session.endTime?.millisecondsSinceEpoch),
      sessionType: Value(session.type.name),
      workoutId: Value(session.workoutId),
      routeId: Value(session.routeId),
      statsDurationMs: Value(stats?.duration.inMilliseconds ?? 0),
      statsAvgPower: Value(stats?.avgPower ?? 0),
      statsMaxPower: Value(stats?.maxPower ?? 0),
      statsNormalizedPower: Value(stats?.normalizedPower ?? 0),
      statsIntensityFactor: Value(stats?.intensityFactor ?? 0.0),
      statsTss: Value(stats?.tss ?? 0),
      statsTotalWork: Value(stats?.totalWork ?? 0),
      statsAvgCadence: Value(stats?.avgCadence),
      statsMaxCadence: Value(stats?.maxCadence),
      statsAvgHeartRate: Value(stats?.avgHeartRate),
      statsMaxHeartRate: Value(stats?.maxHeartRate),
      statsCalories: Value(stats?.calories),
      statsDistance: Value(stats?.distance),
      syncStatusJson: Value(_encodeSyncStatus(session.syncStatus)),
    );
  }

  static String _encodeSyncStatus(Map<String, domain.SyncStatus> status) {
    return jsonEncode(status.map((k, v) => MapEntry(k, v.name)));
  }

  // ============================================================================
  // DataPoint: DB -> Domain
  // ============================================================================

  static domain.DataPoint dataPointToDomain(DataPointEntity dbPoint) {
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

  static List<domain.DataPoint> dataPointsToDomain(List<DataPointEntity> dbPoints) {
    return dbPoints.map(dataPointToDomain).toList();
  }

  // ============================================================================
  // DataPoint: Domain -> DB
  // ============================================================================

  static DataPointsCompanion dataPointToCompanion(
    domain.DataPoint point,
    String sessionId,
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

  static List<DataPointsCompanion> dataPointsToCompanions(
    List<domain.DataPoint> points,
    String sessionId,
  ) {
    return points.map((p) => dataPointToCompanion(p, sessionId)).toList();
  }
}
