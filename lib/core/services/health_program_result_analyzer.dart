import '../../domain/entities/athlete_profile.dart';
import '../../domain/entities/training_session.dart';
import 'health_training_personalization_service.dart';

/// Fitness-Level Schätzung basierend auf Trainingsergebnisse
enum FitnessLevel {
  poor,      // Schlechte Fitness
  fair,      // Mittelmäßig
  good,      // Gut
  excellent, // Ausgezeichnet
}

/// HR Recovery Rate Analyse
class HrRecoveryAnalysis {
  /// HR zu Beginn der Recovery-Phase (Peak HR)
  final int startHr;

  /// HR nach 1 Minute
  final int? hrAfter1Min;

  /// HR nach 2 Minuten
  final int? hrAfter2Min;

  /// HR Rückgang nach 1 Minute
  final int? drop1Min;

  /// HR Rückgang nach 2 Minuten
  final int? drop2Min;

  /// Bewertung der Recovery-Fähigkeit
  final String assessment;

  /// Recovery-Score (0-100)
  /// Basierend auf HR-Rückgang und Zeitraum
  final int recoveryScore;

  HrRecoveryAnalysis({
    required this.startHr,
    this.hrAfter1Min,
    this.hrAfter2Min,
    this.drop1Min,
    this.drop2Min,
    required this.assessment,
    required this.recoveryScore,
  });
}

/// Fitness-Level Schätzung basierend auf Trainingsleistung
class FitnessLevelEstimate {
  /// Geschätztes Fitness-Level
  final FitnessLevel level;

  /// Power-basierte Schätzung (0-100)
  final int powerScore;

  /// HR-basierte Schätzung (0-100)
  final int hrScore;

  /// Gesamtscore (0-100)
  final int overallScore;

  /// Beschreibung des Fitness-Levels
  final String description;

  /// Verbesserungsvorschläge
  final List<String> suggestions;

  FitnessLevelEstimate({
    required this.level,
    required this.powerScore,
    required this.hrScore,
    required this.overallScore,
    required this.description,
    required this.suggestions,
  });
}

/// Vergleich mit vorherigem Training
class SessionComparison {
  /// Ist dies das erste Training? (kein Vergleich möglich)
  final bool isFirstSession;

  /// HR durchschnitt vorher
  final int? previousAvgHr;

  /// HR durchschnitt jetzt
  final int? currentAvgHr;

  /// Änderung in %
  final double? hrChange;

  /// Power durchschnitt vorher
  final int? previousAvgPower;

  /// Power durchschnitt jetzt
  final int? currentAvgPower;

  /// Änderung in %
  final double? powerChange;

  /// Verbesserungen/Verschlechterungen beschreiben
  final String assessment;

  SessionComparison({
    required this.isFirstSession,
    this.previousAvgHr,
    this.currentAvgHr,
    this.hrChange,
    this.previousAvgPower,
    this.currentAvgPower,
    this.powerChange,
    required this.assessment,
  });
}

/// Empfehlung für nächstes Trainingsprogramm
class NextProgramRecommendation {
  /// Name des empfohlenen Programms
  final String programName;

  /// Begründung der Empfehlung
  final String reasoning;

  /// Warnung wenn Programm schwieriger wird
  final String? caution;

  /// Priority (0-100), höher = wichtiger
  final int priority;

  NextProgramRecommendation({
    required this.programName,
    required this.reasoning,
    this.caution,
    required this.priority,
  });
}

/// Komplette Analyse eines Health Training Programms
class HealthProgramResultAnalysis {
  final HrRecoveryAnalysis? recoveryAnalysis;
  final FitnessLevelEstimate? fitnessEstimate;
  final SessionComparison? sessionComparison;
  final NextProgramRecommendation? nextProgramRecommendation;

  HealthProgramResultAnalysis({
    this.recoveryAnalysis,
    this.fitnessEstimate,
    this.sessionComparison,
    this.nextProgramRecommendation,
  });
}

/// Service zur Analyse von Health Training Ergebnissen
class HealthProgramResultAnalyzer {
  /// Analysiert HR Recovery aus Datenpunkten
  ///
  /// Sucht nach Peak HR und berechnet Rückgang über Zeit
  /// Erfordert Datenpunkte mit HR-Daten am Ende des Trainings
  static HrRecoveryAnalysis? analyzeHrRecovery(
    List<DataPoint> dataPoints,
    AthleteProfile athlete,
  ) {
    // Finde HR-Datenpunkte aus den letzten 5 Minuten (nach dem Training)
    if (dataPoints.isEmpty) return null;

    final age = athlete.age ?? 45;
    final expectedMinRecovery = _getExpectedMinRecoveryDrop(age);

    // Finde Peak HR (sollte gegen Ende des Work-Intervals sein)
    int peakHr = 0;
    int peakHrIndex = -1;

    for (int i = 0; i < dataPoints.length; i++) {
      if (dataPoints[i].heartRate != null && dataPoints[i].heartRate! > peakHr) {
        peakHr = dataPoints[i].heartRate!;
        peakHrIndex = i;
      }
    }

    if (peakHrIndex == -1 || peakHr == 0) return null;

    // Finde HR nach 1 und 2 Minuten Recovery
    final peakTime = dataPoints[peakHrIndex].timestamp;
    int? hrAfter1Min;
    int? hrAfter2Min;

    for (final point in dataPoints.sublist(peakHrIndex)) {
      if (point.heartRate != null) {
        final timeSincePeak = point.timestamp - peakTime;

        if (timeSincePeak >= 60000 && timeSincePeak < 70000 && hrAfter1Min == null) {
          hrAfter1Min = point.heartRate;
        }

        if (timeSincePeak >= 120000 && timeSincePeak < 130000 && hrAfter2Min == null) {
          hrAfter2Min = point.heartRate;
        }
      }
    }

    final drop1Min = hrAfter1Min != null ? peakHr - hrAfter1Min : null;
    final drop2Min = hrAfter2Min != null ? peakHr - hrAfter2Min : null;

    // Bewerte Recovery basierend auf HR-Rückgang
    final (assessment, score) = _assessRecovery(
      drop1Min: drop1Min,
      drop2Min: drop2Min,
      expectedDrop: expectedMinRecovery,
    );

    return HrRecoveryAnalysis(
      startHr: peakHr,
      hrAfter1Min: hrAfter1Min,
      hrAfter2Min: hrAfter2Min,
      drop1Min: drop1Min,
      drop2Min: drop2Min,
      assessment: assessment,
      recoveryScore: score,
    );
  }

  /// Schätzt Fitness-Level basierend auf Trainingsleistung
  static FitnessLevelEstimate? analyzeFitnessLevel(
    SessionStats? stats,
    AthleteProfile athlete,
  ) {
    if (stats == null) return null;

    // Power-Score basierend auf IF (Intensity Factor)
    final powerScore = _calculatePowerScore(stats.intensityFactor);

    // HR-Score basierend auf durchschnittlicher HR
    final hrScore = stats.avgHeartRate != null
        ? _calculateHrScore(stats.avgHeartRate!, athlete)
        : 0;

    // Gesamt-Score
    final overallScore = ((powerScore + hrScore) / 2).round();

    // Bestimme Fitness-Level
    final level = _determineFitnessLevel(overallScore);

    // Generiere Beschreibung und Vorschläge
    final (description, suggestions) = _generateFitnessDescription(
      level,
      overallScore,
      stats.intensityFactor,
      stats.avgHeartRate ?? 0,
      athlete,
    );

    return FitnessLevelEstimate(
      level: level,
      powerScore: powerScore,
      hrScore: hrScore,
      overallScore: overallScore,
      description: description,
      suggestions: suggestions,
    );
  }

  /// Vergleicht mit dem vorherigen Training der gleichen Art
  static SessionComparison compareWithPrevious(
    SessionStats? currentStats,
    SessionStats? previousStats,
  ) {
    if (previousStats == null) {
      return SessionComparison(
        isFirstSession: true,
        assessment:
            'Herzlichen Glückwunsch zum ersten Health Training! Dies ist eine gute Ausgangslage für zukünftige Vergleiche.',
      );
    }

    final currentAvgHr = currentStats?.avgHeartRate;
    final previousAvgHr = previousStats.avgHeartRate;
    final currentAvgPower = currentStats?.avgPower;
    final previousAvgPower = previousStats.avgPower;

    double? hrChange;
    double? powerChange;
    String assessment = '';

    if (currentAvgHr != null && previousAvgHr != null) {
      hrChange = ((currentAvgHr - previousAvgHr) / previousAvgHr) * 100;
    }

    if (currentAvgPower != null) {
      powerChange = ((currentAvgPower - previousAvgPower) / previousAvgPower) * 100;
    }

    // Generiere Assessment
    assessment = _generateSessionAssessment(
      hrChange: hrChange,
      powerChange: powerChange,
    );

    return SessionComparison(
      isFirstSession: false,
      previousAvgHr: previousAvgHr,
      currentAvgHr: currentAvgHr,
      hrChange: hrChange,
      previousAvgPower: previousAvgPower,
      currentAvgPower: currentAvgPower,
      powerChange: powerChange,
      assessment: assessment,
    );
  }

  // Helper Methods

  static int _getExpectedMinRecoveryDrop(int age) {
    // Ältere Menschen sollten geringere HR-Rückgänge haben
    if (age < 40) return 20;      // 20 bpm in 1 Minute
    if (age < 50) return 18;      // 18 bpm
    if (age < 60) return 15;      // 15 bpm
    if (age < 70) return 12;      // 12 bpm
    return 10;                    // 10 bpm für 70+
  }

  static (String, int) _assessRecovery({
    required int? drop1Min,
    required int? drop2Min,
    required int expectedDrop,
  }) {
    if (drop1Min == null) {
      return ('Keine HR-Daten für Recovery-Analyse verfügbar', 0);
    }

    int score = 0;
    String assessment = '';

    if (drop1Min >= expectedDrop) {
      score = 85;
      assessment =
          'Ausgezeichnete Erholung: HR sinkt schnell nach Belastung - gutes Zeichen für Kardio-Fitness';
    } else if (drop1Min >= expectedDrop * 0.8) {
      score = 70;
      assessment =
          'Gute Erholung: HR-Rückgang ist in Ordnung, solide Kardio-Fitness';
    } else if (drop1Min >= expectedDrop * 0.6) {
      score = 50;
      assessment =
          'Befriedigende Erholung: HR sinkt angemessen, aber könnte besser sein';
    } else {
      score = 30;
      assessment =
          'Langsame Erholung: HR sinkt nur leicht - eventuell nicht genug Erholung zwischen Sessions';
    }

    return (assessment, score);
  }

  static int _calculatePowerScore(double intensityFactor) {
    // IF 0.75-1.05 = moderates Training, Score 50-70
    // IF 1.05+ = intensives Training, Score 70-100
    if (intensityFactor >= 1.2) return 95;
    if (intensityFactor >= 1.05) return 80;
    if (intensityFactor >= 0.9) return 65;
    if (intensityFactor >= 0.75) return 50;
    return 35;
  }

  static int _calculateHrScore(int avgHr, AthleteProfile athlete) {
    final maxHr = HealthTrainingPersonalizationService.calculateMaxHeartRate(
      athlete.age ?? 45,
      gender: athlete.gender,
    );

    final hrPercent = (avgHr / maxHr) * 100;

    if (hrPercent >= 85) return 90;
    if (hrPercent >= 75) return 75;
    if (hrPercent >= 60) return 60;
    if (hrPercent >= 50) return 45;
    return 30;
  }

  static FitnessLevel _determineFitnessLevel(int score) {
    if (score >= 80) return FitnessLevel.excellent;
    if (score >= 65) return FitnessLevel.good;
    if (score >= 45) return FitnessLevel.fair;
    return FitnessLevel.poor;
  }

  static (String, List<String>) _generateFitnessDescription(
    FitnessLevel level,
    int score,
    double intensityFactor,
    int avgHr,
    AthleteProfile athlete,
  ) {
    String description = '';
    List<String> suggestions = [];

    switch (level) {
      case FitnessLevel.excellent:
        description = 'Ausgezeichnete Fitness! Du hast dieses Training mit Leichtigkeit bewältigt.';
        suggestions = [
          'Erhöhe die Intensität des nächsten Trainings',
          'Versuche längere oder härtere Trainingsprogramme',
          'Monitore deine Fortschritte weiterhin',
        ];
        break;
      case FitnessLevel.good:
        description = 'Gute Fitness-Leistung. Du bist auf dem richtigen Weg.';
        suggestions = [
          'Beibehalte das aktuelle Trainingsniveau',
          'Arbeit an Konsistenz und regelmäßigen Trainings-Sessions',
          'Erwäge, die Dauer oder Intensität schrittweise zu erhöhen',
        ];
        break;
      case FitnessLevel.fair:
        description = 'Befriedigender Leistungsstand. Es gibt Verbesserungspotenzial.';
        suggestions = [
          'Konzentriere dich auf regelmäßiges Training',
          'Baue deine aerobe Basis mit Ausdauer-Programmen auf',
          'Achte auf ausreichende Erholung zwischen Sessions',
        ];
        break;
      case FitnessLevel.poor:
        description = 'Du bist noch am Anfang deiner Trainingsreise. Jedes Training zählt!';
        suggestions = [
          'Beginne mit einfacheren, kürzeren Programmen',
          'Lege Fokus auf Konsistenz statt Intensität',
          'Konsultiere einen Trainer für sichere Progression',
        ];
        break;
    }

    return (description, suggestions);
  }

  static String _generateSessionAssessment({
    required double? hrChange,
    required double? powerChange,
  }) {
    final List<String> points = [];

    if (hrChange != null) {
      if (hrChange < -10) {
        points.add('Deine durchschnittliche Herzfrequenz ist um ${hrChange.abs().toStringAsFixed(1)}% gesunken - bessere kardiovaskuläre Effizienz!');
      } else if (hrChange > 10) {
        points.add('Deine Herzfrequenz ist um ${hrChange.toStringAsFixed(1)}% gestiegen - möglicherweise weniger Erholung oder erhöhte Intensität.');
      }
    }

    if (powerChange != null) {
      if (powerChange > 10) {
        points.add('Du hast ${powerChange.toStringAsFixed(1)}% mehr Power erzeugt - gutes Zeichen für Progression!');
      } else if (powerChange < -10) {
        points.add('Power ist um ${powerChange.abs().toStringAsFixed(1)}% gefallen - möglicherweise Müdigkeit oder schlechtere Bedingungen.');
      }
    }

    return points.isNotEmpty
        ? points.join('\n')
        : 'Ähnliche Leistung wie beim letzten Mal - Konsistenz ist wichtig!';
  }
}
