import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kickr_trainer/core/services/training_load_service.dart';
import 'package:kickr_trainer/domain/repositories/session_repository.dart';
import 'package:kickr_trainer/domain/entities/training_session.dart';
import 'package:kickr_trainer/domain/entities/training_load.dart';

class MockSessionRepository extends Mock implements SessionRepository {}

void main() {
  late MockSessionRepository mockRepository;
  late TrainingLoadService service;

  setUp(() {
    mockRepository = MockSessionRepository();
    service = TrainingLoadService(mockRepository);
  });

  /// Helper to create a TrainingSession with a given date and TSS.
  TrainingSession createSession({
    required DateTime date,
    required int tss,
  }) {
    return TrainingSession(
      id: 'session_${date.millisecondsSinceEpoch}',
      startTime: date,
      endTime: date.add(const Duration(hours: 1)),
      type: SessionType.workout,
      stats: SessionStats(
        duration: const Duration(hours: 1),
        avgPower: 150,
        maxPower: 250,
        normalizedPower: 160,
        intensityFactor: 0.8,
        tss: tss,
        totalWork: 540,
      ),
    );
  }

  group('TrainingLoadService', () {
    group('calculatePMC', () {
      test('returns empty history when no sessions exist', () async {
        when(() => mockRepository.getAllSessions())
            .thenAnswer((_) async => []);

        final result = await service.calculatePMC();

        expect(result.history, isEmpty);
        expect(result.today, isNull);
        expect(result.currentCtl, 0);
        expect(result.currentAtl, 0);
        expect(result.currentTsb, 0);
      });

      test('returns non-empty history with CTL/ATL/TSB when sessions exist',
          () async {
        final now = DateTime.now();
        final sessions = [
          createSession(
            date: DateTime(now.year, now.month, now.day)
                .subtract(const Duration(days: 10)),
            tss: 80,
          ),
          createSession(
            date: DateTime(now.year, now.month, now.day)
                .subtract(const Duration(days: 5)),
            tss: 100,
          ),
          createSession(
            date: DateTime(now.year, now.month, now.day)
                .subtract(const Duration(days: 1)),
            tss: 60,
          ),
        ];

        when(() => mockRepository.getAllSessions())
            .thenAnswer((_) async => sessions);

        final result = await service.calculatePMC();

        expect(result.history, isNotEmpty);
        // CTL and ATL should be positive since we had training
        expect(result.currentCtl, greaterThan(0));
        expect(result.currentAtl, greaterThan(0));
      });

      test('history entries contain valid dates', () async {
        final now = DateTime.now();
        final sessions = [
          createSession(
            date: DateTime(now.year, now.month, now.day)
                .subtract(const Duration(days: 3)),
            tss: 75,
          ),
        ];

        when(() => mockRepository.getAllSessions())
            .thenAnswer((_) async => sessions);

        final result = await service.calculatePMC();

        for (final entry in result.history) {
          expect(entry.date, isNotNull);
          // TSB should equal CTL - ATL
          expect(entry.tsb, closeTo(entry.ctl - entry.atl, 0.01));
        }
      });

      test('sessions without stats are ignored', () async {
        final now = DateTime.now();
        final sessions = [
          TrainingSession(
            id: 'no_stats',
            startTime: now.subtract(const Duration(days: 5)),
            type: SessionType.freeRide,
            // stats is null
          ),
        ];

        when(() => mockRepository.getAllSessions())
            .thenAnswer((_) async => sessions);

        final result = await service.calculatePMC();

        expect(result.history, isEmpty);
      });
    });

    group('predictTsb', () {
      test('basic prediction with known values', () {
        final result = service.predictTsb(
          currentCtl: 50,
          currentAtl: 30,
          plannedTss: 100,
        );

        // CTL decay = 2/(42+1) ≈ 0.04651
        // ATL decay = 2/(7+1) = 0.25
        // newCtl = 50 + 0.04651 * (100 - 50) = 50 + 2.3256 = 52.3256
        // newAtl = 30 + 0.25 * (100 - 30) = 30 + 17.5 = 47.5
        // predictedTsb = 52.3256 - 47.5 = 4.8256
        expect(result, closeTo(4.83, 0.1));
      });

      test('returns positive TSB when CTL >> ATL and low TSS', () {
        final result = service.predictTsb(
          currentCtl: 80,
          currentAtl: 20,
          plannedTss: 0,
        );
        // With zero planned TSS, ATL should decrease more than CTL
        expect(result, greaterThan(0));
      });

      test('returns negative TSB when planned TSS is very high', () {
        final result = service.predictTsb(
          currentCtl: 30,
          currentAtl: 30,
          plannedTss: 300,
        );
        // Very high TSS should increase ATL much more than CTL
        expect(result, lessThan(0));
      });

      test('returns CTL - ATL when planned TSS equals both', () {
        // When plannedTss == CTL == ATL, the formula simplifies:
        // newCtl = CTL + decay*(TSS-CTL) = CTL (no change)
        // newAtl = ATL + decay*(TSS-ATL) = ATL (no change)
        // TSB = CTL - ATL
        final result = service.predictTsb(
          currentCtl: 50,
          currentAtl: 50,
          plannedTss: 50,
        );
        expect(result, closeTo(0, 0.01));
      });
    });

    group('recommendTssForTarget', () {
      test('returns value clamped between 0 and 500', () {
        final result = service.recommendTssForTarget(
          currentCtl: 50,
          currentAtl: 60,
          targetTsb: 0,
        );
        expect(result, greaterThanOrEqualTo(0));
        expect(result, lessThanOrEqualTo(500));
      });

      test('returns reasonable value when CTL equals ATL', () {
        final result = service.recommendTssForTarget(
          currentCtl: 50,
          currentAtl: 50,
          targetTsb: 0,
        );
        // When CTL == ATL and targetTsb == 0, recommended TSS should
        // be around the current load level
        expect(result, greaterThanOrEqualTo(0));
        expect(result, lessThanOrEqualTo(500));
      });

      test('higher target TSB recommends lower TSS', () {
        final lowTsbResult = service.recommendTssForTarget(
          currentCtl: 50,
          currentAtl: 60,
          targetTsb: -20,
        );
        final highTsbResult = service.recommendTssForTarget(
          currentCtl: 50,
          currentAtl: 60,
          targetTsb: 10,
        );
        // Wanting a higher TSB (more rested) should mean less training
        expect(highTsbResult, lessThan(lowTsbResult));
      });

      test('returns 0 when target requires negative TSS', () {
        final result = service.recommendTssForTarget(
          currentCtl: 10,
          currentAtl: 80,
          targetTsb: 50,
        );
        // Wanting a very high TSB from a fatigued state likely needs
        // negative TSS, which gets clamped to 0
        expect(result, 0);
      });
    });
  });
}
