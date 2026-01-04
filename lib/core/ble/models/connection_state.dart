import 'package:equatable/equatable.dart';

import 'ble_device.dart';

enum ConnectionStatus {
  disconnected,
  connecting,
  connected,
  error,
}

/// Repräsentiert den aktuellen BLE-Verbindungsstatus
class BleConnectionState extends Equatable {
  final ConnectionStatus status;
  final BleDevice? device;
  final String? errorMessage;

  const BleConnectionState._({
    required this.status,
    this.device,
    this.errorMessage,
  });

  factory BleConnectionState.disconnected() => const BleConnectionState._(
        status: ConnectionStatus.disconnected,
      );

  factory BleConnectionState.connecting(BleDevice device) => BleConnectionState._(
        status: ConnectionStatus.connecting,
        device: device,
      );

  factory BleConnectionState.connected(BleDevice device) => BleConnectionState._(
        status: ConnectionStatus.connected,
        device: device,
      );

  factory BleConnectionState.error(String message) => BleConnectionState._(
        status: ConnectionStatus.error,
        errorMessage: message,
      );

  bool get isConnected => status == ConnectionStatus.connected;
  bool get isConnecting => status == ConnectionStatus.connecting;
  bool get isDisconnected => status == ConnectionStatus.disconnected;
  bool get hasError => status == ConnectionStatus.error;

  @override
  List<Object?> get props => [status, device, errorMessage];
}
