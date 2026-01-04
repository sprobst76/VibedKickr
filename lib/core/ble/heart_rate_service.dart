import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../main.dart';

/// Heart Rate Service UUID (0x180D)
const String heartRateServiceUuid = '0000180d-0000-1000-8000-00805f9b34fb';

/// Heart Rate Measurement Characteristic UUID (0x2A37)
const String heartRateMeasurementUuid = '00002a37-0000-1000-8000-00805f9b34fb';

/// Heart Rate Daten
class HeartRateData {
  final int heartRate; // bpm
  final bool sensorContact; // Sensor hat Hautkontakt
  final int? energyExpended; // kJ (optional)
  final List<int>? rrIntervals; // R-R Intervalle in ms (optional, für HRV)
  final DateTime timestamp;

  const HeartRateData({
    required this.heartRate,
    this.sensorContact = true,
    this.energyExpended,
    this.rrIntervals,
    required this.timestamp,
  });

  /// Berechnet HRV (Heart Rate Variability) aus R-R Intervallen
  double? get hrv {
    if (rrIntervals == null || rrIntervals!.length < 2) return null;

    // RMSSD Berechnung (Root Mean Square of Successive Differences)
    double sumSquaredDiffs = 0;
    for (int i = 1; i < rrIntervals!.length; i++) {
      final diff = rrIntervals![i] - rrIntervals![i - 1];
      sumSquaredDiffs += diff * diff;
    }
    return (sumSquaredDiffs / (rrIntervals!.length - 1)).sqrt();
  }

  @override
  String toString() => 'HeartRateData(hr: $heartRate, contact: $sensorContact)';
}

extension on double {
  double sqrt() => this >= 0 ? _sqrt(this) : 0;

  static double _sqrt(double x) {
    if (x == 0) return 0;
    double guess = x / 2;
    for (int i = 0; i < 10; i++) {
      guess = (guess + x / guess) / 2;
    }
    return guess;
  }
}

/// Heart Rate Monitor Service
/// Implementiert Bluetooth Heart Rate Profile (HRP)
class HeartRateService {
  final BluetoothService _service;

  BluetoothCharacteristic? _heartRateMeasurementChar;

  final _dataController = StreamController<HeartRateData>.broadcast();
  StreamSubscription<List<int>>? _dataSubscription;

  /// Stream von Heart Rate Daten
  Stream<HeartRateData> get dataStream => _dataController.stream;

  /// Letzter gemessener Herzfrequenzwert
  int? _lastHeartRate;
  int? get lastHeartRate => _lastHeartRate;

  HeartRateService(this._service);

  /// Initialisiert den Heart Rate Service
  Future<void> initialize() async {
    logger.i('Initializing Heart Rate Service');

    for (final char in _service.characteristics) {
      final uuid = char.uuid.toString().toLowerCase();

      if (uuid.contains('2a37')) {
        _heartRateMeasurementChar = char;
        logger.d('Found Heart Rate Measurement characteristic');
      }
    }

    if (_heartRateMeasurementChar == null) {
      logger.e('Heart Rate Measurement characteristic not found');
      return;
    }

    // Notifications aktivieren
    await _heartRateMeasurementChar!.setNotifyValue(true);
    _dataSubscription = _heartRateMeasurementChar!.onValueReceived.listen(_parseHeartRateData);
    logger.i('Heart Rate notifications enabled');
  }

  /// Parst Heart Rate Measurement Daten nach Bluetooth HRP Spec
  void _parseHeartRateData(List<int> data) {
    if (data.isEmpty) return;

    try {
      final flags = data[0];
      int offset = 1;

      // Bit 0: Heart Rate Value Format
      // 0 = UINT8, 1 = UINT16
      final isUint16 = (flags & 0x01) != 0;

      // Heart Rate Value
      int heartRate;
      if (isUint16) {
        if (data.length < 3) return;
        heartRate = data[1] | (data[2] << 8);
        offset = 3;
      } else {
        if (data.length < 2) return;
        heartRate = data[1];
        offset = 2;
      }

      // Bit 1-2: Sensor Contact Status
      final sensorContactSupported = (flags & 0x04) != 0;
      final sensorContact = !sensorContactSupported || (flags & 0x02) != 0;

      // Bit 3: Energy Expended Present
      int? energyExpended;
      if ((flags & 0x08) != 0) {
        if (data.length >= offset + 2) {
          energyExpended = data[offset] | (data[offset + 1] << 8);
          offset += 2;
        }
      }

      // Bit 4: RR-Interval Present
      List<int>? rrIntervals;
      if ((flags & 0x10) != 0) {
        rrIntervals = [];
        while (offset + 1 < data.length) {
          // RR-Interval in 1/1024 Sekunden, konvertieren zu ms
          final rrRaw = data[offset] | (data[offset + 1] << 8);
          final rrMs = (rrRaw * 1000 / 1024).round();
          rrIntervals.add(rrMs);
          offset += 2;
        }
      }

      _lastHeartRate = heartRate;

      final hrData = HeartRateData(
        heartRate: heartRate,
        sensorContact: sensorContact,
        energyExpended: energyExpended,
        rrIntervals: rrIntervals,
        timestamp: DateTime.now(),
      );

      _dataController.add(hrData);
      logger.d('HR: $heartRate bpm (contact: $sensorContact)');
    } catch (e) {
      logger.e('Error parsing HR data: $e');
    }
  }

  void dispose() {
    _dataSubscription?.cancel();
    _dataController.close();
  }
}

/// Bekannte HR Monitor Namen für bessere Erkennung
class KnownHeartRateMonitors {
  static const List<String> patterns = [
    'polar',
    'garmin',
    'wahoo',
    'tickr',
    'hrm',
    'heart',
    'h10',
    'h9',
    'h7',
    'oh1',
    'verity',
    'dual',
    'coospo',
    'magene',
  ];

  static bool isKnownHrMonitor(String name) {
    final lowerName = name.toLowerCase();
    return patterns.any((pattern) => lowerName.contains(pattern));
  }
}
