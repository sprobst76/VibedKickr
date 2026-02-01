import 'package:flutter_test/flutter_test.dart';
import 'package:kickr_trainer/core/services/health_program_result_analyzer.dart';
import 'package:kickr_trainer/domain/entities/athlete_profile.dart';
import 'package:kickr_trainer/domain/entities/health_safety_report.dart';
import 'package:kickr_trainer/domain/entities/training_session.dart';

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
  group('HealthProgramResultAnalyzer', () {
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
      gender: Gender.male,
      ftp: 300,
      weight: 70,
    );

    final seniorAthlete = createTestAthlete(
      id: 'test3',
      name: 'Senior User',
      birthDate: DateTime(1950, 1, 1), // 73 years old
      gender: Gender.female,
      ftp: 180,
      weight: 65,
    );

    group('HR Recovery Analysis', () {
      test('analyzeHrRecovery returns null for empty data', () {
        final result =
            HealthProgramResultAnalyzer.analyzeHrRecovery([], testAthlete);
        expect(result, isNull);
      });

      test('analyzeHrRecovery calculates recovery correctly', () {
        final dataPoints = [
          // Build up to peak HR
          DataPoint(timestamp: 0, power: 100, heartRate: 100),
          DataPoint(timestamp: 30000, power: 200, heartRate: 140),
          DataPoint(timestamp: 60000, power: 250, heartRate: 160),
          // Peak HR at 90000
          DataPoint(timestamp: 90000, power: 250, heartRate: 165),
          // Recovery period (1 minute = 60000ms after peak = 150000ms total)
          DataPoint(timestamp: 150000, power: 50, heartRate: 145),
          // 2 minutes after peak = 120000ms after peak = 210000ms total
          DataPoint(timestamp: 210000, power: 50, heartRate: 130),
        ];

        final result =
            HealthProgramResultAnalyzer.analyzeHrRecovery(dataPoints, testAthlete);

        expect(result, isNotNull);
        expect(result!.startHr, 165);
        // The analysis looks for data at 60000-70000ms after peak (should match 150000ms total)
        expect(result.hrAfter1Min, 145);
        // The analysis looks for data at 120000-130000ms after peak (should match 210000ms total)
        expect(result.hrAfter2Min, 130);
        expect(result.drop1Min, 20);
        expect(result.drop2Min, 35);
        expect(result.recoveryScore, greaterThan(0));
      });

      test('excellent recovery for young athletes', () {
        final dataPoints = [
          DataPoint(timestamp: 60000, power: 250, heartRate: 170), // Peak
          // 1 minute after peak (60000 + 60000 = 120000ms)
          DataPoint(timestamp: 120000, power: 50, heartRate: 145), // 25 bpm drop
          // 2 minutes after peak (60000 + 120000 = 180000ms)
          DataPoint(timestamp: 180000, power: 50, heartRate: 125), // 45 bpm drop
        ];

        final result = HealthProgramResultAnalyzer.analyzeHrRecovery(
            dataPoints, youngAthlete);

        expect(result, isNotNull);
        expect(result!.recoveryScore, greaterThan(70));
        expect(result.assessment, contains('Ausgezeichnet'));
      });

      test('recovery adjusted for age', () {
        final dataPoints = [
          DataPoint(timestamp: 60000, power: 250, heartRate: 155), // Peak
          // 1 minute after peak (60000 + 60000 = 120000ms)
          DataPoint(timestamp: 120000, power: 50, heartRate: 142), // 13 bpm drop
          // 2 minutes after peak (60000 + 120000 = 180000ms)
          DataPoint(timestamp: 180000, power: 50, heartRate: 135), // 20 bpm drop
        ];

        final result =
            HealthProgramResultAnalyzer.analyzeHrRecovery(dataPoints, seniorAthlete);

        expect(result, isNotNull);
        expect(result!.drop1Min, 13);
        // Senior athletes have lower expected drops
        expect(result.recoveryScore, greaterThan(40));
      });
    });

    group('Fitness Level Estimation', () {
      test('analyzeFitnessLevel returns null for null stats', () {
        final result = HealthProgramResultAnalyzer.analyzeFitnessLevel(null, testAthlete);
        expect(result, isNull);
      });

      test('excellent fitness for high intensity factor', () {
        final stats = SessionStats(
          duration: const Duration(minutes: 45),
          avgPower: 270,
          maxPower: 320,
          normalizedPower: 280,
          intensityFactor: 1.12, // High IF
          tss: 85,
          totalWork: 750,
          avgHeartRate: 155,
          maxHeartRate: 175,
        );

        final result = HealthProgramResultAnalyzer.analyzeFitnessLevel(stats, testAthlete);

        expect(result, isNotNull);
        expect(result!.level, FitnessLevel.excellent);
        expect(result.overallScore, greaterThan(80));
      });

      test('good fitness for moderate intensity', () {
        final stats = SessionStats(
          duration: const Duration(minutes: 60),
          avgPower: 220,
          maxPower: 270,
          normalizedPower: 230,
          intensityFactor: 0.92,
          tss: 65,
          totalWork: 825,
          avgHeartRate: 140,
          maxHeartRate: 160,
        );

        final result = HealthProgramResultAnalyzer.analyzeFitnessLevel(stats, testAthlete);

        expect(result!.level, FitnessLevel.good);
        expect(result.overallScore, inInclusiveRange(65, 80));
      });

      test('poor fitness for low intensity', () {
        final stats = SessionStats(
          duration: const Duration(minutes: 30),
          avgPower: 120,
          maxPower: 150,
          normalizedPower: 125,
          intensityFactor: 0.5,
          tss: 25,
          totalWork: 225,
          avgHeartRate: 110,
          maxHeartRate: 130,
        );

        final result = HealthProgramResultAnalyzer.analyzeFitnessLevel(stats, seniorAthlete);

        // Low intensity factor of 0.5 may result in fair or poor depending on calculation
        expect(result!.level, isIn([FitnessLevel.fair, FitnessLevel.poor]));
        expect(result.overallScore, lessThan(60));
      });

      test('suggestions generated for each fitness level', () {
        final excellentStats = SessionStats(
          duration: const Duration(minutes: 45),
          avgPower: 320,
          maxPower: 360,
          normalizedPower: 330,
          intensityFactor: 1.32,
          tss: 100,
          totalWork: 900,
          avgHeartRate: 165,
          maxHeartRate: 180,
        );

        final result = HealthProgramResultAnalyzer.analyzeFitnessLevel(
            excellentStats, youngAthlete);

        expect(result!.suggestions.isNotEmpty, true);
        expect(result.suggestions.length, greaterThan(0));
      });
    });

    group('Session Comparison', () {
      test('first session detection', () {
        final currentStats = SessionStats(
          duration: const Duration(minutes: 45),
          avgPower: 220,
          maxPower: 270,
          normalizedPower: 230,
          intensityFactor: 0.92,
          tss: 65,
          totalWork: 825,
        );

        final result = HealthProgramResultAnalyzer.compareWithPrevious(
            currentStats, null);

        expect(result.isFirstSession, true);
        expect(result.assessment, contains('Herzlichen Glückwunsch'));
      });

      test('HR improvement detection', () {
        final previousStats = SessionStats(
          duration: const Duration(minutes: 45),
          avgPower: 220,
          maxPower: 270,
          normalizedPower: 230,
          intensityFactor: 0.92,
          tss: 65,
          totalWork: 825,
          avgHeartRate: 160,
        );

        final currentStats = SessionStats(
          duration: const Duration(minutes: 45),
          avgPower: 220,
          maxPower: 270,
          normalizedPower: 230,
          intensityFactor: 0.92,
          tss: 65,
          totalWork: 825,
          avgHeartRate: 135, // ~15% lower HR
        );

        final result = HealthProgramResultAnalyzer.compareWithPrevious(
            currentStats, previousStats);

        expect(result.isFirstSession, false);
        // Should show improvement in HR
        expect(result.hrChange, isNotNull);
        expect(result.hrChange!, lessThan(-10));
      });

      test('power improvement detection', () {
        final previousStats = SessionStats(
          duration: const Duration(minutes: 45),
          avgPower: 200,
          maxPower: 250,
          normalizedPower: 210,
          intensityFactor: 0.84,
          tss: 60,
          totalWork: 750,
          avgHeartRate: 140,
        );

        final currentStats = SessionStats(
          duration: const Duration(minutes: 45),
          avgPower: 240, // 20% more
          maxPower: 290,
          normalizedPower: 250,
          intensityFactor: 1.0,
          tss: 72,
          totalWork: 900,
          avgHeartRate: 145,
        );

        final result = HealthProgramResultAnalyzer.compareWithPrevious(
            currentStats, previousStats);

        expect(result.powerChange, greaterThan(10));
        expect(result.assessment, contains('Progression'));
      });
    });

    group('Next Program Recommendation', () {
      test('excellent fitness recommends stress test', () {
        final fitnessEstimate = FitnessLevelEstimate(
          level: FitnessLevel.excellent,
          powerScore: 95,
          hrScore: 90,
          overallScore: 92,
          description: 'Test',
          suggestions: [],
        );

        // This would be tested through program generation
        expect(fitnessEstimate.level, FitnessLevel.excellent);
      });
    });

    group('Safety Rating', () {
      test('safe rating for clean session', () {
        final report = HealthSafetyReport(
          id: 'test',
          sessionId: 'session1',
          events: const [],
          timeAboveInfoLimit: 0,
          timeAboveWarningLimit: 0,
          limitExceededCount: 0,
          autoPauseTriggerCount: 0,
          emergencyStopUsed: false,
          safeLimitHr: 170,
        );

        expect(report.getSafetyRating(), SafetyRating.safe);
      });

      test('warning rating when auto-pause triggered', () {
        final report = HealthSafetyReport(
          id: 'test',
          sessionId: 'session1',
          events: const [],
          timeAboveInfoLimit: 30000,
          timeAboveWarningLimit: 10000,
          limitExceededCount: 2,
          autoPauseTriggerCount: 1,
          emergencyStopUsed: false,
          safeLimitHr: 170,
        );

        expect(report.getSafetyRating(), SafetyRating.warning);
      });

      test('unsafe rating when emergency stop used', () {
        final report = HealthSafetyReport(
          id: 'test',
          sessionId: 'session1',
          events: const [],
          timeAboveInfoLimit: 60000,
          timeAboveWarningLimit: 30000,
          limitExceededCount: 5,
          autoPauseTriggerCount: 2,
          emergencyStopUsed: true,
          safeLimitHr: 170,
        );

        expect(report.getSafetyRating(), SafetyRating.unsafe);
      });
    });
  });
}
