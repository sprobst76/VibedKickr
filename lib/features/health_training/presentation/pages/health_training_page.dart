import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/health_training_program_generator.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../providers/providers.dart';
import '../widgets/program_card.dart';
import '../widgets/recommendation_card.dart';
import '../widgets/health_status_card.dart';

class HealthTrainingPage extends ConsumerWidget {
  const HealthTrainingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(athleteProfileProvider);

    // Generiere alle Programme für diesen Athleten
    final allPrograms = HealthTrainingProgramGenerator.generateAllPrograms(profile);

    // Finde empfohlenes Programm
    final recommendedProgram = HealthTrainingProgramGenerator.recommendProgram(profile, allPrograms: allPrograms);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gesundheitstraining'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Health Status
          const HealthStatusCard(),
          const SizedBox(height: 24),

          // Empfohlenes Programm
          _SectionHeader(title: 'Empfohlenes Programm'),
          RecommendationCard(
            program: recommendedProgram,
            profile: profile,
          ),
          const SizedBox(height: 24),

          // Alle Programme
          _SectionHeader(title: 'Verfügbare Programme'),
          Column(
            children: [
              for (final program in allPrograms)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ProgramCard(
                    program: program,
                    profile: profile,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),

          // Info Section
          if (profile.age != null && profile.age! < 18)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.warning,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Diese Programme sind für Erwachsene konzipiert. Bitte ärztliche Freigabe einholen.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),
        ],
      ),
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
