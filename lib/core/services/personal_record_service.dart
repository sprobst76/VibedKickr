import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/training_session.dart';
import '../database/daos/personal_record_dao.dart';
import '../database/tables/personal_record_table.dart';
import '../../providers/providers.dart';

/// Service für Personal Records Analyse und Verwaltung
class PersonalRecordService {
  final PersonalRecordDao _dao;

  PersonalRecordService(this._dao);

  /// Analysiert eine Session auf neue PRs
  /// Gibt eine Liste der neu aufgestellten PRs zurück
  Future<List<PersonalRecord>> analyzeSession(TrainingSession session) async {
    final newRecords = <PersonalRecord>[];

    if (session.dataPoints.isEmpty) return newRecords;

    // Power-Werte extrahieren (nur nicht-null Werte)
    final powerValues =
        session.dataPoints.map((dp) => dp.power).where((p) => p > 0).toList();

    if (powerValues.isEmpty) return newRecords;

    // Für jeden PR-Typ prüfen
    for (final recordType in RecordType.values) {
      final duration = recordType.duration;
      final sampleCount = (duration.inMilliseconds / 1000).round();

      // Skip wenn Session zu kurz
      if (powerValues.length < sampleCount) continue;

      // Durchschnittliche Power für die Dauer berechnen (gleitender Durchschnitt)
      final bestPower = _calculateBestAverage(powerValues, sampleCount);

      if (bestPower > 0) {
        // Prüfen ob es ein neuer PR ist
        final currentRecord = await _dao.getCurrentRecord(recordType);

        if (currentRecord == null || bestPower > currentRecord.powerWatts) {
          final newRecord = PersonalRecord(
            recordType: recordType,
            powerWatts: bestPower,
            achievedAt: session.startTime,
            sessionId: session.id,
            previousPowerWatts: currentRecord?.powerWatts,
          );

          // PR speichern
          await _dao.insertRecord(newRecord);
          newRecords.add(newRecord);
        }
      }
    }

    return newRecords;
  }

  /// Berechnet den besten Durchschnittswert über eine bestimmte Anzahl von Samples
  int _calculateBestAverage(List<int> values, int sampleCount) {
    if (values.length < sampleCount) return 0;

    int bestSum = 0;
    int currentSum = 0;

    // Initiale Summe
    for (var i = 0; i < sampleCount; i++) {
      currentSum += values[i];
    }
    bestSum = currentSum;

    // Gleitender Durchschnitt
    for (var i = sampleCount; i < values.length; i++) {
      currentSum = currentSum - values[i - sampleCount] + values[i];
      bestSum = max(bestSum, currentSum);
    }

    return (bestSum / sampleCount).round();
  }

  /// Lädt alle aktuellen PRs
  Future<Map<RecordType, PersonalRecord>> getAllRecords() async {
    return _dao.getAllCurrentRecords();
  }

  /// Beobachtet alle PRs
  Stream<Map<RecordType, PersonalRecord>> watchAllRecords() {
    return _dao.watchAllCurrentRecords();
  }

  /// Lädt die History für einen PR-Typ
  Future<List<PersonalRecord>> getRecordHistory(RecordType type) async {
    return _dao.getRecordHistory(type);
  }
}

/// Provider für den Personal Record Service
final personalRecordServiceProvider = Provider<PersonalRecordService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return PersonalRecordService(db.personalRecordDao);
});

/// Provider für alle aktuellen PRs
final currentRecordsProvider =
    StreamProvider<Map<RecordType, PersonalRecord>>((ref) {
  final service = ref.watch(personalRecordServiceProvider);
  return service.watchAllRecords();
});

/// Provider für PR-History eines bestimmten Typs
final recordHistoryProvider = FutureProvider.family<List<PersonalRecord>, RecordType>(
  (ref, type) async {
    final service = ref.watch(personalRecordServiceProvider);
    return service.getRecordHistory(type);
  },
);
