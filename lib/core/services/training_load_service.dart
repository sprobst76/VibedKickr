import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/training_load.dart';
import '../../domain/entities/training_session.dart';
import '../../domain/repositories/session_repository.dart';

/// Service für Training Load Berechnungen (CTL, ATL, TSB)
class TrainingLoadService {
  static const _cacheKey = 'training_load_cache';
  static const int ctlDays = 42; // Chronic Training Load Zeitkonstante
  static const int atlDays = 7; // Acute Training Load Zeitkonstante

  final SessionRepository _sessionRepository;

  TrainingLoadService(this._sessionRepository);

  /// Berechnet Performance Management Chart Daten
  Future<PerformanceManagementData> calculatePMC({int daysBack = 90}) async {
    // Lade alle Sessions
    final sessions = await _sessionRepository.getAllSessions();

    // Gruppiere TSS nach Datum
    final dailyTss = _groupTssByDate(sessions);

    // Berechne CTL/ATL/TSB für jeden Tag
    final history = _calculateDailyLoads(dailyTss, daysBack);

    // Heutiger Wert
    final today = history.isNotEmpty &&
            _isSameDay(history.last.date, DateTime.now())
        ? history.last
        : null;

    return PerformanceManagementData(
      history: history,
      today: today,
    );
  }

  /// Gruppiert Session-TSS nach Datum
  Map<DateTime, int> _groupTssByDate(List<TrainingSession> sessions) {
    final dailyTss = <DateTime, int>{};

    for (final session in sessions) {
      if (session.stats == null) continue;

      final date = DateTime(
        session.startTime.year,
        session.startTime.month,
        session.startTime.day,
      );

      dailyTss[date] = (dailyTss[date] ?? 0) + session.stats!.tss;
    }

    return dailyTss;
  }

  /// Berechnet tägliche Training Loads mit exponentially weighted moving average
  List<DailyTrainingLoad> _calculateDailyLoads(
    Map<DateTime, int> dailyTss,
    int daysBack,
  ) {
    if (dailyTss.isEmpty) return [];

    final result = <DailyTrainingLoad>[];
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: daysBack));

    // Finde frühestes Datum in den Daten
    final earliestData = dailyTss.keys.reduce(
      (a, b) => a.isBefore(b) ? a : b,
    );
    final effectiveStart = earliestData.isAfter(startDate) ? startDate : earliestData;

    // CTL/ATL Decay-Faktoren (exponentially weighted)
    final ctlDecay = 2.0 / (ctlDays + 1); // ~0.047
    final atlDecay = 2.0 / (atlDays + 1); // ~0.25

    double ctl = 0;
    double atl = 0;

    // Iteriere durch jeden Tag
    var currentDate = effectiveStart;
    while (!currentDate.isAfter(now)) {
      final normalizedDate = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
      );

      final tss = dailyTss[normalizedDate] ?? 0;

      // Exponentially weighted moving average
      ctl = ctl + ctlDecay * (tss - ctl);
      atl = atl + atlDecay * (tss - atl);
      final tsb = ctl - atl;

      // Nur Tage ab startDate in die Historie aufnehmen
      if (!currentDate.isBefore(startDate)) {
        result.add(DailyTrainingLoad(
          date: normalizedDate,
          tss: tss,
          ctl: ctl,
          atl: atl,
          tsb: tsb,
        ));
      }

      currentDate = currentDate.add(const Duration(days: 1));
    }

    return result;
  }

  /// Prüft ob zwei Daten am selben Tag sind
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Speichert PMC Cache
  Future<void> cacheData(PerformanceManagementData data) async {
    final prefs = await SharedPreferences.getInstance();
    final json = {
      'history': data.history.map((d) => d.toJson()).toList(),
      'cachedAt': DateTime.now().toIso8601String(),
    };
    await prefs.setString(_cacheKey, jsonEncode(json));
  }

  /// Lädt PMC aus Cache (für schnelleren Start)
  Future<PerformanceManagementData?> loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_cacheKey);
      if (jsonStr == null) return null;

      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      final cachedAt = DateTime.parse(json['cachedAt'] as String);

      // Cache ist maximal 1 Stunde gültig
      if (DateTime.now().difference(cachedAt).inHours > 1) {
        return null;
      }

      final history = (json['history'] as List)
          .map((h) => DailyTrainingLoad.fromJson(h as Map<String, dynamic>))
          .toList();

      final today = history.isNotEmpty &&
              _isSameDay(history.last.date, DateTime.now())
          ? history.last
          : null;

      return PerformanceManagementData(
        history: history,
        today: today,
      );
    } catch (e) {
      return null;
    }
  }

  /// Berechnet prognostizierten TSB nach geplantem Training
  double predictTsb({
    required double currentCtl,
    required double currentAtl,
    required int plannedTss,
  }) {
    final ctlDecay = 2.0 / (ctlDays + 1);
    final atlDecay = 2.0 / (atlDays + 1);

    final newCtl = currentCtl + ctlDecay * (plannedTss - currentCtl);
    final newAtl = currentAtl + atlDecay * (plannedTss - currentAtl);

    return newCtl - newAtl;
  }

  /// Empfiehlt TSS für heute basierend auf Ziel-TSB
  int recommendTssForTarget({
    required double currentCtl,
    required double currentAtl,
    required double targetTsb,
  }) {
    // Vereinfachte Berechnung: Welcher TSS heute würde zum Ziel-TSB führen?
    final ctlDecay = 2.0 / (ctlDays + 1);
    final atlDecay = 2.0 / (atlDays + 1);

    // TSB = CTL - ATL
    // newTSB = (CTL + ctlDecay*(TSS-CTL)) - (ATL + atlDecay*(TSS-ATL))
    // targetTsb = CTL + ctlDecay*TSS - ctlDecay*CTL - ATL - atlDecay*TSS + atlDecay*ATL
    // targetTsb = (CTL - ATL) + TSS*(ctlDecay - atlDecay) - ctlDecay*CTL + atlDecay*ATL
    // TSS = (targetTsb - CTL + ATL + ctlDecay*CTL - atlDecay*ATL) / (ctlDecay - atlDecay)

    final denominator = ctlDecay - atlDecay;
    if (denominator.abs() < 0.001) return 0;

    final tss = (targetTsb - currentCtl + currentAtl +
            ctlDecay * currentCtl -
            atlDecay * currentAtl) /
        denominator;

    return tss.clamp(0, 500).round();
  }
}

/// Aktueller Trainings-Status (kompakte Darstellung)
class TrainingStatus {
  final double ctl;
  final double atl;
  final double tsb;
  final int weeklyTss;
  final FitnessTrend trend;

  const TrainingStatus({
    required this.ctl,
    required this.atl,
    required this.tsb,
    required this.weeklyTss,
    required this.trend,
  });

  TrainingFormState get formState {
    if (tsb > 25) return TrainingFormState.fresh;
    if (tsb > 5) return TrainingFormState.rested;
    if (tsb > -10) return TrainingFormState.optimal;
    if (tsb > -25) return TrainingFormState.tired;
    return TrainingFormState.exhausted;
  }
}
