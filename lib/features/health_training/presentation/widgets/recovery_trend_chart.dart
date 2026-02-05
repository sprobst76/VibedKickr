import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../providers/morning_workout_providers.dart';

/// Recovery-Trend-Chart für die letzten 7 oder 30 Tage
class RecoveryTrendChart extends ConsumerStatefulWidget {
  const RecoveryTrendChart({super.key});

  @override
  ConsumerState<RecoveryTrendChart> createState() => _RecoveryTrendChartState();
}

class _RecoveryTrendChartState extends ConsumerState<RecoveryTrendChart> {
  bool _showMonthly = false;

  @override
  Widget build(BuildContext context) {
    final scoresProvider = _showMonthly
        ? monthlyRecoveryScoresProvider
        : weeklyRecoveryScoresProvider;

    final scores = ref.watch(scoresProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.show_chart, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text(
                  'Recovery Trend',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: false, label: Text('7T')),
                    ButtonSegment(value: true, label: Text('30T')),
                  ],
                  selected: {_showMonthly},
                  onSelectionChanged: (set) {
                    setState(() => _showMonthly = set.first);
                  },
                  style: SegmentedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 11),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            scores.when(
              data: (data) {
                if (data.isEmpty) {
                  return const SizedBox(
                    height: 150,
                    child: Center(
                      child: Text(
                        'Noch keine Daten.\nStarte dein erstes Morgen-Training!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }
                return SizedBox(
                  height: 180,
                  child: _buildChart(data),
                );
              },
              loading: () => const SizedBox(
                height: 180,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, __) => const SizedBox(
                height: 180,
                child: Center(child: Text('Fehler beim Laden')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(List<MorningRecoveryScoreEntity> scores) {
    if (scores.isEmpty) return const SizedBox.shrink();

    final spots = scores.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        entry.value.recoveryScore.toDouble(),
      );
    }).toList();

    final avgScore =
        scores.map((s) => s.recoveryScore).reduce((a, b) => a + b) /
            scores.length;

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 100,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppColors.surfaceLight,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 25,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              interval: _showMonthly ? 7 : 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= scores.length) {
                  return const SizedBox.shrink();
                }
                final date = scores[index].date;
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    DateFormat('dd.MM').format(date),
                    style: const TextStyle(
                      fontSize: 9,
                      color: AppColors.textMuted,
                    ),
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: avgScore,
              color: AppColors.primary.withValues(alpha: 0.5),
              strokeWidth: 1,
              dashArray: [5, 5],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.topRight,
                style: TextStyle(
                  fontSize: 9,
                  color: AppColors.primary.withValues(alpha: 0.7),
                ),
                labelResolver: (_) =>
                    'Ø ${avgScore.toStringAsFixed(0)}',
              ),
            ),
          ],
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.3,
            color: AppColors.primary,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, bar, index) {
                final score = spot.y;
                final color = score >= 70
                    ? Colors.green
                    : score >= 50
                        ? Colors.orange
                        : Colors.red;
                return FlDotCirclePainter(
                  radius: 3,
                  color: color,
                  strokeWidth: 1.5,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primary.withValues(alpha: 0.08),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (spots) {
              return spots.map((spot) {
                final index = spot.x.toInt();
                final date = index < scores.length
                    ? DateFormat('dd.MM.yyyy').format(scores[index].date)
                    : '';
                return LineTooltipItem(
                  '${spot.y.toInt()} Punkte\n$date',
                  const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
