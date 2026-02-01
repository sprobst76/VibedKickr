import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/strength_exercise.dart';

/// Chart Widget für Exercise Progress
/// Zeigt Gewichtsverlauf über Zeit mit Line Chart
/// (Placeholder für fl_chart Integration)
class ExerciseProgressChart extends StatelessWidget {
  final StrengthExercise exercise;
  final String dateRange; // 1w, 1m, 3m, 6m, 1y

  const ExerciseProgressChart({
    required this.exercise,
    required this.dateRange,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart placeholder
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
                    _getDateRangeLabel(dateRange),
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

          // Info box
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
                    'Chart wird mit fl_chart implementiert. Speichern Sie Sessions um Ihren Fortschritt zu sehen.',
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
    );
  }

  String _getDateRangeLabel(String range) {
    return switch (range) {
      '1w' => 'Letzte 1 Woche',
      '1m' => 'Letzter 1 Monat',
      '3m' => 'Letzte 3 Monate',
      '6m' => 'Letzte 6 Monate',
      '1y' => 'Letztes 1 Jahr',
      _ => 'Gewichtsverlauf',
    };
  }
}
