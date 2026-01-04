import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/ble/models/connection_state.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../providers/providers.dart';
import '../../../../routing/app_router.dart';

class ConnectionStatusBar extends ConsumerWidget {
  const ConnectionStatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionState = ref.watch(bleConnectionStateProvider);

    return connectionState.when(
      data: (state) => _StatusBar(state: state),
      loading: () => const _LoadingBar(),
      error: (e, _) => _ErrorBar(message: e.toString()),
    );
  }
}

class _StatusBar extends StatelessWidget {
  final BleConnectionState state;

  const _StatusBar({required this.state});

  @override
  Widget build(BuildContext context) {
    final (icon, color, text, action) = switch (state.status) {
      ConnectionStatus.connected => (
          Icons.bluetooth_connected,
          AppColors.connected,
          'Verbunden: ${state.device?.name ?? "Trainer"}',
          null,
        ),
      ConnectionStatus.connecting => (
          Icons.bluetooth_searching,
          AppColors.scanning,
          'Verbinde mit ${state.device?.name ?? "Gerät"}...',
          null,
        ),
      ConnectionStatus.disconnected => (
          Icons.bluetooth_disabled,
          AppColors.textMuted,
          'Kein Gerät verbunden',
          'Verbinden',
        ),
      ConnectionStatus.error => (
          Icons.error_outline,
          AppColors.error,
          state.errorMessage ?? 'Verbindungsfehler',
          'Erneut versuchen',
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (action != null)
            TextButton(
              onPressed: () => context.push(AppRoutes.deviceScan),
              child: Text(action),
            ),
          if (state.isConnecting)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
        ],
      ),
    );
  }
}

class _LoadingBar extends StatelessWidget {
  const _LoadingBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Text('Initialisiere Bluetooth...'),
        ],
      ),
    );
  }
}

class _ErrorBar extends StatelessWidget {
  final String message;

  const _ErrorBar({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.error.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
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
