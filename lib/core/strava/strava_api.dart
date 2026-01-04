import 'dart:io';

import 'package:dio/dio.dart';

import '../../domain/entities/training_session.dart';
import '../export/fit_exporter.dart';
import 'strava_auth.dart';
import 'strava_config.dart';

/// Strava Upload Status
enum StravaUploadStatus {
  pending,
  processing,
  complete,
  error,
}

/// Strava Upload Ergebnis
class StravaUploadResult {
  final int? activityId;
  final StravaUploadStatus status;
  final String? error;
  final String? externalId;

  StravaUploadResult({
    this.activityId,
    required this.status,
    this.error,
    this.externalId,
  });

  factory StravaUploadResult.fromJson(Map<String, dynamic> json) {
    final status = json['status'] as String?;
    final error = json['error'] as String?;

    StravaUploadStatus uploadStatus;
    if (error != null) {
      uploadStatus = StravaUploadStatus.error;
    } else if (status == 'Your activity is ready.') {
      uploadStatus = StravaUploadStatus.complete;
    } else if (status == 'Your activity is still being processed.') {
      uploadStatus = StravaUploadStatus.processing;
    } else {
      uploadStatus = StravaUploadStatus.pending;
    }

    return StravaUploadResult(
      activityId: json['activity_id'] as int?,
      status: uploadStatus,
      error: error,
      externalId: json['external_id'] as String?,
    );
  }
}

/// Strava Activity Info
class StravaActivity {
  final int id;
  final String name;
  final String type;
  final DateTime startDate;
  final int elapsedTime;
  final double distance;
  final int? averageWatts;
  final int? maxWatts;

  StravaActivity({
    required this.id,
    required this.name,
    required this.type,
    required this.startDate,
    required this.elapsedTime,
    required this.distance,
    this.averageWatts,
    this.maxWatts,
  });

  factory StravaActivity.fromJson(Map<String, dynamic> json) {
    return StravaActivity(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      elapsedTime: json['elapsed_time'] as int,
      distance: (json['distance'] as num).toDouble(),
      averageWatts: json['average_watts'] as int?,
      maxWatts: json['max_watts'] as int?,
    );
  }
}

/// Strava API Client
class StravaApi {
  final StravaAuth _auth;
  final Dio _dio;

  StravaApi(this._auth) : _dio = Dio(BaseOptions(baseUrl: StravaConfig.apiBaseUrl));

  /// Authentifizierten Request durchführen
  Future<Response<T>> _authRequest<T>(
    String method,
    String path, {
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Options? options,
  }) async {
    final token = await _auth.getAccessToken();
    final opts = (options ?? Options()).copyWith(
      headers: {
        ...?options?.headers,
        'Authorization': 'Bearer $token',
      },
    );

    return _dio.request<T>(
      path,
      queryParameters: queryParameters,
      data: data,
      options: opts.copyWith(method: method),
    );
  }

  /// Lädt eine Session als Activity zu Strava hoch
  Future<StravaUploadResult> uploadActivity(
    TrainingSession session, {
    String? name,
    String? description,
    bool isTrainer = true,
  }) async {
    // Session zu FIT exportieren
    final fitPath = await FitExporter.exportToFile(session);
    final fitFile = File(fitPath);

    // Activity Name generieren
    final activityName = name ?? _generateActivityName(session);

    // Multipart Upload
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        fitFile.path,
        filename: 'activity.fit',
      ),
      'name': activityName,
      'description': description ?? 'Uploaded from VibedKickr',
      'trainer': isTrainer ? '1' : '0',
      'data_type': 'fit',
      'activity_type': 'VirtualRide',
      'external_id': 'vibedkickr_${session.id}',
    });

    try {
      final response = await _authRequest<Map<String, dynamic>>(
        'POST',
        '/uploads',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      final uploadId = response.data!['id'] as int;

      // Upload Status prüfen (Strava verarbeitet asynchron)
      return await _pollUploadStatus(uploadId);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 409) {
        // Duplicate activity
        return StravaUploadResult(
          status: StravaUploadStatus.error,
          error: 'Diese Aktivität wurde bereits hochgeladen',
        );
      }
      rethrow;
    } finally {
      // Temp-Datei löschen
      try {
        await fitFile.delete();
      } catch (_) {}
    }
  }

  /// Wartet auf Verarbeitung des Uploads
  Future<StravaUploadResult> _pollUploadStatus(int uploadId) async {
    const maxAttempts = 10;
    const delay = Duration(seconds: 2);

    for (int i = 0; i < maxAttempts; i++) {
      await Future.delayed(delay);

      final response = await _authRequest<Map<String, dynamic>>(
        'GET',
        '/uploads/$uploadId',
      );

      final result = StravaUploadResult.fromJson(response.data!);

      if (result.status == StravaUploadStatus.complete ||
          result.status == StravaUploadStatus.error) {
        return result;
      }
    }

    return StravaUploadResult(
      status: StravaUploadStatus.processing,
      error: 'Upload wird noch verarbeitet',
    );
  }

  /// Holt Athleten-Profil
  Future<Map<String, dynamic>> getAthlete() async {
    final response = await _authRequest<Map<String, dynamic>>('GET', '/athlete');
    return response.data!;
  }

  /// Holt letzte Aktivitäten
  Future<List<StravaActivity>> getActivities({int page = 1, int perPage = 30}) async {
    final response = await _authRequest<List<dynamic>>(
      'GET',
      '/athlete/activities',
      queryParameters: {'page': page, 'per_page': perPage},
    );

    return response.data!
        .map((json) => StravaActivity.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Aktualisiert eine Aktivität
  Future<void> updateActivity(
    int activityId, {
    String? name,
    String? description,
  }) async {
    await _authRequest(
      'PUT',
      '/activities/$activityId',
      data: {
        if (name != null) 'name': name,
        if (description != null) 'description': description,
      },
    );
  }

  String _generateActivityName(TrainingSession session) {
    final typeNames = {
      SessionType.workout: 'Indoor Cycling Workout',
      SessionType.freeRide: 'Indoor Free Ride',
      SessionType.ftpTest: 'FTP Test',
      SessionType.gpxRoute: 'Virtual Ride',
    };
    return typeNames[session.type] ?? 'Indoor Cycling';
  }
}
