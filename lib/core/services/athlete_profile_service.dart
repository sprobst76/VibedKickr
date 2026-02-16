import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/athlete_profile.dart';

/// Service zur Persistierung des Athleten-Profils mit SharedPreferences
class AthleteProfileService {
  static const String _storageKey = 'athlete_profile';

  /// Lade Athleten-Profil aus SharedPreferences
  Future<AthleteProfile> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);

      if (jsonString == null) {
        return AthleteProfile.defaultProfile();
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return AthleteProfile.fromJson(json);
    } catch (e) {
      return AthleteProfile.defaultProfile();
    }
  }

  /// Speichere Athleten-Profil in SharedPreferences
  Future<void> save(AthleteProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(profile.toJson());
    await prefs.setString(_storageKey, json);
  }
}
