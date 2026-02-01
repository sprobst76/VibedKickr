import 'package:flutter/material.dart';

import '../../../../core/services/health_program_result_analyzer.dart';
import '../../../../core/theme/app_theme.dart';

class RecoveryAnalysisCard extends StatelessWidget {
  final HrRecoveryAnalysis analysis;

  const RecoveryAnalysisCard({
    required this.analysis,
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
              const Icon(Icons.favorite_outlined, color: AppColors.primary, size: 24),
              const SizedBox(width: 8),
              Text(
                'HR Recovery Analyse',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Peak HR
          _RecoveryMetricRow(
            label: 'Peak Herzfrequenz',
            value: '${analysis.startHr} bpm',
            subtitle: 'Maximale HR während des Trainings',
          ),
          const SizedBox(height: 12),

          // 1-Minute Recovery
          if (analysis.hrAfter1Min != null) ...[
            _RecoveryMetricRow(
              label: 'Nach 1 Minute',
              value: '${analysis.hrAfter1Min} bpm',
              subtitle: analysis.drop1Min != null
                  ? 'Rückgang: ${analysis.drop1Min} bpm'
                  : '',
              dropColor: _getDropColor(analysis.drop1Min, 15), // 15 bpm erwarteter Rückgang
            ),
            const SizedBox(height: 12),
          ],

          // 2-Minute Recovery
          if (analysis.hrAfter2Min != null) ...[
            _RecoveryMetricRow(
              label: 'Nach 2 Minuten',
              value: '${analysis.hrAfter2Min} bpm',
              subtitle: analysis.drop2Min != null
                  ? 'Rückgang: ${analysis.drop2Min} bpm'
                  : '',
              dropColor: _getDropColor(analysis.drop2Min, 25), // 25 bpm erwarteter Rückgang
            ),
            const SizedBox(height: 12),
          ],

          // Divider
          Divider(color: AppColors.surfaceLight),
          const SizedBox(height: 12),

          // Recovery Score Progress
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recovery-Score',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${analysis.recoveryScore}/100',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: analysis.recoveryScore / 100,
                  minHeight: 8,
                  backgroundColor: AppColors.surfaceLight,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getScoreColor(analysis.recoveryScore),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Assessment
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  _getAssessmentIcon(),
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    analysis.assessment,
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
      ),
    );
  }

  Color _getDropColor(int? drop, int expectedDrop) {
    if (drop == null) return AppColors.textMuted;
    if (drop >= expectedDrop) return Colors.green;
    if (drop >= expectedDrop * 0.7) return Colors.orange;
    return Colors.red;
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  IconData _getAssessmentIcon() {
    final score = analysis.recoveryScore;
    if (score >= 80) return Icons.thumb_up;
    if (score >= 60) return Icons.info;
    return Icons.warning;
  }
}

class _RecoveryMetricRow extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final Color? dropColor;

  const _RecoveryMetricRow({
    required this.label,
    required this.value,
    this.subtitle = '',
    this.dropColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: (dropColor ?? AppColors.primary).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: dropColor ?? AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
