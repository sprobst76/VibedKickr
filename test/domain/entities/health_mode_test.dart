import 'package:flutter_test/flutter_test.dart';

import '../../../lib/domain/entities/health_mode.dart';

void main() {
  group('HealthModeUseCase Extension', () {
    test('comebackAfterIllness has correct properties', () {
      expect(HealthModeUseCase.comebackAfterIllness.label,
          equals('Wiedereinstieg nach Krankheit'));
      expect(HealthModeUseCase.comebackAfterIllness.hasPhases, equals(true));
      expect(HealthModeUseCase.comebackAfterIllness.adjustsIntensity,
          equals(true));
    });

    test('overtrainingPrevention has correct properties', () {
      expect(HealthModeUseCase.overtrainingPrevention.label,
          equals('Übertraining-Schutz'));
      expect(HealthModeUseCase.overtrainingPrevention.hasPhases, equals(false));
      expect(HealthModeUseCase.overtrainingPrevention.adjustsIntensity,
          equals(false));
    });

    test('generalWellnessTracking has correct properties', () {
      expect(HealthModeUseCase.generalWellnessTracking.label,
          equals('Allgemeines Wellness-Tracking'));
      expect(
          HealthModeUseCase.generalWellnessTracking.hasPhases, equals(false));
      expect(HealthModeUseCase.generalWellnessTracking.adjustsIntensity,
          equals(false));
    });
  });

  group('WellnessCheckIn', () {
    test('totalScore calculates sum of 4 components', () {
      final checkIn = WellnessCheckIn(
        date: DateTime(2024, 1, 1),
        energyLevel: 5,
        sleepQuality: 4,
        musclesoreness: 3,
        motivation: 2,
      );

      expect(checkIn.totalScore, equals(14));
    });

    test('normalizedScore converts totalScore to 0-100%', () {
      // Min score: 4 → 0%
      final minCheckIn = WellnessCheckIn(
        date: DateTime(2024, 1, 1),
        energyLevel: 1,
        sleepQuality: 1,
        musclesoreness: 1,
        motivation: 1,
      );
      expect(minCheckIn.normalizedScore, equals(0));

      // Max score: 20 → 100%
      final maxCheckIn = WellnessCheckIn(
        date: DateTime(2024, 1, 1),
        energyLevel: 5,
        sleepQuality: 5,
        musclesoreness: 5,
        motivation: 5,
      );
      expect(maxCheckIn.normalizedScore, equals(100));

      // Mid score: 12 → 50%
      final midCheckIn = WellnessCheckIn(
        date: DateTime(2024, 1, 1),
        energyLevel: 3,
        sleepQuality: 3,
        musclesoreness: 3,
        motivation: 3,
      );
      expect(midCheckIn.normalizedScore, equals(50));
    });

    test('recommendation returns correct wellness recommendation', () {
      expect(
        WellnessCheckIn(
          date: DateTime(2024, 1, 1),
          energyLevel: 5,
          sleepQuality: 5,
          musclesoreness: 5,
          motivation: 5,
        ).recommendation,
        equals(WellnessRecommendation.readyToTrain),
      );

      expect(
        WellnessCheckIn(
          date: DateTime(2024, 1, 1),
          energyLevel: 4,
          sleepQuality: 4,
          musclesoreness: 3,
          motivation: 3,
        ).recommendation,
        equals(WellnessRecommendation.lightTraining),
      );

      expect(
        WellnessCheckIn(
          date: DateTime(2024, 1, 1),
          energyLevel: 2,
          sleepQuality: 2,
          musclesoreness: 2,
          motivation: 2,
        ).recommendation,
        equals(WellnessRecommendation.activeRecovery),
      );

      expect(
        WellnessCheckIn(
          date: DateTime(2024, 1, 1),
          energyLevel: 1,
          sleepQuality: 1,
          musclesoreness: 1,
          motivation: 1,
        ).recommendation,
        equals(WellnessRecommendation.restDay),
      );
    });

    test('isRestingHrElevated correctly detects elevated HR', () {
      final checkIn = WellnessCheckIn(
        date: DateTime(2024, 1, 1),
        energyLevel: 3,
        sleepQuality: 3,
        musclesoreness: 3,
        motivation: 3,
        restingHeartRate: 66,
      );

      // HR 66 vs baseline 60: 66 > 60 * 1.1 (66) → not elevated (equal)
      expect(checkIn.isRestingHrElevated(60), equals(false));

      // HR 66 vs baseline 60: 66 > 60 * 1.1 (66) → elevated
      expect(checkIn.isRestingHrElevated(59), equals(true));

      // No HR data
      final noHrCheckIn = WellnessCheckIn(
        date: DateTime(2024, 1, 1),
        energyLevel: 3,
        sleepQuality: 3,
        musclesoreness: 3,
        motivation: 3,
      );
      expect(noHrCheckIn.isRestingHrElevated(60), equals(false));
    });

    test('WellnessCheckIn JSON serialization round-trip', () {
      final original = WellnessCheckIn(
        date: DateTime(2024, 1, 15, 10, 30, 0),
        energyLevel: 4,
        sleepQuality: 3,
        musclesoreness: 2,
        motivation: 5,
        restingHeartRate: 62,
        notes: 'Test note',
      );

      final json = original.toJson();
      final restored = WellnessCheckIn.fromJson(json);

      expect(restored.energyLevel, equals(original.energyLevel));
      expect(restored.sleepQuality, equals(original.sleepQuality));
      expect(restored.musclesoreness, equals(original.musclesoreness));
      expect(restored.motivation, equals(original.motivation));
      expect(restored.restingHeartRate, equals(original.restingHeartRate));
      expect(restored.notes, equals(original.notes));
      // Date converted to/from milliseconds, so check day equivalence
      expect(
        restored.date.year == original.date.year &&
            restored.date.month == original.date.month &&
            restored.date.day == original.date.day,
        equals(true),
      );
    });

    test('WellnessCheckIn equality works correctly', () {
      final checkIn1 = WellnessCheckIn(
        date: DateTime(2024, 1, 1),
        energyLevel: 3,
        sleepQuality: 3,
        musclesoreness: 3,
        motivation: 3,
      );

      final checkIn2 = WellnessCheckIn(
        date: DateTime(2024, 1, 1),
        energyLevel: 3,
        sleepQuality: 3,
        musclesoreness: 3,
        motivation: 3,
      );

      expect(checkIn1, equals(checkIn2));
    });
  });

  group('HealthMode - FTP Suggestion Logic', () {
    test('hasFtpSuggestion is false when detectedFtp is null', () {
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        originalFtp: 200,
        startDate: DateTime.now().subtract(const Duration(days: 3)),
      );

      expect(healthMode.hasFtpSuggestion, equals(false));
    });

    test('hasFtpSuggestion is false when detectedFtp <= effectiveFtp', () {
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        originalFtp: 200,
        startDate: DateTime.now().subtract(const Duration(days: 3)),
        detectedFtp: 100, // 200 * 0.5 (week1) = 100 effective FTP
      );

      expect(healthMode.hasFtpSuggestion, equals(false));
    });

    test('hasFtpSuggestion is true when detectedFtp > effectiveFtp', () {
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        originalFtp: 200,
        startDate: DateTime.now().subtract(const Duration(days: 3)),
        detectedFtp: 220, // > 100 (effective FTP in week1)
        ftpDetectedAt: DateTime.now(),
      );

      expect(healthMode.hasFtpSuggestion, equals(true));
    });

    test('hasFtpSuggestion is false when detection is older than 7 days', () {
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        originalFtp: 200,
        startDate: DateTime.now().subtract(const Duration(days: 3)),
        detectedFtp: 220,
        ftpDetectedAt: DateTime.now().subtract(const Duration(days: 8)),
      );

      expect(healthMode.hasFtpSuggestion, equals(false));
    });

    test('hasFtpSuggestion is true when detection is within 7 days', () {
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        originalFtp: 200,
        startDate: DateTime.now().subtract(const Duration(days: 3)),
        detectedFtp: 220,
        ftpDetectedAt: DateTime.now().subtract(const Duration(days: 5)),
      );

      expect(healthMode.hasFtpSuggestion, equals(true));
    });

    test('suggestedFtpIncrease calculates correct increase', () {
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        originalFtp: 200,
        startDate: DateTime.now().subtract(const Duration(days: 3)),
        detectedFtp: 220,
      );

      // effectiveFtp in week1: 200 * 0.5 = 100
      // suggestedFtpIncrease: 220 - 100 = 120
      expect(healthMode.suggestedFtpIncrease, equals(120));
    });

    test('suggestedFtpIncrease uses originalFtp when detectedFtp is null', () {
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        originalFtp: 200,
        startDate: DateTime.now().subtract(const Duration(days: 3)),
      );

      // (200 ?? 200) - 100 = 100
      expect(healthMode.suggestedFtpIncrease, equals(100));
    });
  });

  group('HealthMode - Phase Readiness Logic (Comeback Use Case)', () {
    test('isReadyForNextPhase is false when not Comeback use case', () {
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.overtrainingPrevention,
        isActive: true,
        originalFtp: 200,
        startDate: DateTime.now().subtract(const Duration(days: 5)),
      );

      expect(healthMode.isReadyForNextPhase, equals(false));
    });

    test('isReadyForNextPhase is false when currentPhase is completed', () {
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: false, // This makes currentPhase == null
      );

      expect(healthMode.isReadyForNextPhase, equals(false));
    });

    test('isReadyForNextPhase is false when less than 5 days in phase', () {
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        startDate: DateTime.now().subtract(const Duration(days: 3)),
      );

      expect(healthMode.isReadyForNextPhase, equals(false));
    });

    test('isReadyForNextPhase is false when not enough recent check-ins', () {
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        startDate: DateTime.now().subtract(const Duration(days: 5)),
        checkIns: [
          WellnessCheckIn(
            date: DateTime.now().subtract(const Duration(days: 10)),
            energyLevel: 5,
            sleepQuality: 5,
            musclesoreness: 5,
            motivation: 5,
          ),
        ],
      );

      expect(healthMode.isReadyForNextPhase, equals(false));
    });

    test('isReadyForNextPhase is false when wellness score < 60%', () {
      final now = DateTime.now();
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        startDate: now.subtract(const Duration(days: 5)),
        checkIns: [
          WellnessCheckIn(
            date: now,
            energyLevel: 2, // Low energy
            sleepQuality: 2,
            musclesoreness: 2,
            motivation: 2,
            // normalizedScore = (8-4)/16*100 = 25%
          ),
          WellnessCheckIn(
            date: now.subtract(const Duration(days: 1)),
            energyLevel: 2,
            sleepQuality: 2,
            musclesoreness: 2,
            motivation: 2,
            // normalizedScore = 25%
          ),
        ],
      );

      expect(healthMode.isReadyForNextPhase, equals(false));
    });

    test('isReadyForNextPhase is false when resting HR is trending', () {
      final now = DateTime.now();
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        startDate: now.subtract(const Duration(days: 5)),
        baselineRestingHr: 60,
        checkIns: [
          WellnessCheckIn(
            date: now,
            energyLevel: 5,
            sleepQuality: 5,
            musclesoreness: 5,
            motivation: 5,
            restingHeartRate: 70, // > 60 * 1.1 = 66, so elevated
          ),
          WellnessCheckIn(
            date: now.subtract(const Duration(days: 1)),
            energyLevel: 5,
            sleepQuality: 5,
            musclesoreness: 5,
            motivation: 5,
            restingHeartRate: 68,
          ),
          WellnessCheckIn(
            date: now.subtract(const Duration(days: 2)),
            energyLevel: 5,
            sleepQuality: 5,
            musclesoreness: 5,
            motivation: 5,
            restingHeartRate: 67,
          ),
        ],
      );

      expect(healthMode.isReadyForNextPhase, equals(false));
    });

    test('isReadyForNextPhase is true when all criteria are met', () {
      final now = DateTime.now();
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        startDate: now.subtract(const Duration(days: 5)),
        baselineRestingHr: 60,
        checkIns: [
          WellnessCheckIn(
            date: now,
            energyLevel: 5,
            sleepQuality: 5,
            musclesoreness: 5,
            motivation: 5,
            restingHeartRate: 60, // Normal
            // normalizedScore = 100%
          ),
          WellnessCheckIn(
            date: now.subtract(const Duration(days: 1)),
            energyLevel: 4,
            sleepQuality: 4,
            musclesoreness: 4,
            motivation: 4,
            restingHeartRate: 60,
            // normalizedScore = 75%
          ),
          WellnessCheckIn(
            date: now.subtract(const Duration(days: 2)),
            energyLevel: 4,
            sleepQuality: 4,
            musclesoreness: 4,
            motivation: 4,
            restingHeartRate: 60,
            // normalizedScore = 75%
          ),
        ],
      );

      expect(healthMode.isReadyForNextPhase, equals(true));
    });
  });

  group('HealthMode - Phase Progression Recommendation (Comeback Use Case)', () {
    test('recommendation says "completed" when already completed', () {
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: false,
      );

      expect(
        healthMode.phaseProgressionRecommendation,
        contains('Comeback abgeschlossen'),
      );
    });

    test('recommendation says "ready" when all criteria met', () {
      final now = DateTime.now();
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        startDate: now.subtract(const Duration(days: 5)),
        baselineRestingHr: 60,
        checkIns: [
          WellnessCheckIn(
            date: now,
            energyLevel: 5,
            sleepQuality: 5,
            musclesoreness: 5,
            motivation: 5,
            restingHeartRate: 60,
          ),
          WellnessCheckIn(
            date: now.subtract(const Duration(days: 1)),
            energyLevel: 5,
            sleepQuality: 5,
            musclesoreness: 5,
            motivation: 5,
            restingHeartRate: 60,
          ),
          WellnessCheckIn(
            date: now.subtract(const Duration(days: 2)),
            energyLevel: 5,
            sleepQuality: 5,
            musclesoreness: 5,
            motivation: 5,
            restingHeartRate: 60,
          ),
        ],
      );

      expect(
        healthMode.phaseProgressionRecommendation,
        contains('Bereit für'),
      );
    });

    test('recommendation is empty when not Comeback use case', () {
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.overtrainingPrevention,
        isActive: true,
        originalFtp: 200,
      );

      expect(healthMode.phaseProgressionRecommendation, equals(''));
    });

    test('recommendation mentions days left when not 5 days in phase', () {
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        startDate: DateTime.now().subtract(const Duration(days: 2)),
      );

      expect(
        healthMode.phaseProgressionRecommendation,
        contains('Tag'),
      );
    });

    test('recommendation mentions wellness when score too low', () {
      final now = DateTime.now();
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        startDate: now.subtract(const Duration(days: 5)),
        checkIns: [
          WellnessCheckIn(
            date: now,
            energyLevel: 1,
            sleepQuality: 1,
            musclesoreness: 1,
            motivation: 1,
          ),
          WellnessCheckIn(
            date: now.subtract(const Duration(days: 1)),
            energyLevel: 1,
            sleepQuality: 1,
            musclesoreness: 1,
            motivation: 1,
          ),
        ],
      );

      expect(
        healthMode.phaseProgressionRecommendation,
        contains('Wellness-Score'),
      );
    });

    test('recommendation mentions HR when trending high', () {
      final now = DateTime.now();
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        startDate: now.subtract(const Duration(days: 5)),
        baselineRestingHr: 60,
        checkIns: [
          WellnessCheckIn(
            date: now,
            energyLevel: 5,
            sleepQuality: 5,
            musclesoreness: 5,
            motivation: 5,
            restingHeartRate: 70,
          ),
          WellnessCheckIn(
            date: now.subtract(const Duration(days: 1)),
            energyLevel: 5,
            sleepQuality: 5,
            musclesoreness: 5,
            motivation: 5,
            restingHeartRate: 70,
          ),
          WellnessCheckIn(
            date: now.subtract(const Duration(days: 2)),
            energyLevel: 5,
            sleepQuality: 5,
            musclesoreness: 5,
            motivation: 5,
            restingHeartRate: 70,
          ),
        ],
      );

      expect(
        healthMode.phaseProgressionRecommendation,
        contains('Ruhepuls'),
      );
    });
  });

  group('HealthMode - Serialization with FTP Fields', () {
    test('HealthMode JSON round-trip with FTP fields', () {
      final detectedTime = DateTime(2024, 1, 15, 10, 30, 0);
      final original = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        startDate: DateTime(2024, 1, 10),
        originalFtp: 200,
        detectedFtp: 220,
        ftpDetectedAt: detectedTime,
        ftpDetectionMethod: '20min',
      );

      final json = original.toJson();
      final restored = HealthMode.fromJson(json);

      expect(restored.detectedFtp, equals(original.detectedFtp));
      expect(restored.ftpDetectionMethod, equals(original.ftpDetectionMethod));
      expect(restored.ftpDetectedAt?.toIso8601String(),
          equals(original.ftpDetectedAt?.toIso8601String()));
      expect(restored.useCase, equals(original.useCase));
    });

    test('HealthMode JSON with null FTP fields', () {
      final original = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        startDate: DateTime(2024, 1, 10),
        originalFtp: 200,
      );

      final json = original.toJson();
      final restored = HealthMode.fromJson(json);

      expect(restored.detectedFtp, isNull);
      expect(restored.ftpDetectedAt, isNull);
      expect(restored.ftpDetectionMethod, isNull);
    });

    test('HealthMode fromJson with missing FTP fields', () {
      final json = {
        'isActive': true,
        'originalFtp': 200,
        'useCase': 0, // comebackAfterIllness
      };

      final healthMode = HealthMode.fromJson(json);

      expect(healthMode.detectedFtp, isNull);
      expect(healthMode.ftpDetectedAt, isNull);
      expect(healthMode.ftpDetectionMethod, isNull);
    });

    test('HealthMode fromComebackMode migration factory', () {
      final oldJson = {
        'isActive': true,
        'startDate': DateTime(2024, 1, 10).millisecondsSinceEpoch,
        'illnessStartDate': DateTime(2024, 1, 1).millisecondsSinceEpoch,
        'originalFtp': 200,
        'baselineRestingHr': 60,
        'illnessType': 'Grippe',
        'detectedFtp': 220,
      };

      final migrated = HealthMode.fromComebackMode(oldJson);

      expect(migrated.useCase, equals(HealthModeUseCase.comebackAfterIllness));
      expect(migrated.isActive, equals(true));
      expect(migrated.pauseReason, equals('Grippe'));
      expect(migrated.pauseStartDate, isNotNull);
      expect(migrated.detectedFtp, equals(220));
    });
  });

  group('HealthMode - copyWith with FTP Fields', () {
    test('copyWith updates FTP fields', () {
      final original = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        originalFtp: 200,
      );

      final now = DateTime.now();
      final updated = original.copyWith(
        detectedFtp: 220,
        ftpDetectedAt: now,
        ftpDetectionMethod: 'sweetspot',
      );

      expect(updated.detectedFtp, equals(220));
      expect(updated.ftpDetectedAt, equals(now));
      expect(updated.ftpDetectionMethod, equals('sweetspot'));
      expect(updated.originalFtp, equals(200)); // Unchanged
      expect(updated.useCase, equals(HealthModeUseCase.comebackAfterIllness));
    });

    test('copyWith preserves FTP fields when not specified', () {
      final now = DateTime.now();
      final original = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        originalFtp: 200,
        detectedFtp: 220,
        ftpDetectedAt: now,
        ftpDetectionMethod: '20min',
      );

      final updated = original.copyWith(isActive: false);

      expect(updated.detectedFtp, equals(220));
      expect(updated.ftpDetectedAt, equals(now));
      expect(updated.ftpDetectionMethod, equals('20min'));
    });

    test('copyWith can change useCase', () {
      final original = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        originalFtp: 200,
      );

      final updated = original.copyWith(
        useCase: HealthModeUseCase.overtrainingPrevention,
      );

      expect(updated.useCase,
          equals(HealthModeUseCase.overtrainingPrevention));
      expect(updated.isActive, equals(true));
      expect(updated.originalFtp, equals(200));
    });
  });

  group('HealthMode - Effective FTP by Phase', () {
    test('effectiveFtp in Comeback mode matches phase intensity factor', () {
      final now = DateTime.now();
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        originalFtp: 200,
        startDate: now.subtract(const Duration(days: 3)),
      );

      // In week1 (first 7 days): 50% intensity
      expect(healthMode.effectiveFtp, equals(100));
    });

    test(
        'effectiveFtp in non-Comeback modes returns originalFtp without adjustment',
        () {
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.overtrainingPrevention,
        isActive: true,
        originalFtp: 200,
        startDate: DateTime.now().subtract(const Duration(days: 3)),
      );

      // Should return originalFtp without intensity reduction
      expect(healthMode.effectiveFtp, equals(200));
    });

    test('effectiveFtp changes as phases progress in Comeback mode', () {
      final now = DateTime.now();

      // Week 1 (day 3): 50%
      var healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        originalFtp: 200,
        startDate: now.subtract(const Duration(days: 3)),
      );
      expect(healthMode.effectiveFtp, equals(100));
      expect(healthMode.currentPhase,
          equals(ComebackProtocolPhase.week1));
    });
  });

  group('HealthMode - Average Wellness Score', () {
    test('averageWellnessScore7d returns 50 when no check-ins', () {
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        originalFtp: 200,
      );

      expect(healthMode.averageWellnessScore7d, equals(50));
    });

    test('averageWellnessScore7d ignores check-ins older than 7 days', () {
      final now = DateTime.now();
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        originalFtp: 200,
        checkIns: [
          WellnessCheckIn(
            date: now.subtract(const Duration(days: 8)),
            energyLevel: 1,
            sleepQuality: 1,
            musclesoreness: 1,
            motivation: 1,
            // normalizedScore = 0%
          ),
          WellnessCheckIn(
            date: now,
            energyLevel: 5,
            sleepQuality: 5,
            musclesoreness: 5,
            motivation: 5,
            // normalizedScore = 100%
          ),
        ],
      );

      // Should only count the recent check-in (100%)
      expect(healthMode.averageWellnessScore7d, equals(100));
    });

    test('averageWellnessScore7d calculates correct average', () {
      final now = DateTime.now();
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        originalFtp: 200,
        checkIns: [
          WellnessCheckIn(
            date: now,
            energyLevel: 5,
            sleepQuality: 5,
            musclesoreness: 5,
            motivation: 5,
            // normalizedScore = 100%
          ),
          WellnessCheckIn(
            date: now.subtract(const Duration(days: 1)),
            energyLevel: 3,
            sleepQuality: 3,
            musclesoreness: 3,
            motivation: 3,
            // normalizedScore = 50%
          ),
        ],
      );

      expect(healthMode.averageWellnessScore7d, equals(75));
    });
  });

  group('HealthMode - Resting HR Trending', () {
    test('isRestingHrTrending is false when no baseline', () {
      final now = DateTime.now();
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        originalFtp: 200,
        checkIns: [
          WellnessCheckIn(
            date: now,
            energyLevel: 3,
            sleepQuality: 3,
            musclesoreness: 3,
            motivation: 3,
            restingHeartRate: 70,
          ),
        ],
      );

      expect(healthMode.isRestingHrTrending, equals(false));
    });

    test('isRestingHrTrending is false when HR not elevated', () {
      final now = DateTime.now();
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        originalFtp: 200,
        baselineRestingHr: 60,
        checkIns: [
          WellnessCheckIn(
            date: now,
            energyLevel: 3,
            sleepQuality: 3,
            musclesoreness: 3,
            motivation: 3,
            restingHeartRate: 60,
          ),
          WellnessCheckIn(
            date: now.subtract(const Duration(days: 1)),
            energyLevel: 3,
            sleepQuality: 3,
            musclesoreness: 3,
            motivation: 3,
            restingHeartRate: 62,
          ),
        ],
      );

      expect(healthMode.isRestingHrTrending, equals(false));
    });

    test('isRestingHrTrending is true when HR elevated for 3 days', () {
      final now = DateTime.now();
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        originalFtp: 200,
        baselineRestingHr: 60,
        checkIns: [
          WellnessCheckIn(
            date: now,
            energyLevel: 3,
            sleepQuality: 3,
            musclesoreness: 3,
            motivation: 3,
            restingHeartRate: 68,
          ),
          WellnessCheckIn(
            date: now.subtract(const Duration(days: 1)),
            energyLevel: 3,
            sleepQuality: 3,
            musclesoreness: 3,
            motivation: 3,
            restingHeartRate: 68,
          ),
          WellnessCheckIn(
            date: now.subtract(const Duration(days: 2)),
            energyLevel: 3,
            sleepQuality: 3,
            musclesoreness: 3,
            motivation: 3,
            restingHeartRate: 67,
          ),
        ],
      );

      expect(healthMode.isRestingHrTrending, equals(true));
    });
  });

  group('HealthMode - Current Phase (Comeback Use Case Only)', () {
    test('currentPhase is null for non-Comeback use cases', () {
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.overtrainingPrevention,
        isActive: true,
        originalFtp: 200,
        startDate: DateTime.now().subtract(const Duration(days: 5)),
      );

      expect(healthMode.currentPhase, isNull);
    });

    test('currentPhase is null when not active', () {
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: false,
        originalFtp: 200,
      );

      expect(healthMode.currentPhase, isNull);
    });

    test('currentPhase returns week1 in first 7 days', () {
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        originalFtp: 200,
        startDate: DateTime.now().subtract(const Duration(days: 3)),
      );

      expect(healthMode.currentPhase, equals(ComebackProtocolPhase.week1));
    });

    test('currentPhase returns week4 at day 22', () {
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        originalFtp: 200,
        startDate: DateTime.now().subtract(const Duration(days: 22)),
      );

      expect(healthMode.currentPhase, equals(ComebackProtocolPhase.week4));
    });

    test('currentPhase returns completed after 28 days', () {
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        originalFtp: 200,
        startDate: DateTime.now().subtract(const Duration(days: 30)),
      );

      expect(healthMode.currentPhase,
          equals(ComebackProtocolPhase.completed));
    });
  });

  group('HealthMode - Progress Percent', () {
    test('progressPercent is 100 when not active', () {
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: false,
        originalFtp: 200,
      );

      expect(healthMode.progressPercent, equals(100));
    });

    test('progressPercent is 100 for non-Comeback use cases', () {
      final healthMode = HealthMode(
        useCase: HealthModeUseCase.overtrainingPrevention,
        isActive: true,
        originalFtp: 200,
        startDate: DateTime.now().subtract(const Duration(days: 5)),
      );

      expect(healthMode.progressPercent, equals(100));
    });

    test('progressPercent increases as Comeback protocol progresses', () {
      final now = DateTime.now();

      // Day 7 (end of week 1): ~25%
      var healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        originalFtp: 200,
        startDate: now.subtract(const Duration(days: 7)),
      );
      expect(healthMode.progressPercent,
          greaterThan(20)); // Allow some variance
      expect(healthMode.progressPercent, lessThan(30));

      // Day 28 (end of week 4): 100%
      healthMode = HealthMode(
        useCase: HealthModeUseCase.comebackAfterIllness,
        isActive: true,
        originalFtp: 200,
        startDate: now.subtract(const Duration(days: 28)),
      );
      expect(healthMode.progressPercent, equals(100));
    });
  });
}
