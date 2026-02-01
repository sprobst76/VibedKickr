import 'package:kickr_trainer/domain/entities/strength_exercise.dart';

/// Seed data für Krafttraining-Übungen
/// 15+ wissenschaftlich validierte Übungen für 40-70 Altersgruppe
class StrengthExerciseSeedData {
  static List<StrengthExercise> get defaultExercises => [
        // ============================================
        // CORE COMPOUND MOVEMENTS (Priority 1)
        // ============================================

        /// Bodyweight Squat - fundamental lower body exercise
        StrengthExercise(
          id: 'ex_bodyweight_squat',
          name: 'Bodyweight Squat',
          description:
              'Fundamental lower body exercise for leg strength and mobility. Foundation for all lower body work.',
          primaryMuscles: [MuscleGroup.legs],
          secondaryMuscles: [MuscleGroup.core],
          equipment: EquipmentType.bodyweight,
          formCues:
              'Feet shoulder-width apart, toes slightly out. Keep chest up and core tight. Sit back into hips as if sitting in a chair. Knees track over toes. Push through heels to stand. Full depth: knees below parallel.',
          difficulty: DifficultyLevel.beginner,
          isCompound: true,
          minimumAge: 18,
          requiresModification50Plus: true,
          modification50PlusNotes:
              'For those with limited mobility: Use chair for support behind you. Reduce depth to 90-degree knee bend. Focus on controlled movement over range. Can hold chair or wall for balance. Widen stance if needed.',
          videoUrl: null,
        ),

        /// Goblet Squat - dumbbell squat variation
        StrengthExercise(
          id: 'ex_goblet_squat',
          name: 'Goblet Squat',
          description:
              'Dumbbell squat variation. Easier to learn than barbell squat. Better positioning for posterior chain activation.',
          primaryMuscles: [MuscleGroup.legs],
          secondaryMuscles: [MuscleGroup.core, MuscleGroup.back],
          equipment: EquipmentType.dumbbells,
          formCues:
              'Hold one dumbbell vertically at chest height. Feet shoulder-width apart. Squat down, maintaining upright torso. Keep dumbbell at chest level throughout. Knees track over toes. Drive through heels to stand.',
          difficulty: DifficultyLevel.beginner,
          isCompound: true,
          minimumAge: 18,
          requiresModification50Plus: true,
          modification50PlusNotes:
              'Start with light dumbbell (5-8kg). Use box or bench behind you for confidence. Reduce depth initially. Can hold bench for balance with free hand. Focus on achieving full depth with light load.',
          videoUrl: null,
        ),

        /// Push-up - upper body pressing movement
        StrengthExercise(
          id: 'ex_pushup',
          name: 'Push-up',
          description:
              'Upper body pressing movement. Targets chest, shoulders, triceps. Fundamental bodyweight exercise.',
          primaryMuscles: [MuscleGroup.chest],
          secondaryMuscles: [MuscleGroup.shoulders, MuscleGroup.arms, MuscleGroup.core],
          equipment: EquipmentType.bodyweight,
          formCues:
              'Hands shoulder-width apart. Body forms straight line from head to heels. Lower until chest nearly touches ground. Elbows 45 degrees from body. Push through palms to return to start. Keep core tight.',
          difficulty: DifficultyLevel.beginner,
          isCompound: true,
          minimumAge: 18,
          requiresModification50Plus: true,
          modification50PlusNotes:
              'Incline push-up: Hands on elevated surface (bench, box, wall). Wall push-up: Perform standing against wall. Knee push-up: Knees on ground, full body from knees to head. Progress gradually to full push-ups.',
          videoUrl: null,
        ),

        /// Dumbbell Row - upper body pulling movement
        StrengthExercise(
          id: 'ex_dumbbell_row',
          name: 'Dumbbell Row',
          description:
              'Upper body pulling movement. Single-arm variation. Improves back strength and unilateral stability.',
          primaryMuscles: [MuscleGroup.back],
          secondaryMuscles: [MuscleGroup.arms, MuscleGroup.core],
          equipment: EquipmentType.dumbbells,
          formCues:
              'Place one knee on bench or ground. Torso nearly parallel to ground. Row dumbbell to hip, squeezing shoulder blade. Elbow 45 degrees from body. Lower with control. Repeat on both sides.',
          difficulty: DifficultyLevel.beginner,
          isCompound: true,
          minimumAge: 18,
          requiresModification50Plus: false,
          modification50PlusNotes:
              'Start with light weight. Ensure full range of motion. Can perform standing if balance is good. Avoid rotating torso excessively.',
          videoUrl: null,
        ),

        /// Glute Bridge - posterior chain activation
        StrengthExercise(
          id: 'ex_glute_bridge',
          name: 'Glute Bridge',
          description:
              'Posterior chain activation. Strengthens glutes and lower back. Excellent for countering sitting posture.',
          primaryMuscles: [MuscleGroup.legs],
          secondaryMuscles: [MuscleGroup.core],
          equipment: EquipmentType.bodyweight,
          formCues:
              'Lie on back, knees bent, feet flat. Feet shoulder-width apart. Drive through heels to lift hips. Squeeze glutes at top. Pause 1-2 seconds. Lower with control. Full range: hips parallel to knees.',
          difficulty: DifficultyLevel.beginner,
          isCompound: true,
          minimumAge: 18,
          requiresModification50Plus: false,
          modification50PlusNotes:
              'Excellent for all ages. Can place hands across chest or beside body. Increase difficulty: single-leg glute bridge, weighted glute bridge with barbell.',
          videoUrl: null,
        ),

        /// Plank - core stabilization
        StrengthExercise(
          id: 'ex_plank',
          name: 'Plank',
          description:
              'Core stabilization exercise. Engages entire core. Fundamental for strength and stability.',
          primaryMuscles: [MuscleGroup.core],
          secondaryMuscles: [MuscleGroup.shoulders],
          equipment: EquipmentType.bodyweight,
          formCues:
              'Forearm plank: Forearms on ground, elbows under shoulders. Straight line from head to heels. Engage core, glutes. Do not let hips sag. Breathe steadily. High plank: Hands on ground, arms straight.',
          difficulty: DifficultyLevel.beginner,
          isCompound: false,
          minimumAge: 18,
          requiresModification50Plus: true,
          modification50PlusNotes:
              'Start with forearm plank. Can perform on knees initially. Duration goal: 30-60 seconds. Focus on quality over duration. Ensure no sagging hips.',
          videoUrl: null,
        ),

        // ============================================
        // LOWER BODY ACCESSORY (Priority 1.5)
        // ============================================

        /// Walking Lunge - unilateral leg strength
        StrengthExercise(
          id: 'ex_walking_lunge',
          name: 'Walking Lunge',
          description:
              'Unilateral leg strength exercise. Improves balance and stability. Targets quads, glutes.',
          primaryMuscles: [MuscleGroup.legs],
          secondaryMuscles: [MuscleGroup.core],
          equipment: EquipmentType.bodyweight,
          formCues:
              'Stand upright. Step forward with one leg. Lower body until back knee nearly touches ground. Front knee at 90 degrees. Push through front heel to return. Step forward with opposite leg. Maintain upright posture.',
          difficulty: DifficultyLevel.beginner,
          isCompound: true,
          minimumAge: 18,
          requiresModification50Plus: true,
          modification50PlusNotes:
              'Reduce range of motion initially. Can hold onto chair or wall. Static lunge: Stand in lunge position without walking. Ensure front knee does not go past toes.',
          videoUrl: null,
        ),

        /// Calf Raise - lower leg strength
        StrengthExercise(
          id: 'ex_calf_raise',
          name: 'Calf Raise',
          description:
              'Lower leg strength. Targets calf muscles. Important for ankle stability and balance.',
          primaryMuscles: [MuscleGroup.legs],
          secondaryMuscles: [],
          equipment: EquipmentType.bodyweight,
          formCues:
              'Stand with feet hip-width apart. Rise up onto toes. Pause at top. Lower with control. Full range: ankles fully plantarflex at top, feet flat at bottom. Can hold chair for balance.',
          difficulty: DifficultyLevel.beginner,
          isCompound: false,
          minimumAge: 18,
          requiresModification50Plus: false,
          modification50PlusNotes:
              'Always available. Can hold chair for balance. Excellent for proprioception and ankle stability.',
          videoUrl: null,
        ),

        /// Step-up - unilateral leg strength
        StrengthExercise(
          id: 'ex_stepup',
          name: 'Step-up',
          description:
              'Unilateral leg strength. Mimics stair climbing. Functional exercise for daily life.',
          primaryMuscles: [MuscleGroup.legs],
          secondaryMuscles: [MuscleGroup.core],
          equipment: EquipmentType.bodyweight,
          formCues:
              'Stand facing a bench or step (knee height or lower). Step up with one leg. Drive through heel. Bring other leg to top. Step down. Repeat on same leg for all reps, then switch. Maintain upright posture.',
          difficulty: DifficultyLevel.beginner,
          isCompound: true,
          minimumAge: 18,
          requiresModification50Plus: true,
          modification50PlusNotes:
              'Start with lower step height (6-8 inches). Can hold onto chair or wall. Increase height gradually as strength improves.',
          videoUrl: null,
        ),

        // ============================================
        // UPPER BODY ACCESSORY (Priority 2)
        // ============================================

        /// Dumbbell Bench Press - upper body pressing
        StrengthExercise(
          id: 'ex_dumbbell_bench_press',
          name: 'Dumbbell Bench Press',
          description:
              'Upper body pressing movement. Targets chest, shoulders, triceps. More stable than barbell.',
          primaryMuscles: [MuscleGroup.chest],
          secondaryMuscles: [MuscleGroup.shoulders, MuscleGroup.arms],
          equipment: EquipmentType.dumbbells,
          formCues:
              'Lie on bench. Dumbbells at shoulder height, elbows 45 degrees. Press dumbbells up. Dumbbells nearly touch at top. Lower with control. Full range: dumbbells shoulder height at bottom.',
          difficulty: DifficultyLevel.beginner,
          isCompound: true,
          minimumAge: 18,
          requiresModification50Plus: true,
          modification50PlusNotes:
              'Start with light dumbbells. Can perform on ground without bench. Reduce range of motion if shoulder mobility is limited. Excellent pressing foundation.',
          videoUrl: null,
        ),

        /// Bicep Curl - arm flexion
        StrengthExercise(
          id: 'ex_bicep_curl',
          name: 'Dumbbell Bicep Curl',
          description:
              'Arm flexion. Targets biceps. Simple isolation exercise for arm strength.',
          primaryMuscles: [MuscleGroup.arms],
          secondaryMuscles: [],
          equipment: EquipmentType.dumbbells,
          formCues:
              'Stand upright, dumbbells at sides. Curl dumbbells up towards shoulders. Elbows stay at sides. Lower with control. Full range: full extension at bottom, full flexion at top. Avoid swinging weight.',
          difficulty: DifficultyLevel.beginner,
          isCompound: false,
          minimumAge: 18,
          requiresModification50Plus: false,
          modification50PlusNotes:
              'Simple and safe exercise. Suitable for all ages. Good for maintaining arm strength.',
          videoUrl: null,
        ),

        /// Tricep Extension - arm extension
        StrengthExercise(
          id: 'ex_tricep_extension',
          name: 'Dumbbell Tricep Extension',
          description:
              'Arm extension. Targets triceps. Common accessory for upper body strength.',
          primaryMuscles: [MuscleGroup.arms],
          secondaryMuscles: [],
          equipment: EquipmentType.dumbbells,
          formCues:
              'Stand upright, one dumbbell overhead held with both hands. Bend elbows to lower weight behind head. Extend elbows to press weight up. Elbows stay close to head. Avoid flaring elbows.',
          difficulty: DifficultyLevel.beginner,
          isCompound: false,
          minimumAge: 18,
          requiresModification50Plus: false,
          modification50PlusNotes:
              'Good exercise for all ages. Can perform seated if balance is concern. Light weight recommended.',
          videoUrl: null,
        ),

        /// Lateral Raise - shoulder abduction
        StrengthExercise(
          id: 'ex_lateral_raise',
          name: 'Dumbbell Lateral Raise',
          description:
              'Shoulder abduction. Targets lateral shoulders (deltoids). Improves shoulder width and stability.',
          primaryMuscles: [MuscleGroup.shoulders],
          secondaryMuscles: [],
          equipment: EquipmentType.dumbbells,
          formCues:
              'Stand with feet shoulder-width. Dumbbells at sides. Raise arms out to sides, elbows slightly bent. Stop at shoulder height. Lower with control. Thumbs lead motion up, pinkies lead down.',
          difficulty: DifficultyLevel.beginner,
          isCompound: false,
          minimumAge: 18,
          requiresModification50Plus: false,
          modification50PlusNotes:
              'Use light weight. Good for shoulder health and stability. Avoid shoulder impingement by not raising above shoulder height.',
          videoUrl: null,
        ),

        // ============================================
        // CORE & STABILITY (Priority 2.5)
        // ============================================

        /// Bird Dog - core and stability
        StrengthExercise(
          id: 'ex_bird_dog',
          name: 'Bird Dog',
          description:
              'Core stabilization and balance. Targets core, lower back. Improves coordination.',
          primaryMuscles: [MuscleGroup.core],
          secondaryMuscles: [MuscleGroup.back],
          equipment: EquipmentType.bodyweight,
          formCues:
              'Hands and knees position. Extend opposite arm and leg. Maintain neutral spine. Return to start. Alternate sides. Move slowly and deliberately. Keep hips level.',
          difficulty: DifficultyLevel.beginner,
          isCompound: false,
          minimumAge: 18,
          requiresModification50Plus: false,
          modification50PlusNotes:
              'Excellent for all ages. Improves balance and coordination. Great for lower back health.',
          videoUrl: null,
        ),

        /// Wall Sit - isometric leg strength
        StrengthExercise(
          id: 'ex_wall_sit',
          name: 'Wall Sit',
          description:
              'Isometric leg strength. Targets quads. Excellent for building endurance.',
          primaryMuscles: [MuscleGroup.legs],
          secondaryMuscles: [MuscleGroup.core],
          equipment: EquipmentType.bodyweight,
          formCues:
              'Stand with back against wall. Feet hip-width apart, about 2 feet from wall. Slide down until knees at 90 degrees. Thighs parallel to ground. Hold position. Keep back against wall. Weight in heels.',
          difficulty: DifficultyLevel.beginner,
          isCompound: false,
          minimumAge: 18,
          requiresModification50Plus: true,
          modification50PlusNotes:
              'Start with partial depth (120 degrees). Build duration gradually. Can place hands on thighs for support. Excellent for quad strength and endurance.',
          videoUrl: null,
        ),

        /// Dead Bug - core safety
        StrengthExercise(
          id: 'ex_dead_bug',
          name: 'Dead Bug',
          description:
              'Core stabilization with safe spine positioning. Excellent progression to more advanced core work.',
          primaryMuscles: [MuscleGroup.core],
          secondaryMuscles: [],
          equipment: EquipmentType.bodyweight,
          formCues:
              'Lie on back. Hips and knees at 90 degrees. Arms extended to ceiling. Slowly extend opposite arm and leg. Return to start. Alternate sides. Move deliberately. Keep lower back pressed to floor.',
          difficulty: DifficultyLevel.beginner,
          isCompound: false,
          minimumAge: 18,
          requiresModification50Plus: false,
          modification50PlusNotes:
              'Very safe core exercise. Excellent for learning core engagement. Good foundation for advanced core work.',
          videoUrl: null,
        ),

        /// Leg Raise - advanced core
        StrengthExercise(
          id: 'ex_leg_raise',
          name: 'Leg Raise',
          description:
              'Advanced core exercise. Targets lower abdominals. Requires significant core strength.',
          primaryMuscles: [MuscleGroup.core],
          secondaryMuscles: [MuscleGroup.legs],
          equipment: EquipmentType.bodyweight,
          formCues:
              'Lie on back, hands at sides or behind head. Raise legs to 90 degrees. Lower legs without touching ground. Maintain lower back contact with floor. Move slowly and deliberately.',
          difficulty: DifficultyLevel.intermediate,
          isCompound: false,
          minimumAge: 30,
          requiresModification50Plus: true,
          modification50PlusNotes:
              'Advanced exercise. Start with bent knee leg raises. Increase difficulty gradually. Ensure lower back stays on floor. Not recommended for those with lower back issues.',
          videoUrl: null,
        ),

        // ============================================
        // BALANCE & STABILITY (Priority 3)
        // ============================================

        /// Single-Leg Stand - balance and proprioception
        StrengthExercise(
          id: 'ex_single_leg_stand',
          name: 'Single-Leg Stand',
          description:
              'Balance and proprioception. Targets stabilizer muscles. Excellent for fall prevention.',
          primaryMuscles: [MuscleGroup.legs],
          secondaryMuscles: [MuscleGroup.core],
          equipment: EquipmentType.bodyweight,
          formCues:
              'Stand on one leg. Other leg lifted to hip height. Maintain balance. Keep core engaged. Can hold onto chair or wall for support. Eyes forward, not down. Try to minimize upper body movement.',
          difficulty: DifficultyLevel.beginner,
          isCompound: false,
          minimumAge: 18,
          requiresModification50Plus: false,
          modification50PlusNotes:
              'Essential for older adults. Excellent for fall prevention. Always have something to hold onto. Build duration gradually.',
          videoUrl: null,
        ),

        /// Tandem Walk - balance progression
        StrengthExercise(
          id: 'ex_tandem_walk',
          name: 'Tandem Walk',
          description:
              'Balance progression. Walking in straight line heel-to-toe. Functional balance training.',
          primaryMuscles: [MuscleGroup.legs],
          secondaryMuscles: [MuscleGroup.core],
          equipment: EquipmentType.bodyweight,
          formCues:
              'Walk forward placing heel of one foot directly in front of toes of other foot. Maintain straight line. Arms out to sides for balance. Can hold onto wall or rail. Move slowly.',
          difficulty: DifficultyLevel.beginner,
          isCompound: false,
          minimumAge: 18,
          requiresModification50Plus: false,
          modification50PlusNotes:
              'Important for balance and proprioception. Can perform along wall. Excellent for 50+ group.',
          videoUrl: null,
        ),
      ];

  /// Lädt Standard-Übungen in die Datenbank
  /// Wird beim ersten App-Start aufgerufen
  static Future<void> seedDefaultExercises(
    dynamic Function(StrengthExercise) insertFunction,
  ) async {
    for (final exercise in defaultExercises) {
      await insertFunction(exercise);
    }
  }
}
