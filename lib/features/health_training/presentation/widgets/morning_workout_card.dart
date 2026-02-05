import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/health_training_program_generator.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../providers/morning_workout_providers.dart';
import '../../../../providers/providers.dart';
import '../../../workouts/presentation/pages/workout_player_page.dart';

/// Quick-Start Card für das Guten Morgen Training
class MorningWorkoutCard extends ConsumerWidget {
  const MorningWorkoutCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayScore = ref.watch(todayRecoveryScoreProvider);
    final streak = ref.watch(morningWorkoutStreakProvider);

    return Card(
      child: InkWell(
        onTap: () => _startMorningWorkout(context, ref),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.wb_sunny,
                      color: Colors.amber,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Guten Morgen Training',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '10 Min sanftes Training mit Recovery-Check',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  // Heutiger Score
                  todayScore.when(
                    data: (score) {
                      if (score != null) {
                        final scoreColor = score.recoveryScore >= 70
                            ? Colors.green
                            : score.recoveryScore >= 50
                                ? Colors.orange
                                : Colors.red;
                        return _InfoBadge(
                          icon: Icons.favorite,
                          label: '${score.recoveryScore}',
                          subtitle: 'Score',
                          color: scoreColor,
                        );
                      }
                      return const _InfoBadge(
                        icon: Icons.remove_circle_outline,
                        label: '--',
                        subtitle: 'Heute',
                        color: AppColors.textMuted,
                      );
                    },
                    loading: () => const _InfoBadge(
                      icon: Icons.hourglass_empty,
                      label: '...',
                      subtitle: 'Score',
                      color: AppColors.textMuted,
                    ),
                    error: (_, __) => const _InfoBadge(
                      icon: Icons.error_outline,
                      label: '--',
                      subtitle: 'Score',
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Streak
                  streak.when(
                    data: (days) => _InfoBadge(
                      icon: Icons.local_fire_department,
                      label: '$days',
                      subtitle: days == 1 ? 'Tag' : 'Tage',
                      color: days > 0 ? Colors.orange : AppColors.textMuted,
                    ),
                    loading: () => const _InfoBadge(
                      icon: Icons.local_fire_department,
                      label: '...',
                      subtitle: 'Streak',
                      color: AppColors.textMuted,
                    ),
                    error: (_, __) => const _InfoBadge(
                      icon: Icons.local_fire_department,
                      label: '0',
                      subtitle: 'Streak',
                      color: AppColors.textMuted,
                    ),
                  ),
                  const Spacer(),
                  // Start Button
                  todayScore.when(
                    data: (score) {
                      final alreadyDone = score != null;
                      return FilledButton.icon(
                        onPressed: () => _startMorningWorkout(context, ref),
                        icon: Icon(
                          alreadyDone ? Icons.replay : Icons.play_arrow,
                          size: 18,
                        ),
                        label: Text(
                          alreadyDone ? 'Nochmal' : 'Starten',
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.amber.shade700,
                        ),
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => FilledButton.icon(
                      onPressed: () => _startMorningWorkout(context, ref),
                      icon: const Icon(Icons.play_arrow, size: 18),
                      label: const Text('Starten'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.amber.shade700,
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

  void _startMorningWorkout(BuildContext context, WidgetRef ref) {
    final profile = ref.read(athleteProfileProvider);
    final workout =
        HealthTrainingProgramGenerator.generateMorningWakeup(profile);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WorkoutPlayerPage(
          workoutId: workout.id,
        ),
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;

  const _InfoBadge({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}
