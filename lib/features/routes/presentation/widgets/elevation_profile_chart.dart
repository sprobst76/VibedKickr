import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/gpx_route.dart';

/// Widget zur Anzeige des Höhenprofils einer GPX Route
class ElevationProfileChart extends StatelessWidget {
  final GpxRoute route;
  final double currentDistance;
  final Color? lineColor;
  final Color? fillColor;
  final Color? positionColor;

  const ElevationProfileChart({
    super.key,
    required this.route,
    this.currentDistance = 0,
    this.lineColor,
    this.fillColor,
    this.positionColor,
  });

  @override
  Widget build(BuildContext context) {
    if (route.points.isEmpty) {
      return const Center(child: Text('Keine Daten'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _ElevationProfilePainter(
            points: route.points,
            minElevation: route.minElevation,
            maxElevation: route.maxElevation,
            totalDistance: route.totalDistance,
            currentDistance: currentDistance,
            lineColor: lineColor ?? AppColors.primary,
            fillColor: fillColor ?? AppColors.primary.withValues(alpha: 0.3),
            positionColor: positionColor ?? AppColors.warning,
          ),
        );
      },
    );
  }
}

class _ElevationProfilePainter extends CustomPainter {
  final List<RoutePoint> points;
  final double minElevation;
  final double maxElevation;
  final double totalDistance;
  final double currentDistance;
  final Color lineColor;
  final Color fillColor;
  final Color positionColor;

  _ElevationProfilePainter({
    required this.points,
    required this.minElevation,
    required this.maxElevation,
    required this.totalDistance,
    required this.currentDistance,
    required this.lineColor,
    required this.fillColor,
    required this.positionColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty || totalDistance == 0) return;

    final padding = const EdgeInsets.only(left: 40, right: 16, top: 16, bottom: 24);
    final chartRect = Rect.fromLTRB(
      padding.left,
      padding.top,
      size.width - padding.right,
      size.height - padding.bottom,
    );

    // Etwas Puffer für Min/Max
    final elevationRange = maxElevation - minElevation;
    final elevationPadding = elevationRange * 0.1;
    final effectiveMin = minElevation - elevationPadding;
    final effectiveMax = maxElevation + elevationPadding;
    final effectiveRange = effectiveMax - effectiveMin;

    // Grid und Achsen zeichnen
    _drawGrid(canvas, chartRect, effectiveMin, effectiveMax);
    _drawAxes(canvas, chartRect, effectiveMin, effectiveMax);

    // Höhenprofil Pfad erstellen
    final path = Path();
    final fillPath = Path();

    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      final x = chartRect.left + (point.distance / totalDistance) * chartRect.width;
      final y = chartRect.bottom - ((point.elevation - effectiveMin) / effectiveRange) * chartRect.height;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, chartRect.bottom);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    // Fill Path schließen
    fillPath.lineTo(chartRect.right, chartRect.bottom);
    fillPath.close();

    // Füllung zeichnen (abgeschlossener Teil)
    if (currentDistance > 0) {
      final completedPath = Path();
      for (var i = 0; i < points.length; i++) {
        final point = points[i];
        if (point.distance > currentDistance) break;

        final x = chartRect.left + (point.distance / totalDistance) * chartRect.width;
        final y = chartRect.bottom - ((point.elevation - effectiveMin) / effectiveRange) * chartRect.height;

        if (i == 0) {
          completedPath.moveTo(x, chartRect.bottom);
          completedPath.lineTo(x, y);
        } else {
          completedPath.lineTo(x, y);
        }
      }

      // Interpoliere zum aktuellen Punkt
      final currentX = chartRect.left + (currentDistance / totalDistance) * chartRect.width;
      final currentPoint = _interpolateElevation(currentDistance);
      final currentY = chartRect.bottom - ((currentPoint - effectiveMin) / effectiveRange) * chartRect.height;
      completedPath.lineTo(currentX, currentY);
      completedPath.lineTo(currentX, chartRect.bottom);
      completedPath.close();

      canvas.drawPath(
        completedPath,
        Paint()
          ..color = AppColors.success.withValues(alpha: 0.4)
          ..style = PaintingStyle.fill,
      );
    }

    // Restliche Füllung
    canvas.drawPath(
      fillPath,
      Paint()
        ..color = fillColor
        ..style = PaintingStyle.fill,
    );

    // Linie zeichnen
    canvas.drawPath(
      path,
      Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Aktuelle Position markieren
    if (currentDistance > 0 && currentDistance < totalDistance) {
      final currentX = chartRect.left + (currentDistance / totalDistance) * chartRect.width;
      final currentElevation = _interpolateElevation(currentDistance);
      final currentY = chartRect.bottom - ((currentElevation - effectiveMin) / effectiveRange) * chartRect.height;

      // Vertikale Linie
      canvas.drawLine(
        Offset(currentX, chartRect.top),
        Offset(currentX, chartRect.bottom),
        Paint()
          ..color = positionColor.withValues(alpha: 0.5)
          ..strokeWidth = 1,
      );

      // Position Punkt
      canvas.drawCircle(
        Offset(currentX, currentY),
        6,
        Paint()..color = positionColor,
      );
      canvas.drawCircle(
        Offset(currentX, currentY),
        4,
        Paint()..color = Colors.white,
      );

      // Elevation Label
      _drawPositionLabel(canvas, currentX, currentY, currentElevation, chartRect);
    }
  }

  double _interpolateElevation(double distance) {
    if (points.isEmpty) return 0;
    if (distance <= 0) return points.first.elevation;
    if (distance >= totalDistance) return points.last.elevation;

    for (var i = 1; i < points.length; i++) {
      if (points[i].distance >= distance) {
        final prev = points[i - 1];
        final curr = points[i];
        final ratio = (distance - prev.distance) / (curr.distance - prev.distance);
        return prev.elevation + (curr.elevation - prev.elevation) * ratio;
      }
    }
    return points.last.elevation;
  }

  void _drawGrid(Canvas canvas, Rect rect, double minEle, double maxEle) {
    final gridPaint = Paint()
      ..color = AppColors.surfaceLight
      ..strokeWidth = 1;

    // Horizontale Linien (Höhe)
    const horizontalLines = 4;
    for (var i = 0; i <= horizontalLines; i++) {
      final y = rect.top + (rect.height / horizontalLines) * i;
      canvas.drawLine(Offset(rect.left, y), Offset(rect.right, y), gridPaint);
    }

    // Vertikale Linien (Distanz)
    const verticalLines = 5;
    for (var i = 0; i <= verticalLines; i++) {
      final x = rect.left + (rect.width / verticalLines) * i;
      canvas.drawLine(Offset(x, rect.top), Offset(x, rect.bottom), gridPaint);
    }
  }

  void _drawAxes(Canvas canvas, Rect rect, double minEle, double maxEle) {
    final textStyle = TextStyle(
      color: AppColors.textMuted,
      fontSize: 10,
    );

    // Y-Achse Labels (Höhe)
    const yLabels = 5;
    for (var i = 0; i <= yLabels; i++) {
      final elevation = minEle + ((maxEle - minEle) / yLabels) * (yLabels - i);
      final y = rect.top + (rect.height / yLabels) * i;

      final textSpan = TextSpan(
        text: '${elevation.round()}m',
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(rect.left - textPainter.width - 4, y - textPainter.height / 2),
      );
    }

    // X-Achse Labels (Distanz)
    const xLabels = 5;
    for (var i = 0; i <= xLabels; i++) {
      final distance = (totalDistance / xLabels) * i;
      final x = rect.left + (rect.width / xLabels) * i;

      final textSpan = TextSpan(
        text: '${(distance / 1000).toStringAsFixed(1)}',
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, rect.bottom + 4),
      );
    }

    // X-Achse Einheit
    final unitSpan = TextSpan(text: 'km', style: textStyle);
    final unitPainter = TextPainter(text: unitSpan, textDirection: TextDirection.ltr);
    unitPainter.layout();
    unitPainter.paint(canvas, Offset(rect.right + 4, rect.bottom + 4));
  }

  void _drawPositionLabel(Canvas canvas, double x, double y, double elevation, Rect chartRect) {
    final text = '${elevation.round()}m';
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final labelWidth = textPainter.width + 8;
    final labelHeight = textPainter.height + 4;

    // Position des Labels (über dem Punkt, aber im Chart bleiben)
    var labelX = x - labelWidth / 2;
    var labelY = y - labelHeight - 10;

    // Grenzen prüfen
    labelX = labelX.clamp(chartRect.left, chartRect.right - labelWidth);
    if (labelY < chartRect.top) {
      labelY = y + 10;
    }

    // Hintergrund
    final labelRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(labelX, labelY, labelWidth, labelHeight),
      const Radius.circular(4),
    );
    canvas.drawRRect(labelRect, Paint()..color = positionColor);

    // Text
    textPainter.paint(canvas, Offset(labelX + 4, labelY + 2));
  }

  @override
  bool shouldRepaint(_ElevationProfilePainter oldDelegate) {
    return currentDistance != oldDelegate.currentDistance ||
        points != oldDelegate.points;
  }
}

/// Kompaktes Höhenprofil für die Routenkarte
class ElevationProfileMini extends StatelessWidget {
  final GpxRoute route;
  final double height;

  const ElevationProfileMini({
    super.key,
    required this.route,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    if (route.points.isEmpty) {
      return SizedBox(height: height);
    }

    return SizedBox(
      height: height,
      child: CustomPaint(
        size: Size.infinite,
        painter: _MiniProfilePainter(
          points: route.points,
          minElevation: route.minElevation,
          maxElevation: route.maxElevation,
          totalDistance: route.totalDistance,
        ),
      ),
    );
  }
}

class _MiniProfilePainter extends CustomPainter {
  final List<RoutePoint> points;
  final double minElevation;
  final double maxElevation;
  final double totalDistance;

  _MiniProfilePainter({
    required this.points,
    required this.minElevation,
    required this.maxElevation,
    required this.totalDistance,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty || totalDistance == 0) return;

    final elevationRange = maxElevation - minElevation;
    final effectiveRange = elevationRange > 0 ? elevationRange : 1;

    final path = Path();
    final fillPath = Path();

    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      final x = (point.distance / totalDistance) * size.width;
      final y = size.height - ((point.elevation - minElevation) / effectiveRange) * size.height * 0.9;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Gradient fill
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.primary.withValues(alpha: 0.4),
        AppColors.primary.withValues(alpha: 0.1),
      ],
    );

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(_MiniProfilePainter oldDelegate) => false;
}
