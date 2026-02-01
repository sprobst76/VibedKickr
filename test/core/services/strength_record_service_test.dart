import 'package:flutter_test/flutter_test.dart';
import 'package:kickr_trainer/core/database/daos/strength_pr_dao.dart';
import 'package:kickr_trainer/core/services/strength_record_service.dart';
import 'package:kickr_trainer/domain/entities/strength_session.dart';
import 'package:mocktail/mocktail.dart';

class MockStrengthPRDao extends Mock implements StrengthPRDao {}

class FakeStrengthPR extends Fake implements StrengthPR {}

void main() {
  late MockStrengthPRDao mockPRDao;
  late StrengthRecordService service;

  setUpAll(() {
    registerFallbackValue(FakeStrengthPR());
  });

  setUp(() {
    mockPRDao = MockStrengthPRDao();
    service = StrengthRecordService(mockPRDao);
  });

  group('StrengthRecordService - One Rep Max Calculation', () {
    test('calculateOneRepMax should calculate 1RM for 1 rep', () {
      final result = service.calculateOneRepMax(100, 1);
      expect(result, closeTo(103.3, 0.1));
    });

    test('calculateOneRepMax should calculate 1RM for 5 reps', () {
      final result = service.calculateOneRepMax(80, 5);
      expect(result, closeTo(93.3, 0.1));
    });

    test('calculateOneRepMax should calculate 1RM for 10 reps', () {
      final result = service.calculateOneRepMax(60, 10);
      expect(result, closeTo(80.0, 0.1));
    });

    test('calculateOneRepMax should handle 0 reps', () {
      final result = service.calculateOneRepMax(100, 0);
      expect(result, equals(100));
    });

    test('calculateOneRepMax should use Epley formula correctly', () {
      // Epley: weight × (1 + reps/30)
      final weight = 50.0;
      final reps = 8;
      final expected = 50 * (1 + 8 / 30);
      final result = service.calculateOneRepMax(weight, reps);
      expect(result, closeTo(expected, 0.01));
    });
  });

  group('StrengthRecordService - PR Analysis', () {
    test('analyzeSession should detect new PRs', () async {
      final exerciseId = 'ex_squat';
      final session = _createTestSession(exerciseId);

      when(() => mockPRDao.isNewRecord(exerciseId, 5, 100.0))
          .thenAnswer((_) async => true);
      when(() => mockPRDao.getCurrentRecord(exerciseId, 5))
          .thenAnswer((_) async => null);
      when(() => mockPRDao.insertRecord(any()))
          .thenAnswer((_) async => 1);

      final newRecords = await service.analyzeSession(session);

      expect(newRecords, isNotEmpty);
      verify(() => mockPRDao.insertRecord(any())).called(greaterThan(0));
    });

    test('analyzeSession should not insert duplicate PRs', () async {
      final exerciseId = 'ex_squat';
      final session = _createTestSession(exerciseId);

      when(() => mockPRDao.isNewRecord(any(), any(), any()))
          .thenAnswer((_) async => false);

      final newRecords = await service.analyzeSession(session);

      expect(newRecords, isEmpty);
      verifyNever(() => mockPRDao.insertRecord(any()));
    });

    test('analyzeSession should skip sets without weight', () async {
      final exerciseId = 'ex_squat';
      final setWithoutWeight = StrengthSetRecord(
        setNumber: 1,
        repsCompleted: 5,
        weightUsed: null,
        rpe: null,
        timestamp: DateTime.now(),
        restAfter: const Duration(seconds: 90),
      );

      final exerciseRecord = StrengthExerciseRecord(
        exerciseId: exerciseId,
        exerciseName: 'Squat',
        sets: [setWithoutWeight],
      );

      final session = StrengthSession(
        id: 'session_1',
        startTime: DateTime.now(),
        exercises: [exerciseRecord],
      );

      when(() => mockPRDao.isNewRecord(any(), any(), any()))
          .thenAnswer((_) async => false);

      final newRecords = await service.analyzeSession(session);

      expect(newRecords, isEmpty);
    });

    test('analyzeSession should track previous PR for improvement', () async {
      final exerciseId = 'ex_squat';
      final session = _createTestSession(exerciseId);
      final previousPR = StrengthPR(
        exerciseId: exerciseId,
        weightKg: 95.0,
        reps: 5,
        achievedAt: DateTime.now().subtract(const Duration(days: 7)),
      );

      when(() => mockPRDao.isNewRecord(exerciseId, 5, 100.0))
          .thenAnswer((_) async => true);
      when(() => mockPRDao.getCurrentRecord(exerciseId, 5))
          .thenAnswer((_) async => previousPR);
      when(() => mockPRDao.insertRecord(any())).thenAnswer((_) async => 1);

      await service.analyzeSession(session);

      // Verify that insertRecord was called with the new PR
      final captured = verify(() => mockPRDao.insertRecord(captureAny()))
          .captured
          .cast<StrengthPR>();

      expect(captured.isNotEmpty, true);
      // The first captured PR should have previousWeightKg set
      if (captured.isNotEmpty) {
        expect(captured.first.previousWeightKg, equals(95.0));
      }
    });
  });

  group('StrengthRecordService - Retrieval', () {
    test('getCurrentRecord should return current PR', () async {
      final pr = StrengthPR(
        exerciseId: 'ex_squat',
        weightKg: 100.0,
        reps: 5,
        achievedAt: DateTime.now(),
      );

      when(() => mockPRDao.getCurrentRecord('ex_squat', 5))
          .thenAnswer((_) async => pr);

      final result = await service.getCurrentRecord('ex_squat', 5);

      expect(result, equals(pr));
    });

    test('getRecordHistory should return PR history', () async {
      final pr1 = StrengthPR(
        exerciseId: 'ex_squat',
        weightKg: 100.0,
        reps: 5,
        achievedAt: DateTime.now(),
      );
      final pr2 = StrengthPR(
        exerciseId: 'ex_squat',
        weightKg: 95.0,
        reps: 5,
        achievedAt: DateTime.now().subtract(const Duration(days: 7)),
      );

      when(() => mockPRDao.getRecordHistory('ex_squat', 5, limit: 10))
          .thenAnswer((_) async => [pr1, pr2]);

      final result = await service.getRecordHistory('ex_squat', 5);

      expect(result.length, equals(2));
      expect(result.first.weightKg, equals(100.0));
    });

    test('deleteRecord should remove PR', () async {
      when(() => mockPRDao.deleteRecord(1)).thenAnswer((_) async => true);

      final result = await service.deleteRecord(1);

      expect(result, isTrue);
      verify(() => mockPRDao.deleteRecord(1)).called(1);
    });
  });
}

/// Helper function to create a test session
StrengthSession _createTestSession(String exerciseId) {
  final set1 = StrengthSetRecord(
    setNumber: 1,
    repsCompleted: 5,
    weightUsed: 100.0,
    rpe: 7,
    timestamp: DateTime.now(),
    restAfter: const Duration(seconds: 90),
  );
  final set2 = StrengthSetRecord(
    setNumber: 2,
    repsCompleted: 5,
    weightUsed: 100.0,
    rpe: 8,
    timestamp: DateTime.now(),
    restAfter: const Duration(seconds: 90),
  );

  final exerciseRecord = StrengthExerciseRecord(
    exerciseId: exerciseId,
    exerciseName: 'Squat',
    sets: [set1, set2],
  );

  return StrengthSession(
    id: 'session_1',
    startTime: DateTime.now(),
    exercises: [exerciseRecord],
  );
}
