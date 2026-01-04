import 'package:flutter_test/flutter_test.dart';
import 'package:kickr_trainer/domain/entities/training_session.dart';

void main() {
  group('SessionStats', () {
    group('fromDataPoints', () {
      test('should return zero stats for empty data points', () {
        final stats = SessionStats.fromDataPoints([], ftp: 200);

        expect(stats.duration, Duration.zero);
        expect(stats.avgPower, 0);
        expect(stats.maxPower, 0);
        expect(stats.normalizedPower, 0);
        expect(stats.intensityFactor, 0);
        expect(stats.tss, 0);
        expect(stats.totalWork, 0);
      });

      test('should calculate correct average power', () {
        final points = [
          DataPoint(timestamp: 0, power: 100),
          DataPoint(timestamp: 1000, power: 150),
          DataPoint(timestamp: 2000, power: 200),
          DataPoint(timestamp: 3000, power: 150),
          DataPoint(timestamp: 4000, power: 100),
        ];

        final stats = SessionStats.fromDataPoints(points, ftp: 200);

        // Average: (100 + 150 + 200 + 150 + 100) / 5 = 140
        expect(stats.avgPower, 140);
      });

      test('should calculate correct max power', () {
        final points = [
          DataPoint(timestamp: 0, power: 100),
          DataPoint(timestamp: 1000, power: 350),
          DataPoint(timestamp: 2000, power: 200),
        ];

        final stats = SessionStats.fromDataPoints(points, ftp: 200);

        expect(stats.maxPower, 350);
      });

      test('should calculate correct duration from last timestamp', () {
        final points = [
          DataPoint(timestamp: 0, power: 100),
          DataPoint(timestamp: 60000, power: 100), // 60 seconds
        ];

        final stats = SessionStats.fromDataPoints(points, ftp: 200);

        expect(stats.duration, const Duration(milliseconds: 60000));
        expect(stats.duration.inSeconds, 60);
      });

      test('should calculate total work in kilojoules', () {
        final points = [
          DataPoint(timestamp: 0, power: 200),
          DataPoint(timestamp: 3600000, power: 200), // 1 hour at 200W
        ];

        final stats = SessionStats.fromDataPoints(points, ftp: 200);

        // 200W * 3600s / 1000 = 720 kJ
        expect(stats.totalWork, 720);
      });

      test('should calculate average cadence from non-null values', () {
        final points = [
          DataPoint(timestamp: 0, power: 100, cadence: 80),
          DataPoint(timestamp: 1000, power: 100, cadence: 90),
          DataPoint(timestamp: 2000, power: 100, cadence: null),
          DataPoint(timestamp: 3000, power: 100, cadence: 100),
        ];

        final stats = SessionStats.fromDataPoints(points, ftp: 200);

        // Average: (80 + 90 + 100) / 3 = 90
        expect(stats.avgCadence, 90);
      });

      test('should return null avgCadence when all cadence values are null', () {
        final points = [
          DataPoint(timestamp: 0, power: 100, cadence: null),
          DataPoint(timestamp: 1000, power: 100, cadence: null),
        ];

        final stats = SessionStats.fromDataPoints(points, ftp: 200);

        expect(stats.avgCadence, isNull);
      });

      test('should calculate max cadence', () {
        final points = [
          DataPoint(timestamp: 0, power: 100, cadence: 80),
          DataPoint(timestamp: 1000, power: 100, cadence: 110),
          DataPoint(timestamp: 2000, power: 100, cadence: 95),
        ];

        final stats = SessionStats.fromDataPoints(points, ftp: 200);

        expect(stats.maxCadence, 110);
      });

      test('should calculate average heart rate from non-null values', () {
        final points = [
          DataPoint(timestamp: 0, power: 100, heartRate: 120),
          DataPoint(timestamp: 1000, power: 100, heartRate: 130),
          DataPoint(timestamp: 2000, power: 100, heartRate: 140),
        ];

        final stats = SessionStats.fromDataPoints(points, ftp: 200);

        // Average: (120 + 130 + 140) / 3 = 130
        expect(stats.avgHeartRate, 130);
      });

      test('should calculate max heart rate', () {
        final points = [
          DataPoint(timestamp: 0, power: 100, heartRate: 120),
          DataPoint(timestamp: 1000, power: 100, heartRate: 175),
          DataPoint(timestamp: 2000, power: 100, heartRate: 160),
        ];

        final stats = SessionStats.fromDataPoints(points, ftp: 200);

        expect(stats.maxHeartRate, 175);
      });

      test('should calculate distance in kilometers', () {
        final points = [
          DataPoint(timestamp: 0, power: 100, distance: 0),
          DataPoint(timestamp: 60000, power: 100, distance: 5000), // 5000 meters
        ];

        final stats = SessionStats.fromDataPoints(points, ftp: 200);

        expect(stats.distance, 5.0); // 5 km
      });

      test('should return null distance when last point has no distance', () {
        final points = [
          DataPoint(timestamp: 0, power: 100, distance: null),
          DataPoint(timestamp: 60000, power: 100, distance: null),
        ];

        final stats = SessionStats.fromDataPoints(points, ftp: 200);

        expect(stats.distance, isNull);
      });

      test('should calculate calories from total work', () {
        final points = [
          DataPoint(timestamp: 0, power: 200),
          DataPoint(timestamp: 3600000, power: 200), // 1 hour at 200W = 720 kJ
        ];

        final stats = SessionStats.fromDataPoints(points, ftp: 200);

        // Calories = totalWork * 1.1 = 720 * 1.1 = 792
        expect(stats.calories, 792);
      });
    });

    group('normalizedPower calculation', () {
      test('should use simple average for less than 30 data points', () {
        final points = List.generate(
          10,
          (i) => DataPoint(timestamp: i * 1000, power: 200),
        );

        final stats = SessionStats.fromDataPoints(points, ftp: 200);

        // With less than 30 points, NP = simple average = 200
        expect(stats.normalizedPower, 200);
      });

      test('should calculate rolling average for 30+ data points', () {
        // Create 60 data points with constant power
        final points = List.generate(
          60,
          (i) => DataPoint(timestamp: i * 1000, power: 200),
        );

        final stats = SessionStats.fromDataPoints(points, ftp: 200);

        // With constant power, NP should equal the power value
        expect(stats.normalizedPower, 200);
      });

      test('should calculate higher NP for variable power (variability index)', () {
        // Create data with blocks of different power to create variability
        // First 30 seconds at 100W, then 30 seconds at 300W
        final points = List.generate(60, (i) {
          return DataPoint(
            timestamp: i * 1000,
            power: i < 30 ? 100 : 300,
          );
        });

        final stats = SessionStats.fromDataPoints(points, ftp: 200);

        // Average is 200, but NP should be higher due to the 4th power weighting
        expect(stats.avgPower, 200);
        // With blocks, the rolling averages will vary and 4th power will boost NP
        // NP will be between 200 and 300 (closer to the higher power values)
        expect(stats.normalizedPower, greaterThanOrEqualTo(200));
      });
    });

    group('TSS calculation', () {
      test('should return 0 TSS when FTP is 0', () {
        final points = [
          DataPoint(timestamp: 0, power: 200),
          DataPoint(timestamp: 3600000, power: 200),
        ];

        final stats = SessionStats.fromDataPoints(points, ftp: 0);

        expect(stats.tss, 0);
      });

      test('should calculate ~100 TSS for 1 hour at FTP', () {
        // 1 hour at exactly FTP should be ~100 TSS
        final points = List.generate(
          3600,
          (i) => DataPoint(timestamp: i * 1000, power: 200),
        );

        final stats = SessionStats.fromDataPoints(points, ftp: 200);

        // TSS = hours * IF^2 * 100 = 1 * 1^2 * 100 = 100
        // Due to rolling average calculation, it might be slightly different
        expect(stats.tss, closeTo(100, 5));
      });

      test('should calculate correct intensity factor', () {
        final points = List.generate(
          60,
          (i) => DataPoint(timestamp: i * 1000, power: 200),
        );

        final stats = SessionStats.fromDataPoints(points, ftp: 200);

        // IF = NP / FTP = 200 / 200 = 1.0
        expect(stats.intensityFactor, closeTo(1.0, 0.01));
      });
    });

    group('JSON serialization', () {
      test('should serialize to JSON correctly', () {
        const stats = SessionStats(
          duration: Duration(minutes: 30),
          avgPower: 180,
          maxPower: 250,
          normalizedPower: 190,
          intensityFactor: 0.95,
          tss: 48,
          totalWork: 324,
          avgCadence: 85,
          maxCadence: 110,
          avgHeartRate: 145,
          maxHeartRate: 172,
          calories: 356,
          distance: 15.5,
        );

        final json = stats.toJson();

        expect(json['duration'], 1800000); // 30 minutes in ms
        expect(json['avgPower'], 180);
        expect(json['maxPower'], 250);
        expect(json['normalizedPower'], 190);
        expect(json['intensityFactor'], 0.95);
        expect(json['tss'], 48);
        expect(json['totalWork'], 324);
        expect(json['avgCadence'], 85);
        expect(json['maxCadence'], 110);
        expect(json['avgHeartRate'], 145);
        expect(json['maxHeartRate'], 172);
        expect(json['calories'], 356);
        expect(json['distance'], 15.5);
      });
    });

    group('Equatable', () {
      test('should be equal for same values', () {
        const stats1 = SessionStats(
          duration: Duration(minutes: 30),
          avgPower: 180,
          maxPower: 250,
          normalizedPower: 190,
          intensityFactor: 0.95,
          tss: 48,
          totalWork: 324,
        );

        const stats2 = SessionStats(
          duration: Duration(minutes: 30),
          avgPower: 180,
          maxPower: 250,
          normalizedPower: 190,
          intensityFactor: 0.95,
          tss: 48,
          totalWork: 324,
        );

        expect(stats1, equals(stats2));
      });
    });
  });

  group('DataPoint', () {
    test('should create DataPoint with required fields', () {
      final point = DataPoint(timestamp: 1000, power: 200);

      expect(point.timestamp, 1000);
      expect(point.power, 200);
      expect(point.cadence, isNull);
      expect(point.heartRate, isNull);
    });

    test('should create DataPoint with all fields', () {
      final point = DataPoint(
        timestamp: 1000,
        power: 200,
        cadence: 90,
        heartRate: 150,
        speed: 35.5,
        distance: 1000,
        grade: 5.0,
        targetPower: 210,
      );

      expect(point.timestamp, 1000);
      expect(point.power, 200);
      expect(point.cadence, 90);
      expect(point.heartRate, 150);
      expect(point.speed, 35.5);
      expect(point.distance, 1000);
      expect(point.grade, 5.0);
      expect(point.targetPower, 210);
    });

    test('should serialize to JSON correctly', () {
      final point = DataPoint(
        timestamp: 1000,
        power: 200,
        cadence: 90,
        heartRate: 150,
      );

      final json = point.toJson();

      expect(json['timestamp'], 1000);
      expect(json['power'], 200);
      expect(json['cadence'], 90);
      expect(json['heartRate'], 150);
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'timestamp': 1000,
        'power': 200,
        'cadence': 90,
        'heartRate': 150,
        'speed': null,
        'distance': null,
        'grade': null,
        'targetPower': null,
      };

      final point = DataPoint.fromJson(json);

      expect(point.timestamp, 1000);
      expect(point.power, 200);
      expect(point.cadence, 90);
      expect(point.heartRate, 150);
    });
  });
}
