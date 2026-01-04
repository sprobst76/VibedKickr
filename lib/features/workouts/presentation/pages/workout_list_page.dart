import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/duration_formatter.dart';
import '../../../../domain/entities/workout.dart';
import '../../../../domain/entities/training_session.dart';
import '../../../../providers/providers.dart';
import '../../../../routing/app_router.dart';

/// Provider für benutzerdefinierte Workouts
final customWorkoutsProvider = StreamProvider<List<Workout>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.workoutDao.watchAllWorkouts();
});

class WorkoutListPage extends ConsumerWidget {
  const WorkoutListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(athleteProfileProvider);
    final customWorkoutsAsync = ref.watch(customWorkoutsProvider);
    final predefinedWorkouts = PredefinedWorkouts.all;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push(AppRoutes.workoutBuilder),
            tooltip: 'Neues Workout',
          ),
        ],
      ),
      body: customWorkoutsAsync.when(
        data: (customWorkouts) {
          final allWorkouts = [...customWorkouts, ...predefinedWorkouts];
          final hasCustom = customWorkouts.isNotEmpty;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: allWorkouts.length + (hasCustom ? 2 : 1), // +1 Free Ride, +1 Header
            itemBuilder: (context, index) {
              if (index == 0) {
                return _FreeRideCard(
                  onTap: () => _startFreeRide(context, ref),
                );
              }

              // Custom Workouts Sektion
              if (hasCustom && index == 1) {
                return const _SectionHeader(title: 'Meine Workouts');
              }

              // Offset für Custom Workouts
              final workoutIndex = index - (hasCustom ? 2 : 1);

              // Custom Workouts zuerst
              if (hasCustom && workoutIndex < customWorkouts.length) {
                final workout = customWorkouts[workoutIndex];
                return _WorkoutCard(
                  workout: workout,
                  ftp: profile.ftp,
                  isCustom: true,
                  onTap: () => context.push(
                    '${AppRoutes.workoutPlayer}?workoutId=${workout.id}',
                  ),
                  onEdit: () => context.push(
                    '${AppRoutes.workoutBuilder}?workoutId=${workout.id}',
                  ),
                  onDelete: () => _confirmDelete(context, ref, workout),
                );
              }

              // Predefined Header
              final predefinedIndex = workoutIndex - customWorkouts.length;
              if (hasCustom && predefinedIndex == 0) {
                return const _SectionHeader(title: 'Vordefinierte Workouts');
              }

              // Predefined Workouts
              final realPredefinedIndex = hasCustom ? predefinedIndex - 1 : workoutIndex;
              if (realPredefinedIndex >= 0 && realPredefinedIndex < predefinedWorkouts.length) {
                final workout = predefinedWorkouts[realPredefinedIndex];
                return _WorkoutCard(
                  workout: workout,
                  ftp: profile.ftp,
                  onTap: () => context.push(
                    '${AppRoutes.workoutPlayer}?workoutId=${workout.id}',
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
      ),
    );
  }

  void _startFreeRide(BuildContext context, WidgetRef ref) {
    ref.read(activeSessionProvider.notifier).startSession(
          type: SessionType.freeRide,
        );
    context.push(AppRoutes.workoutPlayer);
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, Workout workout) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Workout löschen?'),
        content: Text('Möchtest du "${workout.name}" wirklich löschen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final db = ref.read(appDatabaseProvider);
      await db.workoutDao.deleteWorkout(workout.id);
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 16, bottom: 8),
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

class _FreeRideCard extends StatelessWidget {
  final VoidCallback onTap;

  const _FreeRideCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.2),
                AppColors.primaryDark.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.explore,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Free Ride',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Frei fahren ohne Vorgaben',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textMuted,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  final Workout workout;
  final int ftp;
  final VoidCallback onTap;
  final bool isCustom;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _WorkoutCard({
    required this.workout,
    required this.ftp,
    required this.onTap,
    this.isCustom = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final duration = workout.totalDuration;
    final tss = workout.estimateTss(ftp);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _WorkoutTypeIcon(type: workout.type),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                workout.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (isCustom) ...[
                              IconButton(
                                icon: const Icon(Icons.edit, size: 18),
                                onPressed: onEdit,
                                tooltip: 'Bearbeiten',
                                visualDensity: VisualDensity.compact,
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 18),
                                onPressed: onDelete,
                                tooltip: 'Löschen',
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ],
                        ),
                        if (workout.description.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            workout.description,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Stats Row
              Row(
                children: [
                  _StatChip(
                    icon: Icons.timer_outlined,
                    label: duration.toDisplayString(),
                  ),
                  const SizedBox(width: 12),
                  _StatChip(
                    icon: Icons.local_fire_department_outlined,
                    label: '$tss TSS',
                  ),
                  const SizedBox(width: 12),
                  _StatChip(
                    icon: Icons.repeat,
                    label: '${workout.intervals.length} Intervalle',
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Workout Preview Bar
              _WorkoutPreviewBar(workout: workout, ftp: ftp),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkoutTypeIcon extends StatelessWidget {
  final WorkoutType type;

  const _WorkoutTypeIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (type) {
      WorkoutType.endurance => (Icons.trending_flat, ZoneColors.z2Endurance),
      WorkoutType.interval => (Icons.show_chart, ZoneColors.z4Threshold),
      WorkoutType.hiit => (Icons.flash_on, ZoneColors.z5Vo2Max),
      WorkoutType.tabata => (Icons.timer, ZoneColors.z6Anaerobic),
      WorkoutType.ftpTest => (Icons.assessment, ZoneColors.z4Threshold),
      WorkoutType.pyramid => (Icons.signal_cellular_alt, ZoneColors.z3Tempo),
      WorkoutType.ramp => (Icons.trending_up, ZoneColors.z4Threshold),
      WorkoutType.freeRide => (Icons.explore, AppColors.primary),
      WorkoutType.gpxRoute => (Icons.terrain, AppColors.primary),
    };

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textMuted),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutPreviewBar extends StatelessWidget {
  final Workout workout;
  final int ftp;

  const _WorkoutPreviewBar({required this.workout, required this.ftp});

  @override
  Widget build(BuildContext context) {
    final totalDuration = workout.totalDuration.inSeconds;

    return Container(
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: AppColors.surfaceLight,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Row(
          children: workout.intervals.map((interval) {
            final widthFraction = interval.duration.inSeconds / totalDuration;
            final targetWatts = interval.powerTarget.resolveWatts(ftp);
            final intensity = ftp > 0 ? (targetWatts / ftp).clamp(0.0, 2.0) : 0.5;

            // Farbe basierend auf Intensität
            final color = _colorForIntensity(intensity);

            return Expanded(
              flex: (widthFraction * 1000).round(),
              child: Container(
                color: color,
                child: interval.duration.inSeconds > 120
                    ? Center(
                        child: Text(
                          '${(intensity * 100).round()}%',
                          style: TextStyle(
                            fontSize: 9,
                            color: intensity > 0.8
                                ? Colors.white
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
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
