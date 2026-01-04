import 'dart:async';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../main.dart';
import 'ftms_service.dart';
import 'heart_rate_service.dart';
import 'models/ble_device.dart';
import 'models/connection_state.dart';

/// Zentrale Klasse für BLE-Kommunikation mit Multi-Device Support
class BleManager {
  static final BleManager _instance = BleManager._internal();
  static BleManager get instance => _instance;

  BleManager._internal();

  // State - Trainer
  final _connectionStateController = StreamController<BleConnectionState>.broadcast();
  final _discoveredDevicesController = StreamController<List<BleDevice>>.broadcast();
  final _scanningController = StreamController<bool>.broadcast();

  // State - HR Monitor
  final _hrConnectionStateController = StreamController<BleConnectionState>.broadcast();
  final _hrDataController = StreamController<HeartRateData>.broadcast();

  Stream<BleConnectionState> get connectionState => _connectionStateController.stream;
  Stream<List<BleDevice>> get discoveredDevices => _discoveredDevicesController.stream;
  Stream<bool> get isScanning => _scanningController.stream;

  /// HR Monitor Connection State
  Stream<BleConnectionState> get hrConnectionState => _hrConnectionStateController.stream;

  /// HR Daten Stream (von standalone HR Monitor)
  Stream<HeartRateData> get heartRateData => _hrDataController.stream;

  BleConnectionState _currentState = BleConnectionState.disconnected();
  BleConnectionState get currentState => _currentState;

  BleConnectionState _hrCurrentState = BleConnectionState.disconnected();
  BleConnectionState get hrCurrentState => _hrCurrentState;

  final List<BleDevice> _devices = [];

  // Trainer Connection
  BluetoothDevice? _connectedTrainer;
  FtmsService? _ftmsService;
  StreamSubscription<BluetoothConnectionState>? _trainerConnectionSubscription;

  // HR Monitor Connection
  BluetoothDevice? _connectedHrMonitor;
  HeartRateService? _heartRateService;
  StreamSubscription<BluetoothConnectionState>? _hrConnectionSubscription;
  StreamSubscription<HeartRateData>? _hrDataSubscription;

  StreamSubscription<List<ScanResult>>? _scanSubscription;
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;

  // Für Auto-Reconnect
  String? _lastConnectedTrainerId;
  String? _lastConnectedHrMonitorId;
  bool _autoReconnectEnabled = true;

  // Platform support
  bool _isSupported = false;
  bool get isSupported => _isSupported;

  /// FTMS Service für Trainer-Steuerung
  FtmsService? get ftmsService => _ftmsService;

  /// Heart Rate Service
  HeartRateService? get heartRateService => _heartRateService;

  /// Ist ein Trainer verbunden?
  bool get isTrainerConnected => _connectedTrainer != null && _ftmsService != null;

  /// Ist ein HR Monitor verbunden?
  bool get isHrMonitorConnected => _connectedHrMonitor != null && _heartRateService != null;

  /// Letzter HR Wert vom standalone Monitor
  int? get lastHeartRate => _heartRateService?.lastHeartRate;

  /// Initialisiert BLE
  Future<void> initialize() async {
    logger.i('Initializing BLE Manager (Multi-Device)');

    // Prüfe Plattform-Unterstützung BEVOR wir flutter_blue_plus aufrufen
    if (Platform.isWindows) {
      logger.w('BLE not supported on Windows via flutter_blue_plus');
      logger.w('Use Android or macOS for BLE support');
      _isSupported = false;
      _updateTrainerState(BleConnectionState.error(
        'BLE wird auf Windows nicht unterstützt.\nBitte Android/macOS verwenden.'
      ));
      return;
    }

    try {
      // Prüfe ob BLE verfügbar - nur auf unterstützten Plattformen
      _isSupported = await FlutterBluePlus.isSupported;
      if (!_isSupported) {
        logger.e('Bluetooth not supported on this device');
        _updateTrainerState(BleConnectionState.error('Bluetooth wird nicht unterstützt'));
        return;
      }

      // Auf Desktop: Adapter-Status überwachen
      if (Platform.isMacOS || Platform.isLinux) {
        _adapterStateSubscription?.cancel();
        _adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) {
          logger.d('Adapter state: $state');
          if (state == BluetoothAdapterState.off) {
            _updateTrainerState(BleConnectionState.error('Bluetooth ist ausgeschaltet'));
            _updateHrState(BleConnectionState.error('Bluetooth ist ausgeschaltet'));
          }
        });
      }

      logger.i('BLE Manager initialized successfully');
    } catch (e) {
      logger.e('BLE initialization error: $e');
      _isSupported = false;
      _updateTrainerState(BleConnectionState.error('BLE nicht verfügbar'));
    }
  }

  /// Startet den BLE-Scan nach allen unterstützten Geräten
  Future<void> startScan({Duration timeout = const Duration(seconds: 10)}) async {
    if (!_isSupported) {
      logger.w('BLE not supported - scan skipped');
      return;
    }

    logger.i('Starting BLE scan (Trainers + HR Monitors)');
    _devices.clear();
    _scanningController.add(true);

    try {
      // Stoppe laufenden Scan
      if (FlutterBluePlus.isScanningNow) {
        await FlutterBluePlus.stopScan();
      }

      // Starte neuen Scan
      _scanSubscription?.cancel();
      _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
        for (final result in results) {
          final deviceType = _classifyDevice(result);
          if (deviceType != BleDeviceType.unknown) {
            final device = BleDevice(
              id: result.device.remoteId.str,
              name: result.device.platformName.isNotEmpty
                  ? result.device.platformName
                  : 'Unknown Device',
              rssi: result.rssi,
              bluetoothDevice: result.device,
              deviceType: deviceType,
            );

            final existingIndex = _devices.indexWhere((d) => d.id == device.id);
            if (existingIndex >= 0) {
              _devices[existingIndex] = device;
            } else {
              _devices.add(device);
              final typeStr = deviceType == BleDeviceType.trainer ? 'Trainer' : 'HR Monitor';
              logger.d('Found $typeStr: ${device.name} (${device.id})');
            }

            _discoveredDevicesController.add(List.from(_devices));
          }
        }
      });

      await FlutterBluePlus.startScan(timeout: timeout);

      // Warte auf Scan-Ende
      await Future.delayed(timeout);
    } catch (e) {
      logger.e('Scan error: $e');
    } finally {
      _scanningController.add(false);
      final trainers = _devices.where((d) => d.deviceType == BleDeviceType.trainer).length;
      final hrMonitors = _devices.where((d) => d.deviceType == BleDeviceType.heartRateMonitor).length;
      logger.i('Scan complete. Found $trainers trainers, $hrMonitors HR monitors');
    }
  }

  /// Stoppt den laufenden Scan
  Future<void> stopScan() async {
    if (!_isSupported) return;
    await FlutterBluePlus.stopScan();
    _scanningController.add(false);
  }

  /// Verbindet mit einem Trainer (FTMS)
  Future<bool> connectTrainer(BleDevice device) async {
    if (!_isSupported) {
      logger.w('BLE not supported - connect skipped');
      return false;
    }

    logger.i('Connecting to Trainer: ${device.name}');
    _updateTrainerState(BleConnectionState.connecting(device));

    try {
      // Stoppe Scan falls aktiv
      if (FlutterBluePlus.isScanningNow) {
        await FlutterBluePlus.stopScan();
      }

      // Verbinde
      await device.bluetoothDevice.connect(
        timeout: const Duration(seconds: 15),
        autoConnect: false,
      );

      // Connection State überwachen
      _trainerConnectionSubscription?.cancel();
      _trainerConnectionSubscription = device.bluetoothDevice.connectionState.listen(
        (state) {
          logger.d('Trainer connection state: $state');
          if (state == BluetoothConnectionState.disconnected) {
            _handleTrainerDisconnection();
          }
        },
      );

      // Services entdecken
      logger.d('Discovering trainer services...');
      final services = await device.bluetoothDevice.discoverServices();

      // FTMS Service finden und initialisieren
      for (final service in services) {
        if (service.uuid.toString().toLowerCase() == '00001826-0000-1000-8000-00805f9b34fb') {
          logger.i('Found FTMS service');
          _ftmsService = FtmsService(service);
          await _ftmsService!.initialize();
          break;
        }
      }

      if (_ftmsService == null) {
        logger.e('No FTMS service found');
        await device.bluetoothDevice.disconnect();
        _updateTrainerState(BleConnectionState.error('Kein FTMS-Dienst gefunden'));
        return false;
      }

      _connectedTrainer = device.bluetoothDevice;
      _lastConnectedTrainerId = device.id;
      _updateTrainerState(BleConnectionState.connected(device));
      logger.i('Connected successfully to Trainer: ${device.name}');
      return true;
    } catch (e) {
      logger.e('Trainer connection error: $e');
      _updateTrainerState(BleConnectionState.error('Verbindungsfehler: $e'));
      return false;
    }
  }

  /// Verbindet mit einem HR Monitor
  Future<bool> connectHrMonitor(BleDevice device) async {
    if (!_isSupported) {
      logger.w('BLE not supported - connect skipped');
      return false;
    }

    logger.i('Connecting to HR Monitor: ${device.name}');
    _updateHrState(BleConnectionState.connecting(device));

    try {
      // Stoppe Scan falls aktiv
      if (FlutterBluePlus.isScanningNow) {
        await FlutterBluePlus.stopScan();
      }

      // Verbinde
      await device.bluetoothDevice.connect(
        timeout: const Duration(seconds: 15),
        autoConnect: false,
      );

      // Connection State überwachen
      _hrConnectionSubscription?.cancel();
      _hrConnectionSubscription = device.bluetoothDevice.connectionState.listen(
        (state) {
          logger.d('HR Monitor connection state: $state');
          if (state == BluetoothConnectionState.disconnected) {
            _handleHrMonitorDisconnection();
          }
        },
      );

      // Services entdecken
      logger.d('Discovering HR Monitor services...');
      final services = await device.bluetoothDevice.discoverServices();

      // Heart Rate Service finden und initialisieren
      for (final service in services) {
        if (service.uuid.toString().toLowerCase() == heartRateServiceUuid) {
          logger.i('Found Heart Rate service');
          _heartRateService = HeartRateService(service);
          await _heartRateService!.initialize();

          // HR Daten weiterleiten
          _hrDataSubscription?.cancel();
          _hrDataSubscription = _heartRateService!.dataStream.listen((data) {
            _hrDataController.add(data);
          });
          break;
        }
      }

      if (_heartRateService == null) {
        logger.e('No Heart Rate service found');
        await device.bluetoothDevice.disconnect();
        _updateHrState(BleConnectionState.error('Kein HR-Dienst gefunden'));
        return false;
      }

      _connectedHrMonitor = device.bluetoothDevice;
      _lastConnectedHrMonitorId = device.id;
      _updateHrState(BleConnectionState.connected(device));
      logger.i('Connected successfully to HR Monitor: ${device.name}');
      return true;
    } catch (e) {
      logger.e('HR Monitor connection error: $e');
      _updateHrState(BleConnectionState.error('Verbindungsfehler: $e'));
      return false;
    }
  }

  /// Legacy connect Methode - leitet zum richtigen Connect weiter
  Future<bool> connect(BleDevice device) async {
    if (device.deviceType == BleDeviceType.heartRateMonitor) {
      return connectHrMonitor(device);
    }
    return connectTrainer(device);
  }

  /// Trennt die Trainer-Verbindung
  Future<void> disconnectTrainer() async {
    logger.i('Disconnecting Trainer');
    _trainerConnectionSubscription?.cancel();
    _ftmsService?.dispose();
    _ftmsService = null;

    try {
      await _connectedTrainer?.disconnect();
    } catch (e) {
      logger.w('Trainer disconnect error: $e');
    }

    _connectedTrainer = null;
    _updateTrainerState(BleConnectionState.disconnected());
  }

  /// Trennt die HR Monitor-Verbindung
  Future<void> disconnectHrMonitor() async {
    logger.i('Disconnecting HR Monitor');
    _hrConnectionSubscription?.cancel();
    _hrDataSubscription?.cancel();
    _heartRateService?.dispose();
    _heartRateService = null;

    try {
      await _connectedHrMonitor?.disconnect();
    } catch (e) {
      logger.w('HR Monitor disconnect error: $e');
    }

    _connectedHrMonitor = null;
    _updateHrState(BleConnectionState.disconnected());
  }

  /// Legacy disconnect - trennt Trainer
  Future<void> disconnect() async {
    await disconnectTrainer();
  }

  /// Trennt alle Verbindungen
  Future<void> disconnectAll() async {
    await disconnectTrainer();
    await disconnectHrMonitor();
  }

  /// Versucht Wiederverbindung zum letzten Trainer
  Future<bool> reconnectTrainer() async {
    if (_lastConnectedTrainerId == null) {
      logger.w('No last trainer to reconnect to');
      return false;
    }

    logger.i('Attempting trainer reconnect to $_lastConnectedTrainerId');

    // Kurzer Scan um Gerät zu finden
    await startScan(timeout: const Duration(seconds: 5));

    final device = _devices.where((d) => d.id == _lastConnectedTrainerId).firstOrNull;
    if (device != null) {
      return await connectTrainer(device);
    }

    logger.w('Last trainer not found during reconnect scan');
    return false;
  }

  /// Legacy reconnect
  Future<bool> reconnect() async {
    return reconnectTrainer();
  }

  void _handleTrainerDisconnection() {
    logger.w('Trainer disconnected');
    _ftmsService?.dispose();
    _ftmsService = null;
    _connectedTrainer = null;
    _updateTrainerState(BleConnectionState.disconnected());

    // Auto-Reconnect
    if (_autoReconnectEnabled && _lastConnectedTrainerId != null) {
      logger.i('Attempting trainer auto-reconnect in 2 seconds');
      Future.delayed(const Duration(seconds: 2), () {
        reconnectTrainer();
      });
    }
  }

  void _handleHrMonitorDisconnection() {
    logger.w('HR Monitor disconnected');
    _hrDataSubscription?.cancel();
    _heartRateService?.dispose();
    _heartRateService = null;
    _connectedHrMonitor = null;
    _updateHrState(BleConnectionState.disconnected());

    // Auto-Reconnect für HR Monitor
    if (_autoReconnectEnabled && _lastConnectedHrMonitorId != null) {
      logger.i('Attempting HR Monitor auto-reconnect in 2 seconds');
      Future.delayed(const Duration(seconds: 2), () async {
        await startScan(timeout: const Duration(seconds: 5));
        final device = _devices.where((d) => d.id == _lastConnectedHrMonitorId).firstOrNull;
        if (device != null) {
          await connectHrMonitor(device);
        }
      });
    }
  }

  void _updateTrainerState(BleConnectionState state) {
    _currentState = state;
    _connectionStateController.add(state);
  }

  void _updateHrState(BleConnectionState state) {
    _hrCurrentState = state;
    _hrConnectionStateController.add(state);
  }

  /// Klassifiziert ein Gerät nach Typ
  BleDeviceType _classifyDevice(ScanResult result) {
    final serviceUuids = result.advertisementData.serviceUuids;
    final name = result.device.platformName.toLowerCase();

    // Prüfe auf FTMS (Trainer)
    if (serviceUuids.any((uuid) => uuid.toString().toLowerCase().contains('1826'))) {
      return BleDeviceType.trainer;
    }

    // Prüfe auf Heart Rate Service
    if (serviceUuids.any((uuid) => uuid.toString().toLowerCase().contains('180d'))) {
      // Könnte Trainer mit HR oder standalone HR Monitor sein
      // Prüfe ob auch FTMS vorhanden
      if (serviceUuids.any((uuid) => uuid.toString().toLowerCase().contains('1826'))) {
        return BleDeviceType.trainer;
      }
      return BleDeviceType.heartRateMonitor;
    }

    // Bekannte Trainer Namen
    final trainerNames = ['kickr', 'wahoo', 'tacx', 'elite', 'saris', 'zwift', 'neo', 'flux', 'hammer'];
    if (trainerNames.any((known) => name.contains(known))) {
      // Wahoo TICKR ist ein HR Monitor, nicht Trainer
      if (name.contains('tickr') && !name.contains('kickr')) {
        return BleDeviceType.heartRateMonitor;
      }
      return BleDeviceType.trainer;
    }

    // Bekannte HR Monitor Namen
    if (KnownHeartRateMonitors.isKnownHrMonitor(name)) {
      return BleDeviceType.heartRateMonitor;
    }

    return BleDeviceType.unknown;
  }

  /// Aktiviert/Deaktiviert Auto-Reconnect
  void setAutoReconnect(bool enabled) {
    _autoReconnectEnabled = enabled;
  }

  void dispose() {
    _trainerConnectionSubscription?.cancel();
    _hrConnectionSubscription?.cancel();
    _hrDataSubscription?.cancel();
    _scanSubscription?.cancel();
    _adapterStateSubscription?.cancel();
    _connectionStateController.close();
    _hrConnectionStateController.close();
    _discoveredDevicesController.close();
    _scanningController.close();
    _hrDataController.close();
    _ftmsService?.dispose();
    _heartRateService?.dispose();
  }
}
