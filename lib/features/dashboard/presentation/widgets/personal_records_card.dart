import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/daos/personal_record_dao.dart';
import '../../../../core/database/tables/personal_record_table.dart';
import '../../../../core/services/personal_record_service.dart';
import '../../../../core/theme/app_theme.dart';

/// Kompakte Anzeige der Personal Records im Dashboard
class PersonalRecordsCard extends ConsumerWidget {
  const PersonalRecordsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(currentRecordsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Personal Records',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMuted,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _showAllRecords(context, ref),
                  child: const Text('Alle', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            recordsAsync.when(
              data: (records) {
                if (records.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Noch keine PRs - absolviere ein Training!',
                        style: TextStyle(color: AppColors.textMuted),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                // Zeige die wichtigsten PRs (5s, 1min, 5min, 20min)
                final keyTypes = [
                  RecordType.peak5s,
                  RecordType.peak1min,
                  RecordType.peak5min,
                  RecordType.peak20min,
                ];

                return Row(
                  children: keyTypes.map((type) {
                    final record = records[type];
                    return Expanded(
                      child: _RecordTile(
                        type: type,
                        record: record,
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Fehler: $e'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAllRecords(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const _AllRecordsSheet(),
    );
  }
}

class _RecordTile extends StatelessWidget {
  final RecordType type;
  final PersonalRecord? record;

  const _RecordTile({
    required this.type,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          type.displayName,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          record != null ? '${record!.powerWatts}' : '--',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: record != null ? AppColors.textPrimary : AppColors.textMuted,
          ),
        ),
        const Text(
          'W',
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// Bottom Sheet mit allen Personal Records
class _AllRecordsSheet extends ConsumerWidget {
  const _AllRecordsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(currentRecordsProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.emoji_events, color: Colors.amber, size: 24),
              SizedBox(width: 8),
              Text(
                'Alle Personal Records',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          recordsAsync.when(
            data: (records) {
              if (records.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text(
                      'Noch keine Personal Records vorhanden.\n'
                      'Absolviere ein Training, um deine ersten PRs aufzustellen!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  ),
                );
              }

              return Column(
                children: RecordType.values.map((type) {
                  final record = records[type];
                  return _RecordRow(type: type, record: record);
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Fehler: $e')),
          ),
        ],
      ),
    );
  }
}

class _RecordRow extends StatelessWidget {
  final RecordType type;
  final PersonalRecord? record;

  const _RecordRow({
    required this.type,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 80,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: record != null
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              type.displayName,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: record != null ? AppColors.primary : AppColors.textMuted,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: record != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${record!.powerWatts} W',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatDate(record!.achievedAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  )
                : const Text(
                    '--',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
          ),
          if (record?.improvement != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '+${record!.improvement}W',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.success,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) return 'Heute';
    if (diff.inDays == 1) return 'Gestern';
    if (diff.inDays < 7) return 'Vor ${diff.inDays} Tagen';

    return '${date.day}.${date.month}.${date.year}';
  }
}
