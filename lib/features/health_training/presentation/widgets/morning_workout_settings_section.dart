import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/notification_service.dart';
import '../../../../core/theme/app_theme.dart';

/// Settings-Bereich für die Morgen-Training Benachrichtigungen
class MorningWorkoutSettingsSection extends ConsumerStatefulWidget {
  const MorningWorkoutSettingsSection({super.key});

  @override
  ConsumerState<MorningWorkoutSettingsSection> createState() =>
      _MorningWorkoutSettingsSectionState();
}

class _MorningWorkoutSettingsSectionState
    extends ConsumerState<MorningWorkoutSettingsSection> {
  bool _enabled = false;
  TimeOfDay _time = const TimeOfDay(hour: 6, minute: 30);
  List<int> _days = [1, 2, 3, 4, 5]; // Mo-Fr
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await NotificationService.getSettings();
    if (mounted) {
      setState(() {
        _enabled = settings.enabled;
        _time = settings.time;
        _days = List.from(settings.daysOfWeek);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.notifications_active,
                    size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text(
                  'Erinnerung',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Switch(
                  value: _enabled,
                  onChanged: _toggleEnabled,
                ),
              ],
            ),
            if (_enabled) ...[
              const SizedBox(height: 12),
              // Zeitauswahl
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.access_time, size: 20),
                title: const Text(
                  'Erinnerungszeit',
                  style: TextStyle(fontSize: 13),
                ),
                trailing: TextButton(
                  onPressed: _selectTime,
                  child: Text(
                    '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')} Uhr',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Tagesauswahl
              const SizedBox(height: 4),
              const Text(
                'Trainingstage',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 8),
              _DaySelector(
                selectedDays: _days,
                onChanged: _updateDays,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _toggleEnabled(bool enabled) async {
    setState(() => _enabled = enabled);

    if (enabled) {
      final granted = await NotificationService.requestPermission();
      if (!granted) {
        if (mounted) {
          setState(() => _enabled = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Benachrichtigungsberechtigung nicht erteilt'),
            ),
          );
        }
        return;
      }
      await NotificationService.scheduleMorningReminder(
        time: _time,
        daysOfWeek: _days,
      );
    } else {
      await NotificationService.cancelMorningReminder();
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    if (picked != null && mounted) {
      setState(() => _time = picked);
      if (_enabled) {
        await NotificationService.scheduleMorningReminder(
          time: _time,
          daysOfWeek: _days,
        );
      }
    }
  }

  Future<void> _updateDays(List<int> days) async {
    setState(() => _days = days);
    if (_enabled && _days.isNotEmpty) {
      await NotificationService.scheduleMorningReminder(
        time: _time,
        daysOfWeek: _days,
      );
    } else if (_days.isEmpty) {
      await NotificationService.cancelMorningReminder();
      setState(() => _enabled = false);
    }
  }
}

/// Wochentag-Auswahl als Chips
class _DaySelector extends StatelessWidget {
  final List<int> selectedDays;
  final ValueChanged<List<int>> onChanged;

  const _DaySelector({
    required this.selectedDays,
    required this.onChanged,
  });

  static const _dayLabels = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: List.generate(7, (index) {
        final day = index + 1; // 1=Mo..7=So
        final isSelected = selectedDays.contains(day);

        return FilterChip(
          label: Text(
            _dayLabels[index],
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          selected: isSelected,
          onSelected: (selected) {
            final newDays = List<int>.from(selectedDays);
            if (selected) {
              newDays.add(day);
            } else {
              newDays.remove(day);
            }
            newDays.sort();
            onChanged(newDays);
          },
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      }),
    );
  }
}
