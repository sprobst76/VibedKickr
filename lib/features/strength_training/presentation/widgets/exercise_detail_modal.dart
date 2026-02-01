import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/strength_exercise.dart';

/// Modal für detaillierte Übungsinformationen
/// Zeigt Form Cues, Muskelgruppen, Modifikationen für 50+ und mehr
class ExerciseDetailModal extends StatelessWidget {
  final StrengthExercise exercise;

  const ExerciseDetailModal({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          color: AppColors.surface,
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            children: [
              // Header with dismiss handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title and Compound Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      exercise.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (exercise.isCompound)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Compound',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                exercise.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),

              // Muscle Groups Section
              _SectionHeader(title: 'Muskelgruppen'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MuscleGroupSection(
                    title: 'Primär',
                    muscles: exercise.primaryMuscles,
                  ),
                  const SizedBox(height: 12),
                  if (exercise.secondaryMuscles.isNotEmpty)
                    _MuscleGroupSection(
                      title: 'Sekundär',
                      muscles: exercise.secondaryMuscles,
                    ),
                ],
              ),
              const SizedBox(height: 24),

              // Equipment & Difficulty Info
              _InfoGrid(
                items: [
                  _InfoItem(
                    icon: Icons.fitness_center,
                    label: 'Ausrüstung',
                    value: _getEquipmentName(exercise.equipment),
                  ),
                  _InfoItem(
                    icon: Icons.trending_up,
                    label: 'Schwierigkeit',
                    value: _getDifficultyName(exercise.difficulty),
                  ),
                  _InfoItem(
                    icon: Icons.calendar_today,
                    label: 'Mindestalter',
                    value: '${exercise.minimumAge} Jahre',
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Form Cues Section
              _SectionHeader(title: 'Form Tipps'),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildFormCuesList(exercise.formCues),
                ),
              ),
              const SizedBox(height: 24),

              // 50+ Modifications Section
              if (exercise.requiresModification50Plus) ...[
                _SectionHeader(title: 'Modifikationen für 50+'),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Diese Übung hat Modifikationen für ältere Erwachsene',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.success,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        exercise.modification50PlusNotes ?? '',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Add to Workout Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Add to workout when routes are available
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${exercise.name} zum Workout hinzufügen'),
                        duration: const Duration(milliseconds: 500),
                      ),
                    );
                  },
                  child: const Text('Zum Workout hinzufügen'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildFormCuesList(String? formCues) {
    if (formCues == null || formCues.isEmpty) {
      return [];
    }

    final cues = formCues.split('.');
    final widgets = <Widget>[];

    for (int i = 0; i < cues.length; i++) {
      final cue = cues[i].trim();
      if (cue.isNotEmpty) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4, right: 8),
                  child: Text(
                    '•',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    cue,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    return widgets;
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
}

/// Section Header Widget
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.textMuted,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

/// Muscle Group Display Section
class _MuscleGroupSection extends StatelessWidget {
  final String title;
  final List<MuscleGroup> muscles;

  const _MuscleGroupSection({
    required this.title,
    required this.muscles,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: muscles.map((muscle) {
            return _MuscleGroupChip(muscleGroup: muscle);
          }).toList(),
        ),
      ],
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

/// Muscle Group Chip
class _MuscleGroupChip extends StatelessWidget {
  final MuscleGroup muscleGroup;

  const _MuscleGroupChip({required this.muscleGroup});

  @override
  Widget build(BuildContext context) {
    final name = _getMuscleGroupName(muscleGroup);
    final icon = _getMuscleGroupIcon(muscleGroup);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
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

/// Info Grid for displaying exercise metadata
class _InfoGrid extends StatelessWidget {
  final List<_InfoItem> items;

  const _InfoGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: items
          .map((item) => Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item.icon,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

/// Info Item Model
class _InfoItem {
  final IconData icon;
  final String label;
  final String value;

  _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}
