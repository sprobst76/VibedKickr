import 'package:flutter_test/flutter_test.dart';
import 'package:kickr_trainer/core/ble/models/ftms_data.dart';

void main() {
  group('FtmsData', () {
    test('should create FtmsData with required fields', () {
      final timestamp = DateTime(2024, 1, 15, 10, 30);
      final data = FtmsData(
        timestamp: timestamp,
        power: 200,
      );

      expect(data.timestamp, timestamp);
      expect(data.power, 200);
      expect(data.cadence, isNull);
      expect(data.speed, isNull);
      expect(data.distance, isNull);
      expect(data.heartRate, isNull);
      expect(data.calories, isNull);
    });

    test('should create FtmsData with all fields', () {
      final timestamp = DateTime(2024, 1, 15, 10, 30);
      final data = FtmsData(
        timestamp: timestamp,
        power: 250,
        cadence: 90,
        speed: 35.5,
        distance: 10000,
        heartRate: 150,
        calories: 500,
      );

      expect(data.power, 250);
      expect(data.cadence, 90);
      expect(data.speed, 35.5);
      expect(data.distance, 10000);
      expect(data.heartRate, 150);
      expect(data.calories, 500);
    });

    test('should create empty FtmsData', () {
      final data = FtmsData.empty();

      expect(data.power, 0);
      expect(data.cadence, isNull);
      expect(data.speed, isNull);
      expect(data.timestamp, isNotNull);
    });

    group('Equatable', () {
      test('should be equal for same values (excluding timestamp)', () {
        final timestamp = DateTime(2024, 1, 15, 10, 30);
        final data1 = FtmsData(
          timestamp: timestamp,
          power: 200,
          cadence: 90,
        );
        final data2 = FtmsData(
          timestamp: timestamp,
          power: 200,
          cadence: 90,
        );

        expect(data1, equals(data2));
      });

      test('should not be equal for different power', () {
        final timestamp = DateTime(2024, 1, 15, 10, 30);
        final data1 = FtmsData(timestamp: timestamp, power: 200);
        final data2 = FtmsData(timestamp: timestamp, power: 250);

        expect(data1, isNot(equals(data2)));
      });
    });
  });

  group('FtmsStatus', () {
    group('fromOpCode', () {
      test('should parse Reset status', () {
        final status = FtmsStatus.fromOpCode(0x01, []);

        expect(status.opCode, 0x01);
        expect(status.message, 'Reset');
        expect(status.isSuccess, isTrue);
      });

      test('should parse Stopped by User status', () {
        final status = FtmsStatus.fromOpCode(0x02, []);

        expect(status.opCode, 0x02);
        expect(status.message, 'Fitness Machine Stopped/Paused by User');
        expect(status.isSuccess, isFalse);
      });

      test('should parse Stopped by Safety Key status', () {
        final status = FtmsStatus.fromOpCode(0x03, []);

        expect(status.opCode, 0x03);
        expect(status.message, 'Fitness Machine Stopped by Safety Key');
        expect(status.isSuccess, isFalse);
      });

      test('should parse Started/Resumed status', () {
        final status = FtmsStatus.fromOpCode(0x04, []);

        expect(status.opCode, 0x04);
        expect(status.message, 'Fitness Machine Started/Resumed by User');
        expect(status.isSuccess, isTrue);
      });

      test('should parse Target Power Changed status', () {
        final status = FtmsStatus.fromOpCode(0x08, [0xC8, 0x00]); // 200W

        expect(status.opCode, 0x08);
        expect(status.message, 'Target Power Changed');
        expect(status.isSuccess, isTrue);
        expect(status.rawData, [0xC8, 0x00]);
      });

      test('should parse Target Resistance Level Changed status', () {
        final status = FtmsStatus.fromOpCode(0x07, [0x32]); // 50%

        expect(status.opCode, 0x07);
        expect(status.message, 'Target Resistance Level Changed');
        expect(status.isSuccess, isTrue);
      });

      test('should parse Indoor Bike Simulation Parameters Changed status', () {
        final status = FtmsStatus.fromOpCode(0x12, []);

        expect(status.opCode, 0x12);
        expect(status.message, 'Indoor Bike Simulation Parameters Changed');
        expect(status.isSuccess, isTrue);
      });

      test('should parse Spin Down Status', () {
        final status = FtmsStatus.fromOpCode(0x14, [0x01]); // Success

        expect(status.opCode, 0x14);
        expect(status.message, 'Spin Down Status');
        expect(status.isSuccess, isTrue);
      });

      test('should parse Control Permission Lost status', () {
        final status = FtmsStatus.fromOpCode(0xFF, []);

        expect(status.opCode, 0xFF);
        expect(status.message, 'Control Permission Lost');
        expect(status.isSuccess, isFalse);
      });

      test('should parse unknown status code', () {
        final status = FtmsStatus.fromOpCode(0xAA, []);

        expect(status.opCode, 0xAA);
        expect(status.message, contains('Unknown Status'));
        expect(status.message, contains('0xaa'));
      });

      test('should preserve raw data', () {
        final rawData = [0x01, 0x02, 0x03, 0x04];
        final status = FtmsStatus.fromOpCode(0x08, rawData);

        expect(status.rawData, rawData);
      });
    });

    group('Equatable', () {
      test('should be equal for same values', () {
        final status1 = FtmsStatus.fromOpCode(0x08, [0xC8, 0x00]);
        final status2 = FtmsStatus.fromOpCode(0x08, [0xC8, 0x00]);

        expect(status1, equals(status2));
      });
    });
  });

  group('FtmsControlResponse', () {
    test('should create control response', () {
      const response = FtmsControlResponse(
        requestOpCode: 0x05,
        resultCode: FtmsResultCode.success,
        responseData: [0x05, 0x01],
      );

      expect(response.requestOpCode, 0x05);
      expect(response.resultCode, FtmsResultCode.success);
      expect(response.isSuccess, isTrue);
    });

    test('should indicate failure for non-success result codes', () {
      const response = FtmsControlResponse(
        requestOpCode: 0x05,
        resultCode: FtmsResultCode.operationFailed,
        responseData: [],
      );

      expect(response.isSuccess, isFalse);
    });
  });

  group('FtmsResultCode', () {
    test('should parse success code', () {
      expect(FtmsResultCode.fromCode(0x01), FtmsResultCode.success);
    });

    test('should parse not supported code', () {
      expect(FtmsResultCode.fromCode(0x02), FtmsResultCode.notSupported);
    });

    test('should parse invalid parameter code', () {
      expect(FtmsResultCode.fromCode(0x03), FtmsResultCode.invalidParameter);
    });

    test('should parse operation failed code', () {
      expect(FtmsResultCode.fromCode(0x04), FtmsResultCode.operationFailed);
    });

    test('should parse control not permitted code', () {
      expect(FtmsResultCode.fromCode(0x05), FtmsResultCode.controlNotPermitted);
    });

    test('should return unknown for unrecognized code', () {
      expect(FtmsResultCode.fromCode(0x99), FtmsResultCode.unknown);
    });

    test('should have correct code values', () {
      expect(FtmsResultCode.success.code, 0x01);
      expect(FtmsResultCode.notSupported.code, 0x02);
      expect(FtmsResultCode.invalidParameter.code, 0x03);
      expect(FtmsResultCode.operationFailed.code, 0x04);
      expect(FtmsResultCode.controlNotPermitted.code, 0x05);
      expect(FtmsResultCode.unknown.code, 0xFF);
    });
  });
}
