import 'package:equatable/equatable.dart';

enum ReconnectionStatus {
  idle,          // Not reconnecting
  reconnecting,  // Active reconnection attempt
  failed,        // All retries exhausted
  cancelled,     // User cancelled reconnection
}

/// Repräsentiert den aktuellen Status einer Reconnection-Operation
class BleReconnectionState extends Equatable {
  final ReconnectionStatus status;
  final int currentAttempt;
  final int maxAttempts;
  final Duration nextRetryIn;
  final String? deviceId;
  final String? errorMessage;

  const BleReconnectionState({
    required this.status,
    required this.currentAttempt,
    required this.maxAttempts,
    required this.nextRetryIn,
    this.deviceId,
    this.errorMessage,
  });

  factory BleReconnectionState.idle() => const BleReconnectionState(
        status: ReconnectionStatus.idle,
        currentAttempt: 0,
        maxAttempts: 0,
        nextRetryIn: Duration.zero,
      );

  factory BleReconnectionState.reconnecting({
    required String deviceId,
    required int currentAttempt,
    required int maxAttempts,
    required Duration nextRetryIn,
  }) =>
      BleReconnectionState(
        status: ReconnectionStatus.reconnecting,
        deviceId: deviceId,
        currentAttempt: currentAttempt,
        maxAttempts: maxAttempts,
        nextRetryIn: nextRetryIn,
      );

  factory BleReconnectionState.failed({
    required String deviceId,
    required int maxAttempts,
    String? errorMessage,
  }) =>
      BleReconnectionState(
        status: ReconnectionStatus.failed,
        deviceId: deviceId,
        currentAttempt: maxAttempts,
        maxAttempts: maxAttempts,
        nextRetryIn: Duration.zero,
        errorMessage: errorMessage,
      );

  factory BleReconnectionState.cancelled({
    required String deviceId,
  }) =>
      BleReconnectionState(
        status: ReconnectionStatus.cancelled,
        deviceId: deviceId,
        currentAttempt: 0,
        maxAttempts: 0,
        nextRetryIn: Duration.zero,
      );

  bool get isReconnecting => status == ReconnectionStatus.reconnecting;
  bool get isFailed => status == ReconnectionStatus.failed;
  bool get isCancelled => status == ReconnectionStatus.cancelled;
  bool get isIdle => status == ReconnectionStatus.idle;

  @override
  List<Object?> get props => [
        status,
        currentAttempt,
        maxAttempts,
        nextRetryIn,
        deviceId,
        errorMessage,
      ];
}
