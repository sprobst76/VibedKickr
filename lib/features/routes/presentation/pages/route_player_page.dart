import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/gpx/gpx_route_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/gpx_route.dart';
import '../../../../providers/providers.dart';
import '../widgets/elevation_profile_chart.dart';

/// Seite zum Abspielen einer GPX Route
class RoutePlayerPage extends ConsumerStatefulWidget {
  final String? routeId;

  const RoutePlayerPage({super.key, this.routeId});

  @override
  ConsumerState<RoutePlayerPage> createState() => _RoutePlayerPageState();
}

class _RoutePlayerPageState extends ConsumerState<RoutePlayerPage> {
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRoute();
  }

  Future<void> _loadRoute() async {
    if (widget.routeId == null) {
      setState(() {
        _error = 'Keine Route angegeben';
        _isLoading = false;
      });
      return;
    }

    try {
      final service = ref.read(gpxRouteServiceProvider);
      final route = await service.getRoute(widget.routeId!);

      if (route == null) {
        setState(() {
          _error = 'Route nicht gefunden';
          _isLoading = false;
        });
        return;
      }

      ref.read(routePlayerProvider.notifier).loadRoute(route);
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _error = 'Fehler beim Laden: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerData = ref.watch(routePlayerProvider);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Route laden...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Fehler')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              Text(_error!, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Zurück'),
              ),
            ],
          ),
        ),
      );
    }

    final route = playerData.route;
    if (route == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Fehler')),
        body: const Center(child: Text('Keine Route geladen')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(route.name),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _handleExit(context, playerData.state),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Höhenprofil
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevationProfileChart(
                  route: route,
                  currentDistance: playerData.currentDistance,
                ),
              ),
            ),

            // Stats Grid
            Expanded(
              flex: 2,
              child: _StatsGrid(playerData: playerData, route: route),
            ),

            // Live Data (wenn verbunden)
            _LiveDataBar(),

            // Controls
            Padding(
              padding: const EdgeInsets.all(16),
              child: _PlayerControls(
                state: playerData.state,
                onStart: () => ref.read(routePlayerProvider.notifier).start(),
                onPause: () => ref.read(routePlayerProvider.notifier).pause(),
                onResume: () => ref.read(routePlayerProvider.notifier).resume(),
                onStop: () => _confirmStop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleExit(BuildContext context, RoutePlayerState state) {
    if (state == RoutePlayerState.running || state == RoutePlayerState.paused) {
      _confirmStop(context, andExit: true);
    } else {
      context.pop();
    }
  }

  Future<void> _confirmStop(BuildContext context, {bool andExit = false}) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Route beenden?'),
        content: const Text('Möchtest du die Route wirklich beenden?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Beenden'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(routePlayerProvider.notifier).stop();
      if (andExit && context.mounted) {
        context.pop();
      }
    }
  }
}

class _StatsGrid extends StatelessWidget {
  final RoutePlayerData playerData;
  final GpxRoute route;

  const _StatsGrid({required this.playerData, required this.route});

  @override
  Widget build(BuildContext context) {
    final progress = playerData.progress;
    final distanceKm = playerData.currentDistance / 1000;
    final remainingKm = playerData.remainingDistanceKm;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.surfaceLight,
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progress * 100).toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
              Text(
                'Noch ${remainingKm.toStringAsFixed(2)} km',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Stats
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.straighten,
                    label: 'Distanz',
                    value: '${distanceKm.toStringAsFixed(2)} km',
                    subValue: 'von ${route.totalDistanceKm.toStringAsFixed(1)} km',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.landscape,
                    label: 'Höhe',
                    value: '${playerData.currentElevation.round()} m',
                    subValue: '${route.minElevation.round()} - ${route.maxElevation.round()} m',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.trending_up,
                    label: 'Steigung',
                    value: '${playerData.currentGradient.toStringAsFixed(1)}%',
                    valueColor: _getGradientColor(playerData.currentGradient),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.timer_outlined,
                    label: 'Zeit',
                    value: _formatDuration(playerData.elapsed),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getGradientColor(double gradient) {
    if (gradient > 10) return AppColors.error;
    if (gradient > 5) return AppColors.warning;
    if (gradient > 0) return AppColors.success;
    return AppColors.primary; // Bergab = blau
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subValue;
  final Color? valueColor;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    this.subValue,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
          if (subValue != null) ...[
            const SizedBox(height: 2),
            Text(
              subValue!,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LiveDataBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveData = ref.watch(liveTrainingDataProvider);
    final playerData = ref.watch(routePlayerProvider);

    if (playerData.state != RoutePlayerState.running) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _LiveStat(
            label: 'Power',
            value: '${liveData.power}',
            unit: 'W',
            targetValue: playerData.currentTargetPower,
          ),
          _LiveStat(
            label: 'Kadenz',
            value: '${liveData.cadence ?? 0}',
            unit: 'rpm',
          ),
          _LiveStat(
            label: 'Speed',
            value: (liveData.speed ?? 0).toStringAsFixed(1),
            unit: 'km/h',
          ),
          if (liveData.heartRate != null)
            _LiveStat(
              label: 'HR',
              value: '${liveData.heartRate}',
              unit: 'bpm',
            ),
        ],
      ),
    );
  }
}

class _LiveStat extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final int? targetValue;

  const _LiveStat({
    required this.label,
    required this.value,
    required this.unit,
    this.targetValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textMuted,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              unit,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        if (targetValue != null) ...[
          Text(
            'Ziel: $targetValue W',
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

class _PlayerControls extends StatelessWidget {
  final RoutePlayerState state;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onStop;

  const _PlayerControls({
    required this.state,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case RoutePlayerState.idle:
      case RoutePlayerState.ready:
        return Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onStart,
                icon: const Icon(Icons.play_arrow, size: 28),
                label: const Text('Route starten'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        );

      case RoutePlayerState.running:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onStop,
                icon: const Icon(Icons.stop),
                label: const Text('Stop'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: onPause,
                icon: const Icon(Icons.pause, size: 28),
                label: const Text('Pause'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        );

      case RoutePlayerState.paused:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onStop,
                icon: const Icon(Icons.stop),
                label: const Text('Stop'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: onResume,
                icon: const Icon(Icons.play_arrow, size: 28),
                label: const Text('Fortsetzen'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        );

      case RoutePlayerState.finished:
        return Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.check),
                label: const Text('Fertig'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        );
    }
  }
}
