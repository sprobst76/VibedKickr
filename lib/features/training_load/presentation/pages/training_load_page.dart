import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../providers/providers.dart';
import '../widgets/pmc_chart.dart';

/// Training Load Detail-Seite mit PMC Chart
class TrainingLoadPage extends ConsumerWidget {
  const TrainingLoadPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pmcAsync = ref.watch(pmcDataProvider);
    final status = ref.watch(trainingStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Load'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Aktuelle Werte
            _CurrentStatusCard(status: status),
            const SizedBox(height: 24),

            // PMC Chart
            const Text(
              'Performance Management Chart',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Zeigt Fitness (CTL), Ermüdung (ATL) und Form (TSB) über die letzten 90 Tage',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: PmcChart(height: 250),
              ),
            ),
            const SizedBox(height: 24),

            // Erklärung
            _ExplanationCard(),
            const SizedBox(height: 24),

            // Statistiken
            pmcAsync.when(
              data: (pmc) => _StatsCard(data: pmc),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrentStatusCard extends StatelessWidget {
  final TrainingStatus status;

  const _CurrentStatusCard({required this.status});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _BigMetric(
                    label: 'Fitness (CTL)',
                    value: status.ctl.toStringAsFixed(0),
                    description: 'Langfristige Trainingsbelastung',
                    color: AppColors.primary,
                  ),
                ),
                Container(
                  width: 1,
                  height: 60,
                  color: AppColors.surfaceLight,
                ),
                Expanded(
                  child: _BigMetric(
                    label: 'Ermüdung (ATL)',
                    value: status.atl.toStringAsFixed(0),
                    description: 'Kurzfristige Trainingsbelastung',
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 16),
            _FormDisplay(tsb: status.tsb, formState: status.formState),
          ],
        ),
      ),
    );
  }
}

class _BigMetric extends StatelessWidget {
  final String label;
  final String value;
  final String description;
  final Color color;

  const _BigMetric({
    required this.label,
    required this.value,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textMuted,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _FormDisplay extends StatelessWidget {
  final double tsb;
  final TrainingFormState formState;

  const _FormDisplay({
    required this.tsb,
    required this.formState,
  });

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = switch (formState) {
      TrainingFormState.fresh => ('Sehr erholt', AppColors.primary, Icons.battery_full),
      TrainingFormState.rested => ('Ausgeruht', AppColors.success, Icons.battery_5_bar),
      TrainingFormState.optimal => ('Optimale Form', AppColors.success, Icons.bolt),
      TrainingFormState.tired => ('Müde', AppColors.warning, Icons.battery_3_bar),
      TrainingFormState.exhausted => ('Erschöpft', AppColors.error, Icons.battery_1_bar),
    };

    final recommendation = switch (formState) {
      TrainingFormState.fresh => 'Bereit für Wettkampf oder intensives Training',
      TrainingFormState.rested => 'Guter Zeitpunkt für hartes Training',
      TrainingFormState.optimal => 'Perfekte Balance - weiter so!',
      TrainingFormState.tired => 'Reduziere Intensität, fokussiere auf Erholung',
      TrainingFormState.exhausted => 'Ruhetag oder sehr leichte Aktivität empfohlen',
    };

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Form (TSB): ${tsb >= 0 ? '+' : ''}${tsb.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.lightbulb_outline, color: color, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  recommendation,
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExplanationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surfaceLight,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: AppColors.primary),
                SizedBox(width: 8),
                Text(
                  'Was bedeuten die Werte?',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _ExplanationItem(
              color: AppColors.primary,
              title: 'CTL (Fitness)',
              description: '42-Tage Durchschnitt deines TSS. Höhere Werte = bessere Fitness.',
            ),
            const SizedBox(height: 8),
            _ExplanationItem(
              color: AppColors.warning,
              title: 'ATL (Ermüdung)',
              description: '7-Tage Durchschnitt deines TSS. Zeigt aktuelle Belastung.',
            ),
            const SizedBox(height: 8),
            _ExplanationItem(
              color: AppColors.success,
              title: 'TSB (Form)',
              description: 'CTL minus ATL. Positiv = erholt, Negativ = ermüdet.',
            ),
          ],
        ),
      ),
    );
  }
}

class _ExplanationItem extends StatelessWidget {
  final Color color;
  final String title;
  final String description;

  const _ExplanationItem({
    required this.color,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.only(top: 3),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
              children: [
                TextSpan(
                  text: '$title: ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: description,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatsCard extends StatelessWidget {
  final PerformanceManagementData data;

  const _StatsCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistiken',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _StatRow(
              label: 'Wöchentlicher TSS',
              value: '${data.weeklyTss}',
            ),
            _StatRow(
              label: 'Ø Täglicher TSS (28 Tage)',
              value: data.avgDailyTss.toStringAsFixed(0),
            ),
            _StatRow(
              label: 'Peak Fitness (CTL)',
              value: data.peakCtl.toStringAsFixed(0),
            ),
            _StatRow(
              label: 'Fitness Trend',
              value: switch (data.fitnessTrend) {
                FitnessTrend.rising => '↑ Steigend',
                FitnessTrend.stable => '→ Stabil',
                FitnessTrend.falling => '↓ Fallend',
              },
              valueColor: switch (data.fitnessTrend) {
                FitnessTrend.rising => AppColors.success,
                FitnessTrend.stable => AppColors.textSecondary,
                FitnessTrend.falling => AppColors.error,
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _StatRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
