import 'models/ftms_data.dart';

/// Abstrakte Schnittstelle für FTMS (Fitness Machine Service)
/// Wird von FtmsService (echtes BLE) und MockFtmsService (Simulator) implementiert
abstract class FtmsServiceInterface {
  /// Stream von Trainer-Daten (Power, Kadenz, Geschwindigkeit)
  Stream<FtmsData> get dataStream;

  /// Stream von Status-Updates (Kontrolle akzeptiert, Fehler, etc.)
  Stream<FtmsStatus> get statusStream;

  /// Minimale unterstützte Leistung
  int? get minPower;

  /// Maximale unterstützte Leistung
  int? get maxPower;

  /// Initialisiert den Service
  Future<void> initialize();

  /// Fordert Kontrolle über den Trainer an
  Future<bool> requestControl();

  /// Setzt den Trainer in ERG-Modus mit Ziel-Watt
  Future<bool> setTargetPower(int watts);

  /// Setzt Simulation Parameter (Steigung, Wind, etc.)
  Future<bool> setSimulationParameters({
    required double grade,
    double crr,
    double cw,
    double windSpeed,
  });

  /// Setzt den Widerstandslevel (0-100%)
  Future<bool> setResistanceLevel(int level);

  /// Startet Spindown-Kalibrierung
  Future<bool> startSpindown();

  /// Stoppt das Training / Reset
  Future<bool> reset();

  /// Räumt Ressourcen auf
  void dispose();
}
