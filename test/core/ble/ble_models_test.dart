import 'package:flutter_test/flutter_test.dart';
import 'package:kickr_trainer/core/ble/models/connection_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:kickr_trainer/core/ble/models/ble_device.dart';

// Mock für BluetoothDevice
class MockBluetoothDevice extends Mock implements BluetoothDevice {}

void main() {
  group('BleDevice', () {
    late MockBluetoothDevice mockBluetoothDevice;

    setUp(() {
      mockBluetoothDevice = MockBluetoothDevice();
    });

    group('signalStrength', () {
      test('should return 100% for very strong signal (-30 dBm)', () {
        final device = BleDevice(
          id: 'test-id',
          name: 'Test Device',
          rssi: -30,
          bluetoothDevice: mockBluetoothDevice,
        );

        expect(device.signalStrength, 100);
      });

      test('should return ~50% for medium signal (-65 dBm)', () {
        final device = BleDevice(
          id: 'test-id',
          name: 'Test Device',
          rssi: -65,
          bluetoothDevice: mockBluetoothDevice,
        );

        // (-65 + 100) / 70 * 100 = 50
        expect(device.signalStrength, 50);
      });

      test('should return 0% for very weak signal (-100 dBm)', () {
        final device = BleDevice(
          id: 'test-id',
          name: 'Test Device',
          rssi: -100,
          bluetoothDevice: mockBluetoothDevice,
        );

        expect(device.signalStrength, 0);
      });

      test('should clamp to 0% for signals weaker than -100 dBm', () {
        final device = BleDevice(
          id: 'test-id',
          name: 'Test Device',
          rssi: -120,
          bluetoothDevice: mockBluetoothDevice,
        );

        expect(device.signalStrength, 0);
      });

      test('should clamp to 100% for signals stronger than -30 dBm', () {
        final device = BleDevice(
          id: 'test-id',
          name: 'Test Device',
          rssi: -10,
          bluetoothDevice: mockBluetoothDevice,
        );

        expect(device.signalStrength, 100);
      });
    });

    group('isKnownTrainer', () {
      test('should return true for Wahoo Kickr', () {
        final device = BleDevice(
          id: 'test-id',
          name: 'KICKR CORE 1234',
          rssi: -50,
          bluetoothDevice: mockBluetoothDevice,
        );

        expect(device.isKnownTrainer, isTrue);
      });

      test('should return true for Wahoo branded device', () {
        final device = BleDevice(
          id: 'test-id',
          name: 'Wahoo KICKR',
          rssi: -50,
          bluetoothDevice: mockBluetoothDevice,
        );

        expect(device.isKnownTrainer, isTrue);
      });

      test('should return true for Tacx device', () {
        final device = BleDevice(
          id: 'test-id',
          name: 'TACX NEO 2T',
          rssi: -50,
          bluetoothDevice: mockBluetoothDevice,
        );

        expect(device.isKnownTrainer, isTrue);
      });

      test('should return true for Elite device', () {
        final device = BleDevice(
          id: 'test-id',
          name: 'Elite Suito',
          rssi: -50,
          bluetoothDevice: mockBluetoothDevice,
        );

        expect(device.isKnownTrainer, isTrue);
      });

      test('should return true for Saris device', () {
        final device = BleDevice(
          id: 'test-id',
          name: 'Saris H3',
          rssi: -50,
          bluetoothDevice: mockBluetoothDevice,
        );

        expect(device.isKnownTrainer, isTrue);
      });

      test('should return false for unknown device', () {
        final device = BleDevice(
          id: 'test-id',
          name: 'Unknown Device',
          rssi: -50,
          bluetoothDevice: mockBluetoothDevice,
        );

        expect(device.isKnownTrainer, isFalse);
      });

      test('should be case insensitive', () {
        final device = BleDevice(
          id: 'test-id',
          name: 'kickr core',
          rssi: -50,
          bluetoothDevice: mockBluetoothDevice,
        );

        expect(device.isKnownTrainer, isTrue);
      });
    });

    group('Equatable', () {
      test('should be equal for same id, name, rssi', () {
        final device1 = BleDevice(
          id: 'test-id',
          name: 'Test Device',
          rssi: -50,
          bluetoothDevice: mockBluetoothDevice,
        );
        final device2 = BleDevice(
          id: 'test-id',
          name: 'Test Device',
          rssi: -50,
          bluetoothDevice: mockBluetoothDevice,
        );

        expect(device1, equals(device2));
      });

      test('should not be equal for different rssi', () {
        final device1 = BleDevice(
          id: 'test-id',
          name: 'Test Device',
          rssi: -50,
          bluetoothDevice: mockBluetoothDevice,
        );
        final device2 = BleDevice(
          id: 'test-id',
          name: 'Test Device',
          rssi: -60,
          bluetoothDevice: mockBluetoothDevice,
        );

        expect(device1, isNot(equals(device2)));
      });
    });
  });

  group('BleConnectionState', () {
    late MockBluetoothDevice mockBluetoothDevice;
    late BleDevice testDevice;

    setUp(() {
      mockBluetoothDevice = MockBluetoothDevice();
      testDevice = BleDevice(
        id: 'test-id',
        name: 'Test Device',
        rssi: -50,
        bluetoothDevice: mockBluetoothDevice,
      );
    });

    group('factory constructors', () {
      test('should create disconnected state', () {
        final state = BleConnectionState.disconnected();

        expect(state.status, ConnectionStatus.disconnected);
        expect(state.device, isNull);
        expect(state.errorMessage, isNull);
      });

      test('should create connecting state with device', () {
        final state = BleConnectionState.connecting(testDevice);

        expect(state.status, ConnectionStatus.connecting);
        expect(state.device, testDevice);
        expect(state.errorMessage, isNull);
      });

      test('should create connected state with device', () {
        final state = BleConnectionState.connected(testDevice);

        expect(state.status, ConnectionStatus.connected);
        expect(state.device, testDevice);
        expect(state.errorMessage, isNull);
      });

      test('should create error state with message', () {
        final state = BleConnectionState.error('Connection failed');

        expect(state.status, ConnectionStatus.error);
        expect(state.device, isNull);
        expect(state.errorMessage, 'Connection failed');
      });
    });

    group('status getters', () {
      test('isConnected should be true only for connected state', () {
        expect(BleConnectionState.disconnected().isConnected, isFalse);
        expect(BleConnectionState.connecting(testDevice).isConnected, isFalse);
        expect(BleConnectionState.connected(testDevice).isConnected, isTrue);
        expect(BleConnectionState.error('Error').isConnected, isFalse);
      });

      test('isConnecting should be true only for connecting state', () {
        expect(BleConnectionState.disconnected().isConnecting, isFalse);
        expect(BleConnectionState.connecting(testDevice).isConnecting, isTrue);
        expect(BleConnectionState.connected(testDevice).isConnecting, isFalse);
        expect(BleConnectionState.error('Error').isConnecting, isFalse);
      });

      test('isDisconnected should be true only for disconnected state', () {
        expect(BleConnectionState.disconnected().isDisconnected, isTrue);
        expect(BleConnectionState.connecting(testDevice).isDisconnected, isFalse);
        expect(BleConnectionState.connected(testDevice).isDisconnected, isFalse);
        expect(BleConnectionState.error('Error').isDisconnected, isFalse);
      });

      test('hasError should be true only for error state', () {
        expect(BleConnectionState.disconnected().hasError, isFalse);
        expect(BleConnectionState.connecting(testDevice).hasError, isFalse);
        expect(BleConnectionState.connected(testDevice).hasError, isFalse);
        expect(BleConnectionState.error('Error').hasError, isTrue);
      });
    });

    group('Equatable', () {
      test('should be equal for same state', () {
        final state1 = BleConnectionState.disconnected();
        final state2 = BleConnectionState.disconnected();

        expect(state1, equals(state2));
      });

      test('should be equal for same error message', () {
        final state1 = BleConnectionState.error('Connection failed');
        final state2 = BleConnectionState.error('Connection failed');

        expect(state1, equals(state2));
      });

      test('should not be equal for different error messages', () {
        final state1 = BleConnectionState.error('Connection failed');
        final state2 = BleConnectionState.error('Timeout');

        expect(state1, isNot(equals(state2)));
      });

      test('should be equal for same device in connected state', () {
        final state1 = BleConnectionState.connected(testDevice);
        final state2 = BleConnectionState.connected(testDevice);

        expect(state1, equals(state2));
      });
    });
  });

  group('ConnectionStatus', () {
    test('should have all expected values', () {
      expect(ConnectionStatus.values, contains(ConnectionStatus.disconnected));
      expect(ConnectionStatus.values, contains(ConnectionStatus.connecting));
      expect(ConnectionStatus.values, contains(ConnectionStatus.connected));
      expect(ConnectionStatus.values, contains(ConnectionStatus.error));
      expect(ConnectionStatus.values.length, 4);
    });
  });
}
