import 'package:flutter/material.dart';

import '../../../../core/services/health_program_result_analyzer.dart';
import '../../../../core/theme/app_theme.dart';

class RecommendationCard extends StatelessWidget {
  final NextProgramRecommendation recommendation;

  const RecommendationCard({
    required this.recommendation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final priorityColor = _getPriorityColor(recommendation.priority);
    final priorityLabel = _getPriorityLabel(recommendation.priority);

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
              const Icon(Icons.lightbulb, color: AppColors.primary, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Nächstes Trainingsprogramm',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Recommendation Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: priorityColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: priorityColor.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: priorityColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recommendation.programName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: priorityColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            priorityLabel,
                            style: TextStyle(
                              fontSize: 11,
                              color: priorityColor.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w500,
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

          // Reasoning
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Begründung',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  recommendation.reasoning,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),

          // Caution (if applicable)
          if (recommendation.caution != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Colors.orange.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_amber,
                    color: Colors.orange,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      recommendation.caution!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.orange,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Action Button
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Navigate to recommended program
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${recommendation.programName} wird geladen...'),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_forward),
              label: Text('${recommendation.programName} starten'),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(int priority) {
    if (priority >= 80) return Colors.green;
    if (priority >= 60) return Colors.blue;
    if (priority >= 40) return Colors.orange;
    return Colors.grey;
  }

  String _getPriorityLabel(int priority) {
    if (priority >= 80) return '⭐⭐⭐ Sehr empfohlen';
    if (priority >= 60) return '⭐⭐ Empfohlen';
    if (priority >= 40) return '⭐ Optional';
    return 'Nicht prioritär';
  }
}
