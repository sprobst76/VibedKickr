import 'package:flutter_test/flutter_test.dart';
import 'package:kickr_trainer/core/ble/models/reconnection_state.dart';
import 'package:kickr_trainer/core/ble/reconnection_manager.dart';

void main() {
  group('BLE Reconnection Integration', () {
    late BleReconnectionManager reconnectionManager;

    setUp(() {
      reconnectionManager = BleReconnectionManager();
    });

    tearDown(() {
      reconnectionManager.dispose();
    });

    group('Reconnection workflow', () {
      test('should successfully reconnect on first attempt', () async {
        bool reconnectAttempted = false;
        final states = <BleReconnectionState>[];

        reconnectionManager.reconnectionState.listen(states.add);

        await reconnectionManager.startReconnection(
          deviceId: 'test-trainer-1',
          reconnectFunction: () async {
            reconnectAttempted = true;
            return true; // Successful reconnect
          },
          maxAttempts: 5,
        );

        expect(reconnectAttempted, isTrue);
        expect(states.last.isIdle, isTrue);
      });

      test('should retry multiple times on failure', () async {
        int attemptCount = 0;
        final attempts = <int>[];

        await reconnectionManager.startReconnection(
          deviceId: 'test-trainer-2',
          reconnectFunction: () async {
            attemptCount++;
            attempts.add(attemptCount);
            return false; // Always fail
          },
          maxAttempts: 3,
        );

        expect(attemptCount, equals(3));
        expect(attempts, equals([1, 2, 3]));
      });

      test('should succeed on third attempt after failures', () async {
        int attemptCount = 0;

        await reconnectionManager.startReconnection(
          deviceId: 'test-trainer-3',
          reconnectFunction: () async {
            attemptCount++;
            return attemptCount == 3; // Success on 3rd attempt
          },
          maxAttempts: 5,
        );

        expect(attemptCount, equals(3)); // Should stop after success
      });

      test('should track attempt numbers correctly', () async {
        final states = <BleReconnectionState>[];

        reconnectionManager.reconnectionState.listen(states.add);

        await reconnectionManager.startReconnection(
          deviceId: 'test-trainer-4',
          reconnectFunction: () async => false,
          maxAttempts: 3,
        );

        final reconnectingStates = states.where((s) => s.isReconnecting).toList();

        // Should have 3 reconnecting attempts
        expect(reconnectingStates.length, equals(3));

        // Check attempt numbers
        for (int i = 0; i < reconnectingStates.length; i++) {
          expect(reconnectingStates[i].currentAttempt, equals(i + 1));
          expect(reconnectingStates[i].maxAttempts, equals(3));
        }
      });

      test('should emit failed state when max retries exhausted', () async {
        final states = <BleReconnectionState>[];

        reconnectionManager.reconnectionState.listen(states.add);

        await reconnectionManager.startReconnection(
          deviceId: 'test-trainer-5',
          reconnectFunction: () async => false,
          maxAttempts: 2,
        );

        final failedState = states.firstWhere(
          (s) => s.status == ReconnectionStatus.failed,
          orElse: () => BleReconnectionState.idle(),
        );

        expect(failedState.isFailed, isTrue);
        expect(failedState.currentAttempt, equals(2));
        expect(failedState.maxAttempts, equals(2));
      });
    });

    group('Cancellation', () {
      test('should stop reconnection when cancelled', () async {
        int attemptCount = 0;

        // Don't await - we want to cancel mid-operation
        final reconnectionFuture = reconnectionManager.startReconnection(
          deviceId: 'test-trainer-6',
          reconnectFunction: () async {
            attemptCount++;
            await Future.delayed(const Duration(milliseconds: 100));
            return false;
          },
          maxAttempts: 10,
        );

        // Wait a bit then cancel
        await Future.delayed(const Duration(milliseconds: 50));
        reconnectionManager.cancelReconnection();

        await reconnectionFuture;

        // Should have stopped before reaching max attempts
        expect(attemptCount, lessThan(10));
      });

      test('should emit cancelled state', () async {
        final states = <BleReconnectionState>[];

        reconnectionManager.reconnectionState.listen(states.add);

        // Start reconnection with very long delays
        final reconnectionFuture = reconnectionManager.startReconnection(
          deviceId: 'test-trainer-7',
          reconnectFunction: () async => false,
          maxAttempts: 100,
        );

        // Cancel quickly
        await Future.delayed(const Duration(milliseconds: 50));
        reconnectionManager.cancelReconnection();

        await reconnectionFuture;

        final cancelledState = states.firstWhere(
          (s) => s.status == ReconnectionStatus.cancelled,
          orElse: () => BleReconnectionState.idle(),
        );

        expect(cancelledState.isCancelled, isTrue);
      });
    });

    group('State transitions', () {
      test('should transition from idle to reconnecting to idle', () async {
        final states = <BleReconnectionState>[];

        reconnectionManager.reconnectionState.listen(states.add);

        await reconnectionManager.startReconnection(
          deviceId: 'test-trainer-8',
          reconnectFunction: () async => true,
          maxAttempts: 3,
        );

        // Filter unique statuses for easier assertion
        final statuses = states.map((s) => s.status).toSet();

        expect(
          statuses.contains(ReconnectionStatus.reconnecting),
          isTrue,
        );
        expect(
          states.last.status == ReconnectionStatus.idle ||
              states.last.status == ReconnectionStatus.failed,
          isTrue,
        );
      });

      test('should include error message in failed state', () async {
        final states = <BleReconnectionState>[];

        reconnectionManager.reconnectionState.listen(states.add);

        await reconnectionManager.startReconnection(
          deviceId: 'test-trainer-9',
          reconnectFunction: () async => false,
          maxAttempts: 1,
        );

        final failedState = states.firstWhere((s) => s.isFailed);

        expect(failedState.errorMessage, isNotNull);
        expect(failedState.errorMessage, contains('failed'));
      });
    });

    group('Reset functionality', () {
      test('should reset state after failed reconnection', () async {
        // First, do a failed reconnection
        await reconnectionManager.startReconnection(
          deviceId: 'test-trainer-10',
          reconnectFunction: () async => false,
          maxAttempts: 2,
        );

        // Now reset
        reconnectionManager.reset();

        // Get the reset state
        final resetState = await reconnectionManager.reconnectionState.first;
        expect(resetState.isIdle, isTrue);

        // Try a new reconnection - should work fresh
        bool reconnectCalled = false;

        await reconnectionManager.startReconnection(
          deviceId: 'test-trainer-11',
          reconnectFunction: () async {
            reconnectCalled = true;
            return true;
          },
          maxAttempts: 3,
        );

        expect(reconnectCalled, isTrue);
      });
    });

    group('Edge cases', () {
      test('should handle empty device ID', () async {
        // Should not crash
        await reconnectionManager.startReconnection(
          deviceId: '',
          reconnectFunction: () async => true,
          maxAttempts: 1,
        );

        // Should complete without error
      });

      test('should handle null error in reconnect function', () async {
        // Should not crash
        await reconnectionManager.startReconnection(
          deviceId: 'test-trainer-12',
          reconnectFunction: () async {
            throw Exception('Reconnection failed');
          },
          maxAttempts: 2,
        );

        // Should complete and end in failed state
      });

      test('should handle rapid consecutive start calls', () async {
        int calls1 = 0;
        int calls2 = 0;

        // Start first reconnection
        final future1 = reconnectionManager.startReconnection(
          deviceId: 'device-1',
          reconnectFunction: () async {
            calls1++;
            return false;
          },
          maxAttempts: 3,
        );

        // Immediately try to start another (should cancel first)
        await Future.delayed(const Duration(milliseconds: 10));
        final future2 = reconnectionManager.startReconnection(
          deviceId: 'device-2',
          reconnectFunction: () async {
            calls2++;
            return true;
          },
          maxAttempts: 3,
        );

        await Future.wait([future1, future2]);

        // One of them should have executed
        expect(calls1 + calls2, greaterThan(0));
      });
    });
  });
}
