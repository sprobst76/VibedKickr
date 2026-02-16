import 'package:flutter_test/flutter_test.dart';
import 'package:kickr_trainer/core/ble/models/connection_state.dart';
import 'package:kickr_trainer/core/ble/models/ble_error.dart';

void main() {
  group('BleConnectionState', () {
    group('factory constructors', () {
      test('disconnected() creates state with disconnected status', () {
        final state = BleConnectionState.disconnected();

        expect(state.status, ConnectionStatus.disconnected);
        expect(state.device, isNull);
        expect(state.errorMessage, isNull);
        expect(state.bleError, isNull);
      });

      test('error() creates state with error status and message', () {
        final state = BleConnectionState.error('Something went wrong');

        expect(state.status, ConnectionStatus.error);
        expect(state.errorMessage, 'Something went wrong');
        expect(state.device, isNull);
        expect(state.bleError, isNull);
      });

      test('error() with bleError carries it through', () {
        final bleError = BleError.connectionTimeout();
        final state = BleConnectionState.error(
          'Timeout',
          bleError: bleError,
        );

        expect(state.status, ConnectionStatus.error);
        expect(state.errorMessage, 'Timeout');
        expect(state.bleError, isNotNull);
        expect(state.bleError!.type, BleErrorType.connectionTimeout);
      });

      test('fromBleError() uses userMessage as errorMessage', () {
        final bleError = BleError.adapterOff();
        final state = BleConnectionState.fromBleError(bleError);

        expect(state.status, ConnectionStatus.error);
        expect(state.errorMessage, bleError.userMessage);
        expect(state.bleError, bleError);
      });

      test('simulated() has connected status', () {
        final state = BleConnectionState.simulated();

        expect(state.status, ConnectionStatus.connected);
        expect(state.isConnected, isTrue);
        expect(state.device, isNull);
      });
    });

    group('boolean getters', () {
      test('disconnected state returns correct booleans', () {
        final state = BleConnectionState.disconnected();

        expect(state.isDisconnected, isTrue);
        expect(state.isConnected, isFalse);
        expect(state.isConnecting, isFalse);
        expect(state.isReconnecting, isFalse);
        expect(state.hasError, isFalse);
      });

      test('error state returns correct booleans', () {
        final state = BleConnectionState.error('Error');

        expect(state.hasError, isTrue);
        expect(state.isConnected, isFalse);
        expect(state.isDisconnected, isFalse);
        expect(state.isConnecting, isFalse);
        expect(state.isReconnecting, isFalse);
      });

      test('simulated (connected) state returns correct booleans', () {
        final state = BleConnectionState.simulated();

        expect(state.isConnected, isTrue);
        expect(state.isDisconnected, isFalse);
        expect(state.isConnecting, isFalse);
        expect(state.isReconnecting, isFalse);
        expect(state.hasError, isFalse);
      });
    });

    group('isRetryable', () {
      test('returns false when bleError is null', () {
        final state = BleConnectionState.error('Generic error');
        expect(state.isRetryable, isFalse);
      });

      test('delegates to bleError.isRetryable when bleError is present', () {
        final retryableError = BleError.connectionTimeout();
        final state = BleConnectionState.error(
          'Timeout',
          bleError: retryableError,
        );
        expect(state.isRetryable, isTrue);
      });

      test('returns false for non-retryable bleError', () {
        final nonRetryableError = BleError.permissionDenied();
        final state = BleConnectionState.error(
          'Denied',
          bleError: nonRetryableError,
        );
        expect(state.isRetryable, isFalse);
      });
    });

    group('Equatable', () {
      test('two disconnected states are equal', () {
        final state1 = BleConnectionState.disconnected();
        final state2 = BleConnectionState.disconnected();
        expect(state1, equals(state2));
      });

      test('two simulated states are equal', () {
        final state1 = BleConnectionState.simulated();
        final state2 = BleConnectionState.simulated();
        expect(state1, equals(state2));
      });

      test('two error states with same message are equal', () {
        final state1 = BleConnectionState.error('Error');
        final state2 = BleConnectionState.error('Error');
        expect(state1, equals(state2));
      });

      test('disconnected and error states are not equal', () {
        final state1 = BleConnectionState.disconnected();
        final state2 = BleConnectionState.error('Error');
        expect(state1, isNot(equals(state2)));
      });

      test('error states with different messages are not equal', () {
        final state1 = BleConnectionState.error('Error A');
        final state2 = BleConnectionState.error('Error B');
        expect(state1, isNot(equals(state2)));
      });

      test('simulated and disconnected are not equal', () {
        final state1 = BleConnectionState.simulated();
        final state2 = BleConnectionState.disconnected();
        expect(state1, isNot(equals(state2)));
      });
    });
  });

  group('BleError', () {
    group('factory constructors', () {
      test('permissionDenied() creates correct type', () {
        final error = BleError.permissionDenied();

        expect(error.type, BleErrorType.permissionDenied);
        expect(error.message, isNotEmpty);
        expect(error.userMessage, isNotEmpty);
      });

      test('adapterOff() creates correct type', () {
        final error = BleError.adapterOff();

        expect(error.type, BleErrorType.adapterOff);
        expect(error.message, contains('off'));
      });

      test('connectionTimeout() creates correct type', () {
        final error = BleError.connectionTimeout();

        expect(error.type, BleErrorType.connectionTimeout);
        expect(error.message, contains('timed out'));
      });

      test('serviceDiscoveryTimeout() creates correct type', () {
        final error = BleError.serviceDiscoveryTimeout();

        expect(error.type, BleErrorType.serviceDiscoveryTimeout);
        expect(error.message, contains('discovery'));
      });

      test('serviceNotFound() includes service name in message', () {
        final error = BleError.serviceNotFound('FTMS');

        expect(error.type, BleErrorType.serviceNotFound);
        expect(error.message, contains('FTMS'));
        expect(error.userMessage, contains('FTMS'));
      });

      test('notSupported() creates correct type', () {
        final error = BleError.notSupported();

        expect(error.type, BleErrorType.notSupported);
        expect(error.message, contains('not supported'));
      });

      test('reconnectionFailed() includes attempt count', () {
        final error = BleError.reconnectionFailed(5);

        expect(error.type, BleErrorType.reconnectionFailed);
        expect(error.message, contains('5'));
        expect(error.userMessage, contains('5'));
      });

      test('unknown() includes details in message', () {
        final error = BleError.unknown('some detail');

        expect(error.type, BleErrorType.unknown);
        expect(error.message, 'some detail');
        expect(error.userMessage, contains('some detail'));
      });
    });

    group('isRetryable', () {
      test('connectionTimeout is retryable', () {
        expect(BleError.connectionTimeout().isRetryable, isTrue);
      });

      test('serviceDiscoveryTimeout is retryable', () {
        expect(BleError.serviceDiscoveryTimeout().isRetryable, isTrue);
      });

      test('reconnectionFailed is retryable', () {
        expect(BleError.reconnectionFailed(3).isRetryable, isTrue);
      });

      test('unknown is retryable', () {
        expect(BleError.unknown('error').isRetryable, isTrue);
      });

      test('permissionDenied is not retryable', () {
        expect(BleError.permissionDenied().isRetryable, isFalse);
      });

      test('adapterOff is not retryable', () {
        expect(BleError.adapterOff().isRetryable, isFalse);
      });

      test('serviceNotFound is not retryable', () {
        expect(BleError.serviceNotFound('FTMS').isRetryable, isFalse);
      });

      test('notSupported is not retryable', () {
        expect(BleError.notSupported().isRetryable, isFalse);
      });
    });

    test('toString() returns expected format', () {
      final error = BleError.connectionTimeout();
      expect(
        error.toString(),
        'BleError(BleErrorType.connectionTimeout: Connection timed out)',
      );
    });
  });
}
