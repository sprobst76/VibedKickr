import 'package:flutter/material.dart';

import '../../../../core/services/health_program_result_analyzer.dart';
import '../../../../core/theme/app_theme.dart';

class FitnessLevelCard extends StatelessWidget {
  final FitnessLevelEstimate estimate;

  const FitnessLevelCard({
    required this.estimate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getLevelColor(estimate.level);
    final emoji = _getLevelEmoji(estimate.level);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.trending_up, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                'Fitness-Level Schätzung',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Level Badge
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      emoji,
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getLevelName(estimate.level),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            estimate.description,
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
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Scores
          Row(
            children: [
              Expanded(
                child: _ScoreIndicator(
                  label: 'Power-Score',
                  score: estimate.powerScore,
                  icon: Icons.flash_on,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ScoreIndicator(
                  label: 'HR-Score',
                  score: estimate.hrScore,
                  icon: Icons.favorite,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Overall Score
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Gesamt-Score',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${estimate.overallScore}/100',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: estimate.overallScore / 100,
                  minHeight: 8,
                  backgroundColor: AppColors.surfaceLight,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Suggestions
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Empfehlungen',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                ...estimate.suggestions.map((suggestion) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          suggestion,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getLevelColor(FitnessLevel level) {
    switch (level) {
      case FitnessLevel.excellent:
        return Colors.green;
      case FitnessLevel.good:
        return Colors.blue;
      case FitnessLevel.fair:
        return Colors.orange;
      case FitnessLevel.poor:
        return Colors.red;
    }
  }

  String _getLevelName(FitnessLevel level) {
    switch (level) {
      case FitnessLevel.excellent:
        return 'Ausgezeichnet';
      case FitnessLevel.good:
        return 'Gut';
      case FitnessLevel.fair:
        return 'Befriedigend';
      case FitnessLevel.poor:
        return 'Anfänger';
    }
  }

  String _getLevelEmoji(FitnessLevel level) {
    switch (level) {
      case FitnessLevel.excellent:
        return '🏆';
      case FitnessLevel.good:
        return '💪';
      case FitnessLevel.fair:
        return '🚴';
      case FitnessLevel.poor:
        return '🌱';
    }
  }
}

class _ScoreIndicator extends StatelessWidget {
  final String label;
  final int score;
  final IconData icon;

  const _ScoreIndicator({
    required this.label,
    required this.score,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getScoreColor(score);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '$score',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }
}
