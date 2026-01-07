import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/ble/ble_manager.dart';
import '../core/ble/heart_rate_service.dart';
import '../core/ble/mock_ftms_service.dart';
import '../core/ble/models/ble_device.dart';
import '../core/ble/models/connection_state.dart';
import '../core/ble/models/ftms_data.dart';
import '../core/database/app_database.dart';
import '../core/database/daos/personal_record_dao.dart';
import '../core/services/personal_record_service.dart';
import '../core/services/training_load_service.dart';
import '../data/repositories/session_repository_impl.dart';
import '../domain/entities/athlete_profile.dart';
import '../domain/entities/training_load.dart';
import '../domain/entities/training_session.dart';
import '../domain/repositories/session_repository.dart';

// Re-export for convenience
export '../core/ble/mock_ftms_service.dart';
export '../core/database/daos/personal_record_dao.dart' show PersonalRecord;
export '../core/database/tables/personal_record_table.dart' show RecordType;
export '../core/services/personal_record_service.dart';
export '../core/services/training_load_service.dart';
export '../domain/entities/training_load.dart';

/// Ergebnis einer beendeten Session
class SessionFinishResult {
  final TrainingSession session;
  final List<PersonalRecord> newRecords;

  const SessionFinishResult({
    required this.session,
    this.newRecords = const [],
  });

  /// Wurden neue PRs aufgestellt?
  bool get hasNewRecords => newRecords.isNotEmpty;
}

// ============================================================================
// BLE Providers
// ============================================================================

/// BLE Manager Singleton
final bleManagerProvider = Provider<BleManager>((ref) {
  return BleManager.instance;
});

/// BLE Connection State Stream (zeigt verbunden wenn Simulator aktiv)
final bleConnectionStateProvider = StreamProvider<BleConnectionState>((ref) {
  final simulatorMode = ref.watch(simulatorModeProvider);

  if (simulatorMode) {
    // Simulator Mode: Immer "verbunden" anzeigen
    return Stream.value(BleConnectionState.simulated());
  }

  final bleManager = ref.watch(bleManagerProvider);
  return bleManager.connectionState;
});

/// Ist gerade ein Scan aktiv?
final bleScanningProvider = StreamProvider<bool>((ref) {
  final bleManager = ref.watch(bleManagerProvider);
  return bleManager.isScanning;
});

/// Liste der gefundenen Geräte
final bleDevicesProvider = StreamProvider<List<BleDevice>>((ref) {
  final bleManager = ref.watch(bleManagerProvider);
  return bleManager.discoveredDevices;
});

/// FTMS Daten Stream (nutzt Mock wenn Simulator aktiv)
final ftmsDataProvider = StreamProvider<FtmsData>((ref) {
  final simulatorMode = ref.watch(simulatorModeProvider);

  if (simulatorMode) {
    // Simulator Mode: Nutze MockFtmsService
    final mockService = ref.watch(mockFtmsServiceProvider);
    return mockService.dataStream;
  }

  // Normaler Modus: Nutze echten BLE Trainer
  // WICHTIG: Watch connectionState um Provider neu zu evaluieren bei Verbindungsänderung
  final connectionState = ref.watch(bleConnectionStateProvider);

  return connectionState.when(
    data: (state) {
      if (state.isConnected) {
        final bleManager = ref.read(bleManagerProvider);
        final ftmsService = bleManager.ftmsService;
        if (ftmsService != null) {
          return ftmsService.dataStream;
        }
      }
      return Stream.value(FtmsData.empty());
    },
    loading: () => Stream.value(FtmsData.empty()),
    error: (_, __) => Stream.value(FtmsData.empty()),
  );
});

// ============================================================================
// HR Monitor Providers
// ============================================================================

/// HR Monitor Connection State Stream
final hrConnectionStateProvider = StreamProvider<BleConnectionState>((ref) {
  final bleManager = ref.watch(bleManagerProvider);
  return bleManager.hrConnectionState;
});

/// Heart Rate Daten von standalone HR Monitor
final hrDataProvider = StreamProvider<HeartRateData>((ref) {
  final bleManager = ref.watch(bleManagerProvider);
  return bleManager.heartRateData;
});

/// Gefilterte Trainer-Geräte
final trainerDevicesProvider = Provider<List<BleDevice>>((ref) {
  final devices = ref.watch(bleDevicesProvider);
  return devices.when(
    data: (list) => list.where((d) => d.isTrainer).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

/// Gefilterte HR Monitor-Geräte
final hrMonitorDevicesProvider = Provider<List<BleDevice>>((ref) {
  final devices = ref.watch(bleDevicesProvider);
  return devices.when(
    data: (list) => list.where((d) => d.isHeartRateMonitor).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

// ============================================================================
// Database & Repository Providers
// ============================================================================

/// SQLite Datenbank (Drift)
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

/// Session Repository
final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return SessionRepositoryImpl(db);
});

/// Alle gespeicherten Sessions als Stream
final savedSessionsProvider = StreamProvider<List<TrainingSession>>((ref) {
  final repository = ref.watch(sessionRepositoryProvider);
  return repository.watchAllSessions();
});

// ============================================================================
// Athlete Profile Provider
// ============================================================================

/// Athleten-Profil mit FTP und Zonen
final athleteProfileProvider =
    StateNotifierProvider<AthleteProfileNotifier, AthleteProfile>((ref) {
  return AthleteProfileNotifier();
});

class AthleteProfileNotifier extends StateNotifier<AthleteProfile> {
  AthleteProfileNotifier() : super(AthleteProfile.defaultProfile());

  void updateFtp(int newFtp) {
    // Validierung: FTP muss zwischen 1 und 500 Watt liegen (realistischer Bereich)
    if (newFtp < 1 || newFtp > 500) {
      return;
    }
    state = state.updateFtp(newFtp);
  }

  void updateWeight(int? weight) {
    state = state.copyWith(weight: weight);
  }

  void updateMaxHr(int? maxHr) {
    state = state.copyWith(
      maxHr: maxHr,
      hrZones: maxHr != null ? HeartRateZones.fromMaxHr(maxHr) : null,
    );
  }

  void updateProfile(AthleteProfile profile) {
    state = profile;
  }
}

// ============================================================================
// Live Training Data Provider
// ============================================================================

/// Aggregierte Live-Trainingsdaten
final liveTrainingDataProvider =
    StateNotifierProvider<LiveTrainingDataNotifier, LiveTrainingData>((ref) {
  final notifier = LiveTrainingDataNotifier(ref);
  ref.onDispose(() => notifier.dispose());
  return notifier;
});

class LiveTrainingData {
  final int power;
  final int? cadence;
  final int? heartRate;
  final double? speed;
  final int? distance;
  final int currentZone;
  final int targetPower;
  final Duration elapsed;
  final List<int> powerHistory; // Letzte 60 Sekunden

  const LiveTrainingData({
    this.power = 0,
    this.cadence,
    this.heartRate,
    this.speed,
    this.distance,
    this.currentZone = 1,
    this.targetPower = 0,
    this.elapsed = Duration.zero,
    this.powerHistory = const [],
  });

  LiveTrainingData copyWith({
    int? power,
    int? cadence,
    int? heartRate,
    double? speed,
    int? distance,
    int? currentZone,
    int? targetPower,
    Duration? elapsed,
    List<int>? powerHistory,
  }) {
    return LiveTrainingData(
      power: power ?? this.power,
      cadence: cadence ?? this.cadence,
      heartRate: heartRate ?? this.heartRate,
      speed: speed ?? this.speed,
      distance: distance ?? this.distance,
      currentZone: currentZone ?? this.currentZone,
      targetPower: targetPower ?? this.targetPower,
      elapsed: elapsed ?? this.elapsed,
      powerHistory: powerHistory ?? this.powerHistory,
    );
  }

  /// Durchschnittsleistung der letzten 3 Sekunden
  int get avgPower3s {
    if (powerHistory.length < 3) return power;
    final last3 = powerHistory.sublist(powerHistory.length - 3);
    return (last3.reduce((a, b) => a + b) / 3).round();
  }

  /// Durchschnittsleistung der letzten 10 Sekunden
  int get avgPower10s {
    if (powerHistory.length < 10) return avgPower3s;
    final last10 = powerHistory.sublist(powerHistory.length - 10);
    return (last10.reduce((a, b) => a + b) / 10).round();
  }
}

class LiveTrainingDataNotifier extends StateNotifier<LiveTrainingData> {
  final Ref _ref;
  Timer? _elapsedTimer;
  DateTime? _startTime;
  bool _isRunning = false;

  // HR vom standalone Monitor (hat Priorität)
  int? _standaloneHr;

  LiveTrainingDataNotifier(this._ref) : super(const LiveTrainingData()) {
    _init();
  }

  void _init() {
    // Check if BLE is supported before subscribing
    final bleManager = _ref.read(bleManagerProvider);
    if (!bleManager.isSupported) {
      return; // Don't subscribe if BLE not available
    }

    // Listen to FTMS data
    _ref.listen<AsyncValue<FtmsData>>(
      ftmsDataProvider,
      (previous, next) {
        next.whenData((data) {
          _updateFromFtmsData(data);
        });
      },
    );

    // Listen to standalone HR Monitor data
    _ref.listen<AsyncValue<HeartRateData>>(
      hrDataProvider,
      (previous, next) {
        next.whenData((hrData) {
          _standaloneHr = hrData.heartRate;
          // Update HR in state immediately
          state = state.copyWith(heartRate: hrData.heartRate);
        });
      },
    );
  }

  void _updateFromFtmsData(FtmsData data) {
    final profile = _ref.read(athleteProfileProvider);
    final zone = profile.powerZones.zoneForPower(data.power);

    // Power History aktualisieren (max 60 Einträge)
    final history = [...state.powerHistory, data.power];
    if (history.length > 60) {
      history.removeAt(0);
    }

    // HR: Standalone Monitor hat Priorität, sonst Trainer HR
    final heartRate = _standaloneHr ?? data.heartRate;

    state = state.copyWith(
      power: data.power,
      cadence: data.cadence,
      heartRate: heartRate,
      speed: data.speed,
      distance: data.distance,
      currentZone: zone,
      powerHistory: history,
    );
  }

  void startSession() {
    _startTime = DateTime.now();
    _isRunning = true;
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_startTime != null && _isRunning) {
        state = state.copyWith(
          elapsed: DateTime.now().difference(_startTime!),
        );
      }
    });
  }

  void pauseSession() {
    _isRunning = false;
  }

  void resumeSession() {
    _isRunning = true;
  }

  void stopSession() {
    _elapsedTimer?.cancel();
    _isRunning = false;
    _startTime = null;
    state = const LiveTrainingData();
  }

  void setTargetPower(int watts) {
    state = state.copyWith(targetPower: watts);
  }

  @override
  void dispose() {
    _elapsedTimer?.cancel();
    super.dispose();
  }
}

// ============================================================================
// Training Session Provider
// ============================================================================

/// Aktive Trainingseinheit
final activeSessionProvider =
    StateNotifierProvider<ActiveSessionNotifier, TrainingSession?>((ref) {
  final notifier = ActiveSessionNotifier(ref);
  ref.onDispose(() => notifier.dispose());
  return notifier;
});

class ActiveSessionNotifier extends StateNotifier<TrainingSession?> {
  final Ref _ref;
  final List<DataPoint> _dataPoints = [];
  Timer? _recordingTimer;
  DateTime? _sessionStart;

  ActiveSessionNotifier(this._ref) : super(null);

  void startSession({SessionType type = SessionType.freeRide, String? workoutId}) {
    _sessionStart = DateTime.now();
    _dataPoints.clear();

    state = TrainingSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startTime: _sessionStart!,
      type: type,
      workoutId: workoutId,
    );

    // Daten alle Sekunde aufzeichnen
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _recordDataPoint();
    });

    _ref.read(liveTrainingDataProvider.notifier).startSession();
  }

  void _recordDataPoint() {
    if (_sessionStart == null) return;

    final liveData = _ref.read(liveTrainingDataProvider);
    final dataPoint = DataPoint(
      timestamp: DateTime.now().difference(_sessionStart!).inMilliseconds,
      power: liveData.power,
      cadence: liveData.cadence,
      heartRate: liveData.heartRate,
      speed: liveData.speed,
      distance: liveData.distance,
      targetPower: liveData.targetPower > 0 ? liveData.targetPower : null,
    );

    _dataPoints.add(dataPoint);
  }

  void pauseSession() {
    _recordingTimer?.cancel();
    _ref.read(liveTrainingDataProvider.notifier).pauseSession();
  }

  void resumeSession() {
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _recordDataPoint();
    });
    _ref.read(liveTrainingDataProvider.notifier).resumeSession();
  }

  Future<SessionFinishResult?> finishSession() async {
    _recordingTimer?.cancel();
    _ref.read(liveTrainingDataProvider.notifier).stopSession();

    if (state == null || _dataPoints.isEmpty) {
      state = null;
      return null;
    }

    final ftp = _ref.read(athleteProfileProvider).ftp;
    final stats = SessionStats.fromDataPoints(_dataPoints, ftp: ftp);

    final finishedSession = state!.copyWith(
      endTime: DateTime.now(),
      dataPoints: List.from(_dataPoints),
      stats: stats,
    );

    // Session in Datenbank speichern
    try {
      final repository = _ref.read(sessionRepositoryProvider);
      await repository.saveSession(finishedSession);
    } catch (e) {
      // Fehler beim Speichern loggen, aber Session trotzdem zurückgeben
      // ignore: avoid_print
      print('Fehler beim Speichern der Session: $e');
    }

    // Personal Records analysieren
    List<PersonalRecord> newRecords = [];
    try {
      final prService = _ref.read(personalRecordServiceProvider);
      newRecords = await prService.analyzeSession(finishedSession);
    } catch (e) {
      // PR-Analyse-Fehler nicht kritisch
      // ignore: avoid_print
      print('Fehler bei PR-Analyse: $e');
    }

    state = null;
    _dataPoints.clear();
    _sessionStart = null;

    return SessionFinishResult(
      session: finishedSession,
      newRecords: newRecords,
    );
  }

  void cancelSession() {
    _recordingTimer?.cancel();
    _ref.read(liveTrainingDataProvider.notifier).stopSession();
    state = null;
    _dataPoints.clear();
    _sessionStart = null;
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    super.dispose();
  }
}

// ============================================================================
// Settings Providers
// ============================================================================

/// Sound an/aus
final soundEnabledProvider = StateProvider<bool>((ref) => true);

/// Auto-Connect an/aus
final autoConnectProvider = StateProvider<bool>((ref) => true);

/// ERG Mode vs Simulation Mode
final ergModeProvider = StateProvider<bool>((ref) => true);

/// Trainer Simulator Modus (für Entwicklung ohne echten Trainer)
final simulatorModeProvider = StateProvider<bool>((ref) => false);

// ============================================================================
// Mock Trainer Service
// ============================================================================

/// Mock FTMS Service für Simulator-Modus
final mockFtmsServiceProvider = Provider<MockFtmsService>((ref) {
  final profile = ref.watch(athleteProfileProvider);
  final service = MockFtmsService();

  // Konfiguriere mit Athleten-Daten
  service.configure(
    ftp: profile.ftp,
    maxHr: profile.maxHr ?? 180,
    weight: profile.weight?.toDouble() ?? 75.0,
  );

  ref.onDispose(() => service.dispose());
  return service;
});

/// Mock FTMS Daten Stream
final mockFtmsDataProvider = StreamProvider<FtmsData>((ref) {
  final simulatorMode = ref.watch(simulatorModeProvider);
  if (!simulatorMode) {
    return const Stream.empty();
  }

  final mockService = ref.watch(mockFtmsServiceProvider);
  return mockService.dataStream;
});

// ============================================================================
// Training Load Providers
// ============================================================================

/// Training Load Service
final trainingLoadServiceProvider = Provider<TrainingLoadService>((ref) {
  final sessionRepo = ref.watch(sessionRepositoryProvider);
  return TrainingLoadService(sessionRepo);
});

/// Performance Management Chart Daten
final pmcDataProvider = FutureProvider<PerformanceManagementData>((ref) async {
  final service = ref.watch(trainingLoadServiceProvider);

  // Versuche zuerst Cache zu laden
  final cached = await service.loadFromCache();
  if (cached != null) {
    // Aktualisiere im Hintergrund
    service.calculatePMC().then((fresh) => service.cacheData(fresh));
    return cached;
  }

  // Berechne neu
  final data = await service.calculatePMC();
  await service.cacheData(data);
  return data;
});

/// Aktueller Trainings-Status (kompakt)
final trainingStatusProvider = Provider<TrainingStatus>((ref) {
  final pmcAsync = ref.watch(pmcDataProvider);

  return pmcAsync.when(
    data: (pmc) => TrainingStatus(
      ctl: pmc.currentCtl,
      atl: pmc.currentAtl,
      tsb: pmc.currentTsb,
      weeklyTss: pmc.weeklyTss,
      trend: pmc.fitnessTrend,
    ),
    loading: () => const TrainingStatus(
      ctl: 0,
      atl: 0,
      tsb: 0,
      weeklyTss: 0,
      trend: FitnessTrend.stable,
    ),
    error: (_, __) => const TrainingStatus(
      ctl: 0,
      atl: 0,
      tsb: 0,
      weeklyTss: 0,
      trend: FitnessTrend.stable,
    ),
  );
});
