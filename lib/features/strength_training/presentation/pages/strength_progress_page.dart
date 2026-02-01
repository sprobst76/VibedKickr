import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/seed_data/strength_exercises.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/strength_exercise.dart';

/// Fortschritts-Tracking Page für Krafttraining
/// Zeigt Überblick, Charts und Session History
class StrengthProgressPage extends ConsumerStatefulWidget {
  const StrengthProgressPage({super.key});

  @override
  ConsumerState<StrengthProgressPage> createState() => _StrengthProgressPageState();
}

class _StrengthProgressPageState extends ConsumerState<StrengthProgressPage> {
  String _selectedExerciseId = '';
  String _dateRange = '1m'; // 1w, 1m, 3m, 6m, 1y

  @override
  void initState() {
    super.initState();
    if (StrengthExerciseSeedData.defaultExercises.isNotEmpty) {
      _selectedExerciseId = StrengthExerciseSeedData.defaultExercises.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedExercise = StrengthExerciseSeedData.defaultExercises
        .where((e) => e.id == _selectedExerciseId)
        .firstOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fortschritt'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overview Stats
              _buildOverviewSection(),
              const SizedBox(height: 32),

              // Exercise Selector
              _buildExerciseSelectorSection(selectedExercise),
              const SizedBox(height: 24),

              // Date Range Selector
              _buildDateRangeSelector(),
              const SizedBox(height: 24),

              // Progress Chart (Placeholder)
              if (selectedExercise != null)
                _buildProgressChartSection(selectedExercise),
              const SizedBox(height: 32),

              // Personal Records Table
              _buildPersonalRecordsSection(),
              const SizedBox(height: 32),

              // Recent Sessions
              _buildRecentSessionsSection(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ÜBERBLICK',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textMuted,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        // Stats cards
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            _buildStatCard(
              icon: Icons.fitness_center,
              label: 'Sessions',
              value: '0',
              color: AppColors.primary,
            ),
            _buildStatCard(
              icon: Icons.trending_up,
              label: 'Total Volume',
              value: '0 kg',
              color: AppColors.success,
            ),
            _buildStatCard(
              icon: Icons.emoji_events,
              label: 'PBs',
              value: '0',
              color: AppColors.warning,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseSelectorSection(StrengthExercise? selectedExercise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ÜBUNG AUSWÄHLEN',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textMuted,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _selectedExerciseId,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          items: StrengthExerciseSeedData.defaultExercises.map((exercise) {
            return DropdownMenuItem(
              value: exercise.id,
              child: Text(exercise.name),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedExerciseId = value);
            }
          },
        ),
        if (selectedExercise != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  _getMuscleGroupIcon(selectedExercise.primaryMuscles.first),
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatMuscleGroups(selectedExercise.primaryMuscles),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        selectedExercise.description,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDateRangeSelector() {
    final options = [
      ('1w', '1 Woche'),
      ('1m', '1 Monat'),
      ('3m', '3 Monate'),
      ('6m', '6 Monate'),
      ('1y', '1 Jahr'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: options.map((option) {
          final (value, label) = option;
          final isSelected = _dateRange == value;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (_) => setState(() => _dateRange = value),
              backgroundColor: AppColors.surfaceLight,
              selectedColor: AppColors.primary.withValues(alpha: 0.3),
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.surfaceLight,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProgressChartSection(StrengthExercise exercise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'GEWICHTSVERLAUF',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textMuted,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.surfaceLight),
          ),
          child: Column(
            children: [
              // Placeholder for chart
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.show_chart,
                        size: 48,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Chart wird geladen...',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${exercise.name} Gewichtsverlauf',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Chart info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Speichern Sie Sessions um Ihren Fortschritt zu sehen',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.primary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalRecordsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PERSÖNLICHE BESTLEISTUNGEN',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textMuted,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.surfaceLight),
          ),
          child: Column(
            children: [
              _buildPRRow('1RM', '—', 'Nicht gesetzt'),
              const Divider(height: 16),
              _buildPRRow('3RM', '—', 'Nicht gesetzt'),
              const Divider(height: 16),
              _buildPRRow('5RM', '—', 'Nicht gesetzt'),
              const Divider(height: 16),
              _buildPRRow('10RM', '—', 'Nicht gesetzt'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPRRow(String label, String value, String date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              date,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentSessionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AKTUELLE SESSIONS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textMuted,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.surfaceLight),
          ),
          child: Column(
            children: [
              Icon(
                Icons.history,
                size: 48,
                color: AppColors.textMuted,
              ),
              const SizedBox(height: 12),
              Text(
                'Noch keine Sessions',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Führen Sie Ihr erstes Workout aus um Daten zu erfassen',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: Navigate to session player
                  },
                  child: const Text('Workout starten'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
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

  String _formatMuscleGroups(List<MuscleGroup> groups) {
    final names = groups.map((g) {
      return switch (g) {
        MuscleGroup.chest => 'Brust',
        MuscleGroup.back => 'Rücken',
        MuscleGroup.shoulders => 'Schultern',
        MuscleGroup.arms => 'Arme',
        MuscleGroup.legs => 'Beine',
        MuscleGroup.core => 'Core',
        MuscleGroup.fullBody => 'Ganzkörper',
      };
    }).toList();
    return names.join(', ');
  }
}
