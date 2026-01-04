import 'dart:math';

import 'package:equatable/equatable.dart';

/// Ein Punkt auf der GPX Route
class RoutePoint extends Equatable {
  final double latitude;
  final double longitude;
  final double elevation; // Meter
  final double distance; // Kumulative Distanz in Metern

  const RoutePoint({
    required this.latitude,
    required this.longitude,
    required this.elevation,
    required this.distance,
  });

  factory RoutePoint.fromJson(Map<String, dynamic> json) {
    return RoutePoint(
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lon'] as num).toDouble(),
      elevation: (json['ele'] as num).toDouble(),
      distance: (json['dist'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'lat': latitude,
        'lon': longitude,
        'ele': elevation,
        'dist': distance,
      };

  @override
  List<Object?> get props => [latitude, longitude, elevation, distance];
}

/// Eine komplette GPX Route
class GpxRoute extends Equatable {
  final String id;
  final String name;
  final String? description;
  final List<RoutePoint> points;
  final DateTime? createdAt;

  const GpxRoute({
    required this.id,
    required this.name,
    this.description,
    required this.points,
    this.createdAt,
  });

  /// Gesamtdistanz in Metern
  double get totalDistance => points.isNotEmpty ? points.last.distance : 0;

  /// Gesamtdistanz in Kilometern
  double get totalDistanceKm => totalDistance / 1000;

  /// Minimale Elevation
  double get minElevation {
    if (points.isEmpty) return 0;
    return points.map((p) => p.elevation).reduce(min);
  }

  /// Maximale Elevation
  double get maxElevation {
    if (points.isEmpty) return 0;
    return points.map((p) => p.elevation).reduce(max);
  }

  /// Höhenmeter aufwärts
  double get elevationGain {
    if (points.length < 2) return 0;
    double gain = 0;
    for (var i = 1; i < points.length; i++) {
      final diff = points[i].elevation - points[i - 1].elevation;
      if (diff > 0) gain += diff;
    }
    return gain;
  }

  /// Höhenmeter abwärts
  double get elevationLoss {
    if (points.length < 2) return 0;
    double loss = 0;
    for (var i = 1; i < points.length; i++) {
      final diff = points[i].elevation - points[i - 1].elevation;
      if (diff < 0) loss += diff.abs();
    }
    return loss;
  }

  /// Durchschnittliche Steigung in %
  double get averageGradient {
    if (totalDistance == 0) return 0;
    return (elevationGain / totalDistance) * 100;
  }

  /// Maximale Steigung in %
  double get maxGradient {
    if (points.length < 2) return 0;
    double maxGrad = 0;
    for (var i = 1; i < points.length; i++) {
      final distDiff = points[i].distance - points[i - 1].distance;
      if (distDiff > 0) {
        final eleDiff = points[i].elevation - points[i - 1].elevation;
        final gradient = (eleDiff / distDiff) * 100;
        if (gradient > maxGrad) maxGrad = gradient;
      }
    }
    return maxGrad;
  }

  /// Findet den Punkt an einer bestimmten Distanz (interpoliert)
  RoutePoint? pointAtDistance(double distance) {
    if (points.isEmpty) return null;
    if (distance <= 0) return points.first;
    if (distance >= totalDistance) return points.last;

    // Finde die zwei Punkte zwischen denen die Distanz liegt
    for (var i = 1; i < points.length; i++) {
      if (points[i].distance >= distance) {
        final prev = points[i - 1];
        final curr = points[i];
        final segmentLength = curr.distance - prev.distance;
        if (segmentLength == 0) return prev;

        final ratio = (distance - prev.distance) / segmentLength;

        return RoutePoint(
          latitude: prev.latitude + (curr.latitude - prev.latitude) * ratio,
          longitude: prev.longitude + (curr.longitude - prev.longitude) * ratio,
          elevation: prev.elevation + (curr.elevation - prev.elevation) * ratio,
          distance: distance,
        );
      }
    }

    return points.last;
  }

  /// Berechnet die Steigung an einer bestimmten Distanz in %
  double gradientAtDistance(double distance, {double lookAhead = 50}) {
    final current = pointAtDistance(distance);
    final ahead = pointAtDistance(distance + lookAhead);

    if (current == null || ahead == null) return 0;

    final distDiff = ahead.distance - current.distance;
    if (distDiff == 0) return 0;

    final eleDiff = ahead.elevation - current.elevation;
    return (eleDiff / distDiff) * 100;
  }

  /// Geschätzte Dauer basierend auf Durchschnittsgeschwindigkeit
  Duration estimatedDuration({double avgSpeedKmh = 25}) {
    final hours = totalDistanceKm / avgSpeedKmh;
    return Duration(minutes: (hours * 60).round());
  }

  factory GpxRoute.fromJson(Map<String, dynamic> json) {
    return GpxRoute(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      points: (json['points'] as List)
          .map((p) => RoutePoint.fromJson(p as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'points': points.map((p) => p.toJson()).toList(),
        'createdAt': createdAt?.millisecondsSinceEpoch,
      };

  @override
  List<Object?> get props => [id, name, description, points, createdAt];
}
