import 'package:equatable/equatable.dart';

import 'strength_exercise.dart';

/// Ein einzelner Satz aus einer Krafttraining-Session
class StrengthSetRecord extends Equatable {
  final int setNumber;
  final int repsCompleted;
  final double? weightUsed; // kg
  final int? rpe; // Rate of Perceived Exertion (1-10)
  final DateTime timestamp;
  final Duration? restAfter;

  const StrengthSetRecord({
    required this.setNumber,
    required this.repsCompleted,
    this.weightUsed,
    this.rpe,
    required this.timestamp,
    this.restAfter,
  });

  factory StrengthSetRecord.fromJson(Map<String, dynamic> json) {
    return StrengthSetRecord(
      setNumber: json['setNumber'] as int,
      repsCompleted: json['repsCompleted'] as int,
      weightUsed: json['weightUsed'] as double?,
      rpe: json['rpe'] as int?,
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestampMs'] as int),
      restAfter: json['restAfterSecs'] != null
          ? Duration(seconds: json['restAfterSecs'] as int)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'setNumber': setNumber,
        'repsCompleted': repsCompleted,
        'weightUsed': weightUsed,
        'rpe': rpe,
        'timestampMs': timestamp.millisecondsSinceEpoch,
        'restAfterSecs': restAfter?.inSeconds,
      };

  @override
  List<Object?> get props => [setNumber, repsCompleted, weightUsed, rpe, timestamp, restAfter];
}

/// Alle Sätze für eine einzelne Übung innerhalb einer Session
class StrengthExerciseRecord extends Equatable {
  final String exerciseId;
  final String exerciseName;
  final List<StrengthSetRecord> sets;
  final int? finalRpe; // Gesamtes RPE für die Übung

  const StrengthExerciseRecord({
    required this.exerciseId,
    required this.exerciseName,
    required this.sets,
    this.finalRpe,
  });

  /// Berechnet das durchschnittliche Gewicht über alle Sätze
  double? get avgWeight {
    final weights = sets.where((s) => s.weightUsed != null).map((s) => s.weightUsed!);
    if (weights.isEmpty) return null;
    return weights.reduce((a, b) => a + b) / weights.length;
  }

  /// Berechnet das Gesamtvolumen (Sätze × Reps × Gewicht in kg)
  double get totalVolume {
    return sets.fold(0.0, (total, set) {
      final weight = set.weightUsed ?? 0;
      return total + (set.repsCompleted * weight);
    });
  }

  /// Berechnet durchschnittliches RPE
  int? get avgRpe {
    final rpes = sets.where((s) => s.rpe != null).map((s) => s.rpe!);
    if (rpes.isEmpty) return null;
    return (rpes.reduce((a, b) => a + b) / rpes.length).round();
  }

  factory StrengthExerciseRecord.fromJson(Map<String, dynamic> json) {
    return StrengthExerciseRecord(
      exerciseId: json['exerciseId'] as String,
      exerciseName: json['exerciseName'] as String,
      sets: (json['sets'] as List)
          .map((s) => StrengthSetRecord.fromJson(s as Map<String, dynamic>))
          .toList(),
      finalRpe: json['finalRpe'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'exerciseId': exerciseId,
        'exerciseName': exerciseName,
        'sets': sets.map((s) => s.toJson()).toList(),
        'finalRpe': finalRpe,
      };

  @override
  List<Object?> get props => [exerciseId, exerciseName, sets, finalRpe];
}

/// Statistiken einer Krafttraining-Session
class StrengthSessionStats extends Equatable {
  final Duration duration;
  final int totalSets;
  final int totalReps;
  final double totalVolume; // sets × reps × weight (kg)
  final int? avgRpe;
  final int exercisesCompleted;
  final Map<MuscleGroup, int> muscleGroupWork; // Volumen pro Muskelgruppe

  const StrengthSessionStats({
    required this.duration,
    required this.totalSets,
    required this.totalReps,
    required this.totalVolume,
    this.avgRpe,
    required this.exercisesCompleted,
    required this.muscleGroupWork,
  });

  factory StrengthSessionStats.fromJson(Map<String, dynamic> json) {
    return StrengthSessionStats(
      duration: Duration(seconds: json['durationSecs'] as int),
      totalSets: json['totalSets'] as int,
      totalReps: json['totalReps'] as int,
      totalVolume: json['totalVolume'] as double,
      avgRpe: json['avgRpe'] as int?,
      exercisesCompleted: json['exercisesCompleted'] as int,
      muscleGroupWork: (json['muscleGroupWork'] as Map<String, dynamic>).map(
        (k, v) => MapEntry(
          MuscleGroup.values.firstWhere(
            (mg) => mg.name == k,
            orElse: () => MuscleGroup.fullBody,
          ),
          v as int,
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'durationSecs': duration.inSeconds,
        'totalSets': totalSets,
        'totalReps': totalReps,
        'totalVolume': totalVolume,
        'avgRpe': avgRpe,
        'exercisesCompleted': exercisesCompleted,
        'muscleGroupWork': muscleGroupWork.map((k, v) => MapEntry(k.name, v)),
      };

  @override
  List<Object?> get props => [
        duration,
        totalSets,
        totalReps,
        totalVolume,
        avgRpe,
        exercisesCompleted,
        muscleGroupWork,
      ];
}

/// Eine komplette Krafttraining-Session (zwei-Schicht: Rohdaten + berechnete Stats)
class StrengthSession extends Equatable {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final String? workoutId;
  final List<StrengthExerciseRecord> exercises;
  final StrengthSessionStats? stats;
  final String? notes;

  const StrengthSession({
    required this.id,
    required this.startTime,
    this.endTime,
    this.workoutId,
    required this.exercises,
    this.stats,
    this.notes,
  });

  /// Duration zwischen startTime und endTime
  Duration get duration {
    if (endTime == null) {
      return DateTime.now().difference(startTime);
    }
    return endTime!.difference(startTime);
  }

  /// Berechnet Gesamtvolumen aus allen Übungen
  double get totalVolume {
    return exercises.fold(0.0, (total, ex) => total + ex.totalVolume);
  }

  /// Berechnet durchschnittliches RPE über alle Sätze
  int? get avgRpe {
    final rpes = <int>[];
    for (final ex in exercises) {
      for (final set in ex.sets) {
        if (set.rpe != null) {
          rpes.add(set.rpe!);
        }
      }
    }
    if (rpes.isEmpty) return null;
    return (rpes.reduce((a, b) => a + b) / rpes.length).round();
  }

  factory StrengthSession.fromJson(Map<String, dynamic> json) {
    return StrengthSession(
      id: json['id'] as String,
      startTime: DateTime.fromMillisecondsSinceEpoch(json['startTimeMs'] as int),
      endTime: json['endTimeMs'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['endTimeMs'] as int)
          : null,
      workoutId: json['workoutId'] as String?,
      exercises: (json['exercises'] as List)
          .map((e) => StrengthExerciseRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
      stats: json['stats'] != null
          ? StrengthSessionStats.fromJson(json['stats'] as Map<String, dynamic>)
          : null,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'startTimeMs': startTime.millisecondsSinceEpoch,
        'endTimeMs': endTime?.millisecondsSinceEpoch,
        'workoutId': workoutId,
        'exercises': exercises.map((e) => e.toJson()).toList(),
        'stats': stats?.toJson(),
        'notes': notes,
      };

  StrengthSession copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    String? workoutId,
    List<StrengthExerciseRecord>? exercises,
    StrengthSessionStats? stats,
    String? notes,
  }) {
    return StrengthSession(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      workoutId: workoutId ?? this.workoutId,
      exercises: exercises ?? this.exercises,
      stats: stats ?? this.stats,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [id, startTime, endTime, workoutId, exercises, stats, notes];
}
