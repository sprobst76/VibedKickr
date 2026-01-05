import 'dart:async';
import 'dart:math';

import '../../main.dart';
import 'models/ftms_data.dart';

/// Simulierter FTMS Service für Entwicklung ohne echten Trainer
class MockFtmsService {
  final _dataController = StreamController<FtmsData>.broadcast();
  final _statusController = StreamController<FtmsStatus>.broadcast();
  Timer? _simulationTimer;
  final Random _random = Random();

  // Simulation State
  int _targetPower = 100;
  int _currentPower = 0;
  int _cadence = 85;
  double _speed = 25.0;
  int _distance = 0;
  int _heartRate = 120;
  int _calories = 0;
  double _grade = 0;
  bool _isRunning = false;

  // Simulation Parameters
  int _ftp = 200; // Athlete FTP for realistic simulation
  int _restingHr = 60;
  int _maxHr = 180;
  double _weight = 75; // kg

  /// Stream von Trainer-Daten
  Stream<FtmsData> get dataStream => _dataController.stream;

  /// Stream von Status-Updates
  Stream<FtmsStatus> get statusStream => _statusController.stream;

  int? get minPower => 25;
  int? get maxPower => 1000;

  MockFtmsService();

  /// Konfiguriert den Simulator mit Athleten-Daten
  void configure({
    int? ftp,
    int? restingHr,
    int? maxHr,
    double? weight,
  }) {
    if (ftp != null) _ftp = ftp;
    if (restingHr != null) _restingHr = restingHr;
    if (maxHr != null) _maxHr = maxHr;
    if (weight != null) _weight = weight;
    logger.i('Mock Trainer configured: FTP=$_ftp, MaxHR=$_maxHr');
  }

  /// Initialisiert den Mock Service
  Future<void> initialize() async {
    logger.i('Initializing Mock FTMS Service');
    _statusController.add(const FtmsStatus(
      opCode: 0x04,
      message: 'Mock Trainer Started',
      isSuccess: true,
      rawData: [],
    ));
  }

  /// Startet die Simulation
  void start() {
    if (_isRunning) return;
    _isRunning = true;
    _currentPower = _targetPower;

    logger.i('Mock Trainer simulation started');

    _simulationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateSimulation();
    });
  }

  /// Stoppt die Simulation
  void stop() {
    _isRunning = false;
    _simulationTimer?.cancel();
    _simulationTimer = null;
    _currentPower = 0;
    _cadence = 0;
    _speed = 0;
    _emitData();
    logger.i('Mock Trainer simulation stopped');
  }

  /// Pausiert die Simulation (Freilauf)
  void pause() {
    _targetPower = 0;
  }

  /// Simuliert ERG Mode
  Future<bool> setTargetPower(int watts) async {
    _targetPower = watts.clamp(25, 1000);
    logger.d('Mock Target Power: $_targetPower W');
    _statusController.add(FtmsStatus(
      opCode: 0x08,
      message: 'Target Power Changed to $_targetPower W',
      isSuccess: true,
      rawData: [],
    ));
    return true;
  }

  /// Simuliert Steigungsmodus
  Future<bool> setSimulationParameters({
    required double grade,
    double crr = 0.004,
    double cw = 0.51,
    double windSpeed = 0,
  }) async {
    _grade = grade;
    logger.d('Mock Simulation: grade=$grade%');
    _statusController.add(FtmsStatus(
      opCode: 0x12,
      message: 'Simulation Parameters Changed: ${grade.toStringAsFixed(1)}%',
      isSuccess: true,
      rawData: [],
    ));
    return true;
  }

  /// Simuliert Widerstandslevel
  Future<bool> setResistanceLevel(int level) async {
    _targetPower = (level / 100 * _ftp).round().clamp(25, 1000);
    logger.d('Mock Resistance Level: $level% -> $_targetPower W');
    return true;
  }

  Future<bool> requestControl() async {
    logger.d('Mock Control Requested');
    return true;
  }

  Future<bool> reset() async {
    _targetPower = 100;
    _currentPower = 0;
    _distance = 0;
    _calories = 0;
    logger.i('Mock Trainer Reset');
    return true;
  }

  Future<bool> startSpindown() async {
    logger.i('Mock Spindown (simulated)');
    _statusController.add(const FtmsStatus(
      opCode: 0x14,
      message: 'Spindown Complete (Simulated)',
      isSuccess: true,
      rawData: [],
    ));
    return true;
  }

  void _updateSimulation() {
    if (!_isRunning) return;

    // ERG Mode: Leistung nähert sich dem Ziel
    if (_targetPower > 0) {
      final diff = _targetPower - _currentPower;
      _currentPower += (diff * 0.3).round();
      // Natürliche Variation hinzufügen (±3%)
      final variation = (_random.nextDouble() - 0.5) * 0.06 * _targetPower;
      _currentPower = (_currentPower + variation).round().clamp(0, 1500);
    } else {
      // Freilauf - langsam auf 0
      _currentPower = (_currentPower * 0.95).round();
    }

    // Kadenz basierend auf Leistung (mit Variation)
    if (_currentPower > 0) {
      final baseCadence = 80 + (_currentPower / _ftp * 15).clamp(-10, 20);
      _cadence = (baseCadence + (_random.nextDouble() - 0.5) * 10).round().clamp(60, 120);
    } else {
      _cadence = (_cadence * 0.9).round();
    }

    // Geschwindigkeit basierend auf Leistung und Steigung
    if (_currentPower > 0) {
      // Vereinfachte Physik
      final resistanceForce = _grade * _weight * 0.1 + 5; // Grundwiderstand
      _speed = ((_currentPower / (resistanceForce + 20)) * 3.6).clamp(0, 80);
      _speed += (_random.nextDouble() - 0.5) * 2; // Variation
    } else {
      _speed = (_speed * 0.95).clamp(0, 80);
    }

    // Distanz akkumulieren
    _distance += (_speed / 3.6).round(); // m/s

    // Herzfrequenz basierend auf Intensität
    final intensity = _currentPower / _ftp;
    final targetHr = _restingHr + ((_maxHr - _restingHr) * intensity * 0.9).round();
    final hrDiff = targetHr - _heartRate;
    _heartRate += (hrDiff * 0.1).round(); // Langsame HR-Anpassung
    _heartRate = (_heartRate + (_random.nextDouble() - 0.5) * 3).round().clamp(_restingHr, _maxHr);

    // Kalorien (grobe Schätzung: ~4 cal/min pro Watt)
    _calories += (_currentPower * 0.067 / 60).round();

    _emitData();
  }

  void _emitData() {
    final data = FtmsData(
      timestamp: DateTime.now(),
      power: _currentPower,
      cadence: _cadence > 0 ? _cadence : null,
      speed: _speed > 0 ? _speed : null,
      distance: _distance,
      heartRate: _heartRate,
      calories: _calories,
    );
    _dataController.add(data);
  }

  void dispose() {
    _simulationTimer?.cancel();
    _dataController.close();
    _statusController.close();
  }
}
