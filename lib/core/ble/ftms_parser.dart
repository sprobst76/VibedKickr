import 'models/ftms_data.dart';

/// Hilfsfunktionen zum Parsen von FTMS BLE-Daten
/// Extrahiert aus FtmsService für bessere Testbarkeit
class FtmsParser {
  /// Parst Indoor Bike Data Characteristic nach FTMS Spec
  /// Returns null wenn Daten ungültig sind
  static FtmsData? parseIndoorBikeData(List<int> data) {
    if (data.length < 2) return null;

    final flags = bytesToUint16(data, 0);
    int offset = 2;

    // Instantaneous Speed (0.01 km/h resolution)
    double? speed;
    if ((flags & 0x01) == 0) {
      // Bit 0 = 0 means speed is present
      if (data.length >= offset + 2) {
        speed = bytesToUint16(data, offset) * 0.01;
        offset += 2;
      }
    }

    // Average Speed - skip if present
    if ((flags & 0x02) != 0) {
      if (data.length >= offset + 2) {
        offset += 2;
      }
    }

    // Instantaneous Cadence (0.5 rpm resolution)
    int? cadence;
    if ((flags & 0x04) != 0) {
      if (data.length >= offset + 2) {
        cadence = (bytesToUint16(data, offset) * 0.5).round();
        offset += 2;
      }
    }

    // Average Cadence - skip if present
    if ((flags & 0x08) != 0) {
      if (data.length >= offset + 2) {
        offset += 2;
      }
    }

    // Total Distance (24-bit)
    int? distance;
    if ((flags & 0x10) != 0) {
      if (data.length >= offset + 3) {
        distance = data[offset] | (data[offset + 1] << 8) | (data[offset + 2] << 16);
        offset += 3;
      }
    }

    // Resistance Level - skip if present
    if ((flags & 0x20) != 0) {
      if (data.length >= offset + 2) {
        offset += 2;
      }
    }

    // Instantaneous Power (signed 16-bit)
    int? power;
    if ((flags & 0x40) != 0) {
      if (data.length >= offset + 2) {
        power = bytesToInt16(data, offset);
        offset += 2;
      }
    }

    // Average Power - skip if present
    if ((flags & 0x80) != 0) {
      if (data.length >= offset + 2) {
        offset += 2;
      }
    }

    // Expended Energy (total, per hour, per minute)
    int? calories;
    if ((flags & 0x100) != 0) {
      if (data.length >= offset + 2) {
        calories = bytesToUint16(data, offset);
        offset += 2;
        // Skip per hour and per minute (2 + 2 bytes)
        if (data.length >= offset + 4) {
          offset += 4;
        }
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

    return FtmsData(
      timestamp: DateTime.now(),
      power: power ?? 0,
      cadence: cadence,
      speed: speed,
      distance: distance,
      heartRate: heartRate,
      calories: calories,
    );
  }

  /// Konvertiert 2 Bytes zu unsigned 16-bit Integer (Little Endian)
  static int bytesToUint16(List<int> data, int offset) {
    if (data.length < offset + 2) return 0;
    return data[offset] | (data[offset + 1] << 8);
  }

  /// Konvertiert 2 Bytes zu signed 16-bit Integer (Little Endian)
  static int bytesToInt16(List<int> data, int offset) {
    if (data.length < offset + 2) return 0;
    final value = data[offset] | (data[offset + 1] << 8);
    return value > 32767 ? value - 65536 : value;
  }

  /// Erstellt Set Target Power Command (Op Code 0x05)
  static List<int> createSetTargetPowerCommand(int watts) {
    return [
      0x05,
      watts & 0xFF,
      (watts >> 8) & 0xFF,
    ];
  }

  /// Erstellt Set Target Resistance Command (Op Code 0x04)
  static List<int> createSetResistanceCommand(int levelPercent) {
    final levelValue = (levelPercent * 10).clamp(0, 1000);
    return [
      0x04,
      levelValue & 0xFF,
      (levelValue >> 8) & 0xFF,
    ];
  }

  /// Erstellt Set Indoor Bike Simulation Parameters Command (Op Code 0x11)
  static List<int> createSimulationCommand({
    required double grade,
    double windSpeed = 0,
    double crr = 0.004,
    double cw = 0.51,
  }) {
    // Wind Speed (m/s * 1000, signed 16-bit)
    final windSpeedInt = (windSpeed * 1000).round();
    final windSpeedSigned = windSpeedInt < 0 ? windSpeedInt + 65536 : windSpeedInt;

    // Grade (% * 100, signed 16-bit)
    final gradeInt = (grade * 100).round();
    final gradeSigned = gradeInt < 0 ? gradeInt + 65536 : gradeInt;

    return [
      0x11,
      windSpeedSigned & 0xFF,
      (windSpeedSigned >> 8) & 0xFF,
      gradeSigned & 0xFF,
      (gradeSigned >> 8) & 0xFF,
      (crr * 10000).round().clamp(0, 255),
      (cw * 100).round().clamp(0, 255),
    ];
  }
}
