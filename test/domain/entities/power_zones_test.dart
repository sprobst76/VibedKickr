import 'package:flutter_test/flutter_test.dart';
import 'package:kickr_trainer/domain/entities/athlete_profile.dart';

void main() {
  group('PowerZones', () {
    group('fromFtp', () {
      test('should calculate correct zone boundaries for FTP 200', () {
        final zones = PowerZones.fromFtp(200);

        expect(zones.z1Max, 110); // 0.55 * 200
        expect(zones.z2Max, 150); // 0.75 * 200
        expect(zones.z3Max, 180); // 0.90 * 200
        expect(zones.z4Max, 210); // 1.05 * 200
        expect(zones.z5Max, 240); // 1.20 * 200
        expect(zones.z6Max, 300); // 1.50 * 200
      });

      test('should calculate correct zone boundaries for FTP 250', () {
        final zones = PowerZones.fromFtp(250);

        expect(zones.z1Max, 138); // 0.55 * 250 = 137.5 -> 138
        expect(zones.z2Max, 188); // 0.75 * 250 = 187.5 -> 188
        expect(zones.z3Max, 225); // 0.90 * 250
        expect(zones.z4Max, 263); // 1.05 * 250 = 262.5 -> 263
        expect(zones.z5Max, 300); // 1.20 * 250
        expect(zones.z6Max, 375); // 1.50 * 250
      });

      test('should handle FTP of 0', () {
        final zones = PowerZones.fromFtp(0);

        expect(zones.z1Max, 0);
        expect(zones.z2Max, 0);
        expect(zones.z3Max, 0);
        expect(zones.z4Max, 0);
        expect(zones.z5Max, 0);
        expect(zones.z6Max, 0);
      });
    });

    group('zoneForPower', () {
      late PowerZones zones;

      setUp(() {
        zones = PowerZones.fromFtp(200);
      });

      test('should return zone 1 for power <= z1Max', () {
        expect(zones.zoneForPower(0), 1);
        expect(zones.zoneForPower(50), 1);
        expect(zones.zoneForPower(110), 1);
      });

      test('should return zone 2 for power between z1Max and z2Max', () {
        expect(zones.zoneForPower(111), 2);
        expect(zones.zoneForPower(130), 2);
        expect(zones.zoneForPower(150), 2);
      });

      test('should return zone 3 for power between z2Max and z3Max', () {
        expect(zones.zoneForPower(151), 3);
        expect(zones.zoneForPower(165), 3);
        expect(zones.zoneForPower(180), 3);
      });

      test('should return zone 4 for power between z3Max and z4Max', () {
        expect(zones.zoneForPower(181), 4);
        expect(zones.zoneForPower(195), 4);
        expect(zones.zoneForPower(210), 4);
      });

      test('should return zone 5 for power between z4Max and z5Max', () {
        expect(zones.zoneForPower(211), 5);
        expect(zones.zoneForPower(225), 5);
        expect(zones.zoneForPower(240), 5);
      });

      test('should return zone 6 for power between z5Max and z6Max', () {
        expect(zones.zoneForPower(241), 6);
        expect(zones.zoneForPower(270), 6);
        expect(zones.zoneForPower(300), 6);
      });

      test('should return zone 7 for power above z6Max', () {
        expect(zones.zoneForPower(301), 7);
        expect(zones.zoneForPower(400), 7);
        expect(zones.zoneForPower(1000), 7);
      });

      test('should handle exact boundary values correctly', () {
        // Exact boundary should be in the lower zone
        expect(zones.zoneForPower(110), 1);
        expect(zones.zoneForPower(150), 2);
        expect(zones.zoneForPower(180), 3);
        expect(zones.zoneForPower(210), 4);
        expect(zones.zoneForPower(240), 5);
        expect(zones.zoneForPower(300), 6);
      });
    });

    group('boundsForZone', () {
      late PowerZones zones;

      setUp(() {
        zones = PowerZones.fromFtp(200);
      });

      test('should return correct bounds for zone 1', () {
        final (min, max) = zones.boundsForZone(1);
        expect(min, 0);
        expect(max, 110);
      });

      test('should return correct bounds for zone 2', () {
        final (min, max) = zones.boundsForZone(2);
        expect(min, 111);
        expect(max, 150);
      });

      test('should return correct bounds for zone 7', () {
        final (min, max) = zones.boundsForZone(7);
        expect(min, 301);
        expect(max, 9999);
      });

      test('should return (0, 0) for invalid zone', () {
        final (min, max) = zones.boundsForZone(0);
        expect(min, 0);
        expect(max, 0);

        final (min8, max8) = zones.boundsForZone(8);
        expect(min8, 0);
        expect(max8, 0);
      });
    });

    group('JSON serialization', () {
      test('should serialize to JSON correctly', () {
        final zones = PowerZones.fromFtp(200);
        final json = zones.toJson();

        expect(json['z1Max'], 110);
        expect(json['z2Max'], 150);
        expect(json['z3Max'], 180);
        expect(json['z4Max'], 210);
        expect(json['z5Max'], 240);
        expect(json['z6Max'], 300);
      });

      test('should deserialize from JSON correctly', () {
        final json = {
          'z1Max': 110,
          'z2Max': 150,
          'z3Max': 180,
          'z4Max': 210,
          'z5Max': 240,
          'z6Max': 300,
        };

        final zones = PowerZones.fromJson(json);

        expect(zones.z1Max, 110);
        expect(zones.z2Max, 150);
        expect(zones.z3Max, 180);
        expect(zones.z4Max, 210);
        expect(zones.z5Max, 240);
        expect(zones.z6Max, 300);
      });

      test('should maintain equality after round-trip', () {
        final original = PowerZones.fromFtp(200);
        final json = original.toJson();
        final restored = PowerZones.fromJson(json);

        expect(restored, equals(original));
      });
    });

    group('Equatable', () {
      test('should be equal for same values', () {
        final zones1 = PowerZones.fromFtp(200);
        final zones2 = PowerZones.fromFtp(200);

        expect(zones1, equals(zones2));
      });

      test('should not be equal for different values', () {
        final zones1 = PowerZones.fromFtp(200);
        final zones2 = PowerZones.fromFtp(250);

        expect(zones1, isNot(equals(zones2)));
      });
    });
  });
}
