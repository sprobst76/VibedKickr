import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/tss_threshold_settings.dart';

/// Service zur Verwaltung von TSS Threshold Settings mit SharedPreferences
///
/// Speichert Benutzereinstellungen für TSS-Warnungen:
/// - CTL-basierte Schwellwerte vs. manuelle Einstellung
/// - Multipliers für CTL-Berechnung
/// - Manuelle Warnung/Kritisch-Werte
class TssThresholdSettingsService {
  static const String _storageKey = 'tss_threshold_settings';

  /// Lade TSS Threshold Settings aus SharedPreferences
  ///
  /// Gibt [TssThresholdSettings] mit gespeicherten Werten zurück.
  /// Fallback zu Defaults wenn keine Einstellungen vorhanden sind.
  Future<TssThresholdSettings> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);

      if (jsonString == null) {
        return const TssThresholdSettings();
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return TssThresholdSettings.fromJson(json);
    } catch (e) {
      // Bei Fehler: Fallback zu Defaults
      return const TssThresholdSettings();
    }
  }

  /// Speichere TSS Threshold Settings in SharedPreferences
  Future<void> save(TssThresholdSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(settings.toJson());
    await prefs.setString(_storageKey, json);
  }

  /// Lösche gespeicherte TSS Threshold Settings (Zurücksetzen auf Defaults)
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
