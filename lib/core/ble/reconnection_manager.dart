import 'dart:async';
import 'dart:math';

import '../../main.dart';
import 'models/reconnection_state.dart';

/// Verwaltet die Reconnection-Logik mit exponentieller Backoff-Strategie
class BleReconnectionManager {
  // Configuration
  static const int defaultMaxRetries = 5;
  static const int baseDelaySeconds = 2;
  static const int maxDelaySeconds = 60;

  // State
  final _reconnectionStateController =
      StreamController<BleReconnectionState>.broadcast();
  Timer? _reconnectionTimer;
  int _currentAttempt = 0;
  int _maxAttempts = defaultMaxRetries;
  bool _isReconnecting = false;
  bool get isReconnecting => _isReconnecting;
  bool _disposed = false;
  String? _currentDeviceId;

  // Stream for UI listening
  Stream<BleReconnectionState> get reconnectionState =>
      _reconnectionStateController.stream;

  /// Safely adds an event if not disposed
  void _safeAdd(BleReconnectionState state) {
    if (!_disposed && !_reconnectionStateController.isClosed) {
      _reconnectionStateController.add(state);
    }
  }

  /// Berechnet die Backoff-Verzögerung für einen Versuch (exponentiell)
  /// Attempt 1: 2s, Attempt 2: 4s, Attempt 3: 8s, etc.
  Duration _calculateBackoff(int attempt) {
    if (attempt <= 0) return Duration.zero;

    // 2^(attempt-1) * baseDelaySeconds
    final delaySeconds = baseDelaySeconds * (1 << (attempt - 1));
    final cappedSeconds = min(delaySeconds, maxDelaySeconds);

    return Duration(seconds: cappedSeconds);
  }

  /// Startet die Reconnection mit exponentieller Backoff-Strategie
  ///
  /// [deviceId]: ID des Geräts, das reconnected werden soll
  /// [reconnectFunction]: Async Funktion die die tatsächliche Reconnection durchführt
  /// [maxAttempts]: Maximale Anzahl der Versuche (default: 5)
  /// [onStateChange]: Callback wenn der Reconnection-Status sich ändert
  Future<void> startReconnection({
    required String deviceId,
    required Future<bool> Function() reconnectFunction,
    int maxAttempts = defaultMaxRetries,
    void Function(BleReconnectionState)? onStateChange,
  }) async {
    // Guard: Verhindere konkurrierende Reconnection-Versuche
    if (_isReconnecting && _currentDeviceId == deviceId) {
      logger.w('Reconnection already in progress for device: $deviceId');
      return;
    }

    // Cancel bestehende Reconnection wenn ein neues Gerät reconnected wird
    if (_isReconnecting && _currentDeviceId != deviceId) {
      cancelReconnection();
    }

    logger.i('Starting reconnection for device: $deviceId (max $maxAttempts attempts)');

    _isReconnecting = true;
    _currentAttempt = 0;
    _maxAttempts = maxAttempts;
    _currentDeviceId = deviceId;

    while (_currentAttempt < _maxAttempts && _isReconnecting) {
      _currentAttempt++;

      // Berechne Backoff-Verzögerung
      final backoffDuration = _calculateBackoff(_currentAttempt);

      // Emittiere Reconnecting-State
      final reconnectingState = BleReconnectionState.reconnecting(
        deviceId: deviceId,
        currentAttempt: _currentAttempt,
        maxAttempts: _maxAttempts,
        nextRetryIn: backoffDuration,
      );

      _safeAdd(reconnectingState);
      onStateChange?.call(reconnectingState);

      logger.i(
        'Reconnection attempt $_currentAttempt/$_maxAttempts for $deviceId '
        '(next retry in ${backoffDuration.inSeconds}s)',
      );

      // Warte auf Backoff-Verzögerung (abbrechbar über _isReconnecting flag)
      _reconnectionTimer?.cancel();
      _reconnectionTimer = Timer(backoffDuration, () {});
      await Future.delayed(backoffDuration);
      _reconnectionTimer = null;

      // Prüfe ob während der Verzögerung abgebrochen wurde
      if (!_isReconnecting) {
        logger.i('Reconnection cancelled during backoff delay');
        final cancelledState = BleReconnectionState.cancelled(deviceId: deviceId);
        _safeAdd(cancelledState);
        onStateChange?.call(cancelledState);
        _cleanup();
        return;
      }

      // Versuche zu reconnecten
      try {
        logger.d('Attempting reconnection (attempt $_currentAttempt/$_maxAttempts)');
        final success = await reconnectFunction.call().timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            logger.w('Reconnection timeout on attempt $_currentAttempt/$_maxAttempts');
            return false;
          },
        );

        if (success) {
          logger.i('Reconnection successful on attempt $_currentAttempt/$_maxAttempts');
          _safeAdd(
            BleReconnectionState.idle(),
          );
          _cleanup();
          return;
        }
      } catch (e) {
        logger.w('Reconnection attempt $_currentAttempt/$_maxAttempts failed: $e');
      }

      // Wenn das der letzte Versuch war, geben wir auf
      if (_currentAttempt >= _maxAttempts) {
        logger.e('Reconnection failed after $_maxAttempts attempts for $deviceId');
        final failedState = BleReconnectionState.failed(
          deviceId: deviceId,
          maxAttempts: _maxAttempts,
          errorMessage: 'Failed to reconnect after $_maxAttempts attempts',
        );
        _safeAdd(failedState);
        onStateChange?.call(failedState);
        _cleanup();
        return;
      }
    }

    if (!_isReconnecting) {
      logger.i('Reconnection cancelled for device: $deviceId');
      final cancelledState = BleReconnectionState.cancelled(deviceId: deviceId);
      _safeAdd(cancelledState);
      onStateChange?.call(cancelledState);
    }

    _cleanup();
  }

  /// Bricht die aktive Reconnection ab
  void cancelReconnection() {
    if (!_isReconnecting) return;

    logger.i('Cancelling reconnection for device: $_currentDeviceId');
    _isReconnecting = false;
    _reconnectionTimer?.cancel();
    _reconnectionTimer = null;

    if (_currentDeviceId != null) {
      final cancelledState =
          BleReconnectionState.cancelled(deviceId: _currentDeviceId!);
      _safeAdd(cancelledState);
    }

    _cleanup();
  }

  /// Setzt die Reconnection auf idle zurück
  void reset() {
    logger.d('Resetting reconnection manager');
    _isReconnecting = false;
    _currentAttempt = 0;
    _maxAttempts = defaultMaxRetries;
    _currentDeviceId = null;
    _reconnectionTimer?.cancel();
    _reconnectionTimer = null;
    _safeAdd(BleReconnectionState.idle());
  }

  /// Cleanup-Hilfsmethode
  void _cleanup() {
    _isReconnecting = false;
    _reconnectionTimer?.cancel();
    _reconnectionTimer = null;
  }

  /// Dispose - Call wenn nicht mehr nötig
  void dispose() {
    _disposed = true;
    _reconnectionTimer?.cancel();
    _reconnectionTimer = null;
    if (!_reconnectionStateController.isClosed) {
      _reconnectionStateController.close();
    }
  }
}
