import 'package:equatable/equatable.dart';

/// Wellness Check-In für einen Tag
class WellnessCheckIn extends Equatable {
  final DateTime date;
  final int energyLevel; // 1-5 (1=sehr müde, 5=voller Energie)
  final int sleepQuality; // 1-5 (1=schlecht, 5=ausgezeichnet)
  final int musclesoreness; // 1-5 (1=starker Muskelkater, 5=keine Beschwerden)
  final int motivation; // 1-5 (1=keine Lust, 5=hochmotiviert)
  final int? restingHeartRate; // Optional: Ruhepuls in bpm
  final String? notes; // Optionale Notizen

  const WellnessCheckIn({
    required this.date,
    required this.energyLevel,
    required this.sleepQuality,
    required this.musclesoreness,
    required this.motivation,
    this.restingHeartRate,
    this.notes,
  });

  /// Gesamtscore (4-20, höher = besser)
  int get totalScore => energyLevel + sleepQuality + musclesoreness + motivation;

  /// Normalisierter Score (0-100%)
  double get normalizedScore => (totalScore - 4) / 16 * 100;

  /// Empfehlung basierend auf Score
  WellnessRecommendation get recommendation {
    if (normalizedScore >= 75) return WellnessRecommendation.readyToTrain;
    if (normalizedScore >= 50) return WellnessRecommendation.lightTraining;
    if (normalizedScore >= 25) return WellnessRecommendation.activeRecovery;
    return WellnessRecommendation.restDay;
  }

  /// Ist der Ruhepuls erhöht? (>10% über Baseline)
  bool isRestingHrElevated(int? baselineHr) {
    if (restingHeartRate == null || baselineHr == null) return false;
    return restingHeartRate! > baselineHr * 1.1;
  }

  factory WellnessCheckIn.fromJson(Map<String, dynamic> json) {
    return WellnessCheckIn(
      date: DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
      energyLevel: json['energyLevel'] as int,
      sleepQuality: json['sleepQuality'] as int,
      musclesoreness: json['musclesoreness'] as int,
      motivation: json['motivation'] as int,
      restingHeartRate: json['restingHeartRate'] as int?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date.millisecondsSinceEpoch,
        'energyLevel': energyLevel,
        'sleepQuality': sleepQuality,
        'musclesoreness': musclesoreness,
        'motivation': motivation,
        'restingHeartRate': restingHeartRate,
        'notes': notes,
      };

  @override
  List<Object?> get props => [
        date,
        energyLevel,
        sleepQuality,
        musclesoreness,
        motivation,
        restingHeartRate,
        notes,
      ];
}

/// Empfehlung basierend auf Wellness-Score
enum WellnessRecommendation {
  restDay, // Score < 25%: Ruhetag empfohlen
  activeRecovery, // Score 25-50%: Nur leichte Aktivität
  lightTraining, // Score 50-75%: Leichtes Training ok
  readyToTrain, // Score > 75%: Bereit für normales Training
}

extension WellnessRecommendationExtension on WellnessRecommendation {
  String get label {
    switch (this) {
      case WellnessRecommendation.restDay:
        return 'Ruhetag';
      case WellnessRecommendation.activeRecovery:
        return 'Aktive Erholung';
      case WellnessRecommendation.lightTraining:
        return 'Leichtes Training';
      case WellnessRecommendation.readyToTrain:
        return 'Trainingsbereit';
    }
  }

  String get description {
    switch (this) {
      case WellnessRecommendation.restDay:
        return 'Dein Körper braucht Ruhe. Heute lieber pausieren.';
      case WellnessRecommendation.activeRecovery:
        return 'Nur leichte Aktivität empfohlen (Spaziergang, Dehnen).';
      case WellnessRecommendation.lightTraining:
        return 'Leichtes Training in Zone 1-2 ist ok.';
      case WellnessRecommendation.readyToTrain:
        return 'Du bist bereit für ein normales Comeback-Training!';
    }
  }

  /// Maximale Intensität (% FTP) für diese Empfehlung
  double get maxIntensity {
    switch (this) {
      case WellnessRecommendation.restDay:
        return 0;
      case WellnessRecommendation.activeRecovery:
        return 0.50;
      case WellnessRecommendation.lightTraining:
        return 0.65;
      case WellnessRecommendation.readyToTrain:
        return 0.85;
    }
  }
}

/// Comeback-Phase im Ramp-Up Protokoll
enum ComebackPhase {
  week1, // 50% Intensität/Umfang
  week2, // 70% Intensität/Umfang
  week3, // 85% Intensität/Umfang
  week4, // 100% - Comeback abgeschlossen
  completed, // Wieder auf Normalniveau
}

extension ComebackPhaseExtension on ComebackPhase {
  String get label {
    switch (this) {
      case ComebackPhase.week1:
        return 'Woche 1';
      case ComebackPhase.week2:
        return 'Woche 2';
      case ComebackPhase.week3:
        return 'Woche 3';
      case ComebackPhase.week4:
        return 'Woche 4';
      case ComebackPhase.completed:
        return 'Abgeschlossen';
    }
  }

  String get description {
    switch (this) {
      case ComebackPhase.week1:
        return 'Sanfter Wiedereinstieg - 50% Intensität';
      case ComebackPhase.week2:
        return 'Aufbau fortsetzen - 70% Intensität';
      case ComebackPhase.week3:
        return 'Fast zurück - 85% Intensität';
      case ComebackPhase.week4:
        return 'Letzte Anpassung - 100% Intensität';
      case ComebackPhase.completed:
        return 'Willkommen zurück! Du bist wieder voll da.';
    }
  }

  /// Intensitätsfaktor für diese Phase
  double get intensityFactor {
    switch (this) {
      case ComebackPhase.week1:
        return 0.50;
      case ComebackPhase.week2:
        return 0.70;
      case ComebackPhase.week3:
        return 0.85;
      case ComebackPhase.week4:
      case ComebackPhase.completed:
        return 1.0;
    }
  }

  /// Maximale Trainingsdauer in Minuten
  int get maxDurationMinutes {
    switch (this) {
      case ComebackPhase.week1:
        return 30;
      case ComebackPhase.week2:
        return 45;
      case ComebackPhase.week3:
        return 60;
      case ComebackPhase.week4:
      case ComebackPhase.completed:
        return 90;
    }
  }

  /// Empfohlene Trainingstage pro Woche
  int get recommendedDaysPerWeek {
    switch (this) {
      case ComebackPhase.week1:
        return 2;
      case ComebackPhase.week2:
        return 3;
      case ComebackPhase.week3:
        return 4;
      case ComebackPhase.week4:
      case ComebackPhase.completed:
        return 5;
    }
  }
}

/// Comeback Mode Status
class ComebackMode extends Equatable {
  final bool isActive;
  final DateTime? startDate;
  final DateTime? illnessStartDate;
  final int originalFtp; // FTP vor der Krankheit
  final int? baselineRestingHr; // Normaler Ruhepuls
  final List<WellnessCheckIn> checkIns;
  final String? illnessType; // Optional: Art der Krankheit

  const ComebackMode({
    this.isActive = false,
    this.startDate,
    this.illnessStartDate,
    this.originalFtp = 200,
    this.baselineRestingHr,
    this.checkIns = const [],
    this.illnessType,
  });

  /// Aktuelle Phase basierend auf Startdatum
  ComebackPhase get currentPhase {
    if (!isActive || startDate == null) return ComebackPhase.completed;

    final daysSinceStart = DateTime.now().difference(startDate!).inDays;

    if (daysSinceStart < 7) return ComebackPhase.week1;
    if (daysSinceStart < 14) return ComebackPhase.week2;
    if (daysSinceStart < 21) return ComebackPhase.week3;
    if (daysSinceStart < 28) return ComebackPhase.week4;
    return ComebackPhase.completed;
  }

  /// Tag innerhalb der aktuellen Woche (1-7)
  int get dayInCurrentWeek {
    if (startDate == null) return 1;
    final daysSinceStart = DateTime.now().difference(startDate!).inDays;
    return (daysSinceStart % 7) + 1;
  }

  /// Tage seit Comeback-Start
  int get daysSinceStart {
    if (startDate == null) return 0;
    return DateTime.now().difference(startDate!).inDays;
  }

  /// Tage Krankheit (falls bekannt)
  int? get illnessDays {
    if (illnessStartDate == null || startDate == null) return null;
    return startDate!.difference(illnessStartDate!).inDays;
  }

  /// Aktueller effektiver FTP (reduziert nach Phase)
  int get effectiveFtp {
    return (originalFtp * currentPhase.intensityFactor).round();
  }

  /// Heutiger Check-In (falls vorhanden)
  WellnessCheckIn? get todayCheckIn {
    final today = DateTime.now();
    try {
      return checkIns.firstWhere(
        (c) =>
            c.date.year == today.year &&
            c.date.month == today.month &&
            c.date.day == today.day,
      );
    } catch (_) {
      return null;
    }
  }

  /// Hat heute schon eingecheckt?
  bool get hasCheckedInToday => todayCheckIn != null;

  /// Durchschnittlicher Wellness-Score der letzten 7 Tage
  double get averageWellnessScore7d {
    final recentCheckIns = checkIns
        .where((c) => DateTime.now().difference(c.date).inDays <= 7)
        .toList();
    if (recentCheckIns.isEmpty) return 50;
    return recentCheckIns.map((c) => c.normalizedScore).reduce((a, b) => a + b) /
        recentCheckIns.length;
  }

  /// Ist der Ruhepuls über die letzten Tage erhöht?
  bool get isRestingHrTrending {
    if (baselineRestingHr == null) return false;
    final recent = checkIns
        .where((c) => c.restingHeartRate != null)
        .where((c) => DateTime.now().difference(c.date).inDays <= 3)
        .toList();
    if (recent.isEmpty) return false;
    final avgHr = recent.map((c) => c.restingHeartRate!).reduce((a, b) => a + b) /
        recent.length;
    return avgHr > baselineRestingHr! * 1.1;
  }

  /// Empfehlung für heute
  WellnessRecommendation get todayRecommendation {
    final checkIn = todayCheckIn;
    if (checkIn != null) {
      // Wenn Ruhepuls erhöht, eine Stufe runter
      if (checkIn.isRestingHrElevated(baselineRestingHr)) {
        final rec = checkIn.recommendation;
        if (rec == WellnessRecommendation.readyToTrain) {
          return WellnessRecommendation.lightTraining;
        }
        if (rec == WellnessRecommendation.lightTraining) {
          return WellnessRecommendation.activeRecovery;
        }
        return WellnessRecommendation.restDay;
      }
      return checkIn.recommendation;
    }
    // Ohne Check-In: konservativ sein
    return WellnessRecommendation.lightTraining;
  }

  /// Fortschritt in Prozent (0-100)
  double get progressPercent {
    if (!isActive) return 100;
    final days = daysSinceStart;
    return (days / 28 * 100).clamp(0, 100);
  }

  ComebackMode copyWith({
    bool? isActive,
    DateTime? startDate,
    DateTime? illnessStartDate,
    int? originalFtp,
    int? baselineRestingHr,
    List<WellnessCheckIn>? checkIns,
    String? illnessType,
  }) {
    return ComebackMode(
      isActive: isActive ?? this.isActive,
      startDate: startDate ?? this.startDate,
      illnessStartDate: illnessStartDate ?? this.illnessStartDate,
      originalFtp: originalFtp ?? this.originalFtp,
      baselineRestingHr: baselineRestingHr ?? this.baselineRestingHr,
      checkIns: checkIns ?? this.checkIns,
      illnessType: illnessType ?? this.illnessType,
    );
  }

  factory ComebackMode.fromJson(Map<String, dynamic> json) {
    return ComebackMode(
      isActive: json['isActive'] as bool? ?? false,
      startDate: json['startDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['startDate'] as int)
          : null,
      illnessStartDate: json['illnessStartDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['illnessStartDate'] as int)
          : null,
      originalFtp: json['originalFtp'] as int? ?? 200,
      baselineRestingHr: json['baselineRestingHr'] as int?,
      checkIns: (json['checkIns'] as List?)
              ?.map((e) => WellnessCheckIn.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      illnessType: json['illnessType'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'isActive': isActive,
        'startDate': startDate?.millisecondsSinceEpoch,
        'illnessStartDate': illnessStartDate?.millisecondsSinceEpoch,
        'originalFtp': originalFtp,
        'baselineRestingHr': baselineRestingHr,
        'checkIns': checkIns.map((c) => c.toJson()).toList(),
        'illnessType': illnessType,
      };

  @override
  List<Object?> get props => [
        isActive,
        startDate,
        illnessStartDate,
        originalFtp,
        baselineRestingHr,
        checkIns,
        illnessType,
      ];
}
