import 'package:flutter/material.dart';

import '../../../../core/services/health_program_result_analyzer.dart';
import '../../../../core/theme/app_theme.dart';

class SessionComparisonCard extends StatelessWidget {
  final SessionComparison comparison;

  const SessionComparisonCard({
    required this.comparison,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
              const Icon(Icons.timeline, color: AppColors.primary, size: 24),
              const SizedBox(width: 8),
              Text(
                'Vergleich mit letztem Training',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (comparison.isFirstSession) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      comparison.assessment,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // HR Comparison
            if (comparison.currentAvgHr != null && comparison.previousAvgHr != null) ...[
              _ComparisonRow(
                label: 'Durchschnittliche Herzfrequenz',
                currentValue: '${comparison.currentAvgHr} bpm',
                previousValue: '${comparison.previousAvgHr} bpm',
                change: comparison.hrChange,
              ),
              const SizedBox(height: 12),
            ],

            // Power Comparison
            if (comparison.currentAvgPower != null && comparison.previousAvgPower != null) ...[
              _ComparisonRow(
                label: 'Durchschnittliche Power',
                currentValue: '${comparison.currentAvgPower} W',
                previousValue: '${comparison.previousAvgPower} W',
                change: comparison.powerChange,
              ),
              const SizedBox(height: 12),
            ],

            // Assessment
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    _getAssessmentIcon(comparison),
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      comparison.assessment,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getAssessmentIcon(SessionComparison comparison) {
    if (comparison.isFirstSession) return Icons.emoji_events;

    final hrChange = comparison.hrChange;
    final powerChange = comparison.powerChange;

    // Positive power increase
    if (powerChange != null && powerChange > 5) {
      return Icons.trending_up;
    }

    // HR improved (decreased at same power)
    if (hrChange != null && hrChange < -5) {
      return Icons.check_circle;
    }

    return Icons.info;
  }
}

class _ComparisonRow extends StatelessWidget {
  final String label;
  final String currentValue;
  final String previousValue;
  final double? change;

  const _ComparisonRow({
    required this.label,
    required this.currentValue,
    required this.previousValue,
    this.change,
  });

  @override
  Widget build(BuildContext context) {
    final changeText = change != null ? '${change! > 0 ? '+' : ''}${change!.toStringAsFixed(1)}%' : '';
    final changeColor = _getChangeColor(change);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _ValueBox(
                label: 'Aktuell',
                value: currentValue,
                isNew: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ValueBox(
                label: 'Vorher',
                value: previousValue,
              ),
            ),
            if (changeText.isNotEmpty) ...[
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: changeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  changeText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: changeColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Color _getChangeColor(double? change) {
    if (change == null) return AppColors.textMuted;
    if (change > 5) return Colors.green;     // Power improved
    if (change < -5) return Colors.green;    // HR decreased (good)
    if (change > -5 && change < 5) return Colors.orange;  // Similar
    return Colors.red;                       // Declined
  }
}

class _ValueBox extends StatelessWidget {
  final String label;
  final String value;
  final bool isNew;

  const _ValueBox({
    required this.label,
    required this.value,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isNew ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(6),
        border: isNew ? Border.all(color: AppColors.primary.withValues(alpha: 0.3)) : null,
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isNew ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
