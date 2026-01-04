import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/comeback_mode.dart';
import '../../domain/entities/workout.dart';

/// Service für Comeback Mode Management
class ComebackService {
  static const _storageKey = 'comeback_mode';

  /// Lädt Comeback Mode aus SharedPreferences
  Future<ComebackMode> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_storageKey);
      if (json != null) {
        return ComebackMode.fromJson(jsonDecode(json) as Map<String, dynamic>);
      }
    } catch (e) {
      // Bei Fehler: Default zurückgeben
    }
    return const ComebackMode();
  }

  /// Speichert Comeback Mode
  Future<void> save(ComebackMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(mode.toJson()));
  }

  /// Löscht Comeback Mode
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}

/// Provider für den Comeback Service
final comebackServiceProvider = Provider<ComebackService>((ref) {
  return ComebackService();
});

/// Provider für den Comeback Mode State
final comebackModeProvider =
    StateNotifierProvider<ComebackModeNotifier, ComebackMode>((ref) {
  final service = ref.watch(comebackServiceProvider);
  return ComebackModeNotifier(service);
});

/// Comeback Mode State Notifier
class ComebackModeNotifier extends StateNotifier<ComebackMode> {
  final ComebackService _service;

  ComebackModeNotifier(this._service) : super(const ComebackMode()) {
    _load();
  }

  Future<void> _load() async {
    state = await _service.load();
  }

  /// Startet Comeback Mode
  Future<void> startComeback({
    required int originalFtp,
    int? baselineRestingHr,
    DateTime? illnessStartDate,
    String? illnessType,
  }) async {
    state = ComebackMode(
      isActive: true,
      startDate: DateTime.now(),
      illnessStartDate: illnessStartDate,
      originalFtp: originalFtp,
      baselineRestingHr: baselineRestingHr,
      illnessType: illnessType,
      checkIns: [],
    );
    await _service.save(state);
  }

  /// Beendet Comeback Mode
  Future<void> endComeback() async {
    state = const ComebackMode(isActive: false);
    await _service.clear();
  }

  /// Fügt einen Wellness Check-In hinzu
  Future<void> addCheckIn(WellnessCheckIn checkIn) async {
    // Entferne alten Check-In für heute falls vorhanden
    final updatedCheckIns = state.checkIns
        .where((c) =>
            c.date.year != checkIn.date.year ||
            c.date.month != checkIn.date.month ||
            c.date.day != checkIn.date.day)
        .toList();

    updatedCheckIns.add(checkIn);

    // Sortiere nach Datum
    updatedCheckIns.sort((a, b) => a.date.compareTo(b.date));

    state = state.copyWith(checkIns: updatedCheckIns);
    await _service.save(state);
  }

  /// Aktualisiert Baseline Ruhepuls
  Future<void> updateBaselineHr(int hr) async {
    state = state.copyWith(baselineRestingHr: hr);
    await _service.save(state);
  }
}

/// Comeback Workouts
class ComebackWorkouts {
  /// Generiert Comeback-Workouts basierend auf Phase und FTP
  static List<Workout> getWorkoutsForPhase(ComebackPhase phase, int ftp) {
    switch (phase) {
      case ComebackPhase.week1:
        return _week1Workouts();
      case ComebackPhase.week2:
        return _week2Workouts();
      case ComebackPhase.week3:
        return _week3Workouts();
      case ComebackPhase.week4:
      case ComebackPhase.completed:
        return _week4Workouts();
    }
  }

  /// Woche 1: Sehr leicht, kurz, nur Z1-Z2
  static List<Workout> _week1Workouts() {
    return [
      Workout(
        id: 'comeback_w1_opener',
        name: 'Legs Opener',
        description: 'Sanfter Wiedereinstieg - nur locker treten',
        type: WorkoutType.endurance,
        intervals: [
          WorkoutInterval(
            name: 'Aufwärmen',
            duration: const Duration(minutes: 5),
            type: IntervalType.warmup,
            powerTarget: PowerTarget.ftpPercent(45),
          ),
          WorkoutInterval(
            name: 'Locker rollen',
            duration: const Duration(minutes: 10),
            type: IntervalType.work,
            powerTarget: PowerTarget.ftpPercent(50),
          ),
          WorkoutInterval(
            name: 'Cool Down',
            duration: const Duration(minutes: 5),
            type: IntervalType.cooldown,
            powerTarget: PowerTarget.ftpPercent(40),
          ),
        ],
        isCustom: false,
      ),
      Workout(
        id: 'comeback_w1_easy',
        name: 'Easy Spin',
        description: '30 Minuten in Zone 1-2, hohe Kadenz',
        type: WorkoutType.endurance,
        intervals: [
          WorkoutInterval(
            name: 'Aufwärmen',
            duration: const Duration(minutes: 5),
            type: IntervalType.warmup,
            powerTarget: PowerTarget.ftpPercent(45),
            cadenceMin: 85,
            cadenceMax: 95,
          ),
          WorkoutInterval(
            name: 'Zone 2',
            duration: const Duration(minutes: 20),
            type: IntervalType.work,
            powerTarget: PowerTarget.ftpPercent(55),
            cadenceMin: 90,
            cadenceMax: 100,
          ),
          WorkoutInterval(
            name: 'Cool Down',
            duration: const Duration(minutes: 5),
            type: IntervalType.cooldown,
            powerTarget: PowerTarget.ftpPercent(40),
            cadenceMin: 80,
            cadenceMax: 90,
          ),
        ],
        isCustom: false,
      ),
    ];
  }

  /// Woche 2: Etwas länger, erste kurze Intervalle
  static List<Workout> _week2Workouts() {
    return [
      Workout(
        id: 'comeback_w2_endurance',
        name: 'Endurance Build',
        description: '45 Minuten Grundlage aufbauen',
        type: WorkoutType.endurance,
        intervals: [
          WorkoutInterval(
            name: 'Aufwärmen',
            duration: const Duration(minutes: 10),
            type: IntervalType.warmup,
            powerTarget: PowerTarget.ftpPercent(45),
          ),
          WorkoutInterval(
            name: 'Zone 2',
            duration: const Duration(minutes: 25),
            type: IntervalType.work,
            powerTarget: PowerTarget.ftpPercent(60),
          ),
          WorkoutInterval(
            name: 'Cool Down',
            duration: const Duration(minutes: 10),
            type: IntervalType.cooldown,
            powerTarget: PowerTarget.ftpPercent(40),
          ),
        ],
        isCustom: false,
      ),
      Workout(
        id: 'comeback_w2_tempo',
        name: 'First Tempo Touch',
        description: 'Kurze Tempo-Intervalle um System zu testen',
        type: WorkoutType.interval,
        intervals: [
          WorkoutInterval(
            name: 'Aufwärmen',
            duration: const Duration(minutes: 10),
            type: IntervalType.warmup,
            powerTarget: PowerTarget.ftpPercent(45),
          ),
          // 3x3 min Tempo mit 3 min Pause
          WorkoutInterval(
            name: 'Tempo 1',
            duration: const Duration(minutes: 3),
            type: IntervalType.work,
            powerTarget: PowerTarget.ftpPercent(70),
          ),
          WorkoutInterval(
            name: 'Erholung',
            duration: const Duration(minutes: 3),
            type: IntervalType.rest,
            powerTarget: PowerTarget.ftpPercent(40),
          ),
          WorkoutInterval(
            name: 'Tempo 2',
            duration: const Duration(minutes: 3),
            type: IntervalType.work,
            powerTarget: PowerTarget.ftpPercent(70),
          ),
          WorkoutInterval(
            name: 'Erholung',
            duration: const Duration(minutes: 3),
            type: IntervalType.rest,
            powerTarget: PowerTarget.ftpPercent(40),
          ),
          WorkoutInterval(
            name: 'Tempo 3',
            duration: const Duration(minutes: 3),
            type: IntervalType.work,
            powerTarget: PowerTarget.ftpPercent(70),
          ),
          WorkoutInterval(
            name: 'Cool Down',
            duration: const Duration(minutes: 12),
            type: IntervalType.cooldown,
            powerTarget: PowerTarget.ftpPercent(40),
          ),
        ],
        isCustom: false,
      ),
    ];
  }

  /// Woche 3: Längere Einheiten, mehr Tempo
  static List<Workout> _week3Workouts() {
    return [
      Workout(
        id: 'comeback_w3_endurance',
        name: 'Long Endurance',
        description: '60 Minuten Grundlage',
        type: WorkoutType.endurance,
        intervals: [
          WorkoutInterval(
            name: 'Aufwärmen',
            duration: const Duration(minutes: 10),
            type: IntervalType.warmup,
            powerTarget: PowerTarget.ftpPercent(45),
          ),
          WorkoutInterval(
            name: 'Zone 2',
            duration: const Duration(minutes: 40),
            type: IntervalType.work,
            powerTarget: PowerTarget.ftpPercent(65),
          ),
          WorkoutInterval(
            name: 'Cool Down',
            duration: const Duration(minutes: 10),
            type: IntervalType.cooldown,
            powerTarget: PowerTarget.ftpPercent(40),
          ),
        ],
        isCustom: false,
      ),
      Workout(
        id: 'comeback_w3_sweetspot',
        name: 'Sweet Spot Intro',
        description: 'Erste Sweet Spot Intervalle',
        type: WorkoutType.interval,
        intervals: [
          WorkoutInterval(
            name: 'Aufwärmen',
            duration: const Duration(minutes: 10),
            type: IntervalType.warmup,
            powerTarget: PowerTarget.ftpPercent(45),
          ),
          // 3x5 min Sweet Spot mit 5 min Pause
          WorkoutInterval(
            name: 'Sweet Spot 1',
            duration: const Duration(minutes: 5),
            type: IntervalType.work,
            powerTarget: PowerTarget.ftpPercent(85),
          ),
          WorkoutInterval(
            name: 'Erholung',
            duration: const Duration(minutes: 5),
            type: IntervalType.rest,
            powerTarget: PowerTarget.ftpPercent(40),
          ),
          WorkoutInterval(
            name: 'Sweet Spot 2',
            duration: const Duration(minutes: 5),
            type: IntervalType.work,
            powerTarget: PowerTarget.ftpPercent(85),
          ),
          WorkoutInterval(
            name: 'Erholung',
            duration: const Duration(minutes: 5),
            type: IntervalType.rest,
            powerTarget: PowerTarget.ftpPercent(40),
          ),
          WorkoutInterval(
            name: 'Sweet Spot 3',
            duration: const Duration(minutes: 5),
            type: IntervalType.work,
            powerTarget: PowerTarget.ftpPercent(85),
          ),
          WorkoutInterval(
            name: 'Cool Down',
            duration: const Duration(minutes: 10),
            type: IntervalType.cooldown,
            powerTarget: PowerTarget.ftpPercent(40),
          ),
        ],
        isCustom: false,
      ),
    ];
  }

  /// Woche 4: Zurück zum normalen Training
  static List<Workout> _week4Workouts() {
    return [
      Workout(
        id: 'comeback_w4_threshold',
        name: 'Threshold Test',
        description: 'Teste deine Schwelle - bist du bereit?',
        type: WorkoutType.interval,
        intervals: [
          WorkoutInterval(
            name: 'Aufwärmen',
            duration: const Duration(minutes: 15),
            type: IntervalType.warmup,
            powerTarget: PowerTarget.ftpPercent(55),
          ),
          // 2x10 min Threshold
          WorkoutInterval(
            name: 'Threshold 1',
            duration: const Duration(minutes: 10),
            type: IntervalType.work,
            powerTarget: PowerTarget.ftpPercent(95),
          ),
          WorkoutInterval(
            name: 'Erholung',
            duration: const Duration(minutes: 5),
            type: IntervalType.rest,
            powerTarget: PowerTarget.ftpPercent(40),
          ),
          WorkoutInterval(
            name: 'Threshold 2',
            duration: const Duration(minutes: 10),
            type: IntervalType.work,
            powerTarget: PowerTarget.ftpPercent(95),
          ),
          WorkoutInterval(
            name: 'Cool Down',
            duration: const Duration(minutes: 20),
            type: IntervalType.cooldown,
            powerTarget: PowerTarget.ftpPercent(40),
          ),
        ],
        isCustom: false,
      ),
      Workout(
        id: 'comeback_w4_vo2max',
        name: 'VO2max Opener',
        description: 'Kurze VO2max Intervalle - Willkommen zurück!',
        type: WorkoutType.hiit,
        intervals: [
          WorkoutInterval(
            name: 'Aufwärmen',
            duration: const Duration(minutes: 15),
            type: IntervalType.warmup,
            powerTarget: PowerTarget.ftpPercent(55),
          ),
          // 3x2 min VO2max mit 2 min Pause
          WorkoutInterval(
            name: 'VO2max 1',
            duration: const Duration(minutes: 2),
            type: IntervalType.work,
            powerTarget: PowerTarget.ftpPercent(110),
          ),
          WorkoutInterval(
            name: 'Erholung',
            duration: const Duration(minutes: 2),
            type: IntervalType.rest,
            powerTarget: PowerTarget.ftpPercent(40),
          ),
          WorkoutInterval(
            name: 'VO2max 2',
            duration: const Duration(minutes: 2),
            type: IntervalType.work,
            powerTarget: PowerTarget.ftpPercent(110),
          ),
          WorkoutInterval(
            name: 'Erholung',
            duration: const Duration(minutes: 2),
            type: IntervalType.rest,
            powerTarget: PowerTarget.ftpPercent(40),
          ),
          WorkoutInterval(
            name: 'VO2max 3',
            duration: const Duration(minutes: 2),
            type: IntervalType.work,
            powerTarget: PowerTarget.ftpPercent(110),
          ),
          WorkoutInterval(
            name: 'Cool Down',
            duration: const Duration(minutes: 18),
            type: IntervalType.cooldown,
            powerTarget: PowerTarget.ftpPercent(40),
          ),
        ],
        isCustom: false,
      ),
    ];
  }
}

/// Provider für Comeback Workouts
final comebackWorkoutsProvider = Provider<List<Workout>>((ref) {
  final comebackMode = ref.watch(comebackModeProvider);
  if (!comebackMode.isActive) return [];

  return ComebackWorkouts.getWorkoutsForPhase(
    comebackMode.currentPhase,
    comebackMode.effectiveFtp,
  );
});
