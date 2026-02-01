import 'package:uuid/uuid.dart';
import '../../core/database/app_database.dart';
import '../../domain/entities/scheduled_workout.dart';
import '../../domain/repositories/scheduled_workout_repository.dart';
import '../mappers/scheduled_workout_mapper.dart';

class ScheduledWorkoutRepositoryImpl implements ScheduledWorkoutRepository {
  final AppDatabase _db;
  final ScheduledWorkoutMapper _mapper;

  ScheduledWorkoutRepositoryImpl(this._db, this._mapper);

  @override
  Stream<List<ScheduledWorkout>> watchAllScheduledWorkouts() {
    return _db.scheduledWorkoutDao
        .watchAllScheduledWorkouts()
        .asyncMap((entities) async {
      final List<ScheduledWorkout> workouts = [];
      for (final entity in entities) {
        workouts.add(await _mapper.fromEntity(entity));
      }
      return workouts;
    });
  }

  @override
  Stream<List<ScheduledWorkout>> watchPendingScheduledWorkouts() {
    return _db.scheduledWorkoutDao
        .watchPendingScheduledWorkouts()
        .asyncMap((entities) async {
      final List<ScheduledWorkout> workouts = [];
      for (final entity in entities) {
        workouts.add(await _mapper.fromEntity(entity));
      }
      return workouts;
    });
  }

  @override
  Future<List<ScheduledWorkout>> getScheduledWorkoutsForDate(
    DateTime date,
  ) async {
    final entities =
        await _db.scheduledWorkoutDao.getScheduledWorkoutsForDate(date);
    final List<ScheduledWorkout> workouts = [];
    for (final entity in entities) {
      workouts.add(await _mapper.fromEntity(entity));
    }
    return workouts;
  }

  @override
  Future<List<ScheduledWorkout>> getScheduledWorkoutsInRange(
    DateTime start,
    DateTime end,
  ) async {
    final entities =
        await _db.scheduledWorkoutDao.getScheduledWorkoutsInRange(start, end);
    final List<ScheduledWorkout> workouts = [];
    for (final entity in entities) {
      workouts.add(await _mapper.fromEntity(entity));
    }
    return workouts;
  }

  @override
  Future<void> scheduleWorkout({
    required String workoutId,
    required String workoutType,
    required DateTime scheduledDate,
    int? scheduledTimeMinutes,
  }) async {
    final entity = ScheduledWorkoutEntity(
      id: const Uuid().v4(),
      workoutId: workoutId,
      workoutType: workoutType,
      scheduledDate: scheduledDate,
      scheduledTimeMinutes: scheduledTimeMinutes,
      status: 'pending',
      completedSessionId: null,
      createdAt: DateTime.now(),
    );

    await _db.scheduledWorkoutDao.insertScheduledWorkout(entity);
  }

  @override
  Future<void> updateScheduledWorkout(ScheduledWorkout scheduledWorkout) async {
    final entity = _mapper.toEntity(scheduledWorkout);
    await _db.scheduledWorkoutDao.updateScheduledWorkout(entity);
  }

  @override
  Future<void> deleteScheduledWorkout(String id) async {
    await _db.scheduledWorkoutDao.deleteScheduledWorkout(id);
  }

  @override
  Future<void> markAsCompleted(String id, String sessionId) async {
    await _db.scheduledWorkoutDao.markAsCompleted(id, sessionId);
  }

  @override
  Future<void> markAsSkipped(String id) async {
    await _db.scheduledWorkoutDao.markAsSkipped(id);
  }
}
