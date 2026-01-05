import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../main.dart';
import 'models/ftms_data.dart';

/// FTMS (Fitness Machine Service) Implementation
/// Handles communication with smart trainers following the FTMS spec
class FtmsService {
  final BluetoothService _service;

  // FTMS Characteristics UUIDs (for documentation/reference)
  // ignore: unused_field
  static const _indoorBikeDataUuid = '2ad2';
  // ignore: unused_field
  static const _fitnessMachineControlUuid = '2ad9';
  // ignore: unused_field
  static const _fitnessMachineStatusUuid = '2ada';
  // ignore: unused_field
  static const _supportedResistanceRangeUuid = '2ad6';
  // ignore: unused_field
  static const _supportedPowerRangeUuid = '2ad8';

  BluetoothCharacteristic? _indoorBikeDataChar;
  BluetoothCharacteristic? _controlPointChar;
  BluetoothCharacteristic? _statusChar;
  BluetoothCharacteristic? _resistanceRangeChar;
  BluetoothCharacteristic? _powerRangeChar;

  final _dataController = StreamController<FtmsData>.broadcast();
  final _statusController = StreamController<FtmsStatus>.broadcast();
  StreamSubscription<List<int>>? _dataSubscription;
  StreamSubscription<List<int>>? _statusSubscription;

  /// Stream von Trainer-Daten (Power, Kadenz, Geschwindigkeit)
  Stream<FtmsData> get dataStream => _dataController.stream;

  /// Stream von Status-Updates (Kontrolle akzeptiert, Fehler, etc.)
  Stream<FtmsStatus> get statusStream => _statusController.stream;

  // Unterstützte Bereiche
  int? _minResistance;
  int? _maxResistance;
  int? _minPower;
  int? _maxPower;

  int? get minPower => _minPower;
  int? get maxPower => _maxPower;

  FtmsService(this._service);

  /// Initialisiert den FTMS Service
  Future<void> initialize() async {
    logger.i('Initializing FTMS Service');

    for (final char in _service.characteristics) {
      final uuid = char.uuid.toString().toLowerCase();

      if (uuid.contains('2ad2')) {
        _indoorBikeDataChar = char;
        logger.d('Found Indoor Bike Data characteristic');
      } else if (uuid.contains('2ad9')) {
        _controlPointChar = char;
        logger.d('Found Control Point characteristic');
      } else if (uuid.contains('2ada')) {
        _statusChar = char;
        logger.d('Found Status characteristic');
      } else if (uuid.contains('2ad6')) {
        _resistanceRangeChar = char;
      } else if (uuid.contains('2ad8')) {
        _powerRangeChar = char;
      }
    }

    // Unterstützte Bereiche lesen
    await _readSupportedRanges();

    // Notifications für Bike Data aktivieren
    if (_indoorBikeDataChar != null) {
      try {
        await _indoorBikeDataChar!.setNotifyValue(true);
        _dataSubscription = _indoorBikeDataChar!.onValueReceived.listen((data) {
          logger.d('Received Indoor Bike Data: ${data.length} bytes: $data');
          _parseIndoorBikeData(data);
        });
        logger.i('Indoor Bike Data notifications enabled');
      } catch (e) {
        logger.e('Failed to enable Indoor Bike Data notifications: $e');
      }
    } else {
      logger.e('Indoor Bike Data characteristic NOT found!');
    }

    // Notifications für Status aktivieren
    if (_statusChar != null) {
      await _statusChar!.setNotifyValue(true);
      _statusSubscription = _statusChar!.onValueReceived.listen(_parseStatus);
      logger.d('Status notifications enabled');
    }

    // Control Point Request Control
    await requestControl();
  }

  Future<void> _readSupportedRanges() async {
    try {
      if (_powerRangeChar != null) {
        final data = await _powerRangeChar!.read();
        if (data.length >= 6) {
          _minPower = _bytesToUint16(data, 0);
          _maxPower = _bytesToUint16(data, 2);
          logger.d('Power range: $_minPower - $_maxPower W');
        }
      }

      if (_resistanceRangeChar != null) {
        final data = await _resistanceRangeChar!.read();
        if (data.length >= 6) {
          _minResistance = _bytesToUint16(data, 0);
          _maxResistance = _bytesToUint16(data, 2);
          logger.d('Resistance range: $_minResistance - $_maxResistance');
        }
      }
    } catch (e) {
      logger.w('Could not read supported ranges: $e');
    }
  }

  /// Parst Indoor Bike Data Characteristic
  void _parseIndoorBikeData(List<int> data) {
    if (data.length < 2) return;

    final flags = _bytesToUint16(data, 0);
    int offset = 2;

    // Instantaneous Speed (0.01 km/h resolution)
    double? speed;
    if ((flags & 0x01) == 0) {
      // Bit 0 = 0 means speed is present
      if (data.length >= offset + 2) {
        speed = _bytesToUint16(data, offset) * 0.01;
        offset += 2;
      }
    }

    // Average Speed - skip if present
    if ((flags & 0x02) != 0) {
      offset += 2;
    }

    // Instantaneous Cadence (0.5 rpm resolution)
    int? cadence;
    if ((flags & 0x04) != 0) {
      if (data.length >= offset + 2) {
        cadence = (_bytesToUint16(data, offset) * 0.5).round();
        offset += 2;
      }
    }

    // Average Cadence - skip if present
    if ((flags & 0x08) != 0) {
      offset += 2;
    }

    // Total Distance - skip if present
    int? distance;
    if ((flags & 0x10) != 0) {
      if (data.length >= offset + 3) {
        distance = data[offset] | (data[offset + 1] << 8) | (data[offset + 2] << 16);
        offset += 3;
      }
    }

    // Resistance Level - skip if present
    if ((flags & 0x20) != 0) {
      offset += 2;
    }

    // Instantaneous Power
    int? power;
    if ((flags & 0x40) != 0) {
      if (data.length >= offset + 2) {
        power = _bytesToInt16(data, offset);
        offset += 2;
      }
    }

    // Average Power - skip if present
    if ((flags & 0x80) != 0) {
      offset += 2;
    }

    // Expended Energy
    int? calories;
    if ((flags & 0x100) != 0) {
      if (data.length >= offset + 2) {
        calories = _bytesToUint16(data, offset);
        offset += 2;
        // Skip per hour and per minute
        offset += 2;
      }
    }

    // Heart Rate
    int? heartRate;
    if ((flags & 0x200) != 0) {
      if (data.length >= offset + 1) {
        heartRate = data[offset];
        offset += 1;
      }
    }

    final ftmsData = FtmsData(
      timestamp: DateTime.now(),
      power: power ?? 0,
      cadence: cadence,
      speed: speed,
      distance: distance,
      heartRate: heartRate,
      calories: calories,
    );

    logger.d('Parsed FTMS: power=$power, cadence=$cadence, speed=$speed (flags=0x${flags.toRadixString(16)})');
    _dataController.add(ftmsData);
  }

  void _parseStatus(List<int> data) {
    if (data.isEmpty) return;

    final opCode = data[0];
    final status = FtmsStatus.fromOpCode(opCode, data.sublist(1));
    _statusController.add(status);
    logger.d('FTMS Status: ${status.message}');
  }

  /// Fordert Kontrolle über den Trainer an
  Future<bool> requestControl() async {
    if (_controlPointChar == null) {
      logger.e('Control Point not available');
      return false;
    }

    try {
      // Op Code 0x00 = Request Control
      await _controlPointChar!.write([0x00], withoutResponse: false);
      logger.i('Control requested');
      return true;
    } catch (e) {
      logger.e('Request control failed: $e');
      return false;
    }
  }

  /// Setzt den Trainer in ERG-Modus mit Ziel-Watt
  Future<bool> setTargetPower(int watts) async {
    if (_controlPointChar == null) return false;

    // Clamp auf unterstützten Bereich
    if (_minPower != null && watts < _minPower!) watts = _minPower!;
    if (_maxPower != null && watts > _maxPower!) watts = _maxPower!;

    try {
      // Op Code 0x05 = Set Target Power
      final data = Uint8List(3);
      data[0] = 0x05;
      data[1] = watts & 0xFF;
      data[2] = (watts >> 8) & 0xFF;

      await _controlPointChar!.write(data.toList(), withoutResponse: false);
      logger.d('Target power set to $watts W');
      return true;
    } catch (e) {
      logger.e('Set target power failed: $e');
      return false;
    }
  }

  /// Setzt Simulation Parameter (Steigung, Wind, etc.)
  /// grade: Steigung in % (z.B. 5.0 für 5%)
  /// crr: Rollwiderstandskoeffizient (Standard: 0.004)
  /// cw: Windwiderstandskoeffizient (Standard: 0.51)
  Future<bool> setSimulationParameters({
    required double grade,
    double crr = 0.004,
    double cw = 0.51,
    double windSpeed = 0,
  }) async {
    if (_controlPointChar == null) return false;

    try {
      // Op Code 0x11 = Set Indoor Bike Simulation Parameters
      final data = Uint8List(7);
      data[0] = 0x11;

      // Wind Speed (m/s * 1000, signed 16-bit)
      final windSpeedInt = (windSpeed * 1000).round().toSigned(16);
      data[1] = windSpeedInt & 0xFF;
      data[2] = (windSpeedInt >> 8) & 0xFF;

      // Grade (% * 100, signed 16-bit)
      final gradeInt = (grade * 100).round().toSigned(16);
      data[3] = gradeInt & 0xFF;
      data[4] = (gradeInt >> 8) & 0xFF;

      // CRR (coefficient * 10000, unsigned 8-bit)
      data[5] = (crr * 10000).round().clamp(0, 255);

      // CW (coefficient * 100, unsigned 8-bit)
      data[6] = (cw * 100).round().clamp(0, 255);

      await _controlPointChar!.write(data.toList(), withoutResponse: false);
      logger.d('Simulation params set: grade=$grade%, crr=$crr, cw=$cw');
      return true;
    } catch (e) {
      logger.e('Set simulation params failed: $e');
      return false;
    }
  }

  /// Setzt den Widerstandslevel (0-100%)
  Future<bool> setResistanceLevel(int level) async {
    if (_controlPointChar == null) return false;

    try {
      // Op Code 0x04 = Set Target Resistance Level
      final data = Uint8List(3);
      data[0] = 0x04;
      // Level in 0.1 units
      final levelValue = (level * 10).clamp(0, 1000);
      data[1] = levelValue & 0xFF;
      data[2] = (levelValue >> 8) & 0xFF;

      await _controlPointChar!.write(data.toList(), withoutResponse: false);
      logger.d('Resistance level set to $level%');
      return true;
    } catch (e) {
      logger.e('Set resistance level failed: $e');
      return false;
    }
  }

  /// Startet Spindown-Kalibrierung
  Future<bool> startSpindown() async {
    if (_controlPointChar == null) return false;

    try {
      // Op Code 0x01 = Reset
      // Op Code 0x02 = Spindown Control (Wahoo-spezifisch)
      await _controlPointChar!.write([0x01], withoutResponse: false);
      logger.i('Spindown started');
      return true;
    } catch (e) {
      logger.e('Spindown start failed: $e');
      return false;
    }
  }

  /// Stoppt das Training / Reset
  Future<bool> reset() async {
    if (_controlPointChar == null) return false;

    try {
      await _controlPointChar!.write([0x01], withoutResponse: false);
      logger.i('Trainer reset');
      return true;
    } catch (e) {
      logger.e('Reset failed: $e');
      return false;
    }
  }

  int _bytesToUint16(List<int> data, int offset) {
    return data[offset] | (data[offset + 1] << 8);
  }

  int _bytesToInt16(List<int> data, int offset) {
    final value = data[offset] | (data[offset + 1] << 8);
    return value > 32767 ? value - 65536 : value;
  }

  void dispose() {
    _dataSubscription?.cancel();
    _statusSubscription?.cancel();
    _dataController.close();
    _statusController.close();
  }
}
