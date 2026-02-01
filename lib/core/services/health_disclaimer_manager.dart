import 'package:shared_preferences/shared_preferences.dart';

/// Service zur Verwaltung der Akzeptanz von medizinischen Disclaimer
///
/// Speichert, ob der Benutzer den Disclaimer akzeptiert hat,
/// um ihn nicht bei jedem Training erneut zu zeigen.
class HealthDisclaimerManager {
  static const _disclaimerAcceptedKey = 'health_disclaimer_accepted';
  static const _disclaimerAcceptedDateKey = 'health_disclaimer_accepted_date';
  static const _disclaimerVersionKey = 'health_disclaimer_version';

  /// Aktuelle Version des Disclaimers (erhöhen wenn Disclaimer ändert sich)
  static const _currentDisclaimerVersion = 1;

  /// Prüft ob der Disclaimer vom Benutzer akzeptiert wurde
  static Future<bool> isDisclaimerAccepted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accepted = prefs.getBool(_disclaimerAcceptedKey) ?? false;
      final version = prefs.getInt(_disclaimerVersionKey) ?? 0;

      // Wenn Version sich ändert, muss Disclaimer erneut akzeptiert werden
      if (version != _currentDisclaimerVersion) {
        return false;
      }

      return accepted;
    } catch (e) {
      // Bei Fehler: erneut anzeigen
      return false;
    }
  }

  /// Speichert dass Benutzer den Disclaimer akzeptiert hat
  static Future<bool> acceptDisclaimer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = DateTime.now().toIso8601String();

      await prefs.setBool(_disclaimerAcceptedKey, true);
      await prefs.setString(_disclaimerAcceptedDateKey, timestamp);
      await prefs.setInt(_disclaimerVersionKey, _currentDisclaimerVersion);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Gibt Zeitpunkt der Akzeptanz zurück
  static Future<DateTime?> getAcceptanceDate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dateStr = prefs.getString(_disclaimerAcceptedDateKey);

      if (dateStr != null) {
        return DateTime.tryParse(dateStr);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Setzt Disclaimer zurück (Benutzer muss erneut akzeptieren)
  static Future<bool> resetDisclaimer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_disclaimerAcceptedKey);
      await prefs.remove(_disclaimerAcceptedDateKey);
      await prefs.remove(_disclaimerVersionKey);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Prüft ob ein neuer Disclaimer verfügbar ist
  /// (z.B. wenn Disclaimer aktualisiert wurde)
  static Future<bool> hasNewDisclaimerVersion() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final version = prefs.getInt(_disclaimerVersionKey) ?? 0;
      return version < _currentDisclaimerVersion;
    } catch (e) {
      return false;
    }
  }
}
