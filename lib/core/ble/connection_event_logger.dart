import 'package:intl/intl.dart';

/// Repräsentiert ein BLE-Verbindungsereignis für Diagnostik
class BleConnectionEvent {
  final DateTime timestamp;
  final String eventType; // connect, disconnect, reconnect_start, reconnect_success, reconnect_fail, reconnect_attempt
  final String? deviceId;
  final String? deviceName;
  final String? errorMessage;
  final int? attemptNumber; // Für reconnect_attempt: welcher Versuch
  final int? maxAttempts; // Maximale Versuche

  BleConnectionEvent({
    required this.timestamp,
    required this.eventType,
    this.deviceId,
    this.deviceName,
    this.errorMessage,
    this.attemptNumber,
    this.maxAttempts,
  });

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'eventType': eventType,
        'deviceId': deviceId,
        'deviceName': deviceName,
        'errorMessage': errorMessage,
        'attemptNumber': attemptNumber,
        'maxAttempts': maxAttempts,
      };

  String get formattedTimestamp => DateFormat('HH:mm:ss.SSS').format(timestamp);

  @override
  String toString() =>
      '[$formattedTimestamp] $eventType${deviceId != null ? ' ($deviceId)' : ''}${attemptNumber != null ? ' - Attempt $attemptNumber/$maxAttempts' : ''}${errorMessage != null ? ' - Error: $errorMessage' : ''}';
}

/// Logger für BLE-Verbindungsereignisse
class BleConnectionEventLogger {
  static final List<BleConnectionEvent> _events = [];
  static const int maxEvents = 100;

  /// Fügt ein Ereignis zum Log hinzu
  static void logEvent(BleConnectionEvent event) {
    _events.add(event);

    // Entferne älteste Events wenn Grenzwert überschritten
    if (_events.length > maxEvents) {
      _events.removeAt(0);
    }
  }

  /// Benachrichtigungen für häufige Ereignisse
  static void logConnect(String deviceId, String deviceName) {
    logEvent(BleConnectionEvent(
      timestamp: DateTime.now(),
      eventType: 'connect',
      deviceId: deviceId,
      deviceName: deviceName,
    ));
  }

  static void logDisconnect(String deviceId, String deviceName, {String? reason}) {
    logEvent(BleConnectionEvent(
      timestamp: DateTime.now(),
      eventType: 'disconnect',
      deviceId: deviceId,
      deviceName: deviceName,
      errorMessage: reason,
    ));
  }

  static void logReconnectStart(String deviceId, String deviceName) {
    logEvent(BleConnectionEvent(
      timestamp: DateTime.now(),
      eventType: 'reconnect_start',
      deviceId: deviceId,
      deviceName: deviceName,
    ));
  }

  static void logReconnectAttempt(
    String deviceId,
    String deviceName,
    int attempt,
    int maxAttempts,
  ) {
    logEvent(BleConnectionEvent(
      timestamp: DateTime.now(),
      eventType: 'reconnect_attempt',
      deviceId: deviceId,
      deviceName: deviceName,
      attemptNumber: attempt,
      maxAttempts: maxAttempts,
    ));
  }

  static void logReconnectSuccess(String deviceId, String deviceName) {
    logEvent(BleConnectionEvent(
      timestamp: DateTime.now(),
      eventType: 'reconnect_success',
      deviceId: deviceId,
      deviceName: deviceName,
    ));
  }

  static void logReconnectFail(
    String deviceId,
    String deviceName,
    int attempts,
    String reason,
  ) {
    logEvent(BleConnectionEvent(
      timestamp: DateTime.now(),
      eventType: 'reconnect_fail',
      deviceId: deviceId,
      deviceName: deviceName,
      attemptNumber: attempts,
      errorMessage: reason,
    ));
  }

  /// Gibt alle Events zurück (unmodifiable)
  static List<BleConnectionEvent> getEvents() => List.unmodifiable(_events);

  /// Gibt Events als formatierten String zurück
  static String getFormattedLog() {
    if (_events.isEmpty) {
      return 'No connection events logged yet.';
    }

    return _events.map((e) => e.toString()).join('\n');
  }

  /// Löscht alle Events
  static void clear() {
    _events.clear();
  }

  /// Gibt an wie viele Events geloggt sind
  static int get eventCount => _events.length;

  /// Gibt die letzten N Events zurück
  static List<BleConnectionEvent> getLastEvents(int count) {
    final start = (_events.length - count).clamp(0, _events.length);
    return _events.sublist(start);
  }
}
