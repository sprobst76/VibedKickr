import 'package:flutter/material.dart';

import '../../../../core/database/seed_data/strength_exercises.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/strength_exercise.dart';

/// Modal zum Auswählen von Übungen für Workout Builder
/// Unterstützt Suche, Filterung und Multi-Select
class ExercisePickerModal extends StatefulWidget {
  final Function(List<StrengthExercise>) onExercisesSelected;

  const ExercisePickerModal({
    required this.onExercisesSelected,
  });

  @override
  State<ExercisePickerModal> createState() => _ExercisePickerModalState();
}

class _ExercisePickerModalState extends State<ExercisePickerModal> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedExerciseIds = {};
  final Set<MuscleGroup> _selectedMuscleGroups = {};
  String _sortBy = 'name';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allExercises = StrengthExerciseSeedData.defaultExercises;
    final filteredExercises = _filterExercises(allExercises);
    final sortedExercises = _sortExercises(filteredExercises);

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          color: AppColors.surface,
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              // Header
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
              const SizedBox(height: 16),
              const Text(
                'Übungen auswählen',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Search
              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Übung suchen...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Muscle Group Filters
              Wrap(
                spacing: 8,
                children: [
                  _FilterChip(
                    label: 'Brust',
                    selected: _selectedMuscleGroups.contains(MuscleGroup.chest),
                    onSelected: (_) => _toggleMuscleGroup(MuscleGroup.chest),
                  ),
                  _FilterChip(
                    label: 'Rücken',
                    selected: _selectedMuscleGroups.contains(MuscleGroup.back),
                    onSelected: (_) => _toggleMuscleGroup(MuscleGroup.back),
                  ),
                  _FilterChip(
                    label: 'Schultern',
                    selected: _selectedMuscleGroups.contains(MuscleGroup.shoulders),
                    onSelected: (_) => _toggleMuscleGroup(MuscleGroup.shoulders),
                  ),
                  _FilterChip(
                    label: 'Arme',
                    selected: _selectedMuscleGroups.contains(MuscleGroup.arms),
                    onSelected: (_) => _toggleMuscleGroup(MuscleGroup.arms),
                  ),
                  _FilterChip(
                    label: 'Beine',
                    selected: _selectedMuscleGroups.contains(MuscleGroup.legs),
                    onSelected: (_) => _toggleMuscleGroup(MuscleGroup.legs),
                  ),
                  _FilterChip(
                    label: 'Core',
                    selected: _selectedMuscleGroups.contains(MuscleGroup.core),
                    onSelected: (_) => _toggleMuscleGroup(MuscleGroup.core),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Results Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${sortedExercises.length} Übungen • ${_selectedExerciseIds.length} ausgewählt',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                  DropdownButton<String>(
                    value: _sortBy,
                    underline: const SizedBox.shrink(),
                    items: const [
                      DropdownMenuItem(value: 'name', child: Text('Name')),
                      DropdownMenuItem(value: 'difficulty', child: Text('Schwierigkeit')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _sortBy = value);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Exercises List
              ...sortedExercises.map((exercise) {
                final selected = _selectedExerciseIds.contains(exercise.id);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary.withValues(alpha: 0.1) : null,
                      border: Border.all(
                        color: selected ? AppColors.primary : AppColors.surfaceLight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CheckboxListTile(
                      value: selected,
                      onChanged: (value) {
                        if (value == true) {
                          setState(() => _selectedExerciseIds.add(exercise.id));
                        } else {
                          setState(() => _selectedExerciseIds.remove(exercise.id));
                        }
                      },
                      title: Text(
                        exercise.name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Icon(
                            _getEquipmentIcon(exercise.equipment),
                            size: 14,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getEquipmentName(exercise.equipment),
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (exercise.isCompound)
                            const Text(
                              'Compound',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                      activeColor: AppColors.primary,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                );
              }).toList(),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Abbrechen'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _selectedExerciseIds.isEmpty
                          ? null
                          : () {
                              final selected = StrengthExerciseSeedData.defaultExercises
                                  .where((e) => _selectedExerciseIds.contains(e.id))
                                  .toList();
                              widget.onExercisesSelected(selected);
                            },
                      child: Text(
                        'Hinzufügen (${_selectedExerciseIds.length})',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  List<StrengthExercise> _filterExercises(List<StrengthExercise> exercises) {
    final searchTerm = _searchController.text.toLowerCase();

    return exercises.where((exercise) {
      // Search
      if (searchTerm.isNotEmpty &&
          !exercise.name.toLowerCase().contains(searchTerm) &&
          !exercise.description.toLowerCase().contains(searchTerm)) {
        return false;
      }

      // Muscle group filter
      if (_selectedMuscleGroups.isNotEmpty &&
          !exercise.primaryMuscles.any((m) => _selectedMuscleGroups.contains(m))) {
        return false;
      }

      return true;
    }).toList();
  }

  List<StrengthExercise> _sortExercises(List<StrengthExercise> exercises) {
    final sorted = List<StrengthExercise>.from(exercises);

    switch (_sortBy) {
      case 'name':
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'difficulty':
        const difficultyOrder = {
          DifficultyLevel.beginner: 0,
          DifficultyLevel.intermediate: 1,
          DifficultyLevel.advanced: 2,
        };
        sorted.sort((a, b) =>
            (difficultyOrder[a.difficulty] ?? 0).compareTo(difficultyOrder[b.difficulty] ?? 0));
        break;
    }

    return sorted;
  }

  void _toggleMuscleGroup(MuscleGroup group) {
    setState(() {
      if (_selectedMuscleGroups.contains(group)) {
        _selectedMuscleGroups.remove(group);
      } else {
        _selectedMuscleGroups.add(group);
      }
    });
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
}

/// Filter Chip Widget
class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: AppColors.surfaceLight,
      selectedColor: AppColors.primary.withValues(alpha: 0.3),
      labelStyle: TextStyle(
        color: selected ? AppColors.primary : AppColors.textPrimary,
        fontSize: 12,
      ),
      side: BorderSide(
        color: selected ? AppColors.primary : AppColors.surfaceLight,
      ),
    );
  }
}
