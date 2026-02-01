import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/strength_pr_table.dart';

part 'strength_pr_dao.g.dart';

/// Domain-Modell für Kraft-Training PRs
class StrengthPR {
  final int? id;
  final String exerciseId;
  final double weightKg;
  final int reps;
  final DateTime achievedAt;
  final String? sessionId;
  final double? previousWeightKg;

  const StrengthPR({
    this.id,
    required this.exerciseId,
    required this.weightKg,
    required this.reps,
    required this.achievedAt,
    this.sessionId,
    this.previousWeightKg,
  });

  /// Verbesserung gegenüber dem vorherigen PR in kg
  double? get improvement =>
      previousWeightKg != null ? weightKg - previousWeightKg! : null;

  /// Prozentuale Verbesserung
  double? get improvementPercent => previousWeightKg != null
      ? ((weightKg - previousWeightKg!) / previousWeightKg! * 100)
      : null;
}

@DriftAccessor(tables: [StrengthPersonalRecords])
class StrengthPRDao extends DatabaseAccessor<AppDatabase>
    with _$StrengthPRDaoMixin {
  StrengthPRDao(super.db);

  /// Speichert einen neuen PR
  Future<int> insertRecord(StrengthPR pr) async {
    return await into(strengthPersonalRecords).insert(
      StrengthPersonalRecordsCompanion.insert(
        exerciseId: pr.exerciseId,
        weightKg: pr.weightKg,
        reps: pr.reps,
        achievedAt: pr.achievedAt,
        sessionId: Value(pr.sessionId),
        previousWeightKg: Value(pr.previousWeightKg),
      ),
    );
  }

  /// Lädt den aktuellen PR für eine Übung und Wiederholungen
  Future<StrengthPR?> getCurrentRecord(String exerciseId, int reps) async {
    final entity = await (select(strengthPersonalRecords)
          ..where((t) => t.exerciseId.equals(exerciseId) & t.reps.equals(reps))
          ..orderBy([(t) => OrderingTerm.desc(t.weightKg)])
          ..limit(1))
        .getSingleOrNull();

    return entity != null ? _entityToPR(entity) : null;
  }

  /// Lädt alle aktuellen PRs einer Übung
  Future<Map<int, StrengthPR>> getAllCurrentRecords(String exerciseId) async {
    final records = <int, StrengthPR>{};

    // Common reps to track: 1RM, 3RM, 5RM, 10RM
    for (final reps in [1, 3, 5, 10]) {
      final record = await getCurrentRecord(exerciseId, reps);
      if (record != null) {
        records[reps] = record;
      }
    }

    return records;
  }

  /// Lädt alle aktuellen PRs aller Übungen
  Future<Map<String, Map<int, StrengthPR>>> getAllCurrentRecordsAllExercises() async {
    final allRecords = <String, Map<int, StrengthPR>>{};

    // Get all distinct exercise IDs
    final exerciseIds = await (selectOnly(strengthPersonalRecords)
          ..addColumns([strengthPersonalRecords.exerciseId])
          ..groupBy([strengthPersonalRecords.exerciseId]))
        .map((row) => row.read(strengthPersonalRecords.exerciseId))
        .get();

    for (final exerciseId in exerciseIds) {
      if (exerciseId != null) {
        allRecords[exerciseId] = await getAllCurrentRecords(exerciseId);
      }
    }

    return allRecords;
  }

  /// Beobachtet alle aktuellen PRs für eine Übung
  Stream<Map<int, StrengthPR>> watchRecordsByExercise(String exerciseId) {
    return (select(strengthPersonalRecords)
          ..where((t) => t.exerciseId.equals(exerciseId)))
        .watch()
        .asyncMap((_) async => getAllCurrentRecords(exerciseId));
  }

  /// Lädt die PR-History für eine Übung und Wiederholungen
  Future<List<StrengthPR>> getRecordHistory(
    String exerciseId,
    int reps, {
    int limit = 10,
  }) async {
    final entities = await (select(strengthPersonalRecords)
          ..where((t) =>
              t.exerciseId.equals(exerciseId) & t.reps.equals(reps))
          ..orderBy([(t) => OrderingTerm.desc(t.achievedAt)])
          ..limit(limit))
        .get();

    return entities.map(_entityToPR).toList();
  }

  /// Prüft ob ein neuer Wert ein PR ist
  Future<bool> isNewRecord(
    String exerciseId,
    int reps,
    double weightKg,
  ) async {
    final current = await getCurrentRecord(exerciseId, reps);
    return current == null || weightKg > current.weightKg;
  }

  /// Löscht einen PR-Eintrag
  Future<bool> deleteRecord(int id) async {
    return await (delete(strengthPersonalRecords)
          ..where((t) => t.id.equals(id)))
        .go() >
        0;
  }

  /// Konvertiert eine Entity zu einem Domain-Objekt
  StrengthPR _entityToPR(StrengthPREntity entity) {
    return StrengthPR(
      id: entity.id,
      exerciseId: entity.exerciseId,
      weightKg: entity.weightKg,
      reps: entity.reps,
      achievedAt: entity.achievedAt,
      sessionId: entity.sessionId,
      previousWeightKg: entity.previousWeightKg,
    );
  }
}
