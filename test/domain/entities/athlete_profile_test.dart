import 'package:flutter_test/flutter_test.dart';
import 'package:kickr_trainer/domain/entities/athlete_profile.dart';

void main() {
  group('HeartRateZones', () {
    group('fromMaxHr', () {
      test('should calculate correct zone boundaries for max HR 190', () {
        final zones = HeartRateZones.fromMaxHr(190);

        expect(zones.z1Max, 114); // 0.60 * 190
        expect(zones.z2Max, 133); // 0.70 * 190
        expect(zones.z3Max, 152); // 0.80 * 190
        expect(zones.z4Max, 171); // 0.90 * 190
        expect(zones.z5Max, 190); // max HR
      });
    });

    group('zoneForHr', () {
      late HeartRateZones zones;

      setUp(() {
        zones = HeartRateZones.fromMaxHr(190);
      });

      test('should return zone 1 for HR <= z1Max', () {
        expect(zones.zoneForHr(100), 1);
        expect(zones.zoneForHr(114), 1);
      });

      test('should return zone 2 for HR between z1Max and z2Max', () {
        expect(zones.zoneForHr(115), 2);
        expect(zones.zoneForHr(133), 2);
      });

      test('should return zone 3 for HR between z2Max and z3Max', () {
        expect(zones.zoneForHr(134), 3);
        expect(zones.zoneForHr(152), 3);
      });

      test('should return zone 4 for HR between z3Max and z4Max', () {
        expect(zones.zoneForHr(153), 4);
        expect(zones.zoneForHr(171), 4);
      });

      test('should return zone 5 for HR above z4Max', () {
        expect(zones.zoneForHr(172), 5);
        expect(zones.zoneForHr(190), 5);
        expect(zones.zoneForHr(200), 5);
      });
    });

    group('JSON serialization', () {
      test('should serialize and deserialize correctly', () {
        final original = HeartRateZones.fromMaxHr(190);
        final json = original.toJson();
        final restored = HeartRateZones.fromJson(json);

        expect(restored, equals(original));
      });
    });
  });

  group('AthleteProfile', () {
    group('defaultProfile', () {
      test('should create profile with FTP 200', () {
        final profile = AthleteProfile.defaultProfile();

        expect(profile.id, 'default');
        expect(profile.ftp, 200);
        expect(profile.powerZones, isNotNull);
        expect(profile.powerZones.z1Max, 110);
      });
    });

    group('wattsPerKg', () {
      test('should calculate correct W/kg', () {
        final profile = AthleteProfile(
          id: 'test',
          ftp: 300,
          weight: 75,
          powerZones: PowerZones.fromFtp(300),
        );

        expect(profile.wattsPerKg, 4.0);
      });

      test('should return null when weight is null', () {
        final profile = AthleteProfile(
          id: 'test',
          ftp: 300,
          weight: null,
          powerZones: PowerZones.fromFtp(300),
        );

        expect(profile.wattsPerKg, isNull);
      });

      test('should return null when weight is 0', () {
        final profile = AthleteProfile(
          id: 'test',
          ftp: 300,
          weight: 0,
          powerZones: PowerZones.fromFtp(300),
        );

        expect(profile.wattsPerKg, isNull);
      });
    });

    group('updateFtp', () {
      test('should update FTP and recalculate zones', () {
        final profile = AthleteProfile.defaultProfile();
        final updated = profile.updateFtp(250);

        expect(updated.ftp, 250);
        expect(updated.powerZones.z1Max, 138); // 0.55 * 250
        expect(updated.ftpTestDate, isNotNull);
      });

      test('should add entry to FTP history', () {
        final profile = AthleteProfile.defaultProfile();
        expect(profile.ftpHistory, isEmpty);

        final updated = profile.updateFtp(250);
        expect(updated.ftpHistory, hasLength(1));
        expect(updated.ftpHistory.first.ftp, 250);
      });

      test('should accumulate FTP history', () {
        var profile = AthleteProfile.defaultProfile();
        profile = profile.updateFtp(210);
        profile = profile.updateFtp(220);
        profile = profile.updateFtp(230);

        expect(profile.ftpHistory, hasLength(3));
        expect(profile.ftpHistory[0].ftp, 210);
        expect(profile.ftpHistory[1].ftp, 220);
        expect(profile.ftpHistory[2].ftp, 230);
      });

      test('should not update zones when autoUpdateZones is false', () {
        final profile = AthleteProfile.defaultProfile();
        final originalZones = profile.powerZones;
        final updated = profile.updateFtp(250, autoUpdateZones: false);

        expect(updated.ftp, 250);
        expect(updated.powerZones, equals(originalZones));
      });
    });

    group('copyWith', () {
      test('should copy with new values', () {
        final profile = AthleteProfile.defaultProfile();
        final updated = profile.copyWith(
          name: 'Test User',
          weight: 75,
          maxHr: 190,
        );

        expect(updated.name, 'Test User');
        expect(updated.weight, 75);
        expect(updated.maxHr, 190);
        expect(updated.ftp, profile.ftp); // unchanged
      });

      test('should update HR zones when maxHr is provided', () {
        final profile = AthleteProfile.defaultProfile();
        final updated = profile.copyWith(
          maxHr: 190,
          hrZones: HeartRateZones.fromMaxHr(190),
        );

        expect(updated.hrZones, isNotNull);
        expect(updated.hrZones!.z5Max, 190);
      });
    });

    group('JSON serialization', () {
      test('should serialize to JSON correctly', () {
        final profile = AthleteProfile(
          id: 'test-id',
          name: 'Test User',
          ftp: 250,
          maxHr: 190,
          restingHr: 50,
          weight: 75,
          powerZones: PowerZones.fromFtp(250),
          hrZones: HeartRateZones.fromMaxHr(190),
        );

        final json = profile.toJson();

        expect(json['id'], 'test-id');
        expect(json['name'], 'Test User');
        expect(json['ftp'], 250);
        expect(json['maxHr'], 190);
        expect(json['restingHr'], 50);
        expect(json['weight'], 75);
        expect(json['powerZones'], isA<Map>());
        expect(json['hrZones'], isA<Map>());
      });

      test('should deserialize from JSON correctly', () {
        final json = {
          'id': 'test-id',
          'name': 'Test User',
          'ftp': 250,
          'maxHr': 190,
          'restingHr': 50,
          'weight': 75,
          'powerZones': PowerZones.fromFtp(250).toJson(),
          'hrZones': HeartRateZones.fromMaxHr(190).toJson(),
          'ftpTestDate': null,
          'ftpHistory': [],
        };

        final profile = AthleteProfile.fromJson(json);

        expect(profile.id, 'test-id');
        expect(profile.name, 'Test User');
        expect(profile.ftp, 250);
        expect(profile.maxHr, 190);
        expect(profile.weight, 75);
      });

      test('should handle null optional fields in JSON', () {
        final json = {
          'id': 'test-id',
          'name': null,
          'ftp': 200,
          'maxHr': null,
          'restingHr': null,
          'weight': null,
          'powerZones': PowerZones.fromFtp(200).toJson(),
          'hrZones': null,
          'ftpTestDate': null,
          'ftpHistory': null,
        };

        final profile = AthleteProfile.fromJson(json);

        expect(profile.name, isNull);
        expect(profile.maxHr, isNull);
        expect(profile.weight, isNull);
        expect(profile.hrZones, isNull);
        expect(profile.ftpHistory, isEmpty);
      });

      test('should maintain equality after round-trip', () {
        final original = AthleteProfile(
          id: 'test-id',
          name: 'Test User',
          ftp: 250,
          maxHr: 190,
          weight: 75,
          powerZones: PowerZones.fromFtp(250),
          hrZones: HeartRateZones.fromMaxHr(190),
        );

        final json = original.toJson();
        final restored = AthleteProfile.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.name, original.name);
        expect(restored.ftp, original.ftp);
        expect(restored.maxHr, original.maxHr);
        expect(restored.weight, original.weight);
        expect(restored.powerZones, original.powerZones);
        expect(restored.hrZones, original.hrZones);
      });
    });
  });

  group('FtpHistory', () {
    test('should create FtpHistory entry', () {
      final date = DateTime(2024, 1, 15);
      final history = FtpHistory(date: date, ftp: 250);

      expect(history.date, date);
      expect(history.ftp, 250);
    });

    test('should serialize and deserialize correctly', () {
      final original = FtpHistory(date: DateTime(2024, 1, 15), ftp: 250);
      final json = original.toJson();
      final restored = FtpHistory.fromJson(json);

      expect(restored.ftp, original.ftp);
      expect(restored.date.year, original.date.year);
      expect(restored.date.month, original.date.month);
      expect(restored.date.day, original.date.day);
    });
  });
}
