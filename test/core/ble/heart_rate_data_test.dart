import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:kickr_trainer/core/ble/heart_rate_service.dart';

void main() {
  group('HeartRateData', () {
    test('creation with required fields uses correct defaults', () {
      final now = DateTime.now();
      final data = HeartRateData(
        heartRate: 72,
        timestamp: now,
      );

      expect(data.heartRate, 72);
      expect(data.sensorContact, true);
      expect(data.energyExpended, isNull);
      expect(data.rrIntervals, isNull);
      expect(data.timestamp, now);
    });

    test('creation with all fields', () {
      final now = DateTime.now();
      final data = HeartRateData(
        heartRate: 150,
        sensorContact: false,
        energyExpended: 250,
        rrIntervals: [800, 810],
        timestamp: now,
      );

      expect(data.heartRate, 150);
      expect(data.sensorContact, false);
      expect(data.energyExpended, 250);
      expect(data.rrIntervals, [800, 810]);
    });

    group('HRV calculation', () {
      test('computes correct RMSSD from known RR intervals', () {
        final data = HeartRateData(
          heartRate: 75,
          rrIntervals: [800, 810, 795, 805],
          timestamp: DateTime.now(),
        );

        // Successive differences: (810-800)=10, (795-810)=-15, (805-795)=10
        // Squared: 100, 225, 100
        // Mean: (100 + 225 + 100) / 3 = 141.6667
        // RMSSD: sqrt(141.6667) ≈ 11.9024
        final expectedRmssd = math.sqrt((100 + 225 + 100) / 3);

        expect(data.hrv, isNotNull);
        expect(data.hrv!, closeTo(expectedRmssd, 0.01));
      });

      test('computes RMSSD with exactly 2 RR intervals', () {
        final data = HeartRateData(
          heartRate: 70,
          rrIntervals: [800, 820],
          timestamp: DateTime.now(),
        );

        // Successive differences: (820-800)=20
        // Squared: 400
        // Mean: 400 / 1 = 400
        // RMSSD: sqrt(400) = 20.0
        expect(data.hrv, isNotNull);
        expect(data.hrv!, closeTo(20.0, 0.01));
      });

      test('returns null with fewer than 2 RR intervals', () {
        final data = HeartRateData(
          heartRate: 70,
          rrIntervals: [800],
          timestamp: DateTime.now(),
        );

        expect(data.hrv, isNull);
      });

      test('returns null with empty RR intervals', () {
        final data = HeartRateData(
          heartRate: 70,
          rrIntervals: [],
          timestamp: DateTime.now(),
        );

        expect(data.hrv, isNull);
      });

      test('returns null when rrIntervals is null', () {
        final data = HeartRateData(
          heartRate: 70,
          timestamp: DateTime.now(),
        );

        expect(data.hrv, isNull);
      });
    });

    test('toString() returns expected format', () {
      final data = HeartRateData(
        heartRate: 142,
        sensorContact: true,
        timestamp: DateTime.now(),
      );

      expect(data.toString(), 'HeartRateData(hr: 142, contact: true)');
    });

    test('toString() with sensorContact false', () {
      final data = HeartRateData(
        heartRate: 0,
        sensorContact: false,
        timestamp: DateTime.now(),
      );

      expect(data.toString(), 'HeartRateData(hr: 0, contact: false)');
    });
  });

  group('KnownHeartRateMonitors', () {
    test('recognizes Polar H10', () {
      expect(KnownHeartRateMonitors.isKnownHrMonitor('Polar H10'), isTrue);
    });

    test('recognizes Garmin HRM', () {
      expect(KnownHeartRateMonitors.isKnownHrMonitor('Garmin HRM'), isTrue);
    });

    test('recognizes TICKR (case-insensitive)', () {
      expect(KnownHeartRateMonitors.isKnownHrMonitor('TICKR'), isTrue);
    });

    test('recognizes Coospo H808S', () {
      expect(KnownHeartRateMonitors.isKnownHrMonitor('Coospo H808S'), isTrue);
    });

    test('recognizes Wahoo device', () {
      expect(KnownHeartRateMonitors.isKnownHrMonitor('Wahoo HRM'), isTrue);
    });

    test('recognizes Polar H9', () {
      expect(KnownHeartRateMonitors.isKnownHrMonitor('Polar H9'), isTrue);
    });

    test('recognizes Magene HR monitor', () {
      expect(KnownHeartRateMonitors.isKnownHrMonitor('Magene H303'), isTrue);
    });

    test('rejects Unknown Device', () {
      expect(
          KnownHeartRateMonitors.isKnownHrMonitor('Unknown Device'), isFalse);
    });

    test('rejects Kickr Core (not an HR monitor)', () {
      expect(KnownHeartRateMonitors.isKnownHrMonitor('Kickr Core'), isFalse);
    });

    test('rejects empty string', () {
      expect(KnownHeartRateMonitors.isKnownHrMonitor(''), isFalse);
    });

    test('matching is case-insensitive', () {
      expect(KnownHeartRateMonitors.isKnownHrMonitor('POLAR H10'), isTrue);
      expect(KnownHeartRateMonitors.isKnownHrMonitor('polar h10'), isTrue);
      expect(KnownHeartRateMonitors.isKnownHrMonitor('Polar H10'), isTrue);
    });
  });
}
