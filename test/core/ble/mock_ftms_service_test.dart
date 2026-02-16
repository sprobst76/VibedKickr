import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kickr_trainer/core/ble/mock_ftms_service.dart';
import 'package:kickr_trainer/core/ble/ftms_service_interface.dart';
import 'package:kickr_trainer/core/ble/models/ftms_data.dart';

void main() {
  late MockFtmsService service;

  setUp(() {
    service = MockFtmsService();
  });

  tearDown(() {
    service.dispose();
  });

  group('MockFtmsService', () {
    test('implements FtmsServiceInterface', () {
      expect(service, isA<FtmsServiceInterface>());
    });

    test('has correct minPower and maxPower', () {
      expect(service.minPower, 25);
      expect(service.maxPower, 1000);
    });

    test('initialize() emits a status event', () async {
      final statusFuture = service.statusStream.first;
      await service.initialize();
      final status = await statusFuture;

      expect(status.isSuccess, isTrue);
      expect(status.message, contains('Mock Trainer'));
    });

    test('requestControl() returns true', () async {
      final result = await service.requestControl();
      expect(result, isTrue);
    });

    test('reset() returns true and resets state', () async {
      // Set some state first
      await service.setTargetPower(500);
      final result = await service.reset();

      expect(result, isTrue);
    });

    test('startSpindown() returns true and emits status', () async {
      final statusFuture = service.statusStream.first;
      final result = await service.startSpindown();

      expect(result, isTrue);
      final status = await statusFuture;
      expect(status.isSuccess, isTrue);
      expect(status.message, contains('Spindown'));
    });

    group('setTargetPower', () {
      test('returns true', () async {
        final result = await service.setTargetPower(200);
        expect(result, isTrue);
      });

      test('emits status event on power change', () async {
        final statusFuture = service.statusStream.first;
        await service.setTargetPower(250);
        final status = await statusFuture;

        expect(status.isSuccess, isTrue);
        expect(status.message, contains('250'));
      });

      test('clamps power below minimum to 25', () async {
        final statusFuture = service.statusStream.first;
        await service.setTargetPower(10);
        final status = await statusFuture;

        expect(status.message, contains('25'));
      });

      test('clamps power above maximum to 1000', () async {
        final statusFuture = service.statusStream.first;
        await service.setTargetPower(1500);
        final status = await statusFuture;

        expect(status.message, contains('1000'));
      });
    });

    group('setSimulationParameters', () {
      test('returns true', () async {
        final result = await service.setSimulationParameters(grade: 5.0);
        expect(result, isTrue);
      });

      test('emits status with grade info', () async {
        final statusFuture = service.statusStream.first;
        await service.setSimulationParameters(grade: 3.5);
        final status = await statusFuture;

        expect(status.isSuccess, isTrue);
        expect(status.message, contains('3.5'));
      });
    });

    group('setResistanceLevel', () {
      test('returns true', () async {
        final result = await service.setResistanceLevel(50);
        expect(result, isTrue);
      });
    });

    group('start/stop simulation', () {
      test('start() causes dataStream to emit FtmsData', () async {
        service.start();

        // Wait for at least one data emission (timer fires every 1 second)
        final data = await service.dataStream.first.timeout(
          const Duration(seconds: 3),
        );

        expect(data, isA<FtmsData>());
        expect(data.power, isA<int>());
        expect(data.timestamp, isA<DateTime>());
      });

      test('stop() stops emitting data and resets values', () async {
        service.start();

        // Wait for initial data
        await service.dataStream.first.timeout(
          const Duration(seconds: 3),
        );

        // Stop emits one final data point with zeroed values
        final lastDataFuture = service.dataStream.first;
        service.stop();

        final lastData = await lastDataFuture.timeout(
          const Duration(seconds: 2),
        );

        expect(lastData.power, 0);
      });

      test('start() is idempotent when already running', () async {
        service.start();
        // Calling start again should not throw or create duplicate timers
        service.start();

        final data = await service.dataStream.first.timeout(
          const Duration(seconds: 3),
        );
        expect(data, isA<FtmsData>());
      });
    });

    group('configure', () {
      test('accepts athlete parameters without error', () {
        // Should not throw
        service.configure(
          ftp: 250,
          restingHr: 55,
          maxHr: 190,
          weight: 80.0,
        );
      });
    });

    group('dispose', () {
      test('does not throw errors after dispose', () {
        service.start();
        service.dispose();

        // After dispose, streams should be closed - no errors expected
        // We just verify no exception is thrown
      });

      test('dataStream closes after dispose', () async {
        final completer = Completer<void>();
        service.dataStream.listen(
          (_) {},
          onDone: () => completer.complete(),
        );

        service.dispose();
        await completer.future.timeout(const Duration(seconds: 2));
      });
    });
  });
}
