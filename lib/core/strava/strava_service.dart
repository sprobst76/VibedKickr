import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/training_session.dart';
import 'strava_api.dart';
import 'strava_auth.dart';
import 'strava_config.dart';

/// Strava Verbindungsstatus
class StravaConnectionState {
  final bool isConnected;
  final bool isConfigured;
  final String? athleteName;
  final bool isLoading;
  final String? error;

  const StravaConnectionState({
    this.isConnected = false,
    this.isConfigured = false,
    this.athleteName,
    this.isLoading = false,
    this.error,
  });

  StravaConnectionState copyWith({
    bool? isConnected,
    bool? isConfigured,
    String? athleteName,
    bool? isLoading,
    String? error,
  }) {
    return StravaConnectionState(
      isConnected: isConnected ?? this.isConnected,
      isConfigured: isConfigured ?? this.isConfigured,
      athleteName: athleteName ?? this.athleteName,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Strava Service Provider
final stravaServiceProvider =
    StateNotifierProvider<StravaServiceNotifier, StravaConnectionState>((ref) {
  final notifier = StravaServiceNotifier();
  ref.onDispose(() => notifier.dispose());
  return notifier;
});

/// Strava Service Notifier
class StravaServiceNotifier extends StateNotifier<StravaConnectionState> {
  final StravaAuth _auth = StravaAuth();
  StravaApi? _api;
  StreamSubscription? _authSubscription;

  StravaServiceNotifier() : super(const StravaConnectionState()) {
    _initialize();
  }

  StravaApi? get api => _api;

  Future<void> _initialize() async {
    state = state.copyWith(
      isConfigured: StravaConfig.isConfigured,
      isLoading: true,
    );

    if (!StravaConfig.isConfigured) {
      state = state.copyWith(isLoading: false);
      return;
    }

    // Auth State beobachten
    _authSubscription = _auth.authStateChanges.listen((isAuthenticated) {
      state = state.copyWith(
        isConnected: isAuthenticated,
        athleteName: _auth.athleteName,
      );
    });

    // Gespeicherten Token laden
    try {
      await _auth.initialize();
      _api = StravaApi(_auth);
      state = state.copyWith(
        isConnected: _auth.isAuthenticated,
        athleteName: _auth.athleteName,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Startet den OAuth Flow
  Future<void> connect() async {
    if (!StravaConfig.isConfigured) {
      state = state.copyWith(
        error: 'Strava ist nicht konfiguriert',
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      await _auth.authenticate();
      // Der Callback wird über Deep Links verarbeitet
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Verarbeitet den OAuth Callback
  Future<void> handleCallback(String callbackUrl) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _auth.handleCallback(callbackUrl);
      _api = StravaApi(_auth);
      state = state.copyWith(
        isConnected: true,
        athleteName: _auth.athleteName,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Trennt die Strava-Verbindung
  Future<void> disconnect() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _auth.logout();
      _api = null;
      state = state.copyWith(
        isConnected: false,
        athleteName: null,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Lädt eine Session zu Strava hoch
  Future<StravaUploadResult> uploadSession(
    TrainingSession session, {
    String? name,
    String? description,
  }) async {
    if (_api == null || !state.isConnected) {
      return StravaUploadResult(
        status: StravaUploadStatus.error,
        error: 'Nicht mit Strava verbunden',
      );
    }

    try {
      return await _api!.uploadActivity(
        session,
        name: name,
        description: description,
      );
    } catch (e) {
      return StravaUploadResult(
        status: StravaUploadStatus.error,
        error: e.toString(),
      );
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _auth.dispose();
    super.dispose();
  }
}
