import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/health_mode_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/health_mode.dart';
import '../../../../providers/providers.dart';
import '../widgets/health_warning_banner.dart';
import '../widgets/phase_readiness_card.dart';
import '../widgets/wellness_trend_chart.dart';

/// Seite zum Einrichten des Gesundheitsmodus
class HealthModeSetupPage extends ConsumerStatefulWidget {
  const HealthModeSetupPage({super.key});

  @override
  ConsumerState<HealthModeSetupPage> createState() => _HealthModeSetupPageState();
}

class _HealthModeSetupPageState extends ConsumerState<HealthModeSetupPage> {
  DateTime? _pauseStartDate;
  int? _restingHeartRate;
  String? _pauseReason;
  HealthModeUseCase? _selectedUseCase;
  final _hrController = TextEditingController();

  final List<String> _pauseReasons = [
    'Erkältung',
    'Grippe',
    'COVID-19',
    'Magen-Darm',
    'Verletzung',
    'Übertraining',
    'Sonstiges',
  ];

  @override
  void dispose() {
    _hrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final healthMode = ref.watch(healthModeProvider);
    final athleteProfile = ref.watch(athleteProfileProvider);

    if (healthMode.isActive) {
      return _ActiveHealthModeView(healthMode: healthMode);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gesundheitsmodus starten'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                children: const [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'Was ist der Gesundheitsmodus?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Der Gesundheitsmodus hilft dir bei verschiedenen Trainingspausen '
                    'und gesundheitlichen Situationen:\n\n'
                    '• Langsam und sicher wieder einzusteigen\n'
                    '• Deine Fitness über 4 Wochen aufzubauen\n'
                    '• Übertraining zu vermeiden\n'
                    '• Tägliche Wellness-Checks durchzuführen',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Use Case Selection
            const Text(
              'Dein Anwendungsfall',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildUseCaseRadio(
              HealthModeUseCase.comebackAfterIllness,
              'Comeback nach Krankheit',
              'Rückkehr nach Krankheit oder längerer Pause',
            ),
            const SizedBox(height: 8),
            _buildUseCaseRadio(
              HealthModeUseCase.overtrainingPrevention,
              'Prävention & Wellness',
              'Optimierung deiner Gesundheit und Leistung',
            ),
            const SizedBox(height: 24),

            // 4-Wochen Plan
            const Text(
              '4-Wochen Ramp-Up Plan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildWeekCard(ComebackProtocolPhase.week1),
            _buildWeekCard(ComebackProtocolPhase.week2),
            _buildWeekCard(ComebackProtocolPhase.week3),
            _buildWeekCard(ComebackProtocolPhase.week4),
            const SizedBox(height: 24),

            // Einstellungen
            const Text(
              'Deine Angaben',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Aktueller FTP
            ListTile(
              leading: const Icon(Icons.speed),
              title: const Text('Dein FTP'),
              subtitle: Text('${athleteProfile.ftp} Watt'),
              trailing: const Icon(Icons.check, color: AppColors.success),
              tileColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 12),

            // Pausengrund (only for Comeback)
            if (_selectedUseCase == HealthModeUseCase.comebackAfterIllness) ...[
              ListTile(
                leading: const Icon(Icons.local_hospital),
                title: const Text('Grund der Pause'),
                subtitle: Text(_pauseReason ?? 'Auswählen'),
                trailing: const Icon(Icons.chevron_right),
                tileColor: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onTap: () => _showPauseReasonPicker(),
              ),
              const SizedBox(height: 12),

              // Pausenbeginn (only for Comeback)
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Beginn der Pause'),
                subtitle: Text(_pauseStartDate != null
                    ? '${_pauseStartDate!.day}.${_pauseStartDate!.month}.${_pauseStartDate!.year}'
                    : 'Datum auswählen (optional)'),
                trailing: const Icon(Icons.chevron_right),
                tileColor: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onTap: () => _selectDate(),
              ),
              const SizedBox(height: 12),
            ],

            // Ruhepuls
            ListTile(
              leading: const Icon(Icons.favorite, color: AppColors.error),
              title: const Text('Normaler Ruhepuls'),
              subtitle: TextField(
                controller: _hrController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'z.B. 55 bpm (optional)',
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (v) {
                  setState(() {
                    _restingHeartRate = int.tryParse(v);
                  });
                },
              ),
              tileColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 32),

            // Start Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _selectedUseCase != null ? _startHealthMode : null,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Gesundheitsmodus starten'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildUseCaseRadio(
    HealthModeUseCase useCase,
    String title,
    String subtitle,
  ) {
    return Card(
      child: RadioListTile<HealthModeUseCase>(
        value: useCase,
        groupValue: _selectedUseCase,
        onChanged: (value) {
          setState(() => _selectedUseCase = value);
        },
        title: Text(title),
        subtitle: Text(subtitle),
        tileColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildWeekCard(ComebackProtocolPhase phase) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Text(
            '${phase.index + 1}',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(phase.label),
        subtitle: Text(phase.description),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${(phase.intensityFactor * 100).round()}%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Text(
              '${phase.maxDurationMinutes} min',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPauseReasonPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Grund der Pause',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ..._pauseReasons.map(
              (reason) => ListTile(
                title: Text(reason),
                trailing: _pauseReason == reason
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  setState(() => _pauseReason = reason);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _pauseStartDate ?? DateTime.now().subtract(const Duration(days: 7)),
      firstDate: DateTime.now().subtract(const Duration(days: 60)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            useMaterial3: true,
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 8,
              headerBackgroundColor: AppColors.primary,
              headerForegroundColor: Colors.white,
              weekdayStyle: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              dayStyle: const TextStyle(color: AppColors.textPrimary),
              yearStyle: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
          child: child ?? const SizedBox(),
        );
      },
    );
    if (date != null) {
      setState(() => _pauseStartDate = date);
    }
  }

  void _startHealthMode() {
    final athleteProfile = ref.read(athleteProfileProvider);

    ref.read(healthModeProvider.notifier).startHealthMode(
          useCase: _selectedUseCase!,
          originalFtp: athleteProfile.ftp,
          baselineRestingHr: _restingHeartRate,
          pauseStartDate: _pauseStartDate,
          pauseReason: _pauseReason,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gesundheitsmodus aktiviert!'),
        backgroundColor: AppColors.success,
      ),
    );

    context.pop();
  }
}

class _ActiveHealthModeView extends ConsumerWidget {
  final HealthMode healthMode;

  const _ActiveHealthModeView({required this.healthMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workouts = ref.watch(healthModeWorkoutsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gesundheitsmodus'),
        actions: [
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: () => _confirmEndHealthMode(context, ref),
            tooltip: 'Gesundheitsmodus beenden',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            _StatusCard(healthMode: healthMode),
            const SizedBox(height: 24),

            // Health Warnings
            const HealthWarningBanner(),
            const SizedBox(height: 24),

            // FTP Suggestion Card
            if (healthMode.hasFtpSuggestion) ...[
              _FtpSuggestionCard(healthMode: healthMode),
              const SizedBox(height: 24),
            ],

            // Wellness History
            const Text(
              'Wellness Verlauf',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _WellnessHistory(checkIns: healthMode.checkIns),
            const SizedBox(height: 24),

            // Wellness Trend Chart
            if (healthMode.checkIns.length >= 2) ...[
              WellnessTrendChart(
                checkIns: healthMode.checkIns,
                height: 180,
              ),
              const SizedBox(height: 24),
            ],

            // Phase Readiness
            PhaseReadinessCard(healthMode: healthMode),
            const SizedBox(height: 24),

            // Empfohlene Workouts
            const Text(
              'Empfohlene Workouts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...workouts.map((workout) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.fitness_center,
                        color: AppColors.primary),
                    title: Text(workout.name),
                    subtitle: Text(workout.description),
                    trailing: Text(
                      '${workout.totalDuration.inMinutes} min',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      // TODO: Start workout
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _confirmEndHealthMode(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gesundheitsmodus beenden?'),
        content: const Text(
          'Bist du sicher, dass du den Gesundheitsmodus vorzeitig beenden möchtest? '
          'Dein Fortschritt wird gelöscht.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              ref.read(healthModeProvider.notifier).endHealthMode();
              Navigator.pop(context);
              context.pop();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Beenden'),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final HealthMode healthMode;

  const _StatusCard({required this.healthMode});

  @override
  Widget build(BuildContext context) {
    final phase = healthMode.currentPhase;

    // Only show for Comeback use case
    if (!healthMode.useCase.hasPhases || phase == null) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Phase Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ComebackProtocolPhase.values
                  .where((p) => p != ComebackProtocolPhase.completed)
                  .map((p) => _PhaseIndicator(
                        phase: p,
                        isActive: p == phase,
                        isCompleted: p.index < phase.index,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),

            // Progress
            LinearProgressIndicator(
              value: healthMode.progressPercent / 100,
              minHeight: 8,
              backgroundColor: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              'Tag ${healthMode.daysSinceStart + 1} von 28 - ${phase.description}',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),

            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatColumn(
                  label: 'Original FTP',
                  value: '${healthMode.originalFtp} W',
                ),
                _StatColumn(
                  label: 'Aktueller FTP',
                  value: '${healthMode.effectiveFtp} W',
                  highlight: true,
                ),
                _StatColumn(
                  label: 'Intensität',
                  value: '${(phase.intensityFactor * 100).round()}%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PhaseIndicator extends StatelessWidget {
  final ComebackProtocolPhase phase;
  final bool isActive;
  final bool isCompleted;

  const _PhaseIndicator({
    required this.phase,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? AppColors.primary
                : isCompleted
                    ? AppColors.success
                    : AppColors.surfaceLight,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : Text(
                    '${phase.index + 1}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.white : AppColors.textMuted,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'W${phase.index + 1}',
          style: TextStyle(
            fontSize: 11,
            color: isActive ? AppColors.primary : AppColors.textMuted,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _StatColumn({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: highlight ? AppColors.primary : null,
          ),
        ),
      ],
    );
  }
}

class _WellnessHistory extends StatelessWidget {
  final List<WellnessCheckIn> checkIns;

  const _WellnessHistory({required this.checkIns});

  @override
  Widget build(BuildContext context) {
    if (checkIns.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'Noch keine Check-Ins.\nMache heute deinen ersten!',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      );
    }

    final recentCheckIns = checkIns.reversed.take(7).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: recentCheckIns.map((checkIn) {
        final dayName = _getDayName(checkIn.date);
        return Column(
          children: [
            Text(
              dayName,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getScoreColor(checkIn.normalizedScore),
              ),
              child: Center(
                child: Text(
                  '${checkIn.normalizedScore.round()}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  String _getDayName(DateTime date) {
    const days = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
    return days[date.weekday - 1];
  }

  Color _getScoreColor(double score) {
    if (score >= 75) return AppColors.success;
    if (score >= 50) return AppColors.primary;
    if (score >= 25) return AppColors.warning;
    return AppColors.error;
  }
}

class _FtpSuggestionCard extends ConsumerWidget {
  final HealthMode healthMode;

  const _FtpSuggestionCard({required this.healthMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final increase = healthMode.suggestedFtpIncrease;
    final method = healthMode.ftpDetectionMethod;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      color: AppColors.success.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_up, color: AppColors.success),
                const SizedBox(width: 8),
                const Text(
                  'FTP-Verbesserung erkannt!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Deine Performance deutet auf einen höheren FTP hin. '
              'Erkannt durch ${_getMethodLabel(method)}.',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Aktueller FTP',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                    Text(
                      '${healthMode.effectiveFtp} W',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward, color: AppColors.textMuted),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Vorgeschlagener FTP',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                    Text(
                      '${healthMode.detectedFtp} W (+$increase)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ref
                          .read(healthModeProvider.notifier)
                          .dismissFtpSuggestion();
                    },
                    child: const Text('Ignorieren'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ref
                          .read(healthModeProvider.notifier)
                          .acceptFtpSuggestion();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('FTP aktualisiert!'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                    ),
                    child: const Text('FTP aktualisieren'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getMethodLabel(String? method) {
    return switch (method) {
      '20min' => '20-Minuten-Test',
      'sweetspot' => 'Sweet-Spot-Analyse',
      'normalized' => 'Normalized-Power-Trend',
      _ => 'Workout-Analyse',
    };
  }
}
