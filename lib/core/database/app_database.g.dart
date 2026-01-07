// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TrainingSessionsTable extends TrainingSessions
    with TableInfo<$TrainingSessionsTable, TrainingSessionEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrainingSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<int> startTime = GeneratedColumn<int>(
      'start_time', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<int> endTime = GeneratedColumn<int>(
      'end_time', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _sessionTypeMeta =
      const VerificationMeta('sessionType');
  @override
  late final GeneratedColumn<String> sessionType = GeneratedColumn<String>(
      'session_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _workoutIdMeta =
      const VerificationMeta('workoutId');
  @override
  late final GeneratedColumn<String> workoutId = GeneratedColumn<String>(
      'workout_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _routeIdMeta =
      const VerificationMeta('routeId');
  @override
  late final GeneratedColumn<String> routeId = GeneratedColumn<String>(
      'route_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statsDurationMsMeta =
      const VerificationMeta('statsDurationMs');
  @override
  late final GeneratedColumn<int> statsDurationMs = GeneratedColumn<int>(
      'stats_duration_ms', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _statsAvgPowerMeta =
      const VerificationMeta('statsAvgPower');
  @override
  late final GeneratedColumn<int> statsAvgPower = GeneratedColumn<int>(
      'stats_avg_power', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _statsMaxPowerMeta =
      const VerificationMeta('statsMaxPower');
  @override
  late final GeneratedColumn<int> statsMaxPower = GeneratedColumn<int>(
      'stats_max_power', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _statsNormalizedPowerMeta =
      const VerificationMeta('statsNormalizedPower');
  @override
  late final GeneratedColumn<int> statsNormalizedPower = GeneratedColumn<int>(
      'stats_normalized_power', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _statsIntensityFactorMeta =
      const VerificationMeta('statsIntensityFactor');
  @override
  late final GeneratedColumn<double> statsIntensityFactor =
      GeneratedColumn<double>('stats_intensity_factor', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0.0));
  static const VerificationMeta _statsTssMeta =
      const VerificationMeta('statsTss');
  @override
  late final GeneratedColumn<int> statsTss = GeneratedColumn<int>(
      'stats_tss', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _statsTotalWorkMeta =
      const VerificationMeta('statsTotalWork');
  @override
  late final GeneratedColumn<int> statsTotalWork = GeneratedColumn<int>(
      'stats_total_work', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _statsAvgCadenceMeta =
      const VerificationMeta('statsAvgCadence');
  @override
  late final GeneratedColumn<int> statsAvgCadence = GeneratedColumn<int>(
      'stats_avg_cadence', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _statsMaxCadenceMeta =
      const VerificationMeta('statsMaxCadence');
  @override
  late final GeneratedColumn<int> statsMaxCadence = GeneratedColumn<int>(
      'stats_max_cadence', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _statsAvgHeartRateMeta =
      const VerificationMeta('statsAvgHeartRate');
  @override
  late final GeneratedColumn<int> statsAvgHeartRate = GeneratedColumn<int>(
      'stats_avg_heart_rate', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _statsMaxHeartRateMeta =
      const VerificationMeta('statsMaxHeartRate');
  @override
  late final GeneratedColumn<int> statsMaxHeartRate = GeneratedColumn<int>(
      'stats_max_heart_rate', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _statsCaloriesMeta =
      const VerificationMeta('statsCalories');
  @override
  late final GeneratedColumn<int> statsCalories = GeneratedColumn<int>(
      'stats_calories', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _statsDistanceMeta =
      const VerificationMeta('statsDistance');
  @override
  late final GeneratedColumn<double> statsDistance = GeneratedColumn<double>(
      'stats_distance', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _syncStatusJsonMeta =
      const VerificationMeta('syncStatusJson');
  @override
  late final GeneratedColumn<String> syncStatusJson = GeneratedColumn<String>(
      'sync_status_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        startTime,
        endTime,
        sessionType,
        workoutId,
        routeId,
        statsDurationMs,
        statsAvgPower,
        statsMaxPower,
        statsNormalizedPower,
        statsIntensityFactor,
        statsTss,
        statsTotalWork,
        statsAvgCadence,
        statsMaxCadence,
        statsAvgHeartRate,
        statsMaxHeartRate,
        statsCalories,
        statsDistance,
        syncStatusJson
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'training_sessions';
  @override
  VerificationContext validateIntegrity(
      Insertable<TrainingSessionEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    }
    if (data.containsKey('session_type')) {
      context.handle(
          _sessionTypeMeta,
          sessionType.isAcceptableOrUnknown(
              data['session_type']!, _sessionTypeMeta));
    } else if (isInserting) {
      context.missing(_sessionTypeMeta);
    }
    if (data.containsKey('workout_id')) {
      context.handle(_workoutIdMeta,
          workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta));
    }
    if (data.containsKey('route_id')) {
      context.handle(_routeIdMeta,
          routeId.isAcceptableOrUnknown(data['route_id']!, _routeIdMeta));
    }
    if (data.containsKey('stats_duration_ms')) {
      context.handle(
          _statsDurationMsMeta,
          statsDurationMs.isAcceptableOrUnknown(
              data['stats_duration_ms']!, _statsDurationMsMeta));
    }
    if (data.containsKey('stats_avg_power')) {
      context.handle(
          _statsAvgPowerMeta,
          statsAvgPower.isAcceptableOrUnknown(
              data['stats_avg_power']!, _statsAvgPowerMeta));
    }
    if (data.containsKey('stats_max_power')) {
      context.handle(
          _statsMaxPowerMeta,
          statsMaxPower.isAcceptableOrUnknown(
              data['stats_max_power']!, _statsMaxPowerMeta));
    }
    if (data.containsKey('stats_normalized_power')) {
      context.handle(
          _statsNormalizedPowerMeta,
          statsNormalizedPower.isAcceptableOrUnknown(
              data['stats_normalized_power']!, _statsNormalizedPowerMeta));
    }
    if (data.containsKey('stats_intensity_factor')) {
      context.handle(
          _statsIntensityFactorMeta,
          statsIntensityFactor.isAcceptableOrUnknown(
              data['stats_intensity_factor']!, _statsIntensityFactorMeta));
    }
    if (data.containsKey('stats_tss')) {
      context.handle(_statsTssMeta,
          statsTss.isAcceptableOrUnknown(data['stats_tss']!, _statsTssMeta));
    }
    if (data.containsKey('stats_total_work')) {
      context.handle(
          _statsTotalWorkMeta,
          statsTotalWork.isAcceptableOrUnknown(
              data['stats_total_work']!, _statsTotalWorkMeta));
    }
    if (data.containsKey('stats_avg_cadence')) {
      context.handle(
          _statsAvgCadenceMeta,
          statsAvgCadence.isAcceptableOrUnknown(
              data['stats_avg_cadence']!, _statsAvgCadenceMeta));
    }
    if (data.containsKey('stats_max_cadence')) {
      context.handle(
          _statsMaxCadenceMeta,
          statsMaxCadence.isAcceptableOrUnknown(
              data['stats_max_cadence']!, _statsMaxCadenceMeta));
    }
    if (data.containsKey('stats_avg_heart_rate')) {
      context.handle(
          _statsAvgHeartRateMeta,
          statsAvgHeartRate.isAcceptableOrUnknown(
              data['stats_avg_heart_rate']!, _statsAvgHeartRateMeta));
    }
    if (data.containsKey('stats_max_heart_rate')) {
      context.handle(
          _statsMaxHeartRateMeta,
          statsMaxHeartRate.isAcceptableOrUnknown(
              data['stats_max_heart_rate']!, _statsMaxHeartRateMeta));
    }
    if (data.containsKey('stats_calories')) {
      context.handle(
          _statsCaloriesMeta,
          statsCalories.isAcceptableOrUnknown(
              data['stats_calories']!, _statsCaloriesMeta));
    }
    if (data.containsKey('stats_distance')) {
      context.handle(
          _statsDistanceMeta,
          statsDistance.isAcceptableOrUnknown(
              data['stats_distance']!, _statsDistanceMeta));
    }
    if (data.containsKey('sync_status_json')) {
      context.handle(
          _syncStatusJsonMeta,
          syncStatusJson.isAcceptableOrUnknown(
              data['sync_status_json']!, _syncStatusJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrainingSessionEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrainingSessionEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}end_time']),
      sessionType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_type'])!,
      workoutId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}workout_id']),
      routeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}route_id']),
      statsDurationMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stats_duration_ms'])!,
      statsAvgPower: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stats_avg_power'])!,
      statsMaxPower: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stats_max_power'])!,
      statsNormalizedPower: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}stats_normalized_power'])!,
      statsIntensityFactor: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}stats_intensity_factor'])!,
      statsTss: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stats_tss'])!,
      statsTotalWork: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stats_total_work'])!,
      statsAvgCadence: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stats_avg_cadence']),
      statsMaxCadence: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stats_max_cadence']),
      statsAvgHeartRate: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}stats_avg_heart_rate']),
      statsMaxHeartRate: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}stats_max_heart_rate']),
      statsCalories: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stats_calories']),
      statsDistance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}stats_distance']),
      syncStatusJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}sync_status_json'])!,
    );
  }

  @override
  $TrainingSessionsTable createAlias(String alias) {
    return $TrainingSessionsTable(attachedDatabase, alias);
  }
}

class TrainingSessionEntity extends DataClass
    implements Insertable<TrainingSessionEntity> {
  final String id;
  final int startTime;
  final int? endTime;
  final String sessionType;
  final String? workoutId;
  final String? routeId;
  final int statsDurationMs;
  final int statsAvgPower;
  final int statsMaxPower;
  final int statsNormalizedPower;
  final double statsIntensityFactor;
  final int statsTss;
  final int statsTotalWork;
  final int? statsAvgCadence;
  final int? statsMaxCadence;
  final int? statsAvgHeartRate;
  final int? statsMaxHeartRate;
  final int? statsCalories;
  final double? statsDistance;
  final String syncStatusJson;
  const TrainingSessionEntity(
      {required this.id,
      required this.startTime,
      this.endTime,
      required this.sessionType,
      this.workoutId,
      this.routeId,
      required this.statsDurationMs,
      required this.statsAvgPower,
      required this.statsMaxPower,
      required this.statsNormalizedPower,
      required this.statsIntensityFactor,
      required this.statsTss,
      required this.statsTotalWork,
      this.statsAvgCadence,
      this.statsMaxCadence,
      this.statsAvgHeartRate,
      this.statsMaxHeartRate,
      this.statsCalories,
      this.statsDistance,
      required this.syncStatusJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['start_time'] = Variable<int>(startTime);
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<int>(endTime);
    }
    map['session_type'] = Variable<String>(sessionType);
    if (!nullToAbsent || workoutId != null) {
      map['workout_id'] = Variable<String>(workoutId);
    }
    if (!nullToAbsent || routeId != null) {
      map['route_id'] = Variable<String>(routeId);
    }
    map['stats_duration_ms'] = Variable<int>(statsDurationMs);
    map['stats_avg_power'] = Variable<int>(statsAvgPower);
    map['stats_max_power'] = Variable<int>(statsMaxPower);
    map['stats_normalized_power'] = Variable<int>(statsNormalizedPower);
    map['stats_intensity_factor'] = Variable<double>(statsIntensityFactor);
    map['stats_tss'] = Variable<int>(statsTss);
    map['stats_total_work'] = Variable<int>(statsTotalWork);
    if (!nullToAbsent || statsAvgCadence != null) {
      map['stats_avg_cadence'] = Variable<int>(statsAvgCadence);
    }
    if (!nullToAbsent || statsMaxCadence != null) {
      map['stats_max_cadence'] = Variable<int>(statsMaxCadence);
    }
    if (!nullToAbsent || statsAvgHeartRate != null) {
      map['stats_avg_heart_rate'] = Variable<int>(statsAvgHeartRate);
    }
    if (!nullToAbsent || statsMaxHeartRate != null) {
      map['stats_max_heart_rate'] = Variable<int>(statsMaxHeartRate);
    }
    if (!nullToAbsent || statsCalories != null) {
      map['stats_calories'] = Variable<int>(statsCalories);
    }
    if (!nullToAbsent || statsDistance != null) {
      map['stats_distance'] = Variable<double>(statsDistance);
    }
    map['sync_status_json'] = Variable<String>(syncStatusJson);
    return map;
  }

  TrainingSessionsCompanion toCompanion(bool nullToAbsent) {
    return TrainingSessionsCompanion(
      id: Value(id),
      startTime: Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      sessionType: Value(sessionType),
      workoutId: workoutId == null && nullToAbsent
          ? const Value.absent()
          : Value(workoutId),
      routeId: routeId == null && nullToAbsent
          ? const Value.absent()
          : Value(routeId),
      statsDurationMs: Value(statsDurationMs),
      statsAvgPower: Value(statsAvgPower),
      statsMaxPower: Value(statsMaxPower),
      statsNormalizedPower: Value(statsNormalizedPower),
      statsIntensityFactor: Value(statsIntensityFactor),
      statsTss: Value(statsTss),
      statsTotalWork: Value(statsTotalWork),
      statsAvgCadence: statsAvgCadence == null && nullToAbsent
          ? const Value.absent()
          : Value(statsAvgCadence),
      statsMaxCadence: statsMaxCadence == null && nullToAbsent
          ? const Value.absent()
          : Value(statsMaxCadence),
      statsAvgHeartRate: statsAvgHeartRate == null && nullToAbsent
          ? const Value.absent()
          : Value(statsAvgHeartRate),
      statsMaxHeartRate: statsMaxHeartRate == null && nullToAbsent
          ? const Value.absent()
          : Value(statsMaxHeartRate),
      statsCalories: statsCalories == null && nullToAbsent
          ? const Value.absent()
          : Value(statsCalories),
      statsDistance: statsDistance == null && nullToAbsent
          ? const Value.absent()
          : Value(statsDistance),
      syncStatusJson: Value(syncStatusJson),
    );
  }

  factory TrainingSessionEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrainingSessionEntity(
      id: serializer.fromJson<String>(json['id']),
      startTime: serializer.fromJson<int>(json['startTime']),
      endTime: serializer.fromJson<int?>(json['endTime']),
      sessionType: serializer.fromJson<String>(json['sessionType']),
      workoutId: serializer.fromJson<String?>(json['workoutId']),
      routeId: serializer.fromJson<String?>(json['routeId']),
      statsDurationMs: serializer.fromJson<int>(json['statsDurationMs']),
      statsAvgPower: serializer.fromJson<int>(json['statsAvgPower']),
      statsMaxPower: serializer.fromJson<int>(json['statsMaxPower']),
      statsNormalizedPower:
          serializer.fromJson<int>(json['statsNormalizedPower']),
      statsIntensityFactor:
          serializer.fromJson<double>(json['statsIntensityFactor']),
      statsTss: serializer.fromJson<int>(json['statsTss']),
      statsTotalWork: serializer.fromJson<int>(json['statsTotalWork']),
      statsAvgCadence: serializer.fromJson<int?>(json['statsAvgCadence']),
      statsMaxCadence: serializer.fromJson<int?>(json['statsMaxCadence']),
      statsAvgHeartRate: serializer.fromJson<int?>(json['statsAvgHeartRate']),
      statsMaxHeartRate: serializer.fromJson<int?>(json['statsMaxHeartRate']),
      statsCalories: serializer.fromJson<int?>(json['statsCalories']),
      statsDistance: serializer.fromJson<double?>(json['statsDistance']),
      syncStatusJson: serializer.fromJson<String>(json['syncStatusJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'startTime': serializer.toJson<int>(startTime),
      'endTime': serializer.toJson<int?>(endTime),
      'sessionType': serializer.toJson<String>(sessionType),
      'workoutId': serializer.toJson<String?>(workoutId),
      'routeId': serializer.toJson<String?>(routeId),
      'statsDurationMs': serializer.toJson<int>(statsDurationMs),
      'statsAvgPower': serializer.toJson<int>(statsAvgPower),
      'statsMaxPower': serializer.toJson<int>(statsMaxPower),
      'statsNormalizedPower': serializer.toJson<int>(statsNormalizedPower),
      'statsIntensityFactor': serializer.toJson<double>(statsIntensityFactor),
      'statsTss': serializer.toJson<int>(statsTss),
      'statsTotalWork': serializer.toJson<int>(statsTotalWork),
      'statsAvgCadence': serializer.toJson<int?>(statsAvgCadence),
      'statsMaxCadence': serializer.toJson<int?>(statsMaxCadence),
      'statsAvgHeartRate': serializer.toJson<int?>(statsAvgHeartRate),
      'statsMaxHeartRate': serializer.toJson<int?>(statsMaxHeartRate),
      'statsCalories': serializer.toJson<int?>(statsCalories),
      'statsDistance': serializer.toJson<double?>(statsDistance),
      'syncStatusJson': serializer.toJson<String>(syncStatusJson),
    };
  }

  TrainingSessionEntity copyWith(
          {String? id,
          int? startTime,
          Value<int?> endTime = const Value.absent(),
          String? sessionType,
          Value<String?> workoutId = const Value.absent(),
          Value<String?> routeId = const Value.absent(),
          int? statsDurationMs,
          int? statsAvgPower,
          int? statsMaxPower,
          int? statsNormalizedPower,
          double? statsIntensityFactor,
          int? statsTss,
          int? statsTotalWork,
          Value<int?> statsAvgCadence = const Value.absent(),
          Value<int?> statsMaxCadence = const Value.absent(),
          Value<int?> statsAvgHeartRate = const Value.absent(),
          Value<int?> statsMaxHeartRate = const Value.absent(),
          Value<int?> statsCalories = const Value.absent(),
          Value<double?> statsDistance = const Value.absent(),
          String? syncStatusJson}) =>
      TrainingSessionEntity(
        id: id ?? this.id,
        startTime: startTime ?? this.startTime,
        endTime: endTime.present ? endTime.value : this.endTime,
        sessionType: sessionType ?? this.sessionType,
        workoutId: workoutId.present ? workoutId.value : this.workoutId,
        routeId: routeId.present ? routeId.value : this.routeId,
        statsDurationMs: statsDurationMs ?? this.statsDurationMs,
        statsAvgPower: statsAvgPower ?? this.statsAvgPower,
        statsMaxPower: statsMaxPower ?? this.statsMaxPower,
        statsNormalizedPower: statsNormalizedPower ?? this.statsNormalizedPower,
        statsIntensityFactor: statsIntensityFactor ?? this.statsIntensityFactor,
        statsTss: statsTss ?? this.statsTss,
        statsTotalWork: statsTotalWork ?? this.statsTotalWork,
        statsAvgCadence: statsAvgCadence.present
            ? statsAvgCadence.value
            : this.statsAvgCadence,
        statsMaxCadence: statsMaxCadence.present
            ? statsMaxCadence.value
            : this.statsMaxCadence,
        statsAvgHeartRate: statsAvgHeartRate.present
            ? statsAvgHeartRate.value
            : this.statsAvgHeartRate,
        statsMaxHeartRate: statsMaxHeartRate.present
            ? statsMaxHeartRate.value
            : this.statsMaxHeartRate,
        statsCalories:
            statsCalories.present ? statsCalories.value : this.statsCalories,
        statsDistance:
            statsDistance.present ? statsDistance.value : this.statsDistance,
        syncStatusJson: syncStatusJson ?? this.syncStatusJson,
      );
  TrainingSessionEntity copyWithCompanion(TrainingSessionsCompanion data) {
    return TrainingSessionEntity(
      id: data.id.present ? data.id.value : this.id,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      sessionType:
          data.sessionType.present ? data.sessionType.value : this.sessionType,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
      routeId: data.routeId.present ? data.routeId.value : this.routeId,
      statsDurationMs: data.statsDurationMs.present
          ? data.statsDurationMs.value
          : this.statsDurationMs,
      statsAvgPower: data.statsAvgPower.present
          ? data.statsAvgPower.value
          : this.statsAvgPower,
      statsMaxPower: data.statsMaxPower.present
          ? data.statsMaxPower.value
          : this.statsMaxPower,
      statsNormalizedPower: data.statsNormalizedPower.present
          ? data.statsNormalizedPower.value
          : this.statsNormalizedPower,
      statsIntensityFactor: data.statsIntensityFactor.present
          ? data.statsIntensityFactor.value
          : this.statsIntensityFactor,
      statsTss: data.statsTss.present ? data.statsTss.value : this.statsTss,
      statsTotalWork: data.statsTotalWork.present
          ? data.statsTotalWork.value
          : this.statsTotalWork,
      statsAvgCadence: data.statsAvgCadence.present
          ? data.statsAvgCadence.value
          : this.statsAvgCadence,
      statsMaxCadence: data.statsMaxCadence.present
          ? data.statsMaxCadence.value
          : this.statsMaxCadence,
      statsAvgHeartRate: data.statsAvgHeartRate.present
          ? data.statsAvgHeartRate.value
          : this.statsAvgHeartRate,
      statsMaxHeartRate: data.statsMaxHeartRate.present
          ? data.statsMaxHeartRate.value
          : this.statsMaxHeartRate,
      statsCalories: data.statsCalories.present
          ? data.statsCalories.value
          : this.statsCalories,
      statsDistance: data.statsDistance.present
          ? data.statsDistance.value
          : this.statsDistance,
      syncStatusJson: data.syncStatusJson.present
          ? data.syncStatusJson.value
          : this.syncStatusJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrainingSessionEntity(')
          ..write('id: $id, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('sessionType: $sessionType, ')
          ..write('workoutId: $workoutId, ')
          ..write('routeId: $routeId, ')
          ..write('statsDurationMs: $statsDurationMs, ')
          ..write('statsAvgPower: $statsAvgPower, ')
          ..write('statsMaxPower: $statsMaxPower, ')
          ..write('statsNormalizedPower: $statsNormalizedPower, ')
          ..write('statsIntensityFactor: $statsIntensityFactor, ')
          ..write('statsTss: $statsTss, ')
          ..write('statsTotalWork: $statsTotalWork, ')
          ..write('statsAvgCadence: $statsAvgCadence, ')
          ..write('statsMaxCadence: $statsMaxCadence, ')
          ..write('statsAvgHeartRate: $statsAvgHeartRate, ')
          ..write('statsMaxHeartRate: $statsMaxHeartRate, ')
          ..write('statsCalories: $statsCalories, ')
          ..write('statsDistance: $statsDistance, ')
          ..write('syncStatusJson: $syncStatusJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      startTime,
      endTime,
      sessionType,
      workoutId,
      routeId,
      statsDurationMs,
      statsAvgPower,
      statsMaxPower,
      statsNormalizedPower,
      statsIntensityFactor,
      statsTss,
      statsTotalWork,
      statsAvgCadence,
      statsMaxCadence,
      statsAvgHeartRate,
      statsMaxHeartRate,
      statsCalories,
      statsDistance,
      syncStatusJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrainingSessionEntity &&
          other.id == this.id &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.sessionType == this.sessionType &&
          other.workoutId == this.workoutId &&
          other.routeId == this.routeId &&
          other.statsDurationMs == this.statsDurationMs &&
          other.statsAvgPower == this.statsAvgPower &&
          other.statsMaxPower == this.statsMaxPower &&
          other.statsNormalizedPower == this.statsNormalizedPower &&
          other.statsIntensityFactor == this.statsIntensityFactor &&
          other.statsTss == this.statsTss &&
          other.statsTotalWork == this.statsTotalWork &&
          other.statsAvgCadence == this.statsAvgCadence &&
          other.statsMaxCadence == this.statsMaxCadence &&
          other.statsAvgHeartRate == this.statsAvgHeartRate &&
          other.statsMaxHeartRate == this.statsMaxHeartRate &&
          other.statsCalories == this.statsCalories &&
          other.statsDistance == this.statsDistance &&
          other.syncStatusJson == this.syncStatusJson);
}

class TrainingSessionsCompanion extends UpdateCompanion<TrainingSessionEntity> {
  final Value<String> id;
  final Value<int> startTime;
  final Value<int?> endTime;
  final Value<String> sessionType;
  final Value<String?> workoutId;
  final Value<String?> routeId;
  final Value<int> statsDurationMs;
  final Value<int> statsAvgPower;
  final Value<int> statsMaxPower;
  final Value<int> statsNormalizedPower;
  final Value<double> statsIntensityFactor;
  final Value<int> statsTss;
  final Value<int> statsTotalWork;
  final Value<int?> statsAvgCadence;
  final Value<int?> statsMaxCadence;
  final Value<int?> statsAvgHeartRate;
  final Value<int?> statsMaxHeartRate;
  final Value<int?> statsCalories;
  final Value<double?> statsDistance;
  final Value<String> syncStatusJson;
  final Value<int> rowid;
  const TrainingSessionsCompanion({
    this.id = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.sessionType = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.routeId = const Value.absent(),
    this.statsDurationMs = const Value.absent(),
    this.statsAvgPower = const Value.absent(),
    this.statsMaxPower = const Value.absent(),
    this.statsNormalizedPower = const Value.absent(),
    this.statsIntensityFactor = const Value.absent(),
    this.statsTss = const Value.absent(),
    this.statsTotalWork = const Value.absent(),
    this.statsAvgCadence = const Value.absent(),
    this.statsMaxCadence = const Value.absent(),
    this.statsAvgHeartRate = const Value.absent(),
    this.statsMaxHeartRate = const Value.absent(),
    this.statsCalories = const Value.absent(),
    this.statsDistance = const Value.absent(),
    this.syncStatusJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrainingSessionsCompanion.insert({
    required String id,
    required int startTime,
    this.endTime = const Value.absent(),
    required String sessionType,
    this.workoutId = const Value.absent(),
    this.routeId = const Value.absent(),
    this.statsDurationMs = const Value.absent(),
    this.statsAvgPower = const Value.absent(),
    this.statsMaxPower = const Value.absent(),
    this.statsNormalizedPower = const Value.absent(),
    this.statsIntensityFactor = const Value.absent(),
    this.statsTss = const Value.absent(),
    this.statsTotalWork = const Value.absent(),
    this.statsAvgCadence = const Value.absent(),
    this.statsMaxCadence = const Value.absent(),
    this.statsAvgHeartRate = const Value.absent(),
    this.statsMaxHeartRate = const Value.absent(),
    this.statsCalories = const Value.absent(),
    this.statsDistance = const Value.absent(),
    this.syncStatusJson = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        startTime = Value(startTime),
        sessionType = Value(sessionType);
  static Insertable<TrainingSessionEntity> custom({
    Expression<String>? id,
    Expression<int>? startTime,
    Expression<int>? endTime,
    Expression<String>? sessionType,
    Expression<String>? workoutId,
    Expression<String>? routeId,
    Expression<int>? statsDurationMs,
    Expression<int>? statsAvgPower,
    Expression<int>? statsMaxPower,
    Expression<int>? statsNormalizedPower,
    Expression<double>? statsIntensityFactor,
    Expression<int>? statsTss,
    Expression<int>? statsTotalWork,
    Expression<int>? statsAvgCadence,
    Expression<int>? statsMaxCadence,
    Expression<int>? statsAvgHeartRate,
    Expression<int>? statsMaxHeartRate,
    Expression<int>? statsCalories,
    Expression<double>? statsDistance,
    Expression<String>? syncStatusJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (sessionType != null) 'session_type': sessionType,
      if (workoutId != null) 'workout_id': workoutId,
      if (routeId != null) 'route_id': routeId,
      if (statsDurationMs != null) 'stats_duration_ms': statsDurationMs,
      if (statsAvgPower != null) 'stats_avg_power': statsAvgPower,
      if (statsMaxPower != null) 'stats_max_power': statsMaxPower,
      if (statsNormalizedPower != null)
        'stats_normalized_power': statsNormalizedPower,
      if (statsIntensityFactor != null)
        'stats_intensity_factor': statsIntensityFactor,
      if (statsTss != null) 'stats_tss': statsTss,
      if (statsTotalWork != null) 'stats_total_work': statsTotalWork,
      if (statsAvgCadence != null) 'stats_avg_cadence': statsAvgCadence,
      if (statsMaxCadence != null) 'stats_max_cadence': statsMaxCadence,
      if (statsAvgHeartRate != null) 'stats_avg_heart_rate': statsAvgHeartRate,
      if (statsMaxHeartRate != null) 'stats_max_heart_rate': statsMaxHeartRate,
      if (statsCalories != null) 'stats_calories': statsCalories,
      if (statsDistance != null) 'stats_distance': statsDistance,
      if (syncStatusJson != null) 'sync_status_json': syncStatusJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrainingSessionsCompanion copyWith(
      {Value<String>? id,
      Value<int>? startTime,
      Value<int?>? endTime,
      Value<String>? sessionType,
      Value<String?>? workoutId,
      Value<String?>? routeId,
      Value<int>? statsDurationMs,
      Value<int>? statsAvgPower,
      Value<int>? statsMaxPower,
      Value<int>? statsNormalizedPower,
      Value<double>? statsIntensityFactor,
      Value<int>? statsTss,
      Value<int>? statsTotalWork,
      Value<int?>? statsAvgCadence,
      Value<int?>? statsMaxCadence,
      Value<int?>? statsAvgHeartRate,
      Value<int?>? statsMaxHeartRate,
      Value<int?>? statsCalories,
      Value<double?>? statsDistance,
      Value<String>? syncStatusJson,
      Value<int>? rowid}) {
    return TrainingSessionsCompanion(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      sessionType: sessionType ?? this.sessionType,
      workoutId: workoutId ?? this.workoutId,
      routeId: routeId ?? this.routeId,
      statsDurationMs: statsDurationMs ?? this.statsDurationMs,
      statsAvgPower: statsAvgPower ?? this.statsAvgPower,
      statsMaxPower: statsMaxPower ?? this.statsMaxPower,
      statsNormalizedPower: statsNormalizedPower ?? this.statsNormalizedPower,
      statsIntensityFactor: statsIntensityFactor ?? this.statsIntensityFactor,
      statsTss: statsTss ?? this.statsTss,
      statsTotalWork: statsTotalWork ?? this.statsTotalWork,
      statsAvgCadence: statsAvgCadence ?? this.statsAvgCadence,
      statsMaxCadence: statsMaxCadence ?? this.statsMaxCadence,
      statsAvgHeartRate: statsAvgHeartRate ?? this.statsAvgHeartRate,
      statsMaxHeartRate: statsMaxHeartRate ?? this.statsMaxHeartRate,
      statsCalories: statsCalories ?? this.statsCalories,
      statsDistance: statsDistance ?? this.statsDistance,
      syncStatusJson: syncStatusJson ?? this.syncStatusJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<int>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<int>(endTime.value);
    }
    if (sessionType.present) {
      map['session_type'] = Variable<String>(sessionType.value);
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<String>(workoutId.value);
    }
    if (routeId.present) {
      map['route_id'] = Variable<String>(routeId.value);
    }
    if (statsDurationMs.present) {
      map['stats_duration_ms'] = Variable<int>(statsDurationMs.value);
    }
    if (statsAvgPower.present) {
      map['stats_avg_power'] = Variable<int>(statsAvgPower.value);
    }
    if (statsMaxPower.present) {
      map['stats_max_power'] = Variable<int>(statsMaxPower.value);
    }
    if (statsNormalizedPower.present) {
      map['stats_normalized_power'] = Variable<int>(statsNormalizedPower.value);
    }
    if (statsIntensityFactor.present) {
      map['stats_intensity_factor'] =
          Variable<double>(statsIntensityFactor.value);
    }
    if (statsTss.present) {
      map['stats_tss'] = Variable<int>(statsTss.value);
    }
    if (statsTotalWork.present) {
      map['stats_total_work'] = Variable<int>(statsTotalWork.value);
    }
    if (statsAvgCadence.present) {
      map['stats_avg_cadence'] = Variable<int>(statsAvgCadence.value);
    }
    if (statsMaxCadence.present) {
      map['stats_max_cadence'] = Variable<int>(statsMaxCadence.value);
    }
    if (statsAvgHeartRate.present) {
      map['stats_avg_heart_rate'] = Variable<int>(statsAvgHeartRate.value);
    }
    if (statsMaxHeartRate.present) {
      map['stats_max_heart_rate'] = Variable<int>(statsMaxHeartRate.value);
    }
    if (statsCalories.present) {
      map['stats_calories'] = Variable<int>(statsCalories.value);
    }
    if (statsDistance.present) {
      map['stats_distance'] = Variable<double>(statsDistance.value);
    }
    if (syncStatusJson.present) {
      map['sync_status_json'] = Variable<String>(syncStatusJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrainingSessionsCompanion(')
          ..write('id: $id, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('sessionType: $sessionType, ')
          ..write('workoutId: $workoutId, ')
          ..write('routeId: $routeId, ')
          ..write('statsDurationMs: $statsDurationMs, ')
          ..write('statsAvgPower: $statsAvgPower, ')
          ..write('statsMaxPower: $statsMaxPower, ')
          ..write('statsNormalizedPower: $statsNormalizedPower, ')
          ..write('statsIntensityFactor: $statsIntensityFactor, ')
          ..write('statsTss: $statsTss, ')
          ..write('statsTotalWork: $statsTotalWork, ')
          ..write('statsAvgCadence: $statsAvgCadence, ')
          ..write('statsMaxCadence: $statsMaxCadence, ')
          ..write('statsAvgHeartRate: $statsAvgHeartRate, ')
          ..write('statsMaxHeartRate: $statsMaxHeartRate, ')
          ..write('statsCalories: $statsCalories, ')
          ..write('statsDistance: $statsDistance, ')
          ..write('syncStatusJson: $syncStatusJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DataPointsTable extends DataPoints
    with TableInfo<$DataPointsTable, DataPointEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DataPointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
      'session_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES training_sessions (id)'));
  static const VerificationMeta _timestampMsMeta =
      const VerificationMeta('timestampMs');
  @override
  late final GeneratedColumn<int> timestampMs = GeneratedColumn<int>(
      'timestamp_ms', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _powerMeta = const VerificationMeta('power');
  @override
  late final GeneratedColumn<int> power = GeneratedColumn<int>(
      'power', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _cadenceMeta =
      const VerificationMeta('cadence');
  @override
  late final GeneratedColumn<int> cadence = GeneratedColumn<int>(
      'cadence', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _heartRateMeta =
      const VerificationMeta('heartRate');
  @override
  late final GeneratedColumn<int> heartRate = GeneratedColumn<int>(
      'heart_rate', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _speedMeta = const VerificationMeta('speed');
  @override
  late final GeneratedColumn<double> speed = GeneratedColumn<double>(
      'speed', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _distanceMeta =
      const VerificationMeta('distance');
  @override
  late final GeneratedColumn<int> distance = GeneratedColumn<int>(
      'distance', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _gradeMeta = const VerificationMeta('grade');
  @override
  late final GeneratedColumn<double> grade = GeneratedColumn<double>(
      'grade', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _targetPowerMeta =
      const VerificationMeta('targetPower');
  @override
  late final GeneratedColumn<int> targetPower = GeneratedColumn<int>(
      'target_power', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sessionId,
        timestampMs,
        power,
        cadence,
        heartRate,
        speed,
        distance,
        grade,
        targetPower
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'data_points';
  @override
  VerificationContext validateIntegrity(Insertable<DataPointEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('timestamp_ms')) {
      context.handle(
          _timestampMsMeta,
          timestampMs.isAcceptableOrUnknown(
              data['timestamp_ms']!, _timestampMsMeta));
    } else if (isInserting) {
      context.missing(_timestampMsMeta);
    }
    if (data.containsKey('power')) {
      context.handle(
          _powerMeta, power.isAcceptableOrUnknown(data['power']!, _powerMeta));
    } else if (isInserting) {
      context.missing(_powerMeta);
    }
    if (data.containsKey('cadence')) {
      context.handle(_cadenceMeta,
          cadence.isAcceptableOrUnknown(data['cadence']!, _cadenceMeta));
    }
    if (data.containsKey('heart_rate')) {
      context.handle(_heartRateMeta,
          heartRate.isAcceptableOrUnknown(data['heart_rate']!, _heartRateMeta));
    }
    if (data.containsKey('speed')) {
      context.handle(
          _speedMeta, speed.isAcceptableOrUnknown(data['speed']!, _speedMeta));
    }
    if (data.containsKey('distance')) {
      context.handle(_distanceMeta,
          distance.isAcceptableOrUnknown(data['distance']!, _distanceMeta));
    }
    if (data.containsKey('grade')) {
      context.handle(
          _gradeMeta, grade.isAcceptableOrUnknown(data['grade']!, _gradeMeta));
    }
    if (data.containsKey('target_power')) {
      context.handle(
          _targetPowerMeta,
          targetPower.isAcceptableOrUnknown(
              data['target_power']!, _targetPowerMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DataPointEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DataPointEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id'])!,
      timestampMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp_ms'])!,
      power: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}power'])!,
      cadence: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cadence']),
      heartRate: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}heart_rate']),
      speed: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}speed']),
      distance: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}distance']),
      grade: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}grade']),
      targetPower: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}target_power']),
    );
  }

  @override
  $DataPointsTable createAlias(String alias) {
    return $DataPointsTable(attachedDatabase, alias);
  }
}

class DataPointEntity extends DataClass implements Insertable<DataPointEntity> {
  final int id;
  final String sessionId;
  final int timestampMs;
  final int power;
  final int? cadence;
  final int? heartRate;
  final double? speed;
  final int? distance;
  final double? grade;
  final int? targetPower;
  const DataPointEntity(
      {required this.id,
      required this.sessionId,
      required this.timestampMs,
      required this.power,
      this.cadence,
      this.heartRate,
      this.speed,
      this.distance,
      this.grade,
      this.targetPower});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['timestamp_ms'] = Variable<int>(timestampMs);
    map['power'] = Variable<int>(power);
    if (!nullToAbsent || cadence != null) {
      map['cadence'] = Variable<int>(cadence);
    }
    if (!nullToAbsent || heartRate != null) {
      map['heart_rate'] = Variable<int>(heartRate);
    }
    if (!nullToAbsent || speed != null) {
      map['speed'] = Variable<double>(speed);
    }
    if (!nullToAbsent || distance != null) {
      map['distance'] = Variable<int>(distance);
    }
    if (!nullToAbsent || grade != null) {
      map['grade'] = Variable<double>(grade);
    }
    if (!nullToAbsent || targetPower != null) {
      map['target_power'] = Variable<int>(targetPower);
    }
    return map;
  }

  DataPointsCompanion toCompanion(bool nullToAbsent) {
    return DataPointsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      timestampMs: Value(timestampMs),
      power: Value(power),
      cadence: cadence == null && nullToAbsent
          ? const Value.absent()
          : Value(cadence),
      heartRate: heartRate == null && nullToAbsent
          ? const Value.absent()
          : Value(heartRate),
      speed:
          speed == null && nullToAbsent ? const Value.absent() : Value(speed),
      distance: distance == null && nullToAbsent
          ? const Value.absent()
          : Value(distance),
      grade:
          grade == null && nullToAbsent ? const Value.absent() : Value(grade),
      targetPower: targetPower == null && nullToAbsent
          ? const Value.absent()
          : Value(targetPower),
    );
  }

  factory DataPointEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DataPointEntity(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      timestampMs: serializer.fromJson<int>(json['timestampMs']),
      power: serializer.fromJson<int>(json['power']),
      cadence: serializer.fromJson<int?>(json['cadence']),
      heartRate: serializer.fromJson<int?>(json['heartRate']),
      speed: serializer.fromJson<double?>(json['speed']),
      distance: serializer.fromJson<int?>(json['distance']),
      grade: serializer.fromJson<double?>(json['grade']),
      targetPower: serializer.fromJson<int?>(json['targetPower']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'timestampMs': serializer.toJson<int>(timestampMs),
      'power': serializer.toJson<int>(power),
      'cadence': serializer.toJson<int?>(cadence),
      'heartRate': serializer.toJson<int?>(heartRate),
      'speed': serializer.toJson<double?>(speed),
      'distance': serializer.toJson<int?>(distance),
      'grade': serializer.toJson<double?>(grade),
      'targetPower': serializer.toJson<int?>(targetPower),
    };
  }

  DataPointEntity copyWith(
          {int? id,
          String? sessionId,
          int? timestampMs,
          int? power,
          Value<int?> cadence = const Value.absent(),
          Value<int?> heartRate = const Value.absent(),
          Value<double?> speed = const Value.absent(),
          Value<int?> distance = const Value.absent(),
          Value<double?> grade = const Value.absent(),
          Value<int?> targetPower = const Value.absent()}) =>
      DataPointEntity(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        timestampMs: timestampMs ?? this.timestampMs,
        power: power ?? this.power,
        cadence: cadence.present ? cadence.value : this.cadence,
        heartRate: heartRate.present ? heartRate.value : this.heartRate,
        speed: speed.present ? speed.value : this.speed,
        distance: distance.present ? distance.value : this.distance,
        grade: grade.present ? grade.value : this.grade,
        targetPower: targetPower.present ? targetPower.value : this.targetPower,
      );
  DataPointEntity copyWithCompanion(DataPointsCompanion data) {
    return DataPointEntity(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      timestampMs:
          data.timestampMs.present ? data.timestampMs.value : this.timestampMs,
      power: data.power.present ? data.power.value : this.power,
      cadence: data.cadence.present ? data.cadence.value : this.cadence,
      heartRate: data.heartRate.present ? data.heartRate.value : this.heartRate,
      speed: data.speed.present ? data.speed.value : this.speed,
      distance: data.distance.present ? data.distance.value : this.distance,
      grade: data.grade.present ? data.grade.value : this.grade,
      targetPower:
          data.targetPower.present ? data.targetPower.value : this.targetPower,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DataPointEntity(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('timestampMs: $timestampMs, ')
          ..write('power: $power, ')
          ..write('cadence: $cadence, ')
          ..write('heartRate: $heartRate, ')
          ..write('speed: $speed, ')
          ..write('distance: $distance, ')
          ..write('grade: $grade, ')
          ..write('targetPower: $targetPower')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionId, timestampMs, power, cadence,
      heartRate, speed, distance, grade, targetPower);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DataPointEntity &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.timestampMs == this.timestampMs &&
          other.power == this.power &&
          other.cadence == this.cadence &&
          other.heartRate == this.heartRate &&
          other.speed == this.speed &&
          other.distance == this.distance &&
          other.grade == this.grade &&
          other.targetPower == this.targetPower);
}

class DataPointsCompanion extends UpdateCompanion<DataPointEntity> {
  final Value<int> id;
  final Value<String> sessionId;
  final Value<int> timestampMs;
  final Value<int> power;
  final Value<int?> cadence;
  final Value<int?> heartRate;
  final Value<double?> speed;
  final Value<int?> distance;
  final Value<double?> grade;
  final Value<int?> targetPower;
  const DataPointsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.timestampMs = const Value.absent(),
    this.power = const Value.absent(),
    this.cadence = const Value.absent(),
    this.heartRate = const Value.absent(),
    this.speed = const Value.absent(),
    this.distance = const Value.absent(),
    this.grade = const Value.absent(),
    this.targetPower = const Value.absent(),
  });
  DataPointsCompanion.insert({
    this.id = const Value.absent(),
    required String sessionId,
    required int timestampMs,
    required int power,
    this.cadence = const Value.absent(),
    this.heartRate = const Value.absent(),
    this.speed = const Value.absent(),
    this.distance = const Value.absent(),
    this.grade = const Value.absent(),
    this.targetPower = const Value.absent(),
  })  : sessionId = Value(sessionId),
        timestampMs = Value(timestampMs),
        power = Value(power);
  static Insertable<DataPointEntity> custom({
    Expression<int>? id,
    Expression<String>? sessionId,
    Expression<int>? timestampMs,
    Expression<int>? power,
    Expression<int>? cadence,
    Expression<int>? heartRate,
    Expression<double>? speed,
    Expression<int>? distance,
    Expression<double>? grade,
    Expression<int>? targetPower,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (timestampMs != null) 'timestamp_ms': timestampMs,
      if (power != null) 'power': power,
      if (cadence != null) 'cadence': cadence,
      if (heartRate != null) 'heart_rate': heartRate,
      if (speed != null) 'speed': speed,
      if (distance != null) 'distance': distance,
      if (grade != null) 'grade': grade,
      if (targetPower != null) 'target_power': targetPower,
    });
  }

  DataPointsCompanion copyWith(
      {Value<int>? id,
      Value<String>? sessionId,
      Value<int>? timestampMs,
      Value<int>? power,
      Value<int?>? cadence,
      Value<int?>? heartRate,
      Value<double?>? speed,
      Value<int?>? distance,
      Value<double?>? grade,
      Value<int?>? targetPower}) {
    return DataPointsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      timestampMs: timestampMs ?? this.timestampMs,
      power: power ?? this.power,
      cadence: cadence ?? this.cadence,
      heartRate: heartRate ?? this.heartRate,
      speed: speed ?? this.speed,
      distance: distance ?? this.distance,
      grade: grade ?? this.grade,
      targetPower: targetPower ?? this.targetPower,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (timestampMs.present) {
      map['timestamp_ms'] = Variable<int>(timestampMs.value);
    }
    if (power.present) {
      map['power'] = Variable<int>(power.value);
    }
    if (cadence.present) {
      map['cadence'] = Variable<int>(cadence.value);
    }
    if (heartRate.present) {
      map['heart_rate'] = Variable<int>(heartRate.value);
    }
    if (speed.present) {
      map['speed'] = Variable<double>(speed.value);
    }
    if (distance.present) {
      map['distance'] = Variable<int>(distance.value);
    }
    if (grade.present) {
      map['grade'] = Variable<double>(grade.value);
    }
    if (targetPower.present) {
      map['target_power'] = Variable<int>(targetPower.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DataPointsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('timestampMs: $timestampMs, ')
          ..write('power: $power, ')
          ..write('cadence: $cadence, ')
          ..write('heartRate: $heartRate, ')
          ..write('speed: $speed, ')
          ..write('distance: $distance, ')
          ..write('grade: $grade, ')
          ..write('targetPower: $targetPower')
          ..write(')'))
        .toString();
  }
}

class $CustomWorkoutsTable extends CustomWorkouts
    with TableInfo<$CustomWorkoutsTable, CustomWorkoutEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomWorkoutsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _workoutTypeMeta =
      const VerificationMeta('workoutType');
  @override
  late final GeneratedColumn<String> workoutType = GeneratedColumn<String>(
      'workout_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _intervalsJsonMeta =
      const VerificationMeta('intervalsJson');
  @override
  late final GeneratedColumn<String> intervalsJson = GeneratedColumn<String>(
      'intervals_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, description, workoutType, intervalsJson, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_workouts';
  @override
  VerificationContext validateIntegrity(
      Insertable<CustomWorkoutEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('workout_type')) {
      context.handle(
          _workoutTypeMeta,
          workoutType.isAcceptableOrUnknown(
              data['workout_type']!, _workoutTypeMeta));
    } else if (isInserting) {
      context.missing(_workoutTypeMeta);
    }
    if (data.containsKey('intervals_json')) {
      context.handle(
          _intervalsJsonMeta,
          intervalsJson.isAcceptableOrUnknown(
              data['intervals_json']!, _intervalsJsonMeta));
    } else if (isInserting) {
      context.missing(_intervalsJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomWorkoutEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomWorkoutEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      workoutType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}workout_type'])!,
      intervalsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}intervals_json'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $CustomWorkoutsTable createAlias(String alias) {
    return $CustomWorkoutsTable(attachedDatabase, alias);
  }
}

class CustomWorkoutEntity extends DataClass
    implements Insertable<CustomWorkoutEntity> {
  /// Workout ID (UUID)
  final String id;

  /// Name des Workouts
  final String name;

  /// Beschreibung
  final String description;

  /// Workout-Typ (enum als String)
  final String workoutType;

  /// Intervalle als JSON
  final String intervalsJson;

  /// Erstellungsdatum
  final DateTime createdAt;

  /// Letztes Update
  final DateTime? updatedAt;
  const CustomWorkoutEntity(
      {required this.id,
      required this.name,
      required this.description,
      required this.workoutType,
      required this.intervalsJson,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['workout_type'] = Variable<String>(workoutType);
    map['intervals_json'] = Variable<String>(intervalsJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  CustomWorkoutsCompanion toCompanion(bool nullToAbsent) {
    return CustomWorkoutsCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      workoutType: Value(workoutType),
      intervalsJson: Value(intervalsJson),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory CustomWorkoutEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomWorkoutEntity(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      workoutType: serializer.fromJson<String>(json['workoutType']),
      intervalsJson: serializer.fromJson<String>(json['intervalsJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'workoutType': serializer.toJson<String>(workoutType),
      'intervalsJson': serializer.toJson<String>(intervalsJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  CustomWorkoutEntity copyWith(
          {String? id,
          String? name,
          String? description,
          String? workoutType,
          String? intervalsJson,
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      CustomWorkoutEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        workoutType: workoutType ?? this.workoutType,
        intervalsJson: intervalsJson ?? this.intervalsJson,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  CustomWorkoutEntity copyWithCompanion(CustomWorkoutsCompanion data) {
    return CustomWorkoutEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      workoutType:
          data.workoutType.present ? data.workoutType.value : this.workoutType,
      intervalsJson: data.intervalsJson.present
          ? data.intervalsJson.value
          : this.intervalsJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomWorkoutEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('workoutType: $workoutType, ')
          ..write('intervalsJson: $intervalsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, description, workoutType, intervalsJson, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomWorkoutEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.workoutType == this.workoutType &&
          other.intervalsJson == this.intervalsJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CustomWorkoutsCompanion extends UpdateCompanion<CustomWorkoutEntity> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String> workoutType;
  final Value<String> intervalsJson;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const CustomWorkoutsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.workoutType = const Value.absent(),
    this.intervalsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomWorkoutsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    required String workoutType,
    required String intervalsJson,
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        workoutType = Value(workoutType),
        intervalsJson = Value(intervalsJson),
        createdAt = Value(createdAt);
  static Insertable<CustomWorkoutEntity> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? workoutType,
    Expression<String>? intervalsJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (workoutType != null) 'workout_type': workoutType,
      if (intervalsJson != null) 'intervals_json': intervalsJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomWorkoutsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? description,
      Value<String>? workoutType,
      Value<String>? intervalsJson,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return CustomWorkoutsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      workoutType: workoutType ?? this.workoutType,
      intervalsJson: intervalsJson ?? this.intervalsJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (workoutType.present) {
      map['workout_type'] = Variable<String>(workoutType.value);
    }
    if (intervalsJson.present) {
      map['intervals_json'] = Variable<String>(intervalsJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomWorkoutsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('workoutType: $workoutType, ')
          ..write('intervalsJson: $intervalsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GpxRoutesTable extends GpxRoutes
    with TableInfo<$GpxRoutesTable, GpxRouteEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GpxRoutesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pointsJsonMeta =
      const VerificationMeta('pointsJson');
  @override
  late final GeneratedColumn<String> pointsJson = GeneratedColumn<String>(
      'points_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalDistanceMeta =
      const VerificationMeta('totalDistance');
  @override
  late final GeneratedColumn<double> totalDistance = GeneratedColumn<double>(
      'total_distance', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _elevationGainMeta =
      const VerificationMeta('elevationGain');
  @override
  late final GeneratedColumn<double> elevationGain = GeneratedColumn<double>(
      'elevation_gain', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        pointsJson,
        totalDistance,
        elevationGain,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gpx_routes';
  @override
  VerificationContext validateIntegrity(Insertable<GpxRouteEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('points_json')) {
      context.handle(
          _pointsJsonMeta,
          pointsJson.isAcceptableOrUnknown(
              data['points_json']!, _pointsJsonMeta));
    } else if (isInserting) {
      context.missing(_pointsJsonMeta);
    }
    if (data.containsKey('total_distance')) {
      context.handle(
          _totalDistanceMeta,
          totalDistance.isAcceptableOrUnknown(
              data['total_distance']!, _totalDistanceMeta));
    } else if (isInserting) {
      context.missing(_totalDistanceMeta);
    }
    if (data.containsKey('elevation_gain')) {
      context.handle(
          _elevationGainMeta,
          elevationGain.isAcceptableOrUnknown(
              data['elevation_gain']!, _elevationGainMeta));
    } else if (isInserting) {
      context.missing(_elevationGainMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GpxRouteEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GpxRouteEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      pointsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}points_json'])!,
      totalDistance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_distance'])!,
      elevationGain: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}elevation_gain'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $GpxRoutesTable createAlias(String alias) {
    return $GpxRoutesTable(attachedDatabase, alias);
  }
}

class GpxRouteEntity extends DataClass implements Insertable<GpxRouteEntity> {
  /// Route ID (UUID)
  final String id;

  /// Name der Route
  final String name;

  /// Beschreibung
  final String? description;

  /// Punkte als JSON
  final String pointsJson;

  /// Gesamtdistanz in Metern
  final double totalDistance;

  /// Höhenmeter aufwärts
  final double elevationGain;

  /// Erstellungsdatum
  final DateTime createdAt;
  const GpxRouteEntity(
      {required this.id,
      required this.name,
      this.description,
      required this.pointsJson,
      required this.totalDistance,
      required this.elevationGain,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['points_json'] = Variable<String>(pointsJson);
    map['total_distance'] = Variable<double>(totalDistance);
    map['elevation_gain'] = Variable<double>(elevationGain);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GpxRoutesCompanion toCompanion(bool nullToAbsent) {
    return GpxRoutesCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      pointsJson: Value(pointsJson),
      totalDistance: Value(totalDistance),
      elevationGain: Value(elevationGain),
      createdAt: Value(createdAt),
    );
  }

  factory GpxRouteEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GpxRouteEntity(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      pointsJson: serializer.fromJson<String>(json['pointsJson']),
      totalDistance: serializer.fromJson<double>(json['totalDistance']),
      elevationGain: serializer.fromJson<double>(json['elevationGain']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'pointsJson': serializer.toJson<String>(pointsJson),
      'totalDistance': serializer.toJson<double>(totalDistance),
      'elevationGain': serializer.toJson<double>(elevationGain),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  GpxRouteEntity copyWith(
          {String? id,
          String? name,
          Value<String?> description = const Value.absent(),
          String? pointsJson,
          double? totalDistance,
          double? elevationGain,
          DateTime? createdAt}) =>
      GpxRouteEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        pointsJson: pointsJson ?? this.pointsJson,
        totalDistance: totalDistance ?? this.totalDistance,
        elevationGain: elevationGain ?? this.elevationGain,
        createdAt: createdAt ?? this.createdAt,
      );
  GpxRouteEntity copyWithCompanion(GpxRoutesCompanion data) {
    return GpxRouteEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      pointsJson:
          data.pointsJson.present ? data.pointsJson.value : this.pointsJson,
      totalDistance: data.totalDistance.present
          ? data.totalDistance.value
          : this.totalDistance,
      elevationGain: data.elevationGain.present
          ? data.elevationGain.value
          : this.elevationGain,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GpxRouteEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('pointsJson: $pointsJson, ')
          ..write('totalDistance: $totalDistance, ')
          ..write('elevationGain: $elevationGain, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, pointsJson,
      totalDistance, elevationGain, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GpxRouteEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.pointsJson == this.pointsJson &&
          other.totalDistance == this.totalDistance &&
          other.elevationGain == this.elevationGain &&
          other.createdAt == this.createdAt);
}

class GpxRoutesCompanion extends UpdateCompanion<GpxRouteEntity> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> pointsJson;
  final Value<double> totalDistance;
  final Value<double> elevationGain;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const GpxRoutesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.pointsJson = const Value.absent(),
    this.totalDistance = const Value.absent(),
    this.elevationGain = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GpxRoutesCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    required String pointsJson,
    required double totalDistance,
    required double elevationGain,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        pointsJson = Value(pointsJson),
        totalDistance = Value(totalDistance),
        elevationGain = Value(elevationGain),
        createdAt = Value(createdAt);
  static Insertable<GpxRouteEntity> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? pointsJson,
    Expression<double>? totalDistance,
    Expression<double>? elevationGain,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (pointsJson != null) 'points_json': pointsJson,
      if (totalDistance != null) 'total_distance': totalDistance,
      if (elevationGain != null) 'elevation_gain': elevationGain,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GpxRoutesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<String>? pointsJson,
      Value<double>? totalDistance,
      Value<double>? elevationGain,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return GpxRoutesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      pointsJson: pointsJson ?? this.pointsJson,
      totalDistance: totalDistance ?? this.totalDistance,
      elevationGain: elevationGain ?? this.elevationGain,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (pointsJson.present) {
      map['points_json'] = Variable<String>(pointsJson.value);
    }
    if (totalDistance.present) {
      map['total_distance'] = Variable<double>(totalDistance.value);
    }
    if (elevationGain.present) {
      map['elevation_gain'] = Variable<double>(elevationGain.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GpxRoutesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('pointsJson: $pointsJson, ')
          ..write('totalDistance: $totalDistance, ')
          ..write('elevationGain: $elevationGain, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PersonalRecordsTable extends PersonalRecords
    with TableInfo<$PersonalRecordsTable, PersonalRecordEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonalRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _recordTypeMeta =
      const VerificationMeta('recordType');
  @override
  late final GeneratedColumn<String> recordType = GeneratedColumn<String>(
      'record_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _powerWattsMeta =
      const VerificationMeta('powerWatts');
  @override
  late final GeneratedColumn<int> powerWatts = GeneratedColumn<int>(
      'power_watts', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _achievedAtMeta =
      const VerificationMeta('achievedAt');
  @override
  late final GeneratedColumn<DateTime> achievedAt = GeneratedColumn<DateTime>(
      'achieved_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
      'session_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _previousPowerWattsMeta =
      const VerificationMeta('previousPowerWatts');
  @override
  late final GeneratedColumn<int> previousPowerWatts = GeneratedColumn<int>(
      'previous_power_watts', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, recordType, powerWatts, achievedAt, sessionId, previousPowerWatts];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'personal_records';
  @override
  VerificationContext validateIntegrity(
      Insertable<PersonalRecordEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('record_type')) {
      context.handle(
          _recordTypeMeta,
          recordType.isAcceptableOrUnknown(
              data['record_type']!, _recordTypeMeta));
    } else if (isInserting) {
      context.missing(_recordTypeMeta);
    }
    if (data.containsKey('power_watts')) {
      context.handle(
          _powerWattsMeta,
          powerWatts.isAcceptableOrUnknown(
              data['power_watts']!, _powerWattsMeta));
    } else if (isInserting) {
      context.missing(_powerWattsMeta);
    }
    if (data.containsKey('achieved_at')) {
      context.handle(
          _achievedAtMeta,
          achievedAt.isAcceptableOrUnknown(
              data['achieved_at']!, _achievedAtMeta));
    } else if (isInserting) {
      context.missing(_achievedAtMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    }
    if (data.containsKey('previous_power_watts')) {
      context.handle(
          _previousPowerWattsMeta,
          previousPowerWatts.isAcceptableOrUnknown(
              data['previous_power_watts']!, _previousPowerWattsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PersonalRecordEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonalRecordEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      recordType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}record_type'])!,
      powerWatts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}power_watts'])!,
      achievedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}achieved_at'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id']),
      previousPowerWatts: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}previous_power_watts']),
    );
  }

  @override
  $PersonalRecordsTable createAlias(String alias) {
    return $PersonalRecordsTable(attachedDatabase, alias);
  }
}

class PersonalRecordEntity extends DataClass
    implements Insertable<PersonalRecordEntity> {
  /// Auto-increment ID
  final int id;

  /// Typ des PR (5s, 1min, 5min, 20min, etc.)
  final String recordType;

  /// Power in Watt
  final int powerWatts;

  /// Datum des PR
  final DateTime achievedAt;

  /// Session ID (optional, für Verlinkung)
  final String? sessionId;

  /// Vorheriger PR (für History)
  final int? previousPowerWatts;
  const PersonalRecordEntity(
      {required this.id,
      required this.recordType,
      required this.powerWatts,
      required this.achievedAt,
      this.sessionId,
      this.previousPowerWatts});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['record_type'] = Variable<String>(recordType);
    map['power_watts'] = Variable<int>(powerWatts);
    map['achieved_at'] = Variable<DateTime>(achievedAt);
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<String>(sessionId);
    }
    if (!nullToAbsent || previousPowerWatts != null) {
      map['previous_power_watts'] = Variable<int>(previousPowerWatts);
    }
    return map;
  }

  PersonalRecordsCompanion toCompanion(bool nullToAbsent) {
    return PersonalRecordsCompanion(
      id: Value(id),
      recordType: Value(recordType),
      powerWatts: Value(powerWatts),
      achievedAt: Value(achievedAt),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
      previousPowerWatts: previousPowerWatts == null && nullToAbsent
          ? const Value.absent()
          : Value(previousPowerWatts),
    );
  }

  factory PersonalRecordEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonalRecordEntity(
      id: serializer.fromJson<int>(json['id']),
      recordType: serializer.fromJson<String>(json['recordType']),
      powerWatts: serializer.fromJson<int>(json['powerWatts']),
      achievedAt: serializer.fromJson<DateTime>(json['achievedAt']),
      sessionId: serializer.fromJson<String?>(json['sessionId']),
      previousPowerWatts: serializer.fromJson<int?>(json['previousPowerWatts']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recordType': serializer.toJson<String>(recordType),
      'powerWatts': serializer.toJson<int>(powerWatts),
      'achievedAt': serializer.toJson<DateTime>(achievedAt),
      'sessionId': serializer.toJson<String?>(sessionId),
      'previousPowerWatts': serializer.toJson<int?>(previousPowerWatts),
    };
  }

  PersonalRecordEntity copyWith(
          {int? id,
          String? recordType,
          int? powerWatts,
          DateTime? achievedAt,
          Value<String?> sessionId = const Value.absent(),
          Value<int?> previousPowerWatts = const Value.absent()}) =>
      PersonalRecordEntity(
        id: id ?? this.id,
        recordType: recordType ?? this.recordType,
        powerWatts: powerWatts ?? this.powerWatts,
        achievedAt: achievedAt ?? this.achievedAt,
        sessionId: sessionId.present ? sessionId.value : this.sessionId,
        previousPowerWatts: previousPowerWatts.present
            ? previousPowerWatts.value
            : this.previousPowerWatts,
      );
  PersonalRecordEntity copyWithCompanion(PersonalRecordsCompanion data) {
    return PersonalRecordEntity(
      id: data.id.present ? data.id.value : this.id,
      recordType:
          data.recordType.present ? data.recordType.value : this.recordType,
      powerWatts:
          data.powerWatts.present ? data.powerWatts.value : this.powerWatts,
      achievedAt:
          data.achievedAt.present ? data.achievedAt.value : this.achievedAt,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      previousPowerWatts: data.previousPowerWatts.present
          ? data.previousPowerWatts.value
          : this.previousPowerWatts,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonalRecordEntity(')
          ..write('id: $id, ')
          ..write('recordType: $recordType, ')
          ..write('powerWatts: $powerWatts, ')
          ..write('achievedAt: $achievedAt, ')
          ..write('sessionId: $sessionId, ')
          ..write('previousPowerWatts: $previousPowerWatts')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, recordType, powerWatts, achievedAt, sessionId, previousPowerWatts);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonalRecordEntity &&
          other.id == this.id &&
          other.recordType == this.recordType &&
          other.powerWatts == this.powerWatts &&
          other.achievedAt == this.achievedAt &&
          other.sessionId == this.sessionId &&
          other.previousPowerWatts == this.previousPowerWatts);
}

class PersonalRecordsCompanion extends UpdateCompanion<PersonalRecordEntity> {
  final Value<int> id;
  final Value<String> recordType;
  final Value<int> powerWatts;
  final Value<DateTime> achievedAt;
  final Value<String?> sessionId;
  final Value<int?> previousPowerWatts;
  const PersonalRecordsCompanion({
    this.id = const Value.absent(),
    this.recordType = const Value.absent(),
    this.powerWatts = const Value.absent(),
    this.achievedAt = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.previousPowerWatts = const Value.absent(),
  });
  PersonalRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String recordType,
    required int powerWatts,
    required DateTime achievedAt,
    this.sessionId = const Value.absent(),
    this.previousPowerWatts = const Value.absent(),
  })  : recordType = Value(recordType),
        powerWatts = Value(powerWatts),
        achievedAt = Value(achievedAt);
  static Insertable<PersonalRecordEntity> custom({
    Expression<int>? id,
    Expression<String>? recordType,
    Expression<int>? powerWatts,
    Expression<DateTime>? achievedAt,
    Expression<String>? sessionId,
    Expression<int>? previousPowerWatts,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordType != null) 'record_type': recordType,
      if (powerWatts != null) 'power_watts': powerWatts,
      if (achievedAt != null) 'achieved_at': achievedAt,
      if (sessionId != null) 'session_id': sessionId,
      if (previousPowerWatts != null)
        'previous_power_watts': previousPowerWatts,
    });
  }

  PersonalRecordsCompanion copyWith(
      {Value<int>? id,
      Value<String>? recordType,
      Value<int>? powerWatts,
      Value<DateTime>? achievedAt,
      Value<String?>? sessionId,
      Value<int?>? previousPowerWatts}) {
    return PersonalRecordsCompanion(
      id: id ?? this.id,
      recordType: recordType ?? this.recordType,
      powerWatts: powerWatts ?? this.powerWatts,
      achievedAt: achievedAt ?? this.achievedAt,
      sessionId: sessionId ?? this.sessionId,
      previousPowerWatts: previousPowerWatts ?? this.previousPowerWatts,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recordType.present) {
      map['record_type'] = Variable<String>(recordType.value);
    }
    if (powerWatts.present) {
      map['power_watts'] = Variable<int>(powerWatts.value);
    }
    if (achievedAt.present) {
      map['achieved_at'] = Variable<DateTime>(achievedAt.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (previousPowerWatts.present) {
      map['previous_power_watts'] = Variable<int>(previousPowerWatts.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonalRecordsCompanion(')
          ..write('id: $id, ')
          ..write('recordType: $recordType, ')
          ..write('powerWatts: $powerWatts, ')
          ..write('achievedAt: $achievedAt, ')
          ..write('sessionId: $sessionId, ')
          ..write('previousPowerWatts: $previousPowerWatts')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TrainingSessionsTable trainingSessions =
      $TrainingSessionsTable(this);
  late final $DataPointsTable dataPoints = $DataPointsTable(this);
  late final $CustomWorkoutsTable customWorkouts = $CustomWorkoutsTable(this);
  late final $GpxRoutesTable gpxRoutes = $GpxRoutesTable(this);
  late final $PersonalRecordsTable personalRecords =
      $PersonalRecordsTable(this);
  late final SessionDao sessionDao = SessionDao(this as AppDatabase);
  late final WorkoutDao workoutDao = WorkoutDao(this as AppDatabase);
  late final GpxRouteDao gpxRouteDao = GpxRouteDao(this as AppDatabase);
  late final PersonalRecordDao personalRecordDao =
      PersonalRecordDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        trainingSessions,
        dataPoints,
        customWorkouts,
        gpxRoutes,
        personalRecords
      ];
}

typedef $$TrainingSessionsTableCreateCompanionBuilder
    = TrainingSessionsCompanion Function({
  required String id,
  required int startTime,
  Value<int?> endTime,
  required String sessionType,
  Value<String?> workoutId,
  Value<String?> routeId,
  Value<int> statsDurationMs,
  Value<int> statsAvgPower,
  Value<int> statsMaxPower,
  Value<int> statsNormalizedPower,
  Value<double> statsIntensityFactor,
  Value<int> statsTss,
  Value<int> statsTotalWork,
  Value<int?> statsAvgCadence,
  Value<int?> statsMaxCadence,
  Value<int?> statsAvgHeartRate,
  Value<int?> statsMaxHeartRate,
  Value<int?> statsCalories,
  Value<double?> statsDistance,
  Value<String> syncStatusJson,
  Value<int> rowid,
});
typedef $$TrainingSessionsTableUpdateCompanionBuilder
    = TrainingSessionsCompanion Function({
  Value<String> id,
  Value<int> startTime,
  Value<int?> endTime,
  Value<String> sessionType,
  Value<String?> workoutId,
  Value<String?> routeId,
  Value<int> statsDurationMs,
  Value<int> statsAvgPower,
  Value<int> statsMaxPower,
  Value<int> statsNormalizedPower,
  Value<double> statsIntensityFactor,
  Value<int> statsTss,
  Value<int> statsTotalWork,
  Value<int?> statsAvgCadence,
  Value<int?> statsMaxCadence,
  Value<int?> statsAvgHeartRate,
  Value<int?> statsMaxHeartRate,
  Value<int?> statsCalories,
  Value<double?> statsDistance,
  Value<String> syncStatusJson,
  Value<int> rowid,
});

class $$TrainingSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TrainingSessionsTable,
    TrainingSessionEntity,
    $$TrainingSessionsTableFilterComposer,
    $$TrainingSessionsTableOrderingComposer,
    $$TrainingSessionsTableCreateCompanionBuilder,
    $$TrainingSessionsTableUpdateCompanionBuilder> {
  $$TrainingSessionsTableTableManager(
      _$AppDatabase db, $TrainingSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$TrainingSessionsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$TrainingSessionsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> startTime = const Value.absent(),
            Value<int?> endTime = const Value.absent(),
            Value<String> sessionType = const Value.absent(),
            Value<String?> workoutId = const Value.absent(),
            Value<String?> routeId = const Value.absent(),
            Value<int> statsDurationMs = const Value.absent(),
            Value<int> statsAvgPower = const Value.absent(),
            Value<int> statsMaxPower = const Value.absent(),
            Value<int> statsNormalizedPower = const Value.absent(),
            Value<double> statsIntensityFactor = const Value.absent(),
            Value<int> statsTss = const Value.absent(),
            Value<int> statsTotalWork = const Value.absent(),
            Value<int?> statsAvgCadence = const Value.absent(),
            Value<int?> statsMaxCadence = const Value.absent(),
            Value<int?> statsAvgHeartRate = const Value.absent(),
            Value<int?> statsMaxHeartRate = const Value.absent(),
            Value<int?> statsCalories = const Value.absent(),
            Value<double?> statsDistance = const Value.absent(),
            Value<String> syncStatusJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TrainingSessionsCompanion(
            id: id,
            startTime: startTime,
            endTime: endTime,
            sessionType: sessionType,
            workoutId: workoutId,
            routeId: routeId,
            statsDurationMs: statsDurationMs,
            statsAvgPower: statsAvgPower,
            statsMaxPower: statsMaxPower,
            statsNormalizedPower: statsNormalizedPower,
            statsIntensityFactor: statsIntensityFactor,
            statsTss: statsTss,
            statsTotalWork: statsTotalWork,
            statsAvgCadence: statsAvgCadence,
            statsMaxCadence: statsMaxCadence,
            statsAvgHeartRate: statsAvgHeartRate,
            statsMaxHeartRate: statsMaxHeartRate,
            statsCalories: statsCalories,
            statsDistance: statsDistance,
            syncStatusJson: syncStatusJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required int startTime,
            Value<int?> endTime = const Value.absent(),
            required String sessionType,
            Value<String?> workoutId = const Value.absent(),
            Value<String?> routeId = const Value.absent(),
            Value<int> statsDurationMs = const Value.absent(),
            Value<int> statsAvgPower = const Value.absent(),
            Value<int> statsMaxPower = const Value.absent(),
            Value<int> statsNormalizedPower = const Value.absent(),
            Value<double> statsIntensityFactor = const Value.absent(),
            Value<int> statsTss = const Value.absent(),
            Value<int> statsTotalWork = const Value.absent(),
            Value<int?> statsAvgCadence = const Value.absent(),
            Value<int?> statsMaxCadence = const Value.absent(),
            Value<int?> statsAvgHeartRate = const Value.absent(),
            Value<int?> statsMaxHeartRate = const Value.absent(),
            Value<int?> statsCalories = const Value.absent(),
            Value<double?> statsDistance = const Value.absent(),
            Value<String> syncStatusJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TrainingSessionsCompanion.insert(
            id: id,
            startTime: startTime,
            endTime: endTime,
            sessionType: sessionType,
            workoutId: workoutId,
            routeId: routeId,
            statsDurationMs: statsDurationMs,
            statsAvgPower: statsAvgPower,
            statsMaxPower: statsMaxPower,
            statsNormalizedPower: statsNormalizedPower,
            statsIntensityFactor: statsIntensityFactor,
            statsTss: statsTss,
            statsTotalWork: statsTotalWork,
            statsAvgCadence: statsAvgCadence,
            statsMaxCadence: statsMaxCadence,
            statsAvgHeartRate: statsAvgHeartRate,
            statsMaxHeartRate: statsMaxHeartRate,
            statsCalories: statsCalories,
            statsDistance: statsDistance,
            syncStatusJson: syncStatusJson,
            rowid: rowid,
          ),
        ));
}

class $$TrainingSessionsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $TrainingSessionsTable> {
  $$TrainingSessionsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get startTime => $state.composableBuilder(
      column: $state.table.startTime,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get endTime => $state.composableBuilder(
      column: $state.table.endTime,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get sessionType => $state.composableBuilder(
      column: $state.table.sessionType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get workoutId => $state.composableBuilder(
      column: $state.table.workoutId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get routeId => $state.composableBuilder(
      column: $state.table.routeId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get statsDurationMs => $state.composableBuilder(
      column: $state.table.statsDurationMs,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get statsAvgPower => $state.composableBuilder(
      column: $state.table.statsAvgPower,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get statsMaxPower => $state.composableBuilder(
      column: $state.table.statsMaxPower,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get statsNormalizedPower => $state.composableBuilder(
      column: $state.table.statsNormalizedPower,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get statsIntensityFactor => $state.composableBuilder(
      column: $state.table.statsIntensityFactor,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get statsTss => $state.composableBuilder(
      column: $state.table.statsTss,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get statsTotalWork => $state.composableBuilder(
      column: $state.table.statsTotalWork,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get statsAvgCadence => $state.composableBuilder(
      column: $state.table.statsAvgCadence,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get statsMaxCadence => $state.composableBuilder(
      column: $state.table.statsMaxCadence,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get statsAvgHeartRate => $state.composableBuilder(
      column: $state.table.statsAvgHeartRate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get statsMaxHeartRate => $state.composableBuilder(
      column: $state.table.statsMaxHeartRate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get statsCalories => $state.composableBuilder(
      column: $state.table.statsCalories,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get statsDistance => $state.composableBuilder(
      column: $state.table.statsDistance,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get syncStatusJson => $state.composableBuilder(
      column: $state.table.syncStatusJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter dataPointsRefs(
      ComposableFilter Function($$DataPointsTableFilterComposer f) f) {
    final $$DataPointsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.dataPoints,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder, parentComposers) =>
            $$DataPointsTableFilterComposer(ComposerState($state.db,
                $state.db.dataPoints, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$TrainingSessionsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $TrainingSessionsTable> {
  $$TrainingSessionsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get startTime => $state.composableBuilder(
      column: $state.table.startTime,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get endTime => $state.composableBuilder(
      column: $state.table.endTime,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get sessionType => $state.composableBuilder(
      column: $state.table.sessionType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get workoutId => $state.composableBuilder(
      column: $state.table.workoutId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get routeId => $state.composableBuilder(
      column: $state.table.routeId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get statsDurationMs => $state.composableBuilder(
      column: $state.table.statsDurationMs,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get statsAvgPower => $state.composableBuilder(
      column: $state.table.statsAvgPower,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get statsMaxPower => $state.composableBuilder(
      column: $state.table.statsMaxPower,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get statsNormalizedPower => $state.composableBuilder(
      column: $state.table.statsNormalizedPower,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get statsIntensityFactor => $state.composableBuilder(
      column: $state.table.statsIntensityFactor,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get statsTss => $state.composableBuilder(
      column: $state.table.statsTss,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get statsTotalWork => $state.composableBuilder(
      column: $state.table.statsTotalWork,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get statsAvgCadence => $state.composableBuilder(
      column: $state.table.statsAvgCadence,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get statsMaxCadence => $state.composableBuilder(
      column: $state.table.statsMaxCadence,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get statsAvgHeartRate => $state.composableBuilder(
      column: $state.table.statsAvgHeartRate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get statsMaxHeartRate => $state.composableBuilder(
      column: $state.table.statsMaxHeartRate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get statsCalories => $state.composableBuilder(
      column: $state.table.statsCalories,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get statsDistance => $state.composableBuilder(
      column: $state.table.statsDistance,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get syncStatusJson => $state.composableBuilder(
      column: $state.table.syncStatusJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$DataPointsTableCreateCompanionBuilder = DataPointsCompanion Function({
  Value<int> id,
  required String sessionId,
  required int timestampMs,
  required int power,
  Value<int?> cadence,
  Value<int?> heartRate,
  Value<double?> speed,
  Value<int?> distance,
  Value<double?> grade,
  Value<int?> targetPower,
});
typedef $$DataPointsTableUpdateCompanionBuilder = DataPointsCompanion Function({
  Value<int> id,
  Value<String> sessionId,
  Value<int> timestampMs,
  Value<int> power,
  Value<int?> cadence,
  Value<int?> heartRate,
  Value<double?> speed,
  Value<int?> distance,
  Value<double?> grade,
  Value<int?> targetPower,
});

class $$DataPointsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DataPointsTable,
    DataPointEntity,
    $$DataPointsTableFilterComposer,
    $$DataPointsTableOrderingComposer,
    $$DataPointsTableCreateCompanionBuilder,
    $$DataPointsTableUpdateCompanionBuilder> {
  $$DataPointsTableTableManager(_$AppDatabase db, $DataPointsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$DataPointsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$DataPointsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> sessionId = const Value.absent(),
            Value<int> timestampMs = const Value.absent(),
            Value<int> power = const Value.absent(),
            Value<int?> cadence = const Value.absent(),
            Value<int?> heartRate = const Value.absent(),
            Value<double?> speed = const Value.absent(),
            Value<int?> distance = const Value.absent(),
            Value<double?> grade = const Value.absent(),
            Value<int?> targetPower = const Value.absent(),
          }) =>
              DataPointsCompanion(
            id: id,
            sessionId: sessionId,
            timestampMs: timestampMs,
            power: power,
            cadence: cadence,
            heartRate: heartRate,
            speed: speed,
            distance: distance,
            grade: grade,
            targetPower: targetPower,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String sessionId,
            required int timestampMs,
            required int power,
            Value<int?> cadence = const Value.absent(),
            Value<int?> heartRate = const Value.absent(),
            Value<double?> speed = const Value.absent(),
            Value<int?> distance = const Value.absent(),
            Value<double?> grade = const Value.absent(),
            Value<int?> targetPower = const Value.absent(),
          }) =>
              DataPointsCompanion.insert(
            id: id,
            sessionId: sessionId,
            timestampMs: timestampMs,
            power: power,
            cadence: cadence,
            heartRate: heartRate,
            speed: speed,
            distance: distance,
            grade: grade,
            targetPower: targetPower,
          ),
        ));
}

class $$DataPointsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $DataPointsTable> {
  $$DataPointsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get timestampMs => $state.composableBuilder(
      column: $state.table.timestampMs,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get power => $state.composableBuilder(
      column: $state.table.power,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get cadence => $state.composableBuilder(
      column: $state.table.cadence,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get heartRate => $state.composableBuilder(
      column: $state.table.heartRate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get speed => $state.composableBuilder(
      column: $state.table.speed,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get distance => $state.composableBuilder(
      column: $state.table.distance,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get grade => $state.composableBuilder(
      column: $state.table.grade,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get targetPower => $state.composableBuilder(
      column: $state.table.targetPower,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$TrainingSessionsTableFilterComposer get sessionId {
    final $$TrainingSessionsTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.sessionId,
            referencedTable: $state.db.trainingSessions,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$TrainingSessionsTableFilterComposer(ComposerState($state.db,
                    $state.db.trainingSessions, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$DataPointsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $DataPointsTable> {
  $$DataPointsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get timestampMs => $state.composableBuilder(
      column: $state.table.timestampMs,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get power => $state.composableBuilder(
      column: $state.table.power,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get cadence => $state.composableBuilder(
      column: $state.table.cadence,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get heartRate => $state.composableBuilder(
      column: $state.table.heartRate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get speed => $state.composableBuilder(
      column: $state.table.speed,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get distance => $state.composableBuilder(
      column: $state.table.distance,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get grade => $state.composableBuilder(
      column: $state.table.grade,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get targetPower => $state.composableBuilder(
      column: $state.table.targetPower,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$TrainingSessionsTableOrderingComposer get sessionId {
    final $$TrainingSessionsTableOrderingComposer composer = $state
        .composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.sessionId,
            referencedTable: $state.db.trainingSessions,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$TrainingSessionsTableOrderingComposer(ComposerState($state.db,
                    $state.db.trainingSessions, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$CustomWorkoutsTableCreateCompanionBuilder = CustomWorkoutsCompanion
    Function({
  required String id,
  required String name,
  Value<String> description,
  required String workoutType,
  required String intervalsJson,
  required DateTime createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$CustomWorkoutsTableUpdateCompanionBuilder = CustomWorkoutsCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> description,
  Value<String> workoutType,
  Value<String> intervalsJson,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$CustomWorkoutsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomWorkoutsTable,
    CustomWorkoutEntity,
    $$CustomWorkoutsTableFilterComposer,
    $$CustomWorkoutsTableOrderingComposer,
    $$CustomWorkoutsTableCreateCompanionBuilder,
    $$CustomWorkoutsTableUpdateCompanionBuilder> {
  $$CustomWorkoutsTableTableManager(
      _$AppDatabase db, $CustomWorkoutsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CustomWorkoutsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CustomWorkoutsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> workoutType = const Value.absent(),
            Value<String> intervalsJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomWorkoutsCompanion(
            id: id,
            name: name,
            description: description,
            workoutType: workoutType,
            intervalsJson: intervalsJson,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String> description = const Value.absent(),
            required String workoutType,
            required String intervalsJson,
            required DateTime createdAt,
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomWorkoutsCompanion.insert(
            id: id,
            name: name,
            description: description,
            workoutType: workoutType,
            intervalsJson: intervalsJson,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
        ));
}

class $$CustomWorkoutsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CustomWorkoutsTable> {
  $$CustomWorkoutsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get workoutType => $state.composableBuilder(
      column: $state.table.workoutType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get intervalsJson => $state.composableBuilder(
      column: $state.table.intervalsJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$CustomWorkoutsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CustomWorkoutsTable> {
  $$CustomWorkoutsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get workoutType => $state.composableBuilder(
      column: $state.table.workoutType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get intervalsJson => $state.composableBuilder(
      column: $state.table.intervalsJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$GpxRoutesTableCreateCompanionBuilder = GpxRoutesCompanion Function({
  required String id,
  required String name,
  Value<String?> description,
  required String pointsJson,
  required double totalDistance,
  required double elevationGain,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$GpxRoutesTableUpdateCompanionBuilder = GpxRoutesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> description,
  Value<String> pointsJson,
  Value<double> totalDistance,
  Value<double> elevationGain,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$GpxRoutesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GpxRoutesTable,
    GpxRouteEntity,
    $$GpxRoutesTableFilterComposer,
    $$GpxRoutesTableOrderingComposer,
    $$GpxRoutesTableCreateCompanionBuilder,
    $$GpxRoutesTableUpdateCompanionBuilder> {
  $$GpxRoutesTableTableManager(_$AppDatabase db, $GpxRoutesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$GpxRoutesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$GpxRoutesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> pointsJson = const Value.absent(),
            Value<double> totalDistance = const Value.absent(),
            Value<double> elevationGain = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GpxRoutesCompanion(
            id: id,
            name: name,
            description: description,
            pointsJson: pointsJson,
            totalDistance: totalDistance,
            elevationGain: elevationGain,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> description = const Value.absent(),
            required String pointsJson,
            required double totalDistance,
            required double elevationGain,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              GpxRoutesCompanion.insert(
            id: id,
            name: name,
            description: description,
            pointsJson: pointsJson,
            totalDistance: totalDistance,
            elevationGain: elevationGain,
            createdAt: createdAt,
            rowid: rowid,
          ),
        ));
}

class $$GpxRoutesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $GpxRoutesTable> {
  $$GpxRoutesTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get pointsJson => $state.composableBuilder(
      column: $state.table.pointsJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get totalDistance => $state.composableBuilder(
      column: $state.table.totalDistance,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get elevationGain => $state.composableBuilder(
      column: $state.table.elevationGain,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$GpxRoutesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $GpxRoutesTable> {
  $$GpxRoutesTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get pointsJson => $state.composableBuilder(
      column: $state.table.pointsJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get totalDistance => $state.composableBuilder(
      column: $state.table.totalDistance,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get elevationGain => $state.composableBuilder(
      column: $state.table.elevationGain,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$PersonalRecordsTableCreateCompanionBuilder = PersonalRecordsCompanion
    Function({
  Value<int> id,
  required String recordType,
  required int powerWatts,
  required DateTime achievedAt,
  Value<String?> sessionId,
  Value<int?> previousPowerWatts,
});
typedef $$PersonalRecordsTableUpdateCompanionBuilder = PersonalRecordsCompanion
    Function({
  Value<int> id,
  Value<String> recordType,
  Value<int> powerWatts,
  Value<DateTime> achievedAt,
  Value<String?> sessionId,
  Value<int?> previousPowerWatts,
});

class $$PersonalRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PersonalRecordsTable,
    PersonalRecordEntity,
    $$PersonalRecordsTableFilterComposer,
    $$PersonalRecordsTableOrderingComposer,
    $$PersonalRecordsTableCreateCompanionBuilder,
    $$PersonalRecordsTableUpdateCompanionBuilder> {
  $$PersonalRecordsTableTableManager(
      _$AppDatabase db, $PersonalRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PersonalRecordsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PersonalRecordsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> recordType = const Value.absent(),
            Value<int> powerWatts = const Value.absent(),
            Value<DateTime> achievedAt = const Value.absent(),
            Value<String?> sessionId = const Value.absent(),
            Value<int?> previousPowerWatts = const Value.absent(),
          }) =>
              PersonalRecordsCompanion(
            id: id,
            recordType: recordType,
            powerWatts: powerWatts,
            achievedAt: achievedAt,
            sessionId: sessionId,
            previousPowerWatts: previousPowerWatts,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String recordType,
            required int powerWatts,
            required DateTime achievedAt,
            Value<String?> sessionId = const Value.absent(),
            Value<int?> previousPowerWatts = const Value.absent(),
          }) =>
              PersonalRecordsCompanion.insert(
            id: id,
            recordType: recordType,
            powerWatts: powerWatts,
            achievedAt: achievedAt,
            sessionId: sessionId,
            previousPowerWatts: previousPowerWatts,
          ),
        ));
}

class $$PersonalRecordsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PersonalRecordsTable> {
  $$PersonalRecordsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get recordType => $state.composableBuilder(
      column: $state.table.recordType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get powerWatts => $state.composableBuilder(
      column: $state.table.powerWatts,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get achievedAt => $state.composableBuilder(
      column: $state.table.achievedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get sessionId => $state.composableBuilder(
      column: $state.table.sessionId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get previousPowerWatts => $state.composableBuilder(
      column: $state.table.previousPowerWatts,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$PersonalRecordsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PersonalRecordsTable> {
  $$PersonalRecordsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get recordType => $state.composableBuilder(
      column: $state.table.recordType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get powerWatts => $state.composableBuilder(
      column: $state.table.powerWatts,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get achievedAt => $state.composableBuilder(
      column: $state.table.achievedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get sessionId => $state.composableBuilder(
      column: $state.table.sessionId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get previousPowerWatts => $state.composableBuilder(
      column: $state.table.previousPowerWatts,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TrainingSessionsTableTableManager get trainingSessions =>
      $$TrainingSessionsTableTableManager(_db, _db.trainingSessions);
  $$DataPointsTableTableManager get dataPoints =>
      $$DataPointsTableTableManager(_db, _db.dataPoints);
  $$CustomWorkoutsTableTableManager get customWorkouts =>
      $$CustomWorkoutsTableTableManager(_db, _db.customWorkouts);
  $$GpxRoutesTableTableManager get gpxRoutes =>
      $$GpxRoutesTableTableManager(_db, _db.gpxRoutes);
  $$PersonalRecordsTableTableManager get personalRecords =>
      $$PersonalRecordsTableTableManager(_db, _db.personalRecords);
}
