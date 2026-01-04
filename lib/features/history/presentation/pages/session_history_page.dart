import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/duration_formatter.dart';
import '../../../../domain/entities/training_session.dart';
import '../../../../providers/providers.dart';
import '../../../../routing/app_router.dart';

class SessionHistoryPage extends ConsumerWidget {
  const SessionHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(savedSessionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verlauf'),
      ),
      body: sessionsAsync.when(
        data: (sessions) {
          if (sessions.isEmpty) {
            return const _EmptyState();
          }
          return _SessionList(sessions: sessions);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text('Fehler beim Laden: $error'),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: AppColors.textMuted.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          const Text(
            'Keine Trainings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Beendete Workouts werden hier angezeigt',
            style: TextStyle(color: AppColors.textMuted),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go(AppRoutes.workouts),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Workout starten'),
          ),
        ],
      ),
    );
  }
}

class _SessionList extends StatelessWidget {
  final List<TrainingSession> sessions;

  const _SessionList({required this.sessions});

  @override
  Widget build(BuildContext context) {
    // Gruppiere Sessions nach Datum
    final grouped = <String, List<TrainingSession>>{};
    for (final session in sessions) {
      final dateKey = _formatDateHeader(session.startTime);
      grouped.putIfAbsent(dateKey, () => []).add(session);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final dateKey = grouped.keys.elementAt(index);
        final daySessions = grouped[dateKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 8, top: index > 0 ? 16 : 0),
              child: Text(
                dateKey,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            ...daySessions.map((session) => _SessionCard(session: session)),
          ],
        );
      },
    );
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final sessionDate = DateTime(date.year, date.month, date.day);

    if (sessionDate == today) {
      return 'Heute';
    } else if (sessionDate == yesterday) {
      return 'Gestern';
    } else {
      final weekdays = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
      final months = [
        'Jan', 'Feb', 'Mär', 'Apr', 'Mai', 'Jun',
        'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dez'
      ];
      return '${weekdays[date.weekday - 1]}, ${date.day}. ${months[date.month - 1]}';
    }
  }
}

class _SessionCard extends StatelessWidget {
  final TrainingSession session;

  const _SessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final stats = session.stats;
    final typeInfo = _getTypeInfo(session.type);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => context.push('${AppRoutes.history}/${session.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: typeInfo.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(typeInfo.icon, color: typeInfo.color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          typeInfo.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _formatTime(session.startTime),
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (stats != null) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${stats.tss} TSS',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          stats.duration.toDisplayString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),

              if (stats != null) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),

                // Stats Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(
                      label: 'Avg Power',
                      value: '${stats.avgPower}',
                      unit: 'W',
                    ),
                    _StatItem(
                      label: 'NP',
                      value: '${stats.normalizedPower}',
                      unit: 'W',
                    ),
                    _StatItem(
                      label: 'Max',
                      value: '${stats.maxPower}',
                      unit: 'W',
                    ),
                    _StatItem(
                      label: 'Arbeit',
                      value: '${stats.totalWork}',
                      unit: 'kJ',
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')} Uhr';
  }

  ({IconData icon, Color color, String name}) _getTypeInfo(SessionType type) {
    return switch (type) {
      SessionType.workout => (
          icon: Icons.fitness_center,
          color: ZoneColors.z4Threshold,
          name: 'Workout',
        ),
      SessionType.freeRide => (
          icon: Icons.explore,
          color: AppColors.primary,
          name: 'Free Ride',
        ),
      SessionType.ftpTest => (
          icon: Icons.assessment,
          color: ZoneColors.z5Vo2Max,
          name: 'FTP Test',
        ),
      SessionType.gpxRoute => (
          icon: Icons.terrain,
          color: ZoneColors.z3Tempo,
          name: 'GPX Route',
        ),
    };
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _StatItem({
    required this.label,
    required this.value,
    required this.unit,
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
        const SizedBox(height: 2),
        RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: ' $unit',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
