import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/health_mode_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/health_mode.dart';
import '../../../../routing/app_router.dart';
import 'wellness_check_in_dialog.dart';

/// Gesundheitsmodus Status Card für das Dashboard
class HealthModeStatusCard extends ConsumerWidget {
  const HealthModeStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthMode = ref.watch(healthModeProvider);

    if (!healthMode.isActive) {
      return _InactiveHealthModeCard();
    }

    return _ActiveHealthModeCard(healthMode: healthMode);
  }
}

class _InactiveHealthModeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => context.push(AppRoutes.healthModeSetup),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.health_and_safety,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Gesundheitsmodus',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Wellness-Tracking, Übertraining-Schutz & sichere Progression',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActiveHealthModeCard extends ConsumerWidget {
  final HealthMode healthMode;

  const _ActiveHealthModeCard({required this.healthMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendation = healthMode.todayRecommendation;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getUseCaseIcon(healthMode.useCase),
                    color: AppColors.success,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        healthMode.useCase.label,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _getStatusText(healthMode),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.settings, size: 20),
                  onPressed: () => context.push(AppRoutes.healthModeSetup),
                  tooltip: 'Einstellungen',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Progress Bar (nur für Comeback use case)
            if (healthMode.useCase.hasPhases) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Fortschritt: ${healthMode.progressPercent.round()}%',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                      Text(
                        'Tag ${healthMode.daysSinceStart + 1} von 28',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: healthMode.progressPercent / 100,
                      minHeight: 8,
                      backgroundColor: AppColors.surfaceLight,
                      valueColor: const AlwaysStoppedAnimation(AppColors.success),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Stats Row (nur für Comeback use case)
            if (healthMode.useCase.hasPhases && healthMode.currentPhase != null) ...[
              Row(
                children: [
                  _StatItem(
                    icon: Icons.speed,
                    label: 'Eff. FTP',
                    value: '${healthMode.effectiveFtp} W',
                    subLabel:
                        '${(healthMode.currentPhase!.intensityFactor * 100).round()}% von ${healthMode.originalFtp} W',
                  ),
                  const SizedBox(width: 16),
                  _StatItem(
                    icon: Icons.timer,
                    label: 'Max Dauer',
                    value: '${healthMode.currentPhase!.maxDurationMinutes} min',
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Wellness Check-In
            if (!healthMode.hasCheckedInToday)
              _CheckInPrompt()
            else
              _TodayRecommendation(recommendation: recommendation),
          ],
        ),
      ),
    );
  }

  String _getStatusText(HealthMode healthMode) {
    switch (healthMode.useCase) {
      case HealthModeUseCase.comebackAfterIllness:
        final phase = healthMode.currentPhase;
        return 'Phase: ${phase?.label ?? "Abgeschlossen"}';
      case HealthModeUseCase.overtrainingPrevention:
        return 'Wellness: ${healthMode.averageWellnessScore7d.round()}%';
      case HealthModeUseCase.generalWellnessTracking:
        return '${healthMode.checkIns.length} Check-Ins';
    }
  }

  IconData _getUseCaseIcon(HealthModeUseCase useCase) {
    switch (useCase) {
      case HealthModeUseCase.comebackAfterIllness:
        return Icons.healing;
      case HealthModeUseCase.overtrainingPrevention:
        return Icons.health_and_safety;
      case HealthModeUseCase.generalWellnessTracking:
        return Icons.monitor_heart;
    }
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subLabel;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    this.subLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (subLabel != null) ...[
              const SizedBox(height: 2),
              Text(
                subLabel!,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CheckInPrompt extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.notification_important,
            color: AppColors.warning,
            size: 20,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Täglicher Check-In ausstehend',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () => showWellnessCheckInDialog(context),
            child: const Text('Jetzt'),
          ),
        ],
      ),
    );
  }
}

class _TodayRecommendation extends StatelessWidget {
  final WellnessRecommendation recommendation;

  const _TodayRecommendation({required this.recommendation});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getColor().withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(_getIcon(), color: _getColor(), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Heute: ${recommendation.label}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _getColor(),
                  ),
                ),
                Text(
                  'Max ${(recommendation.maxIntensity * 100).round()}% FTP',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: AppColors.success, size: 20),
        ],
      ),
    );
  }

  Color _getColor() {
    switch (recommendation) {
      case WellnessRecommendation.restDay:
        return AppColors.error;
      case WellnessRecommendation.activeRecovery:
        return AppColors.warning;
      case WellnessRecommendation.lightTraining:
        return AppColors.primary;
      case WellnessRecommendation.readyToTrain:
        return AppColors.success;
    }
  }

  IconData _getIcon() {
    switch (recommendation) {
      case WellnessRecommendation.restDay:
        return Icons.hotel;
      case WellnessRecommendation.activeRecovery:
        return Icons.self_improvement;
      case WellnessRecommendation.lightTraining:
        return Icons.directions_walk;
      case WellnessRecommendation.readyToTrain:
        return Icons.directions_bike;
    }
  }
}
