import '../../domain/entities/athlete_profile.dart';
import '../../domain/entities/health_safety_limits.dart';

/// Service zur Personalisierung von Health Training Programmen
/// basierend auf Alter, Geschlecht, Gewicht und FTP des Athleten
class HealthTrainingPersonalizationService {
  /// Berechnet die maximale Herzfrequenz basierend auf wissenschaftlichen Formeln
  ///
  /// Verwendet altersabhängig unterschiedliche Formeln:
  /// - Tanaka (2001): 208 - (0.7 × Alter) - Standard für Männer
  /// - Gulati (2010): 206 - (0.88 × Alter) - Für Frauen
  /// - Gellish Fallback: 207 - (0.7 × Alter) - Allgemein
  static int calculateMaxHeartRate(int age, {Gender? gender}) {
    // Wenn gender bekannt, verwende geschlechtsspezifische Formel
    if (gender == Gender.female) {
      // Gulati Formel für Frauen (Gulati et al. 2010)
      return (206 - (0.88 * age)).round();
    }

    // Tanaka Formel für Männer (Tanaka et al. 2001) - Standard
    return (208 - (0.7 * age)).round();
  }

  /// Berechnet den Age Factor zur Intensitätsanpassung
  /// Basierend auf altersabhängigen sicheren Trainings-Prozentsätzen
  ///
  /// Beispiel:
  /// - 25-Jähriger: kann bis 90% max HR trainieren → Age Factor = 0.90
  /// - 65-Jähriger: kann bis 75% max HR trainieren → Age Factor = 0.75
  static double calculateAgeFactor(int age) {
    if (age < 40) return 0.90; // Junge Athleten können bis 90% trainieren
    if (age < 50) return 0.85; // 40-50: bis 85%
    if (age < 60) return 0.80; // 50-60: bis 80%
    if (age < 70) return 0.75; // 60-70: bis 75%
    return 0.70; // 70+: konservativ bis 70%
  }

  /// Berechnet die Trainingsintensität mit Age Factor
  ///
  /// Konvertiert absolute % des max HR in sichere Trainings-% für das Alter
  static int applyAgeFactor(int maxHr, int targetPercent, int age) {
    final ageFactor = calculateAgeFactor(age);
    final adjustedPercent = (targetPercent * ageFactor).round();
    return ((adjustedPercent / 100) * maxHr).round();
  }

  /// Berechnet sichere HR-Ziele basierend auf Athletenprofil
  ///
  /// Gibt ein Tupel zurück: (targetHR, maxSafeHR)
  static (int, int) calculateSafeHeartRateZone(
    AthleteProfile athlete,
    int targetPercentOfMax,
  ) {
    // Verwende vorhandene maxHr oder berechne sie
    final maxHr = athlete.maxHr ?? calculateMaxHeartRate(athlete.age ?? 45, gender: athlete.gender);

    // Target HR: Ziel-Herzfrequenz für das Training
    final targetHr = ((targetPercentOfMax / 100) * maxHr).round();

    // Max Safe HR: mit Age Factor reduzierte maximale sichere Grenze
    final ageFactor = calculateAgeFactor(athlete.age ?? 45);
    final maxSafePercent = (ageFactor * 100).round();
    final maxSafeHr = ((maxSafePercent / 100) * maxHr).round();

    return (targetHr, maxSafeHr);
  }

  /// Holt die Sicherheitsgrenzen für einen Athleten
  static HealthSafetyLimits getSafetyLimits(AthleteProfile athlete) {
    final age = athlete.age ?? 45;
    return HealthSafetyLimits.forAge(age);
  }

  /// Berechnet personalisierte Warm-up Dauer basierend auf Alter
  ///
  /// Ältere Athleten benötigen längere Warm-ups:
  /// - <40 Jahre: 5 min
  /// - 40-50: 7 min
  /// - 50-60: 10 min
  /// - 60-70: 12 min
  /// - 70+: 15 min
  static Duration calculateWarmupDuration(int age) {
    if (age < 40) return const Duration(minutes: 5);
    if (age < 50) return const Duration(minutes: 7);
    if (age < 60) return const Duration(minutes: 10);
    if (age < 70) return const Duration(minutes: 12);
    return const Duration(minutes: 15);
  }

  /// Berechnet personalisierte Cool-down Dauer basierend auf Alter
  ///
  /// Ältere Athleten benötigen längere Cool-downs für Erholung:
  /// - <40 Jahre: 5 min
  /// - 40-50: 7 min
  /// - 50-60: 10 min
  /// - 60-70: 12 min
  /// - 70+: 15 min
  static Duration calculateCooldownDuration(int age) {
    if (age < 40) return const Duration(minutes: 5);
    if (age < 50) return const Duration(minutes: 7);
    if (age < 60) return const Duration(minutes: 10);
    if (age < 70) return const Duration(minutes: 12);
    return const Duration(minutes: 15);
  }

  /// Berechnet personalisierte Rest/Recovery Dauer für Intervalle
  ///
  /// Ältere Athleten benötigen längere Erholung:
  /// - <40 Jahre: 1× Basis-Dauer
  /// - 40-50: 1.2× Basis-Dauer
  /// - 50-60: 1.4× Basis-Dauer
  /// - 60-70: 1.6× Basis-Dauer
  /// - 70+: 1.8× Basis-Dauer
  static Duration calculateRecoveryDuration(Duration baseDuration, int age) {
    final baseSeconds = baseDuration.inSeconds;

    if (age < 40) return Duration(seconds: baseSeconds);
    if (age < 50) return Duration(seconds: (baseSeconds * 1.2).round());
    if (age < 60) return Duration(seconds: (baseSeconds * 1.4).round());
    if (age < 70) return Duration(seconds: (baseSeconds * 1.6).round());
    return Duration(seconds: (baseSeconds * 1.8).round());
  }

  /// Bestimmt, ob ein Programm für einen Athleten geeignet ist
  ///
  /// Prüft:
  /// - Alter (min/max)
  /// - HR Monitor Verfügbarkeit (wenn erforderlich)
  /// - Geschlecht (optional)
  static bool isProgramSuitableForAthlete(
    AthleteProfile athlete,
    int programAgeMin,
    int? programAgeMax,
    bool requiresHrMonitor,
  ) {
    final age = athlete.age;
    if (age == null) return false;

    // Altersgrenze prüfen
    if (age < programAgeMin) return false;
    if (programAgeMax != null && age > programAgeMax) return false;

    // HR Monitor erforderlich?
    if (requiresHrMonitor && athlete.maxHr == null) {
      // Könnte verboten werden oder nur warnen - hier erlauben wir es mit Warnung
      return true; // Mit Warnung später
    }

    return true;
  }

  /// Gibt eine Personalisierungs-Zusammenfassung für Debug/UI zurück
  static PersonalizationSummary summarizePersonalization(AthleteProfile athlete) {
    final age = athlete.age ?? 45;
    final maxHr = athlete.maxHr ?? calculateMaxHeartRate(age, gender: athlete.gender);
    final ageFactor = calculateAgeFactor(age);
    final safetyLimits = getSafetyLimits(athlete);

    return PersonalizationSummary(
      age: age,
      gender: athlete.gender,
      maxHeartRate: maxHr,
      ageFactor: ageFactor,
      maxSafePercent: (ageFactor * 100).round(),
      safetyLimits: safetyLimits,
      warmupDuration: calculateWarmupDuration(age),
      cooldownDuration: calculateCooldownDuration(age),
    );
  }
}

/// Zusammenfassung der Personalisierung für Anzeige/Debug
class PersonalizationSummary {
  final int age;
  final Gender? gender;
  final int maxHeartRate;
  final double ageFactor;
  final int maxSafePercent;
  final HealthSafetyLimits safetyLimits;
  final Duration warmupDuration;
  final Duration cooldownDuration;

  PersonalizationSummary({
    required this.age,
    this.gender,
    required this.maxHeartRate,
    required this.ageFactor,
    required this.maxSafePercent,
    required this.safetyLimits,
    required this.warmupDuration,
    required this.cooldownDuration,
  });

  @override
  String toString() => '''PersonalizationSummary(
    age: $age,
    gender: $gender,
    maxHR: $maxHeartRate bpm,
    ageFactor: ${(ageFactor * 100).toStringAsFixed(1)}%,
    safePercent: $maxSafePercent%,
    warmup: ${warmupDuration.inMinutes} min,
    cooldown: ${cooldownDuration.inMinutes} min,
  )''';
}
