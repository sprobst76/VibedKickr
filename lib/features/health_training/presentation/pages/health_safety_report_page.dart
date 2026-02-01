import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/health_safety_report.dart';

class HealthSafetyReportPage extends StatelessWidget {
  final HealthSafetyReport report;

  const HealthSafetyReportPage({
    required this.report,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final rating = report.getSafetyRating();
    final ratingColor = _getRatingColor(rating);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Sicherheits-Bericht'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Safety Rating Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: ratingColor.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ratingColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getRatingIcon(rating),
                        color: ratingColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rating.displayName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ratingColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            rating.description,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Safety Metrics
          _SectionHeader(title: 'Sicherheits-Metriken'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _MetricRow(
                  icon: Icons.favorite,
                  label: 'Peak Herzfrequenz',
                  value: report.peakHr != null ? '${report.peakHr} bpm' : '--',
                  subtitle: 'Sicheres Limit: ${report.safeLimitHr} bpm',
                ),
                Divider(color: AppColors.surfaceLight),
                _MetricRow(
                  icon: Icons.favorite_outline,
                  label: 'Durchschnittliche HR',
                  value: report.avgHr != null ? '${report.avgHr} bpm' : '--',
                ),
                Divider(color: AppColors.surfaceLight),
                _MetricRow(
                  icon: Icons.warning_amber,
                  label: 'Limit-Überschreitungen',
                  value: '${report.limitExceededCount}x',
                  valueColor: report.limitExceededCount > 0
                      ? Colors.orange
                      : Colors.green,
                ),
                Divider(color: AppColors.surfaceLight),
                _MetricRow(
                  icon: Icons.pause_circle,
                  label: 'Auto-Pause Auslösungen',
                  value: '${report.autoPauseTriggerCount}x',
                  valueColor: report.autoPauseTriggerCount > 0
                      ? AppColors.error
                      : Colors.green,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Time Analysis
          _SectionHeader(title: 'Zeit-Analyse'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TimeBar(
                  label: 'Zeit über INFO-Limit (85%)',
                  duration: Duration(milliseconds: report.timeAboveInfoLimit),
                  color: Colors.yellow[700]!,
                  warningLevel: 'Info',
                ),
                const SizedBox(height: 16),
                _TimeBar(
                  label: 'Zeit über WARNING-Limit (95%)',
                  duration: Duration(milliseconds: report.timeAboveWarningLimit),
                  color: Colors.orange,
                  warningLevel: 'Warning',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Events
          if (report.events.isNotEmpty) ...[
            _SectionHeader(title: 'Sicherheits-Ereignisse'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  for (int i = 0; i < report.events.length; i++) ...[
                    _EventItem(event: report.events[i]),
                    if (i < report.events.length - 1)
                      Divider(color: AppColors.surfaceLight),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Recommendations
          _SectionHeader(title: 'Empfehlungen'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final recommendation in _getRecommendations())
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.lightbulb_outline,
                          color: AppColors.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            recommendation,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

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
                    // TODO: Mark as reviewed and close
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Verstanden'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  List<String> _getRecommendations() {
    final List<String> recommendations = [];
    final rating = report.getSafetyRating();

    if (report.emergencyStopUsed) {
      recommendations.add(
        'Du hast den Notfall-Stopp verwendet. Konsultiere einen Arzt vor dem nächsten Training.',
      );
      recommendations.add(
        'Reduziere die Trainingsintensität oder versuche es mit einem leichteren Programm.',
      );
    } else if (report.autoPauseTriggerCount > 0) {
      recommendations.add(
        'Auto-Pause wurde ausgelöst. Deine HR überschritt die sichere Grenze.',
      );
      recommendations.add(
        'Erhöhe die Ruhezeit zwischen den Trainings und versuche mit niedrigerer Intensität zu beginnen.',
      );
    } else if (report.limitExceededCount > 3) {
      recommendations.add(
        'Du hattest mehrere HR-Limitüberschreitungen. Versuche ein leichteres oder kürzeres Programm.',
      );
      recommendations.add(
        'Achte auf ausreichende Erholung zwischen den Trainings-Sessions.',
      );
    } else if (rating == SafetyRating.safe) {
      recommendations.add(
        'Ausgezeichnetes Training! Du hast die Sicherheitsgrenzen gut eingehalten.',
      );
      recommendations.add(
        'Wenn du dich bereit fühlst, kannst du die Intensität beim nächsten Training erhöhen.',
      );
    }

    return recommendations;
  }

  Color _getRatingColor(SafetyRating rating) {
    switch (rating) {
      case SafetyRating.safe:
        return Colors.green;
      case SafetyRating.acceptable:
        return Colors.blue;
      case SafetyRating.caution:
        return Colors.orange;
      case SafetyRating.warning:
        return Colors.deepOrange;
      case SafetyRating.unsafe:
        return AppColors.error;
    }
  }

  IconData _getRatingIcon(SafetyRating rating) {
    switch (rating) {
      case SafetyRating.safe:
        return Icons.check_circle;
      case SafetyRating.acceptable:
        return Icons.info;
      case SafetyRating.caution:
        return Icons.warning_amber;
      case SafetyRating.warning:
        return Icons.warning;
      case SafetyRating.unsafe:
        return Icons.error;
    }
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

class _MetricRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;
  final Color? valueColor;

  const _MetricRow({
    required this.icon,
    required this.label,
    required this.value,
    this.subtitle,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: 12),
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
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeBar extends StatelessWidget {
  final String label;
  final Duration duration;
  final Color color;
  final String warningLevel;

  const _TimeBar({
    required this.label,
    required this.duration,
    required this.color,
    required this.warningLevel,
  });

  @override
  Widget build(BuildContext context) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    final timeStr = '$minutes:${seconds.toString().padLeft(2, '0')} min';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
              timeStr,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (duration.inSeconds / 300).clamp(0.0, 1.0), // Max 5 min shown
            minHeight: 8,
            backgroundColor: AppColors.surfaceLight,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _EventItem extends StatelessWidget {
  final SafetyEventRecord event;

  const _EventItem({required this.event});

  @override
  Widget build(BuildContext context) {
    final eventIcon = _getEventIcon(event.event);
    final eventColor = _getEventColor(event.event);
    final timeStr =
        '${(event.timestamp / 1000).toStringAsFixed(0)}s';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(eventIcon, color: eventColor, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (event.hr != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'HR: ${event.hr} bpm (${event.intensityPercent}%)',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            timeStr,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getEventIcon(SafetyEvent event) {
    switch (event) {
      case SafetyEvent.hrInfoWarning:
        return Icons.info;
      case SafetyEvent.hrWarningWarning:
        return Icons.warning;
      case SafetyEvent.hrCritical:
        return Icons.error;
      case SafetyEvent.autoPauseTriggered:
        return Icons.pause_circle;
      case SafetyEvent.emergencyStop:
        return Icons.stop_circle;
      case SafetyEvent.hrMonitoringFailed:
        return Icons.bluetooth_disabled;
      case SafetyEvent.intensityWarning:
        return Icons.trending_up;
    }
  }

  Color _getEventColor(SafetyEvent event) {
    switch (event) {
      case SafetyEvent.hrInfoWarning:
        return Colors.blue;
      case SafetyEvent.hrWarningWarning:
        return Colors.orange;
      case SafetyEvent.hrCritical:
        return AppColors.error;
      case SafetyEvent.autoPauseTriggered:
        return AppColors.error;
      case SafetyEvent.emergencyStop:
        return AppColors.error;
      case SafetyEvent.hrMonitoringFailed:
        return Colors.grey;
      case SafetyEvent.intensityWarning:
        return Colors.orange;
    }
  }
}
