import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/gpx_route.dart';
import '../../domain/entities/training_session.dart';
import '../../providers/providers.dart';
import '../database/daos/gpx_route_dao.dart';
import 'gpx_parser.dart';

/// Service für GPX Routen
class GpxRouteService {
  final GpxRouteDao _dao;

  GpxRouteService(this._dao);

  /// Importiert eine GPX-Datei
  Future<GpxRoute?> importGpx(String gpxContent, {String? customName}) async {
    final id = const Uuid().v4();
    final route = GpxParser.parseGpx(gpxContent, id: id);

    if (route == null) return null;

    // Optionaler Custom-Name
    final finalRoute = customName != null
        ? GpxRoute(
            id: route.id,
            name: customName,
            description: route.description,
            points: route.points,
            createdAt: route.createdAt,
          )
        : route;

    await _dao.insertRoute(finalRoute);
    return finalRoute;
  }

  /// Lädt alle Routen (Zusammenfassungen)
  Future<List<GpxRouteSummary>> getAllRoutes() async {
    return _dao.getAllRoutes();
  }

  /// Beobachtet alle Routen
  Stream<List<GpxRouteSummary>> watchAllRoutes() {
    return _dao.watchAllRoutes();
  }

  /// Lädt eine einzelne Route mit allen Punkten
  Future<GpxRoute?> getRoute(String id) async {
    return _dao.getRoute(id);
  }

  /// Löscht eine Route
  Future<void> deleteRoute(String id) async {
    await _dao.deleteRoute(id);
  }
}

/// Provider für den GPX Route Service
final gpxRouteServiceProvider = Provider<GpxRouteService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return GpxRouteService(db.gpxRouteDao);
});

/// Provider für alle Routen
final gpxRoutesProvider = StreamProvider<List<GpxRouteSummary>>((ref) {
  final service = ref.watch(gpxRouteServiceProvider);
  return service.watchAllRoutes();
});

/// Provider für eine einzelne Route
final gpxRouteProvider = FutureProvider.family<GpxRoute?, String>((ref, id) {
  final service = ref.watch(gpxRouteServiceProvider);
  return service.getRoute(id);
});

// ============================================================================
// Route Player
// ============================================================================

/// Status des Route Players
enum RoutePlayerState {
  idle,
  ready,
  running,
  paused,
  finished,
}

/// Daten des Route Players
class RoutePlayerData {
  final RoutePlayerState state;
  final GpxRoute? route;
  final double currentDistance; // Meter
  final double currentElevation; // Meter
  final double currentGradient; // %
  final Duration elapsed;
  final int currentTargetPower; // Watt (berechnet aus Gradient)

  const RoutePlayerData({
    this.state = RoutePlayerState.idle,
    this.route,
    this.currentDistance = 0,
    this.currentElevation = 0,
    this.currentGradient = 0,
    this.elapsed = Duration.zero,
    this.currentTargetPower = 0,
  });

  double get progress =>
      route != null && route!.totalDistance > 0
          ? currentDistance / route!.totalDistance
          : 0;

  double get remainingDistance =>
      route != null ? route!.totalDistance - currentDistance : 0;

  double get remainingDistanceKm => remainingDistance / 1000;

  RoutePlayerData copyWith({
    RoutePlayerState? state,
    GpxRoute? route,
    double? currentDistance,
    double? currentElevation,
    double? currentGradient,
    Duration? elapsed,
    int? currentTargetPower,
  }) {
    return RoutePlayerData(
      state: state ?? this.state,
      route: route ?? this.route,
      currentDistance: currentDistance ?? this.currentDistance,
      currentElevation: currentElevation ?? this.currentElevation,
      currentGradient: currentGradient ?? this.currentGradient,
      elapsed: elapsed ?? this.elapsed,
      currentTargetPower: currentTargetPower ?? this.currentTargetPower,
    );
  }
}

/// Route Player Provider
final routePlayerProvider =
    StateNotifierProvider<RoutePlayerNotifier, RoutePlayerData>((ref) {
  final notifier = RoutePlayerNotifier(ref);
  ref.onDispose(() => notifier.dispose());
  return notifier;
});

/// Route Player Notifier
class RoutePlayerNotifier extends StateNotifier<RoutePlayerData> {
  final Ref _ref;
  Timer? _timer;
  DateTime? _startTime;
  double _virtualSpeed = 25.0; // km/h (kann von echtem Speed überschrieben werden)

  RoutePlayerNotifier(this._ref) : super(const RoutePlayerData());

  /// Lädt eine Route
  void loadRoute(GpxRoute route) {
    state = RoutePlayerData(
      state: RoutePlayerState.ready,
      route: route,
      currentElevation: route.points.isNotEmpty ? route.points.first.elevation : 0,
    );
  }

  /// Startet die Route
  void start() {
    if (state.route == null || state.state != RoutePlayerState.ready) return;

    _startTime = DateTime.now();

    state = state.copyWith(
      state: RoutePlayerState.running,
      currentDistance: 0,
    );

    // Timer starten
    _startTimer();

    // Session starten
    _ref.read(activeSessionProvider.notifier).startSession(
          type: SessionType.gpxRoute,
          workoutId: state.route?.id,
        );
  }

  /// Pausiert die Route
  void pause() {
    if (state.state != RoutePlayerState.running) return;

    _timer?.cancel();
    _ref.read(activeSessionProvider.notifier).pauseSession();

    state = state.copyWith(state: RoutePlayerState.paused);
  }

  /// Setzt die Route fort
  void resume() {
    if (state.state != RoutePlayerState.paused) return;

    _ref.read(activeSessionProvider.notifier).resumeSession();

    state = state.copyWith(state: RoutePlayerState.running);
    _startTimer();
  }

  /// Stoppt die Route
  void stop() {
    _timer?.cancel();
    state = state.copyWith(state: RoutePlayerState.finished);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      _tick();
    });
  }

  void _tick() {
    if (state.state != RoutePlayerState.running || state.route == null) return;

    // Echte Geschwindigkeit vom Trainer verwenden falls verfügbar
    final liveData = _ref.read(liveTrainingDataProvider);
    final speed = liveData.speed ?? _virtualSpeed;

    // Distanz pro Tick berechnen (speed ist in km/h, wir brauchen m/500ms)
    final distancePerTick = (speed * 1000 / 3600) * 0.5;
    final newDistance = state.currentDistance + distancePerTick;

    // Prüfen ob Route beendet
    if (newDistance >= state.route!.totalDistance) {
      _timer?.cancel();
      state = state.copyWith(
        state: RoutePlayerState.finished,
        currentDistance: state.route!.totalDistance,
      );
      return;
    }

    // Aktuelle Position berechnen
    final currentPoint = state.route!.pointAtDistance(newDistance);
    final gradient = state.route!.gradientAtDistance(newDistance);

    // Ziel-Power basierend auf Gradient berechnen
    final ftp = _ref.read(athleteProfileProvider).ftp;
    final targetPower = _calculatePowerForGradient(gradient, ftp);

    // Trainer steuern (Simulation Mode)
    _setTrainerResistance(gradient);

    // Elapsed Time
    final elapsed = DateTime.now().difference(_startTime ?? DateTime.now());

    state = state.copyWith(
      currentDistance: newDistance,
      currentElevation: currentPoint?.elevation ?? state.currentElevation,
      currentGradient: gradient,
      elapsed: elapsed,
      currentTargetPower: targetPower,
    );

    // Live Data aktualisieren
    _ref.read(liveTrainingDataProvider.notifier).setTargetPower(targetPower);
  }

  /// Berechnet die Ziel-Power basierend auf dem Gradienten
  int _calculatePowerForGradient(double gradient, int ftp) {
    // Basis-Intensität bei 0% Steigung = 60% FTP
    // Pro 1% Steigung +5% FTP
    // Negative Steigung reduziert auf min 30% FTP
    final baseIntensity = 0.60;
    final gradientFactor = gradient * 0.05;
    final intensity = (baseIntensity + gradientFactor).clamp(0.30, 1.50);

    return (ftp * intensity).round();
  }

  /// Setzt den Trainer-Widerstand basierend auf dem Gradienten
  void _setTrainerResistance(double gradient) {
    final bleManager = _ref.read(bleManagerProvider);
    final ftmsService = bleManager.ftmsService;

    if (ftmsService != null) {
      // Simulation Mode: Gradient direkt setzen
      ftmsService.setSimulationParameters(
        windSpeed: 0,
        grade: gradient,
        crr: 0.004, // Rolling resistance coefficient
        cw: 0.51, // Wind resistance coefficient
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// SessionType Erweiterung (muss in training_session.dart sein)
// Temporär hier als Kommentar: gpxRoute sollte zu SessionType hinzugefügt werden
