import '../../core/database/app_database.dart';
import '../../core/database/daos/workout_dao.dart';
import '../../core/database/daos/strength_workout_dao.dart';
import '../../domain/entities/scheduled_workout.dart';

class ScheduledWorkoutMapper {
  final WorkoutDao _workoutDao;
  final StrengthWorkoutDao _strengthWorkoutDao;

  ScheduledWorkoutMapper(this._workoutDao, this._strengthWorkoutDao);

  Future<ScheduledWorkout> fromEntity(ScheduledWorkoutEntity entity) async {
    final status = _parseStatus(entity.status);

    // Load the associated workout
    if (entity.workoutType == 'cycling') {
      final workout = await _workoutDao.getWorkout(entity.workoutId);

      return ScheduledWorkout(
        id: entity.id,
        workoutId: entity.workoutId,
        workoutType: entity.workoutType,
        cyclingWorkout: workout,
        scheduledDate: entity.scheduledDate,
        scheduledTimeMinutes: entity.scheduledTimeMinutes,
        status: status,
        completedSessionId: entity.completedSessionId,
        createdAt: entity.createdAt,
      );
    } else {
      final workout = await _strengthWorkoutDao.getWorkoutById(entity.workoutId);

      return ScheduledWorkout(
        id: entity.id,
        workoutId: entity.workoutId,
        workoutType: entity.workoutType,
        strengthWorkout: workout,
        scheduledDate: entity.scheduledDate,
        scheduledTimeMinutes: entity.scheduledTimeMinutes,
        status: status,
        completedSessionId: entity.completedSessionId,
        createdAt: entity.createdAt,
      );
    }
  }

  ScheduledWorkoutEntity toEntity(ScheduledWorkout domain) {
    return ScheduledWorkoutEntity(
      id: domain.id,
      workoutId: domain.workoutId,
      workoutType: domain.workoutType,
      scheduledDate: domain.scheduledDate,
      scheduledTimeMinutes: domain.scheduledTimeMinutes,
      status: _statusToString(domain.status),
      completedSessionId: domain.completedSessionId,
      createdAt: domain.createdAt,
    );
  }

  ScheduledWorkoutStatus _parseStatus(String status) {
    switch (status) {
      case 'pending':
        return ScheduledWorkoutStatus.pending;
      case 'completed':
        return ScheduledWorkoutStatus.completed;
      case 'skipped':
        return ScheduledWorkoutStatus.skipped;
      default:
        return ScheduledWorkoutStatus.pending;
    }
  }

  String _statusToString(ScheduledWorkoutStatus status) {
    switch (status) {
      case ScheduledWorkoutStatus.pending:
        return 'pending';
      case ScheduledWorkoutStatus.completed:
        return 'completed';
      case ScheduledWorkoutStatus.skipped:
        return 'skipped';
    }
  }
}
