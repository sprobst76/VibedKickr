// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scheduled_workout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ScheduledWorkout {
  String get id => throw _privateConstructorUsedError;
  String get workoutId => throw _privateConstructorUsedError;
  String get workoutType =>
      throw _privateConstructorUsedError; // 'cycling' or 'strength'
  Workout? get cyclingWorkout => throw _privateConstructorUsedError;
  StrengthWorkout? get strengthWorkout => throw _privateConstructorUsedError;
  DateTime get scheduledDate => throw _privateConstructorUsedError;
  int? get scheduledTimeMinutes => throw _privateConstructorUsedError;
  ScheduledWorkoutStatus get status => throw _privateConstructorUsedError;
  String? get completedSessionId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ScheduledWorkoutCopyWith<ScheduledWorkout> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduledWorkoutCopyWith<$Res> {
  factory $ScheduledWorkoutCopyWith(
          ScheduledWorkout value, $Res Function(ScheduledWorkout) then) =
      _$ScheduledWorkoutCopyWithImpl<$Res, ScheduledWorkout>;
  @useResult
  $Res call(
      {String id,
      String workoutId,
      String workoutType,
      Workout? cyclingWorkout,
      StrengthWorkout? strengthWorkout,
      DateTime scheduledDate,
      int? scheduledTimeMinutes,
      ScheduledWorkoutStatus status,
      String? completedSessionId,
      DateTime createdAt});
}

/// @nodoc
class _$ScheduledWorkoutCopyWithImpl<$Res, $Val extends ScheduledWorkout>
    implements $ScheduledWorkoutCopyWith<$Res> {
  _$ScheduledWorkoutCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workoutId = null,
    Object? workoutType = null,
    Object? cyclingWorkout = freezed,
    Object? strengthWorkout = freezed,
    Object? scheduledDate = null,
    Object? scheduledTimeMinutes = freezed,
    Object? status = null,
    Object? completedSessionId = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      workoutId: null == workoutId
          ? _value.workoutId
          : workoutId // ignore: cast_nullable_to_non_nullable
              as String,
      workoutType: null == workoutType
          ? _value.workoutType
          : workoutType // ignore: cast_nullable_to_non_nullable
              as String,
      cyclingWorkout: freezed == cyclingWorkout
          ? _value.cyclingWorkout
          : cyclingWorkout // ignore: cast_nullable_to_non_nullable
              as Workout?,
      strengthWorkout: freezed == strengthWorkout
          ? _value.strengthWorkout
          : strengthWorkout // ignore: cast_nullable_to_non_nullable
              as StrengthWorkout?,
      scheduledDate: null == scheduledDate
          ? _value.scheduledDate
          : scheduledDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scheduledTimeMinutes: freezed == scheduledTimeMinutes
          ? _value.scheduledTimeMinutes
          : scheduledTimeMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ScheduledWorkoutStatus,
      completedSessionId: freezed == completedSessionId
          ? _value.completedSessionId
          : completedSessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScheduledWorkoutImplCopyWith<$Res>
    implements $ScheduledWorkoutCopyWith<$Res> {
  factory _$$ScheduledWorkoutImplCopyWith(_$ScheduledWorkoutImpl value,
          $Res Function(_$ScheduledWorkoutImpl) then) =
      __$$ScheduledWorkoutImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String workoutId,
      String workoutType,
      Workout? cyclingWorkout,
      StrengthWorkout? strengthWorkout,
      DateTime scheduledDate,
      int? scheduledTimeMinutes,
      ScheduledWorkoutStatus status,
      String? completedSessionId,
      DateTime createdAt});
}

/// @nodoc
class __$$ScheduledWorkoutImplCopyWithImpl<$Res>
    extends _$ScheduledWorkoutCopyWithImpl<$Res, _$ScheduledWorkoutImpl>
    implements _$$ScheduledWorkoutImplCopyWith<$Res> {
  __$$ScheduledWorkoutImplCopyWithImpl(_$ScheduledWorkoutImpl _value,
      $Res Function(_$ScheduledWorkoutImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workoutId = null,
    Object? workoutType = null,
    Object? cyclingWorkout = freezed,
    Object? strengthWorkout = freezed,
    Object? scheduledDate = null,
    Object? scheduledTimeMinutes = freezed,
    Object? status = null,
    Object? completedSessionId = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$ScheduledWorkoutImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      workoutId: null == workoutId
          ? _value.workoutId
          : workoutId // ignore: cast_nullable_to_non_nullable
              as String,
      workoutType: null == workoutType
          ? _value.workoutType
          : workoutType // ignore: cast_nullable_to_non_nullable
              as String,
      cyclingWorkout: freezed == cyclingWorkout
          ? _value.cyclingWorkout
          : cyclingWorkout // ignore: cast_nullable_to_non_nullable
              as Workout?,
      strengthWorkout: freezed == strengthWorkout
          ? _value.strengthWorkout
          : strengthWorkout // ignore: cast_nullable_to_non_nullable
              as StrengthWorkout?,
      scheduledDate: null == scheduledDate
          ? _value.scheduledDate
          : scheduledDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scheduledTimeMinutes: freezed == scheduledTimeMinutes
          ? _value.scheduledTimeMinutes
          : scheduledTimeMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ScheduledWorkoutStatus,
      completedSessionId: freezed == completedSessionId
          ? _value.completedSessionId
          : completedSessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$ScheduledWorkoutImpl extends _ScheduledWorkout {
  const _$ScheduledWorkoutImpl(
      {required this.id,
      required this.workoutId,
      required this.workoutType,
      this.cyclingWorkout,
      this.strengthWorkout,
      required this.scheduledDate,
      this.scheduledTimeMinutes,
      required this.status,
      this.completedSessionId,
      required this.createdAt})
      : super._();

  @override
  final String id;
  @override
  final String workoutId;
  @override
  final String workoutType;
// 'cycling' or 'strength'
  @override
  final Workout? cyclingWorkout;
  @override
  final StrengthWorkout? strengthWorkout;
  @override
  final DateTime scheduledDate;
  @override
  final int? scheduledTimeMinutes;
  @override
  final ScheduledWorkoutStatus status;
  @override
  final String? completedSessionId;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ScheduledWorkout(id: $id, workoutId: $workoutId, workoutType: $workoutType, cyclingWorkout: $cyclingWorkout, strengthWorkout: $strengthWorkout, scheduledDate: $scheduledDate, scheduledTimeMinutes: $scheduledTimeMinutes, status: $status, completedSessionId: $completedSessionId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduledWorkoutImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workoutId, workoutId) ||
                other.workoutId == workoutId) &&
            (identical(other.workoutType, workoutType) ||
                other.workoutType == workoutType) &&
            (identical(other.cyclingWorkout, cyclingWorkout) ||
                other.cyclingWorkout == cyclingWorkout) &&
            (identical(other.strengthWorkout, strengthWorkout) ||
                other.strengthWorkout == strengthWorkout) &&
            (identical(other.scheduledDate, scheduledDate) ||
                other.scheduledDate == scheduledDate) &&
            (identical(other.scheduledTimeMinutes, scheduledTimeMinutes) ||
                other.scheduledTimeMinutes == scheduledTimeMinutes) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.completedSessionId, completedSessionId) ||
                other.completedSessionId == completedSessionId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      workoutId,
      workoutType,
      cyclingWorkout,
      strengthWorkout,
      scheduledDate,
      scheduledTimeMinutes,
      status,
      completedSessionId,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduledWorkoutImplCopyWith<_$ScheduledWorkoutImpl> get copyWith =>
      __$$ScheduledWorkoutImplCopyWithImpl<_$ScheduledWorkoutImpl>(
          this, _$identity);
}

abstract class _ScheduledWorkout extends ScheduledWorkout {
  const factory _ScheduledWorkout(
      {required final String id,
      required final String workoutId,
      required final String workoutType,
      final Workout? cyclingWorkout,
      final StrengthWorkout? strengthWorkout,
      required final DateTime scheduledDate,
      final int? scheduledTimeMinutes,
      required final ScheduledWorkoutStatus status,
      final String? completedSessionId,
      required final DateTime createdAt}) = _$ScheduledWorkoutImpl;
  const _ScheduledWorkout._() : super._();

  @override
  String get id;
  @override
  String get workoutId;
  @override
  String get workoutType;
  @override // 'cycling' or 'strength'
  Workout? get cyclingWorkout;
  @override
  StrengthWorkout? get strengthWorkout;
  @override
  DateTime get scheduledDate;
  @override
  int? get scheduledTimeMinutes;
  @override
  ScheduledWorkoutStatus get status;
  @override
  String? get completedSessionId;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$ScheduledWorkoutImplCopyWith<_$ScheduledWorkoutImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
