import 'package:kickr_trainer/domain/entities/strength_exercise.dart';
import 'package:kickr_trainer/domain/entities/strength_workout.dart';

/// Service zum Generieren von evidenzbasierten Kraft-Trainingsprogrammen
class StrengthProgramGenerator {
  /// Generiert ein Anfänger-Ganzkörperprogramm für 50+ Jahre
  ///
  /// Basierend auf Evidence-Based Guidelines:
  /// - 2-3× pro Woche (Frequenz)
  /// - Compound Movements (Squat, Push, Pull, Hinge, Core)
  /// - 8-12 Wiederholungen (Hypertrophy + Strength)
  /// - 2-3 Sätze pro Übung
  /// - 90-120s Rest zwischen Sätzen
  static StrengthWorkout generateBeginnerFullBody({
    required int age,
    required EquipmentType equipment,
  }) {
    // Übungen basierend auf Equipment wählen
    final exercises = _selectExercisesForEquipment(equipment, age);

    // Anfänger-freundliche Intervalle
    final intervals = [
      // 1. Bodyweight Squat or Goblet Squat
      StrengthInterval(
        exerciseId: exercises[0],
        sets: 3,
        repsTarget: 10,
        repsMin: 10,
        repsMax: 12,
        loadTarget: equipment == EquipmentType.bodyweight
            ? LoadTarget.bodyweight(variation: 'standard')
            : LoadTarget.weight(12.0), // Goblet squat 12kg
        restBetweenSets: const Duration(seconds: 90),
        tempo: '2-1-2',
        instructions: 'Controlled movement, sit back into hips',
      ),
      // 2. Push-up (modified for 50+)
      StrengthInterval(
        exerciseId: exercises[1],
        sets: 3,
        repsTarget: 8,
        repsMin: 8,
        repsMax: 10,
        loadTarget: equipment == EquipmentType.bodyweight
            ? LoadTarget.bodyweight(variation: 'incline')
            : LoadTarget.weight(0), // Wall or incline push-up
        restBetweenSets: const Duration(seconds: 90),
        tempo: '2-1-2',
        instructions: 'Full range of motion, keep core tight',
      ),
      // 3. Dumbbell Row or Resistance Band Row
      StrengthInterval(
        exerciseId: exercises[2],
        sets: 3,
        repsTarget: 10,
        repsMin: 10,
        repsMax: 12,
        loadTarget: equipment == EquipmentType.dumbbells
            ? LoadTarget.weight(8.0) // 8kg dumbbells
            : LoadTarget.weight(0),
        restBetweenSets: const Duration(seconds: 90),
        tempo: '2-1-2',
        instructions: 'Pull elbows back, squeeze shoulder blades',
      ),
      // 4. Glute Bridge
      StrengthInterval(
        exerciseId: exercises[3],
        sets: 3,
        repsTarget: 12,
        repsMin: 12,
        repsMax: 15,
        loadTarget: LoadTarget.bodyweight(variation: 'standard'),
        restBetweenSets: const Duration(seconds: 60),
        tempo: '2-1-2',
        instructions: 'Squeeze glutes at top, controlled descent',
      ),
      // 5. Plank
      StrengthInterval(
        exerciseId: exercises[4],
        sets: 2,
        repsTarget: 30, // Duration in seconds as reps
        repsMin: 30,
        repsMax: 60,
        loadTarget: LoadTarget.bodyweight(variation: 'standard'),
        restBetweenSets: const Duration(seconds: 60),
        tempo: null,
        instructions: 'Straight line from head to heels, breathe steadily',
      ),
    ];

    return StrengthWorkout(
      id: 'workout_beginner_fullbody_${equipment.name}',
      name: 'Anfänger Ganzkörper',
      description:
          'Wissenschaftlich fundiertes Ganzkörperprogramm für 50+. Schwerpunkt auf sichere, effektive Compound Movements.',
      intervals: intervals,
      type: WorkoutType.fullBody,
      estimatedDurationMinutes: 45,
      difficulty: DifficultyLevel.beginner,
      isCustom: false,
      createdAt: DateTime.now(),
    );
  }

  /// Generiert ein wöchentliches Programm für 50+ (2x Kraft + 1x Mobility)
  static List<StrengthWorkout> generateWeeklyProgram50Plus({
    required int age,
    required EquipmentType equipment,
  }) {
    final mondayWorkout = generateBeginnerFullBody(age: age, equipment: equipment);

    // Freitag-Workout: Variation des Montags
    final fridayWorkout = mondayWorkout.copyWith(
      id: 'workout_beginner_fullbody_variation_${equipment.name}',
      name: 'Kraft Freitag (Variation)',
      description:
          'Variation des Montags-Workouts mit ähnlichen Übungen aber angepassten Gewichten.',
    );

    return [mondayWorkout, fridayWorkout];
  }

  /// Generiert progressive Programme basierend auf Erfahrung
  static List<StrengthWorkout> generateProgressiveProgram({
    required int age,
    required DifficultyLevel currentLevel,
    required EquipmentType equipment,
  }) {
    if (currentLevel == DifficultyLevel.beginner) {
      return generateWeeklyProgram50Plus(age: age, equipment: equipment);
    }

    // Intermediate Program (zukünftige Phase)
    // Fortgeschrittenes Programm mit Push/Pull/Legs
    return generateWeeklyProgram50Plus(age: age, equipment: equipment);
  }

  /// Wählt Übungen basierend auf verfügbarem Equipment
  static List<String> _selectExercisesForEquipment(
    EquipmentType equipment,
    int age,
  ) {
    switch (equipment) {
      case EquipmentType.bodyweight:
        return [
          'ex_bodyweight_squat',
          'ex_pushup',
          'ex_bodyweight_row',
          'ex_glute_bridge',
          'ex_plank',
        ];
      case EquipmentType.dumbbells:
        return [
          'ex_goblet_squat',
          'ex_dumbbell_chest_press',
          'ex_dumbbell_row',
          'ex_glute_bridge',
          'ex_plank',
        ];
      case EquipmentType.barbell:
        return [
          'ex_barbell_squat',
          'ex_barbell_bench_press',
          'ex_barbell_row',
          'ex_glute_bridge',
          'ex_plank',
        ];
      case EquipmentType.kettlebell:
        return [
          'ex_kettlebell_goblet_squat',
          'ex_kettlebell_press',
          'ex_kettlebell_row',
          'ex_glute_bridge',
          'ex_plank',
        ];
      case EquipmentType.resistanceBand:
        return [
          'ex_band_squat',
          'ex_band_chest_press',
          'ex_band_row',
          'ex_glute_bridge',
          'ex_plank',
        ];
      case EquipmentType.none:
        return [
          'ex_bodyweight_squat',
          'ex_pushup',
          'ex_bodyweight_row',
          'ex_glute_bridge',
          'ex_plank',
        ];
    }
  }

  /// Empfiehlt Modifikationen basierend auf Alter
  static String getModificationNotes(int age) {
    if (age < 50) {
      return 'Standard Programming. Focus on progressive overload.';
    } else if (age < 60) {
      return 'Age 50-60: Längere Warm-ups (5-10min), normale Bewegungsgeschwindigkeit, 90-120s Rest.';
    } else if (age < 70) {
      return 'Age 60-70: Sehr lange Warm-ups (10-15min), reduzierte Bewegungsgeschwindigkeit, incline variationen, balance training.';
    } else {
      return 'Age 70+: Chair-assisted, very slow tempo (3-2-3), fokus auf functionality, balance und stabilität.';
    }
  }
}
