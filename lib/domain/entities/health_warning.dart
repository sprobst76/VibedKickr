import 'package:equatable/equatable.dart';

/// Schweregrad einer Gesundheitsmodus-Warnung
enum HealthWarningSeverity {
  info,     // Informativ
  warning,  // Aufmerksamkeit erforderlich
  critical, // Sofortiges Handeln erforderlich
}

/// Typ einer Gesundheitsmodus-Warnung
enum HealthWarningType {
  restingHrElevated,     // Ruhepuls >10% über Baseline
  wellnessDeclining,     // 3+ Tage fallender Trend
  overtrainingRisk,      // Mehrere negative Indikatoren
  lowWellnessScore,      // Score <40% für 2+ Tage
  readyForProgression,   // Bereit für nächste Phase (Info)
  ftpImprovement,        // FTP-Verbesserung erkannt (Info)
  highWeeklyTss,         // 400-499 TSS/Woche (Training Load)
  excessiveWeeklyTss,    // 500+ TSS/Woche (Training Load)
}

/// Gesundheitsmodus-Warnung mit Informationen für den Benutzer
class HealthWarning extends Equatable {
  final HealthWarningType type;
  final HealthWarningSeverity severity;
  final String title;
  final String message;
  final String? actionLabel;
  final DateTime createdAt;

  const HealthWarning({
    required this.type,
    required this.severity,
    required this.title,
    required this.message,
    this.actionLabel,
    required DateTime createdAt,
  }) : createdAt = createdAt;

  @override
  List<Object?> get props => [type, severity, title, message, actionLabel, createdAt];
}
