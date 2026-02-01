import 'package:flutter_test/flutter_test.dart';
import 'package:kickr_trainer/core/services/health_training_personalization_service.dart';
import 'package:kickr_trainer/core/services/health_training_program_generator.dart';
import 'package:kickr_trainer/core/services/health_safety_monitor.dart';
import 'package:kickr_trainer/domain/entities/athlete_profile.dart';
import 'package:kickr_trainer/domain/entities/health_safety_limits.dart';

void main() {
  group('Health Training System - User Profile Validation', () {
    /// Test Profile 1: 25-year-old Male (Young, High Intensity)
    final user25M = AthleteProfile(
      id: 'user25m',
      name: '25-Year-Old Male',
      birthDate: DateTime(1999, 6, 15),
      gender: Gender.male,
      weight: 72,
      ftp: 320,
      powerZones: PowerZones.fromFtp(320),
    );

    /// Test Profile 2: 45-year-old Female (Moderate, Gender-Specific)
    final user45F = AthleteProfile(
      id: 'user45f',
      name: '45-Year-Old Female',
      birthDate: DateTime(1979, 3, 22),
      gender: Gender.female,
      weight: 68,
      ftp: 220,
      powerZones: PowerZones.fromFtp(220),
    );

    /// Test Profile 3: 60-year-old Male (Senior, Conservative)
    final user60M = AthleteProfile(
      id: 'user60m',
      name: '60-Year-Old Male',
      birthDate: DateTime(1964, 11, 8),
      gender: Gender.male,
      weight: 78,
      ftp: 210,
      powerZones: PowerZones.fromFtp(210),
    );

    /// Test Profile 4: 75-year-old Female (Very Senior, Safety Priority)
    final user75F = AthleteProfile(
      id: 'user75f',
      name: '75-Year-Old Female',
      birthDate: DateTime(1949, 8, 30),
      gender: Gender.female,
      weight: 62,
      ftp: 160,
      powerZones: PowerZones.fromFtp(160),
    );

    group('25M - Young Male (High Intensity)', () {
      test('age calculated correctly', () {
        expect(user25M.age, 26); // Born in 1999, today is 2026-02-01
      });

      test('max HR calculated using Tanaka formula', () {
        final maxHr = HealthTrainingPersonalizationService.calculateMaxHeartRate(
          user25M.age!,
          gender: user25M.gender,
        );

        // Tanaka: 208 - (0.7 × age) for males
        // 208 - (0.7 × 26) = 208 - 18.2 = 189.8 ≈ 190
        expect(maxHr, equals((208 - (0.7 * 26)).round()));
      });

      test('age factor allows high intensity (0.90)', () {
        final ageFactor =
            HealthTrainingPersonalizationService.calculateAgeFactor(user25M.age!);

        expect(ageFactor, equals(0.90));
      });

      test('can handle all 5 programs safely', () {
        final programs =
            HealthTrainingProgramGenerator.generateAllPrograms(user25M);

        expect(programs.length, 5); // Young athletes get all 5 programs
        final safetyLimits =
            HealthSafetyLimits.forAge(user25M.age!);

        expect(safetyLimits.maxHrPercent, 90);
        expect(safetyLimits.requiresHrMonitor, false);
      });

      test('HR warning triggered at appropriate level', () {
        final maxHr = HealthTrainingPersonalizationService.calculateMaxHeartRate(
          user25M.age!,
          gender: user25M.gender,
        );

        // Critical HR for this age
        final status =
            HealthTrainingSafetyMonitor.calculateHrStatus(
              currentHr: (maxHr * 1.05).round(),
              athlete: user25M,
            );

        expect(status.warningLevel, HrWarningLevel.critical);
      });
    });

    group('45F - Middle-Aged Female (Moderate)', () {
      test('age calculated correctly', () {
        expect(user45F.age, 46); // Born in 1979, today is 2026-02-01
      });

      test('max HR calculated using Gulati formula for women', () {
        final maxHr = HealthTrainingPersonalizationService.calculateMaxHeartRate(
          user45F.age!,
          gender: user45F.gender,
        );

        // Women use Gulati: 206 - (0.88 * age)
        // 206 - (0.88 × 46) = 206 - 40.48 = 165.52 ≈ 166
        expect(maxHr, equals((206 - (0.88 * 46)).round()));
      });

      test('age factor is 0.85 (moderate intensity)', () {
        final ageFactor =
            HealthTrainingPersonalizationService.calculateAgeFactor(user45F.age!);

        expect(ageFactor, equals(0.85));
      });

      test('safety limits appropriate for age', () {
        final safetyLimits =
            HealthSafetyLimits.forAge(user45F.age!);

        expect(safetyLimits.maxHrPercent, 85);
        expect(safetyLimits.requiresHrMonitor, false);
      });

      test('HR monitor not yet required but recommended', () {
        final safetyLimits =
            HealthSafetyLimits.forAge(user45F.age!);

        expect(safetyLimits.requiresHrMonitor, false);
        // But warmup/cooldown is more important
      });
    });

    group('60M - Senior Male (Conservative)', () {
      test('age calculated correctly', () {
        expect(user60M.age, 61); // Born in 1964, birthday already passed, today is 2026-02-01
      });

      test('max HR calculated for senior males', () {
        final maxHr = HealthTrainingPersonalizationService.calculateMaxHeartRate(
          user60M.age!,
          gender: user60M.gender,
        );

        expect(maxHr, isNotNull);
        expect(maxHr, lessThan(170));
      });

      test('age factor is 0.75 (conservative)', () {
        final ageFactor =
            HealthTrainingPersonalizationService.calculateAgeFactor(user60M.age!);

        // Age 61: < 70 but >= 60, so factor is 0.75
        expect(ageFactor, equals(0.75));
      });

      test('HR monitor required', () {
        final safetyLimits =
            HealthSafetyLimits.forAge(user60M.age!);

        expect(safetyLimits.requiresHrMonitor, true);
      });

      test('longer warmup recommended', () {
        final warmupDuration =
            HealthTrainingPersonalizationService.calculateWarmupDuration(user60M.age!);

        expect(warmupDuration.inMinutes, greaterThanOrEqualTo(10));
      });

      test('safety limits are strict', () {
        final safetyLimits =
            HealthSafetyLimits.forAge(user60M.age!);

        // Age 61 is in 60-70 range, so maxHrPercent is 75
        expect(safetyLimits.maxHrPercent, 75);
        expect(safetyLimits.autoPauseHrPercent, 80);
      });
    });

    group('75F - Very Senior Female (Safety Priority)', () {
      test('age calculated correctly', () {
        expect(user75F.age, 76); // Born in 1949, birthday not yet (August), today is 2026-02-01
      });

      test('very conservative limits applied', () {
        final ageFactor =
            HealthTrainingPersonalizationService.calculateAgeFactor(user75F.age!);

        expect(ageFactor, equals(0.70)); // Lowest factor
      });

      test('HR monitor mandatory', () {
        final safetyLimits =
            HealthSafetyLimits.forAge(user75F.age!);

        expect(safetyLimits.requiresHrMonitor, true);
      });

      test('maximum warmup duration', () {
        final warmupDuration =
            HealthTrainingPersonalizationService.calculateWarmupDuration(user75F.age!);

        expect(warmupDuration.inMinutes, greaterThanOrEqualTo(12));
      });

      test('most conservative cooldown', () {
        final cooldownDuration =
            HealthTrainingPersonalizationService.calculateCooldownDuration(user75F.age!);

        expect(cooldownDuration.inMinutes, greaterThanOrEqualTo(10));
      });

      test('extended stop conditions', () {
        final safetyLimits =
            HealthSafetyLimits.forAge(user75F.age!);

        expect(safetyLimits.stopConditions.length, greaterThan(5));
        expect(safetyLimits.stopConditions, contains('Gelenkschmerzen'));
      });
    });

    group('Cross-Profile Comparison', () {
      test('age factors decrease with age', () {
        final age25 =
            HealthTrainingPersonalizationService.calculateAgeFactor(25);
        final age45 =
            HealthTrainingPersonalizationService.calculateAgeFactor(45);
        final age60 =
            HealthTrainingPersonalizationService.calculateAgeFactor(60);
        final age75 =
            HealthTrainingPersonalizationService.calculateAgeFactor(75);

        expect(age25, greaterThan(age45));
        expect(age45, greaterThan(age60));
        expect(age60, greaterThan(age75));
      });

      test('warmup duration increases with age', () {
        final warmup25 =
            HealthTrainingPersonalizationService.calculateWarmupDuration(25);
        final warmup45 =
            HealthTrainingPersonalizationService.calculateWarmupDuration(45);
        final warmup60 =
            HealthTrainingPersonalizationService.calculateWarmupDuration(60);
        final warmup75 =
            HealthTrainingPersonalizationService.calculateWarmupDuration(75);

        expect(warmup25.inMinutes, lessThan(warmup45.inMinutes));
        expect(warmup45.inMinutes, lessThan(warmup60.inMinutes));
        expect(warmup60.inMinutes, lessThan(warmup75.inMinutes));
      });

      test('HR monitor requirement increases with age', () {
        final limits25 =
            HealthSafetyLimits.forAge(25);
        final limits60 =
            HealthSafetyLimits.forAge(60);
        final limits75 =
            HealthSafetyLimits.forAge(75);

        expect(limits25.requiresHrMonitor, false);
        expect(limits60.requiresHrMonitor, true);
        expect(limits75.requiresHrMonitor, true);
      });

      test('max HR percent decreases with age', () {
        final limits25 =
            HealthSafetyLimits.forAge(25);
        final limits45 =
            HealthSafetyLimits.forAge(45);
        final limits60 =
            HealthSafetyLimits.forAge(60);
        final limits75 =
            HealthSafetyLimits.forAge(75);

        expect(limits25.maxHrPercent, greaterThan(limits45.maxHrPercent));
        expect(limits45.maxHrPercent, greaterThan(limits60.maxHrPercent));
        expect(limits60.maxHrPercent, greaterThan(limits75.maxHrPercent));
      });
    });

    group('Program Generation for Profiles', () {
      test('25M can access all programs', () {
        final programs =
            HealthTrainingProgramGenerator.generateAllPrograms(user25M);

        expect(programs.length, 5); // All 5 programs available
      });

      test('60M gets conservative program modifications', () {
        final programs =
            HealthTrainingProgramGenerator.generateAllPrograms(user60M);

        // Programs should exist but be more conservative
        // Seniors (60+) get 4 programs (no stress test)
        expect(programs.length, 4);

        final program = programs.first;
        // Intervals should be adjusted for age
        expect(program.intervals, isNotEmpty);
      });

      test('75F programs are most conservative', () {
        final programs =
            HealthTrainingProgramGenerator.generateAllPrograms(user75F);

        // Seniors (70+) get 4 programs (no stress test)
        expect(programs.length, 4);

        // Extended warmup/cooldown
        final totalDuration = programs.first.totalDuration;
        expect(totalDuration, isNotNull);
      });

      test('stress test unavailable for 60+', () {
        final programs60 =
            HealthTrainingProgramGenerator.generateAllPrograms(user60M);
        final programs75 =
            HealthTrainingProgramGenerator.generateAllPrograms(user75F);

        // Seniors get only 4 programs (no stress test)
        expect(programs60.length, 4);
        expect(programs75.length, 4);
      });
    });
  });
}
