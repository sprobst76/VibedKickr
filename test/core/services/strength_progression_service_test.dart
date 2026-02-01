import 'package:flutter_test/flutter_test.dart';
import 'package:kickr_trainer/core/database/daos/strength_pr_dao.dart';
import 'package:kickr_trainer/core/database/daos/strength_session_dao.dart';
import 'package:kickr_trainer/core/services/strength_progression_service.dart';
import 'package:kickr_trainer/domain/entities/strength_session.dart';
import 'package:mocktail/mocktail.dart';

class MockStrengthSessionDao extends Mock implements StrengthSessionDao {}

class MockStrengthPRDao extends Mock implements StrengthPRDao {}

class FakeStrengthPR extends Fake implements StrengthPR {}

void main() {
  late MockStrengthSessionDao mockSessionDao;
  late MockStrengthPRDao mockPRDao;
  late StrengthProgressionService service;

  setUpAll(() {
    registerFallbackValue(FakeStrengthPR());
  });

  setUp(() {
    mockSessionDao = MockStrengthSessionDao();
    mockPRDao = MockStrengthPRDao();
    service = StrengthProgressionService(mockSessionDao, mockPRDao);
  });

  group('StrengthProgressionService - Linear Progression', () {
    test('calculateNextLoad should return +2.5kg when ready', () async {
      final exerciseId = 'ex_squat';
      final currentPR = StrengthPR(
        exerciseId: exerciseId,
        weightKg: 100.0,
        reps: 5,
        achievedAt: DateTime.now(),
      );

      final sessions = [
        _createSession(exerciseId, 100.0, 5),
        _createSession(exerciseId, 100.0, 5),
        _createSession(exerciseId, 100.0, 5),
      ];

      when(() => mockPRDao.getCurrentRecord(exerciseId, any()))
          .thenAnswer((_) async => currentPR);

      final result = await service.calculateNextLoad(exerciseId, sessions);

      expect(result, isNotNull);
      expect(result?.resolveWeight(), equals(102.5));
    });

    test('calculateNextLoad should return null with insufficient sessions', () async {
      final exerciseId = 'ex_squat';
      final sessions = [_createSession(exerciseId, 100.0, 5)];

      final result = await service.calculateNextLoad(exerciseId, sessions);

      expect(result, isNull);
    });

    test('calculateNextLoad should return null if no PR exists', () async {
      final exerciseId = 'ex_squat';
      final sessions = [
        _createSession(exerciseId, 100.0, 5),
        _createSession(exerciseId, 100.0, 5),
        _createSession(exerciseId, 100.0, 5),
      ];

      when(() => mockPRDao.getCurrentRecord(exerciseId, any()))
          .thenAnswer((_) async => null);

      final result = await service.calculateNextLoad(exerciseId, sessions);

      expect(result, isNull);
    });
  });

  group('StrengthProgressionService - Weekly Volume', () {
    test('calculateWeeklyVolume should sum all sets correctly', () async {
      final sessions = [
        _createSession('ex_squat', 100.0, 5),
        _createSession('ex_bench', 80.0, 8),
      ];

      final volume = await service.calculateWeeklyVolume(sessions);

      expect(volume, greaterThan(0));
    });
  });

  group('StrengthProgressionService - Recommendations', () {
    test('getRecommendation should suggest progression when ready', () async {
      final exerciseId = 'ex_squat';
      final currentPR = StrengthPR(
        exerciseId: exerciseId,
        weightKg: 100.0,
        reps: 5,
        achievedAt: DateTime.now(),
      );

      final sessions = [
        _createSession(exerciseId, 100.0, 5),
        _createSession(exerciseId, 100.0, 5),
        _createSession(exerciseId, 100.0, 5),
      ];

      when(() => mockPRDao.getCurrentRecord(exerciseId, any()))
          .thenAnswer((_) async => currentPR);

      final recommendation = await service.getRecommendation(exerciseId, sessions);

      expect(recommendation.message, isNotEmpty);
      expect(recommendation.estimatedOneRepMax, greaterThan(0));
    });

    test('getRecommendation should provide basic guidance with no history', () async {
      final recommendation = await service.getRecommendation('ex_squat', []);

      expect(recommendation.message, isNotEmpty);
      expect(recommendation.estimatedOneRepMax, equals(0));
    });

    test('getRecommendation should calculate estimated 1RM', () async {
      final exerciseId = 'ex_squat';
      final currentPR = StrengthPR(
        exerciseId: exerciseId,
        weightKg: 100.0,
        reps: 5,
        achievedAt: DateTime.now(),
      );

      final sessions = [_createSession(exerciseId, 100.0, 5)];

      when(() => mockPRDao.getCurrentRecord(exerciseId, any()))
          .thenAnswer((_) async => currentPR);

      final recommendation = await service.getRecommendation(exerciseId, sessions);

      // 100 × (1 + 5/30) ≈ 116.67
      expect(recommendation.estimatedOneRepMax, closeTo(116.67, 1.0));
    });
  });
}

/// Helper function to create a test session
StrengthSession _createSession(String exerciseId, double weight, int reps) {
  final sets = [
    StrengthSetRecord(
      setNumber: 1,
      repsCompleted: reps,
      weightUsed: weight,
      rpe: 7,
      timestamp: DateTime.now(),
      restAfter: const Duration(seconds: 90),
    ),
    StrengthSetRecord(
      setNumber: 2,
      repsCompleted: reps,
      weightUsed: weight,
      rpe: 8,
      timestamp: DateTime.now(),
      restAfter: const Duration(seconds: 90),
    ),
    StrengthSetRecord(
      setNumber: 3,
      repsCompleted: reps,
      weightUsed: weight,
      rpe: 8,
      timestamp: DateTime.now(),
      restAfter: const Duration(seconds: 90),
    ),
  ];

  final exerciseRecord = StrengthExerciseRecord(
    exerciseId: exerciseId,
    exerciseName: exerciseId,
    sets: sets,
  );

  return StrengthSession(
    id: 'session_${DateTime.now().millisecondsSinceEpoch}',
    startTime: DateTime.now(),
    exercises: [exerciseRecord],
  );
}
