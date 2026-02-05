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
