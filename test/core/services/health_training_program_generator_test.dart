import 'package:flutter_test/flutter_test.dart';
import 'package:kickr_trainer/core/services/health_training_program_generator.dart';
import 'package:kickr_trainer/domain/entities/athlete_profile.dart';
import 'package:kickr_trainer/domain/entities/workout.dart';

void main() {
  /// Helper to create an athlete with a specific age.
  AthleteProfile athleteWithAge(int age, {int ftp = 200}) {
    return AthleteProfile.defaultProfile().copyWith(
      birthDate: DateTime.now().subtract(Duration(days: age * 365 + age ~/ 4)),
      ftp: ftp,
      powerZones: PowerZones.fromFtp(ftp),
    );
  }

  group('HealthTrainingProgramGenerator', () {
    group('generateAllPrograms', () {
      test('returns 6 programs for athlete under 60', () {
        final athlete = athleteWithAge(45);
        final programs = HealthTrainingProgramGenerator.generateAllPrograms(athlete);

        expect(programs, hasLength(6));
      });

      test('returns 5 programs for athlete aged 60 or older', () {
        final athlete = athleteWithAge(65);
        final programs = HealthTrainingProgramGenerator.generateAllPrograms(athlete);

        expect(programs, hasLength(5));
      });

      test('each program has valid id, name, and description', () {
        final athlete = athleteWithAge(40);
        final programs = HealthTrainingProgramGenerator.generateAllPrograms(athlete);

        for (final program in programs) {
          expect(program.id, isNotEmpty);
          expect(program.name, isNotEmpty);
          expect(program.description, isNotEmpty);
        }
      });

      test('each program has at least warmup and cooldown intervals', () {
        final athlete = athleteWithAge(40);
        final programs = HealthTrainingProgramGenerator.generateAllPrograms(athlete);

        for (final program in programs) {
          final hasWarmup = program.intervals.any(
            (i) => i.type == IntervalType.warmup,
          );
          final hasCooldown = program.intervals.any(
            (i) => i.type == IntervalType.cooldown,
          );
          expect(hasWarmup, isTrue,
              reason: '${program.name} should have a warmup interval');
          expect(hasCooldown, isTrue,
              reason: '${program.name} should have a cooldown interval');
        }
      });
    });

    group('generateBaselineAssessment', () {
      test('creates workout with warmup + 5 stages + cooldown', () {
        final athlete = athleteWithAge(45);
        final workout =
            HealthTrainingProgramGenerator.generateBaselineAssessment(athlete);

        // 1 warmup + 5 stages + 1 cooldown = 7 intervals
        expect(workout.intervals, hasLength(7));
        expect(workout.intervals.first.type, IntervalType.warmup);
        expect(workout.intervals.last.type, IntervalType.cooldown);

        // 5 work stages in between
        final workIntervals =
            workout.intervals.where((i) => i.type == IntervalType.work);
        expect(workIntervals, hasLength(5));
      });

      test('has valid id and name', () {
        final athlete = athleteWithAge(45);
        final workout =
            HealthTrainingProgramGenerator.generateBaselineAssessment(athlete);

        expect(workout.id, contains('baseline'));
        expect(workout.name, isNotEmpty);
        expect(workout.description, isNotEmpty);
      });
    });

    group('generateCardiacRehabIntervals', () {
      test('has warmup + 4x(work+recovery) + cooldown', () {
        final athlete = athleteWithAge(55);
        final workout =
            HealthTrainingProgramGenerator.generateCardiacRehabIntervals(
                athlete);

        // 1 warmup + 4*(work+recovery) + 1 cooldown = 10 intervals
        expect(workout.intervals, hasLength(10));
        expect(workout.intervals.first.type, IntervalType.warmup);
        expect(workout.intervals.last.type, IntervalType.cooldown);

        final workIntervals =
            workout.intervals.where((i) => i.type == IntervalType.work);
        expect(workIntervals, hasLength(4));

        final restIntervals =
            workout.intervals.where((i) => i.type == IntervalType.rest);
        expect(restIntervals, hasLength(4));
      });
    });

    group('generateMorningWakeup', () {
      test('has 5 intervals totaling 10 minutes', () {
        final athlete = athleteWithAge(45);
        final workout =
            HealthTrainingProgramGenerator.generateMorningWakeup(athlete);

        // 1 warmup + 3 work + 1 cooldown = 5 intervals
        expect(workout.intervals, hasLength(5));

        final totalMinutes = workout.totalDuration.inMinutes;
        expect(totalMinutes, 10);
      });

      test('has warmup and cooldown', () {
        final athlete = athleteWithAge(45);
        final workout =
            HealthTrainingProgramGenerator.generateMorningWakeup(athlete);

        expect(workout.intervals.first.type, IntervalType.warmup);
        expect(workout.intervals.last.type, IntervalType.cooldown);
      });
    });

    group('generateProgressiveStressTest', () {
      test('returns null for athlete aged 60 or older', () {
        final athlete = athleteWithAge(65);
        final workout =
            HealthTrainingProgramGenerator.generateProgressiveStressTest(
                athlete);

        expect(workout, isNull);
      });

      test('returns null for athlete with no birthDate', () {
        final athlete = AthleteProfile.defaultProfile();
        final workout =
            HealthTrainingProgramGenerator.generateProgressiveStressTest(
                athlete);

        expect(workout, isNull);
      });

      test('returns workout for athlete under 60', () {
        final athlete = athleteWithAge(45);
        final workout =
            HealthTrainingProgramGenerator.generateProgressiveStressTest(
                athlete);

        expect(workout, isNotNull);
        expect(workout!.id, contains('stress_test'));
        expect(workout.intervals.first.type, IntervalType.warmup);
        expect(workout.intervals.last.type, IntervalType.cooldown);
      });
    });

    group('recommendProgram', () {
      test('returns cardiac_rehab for athlete aged 50 or older', () {
        final athlete = athleteWithAge(55);
        final recommended =
            HealthTrainingProgramGenerator.recommendProgram(athlete);

        expect(recommended.id, contains('cardiac_rehab'));
      });

      test('returns endurance for general case (age < 50, moderate FTP)', () {
        final athlete = athleteWithAge(35, ftp: 200);
        final recommended =
            HealthTrainingProgramGenerator.recommendProgram(athlete);

        expect(recommended.id, contains('endurance'));
      });

      test('returns stress_test for young active athlete (age < 50, FTP > 250)', () {
        final athlete = athleteWithAge(30, ftp: 280);
        final recommended =
            HealthTrainingProgramGenerator.recommendProgram(athlete);

        expect(recommended.id, contains('stress_test'));
      });
    });
  });
}
