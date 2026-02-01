import '../../domain/entities/athlete_profile.dart';
import '../../domain/entities/health_training_program.dart';
import '../../domain/entities/workout.dart';

/// Generator für Multi-Activity Health Programs
/// Kombiniert Radfahren + Krafttraining in wissenschaftlich fundierten Wochenplänen
class MultiActivityProgramGenerator {
  /// Generiert einen 7-Tage Wochenplan für 50+ mit Radfahren und Krafttraining
  static List<HealthTrainingProgram> generateWeeklyProgram50Plus(
    AthleteProfile athlete,
  ) {
    final age = athlete.age ?? 55;

    return [
      // Montag: Ganzkörper Krafttraining
      HealthTrainingProgram(
        id: 'multi_mon_strength',
        name: 'Kraft Montag',
        description: 'Ganzkörper-Krafttraining mit Fokus auf Grundübungen. 2-3 × pro Woche optimal. Ruhezeiten: 90-120 Sekunden.',
        medicalBasis: 'American College of Sports Medicine (ACSM) Guidelines for 50+ Strength Training',
        type: WorkoutType.endurance,
        activityTypes: [HealthActivityType.strength],
        durationMinutes: 45,
        ageMinimum: 50,
        ageMaximum: null,
        requiresHrMonitor: false,
        difficultyLevel: 'Moderat',
        targetUser: '50+',
      ),

      // Dienstag: Ruhetag (später: Mobilität)
      HealthTrainingProgram(
        id: 'multi_tue_rest',
        name: 'Ruhetag',
        description: 'Aktive Erholung oder leichte Dehnung. Optional: Leichte Dehnungen oder Spaziergang.',
        medicalBasis: 'Recovery and Regeneration Best Practices',
        type: WorkoutType.endurance,
        activityTypes: [HealthActivityType.mobility],
        durationMinutes: 15,
        ageMinimum: 50,
        ageMaximum: null,
        requiresHrMonitor: false,
        difficultyLevel: 'Leicht',
        targetUser: '50+',
      ),

      // Mittwoch: Radfahren mit moderater Intensität
      HealthTrainingProgram(
        id: 'multi_wed_cycling',
        name: 'Radfahren Mittwoch',
        description: 'Kardiovaskuläres Training mit moderater Intensität. Zone 2-3 (gemütlich aber etwas Atmung). Herzgesund.',
        medicalBasis: 'American Heart Association Cardiac Rehabilitation Guidelines',
        type: WorkoutType.endurance,
        activityTypes: [HealthActivityType.cycling],
        durationMinutes: 40,
        ageMinimum: 50,
        ageMaximum: null,
        requiresHrMonitor: true,
        difficultyLevel: 'Moderat',
        targetUser: '50+',
      ),

      // Donnerstag: Ruhetag
      HealthTrainingProgram(
        id: 'multi_thu_rest',
        name: 'Ruhetag Donnerstag',
        description: 'Vollständiger Ruhetag oder leichte Aktivität nach Belieben.',
        medicalBasis: 'Recovery and Regeneration Best Practices',
        type: WorkoutType.endurance,
        activityTypes: [],
        durationMinutes: 0,
        ageMinimum: 50,
        ageMaximum: null,
        requiresHrMonitor: false,
        difficultyLevel: 'Leicht',
        targetUser: '50+',
      ),

      // Freitag: Ganzkörper Krafttraining (Wiederholung)
      HealthTrainingProgram(
        id: 'multi_fri_strength',
        name: 'Kraft Freitag',
        description: 'Ganzkörper-Krafttraining (2. Session der Woche). Ähnliche Übungen wie Montag. 72h Erholung zwischen Sätzen.',
        medicalBasis: 'ACSM Guidelines for Progressive Strength Training',
        type: WorkoutType.endurance,
        activityTypes: [HealthActivityType.strength],
        durationMinutes: 45,
        ageMinimum: 50,
        ageMaximum: null,
        requiresHrMonitor: false,
        difficultyLevel: 'Moderat',
        targetUser: '50+',
      ),

      // Samstag: Radfahren oder Spaziergang
      HealthTrainingProgram(
        id: 'multi_sat_active_recovery',
        name: 'Aktive Erholung Samstag',
        description: 'Leichte Aktivität: Spaziergang oder gemütliches Radfahren. Nach Lust und Laune.',
        medicalBasis: 'Active Recovery Best Practices',
        type: WorkoutType.endurance,
        activityTypes: [HealthActivityType.walking, HealthActivityType.cycling],
        durationMinutes: 30,
        ageMinimum: 50,
        ageMaximum: null,
        requiresHrMonitor: false,
        difficultyLevel: 'Leicht',
        targetUser: '50+',
      ),

      // Sonntag: Ruhetag
      HealthTrainingProgram(
        id: 'multi_sun_rest',
        name: 'Ruhetag Sonntag',
        description: 'Vollständiger Ruhetag für Erholung und Regeneration. Optimal für neuromuskuläre Regeneration.',
        medicalBasis: 'Recovery and Sleep Research',
        type: WorkoutType.endurance,
        activityTypes: [],
        durationMinutes: 0,
        ageMinimum: 50,
        ageMaximum: null,
        requiresHrMonitor: false,
        difficultyLevel: 'Leicht',
        targetUser: '50+',
      ),
    ];
  }

  /// Generiert Programme für jüngere Erwachsene (30-49)
  static List<HealthTrainingProgram> generateWeeklyProgramAdults(
    AthleteProfile athlete,
  ) {
    return [
      // Montag: Krafttraining (oberer Körper)
      HealthTrainingProgram(
        id: 'adult_mon_upper',
        name: 'Oberkörper Montag',
        description: 'Krafttraining für Brust, Rücken, Schultern. 60-90 Sekunden Ruhe zwischen Sätzen.',
        medicalBasis: 'ACSM Guidelines for Adult Strength Training',
        type: WorkoutType.endurance,
        activityTypes: [HealthActivityType.strength],
        durationMinutes: 50,
        ageMinimum: 30,
        ageMaximum: 49,
        requiresHrMonitor: false,
        difficultyLevel: 'Moderat',
        targetUser: '30-49',
      ),

      // Dienstag: Radfahren
      HealthTrainingProgram(
        id: 'adult_tue_cycling',
        name: 'Radfahren Dienstag',
        description: 'HIIT oder Steady State Radfahren. Zone 2-4 je nach Ziel (Ausdauer vs. Kraft).',
        medicalBasis: 'American Heart Association Cardio Guidelines',
        type: WorkoutType.endurance,
        activityTypes: [HealthActivityType.cycling],
        durationMinutes: 45,
        ageMinimum: 30,
        ageMaximum: 49,
        requiresHrMonitor: true,
        difficultyLevel: 'Moderat',
        targetUser: '30-49',
      ),

      // Mittwoch: Ruhetag
      HealthTrainingProgram(
        id: 'adult_wed_rest',
        name: 'Ruhetag Mittwoch',
        description: 'Aktive Erholung oder kompletter Ruhetag. Stretching oder leichte Mobilität.',
        medicalBasis: 'Recovery Best Practices',
        type: WorkoutType.endurance,
        activityTypes: [HealthActivityType.mobility],
        durationMinutes: 20,
        ageMinimum: 30,
        ageMaximum: 49,
        requiresHrMonitor: false,
        difficultyLevel: 'Leicht',
        targetUser: '30-49',
      ),

      // Donnerstag: Krafttraining (unterer Körper)
      HealthTrainingProgram(
        id: 'adult_thu_lower',
        name: 'Unterkörper Donnerstag',
        description: 'Krafttraining für Beine und Core. 60-90 Sekunden Ruhe zwischen Sätzen.',
        medicalBasis: 'ACSM Guidelines for Lower Body Training',
        type: WorkoutType.endurance,
        activityTypes: [HealthActivityType.strength],
        durationMinutes: 50,
        ageMinimum: 30,
        ageMaximum: 49,
        requiresHrMonitor: false,
        difficultyLevel: 'Moderat',
        targetUser: '30-49',
      ),

      // Freitag: Radfahren
      HealthTrainingProgram(
        id: 'adult_fri_cycling',
        name: 'Radfahren Freitag',
        description: 'Zügiges Radfahren oder Sprintsession. Zone 4-5 für Power und Leistung.',
        medicalBasis: 'High Intensity Interval Training Guidelines',
        type: WorkoutType.endurance,
        activityTypes: [HealthActivityType.cycling],
        durationMinutes: 45,
        ageMinimum: 30,
        ageMaximum: 49,
        requiresHrMonitor: true,
        difficultyLevel: 'Anspruchsvoll',
        targetUser: '30-49',
      ),

      // Samstag: Lange Aktivität
      HealthTrainingProgram(
        id: 'adult_sat_long',
        name: 'Lange Aktivität Samstag',
        description: 'Langes Radfahren, Wandern oder leichte Aktivität. Zone 1-2: Gemütlich und nachhaltig.',
        medicalBasis: 'Long Slow Distance Training',
        type: WorkoutType.endurance,
        activityTypes: [HealthActivityType.cycling, HealthActivityType.walking],
        durationMinutes: 60,
        ageMinimum: 30,
        ageMaximum: 49,
        requiresHrMonitor: false,
        difficultyLevel: 'Leicht',
        targetUser: '30-49',
      ),

      // Sonntag: Ruhetag
      HealthTrainingProgram(
        id: 'adult_sun_rest',
        name: 'Ruhetag Sonntag',
        description: 'Vollständiger Ruhetag oder sehr leichte Aktivität.',
        medicalBasis: 'Recovery and Sleep Research',
        type: WorkoutType.endurance,
        activityTypes: [],
        durationMinutes: 0,
        ageMinimum: 30,
        ageMaximum: 49,
        requiresHrMonitor: false,
        difficultyLevel: 'Leicht',
        targetUser: '30-49',
      ),
    ];
  }

  /// Wählt das beste Programm basierend auf Alter und Profil
  static List<HealthTrainingProgram> generateRecommendedProgram(
    AthleteProfile athlete,
  ) {
    final age = athlete.age ?? 50;

    if (age >= 50) {
      return generateWeeklyProgram50Plus(athlete);
    } else if (age >= 30) {
      return generateWeeklyProgramAdults(athlete);
    } else {
      // Für jüngere: Flexibles Programm
      return generateWeeklyProgramAdults(athlete);
    }
  }

  /// Berechnet empfohlene tägliche Aktivität basierend auf Programm
  static String getDailyRecommendation(
    List<HealthTrainingProgram> weeklyProgram,
    int dayOfWeek, // 0 = Monday, 6 = Sunday
  ) {
    if (dayOfWeek < 0 || dayOfWeek >= weeklyProgram.length) {
      return 'Keine Aktivität geplant';
    }

    final program = weeklyProgram[dayOfWeek];
    if (program.activityTypes.isEmpty) {
      return 'Ruhetag - Fokus auf Erholung und Regeneration';
    }

    final activities = program.activityTypes.map((type) {
      return switch (type) {
        HealthActivityType.cycling => 'Radfahren',
        HealthActivityType.strength => 'Krafttraining',
        HealthActivityType.mobility => 'Mobilität/Dehnung',
        HealthActivityType.walking => 'Spaziergang',
      };
    }).join(' + ');

    return '$activities - ${program.durationMinutes} Minuten';
  }
}
