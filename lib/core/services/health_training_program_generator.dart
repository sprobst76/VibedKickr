import '../../domain/entities/athlete_profile.dart';
import '../../domain/entities/workout.dart';
import 'health_training_personalization_service.dart';

/// Service zur Generierung personalisierter Health Training Programme
class HealthTrainingProgramGenerator {
  /// Generiert alle Health Training Programme für einen Athleten
  static List<Workout> generateAllPrograms(AthleteProfile athlete) {
    final programs = [
      generateMorningWakeup(athlete),
      generateBaselineAssessment(athlete),
      generateCardiacRehabIntervals(athlete),
      generateAgeOptimizedEndurance(athlete),
      generateRecoveryCapacityCheck(athlete),
    ];

    // Stress Test nur für < 60 Jahre
    final stressTest = generateProgressiveStressTest(athlete);
    if (stressTest != null) {
      programs.add(stressTest);
    }

    return programs;
  }

  /// Baseline Health Assessment (25 min)
  ///
  /// Ziel: Fitness-Level bestimmen durch progressive Stufenbelastung
  /// Struktur: 5min Warmup + 5 Stufen à 3min + 5min Cooldown
  /// Intensität: 50% → 90% max HR
  static Workout generateBaselineAssessment(AthleteProfile athlete) {
    final age = athlete.age ?? 45;
    final maxHr = athlete.maxHr ?? HealthTrainingPersonalizationService.calculateMaxHeartRate(age, gender: athlete.gender);
    final warmupDuration = HealthTrainingPersonalizationService.calculateWarmupDuration(age);
    final cooldownDuration = HealthTrainingPersonalizationService.calculateCooldownDuration(age);

    final intervals = <WorkoutInterval>[
      // Warmup
      WorkoutInterval(
        name: 'Warmup',
        duration: warmupDuration,
        type: IntervalType.warmup,
        powerTarget: PowerTarget.ftpPercent(50),
        targetHeartRate: ((50 / 100) * maxHr).round(),
        maxHeartRate: ((60 / 100) * maxHr).round(),
        instructions: 'Locker einrollen, Puls stetig erhöhen',
      ),

      // 5 progressive Stufen
      for (int i = 1; i <= 5; i++) ...[
        WorkoutInterval(
          name: 'Stufe $i',
          duration: const Duration(minutes: 3),
          type: IntervalType.work,
          powerTarget: PowerTarget.ftpPercent(50 + (i * 8)),
          targetHeartRate: (((50 + (i * 8)) / 100) * maxHr).round(),
          maxHeartRate: (((50 + (i * 8) + 5) / 100) * maxHr).round(),
          cadenceMin: 85,
          cadenceMax: 95,
          instructions: 'Gleichmäßig treten, Atmung kontrollieren',
          monitorRecovery: false,
        ),
      ],

      // Cooldown
      WorkoutInterval(
        name: 'Cooldown',
        duration: cooldownDuration,
        type: IntervalType.cooldown,
        powerTarget: PowerTarget.ftpPercent(40),
        targetHeartRate: ((40 / 100) * maxHr).round(),
        maxHeartRate: ((50 / 100) * maxHr).round(),
        instructions: 'Locker ausrollen, Puls langsam senken',
        monitorRecovery: true,
      ),
    ];

    return Workout(
      id: 'health_baseline_${athlete.id}',
      name: 'Baseline Health Assessment',
      description: 'Progressive 25-Minuten Stufenbelastung zur Bestimmung deines Fitness-Levels',
      type: WorkoutType.ramp,
      intervals: intervals,
      createdAt: DateTime.now(),
    );
  }

  /// Cardiac Rehab Intervals (35 min)
  ///
  /// Ziel: Herzgesundheit und kardiovaskuläre Ausdauer (besonders für 50+)
  /// Struktur: 10min Warmup + 4× (3min Work @ 60-70% / 3min Recovery) + 10min Cooldown
  /// Wissenschaftliche Basis: AHA Cardiac Rehabilitation Phases II-IV
  static Workout generateCardiacRehabIntervals(AthleteProfile athlete) {
    final age = athlete.age ?? 45;
    final maxHr = athlete.maxHr ?? HealthTrainingPersonalizationService.calculateMaxHeartRate(age, gender: athlete.gender);
    final safetyLimits = HealthTrainingPersonalizationService.getSafetyLimits(athlete);

    // Für 50+ längere Warmup
    final warmupDuration = age >= 50 ? const Duration(minutes: 10) : const Duration(minutes: 8);
    final cooldownDuration = HealthTrainingPersonalizationService.calculateCooldownDuration(age);

    // Work-Intensität: 60-70% max HR
    final workPercent = age < 50 ? 70 : 65;
    final workHr = ((workPercent / 100) * maxHr).round();

    // Recovery: 50-55% max HR
    final recoveryHr = ((50 / 100) * maxHr).round();

    final intervals = <WorkoutInterval>[
      // Extended Warmup
      WorkoutInterval(
        name: 'Warmup',
        duration: warmupDuration,
        type: IntervalType.warmup,
        powerTarget: PowerTarget.ftpPercent(50),
        targetHeartRate: ((50 / 100) * maxHr).round(),
        maxHeartRate: ((60 / 100) * maxHr).round(),
        instructions: 'Gründliches Aufwärmen, allmähliche Pulssteigerung',
      ),

      // 4× (Work + Recovery)
      for (int i = 1; i <= 4; i++) ...[
        WorkoutInterval(
          name: 'Work $i',
          duration: const Duration(minutes: 3),
          type: IntervalType.work,
          powerTarget: PowerTarget.ftpPercent(workPercent),
          targetHeartRate: workHr,
          maxHeartRate: safetyLimits.maxHrPercent,
          cadenceMin: 85,
          cadenceMax: 95,
          instructions: 'Moderate, stetige Intensität - noch können Sie sprechen',
          monitorRecovery: false,
        ),
        WorkoutInterval(
          name: 'Recovery $i',
          duration: const Duration(minutes: 3),
          type: IntervalType.rest,
          powerTarget: PowerTarget.ftpPercent(50),
          targetHeartRate: recoveryHr,
          maxHeartRate: ((60 / 100) * maxHr).round(),
          cadenceMin: 80,
          cadenceMax: 90,
          instructions: 'Aktive Erholung - Puls sollte fallen',
          monitorRecovery: true,
        ),
      ],

      // Cooldown
      WorkoutInterval(
        name: 'Cooldown',
        duration: cooldownDuration,
        type: IntervalType.cooldown,
        powerTarget: PowerTarget.ftpPercent(40),
        targetHeartRate: ((40 / 100) * maxHr).round(),
        maxHeartRate: ((50 / 100) * maxHr).round(),
        instructions: 'Langsam ausklingen, tiefe Atemzüge',
        monitorRecovery: true,
      ),
    ];

    return Workout(
      id: 'health_cardiac_rehab_${athlete.id}',
      name: 'Cardiac Rehab Intervals',
      description: 'Kardiovaskuläre Ausdauer nach AHA-Protokoll - besonders für 50+ Jahre',
      type: WorkoutType.interval,
      intervals: intervals,
      createdAt: DateTime.now(),
    );
  }

  /// Age-Optimized Endurance (45 min)
  ///
  /// Ziel: Personalisierte Grundlagenausdauer basierend auf Alter
  /// Struktur: Altersabhängiges Warmup + 20-30min Endurance @ Zone 2 (optional: Tempo Burst <50) + Cooldown
  /// Intensität: 60-75% max HR
  static Workout generateAgeOptimizedEndurance(AthleteProfile athlete) {
    final age = athlete.age ?? 45;
    final maxHr = athlete.maxHr ?? HealthTrainingPersonalizationService.calculateMaxHeartRate(age, gender: athlete.gender);
    final warmupDuration = HealthTrainingPersonalizationService.calculateWarmupDuration(age);
    final cooldownDuration = HealthTrainingPersonalizationService.calculateCooldownDuration(age);

    // Endurance-Dauer und Intensität je nach Alter
    final (enduranceDuration, endurancePercent) = switch (age) {
      < 40 => (const Duration(minutes: 25), 75),
      < 50 => (const Duration(minutes: 20), 70),
      < 60 => (const Duration(minutes: 20), 65),
      < 70 => (const Duration(minutes: 15), 60),
      _ => (const Duration(minutes: 15), 55),
    };

    final intervals = <WorkoutInterval>[
      // Warmup
      WorkoutInterval(
        name: 'Warmup',
        duration: warmupDuration,
        type: IntervalType.warmup,
        powerTarget: PowerTarget.ftpPercent(50),
        targetHeartRate: ((50 / 100) * maxHr).round(),
        maxHeartRate: ((60 / 100) * maxHr).round(),
        instructions: 'Allmählich einfahren',
      ),

      // Main Endurance
      WorkoutInterval(
        name: 'Endurance',
        duration: enduranceDuration,
        type: IntervalType.work,
        powerTarget: PowerTarget.ftpPercent(endurancePercent),
        targetHeartRate: ((endurancePercent / 100) * maxHr).round(),
        maxHeartRate: (((endurancePercent + 5) / 100) * maxHr).round(),
        cadenceMin: 85,
        cadenceMax: 95,
        instructions: 'Zone 2 Tempo - solltest noch mit jemandem sprechen können',
      ),

      // Optional: Tempo Burst für Jüngere (< 50)
      if (age < 50) ...[
        WorkoutInterval(
          name: 'Tempo Burst',
          duration: const Duration(minutes: 5),
          type: IntervalType.work,
          powerTarget: PowerTarget.ftpPercent(80),
          targetHeartRate: ((80 / 100) * maxHr).round(),
          maxHeartRate: ((85 / 100) * maxHr).round(),
          cadenceMin: 90,
          cadenceMax: 105,
          instructions: 'Leichte Steigerung - atmen aber nicht überanstrengen',
        ),
      ],

      // Cooldown
      WorkoutInterval(
        name: 'Cooldown',
        duration: cooldownDuration,
        type: IntervalType.cooldown,
        powerTarget: PowerTarget.ftpPercent(40),
        targetHeartRate: ((40 / 100) * maxHr).round(),
        maxHeartRate: ((50 / 100) * maxHr).round(),
        instructions: 'Locker ausklingen',
        monitorRecovery: true,
      ),
    ];

    return Workout(
      id: 'health_endurance_${athlete.id}',
      name: 'Age-Optimized Endurance',
      description: 'Personalisiertes Grundlagenausdauer-Training angepasst an dein Alter',
      type: WorkoutType.endurance,
      intervals: intervals,
      createdAt: DateTime.now(),
    );
  }

  /// Progressive Stress Test (30 min)
  ///
  /// Ziel: Leistungsbestimmung (wie FTP Test, aber für Herzfrequenz)
  /// Struktur: 10min Warmup + 5 Stufen à 3min (Modified Bruce Protocol) + Recovery Monitoring
  /// NUR für: Personen unter 60 Jahren
  static Workout? generateProgressiveStressTest(AthleteProfile athlete) {
    final age = athlete.age;

    // Nur für Personen unter 60 Jahren
    if (age == null || age >= 60) {
      return null;
    }

    final maxHr = athlete.maxHr ?? HealthTrainingPersonalizationService.calculateMaxHeartRate(age, gender: athlete.gender);
    final safetyLimits = HealthTrainingPersonalizationService.getSafetyLimits(athlete);

    final intervals = <WorkoutInterval>[
      // Thorough Warmup
      WorkoutInterval(
        name: 'Warmup',
        duration: const Duration(minutes: 10),
        type: IntervalType.warmup,
        powerTarget: PowerTarget.ftpPercent(50),
        targetHeartRate: ((50 / 100) * maxHr).round(),
        maxHeartRate: ((60 / 100) * maxHr).round(),
        instructions: 'Gründliches Aufwärmen vor Stresstest',
      ),

      // 5 progressive Stufen (Modified Bruce Protocol)
      for (int i = 1; i <= 5; i++) ...[
        WorkoutInterval(
          name: 'Stage $i',
          duration: const Duration(minutes: 3),
          type: IntervalType.work,
          powerTarget: PowerTarget.ftpPercent(60 + (i * 6)),
          targetHeartRate: (((60 + (i * 6)) / 100) * maxHr).round(),
          maxHeartRate: safetyLimits.maxHrPercent,
          cadenceMin: 85,
          cadenceMax: 95,
          instructions: 'Gleichmäßiger Leistungsanstieg - bereit zu stoppen wenn nötig',
          monitorRecovery: false,
        ),
      ],

      // Recovery Monitoring (10 min)
      WorkoutInterval(
        name: 'Cooldown & HR Recovery',
        duration: const Duration(minutes: 10),
        type: IntervalType.cooldown,
        powerTarget: PowerTarget.ftpPercent(40),
        targetHeartRate: ((40 / 100) * maxHr).round(),
        maxHeartRate: ((50 / 100) * maxHr).round(),
        instructions: 'Aktive Erholung - wichtig für Recovery-Index',
        monitorRecovery: true,
      ),
    ];

    return Workout(
      id: 'health_stress_test_${athlete.id}',
      name: 'Progressive Stress Test',
      description: 'Leistungsbestimmungs-Test mit progressiven Stufen nach Bruce-Protokoll',
      type: WorkoutType.ramp,
      intervals: intervals,
      createdAt: DateTime.now(),
    );
  }

  /// Recovery Capacity Check (25 min)
  ///
  /// Ziel: Bestimmung der Erholungsfähigkeit
  /// Struktur: 8min Warmup + 3× (2min Moderate / 2min Recovery) + 5min Cooldown
  /// Misst: HR Recovery Rate (sollte um 12-15 bpm pro Minute fallen)
  static Workout generateRecoveryCapacityCheck(AthleteProfile athlete) {
    final age = athlete.age ?? 45;
    final maxHr = athlete.maxHr ?? HealthTrainingPersonalizationService.calculateMaxHeartRate(age, gender: athlete.gender);

    final intervals = <WorkoutInterval>[
      // Warmup
      WorkoutInterval(
        name: 'Warmup',
        duration: const Duration(minutes: 8),
        type: IntervalType.warmup,
        powerTarget: PowerTarget.ftpPercent(50),
        targetHeartRate: ((50 / 100) * maxHr).round(),
        maxHeartRate: ((60 / 100) * maxHr).round(),
        instructions: 'Locker aufwärmen',
      ),

      // 3× (Moderate + Recovery mit HR Tracking)
      for (int i = 1; i <= 3; i++) ...[
        WorkoutInterval(
          name: 'Moderate $i',
          duration: const Duration(minutes: 2),
          type: IntervalType.work,
          powerTarget: PowerTarget.ftpPercent(70),
          targetHeartRate: ((70 / 100) * maxHr).round(),
          maxHeartRate: ((80 / 100) * maxHr).round(),
          cadenceMin: 85,
          cadenceMax: 95,
          instructions: 'Moderates Tempo',
          monitorRecovery: false,
        ),
        WorkoutInterval(
          name: 'Recovery $i',
          duration: const Duration(minutes: 2),
          type: IntervalType.rest,
          powerTarget: PowerTarget.ftpPercent(50),
          targetHeartRate: ((50 / 100) * maxHr).round(),
          maxHeartRate: ((60 / 100) * maxHr).round(),
          cadenceMin: 75,
          cadenceMax: 85,
          instructions: 'Aktive Erholung - beobachte deinen HR Rückgang',
          monitorRecovery: true,
        ),
      ],

      // Final Cooldown
      WorkoutInterval(
        name: 'Cooldown',
        duration: const Duration(minutes: 5),
        type: IntervalType.cooldown,
        powerTarget: PowerTarget.ftpPercent(40),
        targetHeartRate: ((40 / 100) * maxHr).round(),
        maxHeartRate: ((50 / 100) * maxHr).round(),
        instructions: 'Langsam ausklingen',
        monitorRecovery: true,
      ),
    ];

    return Workout(
      id: 'health_recovery_check_${athlete.id}',
      name: 'Recovery Capacity Check',
      description: 'Überprüfe deine Erholungsfähigkeit durch repeated moderate efforts',
      type: WorkoutType.interval,
      intervals: intervals,
      createdAt: DateTime.now(),
    );
  }

  /// Guten Morgen Training (10 min)
  ///
  /// Ziel: Sanfte Morgenaktivierung mit HR-Recovery-Bewertung
  /// Struktur: 2min Warmup + 3× (2min progressive Arbeit) + 2min Cooldown mit Recovery-Monitoring
  /// Intensität: Progressive Steigerung von 40% bis 70% FTP
  ///
  /// [intensityAdjustment] verschiebt die Basis-Intensität (z.B. +5 oder -5).
  /// Wird von der adaptiven Logik basierend auf vergangenen Recovery-Scores gesetzt.
  static Workout generateMorningWakeup(AthleteProfile athlete,
      {int intensityAdjustment = 0}) {
    final age = athlete.age ?? 45;
    final maxHr = athlete.maxHr ??
        HealthTrainingPersonalizationService.calculateMaxHeartRate(age,
            gender: athlete.gender);
    final adj = intensityAdjustment;

    final intervals = <WorkoutInterval>[
      // Kurzes Warmup (Morgens = steif)
      WorkoutInterval(
        name: 'Aufwachen',
        duration: const Duration(minutes: 2),
        type: IntervalType.warmup,
        powerTarget: PowerTarget.ftpPercent(40 + adj),
        targetHeartRate: ((45 / 100) * maxHr).round(),
        maxHeartRate: ((55 / 100) * maxHr).round(),
        instructions: 'Sanft starten, Körper aktivieren',
      ),

      // Progressive Aktivierung: 50% → 60% → 70% FTP
      WorkoutInterval(
        name: 'Leichte Aktivierung',
        duration: const Duration(minutes: 2),
        type: IntervalType.work,
        powerTarget: PowerTarget.ftpPercent(50 + adj),
        targetHeartRate: ((55 / 100) * maxHr).round(),
        maxHeartRate: ((60 / 100) * maxHr).round(),
        cadenceMin: 80,
        cadenceMax: 90,
        instructions: 'Sanft einrollen, lockeres Tempo',
      ),
      WorkoutInterval(
        name: 'Moderate Aktivierung',
        duration: const Duration(minutes: 2),
        type: IntervalType.work,
        powerTarget: PowerTarget.ftpPercent(60 + adj),
        targetHeartRate: ((65 / 100) * maxHr).round(),
        maxHeartRate: ((70 / 100) * maxHr).round(),
        cadenceMin: 80,
        cadenceMax: 90,
        instructions: 'Etwas mehr Druck, Körper wach machen',
      ),
      WorkoutInterval(
        name: 'Volle Aktivierung',
        duration: const Duration(minutes: 2),
        type: IntervalType.work,
        powerTarget: PowerTarget.ftpPercent(70 + adj),
        targetHeartRate: ((70 / 100) * maxHr).round(),
        maxHeartRate: ((78 / 100) * maxHr).round(),
        cadenceMin: 85,
        cadenceMax: 95,
        instructions: 'Richtig wach! Guter Druck auf dem Pedal',
      ),

      // Cooldown mit Recovery-Monitoring
      WorkoutInterval(
        name: 'Cooldown',
        duration: const Duration(minutes: 2),
        type: IntervalType.cooldown,
        powerTarget: PowerTarget.ftpPercent(35 + adj),
        targetHeartRate: ((40 / 100) * maxHr).round(),
        maxHeartRate: ((50 / 100) * maxHr).round(),
        instructions: 'Sanft ausklingen - HR-Recovery wird gemessen',
        monitorRecovery: true,
      ),
    ];

    return Workout(
      id: 'health_morning_wakeup_${athlete.id}',
      name: 'Guten Morgen Training',
      description:
          'Kurzes Morgen-Training (10 Min) mit progressiver Steigerung und HR-Recovery-Bewertung',
      type: WorkoutType.interval,
      intervals: intervals,
      createdAt: DateTime.now(),
    );
  }

  /// Berechnet die adaptive Intensitätsanpassung basierend auf vergangenen Recovery-Scores
  ///
  /// Rückgabewert: FTP-Prozent-Offset (z.B. +5, 0, -5)
  static int calculateAdaptiveAdjustment(List<int> recentScores) {
    if (recentScores.isEmpty) return 0;

    final avgScore =
        recentScores.reduce((a, b) => a + b) / recentScores.length;

    if (avgScore >= 75) return 5; // Gute Erholung → etwas härter
    if (avgScore < 50) return -5; // Schlechte Erholung → etwas leichter
    return 0; // Normal
  }

  /// Wählt das empfohlene Programm für einen Athleten
  ///
  /// Kriterien:
  /// - Anfänger (neu) → Baseline Assessment
  /// - 50+ Jahre → Cardiac Rehab (alternativ Endurance)
  /// - <60 Jahre und aktiv → Stress Test
  /// - Allgemein → Age-Optimized Endurance
  static Workout recommendProgram(AthleteProfile athlete, {List<Workout>? allPrograms}) {
    allPrograms ??= generateAllPrograms(athlete);
    final age = athlete.age ?? 45;

    // Junge und aktive: Stress Test (wenn verfügbar)
    if (age < 50 && athlete.ftp > 250) {
      return allPrograms.firstWhere(
        (p) => p.id.contains('stress_test'),
        orElse: () => allPrograms!.firstWhere((p) => p.id.contains('endurance')),
      );
    }

    // Ältere Athleten: Cardiac Rehab
    if (age >= 50) {
      return allPrograms.firstWhere((p) => p.id.contains('cardiac_rehab'));
    }

    // Allgemein: Age-Optimized Endurance
    return allPrograms.firstWhere((p) => p.id.contains('endurance'));
  }
}
