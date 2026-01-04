/// Strava API Konfiguration
///
/// Erstelle eine App unter: https://www.strava.com/settings/api
///
/// Wichtig: Der Callback URL muss so konfiguriert sein:
/// - Android: vibedkickr://strava/callback
/// - iOS: vibedkickr://strava/callback
class StravaConfig {
  /// Strava Client ID (aus Strava API Settings)
  static const String clientId = String.fromEnvironment(
    'STRAVA_CLIENT_ID',
    defaultValue: '',
  );

  /// Strava Client Secret (aus Strava API Settings)
  static const String clientSecret = String.fromEnvironment(
    'STRAVA_CLIENT_SECRET',
    defaultValue: '',
  );

  /// OAuth Callback Schema
  static const String callbackScheme = 'vibedkickr';

  /// OAuth Callback URL
  static const String callbackUrl = '$callbackScheme://strava/callback';

  /// Strava OAuth Endpoints
  static const String authorizeUrl = 'https://www.strava.com/oauth/mobile/authorize';
  static const String tokenUrl = 'https://www.strava.com/oauth/token';
  static const String deauthorizeUrl = 'https://www.strava.com/oauth/deauthorize';

  /// Strava API Base URL
  static const String apiBaseUrl = 'https://www.strava.com/api/v3';

  /// Benötigte Scopes für die App
  static const String scope = 'read,activity:write,activity:read_all';

  /// Prüft ob Strava konfiguriert ist
  static bool get isConfigured => clientId.isNotEmpty && clientSecret.isNotEmpty;
}
