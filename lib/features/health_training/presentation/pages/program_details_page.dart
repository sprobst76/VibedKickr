import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/health_training_personalization_service.dart';
import '../../../../core/services/health_disclaimer_manager.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/athlete_profile.dart';
import '../../../../domain/entities/workout.dart';
import '../../../../routing/app_router.dart';
import '../widgets/personalization_preview.dart';
import '../widgets/medical_disclaimer_dialog.dart';

class ProgramDetailsPage extends ConsumerWidget {
  final Workout program;
  final AthleteProfile profile;

  const ProgramDetailsPage({
    required this.program,
    required this.profile,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final age = profile.age ?? 45;
    final maxHr = HealthTrainingPersonalizationService.calculateMaxHeartRate(
      age,
      gender: profile.gender,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(program.name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Program Description
          _SectionHeader(title: 'Über dieses Programm'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    program.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Program Details
          _SectionHeader(title: 'Details'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _DetailRow(
                    label: 'Dauer',
                    value: '${program.totalDuration.inMinutes} Minuten',
                  ),
                  _DetailRow(
                    label: 'Phasen',
                    value: '${program.intervals.length}',
                  ),
                  _DetailRow(
                    label: 'Typ',
                    value: _getProgramType(program.name),
                  ),
                  _DetailRow(
                    label: 'Intensität',
                    value: _getIntensityLevel(age),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Intervals Breakdown
          _SectionHeader(title: 'Trainingsablauf'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  for (int i = 0; i < program.intervals.length; i++) ...[
                    _IntervalRow(
                      interval: program.intervals[i],
                      index: i + 1,
                    ),
                    if (i < program.intervals.length - 1)
                      const Divider(height: 16),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Personalization Preview
          _SectionHeader(title: 'Für dich personalisiert'),
          PersonalizationPreview(
            program: program,
            profile: profile,
            maxHr: maxHr,
          ),
          const SizedBox(height: 24),

          // Safety Information
          if (age >= 50)
            Column(
              children: [
                _SectionHeader(title: 'Wichtige Hinweise'),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppColors.warning,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ärztliche Freigabe empfohlen',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.warning,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Da du über 50 Jahre alt bist, wird empfohlen, vor diesem Training eine ärztliche Freigabe einzuholen.',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.warning.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),

          // Start Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _startTraining(context, ref),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Training starten'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _startTraining(BuildContext context, WidgetRef ref) async {
    // Check if medical disclaimer was already accepted
    final disclaimerAccepted = await HealthDisclaimerManager.isDisclaimerAccepted();

    if (!context.mounted) return;

    if (!disclaimerAccepted) {
      // Show medical disclaimer for first time acceptance
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => MedicalDisclaimerDialog(
          onAccepted: () async {
            // Save that disclaimer was accepted
            await HealthDisclaimerManager.acceptDisclaimer();
            Navigator.pop(context);
            _navigateToWorkout(context, ref);
          },
        ),
      );
    } else {
      // Disclaimer already accepted, navigate directly
      _navigateToWorkout(context, ref);
    }
  }

  void _navigateToWorkout(BuildContext context, WidgetRef ref) {
    context.go('${AppRoutes.workoutPlayer}?workoutId=${program.id}');
  }

  String _getProgramType(String name) {
    if (name.contains('Baseline')) return 'Progressiv';
    if (name.contains('Cardiac')) return 'Intervall';
    if (name.contains('Endurance')) return 'Ausdauer';
    if (name.contains('Stress')) return 'Intensiv';
    if (name.contains('Recovery')) return 'Erholung';
    return 'Allgemein';
  }

  String _getIntensityLevel(int age) {
    if (age < 50) return 'Moderat bis Hoch';
    if (age < 60) return 'Moderat';
    if (age < 70) return 'Leicht bis Moderat';
    return 'Leicht';
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.textMuted,
          letterSpacing: 1,
        ),
      ),
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
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _IntervalRow extends StatelessWidget {
  final WorkoutInterval interval;
  final int index;

  const _IntervalRow({
    required this.interval,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final durationStr =
        '${interval.duration.inMinutes}:${(interval.duration.inSeconds % 60).toString().padLeft(2, '0')}';
    final typeColor = _getTypeColor(interval.type);

    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: typeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              '$index',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: typeColor,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                interval.name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                interval.type.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  color: typeColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              durationStr,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '${interval.powerTarget}%',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getTypeColor(IntervalType type) {
    switch (type) {
      case IntervalType.warmup:
        return Colors.blue;
      case IntervalType.work:
        return Colors.orange;
      case IntervalType.rest:
        return Colors.green;
      case IntervalType.cooldown:
        return Colors.purple;
      case IntervalType.freeRide:
        return Colors.grey;
    }
  }
}
