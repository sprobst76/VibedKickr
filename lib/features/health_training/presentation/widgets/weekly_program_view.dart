import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/health_training_program.dart';

/// Weekly Program View für Health Training
/// Zeigt 7-Tage Übersicht mit Cycling und Strength Training kombiniert
class WeeklyProgramView extends StatelessWidget {
  final List<HealthTrainingProgram> weeklyProgram;
  final Function(HealthTrainingProgram)? onProgramTap;

  const WeeklyProgramView({
    required this.weeklyProgram,
    this.onProgramTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const weekDays = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'WOCHENPLAN',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textMuted,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 16),

        // Calendar view
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: List.generate(7, (index) {
            final program = weeklyProgram.isNotEmpty && index < weeklyProgram.length
                ? weeklyProgram[index]
                : null;

            return _buildDayCard(
              dayLabel: weekDays[index],
              program: program,
              onTap: program != null ? () => onProgramTap?.call(program) : null,
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDayCard({
    required String dayLabel,
    required HealthTrainingProgram? program,
    required VoidCallback? onTap,
  }) {
    final hasProgram = program != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: hasProgram ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surfaceLight.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasProgram ? AppColors.primary.withValues(alpha: 0.3) : AppColors.surfaceLight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                dayLabel,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: hasProgram ? AppColors.primary : AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 6),
              if (hasProgram) ...[
                Icon(
                  _getActivityIcon(program),
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Text(
                    program.name.split(' ').first,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 8,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${program.durationMinutes}m',
                  style: const TextStyle(
                    fontSize: 9,
                    color: AppColors.textMuted,
                  ),
                ),
              ] else
                Icon(
                  Icons.close,
                  size: 16,
                  color: AppColors.textMuted,
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getActivityIcon(HealthTrainingProgram program) {
    if (program.activityTypes.contains(HealthActivityType.cycling)) {
      return Icons.directions_bike;
    } else if (program.activityTypes.contains(HealthActivityType.strength)) {
      return Icons.fitness_center;
    } else if (program.activityTypes.contains(HealthActivityType.mobility)) {
      return Icons.self_improvement;
    }
    return Icons.check_circle;
  }
}

/// Detailed Weekly Program Card mit Übersicht
class DetailedWeeklyProgramCard extends StatelessWidget {
  final List<HealthTrainingProgram> weeklyProgram;
  final Function(HealthTrainingProgram)? onStartProgram;

  const DetailedWeeklyProgramCard({
    required this.weeklyProgram,
    this.onStartProgram,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const weekDays = ['Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag', 'Sonntag'];
    final weekPrograms = Map.fromIterables(
      weekDays,
      weeklyProgram.take(7),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DETAILLIERTER WOCHENPLAN',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textMuted,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: weekPrograms.entries.map((entry) {
            final day = entry.key;
            final program = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildDayRow(day, program),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDayRow(String day, HealthTrainingProgram program) {
    final activityTypes = program.activityTypes.map(_getActivityLabel).join(' + ');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onStartProgram?.call(program),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.surfaceLight),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      day,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      program.name,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Chip(
                    label: Text(
                      activityTypes,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${program.durationMinutes} min',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getActivityLabel(HealthActivityType type) {
    return switch (type) {
      HealthActivityType.cycling => '🚴 Radfahren',
      HealthActivityType.strength => '💪 Kraft',
      HealthActivityType.mobility => '🧘 Beweglichkeit',
      HealthActivityType.walking => '🚶 Gehen',
    };
  }
}

/// Activity Type Icons and Colors
class ActivityTypeIndicator extends StatelessWidget {
  final HealthActivityType type;
  final bool compact;

  const ActivityTypeIndicator({
    required this.type,
    this.compact = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          _getActivityIcon(type),
          size: compact ? 20 : 24,
          color: _getActivityColor(type),
        ),
        if (!compact) ...[
          const SizedBox(height: 4),
          Text(
            _getActivityLabel(type),
            style: TextStyle(
              fontSize: compact ? 9 : 11,
              color: _getActivityColor(type),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  IconData _getActivityIcon(HealthActivityType type) {
    return switch (type) {
      HealthActivityType.cycling => Icons.directions_bike,
      HealthActivityType.strength => Icons.fitness_center,
      HealthActivityType.mobility => Icons.self_improvement,
      HealthActivityType.walking => Icons.directions_walk,
    };
  }

  Color _getActivityColor(HealthActivityType type) {
    return switch (type) {
      HealthActivityType.cycling => AppColors.primary,
      HealthActivityType.strength => AppColors.success,
      HealthActivityType.mobility => AppColors.warning,
      HealthActivityType.walking => AppColors.accent,
    };
  }

  String _getActivityLabel(HealthActivityType type) {
    return switch (type) {
      HealthActivityType.cycling => 'Radfahren',
      HealthActivityType.strength => 'Kraft',
      HealthActivityType.mobility => 'Beweglichkeit',
      HealthActivityType.walking => 'Gehen',
    };
  }
}
