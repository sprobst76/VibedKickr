import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/duration_formatter.dart';
import '../../../../domain/entities/workout.dart';

class IntervalProgressBar extends StatelessWidget {
  final WorkoutInterval interval;
  final Duration elapsed;
  final int ftp;

  const IntervalProgressBar({
    super.key,
    required this.interval,
    required this.elapsed,
    required this.ftp,
  });

  @override
  Widget build(BuildContext context) {
    final progress = elapsed.inMilliseconds / interval.duration.inMilliseconds;
    final remaining = interval.duration - elapsed;
    final targetWatts = interval.powerTarget.resolveWatts(ftp);
    final intensity = ftp > 0 ? targetWatts / ftp : 0.5;
    final color = _colorForIntensity(intensity);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              _IntervalTypeIcon(type: interval.type),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      interval.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (interval.instructions != null)
                      Text(
                        interval.instructions!,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                  ],
                ),
              ),
              // Timer
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    remaining.toMinutesSeconds(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: remaining.inSeconds <= 10 ? AppColors.warning : null,
                    ),
                  ),
                  Text(
                    'verbleibend',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 12,
              backgroundColor: AppColors.surfaceLight,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          const SizedBox(height: 12),

          // Target Info Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Power Target
              _TargetChip(
                icon: Icons.flash_on,
                label: targetWatts > 0 ? '$targetWatts W' : 'Frei',
                color: color,
              ),
              // Cadence Target
              if (interval.cadenceMin != null || interval.cadenceMax != null)
                _TargetChip(
                  icon: Icons.sync,
                  label: _cadenceLabel(interval.cadenceMin, interval.cadenceMax),
                  color: AppColors.textSecondary,
                ),
              // Duration
              _TargetChip(
                icon: Icons.timer,
                label: interval.duration.toMinutesSeconds(),
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _cadenceLabel(int? min, int? max) {
    if (min != null && max != null) return '$min-$max rpm';
    if (min != null) return '>$min rpm';
    if (max != null) return '<$max rpm';
    return '';
  }

  Color _colorForIntensity(double intensity) {
    if (intensity < 0.55) return ZoneColors.z1ActiveRecovery;
    if (intensity < 0.75) return ZoneColors.z2Endurance;
    if (intensity < 0.90) return ZoneColors.z3Tempo;
    if (intensity < 1.05) return ZoneColors.z4Threshold;
    if (intensity < 1.20) return ZoneColors.z5Vo2Max;
    if (intensity < 1.50) return ZoneColors.z6Anaerobic;
    return ZoneColors.z7Neuromuscular;
  }
}

class _IntervalTypeIcon extends StatelessWidget {
  final IntervalType type;

  const _IntervalTypeIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (type) {
      IntervalType.warmup => (Icons.whatshot, AppColors.warning),
      IntervalType.work => (Icons.fitness_center, ZoneColors.z4Threshold),
      IntervalType.rest => (Icons.self_improvement, ZoneColors.z1ActiveRecovery),
      IntervalType.cooldown => (Icons.ac_unit, ZoneColors.z2Endurance),
      IntervalType.freeRide => (Icons.explore, AppColors.primary),
    };

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}

class _TargetChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _TargetChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
