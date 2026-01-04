import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/workout.dart';

class WorkoutTimeline extends StatelessWidget {
  final Workout workout;
  final int currentIntervalIndex;
  final int ftp;

  const WorkoutTimeline({
    super.key,
    required this.workout,
    required this.currentIntervalIndex,
    required this.ftp,
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
          const Text(
            'Workout Timeline',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),

          // Visual Bar
          _WorkoutBar(
            workout: workout,
            currentIndex: currentIntervalIndex,
            ftp: ftp,
          ),
          const SizedBox(height: 16),

          // Interval List
          Expanded(
            child: ListView.builder(
              itemCount: workout.intervals.length,
              itemBuilder: (context, index) {
                final interval = workout.intervals[index];
                final isCurrent = index == currentIntervalIndex;
                final isPast = index < currentIntervalIndex;

                return _IntervalListTile(
                  interval: interval,
                  index: index,
                  isCurrent: isCurrent,
                  isPast: isPast,
                  ftp: ftp,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutBar extends StatelessWidget {
  final Workout workout;
  final int currentIndex;
  final int ftp;

  const _WorkoutBar({
    required this.workout,
    required this.currentIndex,
    required this.ftp,
  });

  @override
  Widget build(BuildContext context) {
    final totalDuration = workout.totalDuration.inSeconds;

    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: AppColors.surfaceLight,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Row(
          children: workout.intervals.asMap().entries.map((entry) {
            final index = entry.key;
            final interval = entry.value;
            final widthFraction = interval.duration.inSeconds / totalDuration;
            final targetWatts = interval.powerTarget.resolveWatts(ftp);
            final intensity = ftp > 0 ? (targetWatts / ftp).clamp(0.0, 2.0) : 0.5;
            final color = _colorForIntensity(intensity);

            final isCurrent = index == currentIndex;
            final isPast = index < currentIndex;

            return Expanded(
              flex: (widthFraction * 1000).round(),
              child: Container(
                decoration: BoxDecoration(
                  color: isPast ? color.withOpacity(0.3) : color,
                  border: isCurrent
                      ? Border.all(color: Colors.white, width: 2)
                      : null,
                ),
                child: isCurrent
                    ? const Center(
                        child: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                          size: 20,
                        ),
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ),
    );
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

class _IntervalListTile extends StatelessWidget {
  final WorkoutInterval interval;
  final int index;
  final bool isCurrent;
  final bool isPast;
  final int ftp;

  const _IntervalListTile({
    required this.interval,
    required this.index,
    required this.isCurrent,
    required this.isPast,
    required this.ftp,
  });

  @override
  Widget build(BuildContext context) {
    final targetWatts = interval.powerTarget.resolveWatts(ftp);
    final intensity = ftp > 0 ? (targetWatts / ftp).clamp(0.0, 2.0) : 0.5;
    final color = _colorForIntensity(intensity);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isCurrent ? color.withOpacity(0.15) : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: isCurrent
            ? Border.all(color: color, width: 2)
            : Border.all(color: Colors.transparent),
      ),
      child: Row(
        children: [
          // Index / Check
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isPast
                  ? AppColors.success.withOpacity(0.2)
                  : isCurrent
                      ? color.withOpacity(0.2)
                      : AppColors.surfaceLight,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isPast
                  ? const Icon(Icons.check, size: 14, color: AppColors.success)
                  : Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isCurrent ? color : AppColors.textMuted,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 10),

          // Interval Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  interval.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isPast ? AppColors.textMuted : AppColors.textPrimary,
                  ),
                ),
                Text(
                  _formatDuration(interval.duration),
                  style: TextStyle(
                    fontSize: 11,
                    color: isPast ? AppColors.textMuted : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Power Target
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(isPast ? 0.1 : 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              targetWatts > 0 ? '${targetWatts}W' : 'Frei',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isPast ? color.withOpacity(0.5) : color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    if (minutes == 0) return '${seconds}s';
    if (seconds == 0) return '${minutes}min';
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
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
