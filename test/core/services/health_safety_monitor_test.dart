import 'package:flutter_test/flutter_test.dart';
import 'package:kickr_trainer/core/services/health_safety_monitor.dart';
import 'package:kickr_trainer/domain/entities/athlete_profile.dart';

/// Helper to create test athlete profiles
AthleteProfile createTestAthlete({
  required String id,
  required String name,
  required DateTime birthDate,
  required Gender gender,
  required int ftp,
  int? weight,
}) {
  return AthleteProfile(
    id: id,
    name: name,
    birthDate: birthDate,
    gender: gender,
    weight: weight,
    ftp: ftp,
    powerZones: PowerZones.fromFtp(ftp),
  );
}

void main() {
  group('HealthTrainingSafetyMonitor', () {
    final testAthlete = createTestAthlete(
      id: 'test1',
      name: 'Test User',
      birthDate: DateTime(1980, 1, 1), // 45 years old
      gender: Gender.male,
      ftp: 250,
      weight: 75,
    );

    final youngAthlete = createTestAthlete(
      id: 'test2',
      name: 'Young User',
      birthDate: DateTime(2000, 1, 1), // 24 years old
      gender: Gender.female,
      ftp: 300,
      weight: 65,
    );

    final seniorAthlete = createTestAthlete(
      id: 'test3',
      name: 'Senior User',
      birthDate: DateTime(1950, 1, 1), // 73 years old
      gender: Gender.female,
      ftp: 180,
      weight: 65,
    );

    group('HR Warning Level Detection', () {
      test('normal HR status when well below limit', () {
        final status = HealthTrainingSafetyMonitor.calculateHrStatus(
          currentHr: 120,
          athlete: testAthlete,
        );

        expect(status.warningLevel, HrWarningLevel.normal);
        expect(status.shouldAutoPause, false);
      });

      test('info warning at 85% of safe limit', () {
        // testAthlete is now 45 years old (born 1980-01-01, today 2026-02-01)
        // Max HR (Tanaka): 208 - (0.7 × 45) = 178.5 ≈ 179
        // maxHrPercent for age 45-50: 85%
        // maxSafeHr: 179 × 0.85 = 152.15 ≈ 152
        // 85% of maxSafeHr: 152 × 0.85 = 129.2 ≈ 129
        final status = HealthTrainingSafetyMonitor.calculateHrStatus(
          currentHr: 130,
          athlete: testAthlete,
        );

        expect(status.warningLevel, HrWarningLevel.info);
        expect(status.shouldAutoPause, false);
      });

      test('warning level at 95% of safe limit', () {
        // maxSafeHr: 152
        // 95% of maxSafeHr: 152 × 0.95 = 144.4 ≈ 144
        final status = HealthTrainingSafetyMonitor.calculateHrStatus(
          currentHr: 145,
          athlete: testAthlete,
        );

        expect(status.warningLevel, HrWarningLevel.warning);
        expect(status.shouldAutoPause, false);
      });

      test('critical when exceeding auto-pause limit', () {
        final status = HealthTrainingSafetyMonitor.calculateHrStatus(
          currentHr: 175, // >100% of safe limit for 45-year-old
          athlete: testAthlete,
        );

        expect(status.warningLevel, HrWarningLevel.critical);
        expect(status.shouldAutoPause, true);
      });
    });

    group('Age-Based Safety Limits', () {
      test('young athlete has higher safe limits', () {
        final youngStatus = HealthTrainingSafetyMonitor.calculateHrStatus(
          currentHr: 180,
          athlete: youngAthlete,
        );

        final olderStatus = HealthTrainingSafetyMonitor.calculateHrStatus(
          currentHr: 180,
          athlete: testAthlete,
        );

        // Same HR should be less concerning for young athlete
        expect(youngStatus.warningLevel.index, lessThanOrEqualTo(olderStatus.warningLevel.index));
      });

      test('senior athlete has lower safe limits', () {
        final seniorStatus = HealthTrainingSafetyMonitor.calculateHrStatus(
          currentHr: 155,
          athlete: seniorAthlete,
        );

        expect(seniorStatus.warningLevel.index, greaterThanOrEqualTo(HrWarningLevel.info.index));
      });

      test('safety limits respect age progression', () {
        // Test that limits decrease appropriately with age
        final athlete40s = AthleteProfile(
          id: 'test40s',
          name: '40s',
          birthDate: DateTime(1980, 1, 1),
          gender: Gender.male,
          weight: 75,
          ftp: 250,
          powerZones: PowerZones.fromFtp(250),
        );

        final athlete60s = AthleteProfile(
          id: 'test60s',
          name: '60s',
          birthDate: DateTime(1960, 1, 1),
          gender: Gender.male,
          weight: 75,
          ftp: 200,
          powerZones: PowerZones.fromFtp(200),
        );

        final limits40s = HealthTrainingSafetyMonitor.calculateHrStatus(
          currentHr: 160,
          athlete: athlete40s,
        );

        final limits60s = HealthTrainingSafetyMonitor.calculateHrStatus(
          currentHr: 160,
          athlete: athlete60s,
        );

        // Same HR should trigger higher warning level for older athlete
        expect(limits60s.warningLevel.index, greaterThanOrEqualTo(limits40s.warningLevel.index));
      });
    });

    group('HR Recovery Calculations', () {
      test('calculateRecoveryHrDrop returns positive drop', () {
        final drop = HealthTrainingSafetyMonitor.calculateRecoveryHrDrop(
          peakHr: 160,
          currentHr: 140,
        );

        expect(drop, 20);
      });

      test('calculateRecoveryHrDrop returns null when HR rising', () {
        final drop = HealthTrainingSafetyMonitor.calculateRecoveryHrDrop(
          peakHr: 140,
          currentHr: 150,
        );

        expect(drop, isNull);
      });

      test('isRecoveryAdequate evaluates recovery', () {
        final adequate =
            HealthTrainingSafetyMonitor.isRecoveryAdequate(hrDrop: 18, minExpectedDrop: 15);

        final inadequate =
            HealthTrainingSafetyMonitor.isRecoveryAdequate(hrDrop: 8, minExpectedDrop: 15);

        expect(adequate, true);
        expect(inadequate, false);
      });
    });

    group('Audio Warning Cooldown', () {
      test('no warning on first occurrence', () {
        final shouldPlay = HealthTrainingSafetyMonitor.shouldPlayAudioWarning(
          HrWarningLevel.warning,
          null,
        );

        expect(shouldPlay, true);
      });

      test('warning blocked during cooldown period', () {
        final recentTime = DateTime.now().subtract(const Duration(seconds: 1));

        final shouldPlay = HealthTrainingSafetyMonitor.shouldPlayAudioWarning(
          HrWarningLevel.warning,
          recentTime,
        );

        expect(shouldPlay, false);
      });

      test('warning allowed after cooldown', () {
        final oldTime = DateTime.now().subtract(const Duration(seconds: 5));

        final shouldPlay = HealthTrainingSafetyMonitor.shouldPlayAudioWarning(
          HrWarningLevel.warning,
          oldTime,
        );

        expect(shouldPlay, true);
      });

      test('info warnings have longer cooldown', () {
        // INFO warnings should have 5s cooldown vs 3s for others
        final recentTime = DateTime.now().subtract(const Duration(seconds: 4));

        final infoWarning = HealthTrainingSafetyMonitor.shouldPlayAudioWarning(
          HrWarningLevel.info,
          recentTime,
        );

        // Info should still be blocked, warning might be allowed
        expect(infoWarning, false);
      });
    });

    group('Message Generation', () {
      test('normal status has empty message', () {
        final status = HealthTrainingSafetyMonitor.calculateHrStatus(
          currentHr: 120,
          athlete: testAthlete,
        );

        expect(status.warningMessage, isEmpty);
      });

      test('info warning has appropriate message', () {
        final status = HealthTrainingSafetyMonitor.calculateHrStatus(
          currentHr: 130, // Should be INFO level
          athlete: testAthlete,
        );

        expect(status.warningMessage, isNotEmpty);
        expect(status.warningMessage.toLowerCase(), contains('erhöht'));
      });

      test('critical warning emphasizes danger', () {
        final status = HealthTrainingSafetyMonitor.calculateHrStatus(
          currentHr: 175,
          athlete: testAthlete,
        );

        expect(status.warningMessage, contains('KRITISCH'));
      });
    });

    group('HR Percentage Calculations', () {
      test('hr percentage calculated correctly', () {
        final status = HealthTrainingSafetyMonitor.calculateHrStatus(
          currentHr: 100,
          athlete: testAthlete,
        );

        // Should calculate relative to maxSafeHr, not absolute
        expect(status.hrPercent, isNotNull);
        expect(status.hrPercent, greaterThan(0));
        expect(status.hrPercent, lessThanOrEqualTo(100));
      });

      test('null HR returns zero percentage', () {
        final status = HealthTrainingSafetyMonitor.calculateHrStatus(
          currentHr: null,
          athlete: testAthlete,
        );

        expect(status.hrPercent, 0);
        expect(status.currentHr, isNull);
      });
    });
  });
}
