import 'package:equatable/equatable.dart';

/// TSS Threshold Settings mit Hybrid-Ansatz: CTL-basiert oder manuell
class TssThresholdSettings extends Equatable {
  /// Verwende CTL-basierte Schwellwerte (automatisch) statt manuell
  final bool useCtlBased;

  /// Manuelle Warnung-Schwellwert (nur wenn useCtlBased = false)
  final int manualWarningThreshold;

  /// Manuelle Kritisch-Schwellwert (nur wenn useCtlBased = false)
  final int manualCriticalThreshold;

  /// Multiplikator für CTL-basierte Warnung (CTL × this = Warning Threshold)
  final double ctlWarningMultiplier;

  /// Multiplikator für CTL-basierte Kritisch (CTL × this = Critical Threshold)
  final double ctlCriticalMultiplier;

  // Floor und Cap Konstanten
  static const int minWarningThreshold = 300;
  static const int maxWarningThreshold = 800;
  static const int minCriticalThreshold = 400;
  static const int maxCriticalThreshold = 1000;

  const TssThresholdSettings({
    this.useCtlBased = true,
    this.manualWarningThreshold = 400,
    this.manualCriticalThreshold = 500,
    this.ctlWarningMultiplier = 1.5,
    this.ctlCriticalMultiplier = 2.0,
  });

  /// Berechne Warnung-Schwellwert basierend auf Modus und CTL
  ///
  /// Im CTL-Modus: CTL × [ctlWarningMultiplier], dann geclampt zu [minWarningThreshold]-[maxWarningThreshold]
  /// Im manuellen Modus: [manualWarningThreshold]
  int getWarningThreshold(double ctl) {
    if (useCtlBased) {
      final calculated = (ctl * ctlWarningMultiplier).round();
      return calculated.clamp(minWarningThreshold, maxWarningThreshold);
    }
    return manualWarningThreshold;
  }

  /// Berechne Kritisch-Schwellwert basierend auf Modus und CTL
  ///
  /// Im CTL-Modus: CTL × [ctlCriticalMultiplier], dann geclampt zu [minCriticalThreshold]-[maxCriticalThreshold]
  /// Im manuellen Modus: [manualCriticalThreshold]
  int getCriticalThreshold(double ctl) {
    if (useCtlBased) {
      final calculated = (ctl * ctlCriticalMultiplier).round();
      return calculated.clamp(minCriticalThreshold, maxCriticalThreshold);
    }
    return manualCriticalThreshold;
  }

  /// Erstelle eine Kopie mit optionalen Überschreibungen
  TssThresholdSettings copyWith({
    bool? useCtlBased,
    int? manualWarningThreshold,
    int? manualCriticalThreshold,
    double? ctlWarningMultiplier,
    double? ctlCriticalMultiplier,
  }) {
    return TssThresholdSettings(
      useCtlBased: useCtlBased ?? this.useCtlBased,
      manualWarningThreshold: manualWarningThreshold ?? this.manualWarningThreshold,
      manualCriticalThreshold: manualCriticalThreshold ?? this.manualCriticalThreshold,
      ctlWarningMultiplier: ctlWarningMultiplier ?? this.ctlWarningMultiplier,
      ctlCriticalMultiplier: ctlCriticalMultiplier ?? this.ctlCriticalMultiplier,
    );
  }

  /// Serialisiere zu JSON für SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'useCtlBased': useCtlBased,
      'manualWarningThreshold': manualWarningThreshold,
      'manualCriticalThreshold': manualCriticalThreshold,
      'ctlWarningMultiplier': ctlWarningMultiplier,
      'ctlCriticalMultiplier': ctlCriticalMultiplier,
    };
  }

  /// Deserialisiere von JSON (von SharedPreferences)
  factory TssThresholdSettings.fromJson(Map<String, dynamic> json) {
    return TssThresholdSettings(
      useCtlBased: json['useCtlBased'] as bool? ?? true,
      manualWarningThreshold: json['manualWarningThreshold'] as int? ?? 400,
      manualCriticalThreshold: json['manualCriticalThreshold'] as int? ?? 500,
      ctlWarningMultiplier: (json['ctlWarningMultiplier'] as num?)?.toDouble() ?? 1.5,
      ctlCriticalMultiplier: (json['ctlCriticalMultiplier'] as num?)?.toDouble() ?? 2.0,
    );
  }

  @override
  List<Object?> get props => [
        useCtlBased,
        manualWarningThreshold,
        manualCriticalThreshold,
        ctlWarningMultiplier,
        ctlCriticalMultiplier,
      ];
}
