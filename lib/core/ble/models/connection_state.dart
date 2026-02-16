import 'package:equatable/equatable.dart';

import 'ble_device.dart';
import 'ble_error.dart';

enum ConnectionStatus {
  disconnected,
  connecting,
  reconnecting,
  connected,
  error,
}

/// Repräsentiert den aktuellen BLE-Verbindungsstatus
class BleConnectionState extends Equatable {
  final ConnectionStatus status;
  final BleDevice? device;
  final String? errorMessage;
  final BleError? bleError;

  const BleConnectionState._({
    required this.status,
    this.device,
    this.errorMessage,
    this.bleError,
  });

  factory BleConnectionState.disconnected() => const BleConnectionState._(
        status: ConnectionStatus.disconnected,
      );

  factory BleConnectionState.connecting(BleDevice device) => BleConnectionState._(
        status: ConnectionStatus.connecting,
        device: device,
      );

  factory BleConnectionState.reconnecting(BleDevice device) => BleConnectionState._(
        status: ConnectionStatus.reconnecting,
        device: device,
      );

  factory BleConnectionState.connected(BleDevice device) => BleConnectionState._(
        status: ConnectionStatus.connected,
        device: device,
      );

  factory BleConnectionState.error(String message, {BleError? bleError}) =>
      BleConnectionState._(
        status: ConnectionStatus.error,
        errorMessage: message,
        bleError: bleError,
      );

  /// Erstellt Fehlerstatus aus einem BleError (benutzerfreundliche Nachricht)
  factory BleConnectionState.fromBleError(BleError error) =>
      BleConnectionState._(
        status: ConnectionStatus.error,
        errorMessage: error.userMessage,
        bleError: error,
      );

  /// Simulierter verbundener Status (für Mock-Trainer)
  factory BleConnectionState.simulated() => const BleConnectionState._(
        status: ConnectionStatus.connected,
      );

  bool get isConnected => status == ConnectionStatus.connected;
  bool get isConnecting => status == ConnectionStatus.connecting;
  bool get isReconnecting => status == ConnectionStatus.reconnecting;
  bool get isDisconnected => status == ConnectionStatus.disconnected;
  bool get hasError => status == ConnectionStatus.error;

  /// Ob der Fehler durch einen erneuten Versuch behoben werden kann
  bool get isRetryable => bleError?.isRetryable ?? false;

  @override
  List<Object?> get props => [status, device, errorMessage, bleError];
}
