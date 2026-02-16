import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../providers/providers.dart';
import '../../../strength_training/presentation/pages/exercise_library_page.dart';
import '../../../strength_training/presentation/pages/strength_workout_builder_page.dart';
import '../../../strength_training/presentation/pages/strength_progress_page.dart';

/// Krafttraining Tab für Gesundheitstraining
/// Bietet Zugang zu Übungsbibliothek, Workout Builder und Progress Tracking
class StrengthTrainingTab extends ConsumerWidget {
  const StrengthTrainingTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(athleteProfileProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header
        Text(
          'Krafttraining'.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textMuted,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),

        // Info Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Wissenschaftlich fundiertes Krafttraining',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Evidenzbasierte Programme für ${profile.age ?? "Ihre"} Jahre. '
                '2-3× pro Woche, optimal für Gesundheit und Fitness.',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Action Buttons
        _SectionHeader(title: 'Schnellstart'),
        _ActionButton(
          icon: Icons.library_books,
          title: 'Übungsbibliothek',
          subtitle: '15+ Übungen mit Form-Tipps',
          onTap: () => _navigateTo(context, '/health-training/strength/library'),
        ),
        const SizedBox(height: 12),
        _ActionButton(
          icon: Icons.build,
          title: 'Workout Builder',
          subtitle: 'Erstellen Sie Ihr Custom Workout',
          onTap: () =>
              _navigateTo(context, '/health-training/strength/workout-builder'),
        ),
        const SizedBox(height: 12),
        _ActionButton(
          icon: Icons.trending_up,
          title: 'Fortschritt',
          subtitle: 'Verfolgen Sie Ihre PRs und Trainingsziele',
          onTap: () => _navigateTo(context, '/health-training/strength/progress'),
        ),
        const SizedBox(height: 24),

        // Features
        _SectionHeader(title: 'Funktionen'),
        _FeatureItem(
          icon: Icons.fitness_center,
          title: 'Personal Records',
          description: 'Verfolgen Sie Ihre 1RM, 3RM, 5RM, 10RM',
        ),
        const SizedBox(height: 12),
        _FeatureItem(
          icon: Icons.auto_graph,
          title: 'Intelligente Progression',
          description: '+2.5kg wenn bereit • Automatische Deload-Erkennung',
        ),
        const SizedBox(height: 12),
        _FeatureItem(
          icon: Icons.schedule,
          title: 'Altersgerechte Programme',
          description: 'Wissenschaftlich optimiert für 50+',
        ),
        const SizedBox(height: 12),
        _FeatureItem(
          icon: Icons.info_outline,
          title: 'Detaillierte Form-Tipps',
          description: 'Sichere Ausführung mit Modifikationen',
        ),
        const SizedBox(height: 24),

        // Age-specific note
        if (profile.age != null && profile.age! >= 50)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: AppColors.success,
                  size: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Alle Programme sind speziell für 50+ optimiert.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _navigateTo(BuildContext context, String route) {
    final Widget page;
    switch (route) {
      case '/health-training/strength/library':
        page = const ExerciseLibraryPage();
      case '/health-training/strength/workout-builder':
        page = const StrengthWorkoutBuilderPage();
      case '/health-training/strength/progress':
        page = const StrengthProgressPage();
      default:
        return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );
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

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.surfaceLight,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 28,
                color: AppColors.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 24,
          color: AppColors.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
