import 'dart:math';

import 'package:gpx/gpx.dart';

import '../../domain/entities/gpx_route.dart';

/// Service zum Parsen von GPX-Dateien
class GpxParser {
  /// Parst eine GPX-Datei und gibt eine Route zurück
  static GpxRoute? parseGpx(String gpxContent, {required String id}) {
    try {
      final gpx = GpxReader().fromString(gpxContent);

      // Sammle alle Punkte aus Tracks und Routes
      final allPoints = <Wpt>[];

      // Tracks
      for (final track in gpx.trks) {
        for (final segment in track.trksegs) {
          allPoints.addAll(segment.trkpts);
        }
      }

      // Routes (falls keine Tracks vorhanden)
      if (allPoints.isEmpty) {
        for (final route in gpx.rtes) {
          allPoints.addAll(route.rtepts);
        }
      }

      // Waypoints als Fallback
      if (allPoints.isEmpty) {
        allPoints.addAll(gpx.wpts);
      }

      if (allPoints.isEmpty) return null;

      // Konvertiere zu RoutePoints mit Distanzberechnung
      final routePoints = <RoutePoint>[];
      double cumulativeDistance = 0;

      for (var i = 0; i < allPoints.length; i++) {
        final wpt = allPoints[i];

        if (i > 0) {
          final prevWpt = allPoints[i - 1];
          cumulativeDistance += _calculateDistance(
            prevWpt.lat ?? 0,
            prevWpt.lon ?? 0,
            wpt.lat ?? 0,
            wpt.lon ?? 0,
          );
        }

        routePoints.add(RoutePoint(
          latitude: wpt.lat ?? 0,
          longitude: wpt.lon ?? 0,
          elevation: wpt.ele ?? 0,
          distance: cumulativeDistance,
        ));
      }

      // Punkte vereinfachen wenn zu viele (> 1000)
      final simplifiedPoints = routePoints.length > 1000
          ? _simplifyPoints(routePoints, 500)
          : routePoints;

      // Name aus GPX oder Dateiname
      String name = gpx.metadata?.name ??
          gpx.trks.firstOrNull?.name ??
          gpx.rtes.firstOrNull?.name ??
          'Importierte Route';

      return GpxRoute(
        id: id,
        name: name,
        description: gpx.metadata?.desc,
        points: simplifiedPoints,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Berechnet die Distanz zwischen zwei GPS-Koordinaten (Haversine)
  static double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadius = 6371000.0; // Meter

    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  static double _toRadians(double degrees) => degrees * pi / 180;

  /// Vereinfacht eine Liste von Punkten auf die gewünschte Anzahl
  /// Behält Start, Ende und wichtige Punkte (mit großen Höhenänderungen)
  static List<RoutePoint> _simplifyPoints(
    List<RoutePoint> points,
    int targetCount,
  ) {
    if (points.length <= targetCount) return points;

    final result = <RoutePoint>[points.first];
    final step = (points.length - 1) / (targetCount - 1);

    for (var i = 1; i < targetCount - 1; i++) {
      final index = (i * step).round();
      result.add(points[index]);
    }

    result.add(points.last);
    return result;
  }
}
