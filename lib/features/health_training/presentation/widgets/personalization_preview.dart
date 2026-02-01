import 'package:flutter/material.dart';

import '../../../../core/services/health_training_personalization_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/athlete_profile.dart';
import '../../../../domain/entities/workout.dart';

class PersonalizationPreview extends StatelessWidget {
  final Workout program;
  final AthleteProfile profile;
  final int maxHr;

  const PersonalizationPreview({
    required this.program,
    required this.profile,
    required this.maxHr,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final age = profile.age ?? 45;
    final warmupDuration = HealthTrainingPersonalizationService.calculateWarmupDuration(age);
    final cooldownDuration = HealthTrainingPersonalizationService.calculateCooldownDuration(age);
    final ageFactor = HealthTrainingPersonalizationService.calculateAgeFactor(age);
    final safeHr = (maxHr * ageFactor).round();

    // Find work interval for HR target
    final workInterval = program.intervals.firstWhere(
      (i) => i.type == IntervalType.work,
      orElse: () => program.intervals.first,
    );
    final workTargetHr = ((workInterval.powerTarget.ftpPercent ?? 70) / 100 * maxHr).round();

    return Card(
      color: AppColors.surfaceLight,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.tune, color: AppColors.primary, size: 20),
                SizedBox(width: 8),
                Text(
                  'Angepasst an dein Profil',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _PreviewRow(
              icon: Icons.person,
              label: 'Dein Alter',
              value: '$age Jahre',
            ),
            _PreviewRow(
              icon: Icons.favorite,
              label: 'Max Herzfrequenz',
              value: '$maxHr bpm',
              subtitle: HealthTrainingPersonalizationService.calculateMaxHeartRate(
                age,
                gender: profile.gender,
              ) ==
                  maxHr
                  ? 'Berechnet'
                  : 'Dein Wert',
            ),
            _PreviewRow(
              icon: Icons.timer,
              label: 'Warmup',
              value: '${warmupDuration.inMinutes} min',
              subtitle: 'Altersgerecht',
            ),
            _PreviewRow(
              icon: Icons.show_chart,
              label: 'Sichere Trainings-HR',
              value: '$safeHr bpm',
              subtitle: '${(ageFactor * 100).round()}% von max HR',
            ),
            _PreviewRow(
              icon: Icons.flash_on,
              label: 'Ziel-HR im Work',
              value: '$workTargetHr bpm',
              subtitle: '~70% deiner max HR',
            ),
            _PreviewRow(
              icon: Icons.timer,
              label: 'Cooldown',
              value: '${cooldownDuration.inMinutes} min',
              subtitle: 'Altersgerecht',
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Das Programm passt sich automatisch an deinen Körper an.',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.primary.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;

  const _PreviewRow({
    required this.icon,
    required this.label,
    required this.value,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textMuted,
                    ),
                  ),
              ],
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
