import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/strength_session.dart';

/// Detail Page für eine Krafttraining Session
/// Zeigt Set-für-Set Breakdown und Session Statistiken
class StrengthSessionDetailPage extends StatelessWidget {
  final StrengthSession session;

  const StrengthSessionDetailPage({
    required this.session,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Detail'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Session Header
              _buildSessionHeader(),
              const SizedBox(height: 24),

              // Session Stats
              _buildSessionStats(),
              const SizedBox(height: 24),

              // Exercises Breakdown
              _buildExercisesBreakdown(),
              const SizedBox(height: 24),

              // Notes
              if (session.notes?.isNotEmpty ?? false) ...[
                _buildNotesSection(),
                const SizedBox(height: 24),
              ],

              // Action Buttons
              _buildActionButtons(context),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionHeader() {
    final duration = session.endTime != null
        ? session.endTime!.difference(session.startTime)
        : Duration.zero;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatDate(session.startTime),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SessionInfoItem(
                icon: Icons.schedule,
                label: 'Dauer',
                value: _formatDuration(duration),
              ),
              _SessionInfoItem(
                icon: Icons.fitness_center,
                label: 'Übungen',
                value: session.exercises.length.toString(),
              ),
              _SessionInfoItem(
                icon: Icons.trending_up,
                label: 'Total Reps',
                value: _calculateTotalReps().toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSessionStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'STATISTIKEN',
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
              _buildStatRow(
                'Total Sätze',
                session.stats?.totalSets.toString() ?? '0',
              ),
              const Divider(height: 16),
              _buildStatRow(
                'Total Wiederholungen',
                session.stats?.totalReps.toString() ?? '0',
              ),
              const Divider(height: 16),
              _buildStatRow(
                'Total Volume',
                '${session.stats?.totalVolume.toStringAsFixed(1) ?? "0"} kg',
              ),
              const Divider(height: 16),
              _buildStatRow(
                'Durchschn. RPE',
                session.stats?.avgRpe != null ? '${session.stats!.avgRpe}' : '—',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildExercisesBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ÜBUNGEN',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textMuted,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: session.exercises.asMap().entries.map((entry) {
            final index = entry.key;
            final exercise = entry.value;
            return Column(
              children: [
                _buildExerciseItem(exercise, index),
                if (index < session.exercises.length - 1)
                  const SizedBox(height: 12),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildExerciseItem(StrengthExerciseRecord exercise, int index) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${index + 1}. ${exercise.exerciseName}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${exercise.sets.length} Sätze',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.expand_more,
                color: AppColors.textMuted,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Sets breakdown
          Column(
            children: exercise.sets.asMap().entries.map((entry) {
              final setNum = entry.key + 1;
              final record = entry.value;
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Satz $setNum',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '${record.repsCompleted} reps',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (record.weightUsed != null) ...[
                            const SizedBox(width: 12),
                            Text(
                              '@ ${record.weightUsed}kg',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                          if (record.rpe != null) ...[
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'RPE ${record.rpe}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  if (entry.key < exercise.sets.length - 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Divider(height: 1),
                    ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ANMERKUNGEN',
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
          child: Text(
            session.notes ?? '',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          icon: const Icon(Icons.file_download),
          label: const Text('Als CSV exportieren'),
          onPressed: _exportToCSV,
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Zurück'),
        ),
      ],
    );
  }

  String _formatDate(DateTime dateTime) {
    final months = [
      'Jan',
      'Feb',
      'Mär',
      'Apr',
      'Mai',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Okt',
      'Nov',
      'Dez'
    ];
    return '${dateTime.day}. ${months[dateTime.month - 1]} ${dateTime.year}';
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  int _calculateTotalReps() {
    int total = 0;
    for (final exercise in session.exercises) {
      for (final set in exercise.sets) {
        total += set.repsCompleted;
      }
    }
    return total;
  }

  void _exportToCSV() {
    // TODO: Implement CSV export when file system access available
    // Generate CSV format:
    // Date, Exercise, Set, Reps, Weight, RPE, Duration
    debugPrint('Exporting session to CSV...');
  }
}

/// Session Info Item Widget
class _SessionInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SessionInfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
