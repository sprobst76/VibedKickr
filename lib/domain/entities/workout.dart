import 'package:equatable/equatable.dart';

enum WorkoutType {
  endurance,
  interval,
  hiit,
  tabata,
  pyramid,
  ramp,
  ftpTest,
  freeRide,
  gpxRoute,
}

enum IntervalType {
  warmup,
  work,
  rest,
  cooldown,
  freeRide,
}

/// Leistungsziel für ein Intervall
class PowerTarget extends Equatable {
  final PowerTargetType type;
  final int? watts; // Für absolute
  final int? ftpPercent; // Für FTP-basiert
  final int? minWatts; // Für Range
  final int? maxWatts; // Für Range

  const PowerTarget({
    required this.type,
    this.watts,
    this.ftpPercent,
    this.minWatts,
    this.maxWatts,
  });

  /// Absolute Watt-Zahl
  factory PowerTarget.absolute(int watts) {
    return PowerTarget(type: PowerTargetType.absolute, watts: watts);
  }

  /// Prozent vom FTP
  factory PowerTarget.ftpPercent(int percent) {
    return PowerTarget(type: PowerTargetType.ftpPercent, ftpPercent: percent);
  }

  /// Watt-Range (für ERG mit Toleranz)
  factory PowerTarget.range(int min, int max) {
    return PowerTarget(type: PowerTargetType.range, minWatts: min, maxWatts: max);
  }

  /// Freies Fahren
  factory PowerTarget.free() {
    return const PowerTarget(type: PowerTargetType.free);
  }

  /// Berechnet die Ziel-Watt basierend auf FTP
  int resolveWatts(int ftp) {
    return switch (type) {
      PowerTargetType.absolute => watts ?? 0,
      PowerTargetType.ftpPercent => ((ftpPercent ?? 0) * ftp / 100).round(),
      PowerTargetType.range => ((minWatts ?? 0) + (maxWatts ?? 0)) ~/ 2,
      PowerTargetType.free => 0,
    };
  }

  factory PowerTarget.fromJson(Map<String, dynamic> json) {
    final type = PowerTargetType.values.firstWhere(
      (t) => t.name == json['type'],
      orElse: () => PowerTargetType.free,
    );
    return PowerTarget(
      type: type,
      watts: json['watts'] as int?,
      ftpPercent: json['ftpPercent'] as int?,
      minWatts: json['minWatts'] as int?,
      maxWatts: json['maxWatts'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'watts': watts,
        'ftpPercent': ftpPercent,
        'minWatts': minWatts,
        'maxWatts': maxWatts,
      };

  @override
  List<Object?> get props => [type, watts, ftpPercent, minWatts, maxWatts];
}

enum PowerTargetType { absolute, ftpPercent, range, free }

/// Ein einzelnes Intervall im Workout
class WorkoutInterval extends Equatable {
  final String name;
  final Duration duration;
  final IntervalType type;
  final PowerTarget powerTarget;
  final int? cadenceMin;
  final int? cadenceMax;
  final String? instructions;

  const WorkoutInterval({
    required this.name,
    required this.duration,
    required this.type,
    required this.powerTarget,
    this.cadenceMin,
    this.cadenceMax,
    this.instructions,
  });

  factory WorkoutInterval.fromJson(Map<String, dynamic> json) {
    return WorkoutInterval(
      name: json['name'] as String,
      duration: Duration(milliseconds: json['durationMs'] as int),
      type: IntervalType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => IntervalType.work,
      ),
      powerTarget: PowerTarget.fromJson(json['powerTarget'] as Map<String, dynamic>),
      cadenceMin: json['cadenceMin'] as int?,
      cadenceMax: json['cadenceMax'] as int?,
      instructions: json['instructions'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'durationMs': duration.inMilliseconds,
        'type': type.name,
        'powerTarget': powerTarget.toJson(),
        'cadenceMin': cadenceMin,
        'cadenceMax': cadenceMax,
        'instructions': instructions,
      };

  /// Erstellt eine Kopie mit optionalen Änderungen
  WorkoutInterval copyWith({
    String? name,
    Duration? duration,
    IntervalType? type,
    PowerTarget? powerTarget,
    int? cadenceMin,
    int? cadenceMax,
    String? instructions,
  }) {
    return WorkoutInterval(
      name: name ?? this.name,
      duration: duration ?? this.duration,
      type: type ?? this.type,
      powerTarget: powerTarget ?? this.powerTarget,
      cadenceMin: cadenceMin ?? this.cadenceMin,
      cadenceMax: cadenceMax ?? this.cadenceMax,
      instructions: instructions ?? this.instructions,
    );
  }

  @override
  List<Object?> get props =>
      [name, duration, type, powerTarget, cadenceMin, cadenceMax, instructions];
}

/// Komplettes Workout
class Workout extends Equatable {
  final String id;
  final String name;
  final String description;
  final WorkoutType type;
  final List<WorkoutInterval> intervals;
  final DateTime? createdAt;
  final bool isCustom;

  const Workout({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.intervals,
    this.createdAt,
    this.isCustom = false,
  });

  /// Gesamtdauer des Workouts
  Duration get totalDuration {
    return intervals.fold(
      Duration.zero,
      (total, interval) => total + interval.duration,
    );
  }

  /// Geschätzter TSS (Training Stress Score)
  int estimateTss(int ftp) {
    // Vereinfachte TSS-Berechnung
    double tss = 0;
    for (final interval in intervals) {
      final targetPower = interval.powerTarget.resolveWatts(ftp);
      final durationMinutes = interval.duration.inSeconds / 60;
      final intensityFactor = targetPower / ftp;
      tss += (durationMinutes * intensityFactor * intensityFactor) / 60 * 100;
    }
    return tss.round();
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      type: WorkoutType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => WorkoutType.interval,
      ),
      intervals: (json['intervals'] as List)
          .map((i) => WorkoutInterval.fromJson(i as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int)
          : null,
      isCustom: json['isCustom'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'type': type.name,
        'intervals': intervals.map((i) => i.toJson()).toList(),
        'createdAt': createdAt?.millisecondsSinceEpoch,
        'isCustom': isCustom,
      };

  /// Erstellt eine Kopie mit optionalen Änderungen
  Workout copyWith({
    String? id,
    String? name,
    String? description,
    WorkoutType? type,
    List<WorkoutInterval>? intervals,
    DateTime? createdAt,
    bool? isCustom,
  }) {
    return Workout(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      intervals: intervals ?? this.intervals,
      createdAt: createdAt ?? this.createdAt,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  @override
  List<Object?> get props => [id, name, description, type, intervals, createdAt, isCustom];
}

/// Vordefinierte Workouts
class PredefinedWorkouts {
  static Workout get endurance30 => Workout(
        id: 'endurance_30',
        name: 'Endurance 30',
        description: '30 Minuten moderates Ausdauertraining in Zone 2',
        type: WorkoutType.endurance,
        intervals: [
          WorkoutInterval(
            name: 'Warmup',
            duration: const Duration(minutes: 5),
            type: IntervalType.warmup,
            powerTarget: PowerTarget.ftpPercent(50),
            instructions: 'Locker einrollen',
          ),
          WorkoutInterval(
            name: 'Endurance',
            duration: const Duration(minutes: 20),
            type: IntervalType.work,
            powerTarget: PowerTarget.ftpPercent(65),
            cadenceMin: 85,
            cadenceMax: 95,
            instructions: 'Gleichmäßig treten, Atmung kontrollieren',
          ),
          WorkoutInterval(
            name: 'Cooldown',
            duration: const Duration(minutes: 5),
            type: IntervalType.cooldown,
            powerTarget: PowerTarget.ftpPercent(40),
            instructions: 'Locker ausrollen',
          ),
        ],
      );

  static Workout get sweetSpot45 => Workout(
        id: 'sweet_spot_45',
        name: 'Sweet Spot 45',
        description: '45 Minuten Sweet Spot Training (88-94% FTP)',
        type: WorkoutType.interval,
        intervals: [
          WorkoutInterval(
            name: 'Warmup',
            duration: const Duration(minutes: 10),
            type: IntervalType.warmup,
            powerTarget: PowerTarget.ftpPercent(55),
          ),
          // 3x 10min Sweet Spot mit 3min Pause
          WorkoutInterval(
            name: 'Sweet Spot 1',
            duration: const Duration(minutes: 10),
            type: IntervalType.work,
            powerTarget: PowerTarget.ftpPercent(90),
            cadenceMin: 85,
            cadenceMax: 95,
          ),
          WorkoutInterval(
            name: 'Recovery',
            duration: const Duration(minutes: 3),
            type: IntervalType.rest,
            powerTarget: PowerTarget.ftpPercent(50),
          ),
          WorkoutInterval(
            name: 'Sweet Spot 2',
            duration: const Duration(minutes: 10),
            type: IntervalType.work,
            powerTarget: PowerTarget.ftpPercent(90),
            cadenceMin: 85,
            cadenceMax: 95,
          ),
          WorkoutInterval(
            name: 'Recovery',
            duration: const Duration(minutes: 3),
            type: IntervalType.rest,
            powerTarget: PowerTarget.ftpPercent(50),
          ),
          WorkoutInterval(
            name: 'Sweet Spot 3',
            duration: const Duration(minutes: 10),
            type: IntervalType.work,
            powerTarget: PowerTarget.ftpPercent(90),
            cadenceMin: 85,
            cadenceMax: 95,
          ),
          WorkoutInterval(
            name: 'Cooldown',
            duration: const Duration(minutes: 5),
            type: IntervalType.cooldown,
            powerTarget: PowerTarget.ftpPercent(40),
          ),
        ],
      );

  static Workout get hiit20 => Workout(
        id: 'hiit_20',
        name: 'HIIT 20',
        description: '20 Minuten High Intensity Interval Training',
        type: WorkoutType.hiit,
        intervals: [
          WorkoutInterval(
            name: 'Warmup',
            duration: const Duration(minutes: 5),
            type: IntervalType.warmup,
            powerTarget: PowerTarget.ftpPercent(50),
          ),
          // 8x (30s ON / 30s OFF)
          for (int i = 1; i <= 8; i++) ...[
            WorkoutInterval(
              name: 'Sprint $i',
              duration: const Duration(seconds: 30),
              type: IntervalType.work,
              powerTarget: PowerTarget.ftpPercent(150),
              cadenceMin: 100,
              cadenceMax: 120,
              instructions: 'Vollgas!',
            ),
            WorkoutInterval(
              name: 'Recovery $i',
              duration: const Duration(seconds: 30),
              type: IntervalType.rest,
              powerTarget: PowerTarget.ftpPercent(40),
            ),
          ],
          WorkoutInterval(
            name: 'Cooldown',
            duration: const Duration(minutes: 5),
            type: IntervalType.cooldown,
            powerTarget: PowerTarget.ftpPercent(40),
          ),
        ],
      );

  static Workout get ftpTest20min => Workout(
        id: 'ftp_test_20',
        name: 'FTP Test (20 Min)',
        description: '20 Minuten FTP Test - Ergebnis × 0.95 = FTP',
        type: WorkoutType.ftpTest,
        intervals: [
          WorkoutInterval(
            name: 'Warmup',
            duration: const Duration(minutes: 10),
            type: IntervalType.warmup,
            powerTarget: PowerTarget.ftpPercent(50),
            instructions: 'Locker warmfahren',
          ),
          WorkoutInterval(
            name: 'Aktivierung',
            duration: const Duration(minutes: 3),
            type: IntervalType.work,
            powerTarget: PowerTarget.ftpPercent(80),
            instructions: '3 kurze Sprints einbauen',
          ),
          WorkoutInterval(
            name: 'Erholung',
            duration: const Duration(minutes: 5),
            type: IntervalType.rest,
            powerTarget: PowerTarget.ftpPercent(40),
          ),
          WorkoutInterval(
            name: '20 Min Test',
            duration: const Duration(minutes: 20),
            type: IntervalType.work,
            powerTarget: PowerTarget.free(),
            instructions: 'Maximale nachhaltige Leistung! Gleichmäßig einteilen.',
          ),
          WorkoutInterval(
            name: 'Cooldown',
            duration: const Duration(minutes: 10),
            type: IntervalType.cooldown,
            powerTarget: PowerTarget.ftpPercent(40),
          ),
        ],
      );

  static Workout get tabata4min => Workout(
        id: 'tabata_4',
        name: 'Tabata Classic',
        description: '4 Minuten Tabata: 8× (20s Max / 10s Rest)',
        type: WorkoutType.tabata,
        intervals: [
          WorkoutInterval(
            name: 'Warmup',
            duration: const Duration(minutes: 5),
            type: IntervalType.warmup,
            powerTarget: PowerTarget.ftpPercent(50),
          ),
          for (int i = 1; i <= 8; i++) ...[
            WorkoutInterval(
              name: 'Tabata $i',
              duration: const Duration(seconds: 20),
              type: IntervalType.work,
              powerTarget: PowerTarget.ftpPercent(170),
              cadenceMin: 110,
              instructions: 'ALLES GEBEN!',
            ),
            WorkoutInterval(
              name: 'Rest $i',
              duration: const Duration(seconds: 10),
              type: IntervalType.rest,
              powerTarget: PowerTarget.free(),
            ),
          ],
          WorkoutInterval(
            name: 'Cooldown',
            duration: const Duration(minutes: 5),
            type: IntervalType.cooldown,
            powerTarget: PowerTarget.ftpPercent(40),
          ),
        ],
      );

  static List<Workout> get all => [
        endurance30,
        sweetSpot45,
        hiit20,
        ftpTest20min,
        tabata4min,
      ];
}
