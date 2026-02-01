import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/strength_exercise.dart';

/// Card-Widget für eine Trainingsübung
/// Zeigt Übungsname, Muskelgruppen, Ausrüstung und Schwierigkeitsgrad
class ExerciseCard extends StatelessWidget {
  final StrengthExercise exercise;
  final VoidCallback? onTap;

  const ExerciseCard({
    required this.exercise,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.surfaceLight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Name & Compound Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      exercise.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (exercise.isCompound)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Compound',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Muscle Groups
              Wrap(
                spacing: 6,
                children: exercise.primaryMuscles.map((muscle) {
                  return _MuscleGroupChip(muscleGroup: muscle);
                }).toList(),
              ),
              const SizedBox(height: 8),

              // Equipment & Difficulty Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Equipment
                  Flexible(
                    child: Row(
                      children: [
                        Icon(
                          _getEquipmentIcon(exercise.equipment),
                          size: 16,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getEquipmentName(exercise.equipment),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Difficulty
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(exercise.difficulty).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _getDifficultyName(exercise.difficulty),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: _getDifficultyColor(exercise.difficulty),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getEquipmentIcon(EquipmentType equipment) {
    return switch (equipment) {
      EquipmentType.bodyweight => Icons.person,
      EquipmentType.dumbbells => Icons.fitness_center,
      EquipmentType.barbell => Icons.sports_bar,
      EquipmentType.kettlebell => Icons.fitness_center,
      EquipmentType.resistanceBand => Icons.auto_fix_normal,
      EquipmentType.none => Icons.check_circle_outline,
    };
  }

  String _getEquipmentName(EquipmentType equipment) {
    return switch (equipment) {
      EquipmentType.bodyweight => 'Körpergewicht',
      EquipmentType.dumbbells => 'Kurzhanteln',
      EquipmentType.barbell => 'Langhanteln',
      EquipmentType.kettlebell => 'Kettlebell',
      EquipmentType.resistanceBand => 'Widerstandsband',
      EquipmentType.none => 'Keine',
    };
  }

  String _getDifficultyName(DifficultyLevel difficulty) {
    return switch (difficulty) {
      DifficultyLevel.beginner => 'Anfänger',
      DifficultyLevel.intermediate => 'Mittel',
      DifficultyLevel.advanced => 'Fortgeschritten',
    };
  }

  Color _getDifficultyColor(DifficultyLevel difficulty) {
    return switch (difficulty) {
      DifficultyLevel.beginner => AppColors.success,
      DifficultyLevel.intermediate => AppColors.warning,
      DifficultyLevel.advanced => AppColors.error,
    };
  }
}

/// Chip für Muskelgruppe
class _MuscleGroupChip extends StatelessWidget {
  final MuscleGroup muscleGroup;

  const _MuscleGroupChip({required this.muscleGroup});

  @override
  Widget build(BuildContext context) {
    final name = _getMuscleGroupName(muscleGroup);
    final icon = _getMuscleGroupIcon(muscleGroup);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.primary),
          const SizedBox(width: 3),
          Text(
            name,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  String _getMuscleGroupName(MuscleGroup group) {
    return switch (group) {
      MuscleGroup.chest => 'Brust',
      MuscleGroup.back => 'Rücken',
      MuscleGroup.shoulders => 'Schultern',
      MuscleGroup.arms => 'Arme',
      MuscleGroup.legs => 'Beine',
      MuscleGroup.core => 'Core',
      MuscleGroup.fullBody => 'Ganzkörper',
    };
  }

  IconData _getMuscleGroupIcon(MuscleGroup group) {
    return switch (group) {
      MuscleGroup.chest => Icons.favorite,
      MuscleGroup.back => Icons.backspace,
      MuscleGroup.shoulders => Icons.sports_martial_arts,
      MuscleGroup.arms => Icons.sports_gymnastics,
      MuscleGroup.legs => Icons.directions_run,
      MuscleGroup.core => Icons.center_focus_strong,
      MuscleGroup.fullBody => Icons.accessibility,
    };
  }
}
