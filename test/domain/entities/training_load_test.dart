import 'package:flutter_test/flutter_test.dart';
import 'package:kickr_trainer/domain/entities/training_load.dart';

void main() {
  group('DailyTrainingLoad', () {
    group('formState', () {
      test('returns fresh when tsb > 25', () {
        final load = DailyTrainingLoad(
          date: DateTime(2026, 1, 1),
          tss: 0,
          ctl: 50,
          atl: 24,
          tsb: 26,
        );
        expect(load.formState, TrainingFormState.fresh);
      });

      test('returns rested when tsb > 5 and <= 25', () {
        final load = DailyTrainingLoad(
          date: DateTime(2026, 1, 1),
          tss: 0,
          ctl: 50,
          atl: 44,
          tsb: 6,
        );
        expect(load.formState, TrainingFormState.rested);
      });

      test('returns optimal when tsb > -10 and <= 5', () {
        final load = DailyTrainingLoad(
          date: DateTime(2026, 1, 1),
          tss: 0,
          ctl: 50,
          atl: 59,
          tsb: -9,
        );
        expect(load.formState, TrainingFormState.optimal);
      });

      test('returns tired when tsb > -25 and <= -10', () {
        final load = DailyTrainingLoad(
          date: DateTime(2026, 1, 1),
          tss: 0,
          ctl: 50,
          atl: 74,
          tsb: -24,
        );
        expect(load.formState, TrainingFormState.tired);
      });

      test('returns exhausted when tsb <= -25', () {
        final load = DailyTrainingLoad(
          date: DateTime(2026, 1, 1),
          tss: 0,
          ctl: 50,
          atl: 76,
          tsb: -26,
        );
        expect(load.formState, TrainingFormState.exhausted);
      });

      test('returns rested at boundary tsb = 25', () {
        final load = DailyTrainingLoad(
          date: DateTime(2026, 1, 1),
          tss: 0,
          ctl: 50,
          atl: 25,
          tsb: 25,
        );
        expect(load.formState, TrainingFormState.rested);
      });

      test('returns optimal at boundary tsb = 5', () {
        final load = DailyTrainingLoad(
          date: DateTime(2026, 1, 1),
          tss: 0,
          ctl: 50,
          atl: 45,
          tsb: 5,
        );
        expect(load.formState, TrainingFormState.optimal);
      });

      test('returns tired at boundary tsb = -10', () {
        final load = DailyTrainingLoad(
          date: DateTime(2026, 1, 1),
          tss: 0,
          ctl: 50,
          atl: 60,
          tsb: -10,
        );
        expect(load.formState, TrainingFormState.tired);
      });

      test('returns exhausted at boundary tsb = -25', () {
        final load = DailyTrainingLoad(
          date: DateTime(2026, 1, 1),
          tss: 0,
          ctl: 50,
          atl: 75,
          tsb: -25,
        );
        expect(load.formState, TrainingFormState.exhausted);
      });
    });

    group('recommendation', () {
      test('returns non-empty string for fresh state', () {
        final load = DailyTrainingLoad(
          date: DateTime(2026, 1, 1),
          tss: 0,
          ctl: 50,
          atl: 24,
          tsb: 26,
        );
        expect(load.recommendation, isNotEmpty);
      });

      test('returns non-empty string for rested state', () {
        final load = DailyTrainingLoad(
          date: DateTime(2026, 1, 1),
          tss: 0,
          ctl: 50,
          atl: 44,
          tsb: 6,
        );
        expect(load.recommendation, isNotEmpty);
      });

      test('returns non-empty string for optimal state', () {
        final load = DailyTrainingLoad(
          date: DateTime(2026, 1, 1),
          tss: 0,
          ctl: 50,
          atl: 51,
          tsb: -1,
        );
        expect(load.recommendation, isNotEmpty);
      });

      test('returns non-empty string for tired state', () {
        final load = DailyTrainingLoad(
          date: DateTime(2026, 1, 1),
          tss: 0,
          ctl: 50,
          atl: 74,
          tsb: -24,
        );
        expect(load.recommendation, isNotEmpty);
      });

      test('returns non-empty string for exhausted state', () {
        final load = DailyTrainingLoad(
          date: DateTime(2026, 1, 1),
          tss: 0,
          ctl: 50,
          atl: 80,
          tsb: -30,
        );
        expect(load.recommendation, isNotEmpty);
      });
    });

    group('toJson / fromJson', () {
      test('roundtrip preserves all fields', () {
        final original = DailyTrainingLoad(
          date: DateTime(2026, 2, 15),
          tss: 85,
          ctl: 42.5,
          atl: 55.3,
          tsb: -12.8,
        );

        final json = original.toJson();
        final restored = DailyTrainingLoad.fromJson(json);

        expect(restored.date, original.date);
        expect(restored.tss, original.tss);
        expect(restored.ctl, original.ctl);
        expect(restored.atl, original.atl);
        expect(restored.tsb, original.tsb);
      });

      test('fromJson parses numeric ctl/atl/tsb from int', () {
        final json = {
          'date': '2026-02-15T00:00:00.000',
          'tss': 50,
          'ctl': 40,
          'atl': 30,
          'tsb': 10,
        };
        final load = DailyTrainingLoad.fromJson(json);
        expect(load.ctl, 40.0);
        expect(load.atl, 30.0);
        expect(load.tsb, 10.0);
      });
    });

    group('equality', () {
      test('two instances with same values are equal', () {
        final a = DailyTrainingLoad(
          date: DateTime(2026, 1, 1),
          tss: 100,
          ctl: 50.0,
          atl: 60.0,
          tsb: -10.0,
        );
        final b = DailyTrainingLoad(
          date: DateTime(2026, 1, 1),
          tss: 100,
          ctl: 50.0,
          atl: 60.0,
          tsb: -10.0,
        );
        expect(a, equals(b));
      });

      test('two instances with different values are not equal', () {
        final a = DailyTrainingLoad(
          date: DateTime(2026, 1, 1),
          tss: 100,
          ctl: 50.0,
          atl: 60.0,
          tsb: -10.0,
        );
        final b = DailyTrainingLoad(
          date: DateTime(2026, 1, 2),
          tss: 100,
          ctl: 50.0,
          atl: 60.0,
          tsb: -10.0,
        );
        expect(a, isNot(equals(b)));
      });
    });
  });

  group('PerformanceManagementData', () {
    group('with empty history', () {
      test('currentCtl returns 0', () {
        const pmc = PerformanceManagementData(history: []);
        expect(pmc.currentCtl, 0);
      });

      test('currentAtl returns 0', () {
        const pmc = PerformanceManagementData(history: []);
        expect(pmc.currentAtl, 0);
      });

      test('currentTsb returns 0', () {
        const pmc = PerformanceManagementData(history: []);
        expect(pmc.currentTsb, 0);
      });

      test('peakCtl returns 0', () {
        const pmc = PerformanceManagementData(history: []);
        expect(pmc.peakCtl, 0);
      });

      test('fitnessTrend returns stable', () {
        const pmc = PerformanceManagementData(history: []);
        expect(pmc.fitnessTrend, FitnessTrend.stable);
      });

      test('weeklyTss returns 0', () {
        const pmc = PerformanceManagementData(history: []);
        expect(pmc.weeklyTss, 0);
      });

      test('avgDailyTss returns 0', () {
        const pmc = PerformanceManagementData(history: []);
        expect(pmc.avgDailyTss, 0);
      });
    });

    group('currentCtl', () {
      test('returns today ctl when today is set', () {
        final today = DailyTrainingLoad(
          date: DateTime.now(),
          tss: 80,
          ctl: 45.0,
          atl: 55.0,
          tsb: -10.0,
        );
        final history = [
          DailyTrainingLoad(
            date: DateTime.now().subtract(const Duration(days: 1)),
            tss: 60,
            ctl: 40.0,
            atl: 50.0,
            tsb: -10.0,
          ),
        ];
        final pmc = PerformanceManagementData(
          history: history,
          today: today,
        );
        expect(pmc.currentCtl, 45.0);
      });

      test('returns last history ctl when today is null', () {
        final history = [
          DailyTrainingLoad(
            date: DateTime.now().subtract(const Duration(days: 2)),
            tss: 50,
            ctl: 30.0,
            atl: 40.0,
            tsb: -10.0,
          ),
          DailyTrainingLoad(
            date: DateTime.now().subtract(const Duration(days: 1)),
            tss: 60,
            ctl: 35.0,
            atl: 45.0,
            tsb: -10.0,
          ),
        ];
        final pmc = PerformanceManagementData(history: history);
        expect(pmc.currentCtl, 35.0);
      });
    });

    group('fitnessTrend', () {
      test('returns stable when history has fewer than 7 entries', () {
        final history = List.generate(
          6,
          (i) => DailyTrainingLoad(
            date: DateTime.now().subtract(Duration(days: 6 - i)),
            tss: 50,
            ctl: 40.0 + i,
            atl: 50.0,
            tsb: -10.0 + i,
          ),
        );
        final pmc = PerformanceManagementData(history: history);
        expect(pmc.fitnessTrend, FitnessTrend.stable);
      });

      test('returns rising when last 7 days CTL increases by more than 2', () {
        final history = List.generate(
          10,
          (i) => DailyTrainingLoad(
            date: DateTime.now().subtract(Duration(days: 9 - i)),
            tss: 80,
            ctl: 30.0 + i * 1.0,
            atl: 50.0,
            tsb: -20.0,
          ),
        );
        final pmc = PerformanceManagementData(history: history);
        // Last 7 entries: indices 3-9, CTL 33..39, change = 6 > 2
        expect(pmc.fitnessTrend, FitnessTrend.rising);
      });

      test('returns falling when last 7 days CTL decreases by more than 2', () {
        final history = List.generate(
          10,
          (i) => DailyTrainingLoad(
            date: DateTime.now().subtract(Duration(days: 9 - i)),
            tss: 20,
            ctl: 50.0 - i * 1.0,
            atl: 30.0,
            tsb: 20.0,
          ),
        );
        final pmc = PerformanceManagementData(history: history);
        // Last 7 entries: indices 3-9, CTL 47..41, change = -6 < -2
        expect(pmc.fitnessTrend, FitnessTrend.falling);
      });

      test('returns stable when CTL change is within -2 to 2', () {
        final history = List.generate(
          10,
          (i) => DailyTrainingLoad(
            date: DateTime.now().subtract(Duration(days: 9 - i)),
            tss: 50,
            ctl: 40.0 + (i % 2 == 0 ? 0.5 : -0.5),
            atl: 50.0,
            tsb: -10.0,
          ),
        );
        final pmc = PerformanceManagementData(history: history);
        expect(pmc.fitnessTrend, FitnessTrend.stable);
      });
    });

    group('peakCtl', () {
      test('returns maximum CTL from history', () {
        final history = [
          DailyTrainingLoad(
            date: DateTime(2026, 1, 1),
            tss: 50,
            ctl: 30.0,
            atl: 40.0,
            tsb: -10.0,
          ),
          DailyTrainingLoad(
            date: DateTime(2026, 1, 2),
            tss: 100,
            ctl: 55.0,
            atl: 70.0,
            tsb: -15.0,
          ),
          DailyTrainingLoad(
            date: DateTime(2026, 1, 3),
            tss: 30,
            ctl: 45.0,
            atl: 50.0,
            tsb: -5.0,
          ),
        ];
        final pmc = PerformanceManagementData(history: history);
        expect(pmc.peakCtl, 55.0);
      });
    });
  });

  group('TssZones', () {
    group('zoneForTss', () {
      test('returns Recovery for tss < 50', () {
        expect(TssZones.zoneForTss(0), 'Recovery');
        expect(TssZones.zoneForTss(49), 'Recovery');
      });

      test('returns Endurance for tss 50-99', () {
        expect(TssZones.zoneForTss(50), 'Endurance');
        expect(TssZones.zoneForTss(99), 'Endurance');
      });

      test('returns Tempo for tss 100-149', () {
        expect(TssZones.zoneForTss(100), 'Tempo');
        expect(TssZones.zoneForTss(149), 'Tempo');
      });

      test('returns Threshold for tss 150-199', () {
        expect(TssZones.zoneForTss(150), 'Threshold');
        expect(TssZones.zoneForTss(199), 'Threshold');
      });

      test('returns Intense for tss 200-249', () {
        expect(TssZones.zoneForTss(200), 'Intense');
        expect(TssZones.zoneForTss(249), 'Intense');
      });

      test('returns Epic for tss >= 250', () {
        expect(TssZones.zoneForTss(250), 'Epic');
        expect(TssZones.zoneForTss(500), 'Epic');
      });
    });

    group('descriptionForTss', () {
      test('returns non-empty description for all zones', () {
        expect(TssZones.descriptionForTss(25), isNotEmpty);
        expect(TssZones.descriptionForTss(75), isNotEmpty);
        expect(TssZones.descriptionForTss(125), isNotEmpty);
        expect(TssZones.descriptionForTss(175), isNotEmpty);
        expect(TssZones.descriptionForTss(225), isNotEmpty);
        expect(TssZones.descriptionForTss(300), isNotEmpty);
      });
    });
  });
}
