import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/seed_data/strength_exercises.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/strength_exercise.dart';
import '../widgets/exercise_card.dart';
import '../widgets/exercise_detail_modal.dart';

/// Übungsbibliothek für Krafttraining
/// Ermöglicht Suche, Filterung und Erkundung aller verfügbaren Übungen
class ExerciseLibraryPage extends ConsumerStatefulWidget {
  const ExerciseLibraryPage({super.key});

  @override
  ConsumerState<ExerciseLibraryPage> createState() => _ExerciseLibraryPageState();
}

class _ExerciseLibraryPageState extends ConsumerState<ExerciseLibraryPage> {
  final TextEditingController _searchController = TextEditingController();
  final Set<MuscleGroup> _selectedMuscleGroups = {};
  final Set<EquipmentType> _selectedEquipment = {};
  final Set<DifficultyLevel> _selectedDifficulty = {};
  String _sortBy = 'name'; // name, difficulty

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get all exercises
    final allExercises = StrengthExerciseSeedData.defaultExercises;

    // Apply filters
    final filteredExercises = _filterExercises(allExercises);

    // Apply sorting
    final sortedExercises = _sortExercises(filteredExercises);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Übungsbibliothek'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Übung suchen...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.surfaceLight),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // Filter Section
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  // Muscle Group Filter
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
                  const SizedBox(height: 8),
                  // Equipment Filter
                  Wrap(
                    spacing: 8,
                    children: [
                      _FilterChip(
                        label: 'Körpergewicht',
                        selected: _selectedEquipment.contains(EquipmentType.bodyweight),
                        onSelected: (_) => _toggleEquipment(EquipmentType.bodyweight),
                      ),
                      _FilterChip(
                        label: 'Kurzhanteln',
                        selected: _selectedEquipment.contains(EquipmentType.dumbbells),
                        onSelected: (_) => _toggleEquipment(EquipmentType.dumbbells),
                      ),
                      _FilterChip(
                        label: 'Langhanteln',
                        selected: _selectedEquipment.contains(EquipmentType.barbell),
                        onSelected: (_) => _toggleEquipment(EquipmentType.barbell),
                      ),
                      _FilterChip(
                        label: 'Kettlebell',
                        selected: _selectedEquipment.contains(EquipmentType.kettlebell),
                        onSelected: (_) => _toggleEquipment(EquipmentType.kettlebell),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Difficulty Filter
                  Wrap(
                    spacing: 8,
                    children: [
                      _FilterChip(
                        label: 'Anfänger',
                        selected: _selectedDifficulty.contains(DifficultyLevel.beginner),
                        onSelected: (_) => _toggleDifficulty(DifficultyLevel.beginner),
                      ),
                      _FilterChip(
                        label: 'Mittel',
                        selected: _selectedDifficulty.contains(DifficultyLevel.intermediate),
                        onSelected: (_) => _toggleDifficulty(DifficultyLevel.intermediate),
                      ),
                      _FilterChip(
                        label: 'Fortgeschritten',
                        selected: _selectedDifficulty.contains(DifficultyLevel.advanced),
                        onSelected: (_) => _toggleDifficulty(DifficultyLevel.advanced),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Results Count & Sort
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${sortedExercises.length} Übungen',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
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
          ),

          // Exercise Grid
          Expanded(
            child: sortedExercises.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 48,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Keine Übungen gefunden',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: sortedExercises.length,
                    itemBuilder: (context, index) {
                      final exercise = sortedExercises[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ExerciseCard(
                          exercise: exercise,
                          onTap: () => _showExerciseDetail(context, exercise),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<StrengthExercise> _filterExercises(List<StrengthExercise> exercises) {
    final searchTerm = _searchController.text.toLowerCase();

    return exercises.where((exercise) {
      // Search filter
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

      // Equipment filter
      if (_selectedEquipment.isNotEmpty && !_selectedEquipment.contains(exercise.equipment)) {
        return false;
      }

      // Difficulty filter
      if (_selectedDifficulty.isNotEmpty && !_selectedDifficulty.contains(exercise.difficulty)) {
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

  void _toggleEquipment(EquipmentType equipment) {
    setState(() {
      if (_selectedEquipment.contains(equipment)) {
        _selectedEquipment.remove(equipment);
      } else {
        _selectedEquipment.add(equipment);
      }
    });
  }

  void _toggleDifficulty(DifficultyLevel difficulty) {
    setState(() {
      if (_selectedDifficulty.contains(difficulty)) {
        _selectedDifficulty.remove(difficulty);
      } else {
        _selectedDifficulty.add(difficulty);
      }
    });
  }

  void _showExerciseDetail(BuildContext context, StrengthExercise exercise) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ExerciseDetailModal(exercise: exercise),
    );
  }
}

/// Filter Chip für Exercise Library
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
