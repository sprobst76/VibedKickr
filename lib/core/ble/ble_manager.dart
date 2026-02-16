import 'dart:async';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../main.dart';
import 'ftms_service.dart';
import 'ftms_service_interface.dart';
import 'heart_rate_service.dart';
import 'models/ble_device.dart';
import 'models/ble_error.dart';
import 'models/connection_state.dart';
import 'models/reconnection_state.dart';
import 'reconnection_manager.dart';

/// Zentrale Klasse für BLE-Kommunikation mit Multi-Device Support
class BleManager {
  static final BleManager _instance = BleManager._internal();
  static BleManager get instance => _instance;

  BleManager._internal() {
    // Emit initial states immediately
    _connectionStateController.add(_currentState);
    _hrConnectionStateController.add(_hrCurrentState);
    _discoveredDevicesController.add([]);
    _scanningController.add(false);
  }

  // State - Trainer
  final _connectionStateController = StreamController<BleConnectionState>.broadcast();
  final _discoveredDevicesController = StreamController<List<BleDevice>>.broadcast();
  final _scanningController = StreamController<bool>.broadcast();

  // State - HR Monitor
  final _hrConnectionStateController = StreamController<BleConnectionState>.broadcast();
  final _hrDataController = StreamController<HeartRateData>.broadcast();

  Stream<BleConnectionState> get connectionState async* {
    // Emit current state first, then stream updates
    yield _currentState;
    yield* _connectionStateController.stream;
  }

  Stream<List<BleDevice>> get discoveredDevices async* {
    yield _devices;
    yield* _discoveredDevicesController.stream;
  }

  Stream<bool> get isScanning async* {
    yield false;
    yield* _scanningController.stream;
  }

  /// HR Monitor Connection State
  Stream<BleConnectionState> get hrConnectionState async* {
    yield _hrCurrentState;
    yield* _hrConnectionStateController.stream;
  }

  /// HR Daten Stream (von standalone HR Monitor)
  Stream<HeartRateData> get heartRateData => _hrDataController.stream;

  /// Reconnection State Stream
  Stream<BleReconnectionState> get reconnectionState =>
      _reconnectionManager.reconnectionState;

  BleConnectionState _currentState = BleConnectionState.disconnected();
  BleConnectionState get currentState => _currentState;

  BleConnectionState _hrCurrentState = BleConnectionState.disconnected();
  BleConnectionState get hrCurrentState => _hrCurrentState;

  final List<BleDevice> _devices = [];

  bool _disposed = false;

  // Trainer Connection
  BluetoothDevice? _connectedTrainer;
  FtmsServiceInterface? _ftmsService;
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
  bool _isManualDisconnect = false; // Guard gegen Auto-Reconnect nach manuellem Disconnect

  // Reconnection Manager
  final _reconnectionManager = BleReconnectionManager();

  // Platform support
  bool _isSupported = false;
  bool get isSupported => _isSupported;

  /// FTMS Service für Trainer-Steuerung
  FtmsServiceInterface? get ftmsService => _ftmsService;

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
      _updateTrainerState(BleConnectionState.fromBleError(BleError.notSupported()));
      return;
    }

    try {
      // Prüfe ob BLE verfügbar - nur auf unterstützten Plattformen
      _isSupported = await FlutterBluePlus.isSupported;
      if (!_isSupported) {
        logger.e('Bluetooth not supported on this device');
        _updateTrainerState(BleConnectionState.fromBleError(BleError.notSupported()));
        return;
      }

      // Auf Android: Bluetooth einschalten wenn aus
      if (Platform.isAndroid) {
        final adapterState = await FlutterBluePlus.adapterState.first;
        if (adapterState != BluetoothAdapterState.on) {
          logger.i('Requesting to turn on Bluetooth');
          await FlutterBluePlus.turnOn();
        }
      }

      // Adapter-Status überwachen
      _adapterStateSubscription?.cancel();
      _adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) {
        logger.d('Adapter state: $state');
        if (state == BluetoothAdapterState.off) {
          final error = BleError.adapterOff();
          _updateTrainerState(BleConnectionState.fromBleError(error));
          _updateHrState(BleConnectionState.fromBleError(error));
          _reconnectionManager.cancelReconnection();
        } else if (state == BluetoothAdapterState.on) {
          // Bluetooth ist wieder an - versuche zu reconnecten wenn wir im Fehler-Zustand sind
          if (_autoReconnectEnabled && _lastConnectedTrainerId != null &&
              _currentState.status == ConnectionStatus.error &&
              !_reconnectionManager.isReconnecting) {
            logger.i('Bluetooth turned back on - attempting trainer reconnect');
            Future.delayed(const Duration(seconds: 1), () {
              _handleTrainerDisconnection();
            });
          }
          if (_autoReconnectEnabled && _lastConnectedHrMonitorId != null &&
              _hrCurrentState.status == ConnectionStatus.error &&
              !_reconnectionManager.isReconnecting) {
            logger.i('Bluetooth turned back on - attempting HR monitor reconnect');
            Future.delayed(const Duration(seconds: 1), () {
              _handleHrMonitorDisconnection();
            });
          }
        }
      });

      logger.i('BLE Manager initialized successfully');
    } catch (e) {
      logger.e('BLE initialization error: $e');
      _isSupported = false;
      _updateTrainerState(BleConnectionState.fromBleError(BleError.notSupported()));
    }
  }

  /// Fordert Bluetooth-Berechtigungen an (Android 12+)
  Future<bool> requestPermissions() async {
    if (!Platform.isAndroid) return true;

    try {
      logger.i('Requesting Bluetooth permissions...');

      // Android 12+ (API 31+) braucht BLUETOOTH_SCAN und BLUETOOTH_CONNECT
      final scanStatus = await Permission.bluetoothScan.request();
      final connectStatus = await Permission.bluetoothConnect.request();

      logger.d('Bluetooth Scan permission: $scanStatus');
      logger.d('Bluetooth Connect permission: $connectStatus');

      if (scanStatus.isDenied || connectStatus.isDenied) {
        logger.w('Bluetooth permissions denied');
        return false;
      }

      if (scanStatus.isPermanentlyDenied || connectStatus.isPermanentlyDenied) {
        logger.w('Bluetooth permissions permanently denied - open settings');
        await openAppSettings();
        return false;
      }

      // Auf älteren Android-Versionen auch Location
      final locationStatus = await Permission.locationWhenInUse.request();
      logger.d('Location permission: $locationStatus');

      return scanStatus.isGranted && connectStatus.isGranted;
    } catch (e) {
      logger.e('Permission request error: $e');
      return false;
    }
  }

  /// Startet den BLE-Scan nach allen unterstützten Geräten
  Future<void> startScan({Duration timeout = const Duration(seconds: 10)}) async {
    if (!_isSupported) {
      logger.w('BLE not supported - scan skipped');
      return;
    }

    // Berechtigungen anfordern (Android 12+)
    final hasPermissions = await requestPermissions();
    if (!hasPermissions) {
      logger.e('Bluetooth permissions not granted');
      _updateTrainerState(BleConnectionState.fromBleError(BleError.permissionDenied()));
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

      // Verbinde (längerer Timeout für stabilen Connect)
      await device.bluetoothDevice.connect(
        timeout: const Duration(seconds: 30),
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

      // Services entdecken (mit Timeout)
      logger.d('Discovering trainer services...');
      final services = await device.bluetoothDevice.discoverServices().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Service discovery timed out', const Duration(seconds: 15));
        },
      );

      // Alle Services loggen für Debugging
      logger.i('Found ${services.length} services:');
      for (final service in services) {
        logger.d('  Service: ${service.uuid}');
        for (final char in service.characteristics) {
          logger.d('    Characteristic: ${char.uuid}');
        }
      }

      // FTMS Service finden und initialisieren
      // Standard FTMS UUID: 00001826-0000-1000-8000-00805f9b34fb
      for (final service in services) {
        final uuid = service.uuid.toString().toLowerCase();
        if (uuid == '00001826-0000-1000-8000-00805f9b34fb' || uuid.contains('1826')) {
          logger.i('Found FTMS service: $uuid');
          _ftmsService = FtmsService(service);
          await _ftmsService!.initialize();
          break;
        }
      }

      // Fallback: Wahoo proprietärer Service oder Cycling Power
      if (_ftmsService == null) {
        for (final service in services) {
          final uuid = service.uuid.toString().toLowerCase();
          // Cycling Power Service (0x1818)
          if (uuid.contains('1818')) {
            logger.i('Found Cycling Power service (no FTMS): $uuid');
            // TODO: Implement Cycling Power Service support
          }
          // Wahoo proprietär
          if (uuid.contains('a026')) {
            logger.i('Found Wahoo proprietary service: $uuid');
          }
        }
      }

      if (_ftmsService == null) {
        logger.e('No FTMS service found on device');
        await device.bluetoothDevice.disconnect();
        _updateTrainerState(BleConnectionState.fromBleError(BleError.serviceNotFound('FTMS')));
        return false;
      }

      _connectedTrainer = device.bluetoothDevice;
      _lastConnectedTrainerId = device.id;
      _updateTrainerState(BleConnectionState.connected(device));
      logger.i('Connected successfully to Trainer: ${device.name}');
      return true;
    } on TimeoutException {
      logger.e('Trainer connection/discovery timed out');
      _updateTrainerState(BleConnectionState.fromBleError(BleError.connectionTimeout()));
      return false;
    } catch (e) {
      logger.e('Trainer connection error: $e');
      _updateTrainerState(BleConnectionState.fromBleError(BleError.unknown('$e')));
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

      // DEBUG: Alle Services loggen
      logger.i('Found ${services.length} services on device ${device.name}:');
      for (final service in services) {
        logger.i('  - Service UUID: ${service.uuid} (${service.uuid.toString().toLowerCase()})');
        logger.i('    Characteristics: ${service.characteristics.length}');
        for (final char in service.characteristics) {
          logger.i('      - ${char.uuid}');
        }
      }

      // Heart Rate Service finden und initialisieren
      for (final service in services) {
        final serviceUuid = service.uuid.toString().toLowerCase();
        // Vergleiche beide Formen: Kurzform (180d) und Langform (0000180d-0000-1000-8000-00805f9b34fb)
        if (serviceUuid == heartRateServiceUuid ||
            serviceUuid == '180d' ||
            serviceUuid.contains('180d')) {
          logger.i('✓ Found Heart Rate service: $serviceUuid');
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
        _updateHrState(BleConnectionState.fromBleError(BleError.serviceNotFound('HR')));
        return false;
      }

      _connectedHrMonitor = device.bluetoothDevice;
      _lastConnectedHrMonitorId = device.id;
      _updateHrState(BleConnectionState.connected(device));
      logger.i('Connected successfully to HR Monitor: ${device.name}');
      return true;
    } on TimeoutException {
      logger.e('HR Monitor connection timed out');
      _updateHrState(BleConnectionState.fromBleError(BleError.connectionTimeout()));
      return false;
    } catch (e) {
      logger.e('HR Monitor connection error: $e');
      _updateHrState(BleConnectionState.fromBleError(BleError.unknown('$e')));
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
    logger.i('Disconnecting Trainer (manual)');
    _isManualDisconnect = true; // Verhindere Auto-Reconnect
    _reconnectionManager.cancelReconnection();

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
    _isManualDisconnect = false; // Reset für nächste Disconnection
  }

  /// Trennt die HR Monitor-Verbindung
  Future<void> disconnectHrMonitor() async {
    logger.i('Disconnecting HR Monitor (manual)');
    _isManualDisconnect = true; // Verhindere Auto-Reconnect
    _reconnectionManager.cancelReconnection();

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
    _isManualDisconnect = false; // Reset für nächste Disconnection
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
    logger.w('Trainer disconnected unexpectedly');

    // Cleanup
    _ftmsService?.dispose();
    _ftmsService = null;
    _connectedTrainer = null;

    // Verhindere Auto-Reconnect bei manuellem Disconnect
    if (_isManualDisconnect) {
      _updateTrainerState(BleConnectionState.disconnected());
      return;
    }

    _updateTrainerState(BleConnectionState.disconnected());

    // Starte exponentiellen Backoff für Reconnection
    if (_autoReconnectEnabled && _lastConnectedTrainerId != null) {
      logger.i('Starting auto-reconnect for trainer: $_lastConnectedTrainerId');
      _reconnectionManager.startReconnection(
        deviceId: _lastConnectedTrainerId!,
        reconnectFunction: () async {
          // Update state to reconnecting
          _updateTrainerState(BleConnectionState.reconnecting(
            BleDevice(
              id: _lastConnectedTrainerId!,
              name: 'Previous Trainer',
              rssi: 0,
              bluetoothDevice: _connectedTrainer ?? BluetoothDevice(remoteId: DeviceIdentifier(_lastConnectedTrainerId!)),
              deviceType: BleDeviceType.trainer,
            ),
          ));
          return await reconnectTrainer();
        },
        onStateChange: (state) {
          if (state.status == ReconnectionStatus.failed) {
            _updateTrainerState(BleConnectionState.fromBleError(
              BleError.reconnectionFailed(state.maxAttempts),
            ));
          }
        },
      );
    }
  }

  void _handleHrMonitorDisconnection() {
    logger.w('HR Monitor disconnected unexpectedly');

    // Cleanup
    _hrDataSubscription?.cancel();
    _heartRateService?.dispose();
    _heartRateService = null;
    _connectedHrMonitor = null;

    // Verhindere Auto-Reconnect bei manuellem Disconnect
    if (_isManualDisconnect) {
      _updateHrState(BleConnectionState.disconnected());
      return;
    }

    _updateHrState(BleConnectionState.disconnected());

    // Starte exponentiellen Backoff für Reconnection
    if (_autoReconnectEnabled && _lastConnectedHrMonitorId != null) {
      logger.i('Starting auto-reconnect for HR Monitor: $_lastConnectedHrMonitorId');
      _reconnectionManager.startReconnection(
        deviceId: _lastConnectedHrMonitorId!,
        reconnectFunction: () async {
          // Update state to reconnecting
          _updateHrState(BleConnectionState.reconnecting(
            BleDevice(
              id: _lastConnectedHrMonitorId!,
              name: 'Previous HR Monitor',
              rssi: 0,
              bluetoothDevice: _connectedHrMonitor ?? BluetoothDevice(remoteId: DeviceIdentifier(_lastConnectedHrMonitorId!)),
              deviceType: BleDeviceType.heartRateMonitor,
            ),
          ));

          // Scan für das Gerät und reconnect
          await startScan(timeout: const Duration(seconds: 5));
          final device = _devices.where((d) => d.id == _lastConnectedHrMonitorId).firstOrNull;
          if (device != null) {
            return await connectHrMonitor(device);
          }
          return false;
        },
        onStateChange: (state) {
          if (state.status == ReconnectionStatus.failed) {
            _updateHrState(BleConnectionState.fromBleError(
              BleError.reconnectionFailed(state.maxAttempts),
            ));
          }
        },
      );
    }
  }

  /// Versucht die letzte fehlgeschlagene Verbindung erneut
  Future<bool> retryLastConnection() async {
    if (_lastConnectedTrainerId != null && _currentState.hasError) {
      logger.i('Retrying last trainer connection');
      return reconnectTrainer();
    }
    if (_lastConnectedHrMonitorId != null && _hrCurrentState.hasError) {
      logger.i('Retrying last HR monitor connection');
      await startScan(timeout: const Duration(seconds: 5));
      final device = _devices.where((d) => d.id == _lastConnectedHrMonitorId).firstOrNull;
      if (device != null) {
        return connectHrMonitor(device);
      }
    }
    return false;
  }

  void _updateTrainerState(BleConnectionState state) {
    _currentState = state;
    if (!_disposed && !_connectionStateController.isClosed) {
      _connectionStateController.add(state);
    }
  }

  void _updateHrState(BleConnectionState state) {
    _hrCurrentState = state;
    if (!_disposed && !_hrConnectionStateController.isClosed) {
      _hrConnectionStateController.add(state);
    }
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
    if (!enabled) {
      logger.i('Auto-Reconnect disabled - cancelling active reconnection');
      _reconnectionManager.cancelReconnection();
    }
  }

  /// Gibt zurück ob Auto-Reconnect aktiviert ist
  bool get autoReconnectEnabled => _autoReconnectEnabled;

  void dispose() {
    _disposed = true;
    _trainerConnectionSubscription?.cancel();
    _hrConnectionSubscription?.cancel();
    _hrDataSubscription?.cancel();
    _scanSubscription?.cancel();
    _adapterStateSubscription?.cancel();
    _reconnectionManager.dispose();
    _connectionStateController.close();
    _hrConnectionStateController.close();
    _discoveredDevicesController.close();
    _scanningController.close();
    _hrDataController.close();
    _ftmsService?.dispose();
    _heartRateService?.dispose();
  }
}
