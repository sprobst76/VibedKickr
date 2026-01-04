import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/strava/strava_service.dart';
import '../../../../core/theme/app_theme.dart';

class StravaSettingsCard extends ConsumerWidget {
  const StravaSettingsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stravaState = ref.watch(stravaServiceProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFC4C02).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.directions_bike,
                    color: Color(0xFFFC4C02), // Strava Orange
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Strava',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Aktivitäten automatisch synchronisieren',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (stravaState.isLoading)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else if (stravaState.isConnected)
                  const Icon(Icons.check_circle, color: AppColors.success)
                else
                  const Icon(Icons.link_off, color: AppColors.textMuted),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),

            if (!stravaState.isConfigured) ...[
              // Nicht konfiguriert
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.warning, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Strava API nicht konfiguriert. '
                        'Setze STRAVA_CLIENT_ID und STRAVA_CLIENT_SECRET.',
                        style: TextStyle(fontSize: 12, color: AppColors.warning),
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (stravaState.isConnected) ...[
              // Verbunden
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: AppColors.textMuted),
                  const SizedBox(width: 8),
                  Text(
                    stravaState.athleteName ?? 'Verbunden',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: stravaState.isLoading
                      ? null
                      : () => _confirmDisconnect(context, ref),
                  icon: const Icon(Icons.link_off),
                  label: const Text('Verbindung trennen'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                  ),
                ),
              ),
            ] else ...[
              // Nicht verbunden
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: stravaState.isLoading
                      ? null
                      : () => ref.read(stravaServiceProvider.notifier).connect(),
                  icon: const Icon(Icons.link),
                  label: const Text('Mit Strava verbinden'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFC4C02),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],

            if (stravaState.error != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: AppColors.error, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        stravaState.error!,
                        style:
                            const TextStyle(fontSize: 12, color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDisconnect(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Strava trennen?'),
        content: const Text(
          'Die Verbindung zu Strava wird getrennt. '
          'Bereits hochgeladene Aktivitäten bleiben erhalten.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Trennen'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(stravaServiceProvider.notifier).disconnect();
    }
  }
}
