import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

/// Gerätetyp für Multi-Device Support
enum BleDeviceType {
  trainer,
  heartRateMonitor,
  unknown,
}

/// Repräsentiert ein gefundenes BLE-Gerät
class BleDevice extends Equatable {
  final String id;
  final String name;
  final int rssi;
  final BluetoothDevice bluetoothDevice;
  final BleDeviceType deviceType;

  const BleDevice({
    required this.id,
    required this.name,
    required this.rssi,
    required this.bluetoothDevice,
    this.deviceType = BleDeviceType.unknown,
  });

  /// Signalstärke als Prozent (0-100)
  int get signalStrength {
    // RSSI typisch zwischen -100 (schwach) und -30 (stark)
    final normalized = ((rssi + 100) / 70 * 100).clamp(0, 100);
    return normalized.round();
  }

  /// Gibt an ob das Gerät ein bekannter Trainer ist
  bool get isKnownTrainer {
    final lowerName = name.toLowerCase();
    return lowerName.contains('kickr') ||
        lowerName.contains('wahoo') ||
        lowerName.contains('tacx') ||
        lowerName.contains('elite') ||
        lowerName.contains('saris');
  }

  /// Ist das Gerät ein Trainer?
  bool get isTrainer => deviceType == BleDeviceType.trainer;

  /// Ist das Gerät ein HR Monitor?
  bool get isHeartRateMonitor => deviceType == BleDeviceType.heartRateMonitor;

  @override
  List<Object?> get props => [id, name, rssi, deviceType];
}
