import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../domain/entities/gpx_route.dart';
import '../app_database.dart';
import '../tables/gpx_route_table.dart';

part 'gpx_route_dao.g.dart';

@DriftAccessor(tables: [GpxRoutes])
class GpxRouteDao extends DatabaseAccessor<AppDatabase> with _$GpxRouteDaoMixin {
  GpxRouteDao(super.db);

  /// Speichert eine neue Route
  Future<void> insertRoute(GpxRoute route) async {
    await into(gpxRoutes).insert(
      GpxRoutesCompanion.insert(
        id: route.id,
        name: route.name,
        description: Value(route.description),
        pointsJson: _encodePoints(route.points),
        totalDistance: route.totalDistance,
        elevationGain: route.elevationGain,
        createdAt: route.createdAt ?? DateTime.now(),
      ),
    );
  }

  /// Löscht eine Route
  Future<void> deleteRoute(String id) async {
    await (delete(gpxRoutes)..where((t) => t.id.equals(id))).go();
  }

  /// Lädt alle Routen (ohne Punkte für Performance)
  Future<List<GpxRouteSummary>> getAllRoutes() async {
    final entities = await (select(gpxRoutes)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();

    return entities
        .map((e) => GpxRouteSummary(
              id: e.id,
              name: e.name,
              description: e.description,
              totalDistance: e.totalDistance,
              elevationGain: e.elevationGain,
              createdAt: e.createdAt,
            ))
        .toList();
  }

  /// Beobachtet alle Routen
  Stream<List<GpxRouteSummary>> watchAllRoutes() {
    return (select(gpxRoutes)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch()
        .map((entities) => entities
            .map((e) => GpxRouteSummary(
                  id: e.id,
                  name: e.name,
                  description: e.description,
                  totalDistance: e.totalDistance,
                  elevationGain: e.elevationGain,
                  createdAt: e.createdAt,
                ))
            .toList());
  }

  /// Lädt eine einzelne Route mit allen Punkten
  Future<GpxRoute?> getRoute(String id) async {
    final entity =
        await (select(gpxRoutes)..where((t) => t.id.equals(id))).getSingleOrNull();

    if (entity == null) return null;

    return GpxRoute(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      points: _decodePoints(entity.pointsJson),
      createdAt: entity.createdAt,
    );
  }

  /// Kodiert Punkte als JSON
  String _encodePoints(List<RoutePoint> points) {
    return jsonEncode(points.map((p) => p.toJson()).toList());
  }

  /// Dekodiert Punkte aus JSON
  List<RoutePoint> _decodePoints(String json) {
    final list = jsonDecode(json) as List;
    return list
        .map((item) => RoutePoint.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

/// Zusammenfassung einer Route (ohne Punkte)
class GpxRouteSummary {
  final String id;
  final String name;
  final String? description;
  final double totalDistance;
  final double elevationGain;
  final DateTime createdAt;

  const GpxRouteSummary({
    required this.id,
    required this.name,
    this.description,
    required this.totalDistance,
    required this.elevationGain,
    required this.createdAt,
  });

  /// Distanz in km
  double get totalDistanceKm => totalDistance / 1000;
}
