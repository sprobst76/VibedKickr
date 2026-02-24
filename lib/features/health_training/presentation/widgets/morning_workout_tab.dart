import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../providers/morning_workout_providers.dart';
import 'morning_workout_card.dart';
import 'morning_workout_settings_section.dart';
import 'recovery_trend_chart.dart';

/// Tab für das Morgen-Training im Gesundheitsbereich
class MorningWorkoutTab extends ConsumerWidget {
  const MorningWorkoutTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestScores = ref.watch(latestMorningRecoveryScoresProvider(5));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Quick-Start Card
        const MorningWorkoutCard(),
        const SizedBox(height: 24),

        // Wöchentliche Zusammenfassung
        _SectionHeader(title: 'Diese Woche'),
        const _WeeklySummaryCard(),
        const SizedBox(height: 24),

        // Recovery Trend Chart
        _SectionHeader(title: 'Recovery Verlauf'),
        const RecoveryTrendChart(),
        const SizedBox(height: 24),

        // Letzte Ergebnisse
        _SectionHeader(title: 'Letzte Ergebnisse'),
        latestScores.when(
          data: (scores) {
            if (scores.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.wb_sunny_outlined,
                          size: 40,
                          color: AppColors.textMuted.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Noch keine Morgen-Trainings absolviert',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Starte jetzt dein erstes Training!',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return Column(
              children: scores.map((score) {
                final scoreColor = score.recoveryScore >= 70
                    ? Colors.green
                    : score.recoveryScore >= 50
                        ? Colors.orange
                        : Colors.red;

                final date = score.date;
                final dayStr =
                    '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Card(
                    child: ListTile(
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: scoreColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '${score.recoveryScore}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: scoreColor,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        dayStr,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        score.assessment.length > 60
                            ? '${score.assessment.substring(0, 60)}...'
                            : score.assessment,
                        style: const TextStyle(fontSize: 11),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (score.drop1Min > 0)
                            Text(
                              '↓${score.drop1Min} bpm',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(child: Text('Fehler beim Laden')),
        ),
        const SizedBox(height: 24),

        // Benachrichtigungs-Einstellungen
        _SectionHeader(title: 'Einstellungen'),
        const MorningWorkoutSettingsSection(),
        const SizedBox(height: 24),
      ],
    );
  }
}

/// Wöchentliche Zusammenfassung der Morning Recovery Scores
class _WeeklySummaryCard extends ConsumerWidget {
  const _WeeklySummaryCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thisWeek = ref.watch(weeklyRecoveryScoresProvider);
    final prevWeek = ref.watch(previousWeekRecoveryScoresProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: thisWeek.when(
          data: (scores) {
            if (scores.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Noch keine Trainings diese Woche',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }

            final avgScore =
                scores.map((s) => s.recoveryScore).reduce((a, b) => a + b) /
                    scores.length;
            final avgScoreInt = avgScore.round();
            final scoreColor = avgScoreInt >= 70
                ? Colors.green
                : avgScoreInt >= 50
                    ? Colors.orange
                    : Colors.red;

            // Trend vs. Vorwoche
            final prevAvg = prevWeek.whenData((prev) {
              if (prev.isEmpty) return null;
              return prev
                      .map((s) => s.recoveryScore)
                      .reduce((a, b) => a + b) /
                  prev.length;
            }).valueOrNull;

            final trendDelta =
                prevAvg != null ? (avgScore - prevAvg).round() : null;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Trainingstage
                _WeekStat(
                  icon: Icons.calendar_today,
                  value: '${scores.length}',
                  label: 'Tage',
                  color: AppColors.primary,
                ),
                // Ø Recovery Score
                _WeekStat(
                  icon: Icons.favorite,
                  value: '$avgScoreInt',
                  label: 'Ø Score',
                  color: scoreColor,
                ),
                // Trend vs. Vorwoche
                _WeekStat(
                  icon: trendDelta == null
                      ? Icons.trending_flat
                      : trendDelta > 0
                          ? Icons.trending_up
                          : trendDelta < 0
                              ? Icons.trending_down
                              : Icons.trending_flat,
                  value: trendDelta == null
                      ? '--'
                      : trendDelta > 0
                          ? '+$trendDelta'
                          : '$trendDelta',
                  label: 'vs. Vorwoche',
                  color: trendDelta == null
                      ? AppColors.textMuted
                      : trendDelta > 0
                          ? Colors.green
                          : trendDelta < 0
                              ? Colors.red
                              : AppColors.textMuted,
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) =>
              const Center(child: Text('Fehler beim Laden')),
        ),
      ),
    );
  }
}

class _WeekStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _WeekStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

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
          letterSpacing: 1,
        ),
      ),
    );
  }
}
