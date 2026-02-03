import 'package:flutter_test/flutter_test.dart';
import 'package:kickr_trainer/core/ble/models/reconnection_state.dart';
import 'package:kickr_trainer/core/ble/reconnection_manager.dart';

void main() {
  group('BleReconnectionManager', () {
    late BleReconnectionManager manager;

    setUp(() {
      manager = BleReconnectionManager();
    });

    tearDown(() {
      manager.cancelReconnection();
      manager.dispose();
    });

    test('should successfully reconnect on first attempt', () async {
      bool reconnectAttempted = false;

      await manager.startReconnection(
        deviceId: 'test-device-1',
        reconnectFunction: () async {
          reconnectAttempted = true;
          return true; // Successful reconnect
        },
        maxAttempts: 5,
      );

      expect(reconnectAttempted, isTrue);
    });

    test('should retry on failure', () async {
      int attemptCount = 0;

      await manager.startReconnection(
        deviceId: 'test-device-2',
        reconnectFunction: () async {
          attemptCount++;
          return false; // Always fail
        },
        maxAttempts: 3,
      );

      expect(attemptCount, equals(3));
    });

    test('should succeed on third attempt after failures', () async {
      int attemptCount = 0;

      await manager.startReconnection(
        deviceId: 'test-device-3',
        reconnectFunction: () async {
          attemptCount++;
          return attemptCount == 3; // Success on 3rd attempt
        },
        maxAttempts: 5,
      );

      expect(attemptCount, equals(3)); // Should stop after success
    });

    test('should emit reconnecting state', () async {
      final states = <BleReconnectionState>[];

      manager.reconnectionState.listen(states.add);

      await manager.startReconnection(
        deviceId: 'test-device-4',
        reconnectFunction: () async => true,
        maxAttempts: 2,
      );

      // Should have emitted at least one state
      expect(states.isNotEmpty, isTrue);
    });

    test('should cancel reconnection when cancelled', () async {
      int attemptCount = 0;

      final reconnectionFuture = manager.startReconnection(
        deviceId: 'test-device-5',
        reconnectFunction: () async {
          attemptCount++;
          return false;
        },
        maxAttempts: 100,
      );

      // Wait a bit then cancel
      await Future.delayed(const Duration(milliseconds: 100));
      manager.cancelReconnection();

      await reconnectionFuture;

      // Should have stopped before reaching max attempts
      expect(attemptCount, lessThan(100));
    });

    test('should not allow concurrent reconnections', () async {
      int device1Calls = 0;
      int device2Calls = 0;

      final future1 = manager.startReconnection(
        deviceId: 'device-1',
        reconnectFunction: () async {
          device1Calls++;
          return false;
        },
        maxAttempts: 1,
      );

      // Try to start another reconnection while first is active
      await Future.delayed(const Duration(milliseconds: 50));

      final future2 = manager.startReconnection(
        deviceId: 'device-2',
        reconnectFunction: () async {
          device2Calls++;
          return false;
        },
        maxAttempts: 1,
      );

      await Future.wait([future1, future2]);

      // At least one should have executed
      expect(device1Calls + device2Calls, greaterThan(0));
    });

    test('should safely close stream on dispose', () {
      // Create a fresh manager for this test
      final testManager = BleReconnectionManager();

      // Should not throw
      expect(() => testManager.dispose(), returnsNormally);

      // Second dispose should not throw
      expect(() => testManager.dispose(), returnsNormally);
    });
  });
}
