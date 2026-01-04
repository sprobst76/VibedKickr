import 'dart:math' as math;

import 'package:equatable/equatable.dart';

/// Ein einzelner Datenpunkt während des Trainings
class DataPoint extends Equatable {
  final int timestamp; // Millisekunden seit Session-Start
  final int power; // Watt
  final int? cadence; // RPM
  final int? heartRate; // BPM
  final double? speed; // km/h
  final int? distance; // Meter (kumulativ)
  final double? grade; // Steigung in % (für GPX-Modus)
  final int? targetPower; // Soll-Watt

  const DataPoint({
    required this.timestamp,
    required this.power,
    this.cadence,
    this.heartRate,
    this.speed,
    this.distance,
    this.grade,
    this.targetPower,
  });

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp,
        'power': power,
        'cadence': cadence,
        'heartRate': heartRate,
        'speed': speed,
        'distance': distance,
        'grade': grade,
        'targetPower': targetPower,
      };

  factory DataPoint.fromJson(Map<String, dynamic> json) => DataPoint(
        timestamp: json['timestamp'] as int,
        power: json['power'] as int,
        cadence: json['cadence'] as int?,
        heartRate: json['heartRate'] as int?,
        speed: json['speed'] as double?,
        distance: json['distance'] as int?,
        grade: json['grade'] as double?,
        targetPower: json['targetPower'] as int?,
      );

  @override
  List<Object?> get props => [
        timestamp,
        power,
        cadence,
        heartRate,
        speed,
        distance,
        grade,
        targetPower,
      ];
}

/// Statistiken einer Trainingseinheit
class SessionStats extends Equatable {
  final Duration duration;
  final int avgPower;
  final int maxPower;
  final int normalizedPower; // NP
  final double intensityFactor; // IF = NP / FTP
  final int tss; // Training Stress Score
  final int totalWork; // Kilojoules
  final int? avgCadence;
  final int? maxCadence;
  final int? avgHeartRate;
  final int? maxHeartRate;
  final int? calories;
  final double? distance; // Kilometer

  const SessionStats({
    required this.duration,
    required this.avgPower,
    required this.maxPower,
    required this.normalizedPower,
    required this.intensityFactor,
    required this.tss,
    required this.totalWork,
    this.avgCadence,
    this.maxCadence,
    this.avgHeartRate,
    this.maxHeartRate,
    this.calories,
    this.distance,
  });

  /// Berechnet Statistiken aus Datenpunkten
  factory SessionStats.fromDataPoints(
    List<DataPoint> points, {
    required int ftp,
  }) {
    if (points.isEmpty) {
      return SessionStats(
        duration: Duration.zero,
        avgPower: 0,
        maxPower: 0,
        normalizedPower: 0,
        intensityFactor: 0,
        tss: 0,
        totalWork: 0,
      );
    }

    final duration = Duration(milliseconds: points.last.timestamp);
    final powers = points.map((p) => p.power).toList();
    final avgPower = (powers.reduce((a, b) => a + b) / powers.length).round();
    final maxPower = powers.reduce((a, b) => a > b ? a : b);

    // Normalized Power Berechnung (vereinfacht)
    // Rolling 30s average, dann 4. Potenz, Durchschnitt, 4. Wurzel
    final np = _calculateNormalizedPower(points);
    final intensityFactor = ftp > 0 ? np / ftp : 0.0;
    final tss = _calculateTss(np, duration, ftp);
    final totalWork = (avgPower * duration.inSeconds / 1000).round(); // kJ

    // Kadenz
    final cadences = points.where((p) => p.cadence != null).map((p) => p.cadence!);
    final avgCadence = cadences.isNotEmpty
        ? (cadences.reduce((a, b) => a + b) / cadences.length).round()
        : null;
    final maxCadence = cadences.isNotEmpty
        ? cadences.reduce((a, b) => a > b ? a : b)
        : null;

    // Herzfrequenz
    final hrs = points.where((p) => p.heartRate != null).map((p) => p.heartRate!);
    final avgHr =
        hrs.isNotEmpty ? (hrs.reduce((a, b) => a + b) / hrs.length).round() : null;
    final maxHr = hrs.isNotEmpty ? hrs.reduce((a, b) => a > b ? a : b) : null;

    // Distanz
    final lastDistance = points.last.distance;
    final distance = lastDistance != null ? lastDistance / 1000 : null;

    // Kalorien (grobe Schätzung: 1 kJ ≈ 1 kcal / 4.184)
    final calories = (totalWork * 1.1).round();

    return SessionStats(
      duration: duration,
      avgPower: avgPower,
      maxPower: maxPower,
      normalizedPower: np,
      intensityFactor: intensityFactor,
      tss: tss,
      totalWork: totalWork,
      avgCadence: avgCadence,
      maxCadence: maxCadence,
      avgHeartRate: avgHr,
      maxHeartRate: maxHr,
      calories: calories,
      distance: distance,
    );
  }

  static int _calculateNormalizedPower(List<DataPoint> points) {
    if (points.length < 30) {
      final powers = points.map((p) => p.power).toList();
      return (powers.reduce((a, b) => a + b) / powers.length).round();
    }

    // 30-Sekunden Rolling Average
    List<double> rollingAvg = [];
    for (int i = 29; i < points.length; i++) {
      double sum = 0;
      for (int j = i - 29; j <= i; j++) {
        sum += points[j].power;
      }
      rollingAvg.add(sum / 30);
    }

    // 4. Potenz Durchschnitt
    double sum4th = 0;
    for (final avg in rollingAvg) {
      sum4th += avg * avg * avg * avg;
    }

    return math.sqrt(math.sqrt(sum4th / rollingAvg.length)).round();
  }

  static int _calculateTss(int np, Duration duration, int ftp) {
    if (ftp == 0) return 0;
    final intensityFactor = np / ftp;
    final hours = duration.inSeconds / 3600;
    return (hours * intensityFactor * intensityFactor * 100).round();
  }

  Map<String, dynamic> toJson() => {
        'duration': duration.inMilliseconds,
        'avgPower': avgPower,
        'maxPower': maxPower,
        'normalizedPower': normalizedPower,
        'intensityFactor': intensityFactor,
        'tss': tss,
        'totalWork': totalWork,
        'avgCadence': avgCadence,
        'maxCadence': maxCadence,
        'avgHeartRate': avgHeartRate,
        'maxHeartRate': maxHeartRate,
        'calories': calories,
        'distance': distance,
      };

  @override
  List<Object?> get props => [
        duration,
        avgPower,
        maxPower,
        normalizedPower,
        intensityFactor,
        tss,
        totalWork,
        avgCadence,
        maxCadence,
        avgHeartRate,
        maxHeartRate,
        calories,
        distance,
      ];
}

/// Sync-Status für externe Dienste
enum SyncStatus {
  notSynced,
  syncing,
  synced,
  error,
}

/// Session-Typ
enum SessionType {
  workout,
  freeRide,
  ftpTest,
  gpxRoute,
}

/// Komplette Trainingseinheit
class TrainingSession extends Equatable {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final SessionType type;
  final String? workoutId;
  final String? routeId;
  final List<DataPoint> dataPoints;
  final SessionStats? stats;
  final Map<String, SyncStatus> syncStatus; // 'strava' -> SyncStatus.synced

  const TrainingSession({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.type,
    this.workoutId,
    this.routeId,
    this.dataPoints = const [],
    this.stats,
    this.syncStatus = const {},
  });

  TrainingSession copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    SessionType? type,
    String? workoutId,
    String? routeId,
    List<DataPoint>? dataPoints,
    SessionStats? stats,
    Map<String, SyncStatus>? syncStatus,
  }) {
    return TrainingSession(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      type: type ?? this.type,
      workoutId: workoutId ?? this.workoutId,
      routeId: routeId ?? this.routeId,
      dataPoints: dataPoints ?? this.dataPoints,
      stats: stats ?? this.stats,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'type': type.name,
        'workoutId': workoutId,
        'routeId': routeId,
        'dataPoints': dataPoints.map((p) => p.toJson()).toList(),
        'stats': stats?.toJson(),
        'syncStatus': syncStatus.map((k, v) => MapEntry(k, v.name)),
      };

  @override
  List<Object?> get props => [
        id,
        startTime,
        endTime,
        type,
        workoutId,
        routeId,
        dataPoints,
        stats,
        syncStatus,
      ];
}

