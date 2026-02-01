import '../../domain/entities/athlete_profile.dart';
import '../../domain/entities/health_safety_limits.dart';
import 'health_training_personalization_service.dart';

/// Warnstufen für HR-Überschreitungen
enum HrWarningLevel {
  /// Normaler Bereich (HR < 85% vom sicheren Limit)
  normal,

  /// INFO-Warnung (85% ≤ HR < 95% vom sicheren Limit)
  /// Gelbe Anzeige, keine sofortige Aktion erforderlich
  info,

  /// WARNING-Warnung (95% ≤ HR < 100% vom sicheren Limit)
  /// Orange Anzeige + Audio Beep erforderlich
  warning,

  /// CRITICAL (HR ≥ 100% vom sicheren Limit)
  /// Rote Anzeige + Auto-Pause Option
  critical,
}

/// Status der aktuellen HR-Überwachung
class HrMonitoringStatus {
  /// Aktuelle Herzfrequenz in bpm
  final int? currentHr;

  /// Maximale sichere HR für diesen Athleten in bpm
  final int maxSafeHr;

  /// Sicherheitslimits basierend auf Alter
  final HealthSafetyLimits safetyLimits;

  /// Aktuelle Warnstufe
  final HrWarningLevel warningLevel;

  /// Prozentsatz vom sicheren Limit (z.B. 87% bei Warnstufe INFO)
  final int hrPercent;

  /// Sollte automatisch pausiert werden?
  final bool shouldAutoPause;

  /// HR-Rückgang in der letzten Minute (optional, wenn Recovery gemessen wird)
  final int? recoveryHrDrop;

  /// Zeit der letzten INFO-Warnung (für Audio-Cooldown)
  final DateTime? lastInfoWarningTime;

  /// Zeit der letzten WARNING-Warnung
  final DateTime? lastWarningWarningTime;

  HrMonitoringStatus({
    this.currentHr,
    required this.maxSafeHr,
    required this.safetyLimits,
    required this.warningLevel,
    required this.hrPercent,
    required this.shouldAutoPause,
    this.recoveryHrDrop,
    this.lastInfoWarningTime,
    this.lastWarningWarningTime,
  });

  /// Kopiert diesen Status mit optionalen Änderungen
  HrMonitoringStatus copyWith({
    int? currentHr,
    int? maxSafeHr,
    HealthSafetyLimits? safetyLimits,
    HrWarningLevel? warningLevel,
    int? hrPercent,
    bool? shouldAutoPause,
    int? recoveryHrDrop,
    DateTime? lastInfoWarningTime,
    DateTime? lastWarningWarningTime,
  }) {
    return HrMonitoringStatus(
      currentHr: currentHr ?? this.currentHr,
      maxSafeHr: maxSafeHr ?? this.maxSafeHr,
      safetyLimits: safetyLimits ?? this.safetyLimits,
      warningLevel: warningLevel ?? this.warningLevel,
      hrPercent: hrPercent ?? this.hrPercent,
      shouldAutoPause: shouldAutoPause ?? this.shouldAutoPause,
      recoveryHrDrop: recoveryHrDrop ?? this.recoveryHrDrop,
      lastInfoWarningTime: lastInfoWarningTime ?? this.lastInfoWarningTime,
      lastWarningWarningTime: lastWarningWarningTime ?? this.lastWarningWarningTime,
    );
  }

  /// Gibt ein Warntext basierend auf der Warnstufe zurück
  String get warningMessage {
    switch (warningLevel) {
      case HrWarningLevel.normal:
        return '';
      case HrWarningLevel.info:
        return 'HR erhöht: $currentHr bpm ($hrPercent%)';
      case HrWarningLevel.warning:
        return 'HR zu hoch: $currentHr bpm ($hrPercent%)';
      case HrWarningLevel.critical:
        return 'KRITISCH: HR zu hoch! $currentHr bpm ($hrPercent%)';
    }
  }
}

/// Service zur Überwachung der Herzfrequenz während Health Training Programmen
///
/// Vergleicht aktuelle HR mit altersgerechten Sicherheitslimits und
/// bestimmt die Warnstufe und ob automatisch pausiert werden sollte.
class HealthTrainingSafetyMonitor {
  /// Berechnet den aktuellen HR-Überwachungsstatus
  ///
  /// Wird aufgerufen wenn neue HR-Daten verfügbar sind.
  /// Gibt detaillierte Info über aktuelle Warnstufe und Sicherheitslimit zurück.
  static HrMonitoringStatus calculateHrStatus({
    required int? currentHr,
    required AthleteProfile athlete,
    DateTime? lastInfoWarningTime,
    DateTime? lastWarningWarningTime,
  }) {
    final age = athlete.age ?? 45;
    final maxHr = athlete.maxHr ?? HealthTrainingPersonalizationService.calculateMaxHeartRate(age, gender: athlete.gender);
    final safetyLimits = HealthSafetyLimits.forAge(age);

    // Wenn keine HR verfügbar, kann nicht überwacht werden
    if (currentHr == null) {
      return HrMonitoringStatus(
        currentHr: null,
        maxSafeHr: (maxHr * (safetyLimits.maxHrPercent / 100)).round(),
        safetyLimits: safetyLimits,
        warningLevel: HrWarningLevel.normal,
        hrPercent: 0,
        shouldAutoPause: false,
        lastInfoWarningTime: lastInfoWarningTime,
        lastWarningWarningTime: lastWarningWarningTime,
      );
    }

    // Berechne maxSafeHr basierend auf age-predicted max HR
    final maxSafeHr = (maxHr * (safetyLimits.maxHrPercent / 100)).round();
    final autoPauseHr = (maxHr * (safetyLimits.autoPauseHrPercent / 100)).round();

    // Berechne aktuellen HR-Prozentsatz vom sicheren Limit
    final hrPercent = ((currentHr / maxSafeHr) * 100).round();

    // Bestimme Warnstufe
    final warningLevel = _determineWarningLevel(
      currentHr,
      maxSafeHr,
      autoPauseHr,
      safetyLimits.maxHrPercent,
    );

    // Auto-Pause wenn HR >= autoPauseHr
    final shouldAutoPause = currentHr >= autoPauseHr;

    return HrMonitoringStatus(
      currentHr: currentHr,
      maxSafeHr: maxSafeHr,
      safetyLimits: safetyLimits,
      warningLevel: warningLevel,
      hrPercent: hrPercent,
      shouldAutoPause: shouldAutoPause,
      lastInfoWarningTime: lastInfoWarningTime,
      lastWarningWarningTime: lastWarningWarningTime,
    );
  }

  /// Bestimmt die Warnstufe basierend auf aktuellem HR und Limits
  static HrWarningLevel _determineWarningLevel(
    int currentHr,
    int maxSafeHr,
    int autoPauseHr,
    int maxHrPercent,
  ) {
    // CRITICAL: HR >= autoPauseHr (100% von maxSafeHr)
    if (currentHr >= autoPauseHr) {
      return HrWarningLevel.critical;
    }

    // WARNING: HR >= 95% von maxSafeHr
    final warningThreshold = (maxSafeHr * 0.95).round();
    if (currentHr >= warningThreshold) {
      return HrWarningLevel.warning;
    }

    // INFO: HR >= 85% von maxSafeHr
    final infoThreshold = (maxSafeHr * 0.85).round();
    if (currentHr >= infoThreshold) {
      return HrWarningLevel.info;
    }

    return HrWarningLevel.normal;
  }

  /// Berechnet den HR-Rückgang über eine Zeitperiode (für Recovery-Analyse)
  ///
  /// Wird verwendet um die Recovery-Fähigkeit zu beurteilen.
  /// Gibt den Rückgang in bpm an (z.B. HR von 160 auf 140 = 20 bpm Rückgang).
  static int? calculateRecoveryHrDrop({
    required int peakHr,
    required int currentHr,
  }) {
    if (currentHr < peakHr) {
      return peakHr - currentHr;
    }
    return null; // HR ist nicht gesunken (noch in Aktivität)
  }

  /// Prüft ob HR Recovery für diesen Athleten ausreichend ist
  ///
  /// Eine gute Recovery sollte mindestens minRecoveryHrDrop bpm sein.
  /// Wird nur relevant wenn Recovery-Phase gemessen wird.
  static bool isRecoveryAdequate({
    required int hrDrop,
    required int minExpectedDrop,
  }) {
    return hrDrop >= minExpectedDrop;
  }

  /// Bestimmt ob eine Audio-Warnung abgespielt werden sollte
  ///
  /// Verhindert Audio-Spam durch Cooldown zwischen Warnungen:
  /// - INFO-Warnungen: 5 Sekunden Cooldown
  /// - WARNING-Warnungen: 3 Sekunden Cooldown
  static bool shouldPlayAudioWarning(
    HrWarningLevel warningLevel,
    DateTime? lastWarningTime,
  ) {
    if (warningLevel == HrWarningLevel.normal) {
      return false;
    }

    if (lastWarningTime == null) {
      return true;
    }

    final cooldownDuration = warningLevel == HrWarningLevel.info
        ? Duration(seconds: 5)
        : Duration(seconds: 3);

    final timeSinceLastWarning = DateTime.now().difference(lastWarningTime);
    return timeSinceLastWarning >= cooldownDuration;
  }
}
