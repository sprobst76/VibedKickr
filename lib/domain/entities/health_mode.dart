import 'package:equatable/equatable.dart';

import 'health_warning.dart';

/// Gesundheitsmodus Use-Case Definition
enum HealthModeUseCase {
  comebackAfterIllness,      // 4-Wochen-Ramp-Up Protokoll für Wiedereinstieg
  overtrainingPrevention,    // Präventive Überwachung ohne phasenweise Intensitätsanpassung
  generalWellnessTracking,   // Einfaches Tracking ohne automatische Trainingsanpassung
}

extension HealthModeUseCaseExtension on HealthModeUseCase {
  String get label {
    switch (this) {
      case HealthModeUseCase.comebackAfterIllness:
        return 'Wiedereinstieg nach Krankheit';
      case HealthModeUseCase.overtrainingPrevention:
        return 'Übertraining-Schutz';
      case HealthModeUseCase.generalWellnessTracking:
        return 'Allgemeines Wellness-Tracking';
    }
  }

  String get description {
    switch (this) {
      case HealthModeUseCase.comebackAfterIllness:
        return 'Nach längerer Pause oder Krankheit: 4-Wochen progressiver Aufbau mit schrittweisem Intensitätsanstieg.';
      case HealthModeUseCase.overtrainingPrevention:
        return 'Kontinuierliche Überwachung zur Vermeidung von Übertraining durch tägliche Wellness-Checks und Warnungen.';
      case HealthModeUseCase.generalWellnessTracking:
        return 'Tägliches Wellness-Tracking ohne automatische Trainingsanpassung oder Protokoll.';
    }
  }

  /// Hat dieser Use-Case phasenweise Progression?
  bool get hasPhases => this == HealthModeUseCase.comebackAfterIllness;

  /// Passt dieser Use-Case die Trainingsintensität an?
  bool get adjustsIntensity => this == HealthModeUseCase.comebackAfterIllness;
}

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
        return 'Du bist bereit für ein normales Training!';
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

/// Comeback-Protokoll Phase (nur für Comeback-Use-Case)
enum ComebackProtocolPhase {
  week1, // 50% Intensität/Umfang
  week2, // 70% Intensität/Umfang
  week3, // 85% Intensität/Umfang
  week4, // 100% - Comeback abgeschlossen
  completed, // Wieder auf Normalniveau
}

extension ComebackProtocolPhaseExtension on ComebackProtocolPhase {
  String get label {
    switch (this) {
      case ComebackProtocolPhase.week1:
        return 'Woche 1';
      case ComebackProtocolPhase.week2:
        return 'Woche 2';
      case ComebackProtocolPhase.week3:
        return 'Woche 3';
      case ComebackProtocolPhase.week4:
        return 'Woche 4';
      case ComebackProtocolPhase.completed:
        return 'Abgeschlossen';
    }
  }

  String get description {
    switch (this) {
      case ComebackProtocolPhase.week1:
        return 'Sanfter Wiedereinstieg - 50% Intensität';
      case ComebackProtocolPhase.week2:
        return 'Aufbau fortsetzen - 70% Intensität';
      case ComebackProtocolPhase.week3:
        return 'Fast zurück - 85% Intensität';
      case ComebackProtocolPhase.week4:
        return 'Letzte Anpassung - 100% Intensität';
      case ComebackProtocolPhase.completed:
        return 'Willkommen zurück! Du bist wieder voll da.';
    }
  }

  /// Intensitätsfaktor für diese Phase
  double get intensityFactor {
    switch (this) {
      case ComebackProtocolPhase.week1:
        return 0.50;
      case ComebackProtocolPhase.week2:
        return 0.70;
      case ComebackProtocolPhase.week3:
        return 0.85;
      case ComebackProtocolPhase.week4:
      case ComebackProtocolPhase.completed:
        return 1.0;
    }
  }

  /// Maximale Trainingsdauer in Minuten
  int get maxDurationMinutes {
    switch (this) {
      case ComebackProtocolPhase.week1:
        return 30;
      case ComebackProtocolPhase.week2:
        return 45;
      case ComebackProtocolPhase.week3:
        return 60;
      case ComebackProtocolPhase.week4:
      case ComebackProtocolPhase.completed:
        return 90;
    }
  }

  /// Empfohlene Trainingstage pro Woche
  int get recommendedDaysPerWeek {
    switch (this) {
      case ComebackProtocolPhase.week1:
        return 2;
      case ComebackProtocolPhase.week2:
        return 3;
      case ComebackProtocolPhase.week3:
        return 4;
      case ComebackProtocolPhase.week4:
      case ComebackProtocolPhase.completed:
        return 5;
    }
  }
}

/// Gesundheitsmodus Status
class HealthMode extends Equatable {
  final HealthModeUseCase useCase;
  final bool isActive;
  final DateTime? startDate;
  final DateTime? pauseStartDate; // Wann die Pause/Krankheit begann
  final int originalFtp; // FTP vor der Krankheit/Pause
  final int? baselineRestingHr; // Normaler Ruhepuls
  final List<WellnessCheckIn> checkIns;
  final String? pauseReason; // Optional: Grund der Pause (Krankheit, Urlaub, etc.)
  final int? detectedFtp; // Aus Workouts erkannter FTP
  final DateTime? ftpDetectedAt; // Wann FTP erkannt wurde
  final String? ftpDetectionMethod; // '20min' | 'sweetspot' | 'normalized'

  const HealthMode({
    this.useCase = HealthModeUseCase.comebackAfterIllness,
    this.isActive = false,
    this.startDate,
    this.pauseStartDate,
    this.originalFtp = 200,
    this.baselineRestingHr,
    this.checkIns = const [],
    this.pauseReason,
    this.detectedFtp,
    this.ftpDetectedAt,
    this.ftpDetectionMethod,
  });

  /// Aktuelle Phase basierend auf Startdatum (nur für Comeback-Use-Case)
  ComebackProtocolPhase? get currentPhase {
    if (!isActive || !useCase.hasPhases || startDate == null) {
      return null;
    }

    final daysSinceStart = DateTime.now().difference(startDate!).inDays;

    if (daysSinceStart < 7) return ComebackProtocolPhase.week1;
    if (daysSinceStart < 14) return ComebackProtocolPhase.week2;
    if (daysSinceStart < 21) return ComebackProtocolPhase.week3;
    if (daysSinceStart < 28) return ComebackProtocolPhase.week4;
    return ComebackProtocolPhase.completed;
  }

  /// Tag innerhalb der aktuellen Woche (1-7)
  int get dayInCurrentWeek {
    if (startDate == null) return 1;
    final daysSinceStart = DateTime.now().difference(startDate!).inDays;
    return (daysSinceStart % 7) + 1;
  }

  /// Tage seit Gesundheitsmodus-Start
  int get daysSinceStart {
    if (startDate == null) return 0;
    return DateTime.now().difference(startDate!).inDays;
  }

  /// Tage der Pause (falls bekannt)
  int? get pauseDays {
    if (pauseStartDate == null || startDate == null) return null;
    return startDate!.difference(pauseStartDate!).inDays;
  }

  /// Aktueller effektiver FTP (reduziert bei Comeback-Protokoll)
  int get effectiveFtp {
    if (!useCase.adjustsIntensity || currentPhase == null) {
      return originalFtp;
    }
    return (originalFtp * currentPhase!.intensityFactor).round();
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
    if (!isActive || !useCase.hasPhases) return 100;
    final days = daysSinceStart;
    return (days / 28 * 100).clamp(0, 100);
  }

  /// Hat eine FTP-Verbesserung erkannt?
  bool get hasFtpSuggestion =>
      detectedFtp != null &&
      detectedFtp! > effectiveFtp &&
      (ftpDetectedAt == null || DateTime.now().difference(ftpDetectedAt!).inDays < 7);

  /// Empfohlene FTP-Steigerung
  int get suggestedFtpIncrease => (detectedFtp ?? originalFtp) - effectiveFtp;

  /// Ist bereit für nächste Phase? (nur relevant für Comeback-Use-Case)
  bool get isReadyForNextPhase {
    if (!useCase.hasPhases || currentPhase == null || currentPhase == ComebackProtocolPhase.completed) {
      return false;
    }

    // Mindestens 5 Tage in Phase
    if (dayInCurrentWeek < 5) return false;

    // Durchschnittlicher Wellness-Score >60% für letzte 3 Tage
    final recent3Days = checkIns
        .where((c) => DateTime.now().difference(c.date).inDays <= 3)
        .toList();
    if (recent3Days.length < 2) return false;

    final avgScore =
        recent3Days.map((c) => c.normalizedScore).reduce((a, b) => a + b) /
            recent3Days.length;
    if (avgScore < 60) return false;

    // Ruhepuls nicht erhöht
    if (isRestingHrTrending) return false;

    return true;
  }

  /// Empfehlung zur Phasenfortschritt (nur für Comeback-Use-Case)
  String get phaseProgressionRecommendation {
    if (!useCase.hasPhases) {
      return '';
    }

    // When not active or no startDate, protocol is completed
    if (!isActive || startDate == null) {
      return 'Comeback abgeschlossen! Du bist zurück auf 100%.';
    }

    if (currentPhase == ComebackProtocolPhase.completed) {
      return 'Comeback abgeschlossen! Du bist zurück auf 100%.';
    }

    if (isReadyForNextPhase) {
      final nextPhase = _getNextPhase();
      return 'Bereit für $nextPhase! Wellness und HR sind stabil.';
    }

    final blockers = <String>[];
    if (dayInCurrentWeek < 5) {
      final daysLeft = 5 - dayInCurrentWeek;
      blockers.add('$daysLeft Tag${daysLeft > 1 ? 'e' : ''} mehr empfohlen');
    }

    if (averageWellnessScore7d < 60) {
      blockers
          .add('Wellness-Score verbessern (aktuell: ${averageWellnessScore7d.round()}%)');
    }

    if (isRestingHrTrending) {
      blockers.add('Ruhepuls erhöht - Erholung abwarten');
    }

    return blockers.join(', ');
  }

  String _getNextPhase() {
    return switch (currentPhase) {
      ComebackProtocolPhase.week1 => 'Woche 2 (70% Intensität)',
      ComebackProtocolPhase.week2 => 'Woche 3 (85% Intensität)',
      ComebackProtocolPhase.week3 => 'Woche 4 (100% Intensität)',
      ComebackProtocolPhase.week4 => 'Normales Training',
      ComebackProtocolPhase.completed => 'Bereits abgeschlossen',
      null => 'Nicht verfügbar',
    };
  }

  /// Generiere aktuelle Warnungen basierend auf Wellness-Daten
  List<HealthWarning> get activeWarnings {
    final warnings = <HealthWarning>[];

    // 1. Ruhepuls erhöht
    if (isRestingHrTrending && baselineRestingHr != null) {
      warnings.add(HealthWarning(
        type: HealthWarningType.restingHrElevated,
        severity: HealthWarningSeverity.warning,
        title: 'Ruhepuls erhöht',
        message: 'Dein Ruhepuls ist seit 3 Tagen über dem Normalwert. '
            'Das kann ein Zeichen von Übertraining oder beginnender Krankheit sein. '
            'Erwäge einen Ruhetag oder leichtes Training.',
        actionLabel: 'Ruhetag einlegen',
        createdAt: DateTime.now(),
      ));
    }

    // 2. Wellness-Score fallender Trend
    final wellnessTrend = _calculateWellnessTrend();
    if (wellnessTrend < -15) {
      warnings.add(HealthWarning(
        type: HealthWarningType.wellnessDeclining,
        severity: HealthWarningSeverity.warning,
        title: 'Wellness-Werte sinken',
        message: 'Dein Wellness-Score ist in den letzten Tagen gesunken. '
            'Das deutet auf erhöhten Stress, schlechten Schlaf oder Überbelastung hin. '
            'Reduziere die Trainingsintensität.',
        actionLabel: 'Trainingsplan anpassen',
        createdAt: DateTime.now(),
      ));
    }

    // 3. Niedriger Wellness-Score (kritisch)
    final recentLowScores = checkIns
        .where((c) => DateTime.now().difference(c.date).inDays <= 2)
        .where((c) => c.normalizedScore < 40)
        .length;
    if (recentLowScores >= 2) {
      warnings.add(HealthWarning(
        type: HealthWarningType.lowWellnessScore,
        severity: HealthWarningSeverity.critical,
        title: 'Sehr niedrige Wellness-Werte',
        message: 'Deine Wellness-Werte sind seit 2+ Tagen sehr niedrig (<40%). '
            'Dein Körper braucht dringend Erholung. Nimm dir mindestens 1-2 Ruhetage.',
        actionLabel: 'Mehr erfahren',
        createdAt: DateTime.now(),
      ));
    }

    // 4. Übertraining-Risiko (Kombination mehrerer Faktoren)
    final overtrainingScore = _calculateOvertrainingRisk();
    if (overtrainingScore >= 3) {
      warnings.add(HealthWarning(
        type: HealthWarningType.overtrainingRisk,
        severity: HealthWarningSeverity.critical,
        title: 'Übertraining-Warnung',
        message: 'Mehrere Indikatoren deuten auf Übertraining hin: '
            'Erhöhter Ruhepuls, sinkende Wellness-Werte, niedriger Energielevel. '
            'Reduziere sofort die Trainingsbelastung und priorisiere Erholung.',
        actionLabel: 'Trainingsplan anpassen',
        createdAt: DateTime.now(),
      ));
    }

    // 5. Bereit für Phase-Fortschritt (Info) - nur Comeback use case
    if (useCase.hasPhases &&
        currentPhase != null &&
        currentPhase != ComebackProtocolPhase.completed &&
        isReadyForNextPhase) {
      warnings.add(HealthWarning(
        type: HealthWarningType.readyForProgression,
        severity: HealthWarningSeverity.info,
        title: 'Bereit für nächste Phase',
        message: phaseProgressionRecommendation,
        actionLabel: 'Jetzt fortschreiten',
        createdAt: DateTime.now(),
      ));
    }

    // 6. FTP-Verbesserung erkannt (Info)
    if (hasFtpSuggestion) {
      warnings.add(HealthWarning(
        type: HealthWarningType.ftpImprovement,
        severity: HealthWarningSeverity.info,
        title: 'FTP-Verbesserung erkannt',
        message: 'Deine Leistung deutet auf eine FTP-Steigerung von '
            '${effectiveFtp}W auf ${detectedFtp}W hin (+$suggestedFtpIncrease W).',
        actionLabel: 'FTP aktualisieren',
        createdAt: DateTime.now(),
      ));
    }

    return warnings;
  }

  double _calculateWellnessTrend() {
    if (checkIns.length < 4) return 0;

    final recent = checkIns
        .where((c) => DateTime.now().difference(c.date).inDays <= 7)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    if (recent.length < 4) return 0;

    final firstHalf = recent.take(recent.length ~/ 2);
    final secondHalf = recent.skip(recent.length ~/ 2);

    final avgFirst = firstHalf.map((c) => c.normalizedScore).reduce((a, b) => a + b) /
        firstHalf.length;
    final avgSecond = secondHalf.map((c) => c.normalizedScore).reduce((a, b) => a + b) /
        secondHalf.length;

    return avgSecond - avgFirst;
  }

  int _calculateOvertrainingRisk() {
    int score = 0;

    // Erhöhter Ruhepuls
    if (isRestingHrTrending) score++;

    // Niedriger durchschnittlicher Wellness
    if (averageWellnessScore7d < 50) score++;

    // Sinkender Trend
    if (_calculateWellnessTrend() < -10) score++;

    // Niedriger Energielevel in letzten 3 Tagen
    final recentEnergy = checkIns
        .where((c) => DateTime.now().difference(c.date).inDays <= 3)
        .map((c) => c.energyLevel)
        .toList();
    if (recentEnergy.isNotEmpty &&
        recentEnergy.reduce((a, b) => a + b) / recentEnergy.length < 2.5) {
      score++;
    }

    return score;
  }

  HealthMode copyWith({
    HealthModeUseCase? useCase,
    bool? isActive,
    DateTime? startDate,
    DateTime? pauseStartDate,
    int? originalFtp,
    int? baselineRestingHr,
    List<WellnessCheckIn>? checkIns,
    String? pauseReason,
    int? detectedFtp,
    DateTime? ftpDetectedAt,
    String? ftpDetectionMethod,
  }) {
    return HealthMode(
      useCase: useCase ?? this.useCase,
      isActive: isActive ?? this.isActive,
      startDate: startDate ?? this.startDate,
      pauseStartDate: pauseStartDate ?? this.pauseStartDate,
      originalFtp: originalFtp ?? this.originalFtp,
      baselineRestingHr: baselineRestingHr ?? this.baselineRestingHr,
      checkIns: checkIns ?? this.checkIns,
      pauseReason: pauseReason ?? this.pauseReason,
      detectedFtp: detectedFtp ?? this.detectedFtp,
      ftpDetectedAt: ftpDetectedAt ?? this.ftpDetectedAt,
      ftpDetectionMethod: ftpDetectionMethod ?? this.ftpDetectionMethod,
    );
  }

  /// Migration von alter ComebackMode-Struktur
  factory HealthMode.fromComebackMode(Map<String, dynamic> oldJson) {
    return HealthMode(
      useCase: HealthModeUseCase.comebackAfterIllness, // Default für Migration
      isActive: oldJson['isActive'] as bool? ?? false,
      startDate: oldJson['startDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(oldJson['startDate'] as int)
          : null,
      pauseStartDate: oldJson['illnessStartDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(oldJson['illnessStartDate'] as int)
          : null,
      originalFtp: oldJson['originalFtp'] as int? ?? 200,
      baselineRestingHr: oldJson['baselineRestingHr'] as int?,
      checkIns: (oldJson['checkIns'] as List?)
              ?.map((e) => WellnessCheckIn.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pauseReason: oldJson['illnessType'] as String?,
      detectedFtp: oldJson['detectedFtp'] as int?,
      ftpDetectedAt: oldJson['ftpDetectedAt'] != null
          ? DateTime.parse(oldJson['ftpDetectedAt'] as String)
          : null,
      ftpDetectionMethod: oldJson['ftpDetectionMethod'] as String?,
    );
  }

  factory HealthMode.fromJson(Map<String, dynamic> json) {
    return HealthMode(
      useCase: json['useCase'] != null
          ? HealthModeUseCase.values[json['useCase'] as int]
          : HealthModeUseCase.comebackAfterIllness,
      isActive: json['isActive'] as bool? ?? false,
      startDate: json['startDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['startDate'] as int)
          : null,
      pauseStartDate: json['pauseStartDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['pauseStartDate'] as int)
          : null,
      originalFtp: json['originalFtp'] as int? ?? 200,
      baselineRestingHr: json['baselineRestingHr'] as int?,
      checkIns: (json['checkIns'] as List?)
              ?.map((e) => WellnessCheckIn.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pauseReason: json['pauseReason'] as String?,
      detectedFtp: json['detectedFtp'] as int?,
      ftpDetectedAt: json['ftpDetectedAt'] != null
          ? DateTime.parse(json['ftpDetectedAt'] as String)
          : null,
      ftpDetectionMethod: json['ftpDetectionMethod'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'useCase': useCase.index,
        'isActive': isActive,
        'startDate': startDate?.millisecondsSinceEpoch,
        'pauseStartDate': pauseStartDate?.millisecondsSinceEpoch,
        'originalFtp': originalFtp,
        'baselineRestingHr': baselineRestingHr,
        'checkIns': checkIns.map((c) => c.toJson()).toList(),
        'pauseReason': pauseReason,
        'detectedFtp': detectedFtp,
        'ftpDetectedAt': ftpDetectedAt?.toIso8601String(),
        'ftpDetectionMethod': ftpDetectionMethod,
      };

  @override
  List<Object?> get props => [
        useCase,
        isActive,
        startDate,
        pauseStartDate,
        originalFtp,
        baselineRestingHr,
        checkIns,
        pauseReason,
        detectedFtp,
        ftpDetectedAt,
        ftpDetectionMethod,
      ];
}
