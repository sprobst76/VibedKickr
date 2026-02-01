import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/health_mode_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/health_mode.dart';

class PhaseReadinessCard extends ConsumerWidget {
  final HealthMode healthMode;

  const PhaseReadinessCard({
    super.key,
    required this.healthMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (healthMode.currentPhase == ComebackProtocolPhase.completed) {
      return const SizedBox.shrink();
    }

    final isReady = healthMode.isReadyForNextPhase;
    final recommendation = healthMode.phaseProgressionRecommendation;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isReady ? Icons.check_circle : Icons.schedule,
                  color: isReady ? AppColors.success : AppColors.warning,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isReady ? 'Bereit für nächste Phase' : 'Noch nicht bereit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          isReady ? AppColors.success : AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              recommendation,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            _RequirementsChecklist(healthMode: healthMode),
            if (isReady || healthMode.dayInCurrentWeek >= 7) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  if (!isReady && healthMode.dayInCurrentWeek >= 7)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            _showForceAdvanceDialog(context, ref, healthMode),
                        child: const Text('Trotzdem fortfahren'),
                      ),
                    ),
                  if (!isReady && healthMode.dayInCurrentWeek >= 7)
                    const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isReady || healthMode.dayInCurrentWeek >= 7
                          ? () => _advancePhase(context, ref, healthMode)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isReady ? AppColors.success : null,
                      ),
                      child: Text(
                        healthMode.currentPhase == ComebackProtocolPhase.week4
                            ? 'Comeback abschließen'
                            : 'Zur nächsten Phase',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _advancePhase(
      BuildContext context, WidgetRef ref, HealthMode healthMode) {
    ref.read(healthModeProvider.notifier).advancePhase();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          healthMode.currentPhase == ComebackProtocolPhase.week4
              ? 'Comeback abgeschlossen! Willkommen zurück!'
              : 'Phase fortgeschritten! Viel Erfolg!',
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showForceAdvanceDialog(
      BuildContext context, WidgetRef ref, HealthMode healthMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Phase überspringen?'),
        content: const Text(
          'Die Wellness-Kriterien sind noch nicht erfüllt. '
          'Ein zu früher Fortschritt kann das Risiko eines Rückfalls erhöhen. '
          'Bist du sicher?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _advancePhase(context, ref, healthMode);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
            ),
            child: const Text('Trotzdem fortfahren'),
          ),
        ],
      ),
    );
  }
}

class _RequirementsChecklist extends StatelessWidget {
  final HealthMode healthMode;

  const _RequirementsChecklist({required this.healthMode});

  @override
  Widget build(BuildContext context) {
    final minDays = healthMode.dayInCurrentWeek >= 5;
    final wellness = healthMode.averageWellnessScore7d >= 60;
    final hr = !healthMode.isRestingHrTrending ||
        healthMode.baselineRestingHr == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ChecklistItem(
          isChecked: minDays,
          label: 'Mindestens 5 Tage in Phase',
          detail: 'Tag ${healthMode.dayInCurrentWeek} von 7',
        ),
        _ChecklistItem(
          isChecked: wellness,
          label: 'Wellness-Score >60%',
          detail:
              'Aktuell: ${healthMode.averageWellnessScore7d.round()}%',
        ),
        if (healthMode.baselineRestingHr != null)
          _ChecklistItem(
            isChecked: hr,
            label: 'Ruhepuls stabil',
            detail: healthMode.isRestingHrTrending
                ? 'Erhöht - Erholung empfohlen'
                : 'Normal',
          ),
      ],
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  final bool isChecked;
  final String label;
  final String detail;

  const _ChecklistItem({
    required this.isChecked,
    required this.label,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isChecked ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 20,
            color: isChecked ? AppColors.success : AppColors.textMuted,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        isChecked ? AppColors.textPrimary : AppColors.textMuted,
                    fontWeight:
                        isChecked ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
                Text(
                  detail,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
