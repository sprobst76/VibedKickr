import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/ble/models/connection_state.dart';
import '../../../../core/utils/duration_formatter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../providers/providers.dart';
import '../../../../routing/app_router.dart';
import '../widgets/connection_status_bar.dart';
import '../widgets/live_chart.dart';
import '../widgets/power_gauge.dart';
import '../widgets/metric_card.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionState = ref.watch(bleConnectionStateProvider);
    final liveData = ref.watch(liveTrainingDataProvider);
    final profile = ref.watch(athleteProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kickr Trainer'),
        actions: [
          // Connection Status Button
          connectionState.when(
            data: (state) => _ConnectionButton(state: state),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Responsive Layout
            if (constraints.maxWidth > 900) {
              return _DesktopLayout(liveData: liveData, profile: profile);
            } else {
              return _MobileLayout(liveData: liveData, profile: profile);
            }
          },
        ),
      ),
    );
  }
}

class _ConnectionButton extends ConsumerWidget {
  final BleConnectionState state;

  const _ConnectionButton({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = switch (state.status) {
      ConnectionStatus.connected => AppColors.connected,
      ConnectionStatus.connecting => AppColors.scanning,
      ConnectionStatus.disconnected => AppColors.textMuted,
      ConnectionStatus.error => AppColors.error,
    };

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: IconButton(
        onPressed: () => context.push(AppRoutes.deviceScan),
        icon: Icon(
          state.isConnected ? Icons.bluetooth_connected : Icons.bluetooth,
          color: color,
        ),
        tooltip: state.isConnected
            ? 'Verbunden: ${state.device?.name}'
            : 'Gerät verbinden',
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final LiveTrainingData liveData;
  final dynamic profile;

  const _MobileLayout({required this.liveData, required this.profile});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Connection Status
          const ConnectionStatusBar(),
          const SizedBox(height: 16),

          // Power Gauge (groß)
          PowerGauge(
            power: liveData.power,
            zone: liveData.currentZone,
            targetPower: liveData.targetPower,
            ftp: profile.ftp,
          ),
          const SizedBox(height: 24),

          // Metriken Grid
          Row(
            children: [
              Expanded(
                child: MetricCard(
                  label: 'Kadenz',
                  value: liveData.cadence?.toString() ?? '--',
                  unit: 'rpm',
                  icon: Icons.sync,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricCard(
                  label: 'Herzfrequenz',
                  value: liveData.heartRate?.toString() ?? '--',
                  unit: 'bpm',
                  icon: Icons.favorite,
                  valueColor: liveData.heartRate != null
                      ? _hrColor(liveData.heartRate!, profile)
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: MetricCard(
                  label: 'Geschwindigkeit',
                  value: liveData.speed?.toStringAsFixed(1) ?? '--',
                  unit: 'km/h',
                  icon: Icons.speed,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricCard(
                  label: 'Zeit',
                  value: liveData.elapsed.toTimerString(),
                  unit: '',
                  icon: Icons.timer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Live Chart
          SizedBox(
            height: 200,
            child: LivePowerChart(
              powerHistory: liveData.powerHistory,
              targetPower: liveData.targetPower,
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  final LiveTrainingData liveData;
  final dynamic profile;

  const _DesktopLayout({required this.liveData, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Linke Spalte: Chart
          Expanded(
            flex: 3,
            child: Column(
              children: [
                const ConnectionStatusBar(),
                const SizedBox(height: 16),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: LivePowerChart(
                        powerHistory: liveData.powerHistory,
                        targetPower: liveData.targetPower,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),

          // Rechte Spalte: Metriken
          SizedBox(
            width: 300,
            child: Column(
              children: [
                // Power Gauge
                PowerGauge(
                  power: liveData.power,
                  zone: liveData.currentZone,
                  targetPower: liveData.targetPower,
                  ftp: profile.ftp,
                ),
                const SizedBox(height: 16),

                // Metriken
                MetricCard(
                  label: 'Kadenz',
                  value: liveData.cadence?.toString() ?? '--',
                  unit: 'rpm',
                  icon: Icons.sync,
                ),
                const SizedBox(height: 12),
                MetricCard(
                  label: 'Herzfrequenz',
                  value: liveData.heartRate?.toString() ?? '--',
                  unit: 'bpm',
                  icon: Icons.favorite,
                  valueColor: liveData.heartRate != null
                      ? _hrColor(liveData.heartRate!, profile)
                      : null,
                ),
                const SizedBox(height: 12),
                MetricCard(
                  label: 'Geschwindigkeit',
                  value: liveData.speed?.toStringAsFixed(1) ?? '--',
                  unit: 'km/h',
                  icon: Icons.speed,
                ),
                const SizedBox(height: 12),
                MetricCard(
                  label: 'Trainingszeit',
                  value: liveData.elapsed.toTimerString(),
                  unit: '',
                  icon: Icons.timer,
                ),
                const Spacer(),

                // Quick Start Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => context.push(AppRoutes.workouts),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Workout starten'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Color _hrColor(int hr, dynamic profile) {
  if (profile.hrZones == null) return AppColors.textPrimary;
  final zone = profile.hrZones!.zoneForHr(hr);
  return ZoneColors.forZone(zone);
}
