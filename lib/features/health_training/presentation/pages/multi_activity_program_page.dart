import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/multi_activity_program_generator.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/health_training_program.dart';
import '../../../../providers/providers.dart';
import '../widgets/weekly_program_view.dart';

/// Multi-Activity Health Program Page
/// Zeigt kombinierte Wochenpläne mit Radfahren + Krafttraining
class MultiActivityProgramPage extends ConsumerWidget {
  const MultiActivityProgramPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(athleteProfileProvider);
    final weeklyProgram =
        MultiActivityProgramGenerator.generateRecommendedProgram(profile);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wochenplan'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Info
              _buildHeaderInfo(profile),
              const SizedBox(height: 24),

              // Weekly Overview Grid
              WeeklyProgramView(
                weeklyProgram: weeklyProgram,
                onProgramTap: (program) =>
                    _handleProgramTap(context, program),
              ),
              const SizedBox(height: 32),

              // Detailed Program List
              DetailedWeeklyProgramCard(
                weeklyProgram: weeklyProgram,
                onStartProgram: (program) =>
                    _handleProgramTap(context, program),
              ),
              const SizedBox(height: 32),

              // Program Guidelines
              _buildGuidelinesSection(),
              const SizedBox(height: 32),

              // Activity Benefits
              _buildBenefitsSection(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(dynamic profile) {
    final age = profile.age ?? 'Unbekannt';
    final name = profile.name ?? 'Benutzer';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personalisierter Wochenplan für $name',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Alter: $age Jahre • Fokus: Gesundheit & Fitness',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Dieser Plan kombiniert kardiovaskuläres Training (Radfahren) mit Krafttraining für optimale Gesundheitsergebnisse.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidelinesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'RICHTLINIEN',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textMuted,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.surfaceLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGuidelineItem(
                icon: Icons.fitness_center,
                title: 'Krafttraining',
                description:
                    '2-3 × pro Woche. 45 Min. Fokus auf Grundübungen und funktionelle Bewegungen.',
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              _buildGuidelineItem(
                icon: Icons.directions_bike,
                title: 'Radfahren',
                description:
                    '2-3 × pro Woche. 40-45 Min. Zone 2-3 für kardiovaskuläre Gesundheit.',
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              _buildGuidelineItem(
                icon: Icons.schedule,
                title: 'Ruhezeiten',
                description:
                    '2 Ruhetage pro Woche. Kritisch für Erholung und Muskelaufbau.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGuidelineItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'VORTEILE DIESER KOMBINATION',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textMuted,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBenefitItem('Kardiovaskuläre Gesundheit: Radfahren stärkt das Herz-Kreislauf-System'),
              const SizedBox(height: 8),
              _buildBenefitItem('Muskelaufbau & Knochenstärke: Krafttraining erhöht Knochendichte'),
              const SizedBox(height: 8),
              _buildBenefitItem('Metabolische Vielfalt: Beide Aktivitäten ergänzen sich perfekt'),
              const SizedBox(height: 8),
              _buildBenefitItem('Verletzungsprävention: Wechsel zwischen Aktivitäten reduziert Überlastung'),
              const SizedBox(height: 8),
              _buildBenefitItem('Mentale Gesundheit: Vielfalt verhindert Trainingsmüdigkeit'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3, right: 8),
          child: Icon(
            Icons.check_circle,
            size: 16,
            color: AppColors.success,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  void _handleProgramTap(BuildContext context, HealthTrainingProgram program) {
    if (program.activityTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ruhetag - Fokus auf Erholung'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // TODO: Navigate to appropriate session player based on activity type
    final activities = program.activityTypes
        .map((t) => t.name)
        .join(' + ');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starten: ${program.name}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
