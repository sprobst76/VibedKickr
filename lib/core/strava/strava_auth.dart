import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'strava_config.dart';

/// Strava Token Daten
class StravaToken {
  final String accessToken;
  final String refreshToken;
  final int expiresAt; // Unix timestamp
  final int athleteId;
  final String? athleteName;

  StravaToken({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.athleteId,
    this.athleteName,
  });

  bool get isExpired => DateTime.now().millisecondsSinceEpoch ~/ 1000 >= expiresAt;

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'expires_at': expiresAt,
        'athlete_id': athleteId,
        'athlete_name': athleteName,
      };

  factory StravaToken.fromJson(Map<String, dynamic> json) => StravaToken(
        accessToken: json['access_token'] as String,
        refreshToken: json['refresh_token'] as String,
        expiresAt: json['expires_at'] as int,
        athleteId: json['athlete_id'] as int? ?? json['athlete']?['id'] as int? ?? 0,
        athleteName: json['athlete_name'] as String? ??
            json['athlete']?['firstname'] as String?,
      );
}

/// Strava Authentication Service
class StravaAuth {
  static const _tokenKey = 'strava_token';
  final Dio _dio = Dio();

  StravaToken? _token;
  final _authStateController = StreamController<bool>.broadcast();

  /// Stream der Authentifizierungsstatus-Änderungen
  Stream<bool> get authStateChanges => _authStateController.stream;

  /// Aktuell authentifiziert?
  bool get isAuthenticated => _token != null;

  /// Aktueller Athlete Name
  String? get athleteName => _token?.athleteName;

  /// Initialisiert den Auth Service (lädt gespeicherten Token)
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenJson = prefs.getString(_tokenKey);

    if (tokenJson != null) {
      try {
        _token = StravaToken.fromJson(jsonDecode(tokenJson));

        // Token refresh wenn abgelaufen
        if (_token!.isExpired) {
          await _refreshToken();
        }

        _authStateController.add(true);
      } catch (e) {
        // Token ungültig, löschen
        await prefs.remove(_tokenKey);
        _token = null;
      }
    }
  }

  /// Startet den OAuth Flow
  Future<bool> authenticate() async {
    if (!StravaConfig.isConfigured) {
      throw Exception('Strava ist nicht konfiguriert. '
          'Bitte Client ID und Secret in den Build-Argumenten setzen.');
    }

    final authUrl = Uri.parse(StravaConfig.authorizeUrl).replace(
      queryParameters: {
        'client_id': StravaConfig.clientId,
        'redirect_uri': StravaConfig.callbackUrl,
        'response_type': 'code',
        'approval_prompt': 'auto',
        'scope': StravaConfig.scope,
      },
    );

    // OAuth URL im Browser öffnen
    if (!await launchUrl(authUrl, mode: LaunchMode.externalApplication)) {
      throw Exception('Konnte Browser nicht öffnen');
    }

    return true;
  }

  /// Verarbeitet den OAuth Callback
  Future<bool> handleCallback(String callbackUrl) async {
    final uri = Uri.parse(callbackUrl);
    final code = uri.queryParameters['code'];
    final error = uri.queryParameters['error'];

    if (error != null) {
      throw Exception('Strava Autorisierung abgelehnt: $error');
    }

    if (code == null) {
      throw Exception('Kein Autorisierungscode erhalten');
    }

    // Code gegen Token tauschen
    try {
      final response = await _dio.post(
        StravaConfig.tokenUrl,
        data: {
          'client_id': StravaConfig.clientId,
          'client_secret': StravaConfig.clientSecret,
          'code': code,
          'grant_type': 'authorization_code',
        },
      );

      _token = StravaToken.fromJson(response.data);
      await _saveToken();
      _authStateController.add(true);
      return true;
    } catch (e) {
      throw Exception('Token-Austausch fehlgeschlagen: $e');
    }
  }

  /// Aktualisiert den Access Token
  Future<void> _refreshToken() async {
    if (_token == null) return;

    try {
      final response = await _dio.post(
        StravaConfig.tokenUrl,
        data: {
          'client_id': StravaConfig.clientId,
          'client_secret': StravaConfig.clientSecret,
          'refresh_token': _token!.refreshToken,
          'grant_type': 'refresh_token',
        },
      );

      _token = StravaToken(
        accessToken: response.data['access_token'],
        refreshToken: response.data['refresh_token'],
        expiresAt: response.data['expires_at'],
        athleteId: _token!.athleteId,
        athleteName: _token!.athleteName,
      );
      await _saveToken();
    } catch (e) {
      // Refresh fehlgeschlagen, logout
      await logout();
      rethrow;
    }
  }

  /// Gibt einen gültigen Access Token zurück (refresht wenn nötig)
  Future<String> getAccessToken() async {
    if (_token == null) {
      throw Exception('Nicht authentifiziert');
    }

    if (_token!.isExpired) {
      await _refreshToken();
    }

    return _token!.accessToken;
  }

  /// Logout - Token widerrufen und löschen
  Future<void> logout() async {
    if (_token != null) {
      try {
        await _dio.post(
          StravaConfig.deauthorizeUrl,
          data: {'access_token': _token!.accessToken},
        );
      } catch (_) {
        // Ignorieren wenn Deauthorize fehlschlägt
      }
    }

    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    _authStateController.add(false);
  }

  Future<void> _saveToken() async {
    if (_token == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, jsonEncode(_token!.toJson()));
  }

  void dispose() {
    _authStateController.close();
  }
}

/// Deep Link Handler für OAuth Callback
class StravaDeepLinkHandler {
  static const _channel = MethodChannel('vibedkickr/deeplink');
  static final _linkController = StreamController<String>.broadcast();

  static Stream<String> get linkStream => _linkController.stream;

  static void initialize() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onDeepLink') {
        final link = call.arguments as String;
        if (link.startsWith(StravaConfig.callbackScheme)) {
          _linkController.add(link);
        }
      }
    });
  }

  static void dispose() {
    _linkController.close();
  }
}
