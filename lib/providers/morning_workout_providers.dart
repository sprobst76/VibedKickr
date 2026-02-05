import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/database/app_database.dart';
import '../core/database/daos/morning_recovery_dao.dart';
import 'providers.dart';

// ============================================================================
// Morning Recovery DAO Provider
// ============================================================================

/// Morning Recovery DAO (für Datenbankzugriff)
final morningRecoveryDaoProvider = Provider<MorningRecoveryDao>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.morningRecoveryDao;
});

// ============================================================================
// Morning Recovery Data Providers
// ============================================================================

/// Letzte N Recovery Scores als Stream (für reaktive UI)
final latestMorningRecoveryScoresProvider =
    StreamProvider.family<List<MorningRecoveryScoreEntity>, int>((ref, count) {
  final dao = ref.watch(morningRecoveryDaoProvider);
  return dao.watchLatestScores(count);
});

/// Recovery Scores der letzten 7 Tage
final weeklyRecoveryScoresProvider =
    FutureProvider<List<MorningRecoveryScoreEntity>>((ref) async {
  final dao = ref.watch(morningRecoveryDaoProvider);
  final now = DateTime.now();
  final weekAgo = now.subtract(const Duration(days: 7));
  return dao.getScoresByDateRange(weekAgo, now);
});

/// Recovery Scores der letzten 30 Tage
final monthlyRecoveryScoresProvider =
    FutureProvider<List<MorningRecoveryScoreEntity>>((ref) async {
  final dao = ref.watch(morningRecoveryDaoProvider);
  final now = DateTime.now();
  final monthAgo = now.subtract(const Duration(days: 30));
  return dao.getScoresByDateRange(monthAgo, now);
});

/// Heutige Recovery Score
final todayRecoveryScoreProvider =
    FutureProvider<MorningRecoveryScoreEntity?>((ref) async {
  final dao = ref.watch(morningRecoveryDaoProvider);
  return dao.getScoreForDate(DateTime.now());
});

/// Streak (aufeinanderfolgende Tage)
final morningWorkoutStreakProvider = FutureProvider<int>((ref) async {
  final dao = ref.watch(morningRecoveryDaoProvider);
  return dao.getStreak();
});
