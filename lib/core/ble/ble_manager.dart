import 'dart:async';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../main.dart';
import 'ftms_service.dart';
import 'models/ble_device.dart';
import 'models/connection_state.dart';

/// Zentrale Klasse für BLE-Kommunikation
class BleManager {
  static final BleManager _instance = BleManager._internal();
  static BleManager get instance => _instance;

  BleManager._internal();

  // State
  final _connectionStateController = StreamController<BleConnectionState>.broadcast();
  final _discoveredDevicesController = StreamController<List<BleDevice>>.broadcast();
  final _scanningController = StreamController<bool>.broadcast();

  Stream<BleConnectionState> get connectionState => _connectionStateController.stream;
  Stream<List<BleDevice>> get discoveredDevices => _discoveredDevicesController.stream;
  Stream<bool> get isScanning => _scanningController.stream;

  BleConnectionState _currentState = BleConnectionState.disconnected();
  BleConnectionState get currentState => _currentState;

  final List<BleDevice> _devices = [];
  BluetoothDevice? _connectedDevice;
  FtmsService? _ftmsService;
  StreamSubscription<BluetoothConnectionState>? _connectionSubscription;
  StreamSubscription<List<ScanResult>>? _scanSubscription;

  // Für Auto-Reconnect
  String? _lastConnectedDeviceId;
  bool _autoReconnectEnabled = true;
  
  // Platform support
  bool _isSupported = false;
  bool get isSupported => _isSupported;

  /// FTMS Service für Trainer-Steuerung
  FtmsService? get ftmsService => _ftmsService;

  /// Initialisiert BLE
  Future<void> initialize() async {
    logger.i('Initializing BLE Manager');

    // Prüfe Plattform-Unterstützung BEVOR wir flutter_blue_plus aufrufen
    if (Platform.isWindows) {
      logger.w('BLE not supported on Windows via flutter_blue_plus');
      logger.w('Use Android or macOS for BLE support');
      _isSupported = false;
      _updateState(BleConnectionState.error(
        'BLE wird auf Windows nicht unterstützt.\nBitte Android/macOS verwenden.'
      ));
      return;
    }

    try {
      // Prüfe ob BLE verfügbar - nur auf unterstützten Plattformen
      _isSupported = await FlutterBluePlus.isSupported;
      if (!_isSupported) {
        logger.e('Bluetooth not supported on this device');
        _updateState(BleConnectionState.error('Bluetooth wird nicht unterstützt'));
        return;
      }

      // Auf Desktop: Adapter-Status überwachen
      if (Platform.isMacOS || Platform.isLinux) {
        FlutterBluePlus.adapterState.listen((state) {
          logger.d('Adapter state: $state');
          if (state == BluetoothAdapterState.off) {
            _updateState(BleConnectionState.error('Bluetooth ist ausgeschaltet'));
          }
        });
      }

      logger.i('BLE Manager initialized successfully');
    } catch (e) {
      logger.e('BLE initialization error: $e');
      _isSupported = false;
      _updateState(BleConnectionState.error('BLE nicht verfügbar'));
    }
  }

  /// Startet den BLE-Scan nach FTMS-Geräten
  Future<void> startScan({Duration timeout = const Duration(seconds: 10)}) async {
    if (!_isSupported) {
      logger.w('BLE not supported - scan skipped');
      return;
    }
    
    logger.i('Starting BLE scan');
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
          // Filtere nach FTMS-Geräten oder bekannten Namen
          if (_isFtmsDevice(result)) {
            final device = BleDevice(
              id: result.device.remoteId.str,
              name: result.device.platformName.isNotEmpty
                  ? result.device.platformName
                  : 'Unknown Device',
              rssi: result.rssi,
              bluetoothDevice: result.device,
            );

            final existingIndex = _devices.indexWhere((d) => d.id == device.id);
            if (existingIndex >= 0) {
              _devices[existingIndex] = device;
            } else {
              _devices.add(device);
              logger.d('Found device: ${device.name} (${device.id})');
            }

            _discoveredDevicesController.add(List.from(_devices));
          }
        }
      });

      await FlutterBluePlus.startScan(
        timeout: timeout,
        // Filter im Callback statt hier - vermeidet Guid API-Probleme
      );

      // Warte auf Scan-Ende
      await Future.delayed(timeout);
    } catch (e) {
      logger.e('Scan error: $e');
    } finally {
      _scanningController.add(false);
      logger.i('Scan complete. Found ${_devices.length} devices');
    }
  }

  /// Stoppt den laufenden Scan
  Future<void> stopScan() async {
    if (!_isSupported) return;
    await FlutterBluePlus.stopScan();
    _scanningController.add(false);
  }

  /// Verbindet mit einem Gerät
  Future<bool> connect(BleDevice device) async {
    if (!_isSupported) {
      logger.w('BLE not supported - connect skipped');
      return false;
    }
    
    logger.i('Connecting to ${device.name}');
    _updateState(BleConnectionState.connecting(device));

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
      _connectionSubscription?.cancel();
      _connectionSubscription = device.bluetoothDevice.connectionState.listen(
        (state) {
          logger.d('Connection state changed: $state');
          if (state == BluetoothConnectionState.disconnected) {
            _handleDisconnection();
          }
        },
      );

      // Services entdecken
      logger.d('Discovering services...');
      final services = await device.bluetoothDevice.discoverServices();

      // FTMS Service finden und initialisieren
      for (final service in services) {
        // Vergleiche UUID als String (case-insensitive)
        if (service.uuid.toString().toLowerCase() == '00001826-0000-1000-8000-00805f9b34fb') {
          logger.i('Found FTMS service');
          _ftmsService = FtmsService(service);
          await _ftmsService!.initialize();
          break;
        }
      }

      if (_ftmsService == null) {
        logger.e('No FTMS service found');
        await disconnect();
        _updateState(BleConnectionState.error('Kein FTMS-Dienst gefunden'));
        return false;
      }

      _connectedDevice = device.bluetoothDevice;
      _lastConnectedDeviceId = device.id;
      _updateState(BleConnectionState.connected(device));
      logger.i('Connected successfully to ${device.name}');
      return true;
    } catch (e) {
      logger.e('Connection error: $e');
      _updateState(BleConnectionState.error('Verbindungsfehler: $e'));
      return false;
    }
  }

  /// Trennt die aktuelle Verbindung
  Future<void> disconnect() async {
    logger.i('Disconnecting');
    _connectionSubscription?.cancel();
    _ftmsService?.dispose();
    _ftmsService = null;

    try {
      await _connectedDevice?.disconnect();
    } catch (e) {
      logger.w('Disconnect error: $e');
    }

    _connectedDevice = null;
    _updateState(BleConnectionState.disconnected());
  }

  /// Versucht Wiederverbindung zum letzten Gerät
  Future<bool> reconnect() async {
    if (_lastConnectedDeviceId == null) {
      logger.w('No last device to reconnect to');
      return false;
    }

    logger.i('Attempting reconnect to $_lastConnectedDeviceId');

    // Kurzer Scan um Gerät zu finden
    await startScan(timeout: const Duration(seconds: 5));

    final device = _devices.where((d) => d.id == _lastConnectedDeviceId).firstOrNull;
    if (device != null) {
      return await connect(device);
    }

    logger.w('Last device not found during reconnect scan');
    return false;
  }

  void _handleDisconnection() {
    logger.w('Device disconnected');
    _ftmsService?.dispose();
    _ftmsService = null;
    _connectedDevice = null;
    _updateState(BleConnectionState.disconnected());

    // Auto-Reconnect
    if (_autoReconnectEnabled && _lastConnectedDeviceId != null) {
      logger.i('Attempting auto-reconnect in 2 seconds');
      Future.delayed(const Duration(seconds: 2), () {
        reconnect();
      });
    }
  }

  void _updateState(BleConnectionState state) {
    _currentState = state;
    _connectionStateController.add(state);
  }

  bool _isFtmsDevice(ScanResult result) {
    // Prüfe Service UUIDs
    final serviceUuids = result.advertisementData.serviceUuids;
    if (serviceUuids.any((uuid) => 
        uuid.toString().toLowerCase().contains('1826') || // FTMS
        uuid.toString().toLowerCase().contains('180d'))) { // HRM
      return true;
    }

    // Prüfe bekannte Gerätenamen
    final name = result.device.platformName.toLowerCase();
    final knownNames = ['kickr', 'wahoo', 'tacx', 'elite', 'saris', 'zwift'];
    if (knownNames.any((known) => name.contains(known))) {
      return true;
    }

    return false;
  }

  /// Aktiviert/Deaktiviert Auto-Reconnect
  void setAutoReconnect(bool enabled) {
    _autoReconnectEnabled = enabled;
  }

  void dispose() {
    _connectionSubscription?.cancel();
    _scanSubscription?.cancel();
    _connectionStateController.close();
    _discoveredDevicesController.close();
    _scanningController.close();
    _ftmsService?.dispose();
  }
}
