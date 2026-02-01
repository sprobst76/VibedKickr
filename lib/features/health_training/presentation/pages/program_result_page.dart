import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/health_program_result_analyzer.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/training_session.dart';
import '../../../../domain/entities/workout.dart';
import '../../../../providers/providers.dart';
import '../widgets/recovery_analysis_card.dart';
import '../widgets/fitness_level_card.dart';
import '../widgets/session_comparison_card.dart';
import '../widgets/next_program_recommendation_card.dart';
import '../widgets/difficulty_feedback_dialog.dart';

class ProgramResultPage extends ConsumerStatefulWidget {
  final TrainingSession session;
  final Workout program;

  const ProgramResultPage({
    required this.session,
    required this.program,
    super.key,
  });

  @override
  ConsumerState<ProgramResultPage> createState() => _ProgramResultPageState();
}

class _ProgramResultPageState extends ConsumerState<ProgramResultPage> {
  late HealthProgramResultAnalysis analysis;

  @override
  void initState() {
    super.initState();
    _analyzeResults();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showFeedbackDialog();
    });
  }

  void _analyzeResults() {
    final athlete = ref.read(athleteProfileProvider);

    // Analysiere Recovery, Fitness, Vergleich mit vorherigem Training, etc.
    final recoveryAnalysis = HealthProgramResultAnalyzer.analyzeHrRecovery(
      widget.session.dataPoints,
      athlete,
    );

    final fitnessEstimate = HealthProgramResultAnalyzer.analyzeFitnessLevel(
      widget.session.stats,
      athlete,
    );

    // TODO: Hole vorheriges Training für Vergleich
    final sessionComparison = HealthProgramResultAnalyzer.compareWithPrevious(
      widget.session.stats,
      null, // Vorheriges Training - später implementieren
    );

    // Generiere Empfehlung für nächstes Programm
    final nextProgram = _generateNextProgramRecommendation(
      fitnessEstimate,
      recoveryAnalysis,
    );

    analysis = HealthProgramResultAnalysis(
      recoveryAnalysis: recoveryAnalysis,
      fitnessEstimate: fitnessEstimate,
      sessionComparison: sessionComparison,
      nextProgramRecommendation: nextProgram,
    );
  }

  NextProgramRecommendation _generateNextProgramRecommendation(
    FitnessLevelEstimate? fitnessEstimate,
    HrRecoveryAnalysis? recoveryAnalysis,
  ) {
    // Empfehlung basierend auf Fitness-Level und Recovery
    if (fitnessEstimate == null) {
      return NextProgramRecommendation(
        programName: widget.program.name,
        reasoning: 'Wiederhole dieses Programm um konsistent zu trainieren.',
        priority: 50,
      );
    }

    final level = fitnessEstimate.level;

    if (level == FitnessLevel.excellent) {
      return NextProgramRecommendation(
        programName: 'Progressive Stress Test',
        reasoning: 'Du hast dieses Programm beeindruckend absolviert. Ein Stress Test wird dir helfen, dein aktuelles Leistungslimit zu bestimmen.',
        priority: 90,
      );
    } else if (level == FitnessLevel.good) {
      return NextProgramRecommendation(
        programName: 'Age-Optimized Endurance',
        reasoning: 'Mit deinem aktuellen Fitness-Level bist du bereit für längere Ausdauer-Sessions.',
        priority: 75,
      );
    } else if (level == FitnessLevel.fair) {
      return NextProgramRecommendation(
        programName: widget.program.name,
        reasoning: 'Wiederhole dieses Programm 1-2 mal pro Woche um deine Basis zu verbessern.',
        caution: 'Achte auf ausreichende Erholung zwischen Sessions.',
        priority: 60,
      );
    } else {
      return NextProgramRecommendation(
        programName: 'Cardiac Rehab Intervals',
        reasoning: 'Starte mit einem konservativeren Programm. Dieses bietet sanfte, überwachte Trainingsintervalle.',
        caution: 'Baue die Trainingsintensität allmählich auf.',
        priority: 40,
      );
    }
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => DifficultyFeedbackDialog(
        onFeedback: (difficulty) {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('${widget.program.name} - Ergebnisse'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Summary Card
          _ResultSummary(
            session: widget.session,
            program: widget.program,
          ),
          const SizedBox(height: 24),

          // Recovery Analysis
          if (analysis.recoveryAnalysis != null) ...[
            RecoveryAnalysisCard(analysis: analysis.recoveryAnalysis!),
            const SizedBox(height: 24),
          ],

          // Fitness Level Estimate
          if (analysis.fitnessEstimate != null) ...[
            FitnessLevelCard(estimate: analysis.fitnessEstimate!),
            const SizedBox(height: 24),
          ],

          // Session Comparison
          if (analysis.sessionComparison != null) ...[
            SessionComparisonCard(comparison: analysis.sessionComparison!),
            const SizedBox(height: 24),
          ],

          // Next Program Recommendation
          if (analysis.nextProgramRecommendation != null) ...[
            RecommendationCard(recommendation: analysis.nextProgramRecommendation!),
            const SizedBox(height: 24),
          ],

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  label: const Text('Zurück'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Navigate to next program or home
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Fertig'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

/// Zusammenfassung der Trainings-Session
class _ResultSummary extends StatelessWidget {
  final TrainingSession session;
  final Workout program;

  const _ResultSummary({
    required this.session,
    required this.program,
  });

  @override
  Widget build(BuildContext context) {
    final stats = session.stats;
    if (stats == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Training abgeschlossen! 🎉',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.green,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _SummaryItem(
                icon: Icons.timer_outlined,
                label: 'Dauer',
                value: _formatDuration(stats.duration),
              ),
              _SummaryItem(
                icon: Icons.flash_on,
                label: 'Energie',
                value: '${stats.totalWork} kJ',
              ),
              _SummaryItem(
                icon: Icons.favorite_outlined,
                label: 'Ø Puls',
                value: stats.avgHeartRate != null ? '${stats.avgHeartRate} bpm' : '--',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _SummaryItem(
                icon: Icons.show_chart_outlined,
                label: 'TSS',
                value: '${stats.tss}',
              ),
              _SummaryItem(
                icon: Icons.bolt,
                label: 'Ø Power',
                value: '${stats.avgPower} W',
              ),
              _SummaryItem(
                icon: Icons.show_chart,
                label: 'Max HR',
                value: stats.maxHeartRate != null ? '${stats.maxHeartRate} bpm' : '--',
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes % 60;
    final seconds = d.inSeconds % 60;

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}h';
    }
    return '${minutes}m ${seconds}s';
  }
}

/// Einzelnes Summary Item
class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
