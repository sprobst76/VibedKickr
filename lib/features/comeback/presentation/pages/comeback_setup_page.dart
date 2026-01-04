import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/comeback_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/comeback_mode.dart';
import '../../../../providers/providers.dart';

/// Seite zum Einrichten des Comeback Mode
class ComebackSetupPage extends ConsumerStatefulWidget {
  const ComebackSetupPage({super.key});

  @override
  ConsumerState<ComebackSetupPage> createState() => _ComebackSetupPageState();
}

class _ComebackSetupPageState extends ConsumerState<ComebackSetupPage> {
  DateTime? _illnessStartDate;
  int? _restingHeartRate;
  String? _illnessType;
  final _hrController = TextEditingController();

  final List<String> _illnessTypes = [
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
    final comebackMode = ref.watch(comebackModeProvider);
    final athleteProfile = ref.watch(athleteProfileProvider);

    if (comebackMode.isActive) {
      return _ActiveComebackView(comebackMode: comebackMode);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comeback starten'),
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
                        'Was ist Comeback Mode?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Nach einer Krankheit oder längeren Pause ist dein Körper '
                    'noch nicht wieder voll belastbar. Der Comeback Mode hilft dir:\n\n'
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

            // 4-Wochen Plan
            const Text(
              '4-Wochen Ramp-Up Plan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildWeekCard(ComebackPhase.week1),
            _buildWeekCard(ComebackPhase.week2),
            _buildWeekCard(ComebackPhase.week3),
            _buildWeekCard(ComebackPhase.week4),
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
              title: const Text('Dein FTP vor der Pause'),
              subtitle: Text('${athleteProfile.ftp} Watt'),
              trailing: const Icon(Icons.check, color: AppColors.success),
              tileColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 12),

            // Krankheitsart
            ListTile(
              leading: const Icon(Icons.local_hospital),
              title: const Text('Art der Pause'),
              subtitle: Text(_illnessType ?? 'Auswählen'),
              trailing: const Icon(Icons.chevron_right),
              tileColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              onTap: () => _showIllnessTypePicker(),
            ),
            const SizedBox(height: 12),

            // Krankheitsbeginn
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Beginn der Pause'),
              subtitle: Text(_illnessStartDate != null
                  ? '${_illnessStartDate!.day}.${_illnessStartDate!.month}.${_illnessStartDate!.year}'
                  : 'Datum auswählen (optional)'),
              trailing: const Icon(Icons.chevron_right),
              tileColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              onTap: () => _selectDate(),
            ),
            const SizedBox(height: 12),

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
                onPressed: _startComeback,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Comeback starten'),
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

  Widget _buildWeekCard(ComebackPhase phase) {
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

  void _showIllnessTypePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Art der Pause',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ..._illnessTypes.map(
              (type) => ListTile(
                title: Text(type),
                trailing: _illnessType == type
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  setState(() => _illnessType = type);
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
      initialDate: _illnessStartDate ?? DateTime.now().subtract(const Duration(days: 7)),
      firstDate: DateTime.now().subtract(const Duration(days: 60)),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => _illnessStartDate = date);
    }
  }

  void _startComeback() {
    final athleteProfile = ref.read(athleteProfileProvider);

    ref.read(comebackModeProvider.notifier).startComeback(
          originalFtp: athleteProfile.ftp,
          baselineRestingHr: _restingHeartRate,
          illnessStartDate: _illnessStartDate,
          illnessType: _illnessType,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Comeback Mode aktiviert! Gute Besserung!'),
        backgroundColor: AppColors.success,
      ),
    );

    context.pop();
  }
}

class _ActiveComebackView extends ConsumerWidget {
  final ComebackMode comebackMode;

  const _ActiveComebackView({required this.comebackMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workouts = ref.watch(comebackWorkoutsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comeback Mode'),
        actions: [
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: () => _confirmEndComeback(context, ref),
            tooltip: 'Comeback beenden',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            _StatusCard(comebackMode: comebackMode),
            const SizedBox(height: 24),

            // Wellness History
            const Text(
              'Wellness Verlauf',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _WellnessHistory(checkIns: comebackMode.checkIns),
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
                    subtitle: Text(workout.description ?? ''),
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

  void _confirmEndComeback(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Comeback beenden?'),
        content: const Text(
          'Bist du sicher, dass du den Comeback Mode vorzeitig beenden möchtest? '
          'Dein Fortschritt wird gelöscht.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              ref.read(comebackModeProvider.notifier).endComeback();
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
  final ComebackMode comebackMode;

  const _StatusCard({required this.comebackMode});

  @override
  Widget build(BuildContext context) {
    final phase = comebackMode.currentPhase;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Phase Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ComebackPhase.values
                  .where((p) => p != ComebackPhase.completed)
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
              value: comebackMode.progressPercent / 100,
              minHeight: 8,
              backgroundColor: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              'Tag ${comebackMode.daysSinceStart + 1} von 28 - ${phase.description}',
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
                  value: '${comebackMode.originalFtp} W',
                ),
                _StatColumn(
                  label: 'Aktueller FTP',
                  value: '${comebackMode.effectiveFtp} W',
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
  final ComebackPhase phase;
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
