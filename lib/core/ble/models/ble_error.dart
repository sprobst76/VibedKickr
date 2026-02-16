/// Typisierte BLE-Fehler für strukturierte Fehlerbehandlung
enum BleErrorType {
  /// Bluetooth-Berechtigung wurde verweigert
  permissionDenied,

  /// Bluetooth-Adapter ist ausgeschaltet
  adapterOff,

  /// Verbindungstimeout
  connectionTimeout,

  /// Service Discovery Timeout
  serviceDiscoveryTimeout,

  /// FTMS/HR Service nicht auf dem Gerät gefunden
  serviceNotFound,

  /// BLE wird auf dieser Plattform nicht unterstützt
  notSupported,

  /// Reconnection fehlgeschlagen
  reconnectionFailed,

  /// Unbekannter Fehler
  unknown,
}

/// Strukturierter BLE-Fehler mit Typ und benutzerfreundlicher Nachricht
class BleError {
  final BleErrorType type;
  final String message;
  final String userMessage;

  const BleError({
    required this.type,
    required this.message,
    required this.userMessage,
  });

  /// Erstellt einen BleError für Berechtigungsfehler
  factory BleError.permissionDenied() => const BleError(
        type: BleErrorType.permissionDenied,
        message: 'Bluetooth permissions denied',
        userMessage:
            'Bluetooth-Berechtigung benötigt.\nBitte in den Einstellungen erlauben.',
      );

  /// Erstellt einen BleError für ausgeschaltetes Bluetooth
  factory BleError.adapterOff() => const BleError(
        type: BleErrorType.adapterOff,
        message: 'Bluetooth adapter is off',
        userMessage: 'Bluetooth ist ausgeschaltet.',
      );

  /// Erstellt einen BleError für Verbindungstimeout
  factory BleError.connectionTimeout() => const BleError(
        type: BleErrorType.connectionTimeout,
        message: 'Connection timed out',
        userMessage:
            'Verbindungstimeout.\nBitte stelle sicher, dass der Trainer eingeschaltet ist.',
      );

  /// Erstellt einen BleError für Service Discovery Timeout
  factory BleError.serviceDiscoveryTimeout() => const BleError(
        type: BleErrorType.serviceDiscoveryTimeout,
        message: 'Service discovery timed out',
        userMessage:
            'Service-Erkennung fehlgeschlagen.\nBitte versuche es erneut.',
      );

  /// Erstellt einen BleError für nicht gefundenen Service
  factory BleError.serviceNotFound(String serviceName) => BleError(
        type: BleErrorType.serviceNotFound,
        message: '$serviceName service not found on device',
        userMessage:
            'Kein $serviceName-Dienst gefunden.\nIst der Trainer im richtigen Modus?',
      );

  /// Erstellt einen BleError für nicht unterstützte Plattform
  factory BleError.notSupported() => const BleError(
        type: BleErrorType.notSupported,
        message: 'BLE not supported on this platform',
        userMessage:
            'BLE wird auf dieser Plattform nicht unterstützt.\nBitte Android/macOS verwenden.',
      );

  /// Erstellt einen BleError für fehlgeschlagene Reconnection
  factory BleError.reconnectionFailed(int attempts) => BleError(
        type: BleErrorType.reconnectionFailed,
        message: 'Reconnection failed after $attempts attempts',
        userMessage:
            'Wiederverbindung nach $attempts Versuchen fehlgeschlagen.',
      );

  /// Erstellt einen BleError für unbekannte Fehler
  factory BleError.unknown(String details) => BleError(
        type: BleErrorType.unknown,
        message: details,
        userMessage: 'Verbindungsfehler: $details',
      );

  /// Ob der Fehler durch einen erneuten Versuch behoben werden kann
  bool get isRetryable => switch (type) {
        BleErrorType.connectionTimeout => true,
        BleErrorType.serviceDiscoveryTimeout => true,
        BleErrorType.reconnectionFailed => true,
        BleErrorType.unknown => true,
        _ => false,
      };

  @override
  String toString() => 'BleError($type: $message)';
}
