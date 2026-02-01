import 'package:equatable/equatable.dart';

import 'strength_exercise.dart';

enum LoadTargetType { absolute, percentage, rpe, bodyweight }

enum WorkoutType { fullBody, upperBody, lowerBody, pushPull, core }

/// Lastziel für ein Krafttraining-Intervall (spiegelt PowerTarget-Pattern)
class LoadTarget extends Equatable {
  final LoadTargetType type;
  final double? weight; // kg für absolute Last
  final int? percentage; // % of 1RM
  final int? rpe; // Rate of Perceived Exertion (1-10)
  final String? bodyweightVariation; // 'standard', 'assisted', 'weighted'

  const LoadTarget({
    required this.type,
    this.weight,
    this.percentage,
    this.rpe,
    this.bodyweightVariation,
  });

  /// Absolute Gewicht in kg
  factory LoadTarget.weight(double kg) {
    return LoadTarget(type: LoadTargetType.absolute, weight: kg);
  }

  /// Prozent vom 1RM
  factory LoadTarget.percentage(int percent, double oneRepMax) {
    return LoadTarget(
      type: LoadTargetType.percentage,
      percentage: percent,
      weight: (percent / 100.0) * oneRepMax,
    );
  }

  /// Rate of Perceived Exertion (1-10)
  factory LoadTarget.rpe(int rpe) {
    return LoadTarget(type: LoadTargetType.rpe, rpe: rpe);
  }

  /// Bodyweight (standard/assisted/weighted)
  factory LoadTarget.bodyweight({String variation = 'standard'}) {
    return LoadTarget(
      type: LoadTargetType.bodyweight,
      bodyweightVariation: variation,
    );
  }

  /// Gibt die tatsächliche Last in kg zurück (wenn bekannt)
  double? resolveWeight() {
    return weight;
  }

  factory LoadTarget.fromJson(Map<String, dynamic> json) {
    final type = LoadTargetType.values.firstWhere(
      (t) => t.name == json['type'],
      orElse: () => LoadTargetType.bodyweight,
    );
    return LoadTarget(
      type: type,
      weight: json['weight'] as double?,
      percentage: json['percentage'] as int?,
      rpe: json['rpe'] as int?,
      bodyweightVariation: json['bodyweightVariation'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'weight': weight,
        'percentage': percentage,
        'rpe': rpe,
        'bodyweightVariation': bodyweightVariation,
      };

  @override
  List<Object?> get props => [type, weight, percentage, rpe, bodyweightVariation];
}

/// Ein einzelnes Intervall im Krafttraining-Workout
class StrengthInterval extends Equatable {
  final String exerciseId;
  final int sets;
  final int repsTarget; // Ziel-Wiederholungen pro Satz
  final int? repsMin; // Minimum für Bereich (z.B. 8-12)
  final int? repsMax; // Maximum für Bereich
  final LoadTarget loadTarget;
  final Duration restBetweenSets;
  final String? tempo; // z.B. "3-1-1" (eccentric-pause-concentric)
  final String? instructions;

  const StrengthInterval({
    required this.exerciseId,
    required this.sets,
    required this.repsTarget,
    this.repsMin,
    this.repsMax,
    required this.loadTarget,
    required this.restBetweenSets,
    this.tempo,
    this.instructions,
  });

  factory StrengthInterval.fromJson(Map<String, dynamic> json) {
    return StrengthInterval(
      exerciseId: json['exerciseId'] as String,
      sets: json['sets'] as int,
      repsTarget: json['repsTarget'] as int,
      repsMin: json['repsMin'] as int?,
      repsMax: json['repsMax'] as int?,
      loadTarget: LoadTarget.fromJson(json['loadTarget'] as Map<String, dynamic>),
      restBetweenSets: Duration(seconds: json['restBetweenSetsSecs'] as int? ?? 90),
      tempo: json['tempo'] as String?,
      instructions: json['instructions'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'exerciseId': exerciseId,
        'sets': sets,
        'repsTarget': repsTarget,
        'repsMin': repsMin,
        'repsMax': repsMax,
        'loadTarget': loadTarget.toJson(),
        'restBetweenSetsSecs': restBetweenSets.inSeconds,
        'tempo': tempo,
        'instructions': instructions,
      };

  StrengthInterval copyWith({
    String? exerciseId,
    int? sets,
    int? repsTarget,
    int? repsMin,
    int? repsMax,
    LoadTarget? loadTarget,
    Duration? restBetweenSets,
    String? tempo,
    String? instructions,
  }) {
    return StrengthInterval(
      exerciseId: exerciseId ?? this.exerciseId,
      sets: sets ?? this.sets,
      repsTarget: repsTarget ?? this.repsTarget,
      repsMin: repsMin ?? this.repsMin,
      repsMax: repsMax ?? this.repsMax,
      loadTarget: loadTarget ?? this.loadTarget,
      restBetweenSets: restBetweenSets ?? this.restBetweenSets,
      tempo: tempo ?? this.tempo,
      instructions: instructions ?? this.instructions,
    );
  }

  @override
  List<Object?> get props => [
        exerciseId,
        sets,
        repsTarget,
        repsMin,
        repsMax,
        loadTarget,
        restBetweenSets,
        tempo,
        instructions,
      ];
}

/// Komplettes Krafttraining-Workout
class StrengthWorkout extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<StrengthInterval> intervals;
  final WorkoutType type;
  final int estimatedDurationMinutes;
  final DifficultyLevel difficulty;
  final bool isCustom;
  final DateTime? createdAt;

  const StrengthWorkout({
    required this.id,
    required this.name,
    required this.description,
    required this.intervals,
    required this.type,
    required this.estimatedDurationMinutes,
    required this.difficulty,
    this.isCustom = false,
    this.createdAt,
  });

  /// Berechnet die Gesamtdauer basierend auf Sets, Reps und Ruhezeiten
  /// Vereinfachte Schätzung: ~3 Sekunden pro Rep + Ruhezeit
  Duration get estimatedTotalDuration {
    double totalSeconds = 0;
    for (final interval in intervals) {
      // Zeit für Sets und Reps: ~3 Sekunden pro Rep
      final repsPerSet = interval.repsTarget;
      final secondsPerSet = repsPerSet * 3.0;
      totalSeconds += (secondsPerSet + interval.restBetweenSets.inSeconds) * interval.sets;
    }
    return Duration(seconds: totalSeconds.ceil());
  }

  factory StrengthWorkout.fromJson(Map<String, dynamic> json) {
    return StrengthWorkout(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      intervals: (json['intervals'] as List)
          .map((i) => StrengthInterval.fromJson(i as Map<String, dynamic>))
          .toList(),
      type: WorkoutType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => WorkoutType.fullBody,
      ),
      estimatedDurationMinutes: json['estimatedDurationMinutes'] as int,
      difficulty: DifficultyLevel.values.firstWhere(
        (d) => d.name == json['difficulty'],
        orElse: () => DifficultyLevel.beginner,
      ),
      isCustom: json['isCustom'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'intervals': intervals.map((i) => i.toJson()).toList(),
        'type': type.name,
        'estimatedDurationMinutes': estimatedDurationMinutes,
        'difficulty': difficulty.name,
        'isCustom': isCustom,
        'createdAt': createdAt?.millisecondsSinceEpoch,
      };

  StrengthWorkout copyWith({
    String? id,
    String? name,
    String? description,
    List<StrengthInterval>? intervals,
    WorkoutType? type,
    int? estimatedDurationMinutes,
    DifficultyLevel? difficulty,
    bool? isCustom,
    DateTime? createdAt,
  }) {
    return StrengthWorkout(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      intervals: intervals ?? this.intervals,
      type: type ?? this.type,
      estimatedDurationMinutes: estimatedDurationMinutes ?? this.estimatedDurationMinutes,
      difficulty: difficulty ?? this.difficulty,
      isCustom: isCustom ?? this.isCustom,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        intervals,
        type,
        estimatedDurationMinutes,
        difficulty,
        isCustom,
        createdAt,
      ];
}
