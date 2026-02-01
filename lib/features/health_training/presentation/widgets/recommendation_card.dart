import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/athlete_profile.dart';
import '../../../../domain/entities/workout.dart';

/// Empfehlungs-Karte für ein Trainingsprogramm auf der Health Training Seite
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
    final isRecommendedForAge = _isRecommendedForAge(age);
    final reasoningColor = isRecommendedForAge ? Colors.green : Colors.orange;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: reasoningColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: reasoningColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.star, color: reasoningColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: reasoningColor,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isRecommendedForAge
                          ? 'Perfekt für dein Alter'
                          : 'Später ausprobieren',
                      style: TextStyle(
                        fontSize: 12,
                        color: reasoningColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            program.description,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.timer_outlined, size: 16, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    '${program.totalDuration.inMinutes} min',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.repeat, size: 16, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    '${program.intervals.length} Phasen',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _isRecommendedForAge(int age) {
    // Progressive Stress Test nur für < 60 Jahre
    if (program.id.contains('stress_test')) {
      return age < 60;
    }
    // Alle anderen Programme für alle Altersgruppen
    return true;
  }
}
