import 'package:flutter_test/flutter_test.dart';
import 'package:kickr_trainer/core/ble/ftms_parser.dart';

void main() {
  group('FtmsParser', () {
    group('bytesToUint16', () {
      test('should convert little-endian bytes to uint16', () {
        expect(FtmsParser.bytesToUint16([0x00, 0x00], 0), 0);
        expect(FtmsParser.bytesToUint16([0x01, 0x00], 0), 1);
        expect(FtmsParser.bytesToUint16([0xFF, 0x00], 0), 255);
        expect(FtmsParser.bytesToUint16([0x00, 0x01], 0), 256);
        expect(FtmsParser.bytesToUint16([0xC8, 0x00], 0), 200); // 200W
        expect(FtmsParser.bytesToUint16([0xFF, 0xFF], 0), 65535);
      });

      test('should handle offset correctly', () {
        expect(FtmsParser.bytesToUint16([0x00, 0x00, 0xC8, 0x00], 2), 200);
        expect(FtmsParser.bytesToUint16([0x01, 0x02, 0x03, 0x04], 2), 0x0403);
      });

      test('should return 0 for insufficient data', () {
        expect(FtmsParser.bytesToUint16([0x01], 0), 0);
        expect(FtmsParser.bytesToUint16([], 0), 0);
        expect(FtmsParser.bytesToUint16([0x01, 0x02], 2), 0);
      });
    });

    group('bytesToInt16', () {
      test('should convert positive values', () {
        expect(FtmsParser.bytesToInt16([0x00, 0x00], 0), 0);
        expect(FtmsParser.bytesToInt16([0xC8, 0x00], 0), 200);
        expect(FtmsParser.bytesToInt16([0xFF, 0x7F], 0), 32767);
      });

      test('should convert negative values', () {
        expect(FtmsParser.bytesToInt16([0xFF, 0xFF], 0), -1);
        expect(FtmsParser.bytesToInt16([0x00, 0x80], 0), -32768);
        expect(FtmsParser.bytesToInt16([0x38, 0xFF], 0), -200); // -200
      });

      test('should return 0 for insufficient data', () {
        expect(FtmsParser.bytesToInt16([0x01], 0), 0);
        expect(FtmsParser.bytesToInt16([], 0), 0);
      });
    });

    group('parseIndoorBikeData', () {
      test('should return null for data shorter than 2 bytes', () {
        expect(FtmsParser.parseIndoorBikeData([]), isNull);
        expect(FtmsParser.parseIndoorBikeData([0x00]), isNull);
      });

      test('should parse power only (flag 0x41)', () {
        // Flags: 0x0041 = speed NOT present (bit0=1), power present (bit6=1)
        // bit 0 = 1 -> speed NOT present
        // bit 6 = 1 -> power present
        // Power: 200W (0xC8, 0x00)
        final data = [0x41, 0x00, 0xC8, 0x00];
        final result = FtmsParser.parseIndoorBikeData(data);

        expect(result, isNotNull);
        expect(result!.power, 200);
        expect(result.cadence, isNull);
        expect(result.speed, isNull);
      });

      test('should parse speed when flag bit 0 is NOT set', () {
        // Flags: 0x0000 (speed present when bit 0 = 0)
        // Speed: 3500 = 35.00 km/h (0xAC, 0x0D)
        final data = [0x00, 0x00, 0xAC, 0x0D];
        final result = FtmsParser.parseIndoorBikeData(data);

        expect(result, isNotNull);
        expect(result!.speed, closeTo(35.0, 0.1));
      });

      test('should parse cadence (flag 0x04)', () {
        // Flags: 0x0044 (power + cadence present, no speed)
        // Cadence: 180 = 90 RPM (0xB4, 0x00) - stored as 0.5 RPM resolution
        // Power: 200W
        final data = [0x45, 0x00, 0xB4, 0x00, 0xC8, 0x00];
        final result = FtmsParser.parseIndoorBikeData(data);

        expect(result, isNotNull);
        expect(result!.cadence, 90);
        expect(result.power, 200);
      });

      test('should parse distance (flag 0x10)', () {
        // Flags: 0x0051 (distance + power present, no speed)
        // Distance: 10000m = 0x002710 (24-bit little endian)
        // Power: 150W
        final data = [0x51, 0x00, 0x10, 0x27, 0x00, 0x96, 0x00];
        final result = FtmsParser.parseIndoorBikeData(data);

        expect(result, isNotNull);
        expect(result!.distance, 10000);
        expect(result.power, 150);
      });

      test('should parse heart rate (flag 0x200)', () {
        // Flags: 0x0241 (HR + power present, no speed)
        // Power: 200W
        // HR: 150 BPM
        final data = [0x41, 0x02, 0xC8, 0x00, 0x96];
        final result = FtmsParser.parseIndoorBikeData(data);

        expect(result, isNotNull);
        expect(result!.heartRate, 150);
        expect(result.power, 200);
      });

      test('should parse calories (flag 0x100)', () {
        // Flags: 0x0141 (calories + power present, no speed)
        // Power: 200W
        // Total calories: 500
        // Per hour: 0 (skipped)
        // Per minute: 0 (skipped)
        final data = [0x41, 0x01, 0xC8, 0x00, 0xF4, 0x01, 0x00, 0x00, 0x00, 0x00];
        final result = FtmsParser.parseIndoorBikeData(data);

        expect(result, isNotNull);
        expect(result!.calories, 500);
        expect(result.power, 200);
      });

      test('should parse complete data packet from Wahoo Kickr', () {
        // FTMS Indoor Bike Data flags interpretation:
        // bit 0 = 0 -> instantaneous speed IS present
        // bit 0 = 1 -> instantaneous speed NOT present
        // bit 2 = 1 -> cadence present
        // bit 6 = 1 -> power present (0x40)

        // Flags: 0x0044 = 0b0000000001000100
        // bit 0 = 0 -> speed present
        // bit 2 = 1 -> cadence present
        // bit 6 = 1 -> power present
        final data = [
          0x44, 0x00, // Flags: speed present (bit0=0), cadence (bit2), power (bit6)
          0xAC, 0x0D, // Speed: 3500 = 35.00 km/h
          0xB4, 0x00, // Cadence: 180 * 0.5 = 90 RPM
          0xC8, 0x00, // Power: 200W
        ];
        final result = FtmsParser.parseIndoorBikeData(data);

        expect(result, isNotNull);
        expect(result!.speed, closeTo(35.0, 0.1));
        expect(result.cadence, 90);
        expect(result.power, 200);
      });

      test('should parse packet without speed (bit 0 set)', () {
        // Flags: 0x0045 = speed NOT present (bit0=1), cadence (bit2), power (bit6)
        final data = [
          0x45, 0x00, // Flags
          0xB4, 0x00, // Cadence: 180 * 0.5 = 90 RPM
          0xC8, 0x00, // Power: 200W
        ];
        final result = FtmsParser.parseIndoorBikeData(data);

        expect(result, isNotNull);
        expect(result!.speed, isNull);
        expect(result.cadence, 90);
        expect(result.power, 200);
      });

      test('should skip average speed when flag 0x02 is set', () {
        // Flags: 0x0042 (avg speed + power present, speed not present)
        // Avg Speed: skipped
        // Power: 200W
        final data = [0x43, 0x00, 0x00, 0x00, 0xC8, 0x00];
        final result = FtmsParser.parseIndoorBikeData(data);

        expect(result, isNotNull);
        expect(result!.power, 200);
      });

      test('should skip average cadence when flag 0x08 is set', () {
        // Flags: 0x004D (cadence + avg cadence + power, no speed)
        final data = [
          0x4D, 0x00, // Flags
          0xB4, 0x00, // Cadence: 90 RPM
          0x00, 0x00, // Avg Cadence: skipped
          0xC8, 0x00, // Power: 200W
        ];
        final result = FtmsParser.parseIndoorBikeData(data);

        expect(result, isNotNull);
        expect(result!.cadence, 90);
        expect(result.power, 200);
      });

      test('should skip resistance level when flag 0x20 is set', () {
        // Flags: 0x0061 (resistance + power, no speed)
        final data = [
          0x61, 0x00, // Flags
          0x32, 0x00, // Resistance: skipped
          0xC8, 0x00, // Power: 200W
        ];
        final result = FtmsParser.parseIndoorBikeData(data);

        expect(result, isNotNull);
        expect(result!.power, 200);
      });

      test('should skip average power when flag 0x80 is set', () {
        // Flags: 0x00C1 (power + avg power, no speed)
        final data = [
          0xC1, 0x00, // Flags
          0xC8, 0x00, // Power: 200W
          0xD2, 0x00, // Avg Power: skipped (210W)
        ];
        final result = FtmsParser.parseIndoorBikeData(data);

        expect(result, isNotNull);
        expect(result!.power, 200);
      });

      test('should handle negative power values', () {
        // Power can be negative during downhill simulation
        // Flags: 0x0041 (power, no speed)
        final data = [0x41, 0x00, 0x38, 0xFF]; // -200W
        final result = FtmsParser.parseIndoorBikeData(data);

        expect(result, isNotNull);
        expect(result!.power, -200);
      });

      test('should default to 0 power when power flag not set', () {
        // Flags: 0x0001 (no power, no speed)
        final data = [0x01, 0x00];
        final result = FtmsParser.parseIndoorBikeData(data);

        expect(result, isNotNull);
        expect(result!.power, 0);
      });

      test('should handle maximum values', () {
        // Max power: 65535W (unrealistic but valid)
        // Max cadence: 32767 * 0.5 = ~16383 RPM
        // Max speed: 65535 * 0.01 = 655.35 km/h
        final data = [
          0x44, 0x00, // Flags
          0xFF, 0xFF, // Speed: max
          0xFE, 0xFF, // Cadence: max (65534 * 0.5 = 32767)
          0xFF, 0xFF, // Power: max
        ];
        final result = FtmsParser.parseIndoorBikeData(data);

        expect(result, isNotNull);
        expect(result!.speed, closeTo(655.35, 0.1));
        expect(result.cadence, 32767);
      });
    });

    group('createSetTargetPowerCommand', () {
      test('should create correct command for 200W', () {
        final command = FtmsParser.createSetTargetPowerCommand(200);

        expect(command, [0x05, 0xC8, 0x00]);
      });

      test('should create correct command for 350W', () {
        final command = FtmsParser.createSetTargetPowerCommand(350);

        // 350 = 0x015E
        expect(command, [0x05, 0x5E, 0x01]);
      });

      test('should create correct command for 0W', () {
        final command = FtmsParser.createSetTargetPowerCommand(0);

        expect(command, [0x05, 0x00, 0x00]);
      });

      test('should create correct command for max power', () {
        final command = FtmsParser.createSetTargetPowerCommand(2000);

        // 2000 = 0x07D0
        expect(command, [0x05, 0xD0, 0x07]);
      });
    });

    group('createSetResistanceCommand', () {
      test('should create correct command for 50%', () {
        final command = FtmsParser.createSetResistanceCommand(50);

        // 50% * 10 = 500 = 0x01F4
        expect(command, [0x04, 0xF4, 0x01]);
      });

      test('should create correct command for 0%', () {
        final command = FtmsParser.createSetResistanceCommand(0);

        expect(command, [0x04, 0x00, 0x00]);
      });

      test('should create correct command for 100%', () {
        final command = FtmsParser.createSetResistanceCommand(100);

        // 100% * 10 = 1000 = 0x03E8
        expect(command, [0x04, 0xE8, 0x03]);
      });

      test('should clamp values over 100%', () {
        final command = FtmsParser.createSetResistanceCommand(150);

        // Should be clamped to 1000
        expect(command, [0x04, 0xE8, 0x03]);
      });
    });

    group('createSimulationCommand', () {
      test('should create correct command for flat road', () {
        final command = FtmsParser.createSimulationCommand(
          grade: 0.0,
          windSpeed: 0.0,
          crr: 0.004,
          cw: 0.51,
        );

        expect(command[0], 0x11); // Op code
        expect(command[1], 0x00); // Wind speed low byte
        expect(command[2], 0x00); // Wind speed high byte
        expect(command[3], 0x00); // Grade low byte
        expect(command[4], 0x00); // Grade high byte
        expect(command[5], 40); // CRR: 0.004 * 10000 = 40
        expect(command[6], 51); // CW: 0.51 * 100 = 51
      });

      test('should create correct command for 5% grade', () {
        final command = FtmsParser.createSimulationCommand(
          grade: 5.0,
          windSpeed: 0.0,
        );

        expect(command[0], 0x11);
        // Grade: 5.0 * 100 = 500 = 0x01F4
        expect(command[3], 0xF4);
        expect(command[4], 0x01);
      });

      test('should create correct command for negative grade (downhill)', () {
        final command = FtmsParser.createSimulationCommand(
          grade: -5.0,
          windSpeed: 0.0,
        );

        expect(command[0], 0x11);
        // Grade: -5.0 * 100 = -500 (signed 16-bit: 0xFE0C)
        final gradeValue = command[3] | (command[4] << 8);
        expect(gradeValue, 65036); // -500 as unsigned = 65536 - 500
      });

      test('should create correct command with headwind', () {
        final command = FtmsParser.createSimulationCommand(
          grade: 0.0,
          windSpeed: 5.0, // 5 m/s headwind
        );

        // Wind: 5.0 * 1000 = 5000 = 0x1388
        expect(command[1], 0x88);
        expect(command[2], 0x13);
      });

      test('should clamp CRR to valid range', () {
        final command = FtmsParser.createSimulationCommand(
          grade: 0.0,
          crr: 0.1, // Very high CRR
        );

        // CRR: 0.1 * 10000 = 1000, but clamped to 255
        expect(command[5], 255);
      });

      test('should clamp CW to valid range', () {
        final command = FtmsParser.createSimulationCommand(
          grade: 0.0,
          cw: 5.0, // Very high CW
        );

        // CW: 5.0 * 100 = 500, but clamped to 255
        expect(command[6], 255);
      });
    });
  });
}
