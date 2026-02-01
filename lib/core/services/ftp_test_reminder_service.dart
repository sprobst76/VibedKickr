import '../../domain/entities/health_warning.dart';

/// Service zur Generierung von FTP-Test-Erinnerungen
///
/// Erinnert Benutzer daran, ihren FTP-Test zu wiederholen,
/// wenn es zu lange her ist seit dem letzten Update.
class FtpTestReminderService {
  // Schwellwerte in Tagen (basierend auf Best Practices: FTP alle 4-8 Wochen)
  static const int infoThreshold = 28;      // 4 Wochen
  static const int warningThreshold = 42;   // 6 Wochen
  static const int criticalThreshold = 56;  // 8 Wochen

  /// Generiert Warnungen basierend auf ftpTestDate
  ///
  /// Parameter:
  /// - [ftpTestDate]: Datum des letzten FTP-Tests (nullable)
  ///
  /// Rückgabe:
  /// - Liste von Warnungen (0-1 Warnungen pro Aufruf)
  ///
  /// Null Handling: Wenn ftpTestDate null, keine Warnung (neu konfiguriert)
  List<HealthWarning> generateWarnings(DateTime? ftpTestDate) {
    // Wenn kein Datum gesetzt, keine Warnung (neu konfigurierter Benutzer)
    if (ftpTestDate == null) return [];

    final daysSinceTest = DateTime.now().difference(ftpTestDate).inDays;

    if (daysSinceTest >= criticalThreshold) {
      return [_createCriticalWarning(daysSinceTest)];
    } else if (daysSinceTest >= warningThreshold) {
      return [_createWarningWarning(daysSinceTest)];
    } else if (daysSinceTest >= infoThreshold) {
      return [_createInfoWarning(daysSinceTest)];
    }

    return [];
  }

  HealthWarning _createInfoWarning(int days) {
    final weeks = (days / 7).round();
    return HealthWarning(
      type: HealthWarningType.ftpTestReminder,
      severity: HealthWarningSeverity.info,
      title: 'FTP-Test empfohlen',
      message: 'Dein letzter FTP-Test ist $weeks Wochen her. '
          'Ein neuer Test kann helfen, deine Trainingszonen zu optimieren '
          'und deinen Fortschritt zu verfolgen.',
      actionLabel: 'FTP aktualisieren',
      createdAt: DateTime.now(),
    );
  }

  HealthWarning _createWarningWarning(int days) {
    final weeks = (days / 7).round();
    return HealthWarning(
      type: HealthWarningType.ftpTestOverdue,
      severity: HealthWarningSeverity.warning,
      title: 'FTP-Test überfällig',
      message: 'Dein letzter FTP-Test ist $weeks Wochen her. '
          'Für präzise Trainingszonen wird ein Test alle 4-6 Wochen empfohlen. '
          'Führe einen 20-Minuten-Test oder Ramp-Test durch.',
      actionLabel: 'FTP aktualisieren',
      createdAt: DateTime.now(),
    );
  }

  HealthWarning _createCriticalWarning(int days) {
    final weeks = (days / 7).round();
    return HealthWarning(
      type: HealthWarningType.ftpTestCritical,
      severity: HealthWarningSeverity.critical,
      title: 'FTP-Test dringend empfohlen',
      message: 'Dein letzter FTP-Test ist $weeks Wochen her! '
          'Deine Trainingszonen könnten nicht mehr akkurat sein. '
          'Ein FTP-Test ist dringend erforderlich für effektives Training.',
      actionLabel: 'Jetzt FTP testen',
      createdAt: DateTime.now(),
    );
  }
}
