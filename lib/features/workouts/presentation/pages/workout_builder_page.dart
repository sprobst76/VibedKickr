import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/duration_formatter.dart';
import '../../../../domain/entities/workout.dart';
import '../../../../providers/providers.dart';

/// Workout Builder Seite zum Erstellen und Bearbeiten von Workouts
class WorkoutBuilderPage extends ConsumerStatefulWidget {
  final String? workoutId; // Null = neues Workout

  const WorkoutBuilderPage({super.key, this.workoutId});

  @override
  ConsumerState<WorkoutBuilderPage> createState() => _WorkoutBuilderPageState();
}

class _WorkoutBuilderPageState extends ConsumerState<WorkoutBuilderPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  WorkoutType _selectedType = WorkoutType.interval;
  List<WorkoutInterval> _intervals = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.workoutId != null) {
      _loadExistingWorkout();
    } else {
      // Standardmäßig Warmup und Cooldown hinzufügen
      _intervals = [
        const WorkoutInterval(
          name: 'Warmup',
          duration: Duration(minutes: 5),
          type: IntervalType.warmup,
          powerTarget: PowerTarget(type: PowerTargetType.ftpPercent, ftpPercent: 50),
        ),
        const WorkoutInterval(
          name: 'Cooldown',
          duration: Duration(minutes: 5),
          type: IntervalType.cooldown,
          powerTarget: PowerTarget(type: PowerTargetType.ftpPercent, ftpPercent: 40),
        ),
      ];
    }
  }

  Future<void> _loadExistingWorkout() async {
    // Versuche aus DB zu laden, falls es ein Custom Workout ist
    final db = ref.read(appDatabaseProvider);
    final workout = await db.workoutDao.getWorkout(widget.workoutId!);

    if (workout != null) {
      setState(() {
        _nameController.text = workout.name;
        _descriptionController.text = workout.description;
        _selectedType = workout.type;
        _intervals = List.from(workout.intervals);
      });
    } else {
      // Versuche vordefiniertes Workout zu finden
      final predefined = PredefinedWorkouts.all.where((w) => w.id == widget.workoutId).firstOrNull;
      if (predefined != null) {
        setState(() {
          _nameController.text = '${predefined.name} (Kopie)';
          _descriptionController.text = predefined.description;
          _selectedType = predefined.type;
          _intervals = List.from(predefined.intervals);
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(athleteProfileProvider);
    final ftp = profile.ftp;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workoutId != null ? 'Workout bearbeiten' : 'Neues Workout'),
        actions: [
          if (_intervals.isNotEmpty)
            TextButton.icon(
              onPressed: _isSaving ? null : _saveWorkout,
              icon: _isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: const Text('Speichern'),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Basis-Informationen
            _SectionHeader(title: 'Basis'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        hintText: 'z.B. Sweet Spot Training',
                        prefixIcon: Icon(Icons.title),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Bitte einen Namen eingeben';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Beschreibung',
                        hintText: 'Optional: Was trainiert dieses Workout?',
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<WorkoutType>(
                      value: _selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Typ',
                        prefixIcon: Icon(Icons.category),
                      ),
                      items: WorkoutType.values
                          .where((t) => t != WorkoutType.freeRide && t != WorkoutType.gpxRoute)
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(_workoutTypeLabel(type)),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedType = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Workout-Vorschau
            if (_intervals.isNotEmpty) ...[
              _SectionHeader(title: 'Vorschau'),
              _WorkoutPreview(intervals: _intervals, ftp: ftp),
              const SizedBox(height: 24),
            ],

            // Intervalle
            _SectionHeader(
              title: 'Intervalle (${_intervals.length})',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.library_add),
                    onPressed: _showTemplateDialog,
                    tooltip: 'Vorlage hinzufügen',
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle),
                    onPressed: () => _addInterval(null),
                    tooltip: 'Intervall hinzufügen',
                  ),
                ],
              ),
            ),
            if (_intervals.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.playlist_add,
                        size: 48,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Noch keine Intervalle',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => _addInterval(null),
                        icon: const Icon(Icons.add),
                        label: const Text('Intervall hinzufügen'),
                      ),
                    ],
                  ),
                ),
              )
            else
              ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _intervals.length,
                onReorder: _reorderIntervals,
                itemBuilder: (context, index) {
                  final interval = _intervals[index];
                  return _IntervalCard(
                    key: ValueKey('interval_$index'),
                    interval: interval,
                    index: index,
                    ftp: ftp,
                    onEdit: () => _editInterval(index),
                    onDelete: () => _deleteInterval(index),
                    onDuplicate: () => _duplicateInterval(index),
                  );
                },
              ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: _intervals.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _addInterval(null),
              icon: const Icon(Icons.add),
              label: const Text('Intervall'),
            )
          : null,
    );
  }

  String _workoutTypeLabel(WorkoutType type) {
    return switch (type) {
      WorkoutType.endurance => 'Ausdauer',
      WorkoutType.interval => 'Intervall',
      WorkoutType.hiit => 'HIIT',
      WorkoutType.tabata => 'Tabata',
      WorkoutType.pyramid => 'Pyramide',
      WorkoutType.ramp => 'Rampe',
      WorkoutType.ftpTest => 'FTP Test',
      WorkoutType.freeRide => 'Free Ride',
      WorkoutType.gpxRoute => 'GPX Route',
    };
  }

  void _addInterval(WorkoutInterval? template) {
    final newInterval = template ??
        const WorkoutInterval(
          name: 'Work',
          duration: Duration(minutes: 5),
          type: IntervalType.work,
          powerTarget: PowerTarget(type: PowerTargetType.ftpPercent, ftpPercent: 75),
        );

    // Füge vor dem Cooldown ein, falls vorhanden
    final cooldownIndex = _intervals.indexWhere((i) => i.type == IntervalType.cooldown);
    final insertIndex = cooldownIndex >= 0 ? cooldownIndex : _intervals.length;

    setState(() {
      _intervals.insert(insertIndex, newInterval);
    });
  }

  void _editInterval(int index) async {
    final result = await showModalBottomSheet<WorkoutInterval>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _IntervalEditor(
        interval: _intervals[index],
        ftp: ref.read(athleteProfileProvider).ftp,
      ),
    );

    if (result != null) {
      setState(() {
        _intervals[index] = result;
      });
    }
  }

  void _deleteInterval(int index) {
    setState(() {
      _intervals.removeAt(index);
    });
  }

  void _duplicateInterval(int index) {
    setState(() {
      _intervals.insert(index + 1, _intervals[index]);
    });
  }

  void _reorderIntervals(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _intervals.removeAt(oldIndex);
      _intervals.insert(newIndex, item);
    });
  }

  void _showTemplateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vorlage hinzufügen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TemplateOption(
              title: '30/30 Intervalle (5x)',
              description: '30s Work / 30s Rest',
              onTap: () {
                Navigator.pop(context);
                _addIntervalSet(5, 30, 30, 120, 50);
              },
            ),
            _TemplateOption(
              title: '1 Minute Intervalle (4x)',
              description: '1min Work / 1min Rest',
              onTap: () {
                Navigator.pop(context);
                _addIntervalSet(4, 60, 60, 100, 50);
              },
            ),
            _TemplateOption(
              title: 'Sweet Spot Block',
              description: '10min @ 90% FTP',
              onTap: () {
                Navigator.pop(context);
                _addInterval(const WorkoutInterval(
                  name: 'Sweet Spot',
                  duration: Duration(minutes: 10),
                  type: IntervalType.work,
                  powerTarget: PowerTarget(type: PowerTargetType.ftpPercent, ftpPercent: 90),
                ));
              },
            ),
            _TemplateOption(
              title: 'VO2max Block',
              description: '3min @ 120% FTP',
              onTap: () {
                Navigator.pop(context);
                _addInterval(const WorkoutInterval(
                  name: 'VO2max',
                  duration: Duration(minutes: 3),
                  type: IntervalType.work,
                  powerTarget: PowerTarget(type: PowerTargetType.ftpPercent, ftpPercent: 120),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addIntervalSet(int count, int workSeconds, int restSeconds, int workPercent, int restPercent) {
    final intervals = <WorkoutInterval>[];
    for (var i = 1; i <= count; i++) {
      intervals.add(WorkoutInterval(
        name: 'Work $i',
        duration: Duration(seconds: workSeconds),
        type: IntervalType.work,
        powerTarget: PowerTarget(type: PowerTargetType.ftpPercent, ftpPercent: workPercent),
      ));
      if (i < count || restSeconds > 0) {
        intervals.add(WorkoutInterval(
          name: 'Rest $i',
          duration: Duration(seconds: restSeconds),
          type: IntervalType.rest,
          powerTarget: PowerTarget(type: PowerTargetType.ftpPercent, ftpPercent: restPercent),
        ));
      }
    }

    // Vor Cooldown einfügen
    final cooldownIndex = _intervals.indexWhere((i) => i.type == IntervalType.cooldown);
    final insertIndex = cooldownIndex >= 0 ? cooldownIndex : _intervals.length;

    setState(() {
      _intervals.insertAll(insertIndex, intervals);
    });
  }

  Future<void> _saveWorkout() async {
    if (!_formKey.currentState!.validate()) return;
    if (_intervals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte mindestens ein Intervall hinzufügen')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final workout = Workout(
        id: widget.workoutId ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        type: _selectedType,
        intervals: _intervals,
        createdAt: DateTime.now(),
        isCustom: true,
      );

      final db = ref.read(appDatabaseProvider);

      if (widget.workoutId != null) {
        await db.workoutDao.updateWorkout(workout);
      } else {
        await db.workoutDao.insertWorkout(workout);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workout gespeichert!')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Speichern: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const _SectionHeader({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
              letterSpacing: 1,
            ),
          ),
          const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _WorkoutPreview extends StatelessWidget {
  final List<WorkoutInterval> intervals;
  final int ftp;

  const _WorkoutPreview({required this.intervals, required this.ftp});

  @override
  Widget build(BuildContext context) {
    final totalDuration = intervals.fold<Duration>(
      Duration.zero,
      (total, i) => total + i.duration,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _InfoChip(
                  icon: Icons.timer,
                  label: totalDuration.toDisplayString(),
                ),
                const SizedBox(width: 12),
                _InfoChip(
                  icon: Icons.repeat,
                  label: '${intervals.length} Intervalle',
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 60,
              child: _PowerChart(intervals: intervals, ftp: ftp),
            ),
          ],
        ),
      ),
    );
  }
}

class _PowerChart extends StatelessWidget {
  final List<WorkoutInterval> intervals;
  final int ftp;

  const _PowerChart({required this.intervals, required this.ftp});

  @override
  Widget build(BuildContext context) {
    final totalSeconds = intervals.fold<int>(
      0,
      (total, i) => total + i.duration.inSeconds,
    );

    if (totalSeconds == 0) return const SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: intervals.map((interval) {
          final widthFraction = interval.duration.inSeconds / totalSeconds;
          final targetWatts = interval.powerTarget.resolveWatts(ftp);
          final intensity = ftp > 0 ? (targetWatts / ftp).clamp(0.0, 2.0) : 0.5;
          final height = 20 + (intensity * 40);
          final color = _colorForIntensity(intensity);

          return Expanded(
            flex: (widthFraction * 1000).round().clamp(1, 1000),
            child: Container(
              height: height,
              margin: const EdgeInsets.symmetric(horizontal: 0.5),
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _colorForIntensity(double intensity) {
    if (intensity < 0.55) return ZoneColors.z1ActiveRecovery;
    if (intensity < 0.75) return ZoneColors.z2Endurance;
    if (intensity < 0.90) return ZoneColors.z3Tempo;
    if (intensity < 1.05) return ZoneColors.z4Threshold;
    if (intensity < 1.20) return ZoneColors.z5Vo2Max;
    if (intensity < 1.50) return ZoneColors.z6Anaerobic;
    return ZoneColors.z7Neuromuscular;
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textMuted),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

class _IntervalCard extends StatelessWidget {
  final WorkoutInterval interval;
  final int index;
  final int ftp;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;

  const _IntervalCard({
    super.key,
    required this.interval,
    required this.index,
    required this.ftp,
    required this.onEdit,
    required this.onDelete,
    required this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    final targetWatts = interval.powerTarget.resolveWatts(ftp);
    final intensity = ftp > 0 ? targetWatts / ftp : 0.0;
    final color = _colorForType(interval.type);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Drag Handle
              const Icon(Icons.drag_handle, color: AppColors.textMuted),
              const SizedBox(width: 8),

              // Type Indicator
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      interval.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          interval.duration.toDisplayString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _powerTargetLabel(interval.powerTarget, targetWatts, intensity),
                          style: TextStyle(
                            fontSize: 12,
                            color: color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              IconButton(
                icon: const Icon(Icons.copy, size: 18),
                onPressed: onDuplicate,
                tooltip: 'Duplizieren',
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18),
                onPressed: onDelete,
                tooltip: 'Löschen',
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _powerTargetLabel(PowerTarget target, int watts, double intensity) {
    return switch (target.type) {
      PowerTargetType.ftpPercent => '${target.ftpPercent}% FTP (${watts}W)',
      PowerTargetType.absolute => '${watts}W',
      PowerTargetType.range => '${target.minWatts}-${target.maxWatts}W',
      PowerTargetType.free => 'Frei',
    };
  }

  Color _colorForType(IntervalType type) {
    return switch (type) {
      IntervalType.warmup => ZoneColors.z1ActiveRecovery,
      IntervalType.work => ZoneColors.z4Threshold,
      IntervalType.rest => ZoneColors.z2Endurance,
      IntervalType.cooldown => ZoneColors.z1ActiveRecovery,
      IntervalType.freeRide => AppColors.primary,
    };
  }
}

class _TemplateOption extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const _TemplateOption({
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(description),
      trailing: const Icon(Icons.add_circle_outline),
      onTap: onTap,
    );
  }
}

/// Bottom Sheet zum Bearbeiten eines Intervalls
class _IntervalEditor extends ConsumerStatefulWidget {
  final WorkoutInterval interval;
  final int ftp;

  const _IntervalEditor({
    required this.interval,
    required this.ftp,
  });

  @override
  ConsumerState<_IntervalEditor> createState() => _IntervalEditorState();
}

class _IntervalEditorState extends ConsumerState<_IntervalEditor> {
  late TextEditingController _nameController;
  late IntervalType _type;
  late int _durationMinutes;
  late int _durationSeconds;
  late PowerTargetType _powerType;
  late int _ftpPercent;
  late int _absoluteWatts;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.interval.name);
    _type = widget.interval.type;
    _durationMinutes = widget.interval.duration.inMinutes;
    _durationSeconds = widget.interval.duration.inSeconds % 60;
    _powerType = widget.interval.powerTarget.type;
    _ftpPercent = widget.interval.powerTarget.ftpPercent ?? 75;
    _absoluteWatts = widget.interval.powerTarget.watts ?? 150;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final targetWatts = _powerType == PowerTargetType.ftpPercent
        ? (_ftpPercent * widget.ftp / 100).round()
        : _absoluteWatts;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 500),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(24),
          children: [
            // Header
            Row(
              children: [
                const Text(
                  'Intervall bearbeiten',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),

            // Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Typ
            DropdownButtonFormField<IntervalType>(
              value: _type,
              decoration: const InputDecoration(
                labelText: 'Typ',
                border: OutlineInputBorder(),
              ),
              items: IntervalType.values
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(_intervalTypeLabel(type)),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _type = value);
                }
              },
            ),
            const SizedBox(height: 16),

            // Dauer
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: _durationMinutes.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Minuten',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _durationMinutes = int.tryParse(value) ?? 0;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    initialValue: _durationSeconds.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Sekunden',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _durationSeconds = int.tryParse(value) ?? 0;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Power Target
            const Text(
              'Leistungsziel',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            SegmentedButton<PowerTargetType>(
              segments: const [
                ButtonSegment(
                  value: PowerTargetType.ftpPercent,
                  label: Text('% FTP'),
                ),
                ButtonSegment(
                  value: PowerTargetType.absolute,
                  label: Text('Watt'),
                ),
                ButtonSegment(
                  value: PowerTargetType.free,
                  label: Text('Frei'),
                ),
              ],
              selected: {_powerType},
              onSelectionChanged: (selected) {
                setState(() => _powerType = selected.first);
              },
            ),
            const SizedBox(height: 16),

            if (_powerType == PowerTargetType.ftpPercent) ...[
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _ftpPercent.toDouble(),
                      min: 30,
                      max: 200,
                      divisions: 34,
                      label: '$_ftpPercent%',
                      onChanged: (value) {
                        setState(() => _ftpPercent = value.round());
                      },
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(
                      '$_ftpPercent% FTP\n(${targetWatts}W)',
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ] else if (_powerType == PowerTargetType.absolute) ...[
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _absoluteWatts.toDouble(),
                      min: 50,
                      max: 500,
                      divisions: 45,
                      label: '${_absoluteWatts}W',
                      onChanged: (value) {
                        setState(() => _absoluteWatts = value.round());
                      },
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: Text(
                      '${_absoluteWatts}W',
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 24),

            // Save Button
            ElevatedButton(
              onPressed: () {
                final powerTarget = switch (_powerType) {
                  PowerTargetType.ftpPercent => PowerTarget.ftpPercent(_ftpPercent),
                  PowerTargetType.absolute => PowerTarget.absolute(_absoluteWatts),
                  PowerTargetType.free => PowerTarget.free(),
                  PowerTargetType.range => PowerTarget.free(),
                };

                final interval = widget.interval.copyWith(
                  name: _nameController.text.trim(),
                  duration: Duration(
                    minutes: _durationMinutes,
                    seconds: _durationSeconds,
                  ),
                  type: _type,
                  powerTarget: powerTarget,
                );

                Navigator.pop(context, interval);
              },
              child: const Text('Übernehmen'),
            ),
          ],
        ),
      ),
    );
  }

  String _intervalTypeLabel(IntervalType type) {
    return switch (type) {
      IntervalType.warmup => 'Warmup',
      IntervalType.work => 'Work',
      IntervalType.rest => 'Rest / Recovery',
      IntervalType.cooldown => 'Cooldown',
      IntervalType.freeRide => 'Free Ride',
    };
  }
}
