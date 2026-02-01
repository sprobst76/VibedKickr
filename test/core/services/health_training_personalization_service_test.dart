import 'package:flutter_test/flutter_test.dart';
import 'package:kickr_trainer/core/services/health_training_personalization_service.dart';
import 'package:kickr_trainer/domain/entities/athlete_profile.dart';
import 'package:kickr_trainer/domain/entities/health_safety_limits.dart';

void main() {
  group('HealthTrainingPersonalizationService', () {
    group('calculateMaxHeartRate', () {
      test('Tanaka formula for males at age 25', () {
        // 208 - (0.7 × 25) = 208 - 17.5 = 190.5 ≈ 191
        final maxHr = HealthTrainingPersonalizationService.calculateMaxHeartRate(
          25,
          gender: Gender.male,
        );
        expect(maxHr, 191);
      });

      test('Tanaka formula for males at age 45', () {
        // 208 - (0.7 × 45) = 208 - 31.5 = 176.5 ≈ 177
        final maxHr = HealthTrainingPersonalizationService.calculateMaxHeartRate(
          45,
          gender: Gender.male,
        );
        expect(maxHr, 177);
      });

      test('Tanaka formula for males at age 65', () {
        // 208 - (0.7 × 65) = 208 - 45.5 = 162.5 ≈ 163
        final maxHr = HealthTrainingPersonalizationService.calculateMaxHeartRate(
          65,
          gender: Gender.male,
        );
        expect(maxHr, 163);
      });

      test('Gulati formula for females at age 25', () {
        // 206 - (0.88 × 25) = 206 - 22 = 184
        final maxHr = HealthTrainingPersonalizationService.calculateMaxHeartRate(
          25,
          gender: Gender.female,
        );
        expect(maxHr, 184);
      });

      test('Gulati formula for females at age 45', () {
        // 206 - (0.88 × 45) = 206 - 39.6 = 166.4 ≈ 166
        final maxHr = HealthTrainingPersonalizationService.calculateMaxHeartRate(
          45,
          gender: Gender.female,
        );
        expect(maxHr, 166);
      });

      test('Gulati formula for females at age 65', () {
        // 206 - (0.88 × 65) = 206 - 57.2 = 148.8 ≈ 149
        final maxHr = HealthTrainingPersonalizationService.calculateMaxHeartRate(
          65,
          gender: Gender.female,
        );
        expect(maxHr, 149);
      });

      test('Default Tanaka formula when gender not specified', () {
        // Should use Tanaka even without gender
        final maxHr = HealthTrainingPersonalizationService.calculateMaxHeartRate(30);
        // 208 - (0.7 × 30) = 208 - 21 = 187
        expect(maxHr, 187);
      });
    });

    group('calculateAgeFactor', () {
      test('Age < 40 returns 0.90', () {
        expect(HealthTrainingPersonalizationService.calculateAgeFactor(25), 0.90);
        expect(HealthTrainingPersonalizationService.calculateAgeFactor(39), 0.90);
      });

      test('Age 40-49 returns 0.85', () {
        expect(HealthTrainingPersonalizationService.calculateAgeFactor(40), 0.85);
        expect(HealthTrainingPersonalizationService.calculateAgeFactor(45), 0.85);
        expect(HealthTrainingPersonalizationService.calculateAgeFactor(49), 0.85);
      });

      test('Age 50-59 returns 0.80', () {
        expect(HealthTrainingPersonalizationService.calculateAgeFactor(50), 0.80);
        expect(HealthTrainingPersonalizationService.calculateAgeFactor(55), 0.80);
        expect(HealthTrainingPersonalizationService.calculateAgeFactor(59), 0.80);
      });

      test('Age 60-69 returns 0.75', () {
        expect(HealthTrainingPersonalizationService.calculateAgeFactor(60), 0.75);
        expect(HealthTrainingPersonalizationService.calculateAgeFactor(65), 0.75);
        expect(HealthTrainingPersonalizationService.calculateAgeFactor(69), 0.75);
      });

      test('Age 70+ returns 0.70', () {
        expect(HealthTrainingPersonalizationService.calculateAgeFactor(70), 0.70);
        expect(HealthTrainingPersonalizationService.calculateAgeFactor(75), 0.70);
        expect(HealthTrainingPersonalizationService.calculateAgeFactor(80), 0.70);
      });
    });

    group('applyAgeFactor', () {
      test('Young athlete (25) can reach 90% of max HR at 100% target', () {
        // maxHr: 191, ageFactor: 0.90, targetPercent: 100
        // Result: (100 * 0.90 / 100) * 191 = 0.90 * 191 = 171.9 ≈ 172
        final result = HealthTrainingPersonalizationService.applyAgeFactor(191, 100, 25);
        expect(result, 172);
      });

      test('Older athlete (65) cannot reach young intensity', () {
        // maxHr: 163, ageFactor: 0.75, targetPercent: 100
        // Result: (100 * 0.75 / 100) * 163 = 0.75 * 163 = 122.25 ≈ 122
        final result = HealthTrainingPersonalizationService.applyAgeFactor(163, 100, 65);
        expect(result, 122);
      });

      test('Senior athlete (75) has conservative limits', () {
        // maxHr: ~157, ageFactor: 0.70, targetPercent: 100
        final maxHr = HealthTrainingPersonalizationService.calculateMaxHeartRate(75);
        final result = HealthTrainingPersonalizationService.applyAgeFactor(maxHr, 100, 75);
        // Should be roughly 70% of max HR
        expect(result, lessThan(maxHr));
        expect(result, greaterThan((0.69 * maxHr).round()));
      });
    });

    group('calculateSafeHeartRateZone', () {
      test('Returns safe HR zone for young athlete', () {
        final athlete = AthleteProfile(
          id: 'test_young',
          ftp: 250,
          powerZones: PowerZones.fromFtp(250),
          birthDate: DateTime(2000, 1, 1), // 24-25 years old
          gender: Gender.male,
        );

        final (targetHr, maxSafeHr) = HealthTrainingPersonalizationService.calculateSafeHeartRateZone(athlete, 80);

        expect(targetHr, greaterThan(0));
        expect(maxSafeHr, greaterThan(targetHr));
        expect(targetHr, lessThan(200)); // Should be reasonable
      });

      test('Returns safe HR zone for older athlete', () {
        final athlete = AthleteProfile(
          id: 'test_old',
          ftp: 200,
          powerZones: PowerZones.fromFtp(200),
          birthDate: DateTime(1960, 1, 1), // 64-65 years old
          gender: Gender.female,
        );

        final (targetHr, maxSafeHr) = HealthTrainingPersonalizationService.calculateSafeHeartRateZone(athlete, 80);

        // Gulati: max HR ≈ 150, 80% = 120 (targetHr)
        // Age factor 0.75 = 75% of max = 112 (maxSafeHr)
        // For older athletes, maxSafeHr may be less than targetHr (safety limit)
        expect(targetHr, greaterThan(100));
        expect(maxSafeHr, greaterThan(100));
        // Both should be reasonable values
        expect(maxSafeHr, lessThan(130));
        expect(targetHr, lessThan(150));
      });

      test('Respects athlete maxHr if provided', () {
        final athlete = AthleteProfile(
          id: 'test_custom',
          ftp: 200,
          powerZones: PowerZones.fromFtp(200),
          birthDate: DateTime(1990, 1, 1),
          maxHr: 170, // Custom max HR
        );

        final (targetHr, maxSafeHr) = HealthTrainingPersonalizationService.calculateSafeHeartRateZone(athlete, 75);

        // Should use provided maxHr (170)
        expect(targetHr, lessThanOrEqualTo(170));
        expect(maxSafeHr, lessThanOrEqualTo(170));
      });
    });

    group('getSafetyLimits', () {
      test('Returns appropriate safety limits for age < 40', () {
        final athlete = AthleteProfile(
          id: 'test_young',
          ftp: 250,
          powerZones: PowerZones.fromFtp(250),
          birthDate: DateTime(2000, 1, 1),
        );

        final limits = HealthTrainingPersonalizationService.getSafetyLimits(athlete);

        expect(limits.maxHrPercent, 90);
        expect(limits.autoPauseHrPercent, 95);
        expect(limits.requiresHrMonitor, false);
      });

      test('Returns appropriate safety limits for age 50-60', () {
        final athlete = AthleteProfile(
          id: 'test_mid',
          ftp: 200,
          powerZones: PowerZones.fromFtp(200),
          birthDate: DateTime(1970, 6, 15), // ~54 years (firmly in 50-60 range)
        );

        final limits = HealthTrainingPersonalizationService.getSafetyLimits(athlete);

        expect(limits.maxHrPercent, 80);
        expect(limits.autoPauseHrPercent, 85);
        expect(limits.requiresHrMonitor, true);
      });

      test('Returns appropriate safety limits for age 70+', () {
        final athlete = AthleteProfile(
          id: 'test_senior',
          ftp: 150,
          powerZones: PowerZones.fromFtp(150),
          birthDate: DateTime(1950, 1, 1), // ~74 years
        );

        final limits = HealthTrainingPersonalizationService.getSafetyLimits(athlete);

        expect(limits.maxHrPercent, 70);
        expect(limits.autoPauseHrPercent, 75);
        expect(limits.requiresHrMonitor, true);
        expect(limits.stopConditions.length, greaterThan(5));
      });
    });

    group('calculateWarmupDuration', () {
      test('Young athlete needs short warmup', () {
        expect(HealthTrainingPersonalizationService.calculateWarmupDuration(25).inMinutes, 5);
      });

      test('Middle-aged athlete needs moderate warmup', () {
        expect(HealthTrainingPersonalizationService.calculateWarmupDuration(45).inMinutes, 7);
      });

      test('Older athlete needs long warmup', () {
        expect(HealthTrainingPersonalizationService.calculateWarmupDuration(65).inMinutes, 12);
        expect(HealthTrainingPersonalizationService.calculateWarmupDuration(75).inMinutes, 15);
      });
    });

    group('calculateCooldownDuration', () {
      test('Young athlete needs short cooldown', () {
        expect(HealthTrainingPersonalizationService.calculateCooldownDuration(25).inMinutes, 5);
      });

      test('Older athlete needs long cooldown', () {
        expect(HealthTrainingPersonalizationService.calculateCooldownDuration(65).inMinutes, 12);
        expect(HealthTrainingPersonalizationService.calculateCooldownDuration(75).inMinutes, 15);
      });
    });

    group('calculateRecoveryDuration', () {
      test('Recovery duration increases with age', () {
        final baseDuration = const Duration(minutes: 2);

        final recovery25 = HealthTrainingPersonalizationService.calculateRecoveryDuration(baseDuration, 25);
        expect(recovery25.inSeconds, equals(120)); // 1× base (< 40)

        final recovery45 = HealthTrainingPersonalizationService.calculateRecoveryDuration(baseDuration, 45);
        expect(recovery45.inSeconds, equals(144)); // 1.2× base (40-49)

        final recovery50 = HealthTrainingPersonalizationService.calculateRecoveryDuration(baseDuration, 50);
        expect(recovery50.inSeconds, equals(168)); // 1.4× base (50-59)

        final recovery65 = HealthTrainingPersonalizationService.calculateRecoveryDuration(baseDuration, 65);
        expect(recovery65.inSeconds, equals(192)); // 1.6× base (60-69)

        // Older athletes get more recovery time
        expect(recovery65.inSeconds, greaterThan(recovery50.inSeconds));
        expect(recovery50.inSeconds, greaterThan(recovery45.inSeconds));
        expect(recovery45.inSeconds, greaterThan(recovery25.inSeconds));
      });
    });

    group('isProgramSuitableForAthlete', () {
      test('Program suitable for athlete within age range', () {
        final athlete = AthleteProfile(
          id: 'test',
          ftp: 200,
          powerZones: PowerZones.fromFtp(200),
          birthDate: DateTime(1980, 1, 1), // ~44 years
        );

        final suitable = HealthTrainingPersonalizationService.isProgramSuitableForAthlete(
          athlete,
          40, // Min age
          50, // Max age
          false, // No HR monitor required
        );

        expect(suitable, true);
      });

      test('Program not suitable for athlete below min age', () {
        final athlete = AthleteProfile(
          id: 'test_young',
          ftp: 250,
          powerZones: PowerZones.fromFtp(250),
          birthDate: DateTime(2005, 1, 1), // ~19 years
        );

        final suitable = HealthTrainingPersonalizationService.isProgramSuitableForAthlete(
          athlete,
          30, // Min age
          null, // No max age
          false,
        );

        expect(suitable, false);
      });

      test('Program not suitable for athlete above max age', () {
        final athlete = AthleteProfile(
          id: 'test_old',
          ftp: 180,
          powerZones: PowerZones.fromFtp(180),
          birthDate: DateTime(1945, 1, 1), // ~79 years
        );

        final suitable = HealthTrainingPersonalizationService.isProgramSuitableForAthlete(
          athlete,
          40,
          70, // Max age
          false,
        );

        expect(suitable, false);
      });

      test('Returns false when athlete age unknown', () {
        final athlete = AthleteProfile(
          id: 'test_no_age',
          ftp: 200,
          powerZones: PowerZones.fromFtp(200),
        );

        final suitable = HealthTrainingPersonalizationService.isProgramSuitableForAthlete(
          athlete,
          40,
          60,
          false,
        );

        expect(suitable, false);
      });
    });

    group('summarizePersonalization', () {
      test('Creates valid personalization summary for athlete', () {
        final athlete = AthleteProfile(
          id: 'test_summary',
          ftp: 250,
          powerZones: PowerZones.fromFtp(250),
          birthDate: DateTime(1990, 6, 15),
          gender: Gender.male,
        );

        final summary = HealthTrainingPersonalizationService.summarizePersonalization(athlete);

        expect(summary.age, greaterThan(30));
        expect(summary.maxHeartRate, greaterThan(0));
        expect(summary.ageFactor, greaterThan(0.6));
        expect(summary.ageFactor, lessThanOrEqualTo(0.95));
        expect(summary.maxSafePercent, greaterThan(60));
        expect(summary.maxSafePercent, lessThanOrEqualTo(95));
        expect(summary.safetyLimits, isNotNull);
        expect(summary.warmupDuration.inMinutes, greaterThan(0));
        expect(summary.cooldownDuration.inMinutes, greaterThan(0));
      });

      test('Summary uses fallback age when not provided', () {
        final athlete = AthleteProfile(
          id: 'test_no_date',
          ftp: 200,
          powerZones: PowerZones.fromFtp(200),
        );

        final summary = HealthTrainingPersonalizationService.summarizePersonalization(athlete);

        // Should use default age of 45
        expect(summary.age, 45);
      });
    });
  });
}
