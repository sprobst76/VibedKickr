import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/comeback_mode.dart';

class WellnessTrendChart extends StatelessWidget {
  final List<WellnessCheckIn> checkIns;
  final double height;

  const WellnessTrendChart({
    super.key,
    required this.checkIns,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    if (checkIns.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            'Noch keine Check-Ins',
            style: TextStyle(color: context.secondaryTextColor),
          ),
        ),
      );
    }

    // Sort by date
    final sorted = checkIns.toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    // Take last 7 days
    final last7Days = sorted.reversed.take(7).toList().reversed.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Wellness-Verlauf',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _TrendIndicator(checkIns: last7Days),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildChart(context, last7Days),
          ),
        ),
      ],
    );
  }

  Widget _buildChart(BuildContext context, List<WellnessCheckIn> data) {
    final spots = data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.normalizedScore);
    }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (value) => FlLine(
            color: context.chartGridColor,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 25,
              getTitlesWidget: (value, meta) => Text(
                '${value.toInt()}%',
                style: TextStyle(fontSize: 10, color: context.chartTextColor),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= data.length) {
                  return const SizedBox.shrink();
                }
                final checkIn = data[value.toInt()];
                final weekday = _getWeekdayAbbr(checkIn.date.weekday);
                return Text(
                  weekday,
                  style: TextStyle(fontSize: 10, color: context.chartTextColor),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minY: 0,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: _getLineColor(data),
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: _getScoreColor(spot.y),
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: _getLineColor(data).withValues(alpha: 0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (spot) => context.surfaceColor,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final checkIn = data[spot.x.toInt()];
                return LineTooltipItem(
                  '${spot.y.toInt()}%\n${_formatDate(checkIn.date)}',
                  TextStyle(
                    color: context.primaryTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Color _getLineColor(List<WellnessCheckIn> data) {
    if (data.length < 2) return AppColors.primary;

    final avg =
        data.map((c) => c.normalizedScore).reduce((a, b) => a + b) /
            data.length;
    if (avg >= 75) return AppColors.success;
    if (avg >= 50) return AppColors.primary;
    if (avg >= 25) return AppColors.warning;
    return AppColors.error;
  }

  Color _getScoreColor(double score) {
    if (score >= 75) return AppColors.success;
    if (score >= 50) return AppColors.primary;
    if (score >= 25) return AppColors.warning;
    return AppColors.error;
  }

  String _getWeekdayAbbr(int weekday) {
    const abbrs = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
    return abbrs[weekday - 1];
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.';
  }
}

class _TrendIndicator extends StatelessWidget {
  final List<WellnessCheckIn> checkIns;

  const _TrendIndicator({required this.checkIns});

  @override
  Widget build(BuildContext context) {
    if (checkIns.length < 2) {
      return const SizedBox.shrink();
    }

    final trend = _calculateTrend();
    final (icon, color, label) = _getTrendDisplay(trend);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  double _calculateTrend() {
    final scores = checkIns.map((c) => c.normalizedScore).toList();
    if (scores.length < 2) return 0;

    final firstHalf = scores.take(scores.length ~/ 2);
    final secondHalf = scores.skip(scores.length ~/ 2);

    final avgFirst =
        firstHalf.reduce((a, b) => a + b) / firstHalf.length;
    final avgSecond =
        secondHalf.reduce((a, b) => a + b) / secondHalf.length;

    return avgSecond - avgFirst;
  }

  (IconData, Color, String) _getTrendDisplay(double trend) {
    if (trend > 10) {
      return (Icons.trending_up, AppColors.success, 'Steigend');
    } else if (trend < -10) {
      return (Icons.trending_down, AppColors.error, 'Fallend');
    } else {
      return (Icons.trending_flat, AppColors.textSecondary, 'Stabil');
    }
  }
}
