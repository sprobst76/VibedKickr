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
    final connectionState = ref.watch(bleConnectionStateProvider);
    final isScanning = ref.watch(bleScanningProvider);
    final devices = ref.watch(bleDevicesProvider);

    // Show unsupported platform message
    if (!bleManager.isSupported) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Gerät verbinden'),
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
        title: const Text('Gerät verbinden'),
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
      body: Column(
        children: [
          // Connection Status
          connectionState.when(
            data: (state) {
              if (state.isConnected) {
                return _ConnectedBanner(device: state.device!);
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

          // Device List
          Expanded(
            child: devices.when(
              data: (deviceList) {
                if (deviceList.isEmpty) {
                  return const _EmptyState();
                }

                // Sortiere: Bekannte Trainer zuerst, dann nach Signalstärke
                final sortedDevices = [...deviceList]..sort((a, b) {
                    if (a.isKnownTrainer && !b.isKnownTrainer) return -1;
                    if (!a.isKnownTrainer && b.isKnownTrainer) return 1;
                    return b.rssi.compareTo(a.rssi);
                  });

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sortedDevices.length,
                  itemBuilder: (context, index) {
                    final device = sortedDevices[index];
                    return _DeviceListTile(
                      device: device,
                      onTap: () => _connectToDevice(device),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Fehler: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _connectToDevice(BleDevice device) async {
    final bleManager = ref.read(bleManagerProvider);
    final success = await bleManager.connect(device);

    if (success && mounted) {
      // Kurz warten, dann zurück zum Dashboard
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        context.pop();
      }
    }
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
                  color: device.isKnownTrainer
                      ? AppColors.primary.withOpacity(0.1)
                      : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  device.isKnownTrainer
                      ? Icons.directions_bike
                      : Icons.bluetooth,
                  color: device.isKnownTrainer
                      ? AppColors.primary
                      : AppColors.textSecondary,
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
                    if (device.isKnownTrainer)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Smart Trainer',
                          style: TextStyle(
                            color: AppColors.primary,
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

  const _ConnectedBanner({required this.device});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.success.withOpacity(0.1),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.success),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Verbunden mit ${device.name}',
              style: const TextStyle(
                color: AppColors.success,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Trennen
            },
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bluetooth_searching,
            size: 64,
            color: AppColors.textMuted.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Keine Geräte gefunden',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Stelle sicher, dass dein Trainer\neingeschaltet und in Reichweite ist.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
