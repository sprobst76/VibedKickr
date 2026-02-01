import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/health_training_personalization_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/athlete_profile.dart';
import '../../../../providers/providers.dart';
import '../../../../routing/app_router.dart';
import '../widgets/strava_settings_card.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(athleteProfileProvider);
    final soundEnabled = ref.watch(soundEnabledProvider);
    final hapticsEnabled = ref.watch(hapticsEnabledProvider);
    final powerDeviationAlerts = ref.watch(powerDeviationAlertsProvider);
    final powerDeviationThreshold = ref.watch(powerDeviationThresholdProvider);
    final autoConnect = ref.watch(autoConnectProvider);
    final ergMode = ref.watch(ergModeProvider);
    final simulatorMode = ref.watch(simulatorModeProvider);
    final keepScreenOn = ref.watch(keepScreenOnProvider);
    final themeMode = ref.watch(themeModeProvider);

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

          // Profil & Gesundheit
          _SectionHeader(title: 'Profil & Gesundheit'),
          Card(
            child: Column(
              children: [
                _SettingsTile(
                  title: 'Geburtsdatum',
                  subtitle: profile.birthDate != null
                      ? '${profile.birthDate!.day.toString().padLeft(2, '0')}.${profile.birthDate!.month.toString().padLeft(2, '0')}.${profile.birthDate!.year}'
                      : 'Nicht gesetzt',
                  icon: Icons.calendar_today,
                  onTap: () => _showBirthDatePicker(context, ref, profile.birthDate),
                ),
                const Divider(height: 1),
                _SettingsTile(
                  title: 'Alter',
                  subtitle: profile.age != null ? '${profile.age} Jahre' : 'Geburtsdatum erforderlich',
                  icon: Icons.info_outline,
                ),
                const Divider(height: 1),
                _SettingsTile(
                  title: 'Geschlecht',
                  subtitle: profile.gender != null ? profile.gender!.label : 'Nicht gesetzt',
                  icon: Icons.person,
                  onTap: () => _showGenderDialog(context, ref, profile.gender),
                ),
                const Divider(height: 1),
                _SettingsTile(
                  title: 'Max. Herzfrequenz (berechnet)',
                  subtitle: profile.age != null
                      ? '${HealthTrainingPersonalizationService.calculateMaxHeartRate(profile.age!, gender: profile.gender)} bpm'
                      : 'Geburtsdatum erforderlich',
                  icon: Icons.favorite,
                ),
                if (profile.age != null) ...[
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: _HealthMetricsDisplay(profile: profile),
                  ),
                ],
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

          // Display
          _SectionHeader(title: 'Display'),
          Card(
            child: SwitchListTile(
              title: const Text('Bildschirm aktiv halten'),
              subtitle: const Text('Verhindert Sperre während Trainings'),
              value: keepScreenOn,
              onChanged: (value) {
                ref.read(keepScreenOnProvider.notifier).state = value;
              },
            ),
          ),
          const SizedBox(height: 24),

          // Theme
          _SectionHeader(title: 'Design'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.palette),
              title: const Text('Design-Modus'),
              subtitle: Text(_getThemeModeLabel(themeMode)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showThemeModeDialog(context, ref, themeMode),
            ),
          ),
          const SizedBox(height: 24),

          // Audio
          _SectionHeader(title: 'Audio'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Sound-Effekte'),
                  subtitle: const Text('Audio-Hinweise bei Intervallwechsel'),
                  value: soundEnabled,
                  onChanged: (value) {
                    ref.read(soundEnabledProvider.notifier).state = value;
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Haptic Feedback'),
                  subtitle: const Text('Vibration bei Intervallwechsel'),
                  value: hapticsEnabled,
                  onChanged: (value) {
                    ref.read(hapticsEnabledProvider.notifier).state = value;
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Power-Abweichungs-Warnungen'),
                  subtitle: const Text('Audio-Alert bei zu niedriger/hoher Leistung'),
                  value: powerDeviationAlerts,
                  onChanged: (value) {
                    ref.read(powerDeviationAlertsProvider.notifier).state = value;
                  },
                ),
                if (powerDeviationAlerts)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Abweichungs-Schwelle',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                            Text(
                              '$powerDeviationThreshold%',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: powerDeviationThreshold.toDouble(),
                          min: 10,
                          max: 30,
                          divisions: 4,
                          label: '$powerDeviationThreshold%',
                          onChanged: (value) {
                            ref.read(powerDeviationThresholdProvider.notifier).state =
                                value.toInt();
                          },
                        ),
                        Text(
                          'Warnung bei >$powerDeviationThreshold% Abweichung vom Ziel',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Training Load Schwellwerte
          _SectionHeader(title: 'Training Load Schwellwerte'),
          _TssThresholdSettingsCard(),
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
                  subtitle: '0.9.0 Beta',
                  icon: Icons.info_outline,
                ),
                const Divider(height: 1),
                _SettingsTile(
                  title: 'Lizenzen',
                  subtitle: 'Open Source Bibliotheken',
                  icon: Icons.description_outlined,
                  onTap: () => showLicensePage(
                    context: context,
                    applicationName: 'VibedKickr',
                    applicationVersion: '0.9.0 Beta',
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

  void _showThemeModeDialog(BuildContext context, WidgetRef ref, ThemeMode currentMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Design-Modus'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('System'),
              subtitle: const Text('Folgt Systemeinstellung'),
              value: ThemeMode.system,
              groupValue: currentMode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeModeProvider.notifier).state = value;
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Helles Design'),
              subtitle: const Text('Immer helles Design'),
              value: ThemeMode.light,
              groupValue: currentMode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeModeProvider.notifier).state = value;
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dunkles Design'),
              subtitle: const Text('Immer dunkles Design'),
              value: ThemeMode.dark,
              groupValue: currentMode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeModeProvider.notifier).state = value;
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBirthDatePicker(BuildContext context, WidgetRef ref, DateTime? currentDate) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime.now().subtract(const Duration(days: 365 * 30)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      locale: const Locale('de', 'DE'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            useMaterial3: true,
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 8,
              headerBackgroundColor: AppColors.primary,
              headerForegroundColor: Colors.white,
              weekdayStyle: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              dayStyle: const TextStyle(color: AppColors.textPrimary),
              yearStyle: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
          child: child ?? const SizedBox(),
        );
      },
    );

    if (pickedDate != null) {
      ref.read(athleteProfileProvider.notifier).updateBirthDate(pickedDate);
    }
  }

  void _showGenderDialog(BuildContext context, WidgetRef ref, Gender? currentGender) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Geschlecht'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<Gender>(
              title: const Text('Männlich'),
              value: Gender.male,
              groupValue: currentGender,
              onChanged: (value) {
                if (value != null) {
                  ref.read(athleteProfileProvider.notifier).updateGender(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<Gender>(
              title: const Text('Weiblich'),
              value: Gender.female,
              groupValue: currentGender,
              onChanged: (value) {
                if (value != null) {
                  ref.read(athleteProfileProvider.notifier).updateGender(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<Gender>(
              title: const Text('Sonstiges'),
              value: Gender.other,
              groupValue: currentGender,
              onChanged: (value) {
                if (value != null) {
                  ref.read(athleteProfileProvider.notifier).updateGender(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<Gender>(
              title: const Text('Nicht angegeben'),
              value: Gender.notSpecified,
              groupValue: currentGender,
              onChanged: (value) {
                if (value != null) {
                  ref.read(athleteProfileProvider.notifier).updateGender(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getThemeModeLabel(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.system => 'System',
      ThemeMode.light => 'Hell',
      ThemeMode.dark => 'Dunkel',
    };
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

class _HealthMetricsDisplay extends StatelessWidget {
  final AthleteProfile profile;

  const _HealthMetricsDisplay({required this.profile});

  @override
  Widget build(BuildContext context) {
    final age = profile.age;
    if (age == null) return const SizedBox.shrink();

    final maxHr = HealthTrainingPersonalizationService.calculateMaxHeartRate(
      age,
      gender: profile.gender,
    );
    final ageFactor = HealthTrainingPersonalizationService.calculateAgeFactor(age);
    final safePercent = (ageFactor * 100).round();
    final safeHr = (maxHr * ageFactor).round();
    final barColor = ageFactor >= 0.85
        ? Colors.green
        : ageFactor >= 0.75
            ? Colors.orange
            : Colors.red;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Sicherer Trainingsbereich',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'bis $safePercent% max HR',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: ageFactor,
                minHeight: 32,
                backgroundColor: AppColors.surfaceLight,
                valueColor: AlwaysStoppedAnimation<Color>(barColor),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Text(
                  '$safeHr bpm',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Empfohlene Zonen',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _HrZoneBadge(
                zone: 'Z1',
                name: 'Recovery',
                min: 0,
                max: (maxHr * 0.60).round(),
              ),
              _HrZoneBadge(
                zone: 'Z2',
                name: 'Aerobic',
                min: (maxHr * 0.60).round() + 1,
                max: (maxHr * 0.70).round(),
              ),
              _HrZoneBadge(
                zone: 'Z3',
                name: 'Tempo',
                min: (maxHr * 0.70).round() + 1,
                max: (maxHr * 0.80).round(),
              ),
              _HrZoneBadge(
                zone: 'Z4',
                name: 'Threshold',
                min: (maxHr * 0.80).round() + 1,
                max: (maxHr * 0.90).round(),
              ),
              _HrZoneBadge(
                zone: 'Z5',
                name: 'Max',
                min: (maxHr * 0.90).round() + 1,
                max: maxHr,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HrZoneBadge extends StatelessWidget {
  final String zone;
  final String name;
  final int min;
  final int max;

  const _HrZoneBadge({
    required this.zone,
    required this.name,
    required this.min,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              zone,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Text(
            '$min–$max bpm',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// TSS Threshold Settings Card
class _TssThresholdSettingsCard extends ConsumerWidget {
  const _TssThresholdSettingsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(tssThresholdSettingsProvider);
    final trainingStatus = ref.watch(trainingStatusProvider);
    final ctl = trainingStatus.ctl;

    final warningThreshold = settings.getWarningThreshold(ctl);
    final criticalThreshold = settings.getCriticalThreshold(ctl);

    return Card(
      child: Column(
        children: [
          // Toggle Switch
          SwitchListTile(
            title: const Text('CTL-basierte Schwellwerte verwenden'),
            subtitle: Text(
              settings.useCtlBased
                  ? 'Automatisch basierend auf deiner Fitness (CTL)'
                  : 'Manuelle Schwellwerte',
            ),
            value: settings.useCtlBased,
            onChanged: (value) {
              ref.read(tssThresholdSettingsProvider.notifier).toggleMode(value);
            },
          ),

          // CTL Mode: Show calculated values
          if (settings.useCtlBased) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Aktuelle Schwellwerte:',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                      Text(
                        'CTL: ${ctl.round()}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _ThresholdInfoRow(
                    label: 'Warnung',
                    value: '$warningThreshold TSS',
                    color: AppColors.warning,
                  ),
                  const SizedBox(height: 4),
                  _ThresholdInfoRow(
                    label: 'Kritisch',
                    value: '$criticalThreshold TSS',
                    color: AppColors.error,
                  ),
                ],
              ),
            ),
          ],

          // Manual Mode: Sliders
          if (!settings.useCtlBased) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Warning Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Warnung-Schwellwert'),
                      Text(
                        '${settings.manualWarningThreshold} TSS',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: settings.manualWarningThreshold.toDouble(),
                    min: 300,
                    max: 800,
                    divisions: 10,
                    label: '${settings.manualWarningThreshold} TSS',
                    onChanged: (value) {
                      ref
                          .read(tssThresholdSettingsProvider.notifier)
                          .updateManualThresholds(warning: value.toInt());
                    },
                  ),
                  const SizedBox(height: 12),

                  // Critical Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Kritisch-Schwellwert'),
                      Text(
                        '${settings.manualCriticalThreshold} TSS',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: settings.manualCriticalThreshold.toDouble(),
                    min: 400,
                    max: 1000,
                    divisions: 12,
                    label: '${settings.manualCriticalThreshold} TSS',
                    onChanged: (value) {
                      ref
                          .read(tssThresholdSettingsProvider.notifier)
                          .updateManualThresholds(critical: value.toInt());
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Row to display threshold info with color-coded container
class _ThresholdInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ThresholdInfoRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
