import 'package:equatable/equatable.dart';

/// Daten vom Fitness Machine Service
class FtmsData extends Equatable {
  final DateTime timestamp;
  final int power; // Watt
  final int? cadence; // RPM
  final double? speed; // km/h
  final int? distance; // Meter (kumulativ)
  final int? heartRate; // BPM (falls vom Trainer geliefert)
  final int? calories; // kcal

  const FtmsData({
    required this.timestamp,
    required this.power,
    this.cadence,
    this.speed,
    this.distance,
    this.heartRate,
    this.calories,
  });

  /// Leerer Datenpunkt
  factory FtmsData.empty() => FtmsData(
        timestamp: DateTime.now(),
        power: 0,
      );

  @override
  List<Object?> get props =>
      [timestamp, power, cadence, speed, distance, heartRate, calories];
}

/// FTMS Status-Nachrichten
class FtmsStatus extends Equatable {
  final int opCode;
  final String message;
  final bool isSuccess;
  final List<int> rawData;

  const FtmsStatus({
    required this.opCode,
    required this.message,
    required this.isSuccess,
    required this.rawData,
  });

  factory FtmsStatus.fromOpCode(int opCode, List<int> data) {
    final message = switch (opCode) {
      0x01 => 'Reset',
      0x02 => 'Fitness Machine Stopped/Paused by User',
      0x03 => 'Fitness Machine Stopped by Safety Key',
      0x04 => 'Fitness Machine Started/Resumed by User',
      0x05 => 'Target Speed Changed',
      0x06 => 'Target Incline Changed',
      0x07 => 'Target Resistance Level Changed',
      0x08 => 'Target Power Changed',
      0x09 => 'Target Heart Rate Changed',
      0x0A => 'Targeted Expended Energy Changed',
      0x0B => 'Targeted Number of Steps Changed',
      0x0C => 'Targeted Number of Strides Changed',
      0x0D => 'Targeted Distance Changed',
      0x0E => 'Targeted Training Time Changed',
      0x0F => 'Targeted Time in Two Heart Rate Zones Changed',
      0x10 => 'Targeted Time in Three Heart Rate Zones Changed',
      0x11 => 'Targeted Time in Five Heart Rate Zones Changed',
      0x12 => 'Indoor Bike Simulation Parameters Changed',
      0x13 => 'Wheel Circumference Changed',
      0x14 => 'Spin Down Status',
      0x15 => 'Targeted Cadence Changed',
      0xFF => 'Control Permission Lost',
      _ => 'Unknown Status (0x${opCode.toRadixString(16)})',
    };

    final isSuccess = opCode != 0xFF && opCode != 0x02 && opCode != 0x03;

    return FtmsStatus(
      opCode: opCode,
      message: message,
      isSuccess: isSuccess,
      rawData: data,
    );
  }

  @override
  List<Object?> get props => [opCode, message, isSuccess, rawData];
}

/// Control Point Response
class FtmsControlResponse extends Equatable {
  final int requestOpCode;
  final FtmsResultCode resultCode;
  final List<int> responseData;

  const FtmsControlResponse({
    required this.requestOpCode,
    required this.resultCode,
    required this.responseData,
  });

  bool get isSuccess => resultCode == FtmsResultCode.success;

  @override
  List<Object?> get props => [requestOpCode, resultCode, responseData];
}

enum FtmsResultCode {
  success(0x01),
  notSupported(0x02),
  invalidParameter(0x03),
  operationFailed(0x04),
  controlNotPermitted(0x05),
  unknown(0xFF);

  final int code;
  const FtmsResultCode(this.code);

  static FtmsResultCode fromCode(int code) {
    return FtmsResultCode.values.firstWhere(
      (e) => e.code == code,
      orElse: () => FtmsResultCode.unknown,
    );
  }
}
