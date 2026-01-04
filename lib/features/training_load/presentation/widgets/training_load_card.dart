import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../providers/providers.dart';

/// Kompakte Training Load Karte für das Dashboard
class TrainingLoadCard extends ConsumerWidget {
  const TrainingLoadCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(trainingStatusProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: _getTrendColor(status.trend),
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Training Load',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                _FormBadge(formState: status.formState),
              ],
            ),
            const SizedBox(height: 16),

            // CTL / ATL / TSB
            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    label: 'Fitness',
                    value: status.ctl.toStringAsFixed(0),
                    subtitle: 'CTL',
                    color: AppColors.primary,
                  ),
                ),
                Expanded(
                  child: _MetricTile(
                    label: 'Ermüdung',
                    value: status.atl.toStringAsFixed(0),
                    subtitle: 'ATL',
                    color: AppColors.warning,
                  ),
                ),
                Expanded(
                  child: _MetricTile(
                    label: 'Form',
                    value: _formatTsb(status.tsb),
                    subtitle: 'TSB',
                    color: _getTsbColor(status.tsb),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Wöchentlicher TSS
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Diese Woche',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    '${status.weeklyTss} TSS',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTrendColor(FitnessTrend trend) {
    switch (trend) {
      case FitnessTrend.rising:
        return AppColors.success;
      case FitnessTrend.stable:
        return AppColors.textSecondary;
      case FitnessTrend.falling:
        return AppColors.error;
    }
  }

  Color _getTsbColor(double tsb) {
    if (tsb > 15) return AppColors.primary;
    if (tsb > 0) return AppColors.success;
    if (tsb > -15) return AppColors.warning;
    return AppColors.error;
  }

  String _formatTsb(double tsb) {
    final sign = tsb >= 0 ? '+' : '';
    return '$sign${tsb.toStringAsFixed(0)}';
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final Color color;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _FormBadge extends StatelessWidget {
  final TrainingFormState formState;

  const _FormBadge({required this.formState});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (formState) {
      TrainingFormState.fresh => ('Erholt', AppColors.primary),
      TrainingFormState.rested => ('Ausgeruht', AppColors.success),
      TrainingFormState.optimal => ('Optimal', AppColors.success),
      TrainingFormState.tired => ('Müde', AppColors.warning),
      TrainingFormState.exhausted => ('Erschöpft', AppColors.error),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
