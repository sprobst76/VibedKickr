import '../../domain/entities/health_warning.dart';
import '../../domain/entities/tss_threshold_settings.dart';

/// Service zur Generierung von Trainingsbelastungs-Warnungen
///
/// Warnt Benutzer, wenn ihre wöchentliche Trainingsbelastung (TSS)
/// oberhalb konfigurierter Schwellwerte liegt.
///
/// Unterstützt zwei Modi:
/// - CTL-basiert: Schwellwerte werden basierend auf CTL berechnet (Standard)
/// - Manuell: Benutzer-definierte feste Schwellwerte
class TrainingLoadWarningService {
  /// Generiert Warnungen basierend auf wöchentlichem TSS und Schwellwert-Einstellungen
  ///
  /// Parameter:
  /// - [weeklyTss]: Trainings Stress Score für die aktuelle Woche (rolling 7 days)
  /// - [settings]: TSS Threshold Settings (optional, default: CTL-basiert)
  /// - [ctl]: Aktueller CTL Wert für CTL-basierte Berechnung (optional)
  ///
  /// Rückgabe:
  /// - Liste von Warnungen (0-1 Warnungen pro Aufruf)
  List<HealthWarning> generateWarnings(
    int weeklyTss, {
    TssThresholdSettings? settings,
    double? ctl,
  }) {
    final effectiveSettings = settings ?? const TssThresholdSettings();
    final effectiveCTL = ctl ?? 0.0;

    final warningThreshold = effectiveSettings.getWarningThreshold(effectiveCTL);
    final criticalThreshold = effectiveSettings.getCriticalThreshold(effectiveCTL);

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
