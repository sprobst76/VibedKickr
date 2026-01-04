import 'package:drift/drift.dart';

/// Tabelle für GPX Routen
@DataClassName('GpxRouteEntity')
class GpxRoutes extends Table {
  /// Route ID (UUID)
  TextColumn get id => text()();

  /// Name der Route
  TextColumn get name => text()();

  /// Beschreibung
  TextColumn get description => text().nullable()();

  /// Punkte als JSON
  TextColumn get pointsJson => text()();

  /// Gesamtdistanz in Metern
  RealColumn get totalDistance => real()();

  /// Höhenmeter aufwärts
  RealColumn get elevationGain => real()();

  /// Erstellungsdatum
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
