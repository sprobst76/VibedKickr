import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/entities/workout.dart';
import '../../main.dart';

/// Lädt Workout-Definitionen aus JSON-Dateien in assets/workouts/
class WorkoutLibraryService {
  List<Workout> _predefinedWorkouts = [];
  bool _loaded = false;

  List<Workout> get predefinedWorkouts => _predefinedWorkouts;
  bool get isLoaded => _loaded;

  /// Lädt alle Workouts aus den Asset-Dateien
  Future<void> loadWorkouts() async {
    if (_loaded) return;

    final workoutFiles = [
      'assets/workouts/endurance_30.json',
      'assets/workouts/sweet_spot_45.json',
      'assets/workouts/hiit_20.json',
      'assets/workouts/ftp_test_20.json',
      'assets/workouts/tabata_4.json',
    ];

    final workouts = <Workout>[];
    for (final path in workoutFiles) {
      try {
        final jsonString = await rootBundle.loadString(path);
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        workouts.add(Workout.fromJson(json));
      } catch (e) {
        logger.e('Fehler beim Laden von $path: $e');
      }
    }

    _predefinedWorkouts = workouts;
    _loaded = true;
    logger.i('${workouts.length} vordefinierte Workouts geladen');
  }

  /// Sucht ein Workout per ID
  Workout? getWorkoutById(String id) {
    try {
      return _predefinedWorkouts.firstWhere((w) => w.id == id);
    } catch (_) {
      return null;
    }
  }
}
