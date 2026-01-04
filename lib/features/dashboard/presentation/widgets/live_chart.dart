import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class LivePowerChart extends StatelessWidget {
  final List<int> powerHistory;
  final int targetPower;
  final int maxSeconds;

  const LivePowerChart({
    super.key,
    required this.powerHistory,
    this.targetPower = 0,
    this.maxSeconds = 60,
  });

  @override
  Widget build(BuildContext context) {
    if (powerHistory.isEmpty) {
      return const Center(
        child: Text(
          'Warte auf Daten...',
          style: TextStyle(color: AppColors.textMuted),
        ),
      );
    }

    final spots = <FlSpot>[];
    final startIndex =
        powerHistory.length > maxSeconds ? powerHistory.length - maxSeconds : 0;

    for (int i = startIndex; i < powerHistory.length; i++) {
      spots.add(FlSpot(
        (i - startIndex).toDouble(),
        powerHistory[i].toDouble(),
      ));
    }

    // Max Y für die Anzeige
    final maxPower = powerHistory.reduce((a, b) => a > b ? a : b);
    final maxY = (maxPower * 1.2).clamp(100, 2000).toDouble();

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (maxSeconds - 1).toDouble(),
        minY: 0,
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 5,
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
              reservedSize: 45,
              interval: maxY / 5,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    '${value.toInt()}',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 25,
              interval: 10,
              getTitlesWidget: (value, meta) {
                final secondsAgo = maxSeconds - 1 - value.toInt();
                if (secondsAgo == 0) return const SizedBox.shrink();
                return Text(
                  '-${secondsAgo}s',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          // Power Line
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.2,
            color: AppColors.primary,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.3),
                  AppColors.primary.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            // Target Power Line
            if (targetPower > 0)
              HorizontalLine(
                y: targetPower.toDouble(),
                color: AppColors.warning.withOpacity(0.7),
                strokeWidth: 2,
                dashArray: [8, 4],
                label: HorizontalLineLabel(
                  show: true,
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.only(right: 8, bottom: 4),
                  style: const TextStyle(
                    color: AppColors.warning,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  labelResolver: (line) => 'Ziel: ${targetPower}W',
                ),
              ),
          ],
        ),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (spot) => AppColors.surface,
            tooltipRoundedRadius: 8,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${spot.y.toInt()} W',
                  const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
      duration: const Duration(milliseconds: 150),
    );
  }
}

/// Mini-Chart für History/Übersicht
class MiniPowerChart extends StatelessWidget {
  final List<int> powerData;
  final Color? color;

  const MiniPowerChart({
    super.key,
    required this.powerData,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (powerData.isEmpty) {
      return const SizedBox.shrink();
    }

    final spots = powerData
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
        .toList();

    final maxPower = powerData.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 40,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: maxPower.toDouble() * 1.1,
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.3,
              color: color ?? AppColors.primary,
              barWidth: 1.5,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: (color ?? AppColors.primary).withOpacity(0.1),
              ),
            ),
          ],
          lineTouchData: const LineTouchData(enabled: false),
        ),
      ),
    );
  }
}
