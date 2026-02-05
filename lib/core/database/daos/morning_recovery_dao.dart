import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/morning_recovery_table.dart';

part 'morning_recovery_dao.g.dart';

@DriftAccessor(tables: [MorningRecoveryScores])
class MorningRecoveryDao extends DatabaseAccessor<AppDatabase>
    with _$MorningRecoveryDaoMixin {
  MorningRecoveryDao(AppDatabase db) : super(db);

  /// Insert a new recovery score
  Future<int> insertScore(MorningRecoveryScoresCompanion score) {
    return into(morningRecoveryScores).insert(score);
  }

  /// Get scores for a date range (for trend chart)
  Future<List<MorningRecoveryScoreEntity>> getScoresByDateRange(
    DateTime start,
    DateTime end,
  ) {
    return (select(morningRecoveryScores)
          ..where((t) =>
              t.date.isBiggerOrEqualValue(start) &
              t.date.isSmallerOrEqualValue(end))
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();
  }

  /// Get the latest N scores
  Future<List<MorningRecoveryScoreEntity>> getLatestScores(int count) {
    return (select(morningRecoveryScores)
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(count))
        .get();
  }

  /// Get score for a specific date
  Future<MorningRecoveryScoreEntity?> getScoreForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(morningRecoveryScores)
          ..where((t) =>
              t.date.isBiggerOrEqualValue(startOfDay) &
              t.date.isSmallerThanValue(endOfDay)))
        .getSingleOrNull();
  }

  /// Watch latest scores as a stream (for reactive UI)
  Stream<List<MorningRecoveryScoreEntity>> watchLatestScores(int count) {
    return (select(morningRecoveryScores)
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(count))
        .watch();
  }

  /// Get consecutive day streak count
  Future<int> getStreak() async {
    final scores = await (select(morningRecoveryScores)
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(60))
        .get();

    if (scores.isEmpty) return 0;

    int streak = 1;
    for (int i = 1; i < scores.length; i++) {
      final prevDate = DateTime(
        scores[i - 1].date.year,
        scores[i - 1].date.month,
        scores[i - 1].date.day,
      );
      final currDate = DateTime(
        scores[i].date.year,
        scores[i].date.month,
        scores[i].date.day,
      );
      final diff = prevDate.difference(currDate).inDays;
      if (diff == 1) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }
}
