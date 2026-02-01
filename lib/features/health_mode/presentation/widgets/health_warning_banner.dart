import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/health_warning.dart';
import '../../../../core/services/health_mode_service.dart';
import '../../../../providers/providers.dart';

/// Widget zum Anzeigen von Gesundheitsmodus-Warnungen
class HealthWarningBanner extends ConsumerWidget {
  const HealthWarningBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final warnings = ref.watch(allActiveWarningsProvider);

    if (warnings.isEmpty) return const SizedBox.shrink();

    // Sortiere nach Schweregrad (kritisch zuerst)
    final sortedWarnings = warnings.toList()
      ..sort((a, b) => b.severity.index.compareTo(a.severity.index));

    return Column(
      children: sortedWarnings.take(3).map((warning) {
        return _WarningCard(warning: warning);
      }).toList(),
    );
  }
}

class _WarningCard extends StatelessWidget {
  final HealthWarning warning;

  const _WarningCard({required this.warning});

  @override
  Widget build(BuildContext context) {
    final color = _getSeverityColor(warning.severity);
    final icon = _getSeverityIcon(warning.severity);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: color.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    warning.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                if (warning.severity != HealthWarningSeverity.info)
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () {
                      // TODO: Dismiss warning
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              warning.message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            if (warning.actionLabel != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _handleAction(context, warning.type),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                  ),
                  child: Text(warning.actionLabel!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(HealthWarningSeverity severity) {
    switch (severity) {
      case HealthWarningSeverity.info:
        return AppColors.primary;
      case HealthWarningSeverity.warning:
        return AppColors.warning;
      case HealthWarningSeverity.critical:
        return AppColors.error;
    }
  }

  IconData _getSeverityIcon(HealthWarningSeverity severity) {
    switch (severity) {
      case HealthWarningSeverity.info:
        return Icons.info_outline;
      case HealthWarningSeverity.warning:
        return Icons.warning_amber_outlined;
      case HealthWarningSeverity.critical:
        return Icons.error_outline;
    }
  }

  void _handleAction(BuildContext context, HealthWarningType type) {
    switch (type) {
      case HealthWarningType.readyForProgression:
        // Navigate to phase advancement
        break;
      case HealthWarningType.ftpImprovement:
        // Navigate to FTP update
        break;
      case HealthWarningType.restingHrElevated:
      case HealthWarningType.wellnessDeclining:
      case HealthWarningType.overtrainingRisk:
      case HealthWarningType.lowWellnessScore:
      case HealthWarningType.highWeeklyTss:
      case HealthWarningType.excessiveWeeklyTss:
        // Show recovery tips dialog
        _showRecoveryTips(context, type);
        break;
    }
  }

  void _showRecoveryTips(BuildContext context, HealthWarningType type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erholungs-Tipps'),
        content: SingleChildScrollView(
          child: Text(_getRecoveryTips(type)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Verstanden'),
          ),
        ],
      ),
    );
  }

  String _getRecoveryTips(HealthWarningType type) {
    switch (type) {
      case HealthWarningType.restingHrElevated:
        return '• Nimm dir 1-2 Ruhetage\n'
            '• Erhöhe deine Schlafdauer auf 8+ Stunden\n'
            '• Hydratation erhöhen (2-3L Wasser/Tag)\n'
            '• Stressreduktion (Meditation, leichte Spaziergänge)\n'
            '• Bei Anhalten >3 Tage: Arzt konsultieren';
      case HealthWarningType.wellnessDeclining:
      case HealthWarningType.overtrainingRisk:
        return '• Trainingsumfang um 30-50% reduzieren\n'
            '• Nur Zone 1-2 Einheiten für 3-5 Tage\n'
            '• Schlafpriorisierung (8-9 Stunden)\n'
            '• Ernährung: Erhöhte Protein- & Kohlenhydrat-Zufuhr\n'
            '• Aktive Erholung: Yoga, Stretching, leichte Spaziergänge\n'
            '• Stress-Management: Meditation, Atemübungen';
      case HealthWarningType.lowWellnessScore:
        return '• Mindestens 2 komplette Ruhetage\n'
            '• Keine intensiven Trainings für 3-5 Tage\n'
            '• Schlaf >9 Stunden\n'
            '• Massage oder Physiotherapie erwägen\n'
            '• Bei Krankheitsgefühl: Arzt aufsuchen\n'
            '• Langsamer Wiedereinstieg mit Zone 1 Training';
      case HealthWarningType.highWeeklyTss:
        return '• Plane 1-2 Ruhetage diese Woche ein\n'
            '• Reduziere Intensität auf Zone 1-2 für 2-3 Tage\n'
            '• Erhöhe Schlafdauer auf 8+ Stunden\n'
            '• Achte auf Ernährung und Hydratation\n'
            '• Überwache Wellness-Werte (Müdigkeit, Muskelkater)\n'
            '• Erwäge aktive Erholung statt intensiver Einheiten';
      case HealthWarningType.excessiveWeeklyTss:
        return '• SOFORT Trainingsumfang reduzieren\n'
            '• Mindestens 2 komplette Ruhetage\n'
            '• Nur Zone 1 Training für 3-5 Tage\n'
            '• Schlafpriorisierung (9+ Stunden)\n'
            '• Bei Anzeichen von Übertraining (erhöhter Ruhepuls, '
            'Leistungsabfall, Motivationsverlust): 1 Woche Trainingspause\n'
            '• Erwäge professionelle Trainingsberatung';
      default:
        return 'Allgemeine Erholungs-Tipps:\n\n'
            '• Ausreichend Schlaf (7-9 Stunden)\n'
            '• Gesunde Ernährung\n'
            '• Hydratation\n'
            '• Stressmanagement\n'
            '• Aktive Erholung';
    }
  }
}
