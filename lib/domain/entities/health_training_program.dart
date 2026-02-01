import 'package:equatable/equatable.dart';
import 'workout.dart';

/// Aktivitätstypen für Health Training (vorbereitet für zukünftige Multi-Activity)
enum HealthActivityType {
  cycling,        // ✅ Jetzt implementiert
  strength,       // Später: Krafttraining
  mobility,       // Später: Stretching, Yoga
  walking,        // Später: Schritte-Tracking
}

extension HealthActivityTypeExtension on HealthActivityType {
  String get label {
    switch (this) {
      case HealthActivityType.cycling:
        return 'Fahrrad';
      case HealthActivityType.strength:
        return 'Krafttraining';
      case HealthActivityType.mobility:
        return 'Beweglichkeit';
      case HealthActivityType.walking:
        return 'Spaziergang';
    }
  }

  String get description {
    switch (this) {
      case HealthActivityType.cycling:
        return 'Indoor Cycling Training';
      case HealthActivityType.strength:
        return 'Kraft- und Widerstandstraining';
      case HealthActivityType.mobility:
        return 'Dehnungs- und Beweglichkeitstraining';
      case HealthActivityType.walking:
        return 'Aktive Bewegung und Spaziergang';
    }
  }
}

/// Health Training Programm Template
class HealthTrainingProgram extends Equatable {
  final String id;
  final String name;
  final String description;
  final String medicalBasis; // Wissenschaftliche Grundlage (z.B. "Bruce Protocol", "Cardiac Rehab AHA")
  final WorkoutType type; // warmup, work, rest, cooldown
  final List<HealthActivityType> activityTypes; // Zukünftig: [cycling], später [cycling, strength]
  final int durationMinutes; // Geschätzte Gesamtdauer
  final int ageMinimum; // Mindestempfohlenes Alter
  final int? ageMaximum; // Maximalempfohlenes Alter (null = keine Obergrenze)
  final bool requiresHrMonitor; // HR Monitor erforderlich?
  final String? difficultyLevel; // "Leicht", "Moderat", "Anspruchsvoll"
  final String? targetUser; // z.B. "50+", "Anfänger", "Senioren"

  const HealthTrainingProgram({
    required this.id,
    required this.name,
    required this.description,
    required this.medicalBasis,
    required this.type,
    required this.activityTypes,
    required this.durationMinutes,
    required this.ageMinimum,
    this.ageMaximum,
    required this.requiresHrMonitor,
    this.difficultyLevel,
    this.targetUser,
  });

  /// Prüft, ob das Programm für einen bestimmten Age geeignet ist
  bool isAppropriorateForAge(int age) {
    if (age < ageMinimum) return false;
    if (ageMaximum != null && age > ageMaximum!) return false;
    return true;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        medicalBasis,
        type,
        activityTypes,
        durationMinutes,
        ageMinimum,
        ageMaximum,
        requiresHrMonitor,
        difficultyLevel,
        targetUser,
      ];
}
