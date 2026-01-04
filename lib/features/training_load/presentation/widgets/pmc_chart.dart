import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../providers/providers.dart';

/// Performance Management Chart (PMC)
/// Zeigt CTL, ATL und TSB über Zeit
class PmcChart extends ConsumerWidget {
  final double height;

  const PmcChart({
    super.key,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pmcAsync = ref.watch(pmcDataProvider);

    return pmcAsync.when(
      data: (pmc) => _PmcChartContent(data: pmc, height: height),
      loading: () => SizedBox(
        height: height,
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => SizedBox(
        height: height,
        child: Center(
          child: Text('Fehler: $e', style: const TextStyle(color: AppColors.error)),
        ),
      ),
    );
  }
}

class _PmcChartContent extends StatelessWidget {
  final PerformanceManagementData data;
  final double height;

  const _PmcChartContent({
    required this.data,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (data.history.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(
          child: Text(
            'Noch keine Trainingsdaten vorhanden',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Legend
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendItem(color: AppColors.primary, label: 'CTL (Fitness)'),
              const SizedBox(width: 16),
              _LegendItem(color: AppColors.warning, label: 'ATL (Ermüdung)'),
              const SizedBox(width: 16),
              _LegendItem(color: AppColors.success, label: 'TSB (Form)'),
            ],
          ),
        ),

        // Chart
        SizedBox(
          height: height,
          child: CustomPaint(
            size: Size.infinite,
            painter: _PmcChartPainter(data: data),
          ),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _PmcChartPainter extends CustomPainter {
  final PerformanceManagementData data;

  _PmcChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.history.isEmpty) return;

    final padding = const EdgeInsets.only(left: 40, right: 16, top: 16, bottom: 24);
    final chartArea = Rect.fromLTWH(
      padding.left,
      padding.top,
      size.width - padding.left - padding.right,
      size.height - padding.top - padding.bottom,
    );

    // Berechne Wertebereiche
    double minValue = double.infinity;
    double maxValue = double.negativeInfinity;

    for (final day in data.history) {
      minValue = math.min(minValue, math.min(day.tsb, math.min(day.ctl, day.atl)));
      maxValue = math.max(maxValue, math.max(day.tsb, math.max(day.ctl, day.atl)));
    }

    // Padding für Werte
    final valueRange = maxValue - minValue;
    minValue -= valueRange * 0.1;
    maxValue += valueRange * 0.1;
    if (minValue == maxValue) {
      minValue -= 10;
      maxValue += 10;
    }

    // Zeichne Nulllinie für TSB
    if (minValue < 0 && maxValue > 0) {
      final zeroY = chartArea.bottom - (0 - minValue) / (maxValue - minValue) * chartArea.height;
      final zeroPaint = Paint()
        ..color = AppColors.textMuted.withValues(alpha: 0.3)
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
        Offset(chartArea.left, zeroY),
        Offset(chartArea.right, zeroY),
        zeroPaint,
      );
    }

    // Zeichne Y-Achse Labels
    _drawYAxisLabels(canvas, chartArea, minValue, maxValue);

    // Zeichne die Linien
    _drawLine(canvas, chartArea, data.history.map((d) => d.ctl).toList(),
              minValue, maxValue, AppColors.primary);
    _drawLine(canvas, chartArea, data.history.map((d) => d.atl).toList(),
              minValue, maxValue, AppColors.warning);
    _drawLine(canvas, chartArea, data.history.map((d) => d.tsb).toList(),
              minValue, maxValue, AppColors.success);

    // Zeichne X-Achse Labels (Datum)
    _drawXAxisLabels(canvas, chartArea);
  }

  void _drawLine(Canvas canvas, Rect chartArea, List<double> values,
                 double minValue, double maxValue, Color color) {
    if (values.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    bool first = true;

    for (int i = 0; i < values.length; i++) {
      final x = chartArea.left + (i / (values.length - 1)) * chartArea.width;
      final y = chartArea.bottom -
                ((values[i] - minValue) / (maxValue - minValue)) * chartArea.height;

      if (first) {
        path.moveTo(x, y);
        first = false;
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  void _drawYAxisLabels(Canvas canvas, Rect chartArea, double minValue, double maxValue) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final steps = 4;
    for (int i = 0; i <= steps; i++) {
      final value = minValue + (maxValue - minValue) * i / steps;
      final y = chartArea.bottom - (i / steps) * chartArea.height;

      textPainter.text = TextSpan(
        text: value.round().toString(),
        style: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 10,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(chartArea.left - textPainter.width - 8, y - textPainter.height / 2),
      );
    }
  }

  void _drawXAxisLabels(Canvas canvas, Rect chartArea) {
    if (data.history.isEmpty) return;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Zeige erste, mittlere und letzte Datum
    final indices = [0, data.history.length ~/ 2, data.history.length - 1];

    for (final i in indices) {
      if (i >= data.history.length) continue;

      final date = data.history[i].date;
      final x = chartArea.left + (i / (data.history.length - 1)) * chartArea.width;

      textPainter.text = TextSpan(
        text: '${date.day}.${date.month}',
        style: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 10,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, chartArea.bottom + 8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PmcChartPainter oldDelegate) {
    return data != oldDelegate.data;
  }
}
