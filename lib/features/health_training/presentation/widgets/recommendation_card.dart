import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/athlete_profile.dart';
import '../../../../domain/entities/workout.dart';

class RecommendationCard extends StatelessWidget {
  final Workout program;
  final AthleteProfile profile;

  const RecommendationCard({
    required this.program,
    required this.profile,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final age = profile.age ?? 45;
    final recommendationReason = _getRecommendationReason(age);

    return Card(
      color: AppColors.primaryDark.withValues(alpha: 0.1),
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
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ideal für dich',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        program.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              recommendationReason,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.timer_outlined,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${program.totalDuration.inMinutes} min',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.favorite_outlined,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${program.intervals.length} Phasen',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Navigate to program details or start directly
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Training starten'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRecommendationReason(int age) {
    if (age < 40) {
      return 'Dieses Programm ist ideal für dein Alter und Fitnesslevel. Es bietet eine ausgewogene Mischung aus Ausdauer und Belastung.';
    } else if (age < 50) {
      return 'Perfekt für dein Alter! Das Programm ist speziell auf die Bedürfnisse von Athleten deiner Altersgruppe abgestimmt.';
    } else if (age < 60) {
      return 'Für 50+ Jahre entwickelt. Das Programm berücksichtigt längere Warm-up- und Recovery-Phasen.';
    } else if (age < 70) {
      return 'Speziell für Senioren konzipiert. Längere Erholung und konservative Intensität für maximale Sicherheit.';
    } else {
      return 'Sehr konservatives Programm mit verlängerten Pausen. Perfekt für dein Alter und Fitness-Level.';
    }
  }
}
