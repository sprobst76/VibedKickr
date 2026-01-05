import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../providers/providers.dart';
import '../../../../routing/app_router.dart';
import '../widgets/strava_settings_card.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(athleteProfileProvider);
    final soundEnabled = ref.watch(soundEnabledProvider);
    final autoConnect = ref.watch(autoConnectProvider);
    final ergMode = ref.watch(ergModeProvider);
    final simulatorMode = ref.watch(simulatorModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Athleten-Profil
          _SectionHeader(title: 'Athleten-Profil'),
          Card(
            child: Column(
              children: [
                _SettingsTile(
                  title: 'FTP (Functional Threshold Power)',
                  subtitle: '${profile.ftp} Watt',
                  icon: Icons.flash_on,
                  onTap: () => _showFtpDialog(context, ref, profile.ftp),
                ),
                const Divider(height: 1),
                _SettingsTile(
                  title: 'Gewicht',
                  subtitle: profile.weight != null ? '${profile.weight} kg' : 'Nicht gesetzt',
                  icon: Icons.monitor_weight,
                  onTap: () => _showWeightDialog(context, ref, profile.weight),
                ),
                const Divider(height: 1),
                _SettingsTile(
                  title: 'Max. Herzfrequenz',
                  subtitle: profile.maxHr != null ? '${profile.maxHr} bpm' : 'Nicht gesetzt',
                  icon: Icons.favorite,
                  onTap: () => _showMaxHrDialog(context, ref, profile.maxHr),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Power Zones
          _SectionHeader(title: 'Power Zonen'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _ZoneRow(zone: 1, name: 'Active Recovery', max: profile.powerZones.z1Max),
                  _ZoneRow(zone: 2, name: 'Endurance', max: profile.powerZones.z2Max),
                  _ZoneRow(zone: 3, name: 'Tempo', max: profile.powerZones.z3Max),
                  _ZoneRow(zone: 4, name: 'Threshold', max: profile.powerZones.z4Max),
                  _ZoneRow(zone: 5, name: 'VO₂max', max: profile.powerZones.z5Max),
                  _ZoneRow(zone: 6, name: 'Anaerobic', max: profile.powerZones.z6Max),
                  _ZoneRow(zone: 7, name: 'Neuromuscular', max: null),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Trainer-Einstellungen
          _SectionHeader(title: 'Trainer'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Auto-Connect'),
                  subtitle: const Text('Automatisch mit letztem Gerät verbinden'),
                  value: autoConnect,
                  onChanged: (value) {
                    ref.read(autoConnectProvider.notifier).state = value;
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('ERG Modus'),
                  subtitle: const Text('Konstante Wattleistung statt Simulation'),
                  value: ergMode,
                  onChanged: (value) {
                    ref.read(ergModeProvider.notifier).state = value;
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: Row(
                    children: [
                      const Text('Simulator Modus'),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'DEV',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: const Text('Simulierter Trainer für Entwicklung'),
                  value: simulatorMode,
                  onChanged: (value) {
                    ref.read(simulatorModeProvider.notifier).state = value;
                    if (value) {
                      // Starte Simulator wenn aktiviert
                      ref.read(mockFtmsServiceProvider).start();
                    } else {
                      // Stoppe Simulator wenn deaktiviert
                      ref.read(mockFtmsServiceProvider).stop();
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Audio
          _SectionHeader(title: 'Audio'),
          Card(
            child: SwitchListTile(
              title: const Text('Sound-Effekte'),
              subtitle: const Text('Audio-Hinweise bei Intervallwechsel'),
              value: soundEnabled,
              onChanged: (value) {
                ref.read(soundEnabledProvider.notifier).state = value;
              },
            ),
          ),
          const SizedBox(height: 24),

          // Strava
          _SectionHeader(title: 'Verbindungen'),
          const StravaSettingsCard(),
          const SizedBox(height: 24),

          // Debug / Entwickler
          _SectionHeader(title: 'Entwickler'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.bug_report, color: AppColors.warning),
                  title: const Text('BLE Diagnose'),
                  subtitle: const Text('Bluetooth-Verbindung testen'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.bleDiagnostic),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Info
          _SectionHeader(title: 'Info'),
          Card(
            child: Column(
              children: [
                _SettingsTile(
                  title: 'Version',
                  subtitle: '1.1.0',
                  icon: Icons.info_outline,
                ),
                const Divider(height: 1),
                _SettingsTile(
                  title: 'Lizenzen',
                  subtitle: 'Open Source Bibliotheken',
                  icon: Icons.description_outlined,
                  onTap: () => showLicensePage(
                    context: context,
                    applicationName: 'Kickr Trainer',
                    applicationVersion: '1.1.0',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showFtpDialog(BuildContext context, WidgetRef ref, int currentFtp) {
    final controller = TextEditingController(text: currentFtp.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('FTP anpassen'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'FTP (Watt)',
            hintText: 'z.B. 200',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () {
              final newFtp = int.tryParse(controller.text);
              if (newFtp != null && newFtp > 0 && newFtp < 1000) {
                ref.read(athleteProfileProvider.notifier).updateFtp(newFtp);
                Navigator.pop(context);
              }
            },
            child: const Text('Speichern'),
          ),
        ],
      ),
    );
  }

  void _showWeightDialog(BuildContext context, WidgetRef ref, int? currentWeight) {
    final controller = TextEditingController(
      text: currentWeight?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gewicht anpassen'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Gewicht (kg)',
            hintText: 'z.B. 75',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () {
              final newWeight = int.tryParse(controller.text);
              if (newWeight != null && newWeight > 0 && newWeight < 300) {
                ref.read(athleteProfileProvider.notifier).updateWeight(newWeight);
                Navigator.pop(context);
              }
            },
            child: const Text('Speichern'),
          ),
        ],
      ),
    );
  }

  void _showMaxHrDialog(BuildContext context, WidgetRef ref, int? currentMaxHr) {
    final controller = TextEditingController(
      text: currentMaxHr?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Max. Herzfrequenz'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Max HR (bpm)',
            hintText: 'z.B. 185',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () {
              final newMaxHr = int.tryParse(controller.text);
              if (newMaxHr != null && newMaxHr > 100 && newMaxHr < 250) {
                ref.read(athleteProfileProvider.notifier).updateMaxHr(newMaxHr);
                Navigator.pop(context);
              }
            },
            child: const Text('Speichern'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
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

class _SettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.title,
    required this.subtitle,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon != null
          ? Icon(icon, color: AppColors.textSecondary)
          : null,
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: onTap != null
          ? const Icon(Icons.chevron_right, color: AppColors.textMuted)
          : null,
      onTap: onTap,
    );
  }
}

class _ZoneRow extends StatelessWidget {
  final int zone;
  final String name;
  final int? max;

  const _ZoneRow({
    required this.zone,
    required this.name,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    final color = ZoneColors.forZone(zone);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                '$zone',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Text(
            max != null ? '< $max W' : '> ${zone == 7 ? "Z6" : ""} W',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
