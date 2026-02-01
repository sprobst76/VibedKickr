import '../../domain/entities/health_warning.dart';

/// Service zur Generierung von Trainingsbelastungs-Warnungen
///
/// Warnt Benutzer, wenn ihre wöchentliche Trainingsbelastung (TSS)
/// oberhalb empfohlener Schwellwerte liegt.
class TrainingLoadWarningService {
  // TSS Schwellwerte basierend auf Coggan/Allen Research
  static const int warningThreshold = 400;   // TSS/Woche - Hohe Belastung
  static const int criticalThreshold = 500;  // TSS/Woche - Sehr hohe Belastung

  /// Generiert Warnungen basierend auf wöchentlichem TSS
  ///
  /// Parameter:
  /// - [weeklyTss]: Trainings Stress Score für die aktuelle Woche (rolling 7 days)
  ///
  /// Rückgabe:
  /// - Liste von Warnungen (0-1 Warnungen pro Aufruf)
  ///
  /// Warnung-Schwellwerte:
  /// - < 400 TSS: Keine Warnung
  /// - 400-499 TSS: Warning (gelb)
  /// - >= 500 TSS: Critical (rot)
  List<HealthWarning> generateWarnings(int weeklyTss) {
    final warnings = <HealthWarning>[];

    if (weeklyTss >= criticalThreshold) {
      warnings.add(HealthWarning(
        type: HealthWarningType.excessiveWeeklyTss,
        severity: HealthWarningSeverity.critical,
        title: 'Sehr hohe Trainingsbelastung',
        message: 'Du hast diese Woche $weeklyTss TSS erreicht. '
            'Das ist eine sehr hohe Belastung für Amateur-Athleten. '
            'Risiko von Übertraining und Verletzungen steigt deutlich. '
            'Erwäge Ruhetage und reduziere die Intensität.',
        actionLabel: 'Erholungstipps',
        createdAt: DateTime.now(),
      ));
    } else if (weeklyTss >= warningThreshold) {
      warnings.add(HealthWarning(
        type: HealthWarningType.highWeeklyTss,
        severity: HealthWarningSeverity.warning,
        title: 'Hohe Trainingsbelastung',
        message: 'Du hast diese Woche $weeklyTss TSS erreicht. '
            'Das ist eine hohe Belastung. Achte auf ausreichende Erholung '
            'und plane Ruhetage ein, um Übertraining zu vermeiden.',
        actionLabel: 'Training anpassen',
        createdAt: DateTime.now(),
      ));
    }

    return warnings;
  }
}
