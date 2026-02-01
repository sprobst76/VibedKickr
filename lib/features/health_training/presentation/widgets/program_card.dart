import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/athlete_profile.dart';
import '../../../../domain/entities/workout.dart';

class ProgramCard extends StatelessWidget {
  final Workout program;
  final AthleteProfile profile;

  const ProgramCard({
    required this.program,
    required this.profile,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final icon = _getProgramIcon(program.name);
    final description = _getProgramDescription(program.name);
    final color = _getProgramColor(program.name);
    final isDisabled = _isDisabled();

    return Card(
      child: InkWell(
        onTap: isDisabled ? null : () => _showProgramDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Opacity(
          opacity: isDisabled ? 0.5 : 1.0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: color, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            program.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            description,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isDisabled)
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.textMuted,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _InfoChip(
                      icon: Icons.timer_outlined,
                      label: '${program.totalDuration.inMinutes} min',
                    ),
                    const SizedBox(width: 8),
                    _InfoChip(
                      icon: Icons.repeat,
                      label: '${program.intervals.length} Phasen',
                    ),
                    if (isDisabled) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 12,
                              color: AppColors.warning,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'nur < 60 Jahre',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.warning,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isDisabled() {
    // Progressive Stress Test nur für < 60 Jahre
    if (program.id.contains('stress_test')) {
      final age = profile.age ?? 45;
      return age >= 60;
    }
    return false;
  }

  IconData _getProgramIcon(String name) {
    if (name.contains('Baseline')) {
      return Icons.trending_up;
    } else if (name.contains('Cardiac')) {
      return Icons.favorite;
    } else if (name.contains('Endurance')) {
      return Icons.directions_bike;
    } else if (name.contains('Stress')) {
      return Icons.flash_on;
    } else if (name.contains('Recovery')) {
      return Icons.spa;
    }
    return Icons.fitness_center;
  }

  Color _getProgramColor(String name) {
    if (name.contains('Baseline')) {
      return Colors.blue;
    } else if (name.contains('Cardiac')) {
      return Colors.red;
    } else if (name.contains('Endurance')) {
      return Colors.green;
    } else if (name.contains('Stress')) {
      return Colors.orange;
    } else if (name.contains('Recovery')) {
      return Colors.purple;
    }
    return AppColors.primary;
  }

  String _getProgramDescription(String name) {
    if (name.contains('Baseline')) {
      return 'Progressive Stufenbelastung zur Fitness-Bestimmung';
    } else if (name.contains('Cardiac')) {
      return 'Kardiovaskuläre Ausdauer nach AHA-Protokoll';
    } else if (name.contains('Endurance')) {
      return 'Personalisiertes Grundlagenausdauer-Training';
    } else if (name.contains('Stress')) {
      return 'Leistungsbestimmung mit progressive Stufen';
    } else if (name.contains('Recovery')) {
      return 'Überprüfung der Erholungsfähigkeit';
    }
    return '';
  }

  void _showProgramDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ProgramDetailsDialog(
        program: program,
        profile: profile,
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class ProgramDetailsDialog extends StatelessWidget {
  final Workout program;
  final AthleteProfile profile;

  const ProgramDetailsDialog({
    required this.program,
    required this.profile,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final duration = program.totalDuration;
    final phaseCount = program.intervals.length;

    return AlertDialog(
      title: Text(program.name),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              program.description,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Details',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 8),
            _DetailRow(
              label: 'Dauer',
              value: '${duration.inMinutes} Minuten',
            ),
            _DetailRow(
              label: 'Phasen',
              value: '$phaseCount',
            ),
            _DetailRow(
              label: 'Wissenschaftliche Basis',
              value: program.name.contains('Baseline') ? 'Progressive Stufentest' : 'Medizinische Protokolle',
            ),
            const SizedBox(height: 16),
            const Text(
              'Intervalle',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 8),
            for (int i = 0; i < phaseCount && i < 5; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _IntervalTile(interval: program.intervals[i]),
              ),
            if (phaseCount > 5)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '+ ${phaseCount - 5} weitere Phasen',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Schließen'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            // TODO: Start training
            Navigator.pop(context);
          },
          icon: const Icon(Icons.play_arrow),
          label: const Text('Training starten'),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _IntervalTile extends StatelessWidget {
  final WorkoutInterval interval;

  const _IntervalTile({required this.interval});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                interval.name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${interval.duration.inMinutes}:${(interval.duration.inSeconds % 60).toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              interval.type.name.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
