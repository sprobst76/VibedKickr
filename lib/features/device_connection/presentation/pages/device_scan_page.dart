import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/ble/models/ble_device.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../providers/providers.dart';

class DeviceScanPage extends ConsumerStatefulWidget {
  const DeviceScanPage({super.key});

  @override
  ConsumerState<DeviceScanPage> createState() => _DeviceScanPageState();
}

class _DeviceScanPageState extends ConsumerState<DeviceScanPage> {
  @override
  void initState() {
    super.initState();
    // Automatisch Scan starten (nur wenn unterstützt)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bleManager = ref.read(bleManagerProvider);
      if (bleManager.isSupported) {
        bleManager.startScan();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bleManager = ref.watch(bleManagerProvider);
    final trainerState = ref.watch(bleConnectionStateProvider);
    final hrState = ref.watch(hrConnectionStateProvider);
    final isScanning = ref.watch(bleScanningProvider);
    final trainers = ref.watch(trainerDevicesProvider);
    final hrMonitors = ref.watch(hrMonitorDevicesProvider);

    // Show unsupported platform message
    if (!bleManager.isSupported) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Geräte verbinden'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bluetooth_disabled,
                  size: 80,
                  color: AppColors.textMuted.withOpacity(0.5),
                ),
                const SizedBox(height: 24),
                const Text(
                  'BLE nicht unterstützt',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Bluetooth Low Energy wird auf dieser Plattform nicht unterstützt.\n\n'
                  'Bitte verwende:\n'
                  '• Android (Smartphone/Tablet)\n'
                  '• iOS (iPhone/iPad)\n'
                  '• macOS\n\n'
                  'Windows-Unterstützung ist in Arbeit.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 32),
                OutlinedButton.icon(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Zurück'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Geräte verbinden'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          // Scan Button
          isScanning.when(
            data: (scanning) => scanning
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => ref.read(bleManagerProvider).startScan(),
                    tooltip: 'Erneut suchen',
                  ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trainer Connection Status
            trainerState.when(
              data: (state) {
                if (state.isConnected) {
                  return _ConnectedBanner(
                    device: state.device!,
                    deviceType: BleDeviceType.trainer,
                    onDisconnect: () => bleManager.disconnectTrainer(),
                  );
                }
                if (state.isConnecting) {
                  return _ConnectingBanner(device: state.device!);
                }
                if (state.hasError) {
                  return _ErrorBanner(message: state.errorMessage!);
                }
                return const SizedBox.shrink();
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),

            // HR Monitor Connection Status
            hrState.when(
              data: (state) {
                if (state.isConnected) {
                  return _ConnectedBanner(
                    device: state.device!,
                    deviceType: BleDeviceType.heartRateMonitor,
                    onDisconnect: () => bleManager.disconnectHrMonitor(),
                  );
                }
                if (state.isConnecting) {
                  return _ConnectingBanner(device: state.device!);
                }
                if (state.hasError) {
                  return _ErrorBanner(message: state.errorMessage!);
                }
                return const SizedBox.shrink();
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),

            // Scan Hint
            isScanning.when(
              data: (scanning) => scanning
                  ? Container(
                      padding: const EdgeInsets.all(16),
                      child: const Row(
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Text('Suche nach Geräten...'),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),

            // Trainer Section
            _DeviceSection(
              title: 'Smart Trainer',
              icon: Icons.directions_bike,
              iconColor: AppColors.primary,
              devices: trainers,
              emptyMessage: 'Keine Trainer gefunden',
              onDeviceTap: (device) => _connectTrainer(device),
            ),

            const SizedBox(height: 16),

            // HR Monitor Section
            _DeviceSection(
              title: 'Herzfrequenz-Monitore',
              icon: Icons.favorite,
              iconColor: AppColors.error,
              devices: hrMonitors,
              emptyMessage: 'Keine HR-Monitore gefunden',
              onDeviceTap: (device) => _connectHrMonitor(device),
            ),

            const SizedBox(height: 24),

            // Info Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Du kannst gleichzeitig einen Trainer und einen HR-Monitor verbinden. '
                'Der HR-Monitor hat Priorität für die Herzfrequenz-Messung.',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _connectTrainer(BleDevice device) async {
    final bleManager = ref.read(bleManagerProvider);
    final success = await bleManager.connectTrainer(device);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Trainer verbunden: ${device.name}'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _connectHrMonitor(BleDevice device) async {
    final bleManager = ref.read(bleManagerProvider);
    final success = await bleManager.connectHrMonitor(device);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('HR-Monitor verbunden: ${device.name}'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}

class _DeviceSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<BleDevice> devices;
  final String emptyMessage;
  final void Function(BleDevice) onDeviceTap;

  const _DeviceSection({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.devices,
    required this.emptyMessage,
    required this.onDeviceTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${devices.length} gefunden',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        // Device List or Empty State
        if (devices.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Center(
              child: Text(
                emptyMessage,
                style: const TextStyle(color: AppColors.textMuted),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];
              return _DeviceListTile(
                device: device,
                onTap: () => onDeviceTap(device),
              );
            },
          ),
      ],
    );
  }
}

class _DeviceListTile extends StatelessWidget {
  final BleDevice device;
  final VoidCallback onTap;

  const _DeviceListTile({
    required this.device,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isTrainer = device.deviceType == BleDeviceType.trainer;
    final color = isTrainer ? AppColors.primary : AppColors.error;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isTrainer ? Icons.directions_bike : Icons.favorite,
                  color: color,
                ),
              ),
              const SizedBox(width: 16),

              // Name & ID
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      device.id,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isTrainer ? 'Smart Trainer' : 'HR Monitor',
                        style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Signal Strength
              Column(
                children: [
                  _SignalStrengthIndicator(strength: device.signalStrength),
                  const SizedBox(height: 4),
                  Text(
                    '${device.rssi} dBm',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignalStrengthIndicator extends StatelessWidget {
  final int strength;

  const _SignalStrengthIndicator({required this.strength});

  @override
  Widget build(BuildContext context) {
    final bars = (strength / 25).ceil().clamp(1, 4);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(4, (index) {
        final isActive = index < bars;
        final height = 6.0 + (index * 4);

        return Container(
          width: 4,
          height: height,
          margin: const EdgeInsets.only(left: 2),
          decoration: BoxDecoration(
            color: isActive ? AppColors.success : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}

class _ConnectedBanner extends StatelessWidget {
  final BleDevice device;
  final BleDeviceType deviceType;
  final VoidCallback onDisconnect;

  const _ConnectedBanner({
    required this.device,
    required this.deviceType,
    required this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    final isTrainer = deviceType == BleDeviceType.trainer;
    final label = isTrainer ? 'Trainer' : 'HR-Monitor';
    final icon = isTrainer ? Icons.directions_bike : Icons.favorite;

    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.success.withOpacity(0.1),
      child: Row(
        children: [
          Icon(icon, color: AppColors.success, size: 20),
          const SizedBox(width: 8),
          const Icon(Icons.check_circle, color: AppColors.success, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$label: ${device.name}',
              style: const TextStyle(
                color: AppColors.success,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: onDisconnect,
            child: const Text('Trennen'),
          ),
        ],
      ),
    );
  }
}

class _ConnectingBanner extends StatelessWidget {
  final BleDevice device;

  const _ConnectingBanner({required this.device});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.primary.withOpacity(0.1),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Text(
            'Verbinde mit ${device.name}...',
            style: const TextStyle(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.error.withOpacity(0.1),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
