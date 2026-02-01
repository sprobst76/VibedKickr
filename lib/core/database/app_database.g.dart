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

class $StrengthExercisesTable extends StrengthExercises
    with TableInfo<$StrengthExercisesTable, StrengthExerciseEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StrengthExercisesTable(this.attachedDatabase, [this._alias]);
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
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _primaryMusclesJsonMeta =
      const VerificationMeta('primaryMusclesJson');
  @override
  late final GeneratedColumn<String> primaryMusclesJson =
      GeneratedColumn<String>('primary_muscles_json', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _secondaryMusclesJsonMeta =
      const VerificationMeta('secondaryMusclesJson');
  @override
  late final GeneratedColumn<String> secondaryMusclesJson =
      GeneratedColumn<String>('secondary_muscles_json', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _equipmentMeta =
      const VerificationMeta('equipment');
  @override
  late final GeneratedColumn<String> equipment = GeneratedColumn<String>(
      'equipment', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _formCuesMeta =
      const VerificationMeta('formCues');
  @override
  late final GeneratedColumn<String> formCues = GeneratedColumn<String>(
      'form_cues', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _videoUrlMeta =
      const VerificationMeta('videoUrl');
  @override
  late final GeneratedColumn<String> videoUrl = GeneratedColumn<String>(
      'video_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _difficultyMeta =
      const VerificationMeta('difficulty');
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
      'difficulty', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isCompoundMeta =
      const VerificationMeta('isCompound');
  @override
  late final GeneratedColumn<bool> isCompound = GeneratedColumn<bool>(
      'is_compound', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_compound" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _minimumAgeMeta =
      const VerificationMeta('minimumAge');
  @override
  late final GeneratedColumn<int> minimumAge = GeneratedColumn<int>(
      'minimum_age', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(18));
  static const VerificationMeta _maximumAgeMeta =
      const VerificationMeta('maximumAge');
  @override
  late final GeneratedColumn<int> maximumAge = GeneratedColumn<int>(
      'maximum_age', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _requiresModification50PlusMeta =
      const VerificationMeta('requiresModification50Plus');
  @override
  late final GeneratedColumn<bool> requiresModification50Plus =
      GeneratedColumn<bool>('requires_modification50_plus', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("requires_modification50_plus" IN (0, 1))'),
          defaultValue: const Constant(false));
  static const VerificationMeta _modification50PlusNotesMeta =
      const VerificationMeta('modification50PlusNotes');
  @override
  late final GeneratedColumn<String> modification50PlusNotes =
      GeneratedColumn<String>('modification50_plus_notes', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        primaryMusclesJson,
        secondaryMusclesJson,
        equipment,
        formCues,
        videoUrl,
        difficulty,
        isCompound,
        minimumAge,
        maximumAge,
        requiresModification50Plus,
        modification50PlusNotes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'strength_exercises';
  @override
  VerificationContext validateIntegrity(
      Insertable<StrengthExerciseEntity> instance,
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
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('primary_muscles_json')) {
      context.handle(
          _primaryMusclesJsonMeta,
          primaryMusclesJson.isAcceptableOrUnknown(
              data['primary_muscles_json']!, _primaryMusclesJsonMeta));
    } else if (isInserting) {
      context.missing(_primaryMusclesJsonMeta);
    }
    if (data.containsKey('secondary_muscles_json')) {
      context.handle(
          _secondaryMusclesJsonMeta,
          secondaryMusclesJson.isAcceptableOrUnknown(
              data['secondary_muscles_json']!, _secondaryMusclesJsonMeta));
    } else if (isInserting) {
      context.missing(_secondaryMusclesJsonMeta);
    }
    if (data.containsKey('equipment')) {
      context.handle(_equipmentMeta,
          equipment.isAcceptableOrUnknown(data['equipment']!, _equipmentMeta));
    } else if (isInserting) {
      context.missing(_equipmentMeta);
    }
    if (data.containsKey('form_cues')) {
      context.handle(_formCuesMeta,
          formCues.isAcceptableOrUnknown(data['form_cues']!, _formCuesMeta));
    } else if (isInserting) {
      context.missing(_formCuesMeta);
    }
    if (data.containsKey('video_url')) {
      context.handle(_videoUrlMeta,
          videoUrl.isAcceptableOrUnknown(data['video_url']!, _videoUrlMeta));
    }
    if (data.containsKey('difficulty')) {
      context.handle(
          _difficultyMeta,
          difficulty.isAcceptableOrUnknown(
              data['difficulty']!, _difficultyMeta));
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('is_compound')) {
      context.handle(
          _isCompoundMeta,
          isCompound.isAcceptableOrUnknown(
              data['is_compound']!, _isCompoundMeta));
    }
    if (data.containsKey('minimum_age')) {
      context.handle(
          _minimumAgeMeta,
          minimumAge.isAcceptableOrUnknown(
              data['minimum_age']!, _minimumAgeMeta));
    }
    if (data.containsKey('maximum_age')) {
      context.handle(
          _maximumAgeMeta,
          maximumAge.isAcceptableOrUnknown(
              data['maximum_age']!, _maximumAgeMeta));
    }
    if (data.containsKey('requires_modification50_plus')) {
      context.handle(
          _requiresModification50PlusMeta,
          requiresModification50Plus.isAcceptableOrUnknown(
              data['requires_modification50_plus']!,
              _requiresModification50PlusMeta));
    }
    if (data.containsKey('modification50_plus_notes')) {
      context.handle(
          _modification50PlusNotesMeta,
          modification50PlusNotes.isAcceptableOrUnknown(
              data['modification50_plus_notes']!,
              _modification50PlusNotesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StrengthExerciseEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StrengthExerciseEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      primaryMusclesJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}primary_muscles_json'])!,
      secondaryMusclesJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}secondary_muscles_json'])!,
      equipment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}equipment'])!,
      formCues: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}form_cues'])!,
      videoUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}video_url']),
      difficulty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}difficulty'])!,
      isCompound: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_compound'])!,
      minimumAge: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}minimum_age'])!,
      maximumAge: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}maximum_age']),
      requiresModification50Plus: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}requires_modification50_plus'])!,
      modification50PlusNotes: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}modification50_plus_notes']),
    );
  }

  @override
  $StrengthExercisesTable createAlias(String alias) {
    return $StrengthExercisesTable(attachedDatabase, alias);
  }
}

class StrengthExerciseEntity extends DataClass
    implements Insertable<StrengthExerciseEntity> {
  /// Eindeutige ID
  final String id;

  /// Name der Übung
  final String name;

  /// Beschreibung
  final String description;

  /// Primäre Muskelgruppen als JSON Array
  final String primaryMusclesJson;

  /// Sekundäre Muskelgruppen als JSON Array
  final String secondaryMusclesJson;

  /// Equipment-Typ
  final String equipment;

  /// Form-Hinweise
  final String formCues;

  /// Video URL (optional)
  final String? videoUrl;

  /// Schwierigkeitsgrad
  final String difficulty;

  /// Ist es eine Compound-Übung?
  final bool isCompound;

  /// Minimum Alter für diese Übung
  final int minimumAge;

  /// Maximum Alter (optional)
  final int? maximumAge;

  /// Benötigt Modifikation für 50+?
  final bool requiresModification50Plus;

  /// Modifikations-Notizen für 50+
  final String? modification50PlusNotes;
  const StrengthExerciseEntity(
      {required this.id,
      required this.name,
      required this.description,
      required this.primaryMusclesJson,
      required this.secondaryMusclesJson,
      required this.equipment,
      required this.formCues,
      this.videoUrl,
      required this.difficulty,
      required this.isCompound,
      required this.minimumAge,
      this.maximumAge,
      required this.requiresModification50Plus,
      this.modification50PlusNotes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['primary_muscles_json'] = Variable<String>(primaryMusclesJson);
    map['secondary_muscles_json'] = Variable<String>(secondaryMusclesJson);
    map['equipment'] = Variable<String>(equipment);
    map['form_cues'] = Variable<String>(formCues);
    if (!nullToAbsent || videoUrl != null) {
      map['video_url'] = Variable<String>(videoUrl);
    }
    map['difficulty'] = Variable<String>(difficulty);
    map['is_compound'] = Variable<bool>(isCompound);
    map['minimum_age'] = Variable<int>(minimumAge);
    if (!nullToAbsent || maximumAge != null) {
      map['maximum_age'] = Variable<int>(maximumAge);
    }
    map['requires_modification50_plus'] =
        Variable<bool>(requiresModification50Plus);
    if (!nullToAbsent || modification50PlusNotes != null) {
      map['modification50_plus_notes'] =
          Variable<String>(modification50PlusNotes);
    }
    return map;
  }

  StrengthExercisesCompanion toCompanion(bool nullToAbsent) {
    return StrengthExercisesCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      primaryMusclesJson: Value(primaryMusclesJson),
      secondaryMusclesJson: Value(secondaryMusclesJson),
      equipment: Value(equipment),
      formCues: Value(formCues),
      videoUrl: videoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(videoUrl),
      difficulty: Value(difficulty),
      isCompound: Value(isCompound),
      minimumAge: Value(minimumAge),
      maximumAge: maximumAge == null && nullToAbsent
          ? const Value.absent()
          : Value(maximumAge),
      requiresModification50Plus: Value(requiresModification50Plus),
      modification50PlusNotes: modification50PlusNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(modification50PlusNotes),
    );
  }

  factory StrengthExerciseEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StrengthExerciseEntity(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      primaryMusclesJson:
          serializer.fromJson<String>(json['primaryMusclesJson']),
      secondaryMusclesJson:
          serializer.fromJson<String>(json['secondaryMusclesJson']),
      equipment: serializer.fromJson<String>(json['equipment']),
      formCues: serializer.fromJson<String>(json['formCues']),
      videoUrl: serializer.fromJson<String?>(json['videoUrl']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      isCompound: serializer.fromJson<bool>(json['isCompound']),
      minimumAge: serializer.fromJson<int>(json['minimumAge']),
      maximumAge: serializer.fromJson<int?>(json['maximumAge']),
      requiresModification50Plus:
          serializer.fromJson<bool>(json['requiresModification50Plus']),
      modification50PlusNotes:
          serializer.fromJson<String?>(json['modification50PlusNotes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'primaryMusclesJson': serializer.toJson<String>(primaryMusclesJson),
      'secondaryMusclesJson': serializer.toJson<String>(secondaryMusclesJson),
      'equipment': serializer.toJson<String>(equipment),
      'formCues': serializer.toJson<String>(formCues),
      'videoUrl': serializer.toJson<String?>(videoUrl),
      'difficulty': serializer.toJson<String>(difficulty),
      'isCompound': serializer.toJson<bool>(isCompound),
      'minimumAge': serializer.toJson<int>(minimumAge),
      'maximumAge': serializer.toJson<int?>(maximumAge),
      'requiresModification50Plus':
          serializer.toJson<bool>(requiresModification50Plus),
      'modification50PlusNotes':
          serializer.toJson<String?>(modification50PlusNotes),
    };
  }

  StrengthExerciseEntity copyWith(
          {String? id,
          String? name,
          String? description,
          String? primaryMusclesJson,
          String? secondaryMusclesJson,
          String? equipment,
          String? formCues,
          Value<String?> videoUrl = const Value.absent(),
          String? difficulty,
          bool? isCompound,
          int? minimumAge,
          Value<int?> maximumAge = const Value.absent(),
          bool? requiresModification50Plus,
          Value<String?> modification50PlusNotes = const Value.absent()}) =>
      StrengthExerciseEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        primaryMusclesJson: primaryMusclesJson ?? this.primaryMusclesJson,
        secondaryMusclesJson: secondaryMusclesJson ?? this.secondaryMusclesJson,
        equipment: equipment ?? this.equipment,
        formCues: formCues ?? this.formCues,
        videoUrl: videoUrl.present ? videoUrl.value : this.videoUrl,
        difficulty: difficulty ?? this.difficulty,
        isCompound: isCompound ?? this.isCompound,
        minimumAge: minimumAge ?? this.minimumAge,
        maximumAge: maximumAge.present ? maximumAge.value : this.maximumAge,
        requiresModification50Plus:
            requiresModification50Plus ?? this.requiresModification50Plus,
        modification50PlusNotes: modification50PlusNotes.present
            ? modification50PlusNotes.value
            : this.modification50PlusNotes,
      );
  StrengthExerciseEntity copyWithCompanion(StrengthExercisesCompanion data) {
    return StrengthExerciseEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      primaryMusclesJson: data.primaryMusclesJson.present
          ? data.primaryMusclesJson.value
          : this.primaryMusclesJson,
      secondaryMusclesJson: data.secondaryMusclesJson.present
          ? data.secondaryMusclesJson.value
          : this.secondaryMusclesJson,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
      formCues: data.formCues.present ? data.formCues.value : this.formCues,
      videoUrl: data.videoUrl.present ? data.videoUrl.value : this.videoUrl,
      difficulty:
          data.difficulty.present ? data.difficulty.value : this.difficulty,
      isCompound:
          data.isCompound.present ? data.isCompound.value : this.isCompound,
      minimumAge:
          data.minimumAge.present ? data.minimumAge.value : this.minimumAge,
      maximumAge:
          data.maximumAge.present ? data.maximumAge.value : this.maximumAge,
      requiresModification50Plus: data.requiresModification50Plus.present
          ? data.requiresModification50Plus.value
          : this.requiresModification50Plus,
      modification50PlusNotes: data.modification50PlusNotes.present
          ? data.modification50PlusNotes.value
          : this.modification50PlusNotes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StrengthExerciseEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('primaryMusclesJson: $primaryMusclesJson, ')
          ..write('secondaryMusclesJson: $secondaryMusclesJson, ')
          ..write('equipment: $equipment, ')
          ..write('formCues: $formCues, ')
          ..write('videoUrl: $videoUrl, ')
          ..write('difficulty: $difficulty, ')
          ..write('isCompound: $isCompound, ')
          ..write('minimumAge: $minimumAge, ')
          ..write('maximumAge: $maximumAge, ')
          ..write('requiresModification50Plus: $requiresModification50Plus, ')
          ..write('modification50PlusNotes: $modification50PlusNotes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      description,
      primaryMusclesJson,
      secondaryMusclesJson,
      equipment,
      formCues,
      videoUrl,
      difficulty,
      isCompound,
      minimumAge,
      maximumAge,
      requiresModification50Plus,
      modification50PlusNotes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StrengthExerciseEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.primaryMusclesJson == this.primaryMusclesJson &&
          other.secondaryMusclesJson == this.secondaryMusclesJson &&
          other.equipment == this.equipment &&
          other.formCues == this.formCues &&
          other.videoUrl == this.videoUrl &&
          other.difficulty == this.difficulty &&
          other.isCompound == this.isCompound &&
          other.minimumAge == this.minimumAge &&
          other.maximumAge == this.maximumAge &&
          other.requiresModification50Plus == this.requiresModification50Plus &&
          other.modification50PlusNotes == this.modification50PlusNotes);
}

class StrengthExercisesCompanion
    extends UpdateCompanion<StrengthExerciseEntity> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String> primaryMusclesJson;
  final Value<String> secondaryMusclesJson;
  final Value<String> equipment;
  final Value<String> formCues;
  final Value<String?> videoUrl;
  final Value<String> difficulty;
  final Value<bool> isCompound;
  final Value<int> minimumAge;
  final Value<int?> maximumAge;
  final Value<bool> requiresModification50Plus;
  final Value<String?> modification50PlusNotes;
  final Value<int> rowid;
  const StrengthExercisesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.primaryMusclesJson = const Value.absent(),
    this.secondaryMusclesJson = const Value.absent(),
    this.equipment = const Value.absent(),
    this.formCues = const Value.absent(),
    this.videoUrl = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.isCompound = const Value.absent(),
    this.minimumAge = const Value.absent(),
    this.maximumAge = const Value.absent(),
    this.requiresModification50Plus = const Value.absent(),
    this.modification50PlusNotes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StrengthExercisesCompanion.insert({
    required String id,
    required String name,
    required String description,
    required String primaryMusclesJson,
    required String secondaryMusclesJson,
    required String equipment,
    required String formCues,
    this.videoUrl = const Value.absent(),
    required String difficulty,
    this.isCompound = const Value.absent(),
    this.minimumAge = const Value.absent(),
    this.maximumAge = const Value.absent(),
    this.requiresModification50Plus = const Value.absent(),
    this.modification50PlusNotes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        description = Value(description),
        primaryMusclesJson = Value(primaryMusclesJson),
        secondaryMusclesJson = Value(secondaryMusclesJson),
        equipment = Value(equipment),
        formCues = Value(formCues),
        difficulty = Value(difficulty);
  static Insertable<StrengthExerciseEntity> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? primaryMusclesJson,
    Expression<String>? secondaryMusclesJson,
    Expression<String>? equipment,
    Expression<String>? formCues,
    Expression<String>? videoUrl,
    Expression<String>? difficulty,
    Expression<bool>? isCompound,
    Expression<int>? minimumAge,
    Expression<int>? maximumAge,
    Expression<bool>? requiresModification50Plus,
    Expression<String>? modification50PlusNotes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (primaryMusclesJson != null)
        'primary_muscles_json': primaryMusclesJson,
      if (secondaryMusclesJson != null)
        'secondary_muscles_json': secondaryMusclesJson,
      if (equipment != null) 'equipment': equipment,
      if (formCues != null) 'form_cues': formCues,
      if (videoUrl != null) 'video_url': videoUrl,
      if (difficulty != null) 'difficulty': difficulty,
      if (isCompound != null) 'is_compound': isCompound,
      if (minimumAge != null) 'minimum_age': minimumAge,
      if (maximumAge != null) 'maximum_age': maximumAge,
      if (requiresModification50Plus != null)
        'requires_modification50_plus': requiresModification50Plus,
      if (modification50PlusNotes != null)
        'modification50_plus_notes': modification50PlusNotes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StrengthExercisesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? description,
      Value<String>? primaryMusclesJson,
      Value<String>? secondaryMusclesJson,
      Value<String>? equipment,
      Value<String>? formCues,
      Value<String?>? videoUrl,
      Value<String>? difficulty,
      Value<bool>? isCompound,
      Value<int>? minimumAge,
      Value<int?>? maximumAge,
      Value<bool>? requiresModification50Plus,
      Value<String?>? modification50PlusNotes,
      Value<int>? rowid}) {
    return StrengthExercisesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      primaryMusclesJson: primaryMusclesJson ?? this.primaryMusclesJson,
      secondaryMusclesJson: secondaryMusclesJson ?? this.secondaryMusclesJson,
      equipment: equipment ?? this.equipment,
      formCues: formCues ?? this.formCues,
      videoUrl: videoUrl ?? this.videoUrl,
      difficulty: difficulty ?? this.difficulty,
      isCompound: isCompound ?? this.isCompound,
      minimumAge: minimumAge ?? this.minimumAge,
      maximumAge: maximumAge ?? this.maximumAge,
      requiresModification50Plus:
          requiresModification50Plus ?? this.requiresModification50Plus,
      modification50PlusNotes:
          modification50PlusNotes ?? this.modification50PlusNotes,
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
    if (primaryMusclesJson.present) {
      map['primary_muscles_json'] = Variable<String>(primaryMusclesJson.value);
    }
    if (secondaryMusclesJson.present) {
      map['secondary_muscles_json'] =
          Variable<String>(secondaryMusclesJson.value);
    }
    if (equipment.present) {
      map['equipment'] = Variable<String>(equipment.value);
    }
    if (formCues.present) {
      map['form_cues'] = Variable<String>(formCues.value);
    }
    if (videoUrl.present) {
      map['video_url'] = Variable<String>(videoUrl.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (isCompound.present) {
      map['is_compound'] = Variable<bool>(isCompound.value);
    }
    if (minimumAge.present) {
      map['minimum_age'] = Variable<int>(minimumAge.value);
    }
    if (maximumAge.present) {
      map['maximum_age'] = Variable<int>(maximumAge.value);
    }
    if (requiresModification50Plus.present) {
      map['requires_modification50_plus'] =
          Variable<bool>(requiresModification50Plus.value);
    }
    if (modification50PlusNotes.present) {
      map['modification50_plus_notes'] =
          Variable<String>(modification50PlusNotes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StrengthExercisesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('primaryMusclesJson: $primaryMusclesJson, ')
          ..write('secondaryMusclesJson: $secondaryMusclesJson, ')
          ..write('equipment: $equipment, ')
          ..write('formCues: $formCues, ')
          ..write('videoUrl: $videoUrl, ')
          ..write('difficulty: $difficulty, ')
          ..write('isCompound: $isCompound, ')
          ..write('minimumAge: $minimumAge, ')
          ..write('maximumAge: $maximumAge, ')
          ..write('requiresModification50Plus: $requiresModification50Plus, ')
          ..write('modification50PlusNotes: $modification50PlusNotes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StrengthWorkoutsTable extends StrengthWorkouts
    with TableInfo<$StrengthWorkoutsTable, StrengthWorkoutEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StrengthWorkoutsTable(this.attachedDatabase, [this._alias]);
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
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _intervalsJsonMeta =
      const VerificationMeta('intervalsJson');
  @override
  late final GeneratedColumn<String> intervalsJson = GeneratedColumn<String>(
      'intervals_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _workoutTypeMeta =
      const VerificationMeta('workoutType');
  @override
  late final GeneratedColumn<String> workoutType = GeneratedColumn<String>(
      'workout_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _estimatedDurationMinutesMeta =
      const VerificationMeta('estimatedDurationMinutes');
  @override
  late final GeneratedColumn<int> estimatedDurationMinutes =
      GeneratedColumn<int>('estimated_duration_minutes', aliasedName, false,
          type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _difficultyMeta =
      const VerificationMeta('difficulty');
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
      'difficulty', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isCustomMeta =
      const VerificationMeta('isCustom');
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
      'is_custom', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_custom" IN (0, 1))'),
      defaultValue: const Constant(false));
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
        intervalsJson,
        workoutType,
        estimatedDurationMinutes,
        difficulty,
        isCustom,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'strength_workouts';
  @override
  VerificationContext validateIntegrity(
      Insertable<StrengthWorkoutEntity> instance,
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
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('intervals_json')) {
      context.handle(
          _intervalsJsonMeta,
          intervalsJson.isAcceptableOrUnknown(
              data['intervals_json']!, _intervalsJsonMeta));
    } else if (isInserting) {
      context.missing(_intervalsJsonMeta);
    }
    if (data.containsKey('workout_type')) {
      context.handle(
          _workoutTypeMeta,
          workoutType.isAcceptableOrUnknown(
              data['workout_type']!, _workoutTypeMeta));
    } else if (isInserting) {
      context.missing(_workoutTypeMeta);
    }
    if (data.containsKey('estimated_duration_minutes')) {
      context.handle(
          _estimatedDurationMinutesMeta,
          estimatedDurationMinutes.isAcceptableOrUnknown(
              data['estimated_duration_minutes']!,
              _estimatedDurationMinutesMeta));
    } else if (isInserting) {
      context.missing(_estimatedDurationMinutesMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
          _difficultyMeta,
          difficulty.isAcceptableOrUnknown(
              data['difficulty']!, _difficultyMeta));
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('is_custom')) {
      context.handle(_isCustomMeta,
          isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta));
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
  StrengthWorkoutEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StrengthWorkoutEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      intervalsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}intervals_json'])!,
      workoutType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}workout_type'])!,
      estimatedDurationMinutes: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}estimated_duration_minutes'])!,
      difficulty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}difficulty'])!,
      isCustom: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_custom'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $StrengthWorkoutsTable createAlias(String alias) {
    return $StrengthWorkoutsTable(attachedDatabase, alias);
  }
}

class StrengthWorkoutEntity extends DataClass
    implements Insertable<StrengthWorkoutEntity> {
  /// Eindeutige ID
  final String id;

  /// Name des Workouts
  final String name;

  /// Beschreibung
  final String description;

  /// Intervalle als JSON Array (StrengthInterval objects)
  final String intervalsJson;

  /// Workout-Typ
  final String workoutType;

  /// Geschätzte Dauer in Minuten
  final int estimatedDurationMinutes;

  /// Schwierigkeitsgrad
  final String difficulty;

  /// Ist es ein Custom Workout?
  final bool isCustom;

  /// Erstellungsdatum
  final DateTime createdAt;
  const StrengthWorkoutEntity(
      {required this.id,
      required this.name,
      required this.description,
      required this.intervalsJson,
      required this.workoutType,
      required this.estimatedDurationMinutes,
      required this.difficulty,
      required this.isCustom,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['intervals_json'] = Variable<String>(intervalsJson);
    map['workout_type'] = Variable<String>(workoutType);
    map['estimated_duration_minutes'] = Variable<int>(estimatedDurationMinutes);
    map['difficulty'] = Variable<String>(difficulty);
    map['is_custom'] = Variable<bool>(isCustom);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StrengthWorkoutsCompanion toCompanion(bool nullToAbsent) {
    return StrengthWorkoutsCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      intervalsJson: Value(intervalsJson),
      workoutType: Value(workoutType),
      estimatedDurationMinutes: Value(estimatedDurationMinutes),
      difficulty: Value(difficulty),
      isCustom: Value(isCustom),
      createdAt: Value(createdAt),
    );
  }

  factory StrengthWorkoutEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StrengthWorkoutEntity(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      intervalsJson: serializer.fromJson<String>(json['intervalsJson']),
      workoutType: serializer.fromJson<String>(json['workoutType']),
      estimatedDurationMinutes:
          serializer.fromJson<int>(json['estimatedDurationMinutes']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'intervalsJson': serializer.toJson<String>(intervalsJson),
      'workoutType': serializer.toJson<String>(workoutType),
      'estimatedDurationMinutes':
          serializer.toJson<int>(estimatedDurationMinutes),
      'difficulty': serializer.toJson<String>(difficulty),
      'isCustom': serializer.toJson<bool>(isCustom),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StrengthWorkoutEntity copyWith(
          {String? id,
          String? name,
          String? description,
          String? intervalsJson,
          String? workoutType,
          int? estimatedDurationMinutes,
          String? difficulty,
          bool? isCustom,
          DateTime? createdAt}) =>
      StrengthWorkoutEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        intervalsJson: intervalsJson ?? this.intervalsJson,
        workoutType: workoutType ?? this.workoutType,
        estimatedDurationMinutes:
            estimatedDurationMinutes ?? this.estimatedDurationMinutes,
        difficulty: difficulty ?? this.difficulty,
        isCustom: isCustom ?? this.isCustom,
        createdAt: createdAt ?? this.createdAt,
      );
  StrengthWorkoutEntity copyWithCompanion(StrengthWorkoutsCompanion data) {
    return StrengthWorkoutEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      intervalsJson: data.intervalsJson.present
          ? data.intervalsJson.value
          : this.intervalsJson,
      workoutType:
          data.workoutType.present ? data.workoutType.value : this.workoutType,
      estimatedDurationMinutes: data.estimatedDurationMinutes.present
          ? data.estimatedDurationMinutes.value
          : this.estimatedDurationMinutes,
      difficulty:
          data.difficulty.present ? data.difficulty.value : this.difficulty,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StrengthWorkoutEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('intervalsJson: $intervalsJson, ')
          ..write('workoutType: $workoutType, ')
          ..write('estimatedDurationMinutes: $estimatedDurationMinutes, ')
          ..write('difficulty: $difficulty, ')
          ..write('isCustom: $isCustom, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, intervalsJson,
      workoutType, estimatedDurationMinutes, difficulty, isCustom, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StrengthWorkoutEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.intervalsJson == this.intervalsJson &&
          other.workoutType == this.workoutType &&
          other.estimatedDurationMinutes == this.estimatedDurationMinutes &&
          other.difficulty == this.difficulty &&
          other.isCustom == this.isCustom &&
          other.createdAt == this.createdAt);
}

class StrengthWorkoutsCompanion extends UpdateCompanion<StrengthWorkoutEntity> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String> intervalsJson;
  final Value<String> workoutType;
  final Value<int> estimatedDurationMinutes;
  final Value<String> difficulty;
  final Value<bool> isCustom;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const StrengthWorkoutsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.intervalsJson = const Value.absent(),
    this.workoutType = const Value.absent(),
    this.estimatedDurationMinutes = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StrengthWorkoutsCompanion.insert({
    required String id,
    required String name,
    required String description,
    required String intervalsJson,
    required String workoutType,
    required int estimatedDurationMinutes,
    required String difficulty,
    this.isCustom = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        description = Value(description),
        intervalsJson = Value(intervalsJson),
        workoutType = Value(workoutType),
        estimatedDurationMinutes = Value(estimatedDurationMinutes),
        difficulty = Value(difficulty),
        createdAt = Value(createdAt);
  static Insertable<StrengthWorkoutEntity> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? intervalsJson,
    Expression<String>? workoutType,
    Expression<int>? estimatedDurationMinutes,
    Expression<String>? difficulty,
    Expression<bool>? isCustom,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (intervalsJson != null) 'intervals_json': intervalsJson,
      if (workoutType != null) 'workout_type': workoutType,
      if (estimatedDurationMinutes != null)
        'estimated_duration_minutes': estimatedDurationMinutes,
      if (difficulty != null) 'difficulty': difficulty,
      if (isCustom != null) 'is_custom': isCustom,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StrengthWorkoutsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? description,
      Value<String>? intervalsJson,
      Value<String>? workoutType,
      Value<int>? estimatedDurationMinutes,
      Value<String>? difficulty,
      Value<bool>? isCustom,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return StrengthWorkoutsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      intervalsJson: intervalsJson ?? this.intervalsJson,
      workoutType: workoutType ?? this.workoutType,
      estimatedDurationMinutes:
          estimatedDurationMinutes ?? this.estimatedDurationMinutes,
      difficulty: difficulty ?? this.difficulty,
      isCustom: isCustom ?? this.isCustom,
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
    if (intervalsJson.present) {
      map['intervals_json'] = Variable<String>(intervalsJson.value);
    }
    if (workoutType.present) {
      map['workout_type'] = Variable<String>(workoutType.value);
    }
    if (estimatedDurationMinutes.present) {
      map['estimated_duration_minutes'] =
          Variable<int>(estimatedDurationMinutes.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
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
    return (StringBuffer('StrengthWorkoutsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('intervalsJson: $intervalsJson, ')
          ..write('workoutType: $workoutType, ')
          ..write('estimatedDurationMinutes: $estimatedDurationMinutes, ')
          ..write('difficulty: $difficulty, ')
          ..write('isCustom: $isCustom, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StrengthSessionsTable extends StrengthSessions
    with TableInfo<$StrengthSessionsTable, StrengthSessionEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StrengthSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startTimeMsMeta =
      const VerificationMeta('startTimeMs');
  @override
  late final GeneratedColumn<int> startTimeMs = GeneratedColumn<int>(
      'start_time_ms', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _endTimeMsMeta =
      const VerificationMeta('endTimeMs');
  @override
  late final GeneratedColumn<int> endTimeMs = GeneratedColumn<int>(
      'end_time_ms', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _workoutIdMeta =
      const VerificationMeta('workoutId');
  @override
  late final GeneratedColumn<String> workoutId = GeneratedColumn<String>(
      'workout_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _exercisesJsonMeta =
      const VerificationMeta('exercisesJson');
  @override
  late final GeneratedColumn<String> exercisesJson = GeneratedColumn<String>(
      'exercises_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statsDurationSecsMeta =
      const VerificationMeta('statsDurationSecs');
  @override
  late final GeneratedColumn<int> statsDurationSecs = GeneratedColumn<int>(
      'stats_duration_secs', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _statsTotalSetsMeta =
      const VerificationMeta('statsTotalSets');
  @override
  late final GeneratedColumn<int> statsTotalSets = GeneratedColumn<int>(
      'stats_total_sets', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _statsTotalRepsMeta =
      const VerificationMeta('statsTotalReps');
  @override
  late final GeneratedColumn<int> statsTotalReps = GeneratedColumn<int>(
      'stats_total_reps', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _statsTotalVolumeMeta =
      const VerificationMeta('statsTotalVolume');
  @override
  late final GeneratedColumn<double> statsTotalVolume = GeneratedColumn<double>(
      'stats_total_volume', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _statsAvgRpeMeta =
      const VerificationMeta('statsAvgRpe');
  @override
  late final GeneratedColumn<int> statsAvgRpe = GeneratedColumn<int>(
      'stats_avg_rpe', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _statsExercisesCompletedMeta =
      const VerificationMeta('statsExercisesCompleted');
  @override
  late final GeneratedColumn<int> statsExercisesCompleted =
      GeneratedColumn<int>('stats_exercises_completed', aliasedName, false,
          type: DriftSqlType.int,
          requiredDuringInsert: false,
          defaultValue: const Constant(0));
  static const VerificationMeta _statsMuscleGroupWorkJsonMeta =
      const VerificationMeta('statsMuscleGroupWorkJson');
  @override
  late final GeneratedColumn<String> statsMuscleGroupWorkJson =
      GeneratedColumn<String>(
          'stats_muscle_group_work_json', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('{}'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        startTimeMs,
        endTimeMs,
        workoutId,
        exercisesJson,
        statsDurationSecs,
        statsTotalSets,
        statsTotalReps,
        statsTotalVolume,
        statsAvgRpe,
        statsExercisesCompleted,
        statsMuscleGroupWorkJson,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'strength_sessions';
  @override
  VerificationContext validateIntegrity(
      Insertable<StrengthSessionEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('start_time_ms')) {
      context.handle(
          _startTimeMsMeta,
          startTimeMs.isAcceptableOrUnknown(
              data['start_time_ms']!, _startTimeMsMeta));
    } else if (isInserting) {
      context.missing(_startTimeMsMeta);
    }
    if (data.containsKey('end_time_ms')) {
      context.handle(
          _endTimeMsMeta,
          endTimeMs.isAcceptableOrUnknown(
              data['end_time_ms']!, _endTimeMsMeta));
    }
    if (data.containsKey('workout_id')) {
      context.handle(_workoutIdMeta,
          workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta));
    }
    if (data.containsKey('exercises_json')) {
      context.handle(
          _exercisesJsonMeta,
          exercisesJson.isAcceptableOrUnknown(
              data['exercises_json']!, _exercisesJsonMeta));
    } else if (isInserting) {
      context.missing(_exercisesJsonMeta);
    }
    if (data.containsKey('stats_duration_secs')) {
      context.handle(
          _statsDurationSecsMeta,
          statsDurationSecs.isAcceptableOrUnknown(
              data['stats_duration_secs']!, _statsDurationSecsMeta));
    }
    if (data.containsKey('stats_total_sets')) {
      context.handle(
          _statsTotalSetsMeta,
          statsTotalSets.isAcceptableOrUnknown(
              data['stats_total_sets']!, _statsTotalSetsMeta));
    }
    if (data.containsKey('stats_total_reps')) {
      context.handle(
          _statsTotalRepsMeta,
          statsTotalReps.isAcceptableOrUnknown(
              data['stats_total_reps']!, _statsTotalRepsMeta));
    }
    if (data.containsKey('stats_total_volume')) {
      context.handle(
          _statsTotalVolumeMeta,
          statsTotalVolume.isAcceptableOrUnknown(
              data['stats_total_volume']!, _statsTotalVolumeMeta));
    }
    if (data.containsKey('stats_avg_rpe')) {
      context.handle(
          _statsAvgRpeMeta,
          statsAvgRpe.isAcceptableOrUnknown(
              data['stats_avg_rpe']!, _statsAvgRpeMeta));
    }
    if (data.containsKey('stats_exercises_completed')) {
      context.handle(
          _statsExercisesCompletedMeta,
          statsExercisesCompleted.isAcceptableOrUnknown(
              data['stats_exercises_completed']!,
              _statsExercisesCompletedMeta));
    }
    if (data.containsKey('stats_muscle_group_work_json')) {
      context.handle(
          _statsMuscleGroupWorkJsonMeta,
          statsMuscleGroupWorkJson.isAcceptableOrUnknown(
              data['stats_muscle_group_work_json']!,
              _statsMuscleGroupWorkJsonMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StrengthSessionEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StrengthSessionEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      startTimeMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_time_ms'])!,
      endTimeMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}end_time_ms']),
      workoutId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}workout_id']),
      exercisesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exercises_json'])!,
      statsDurationSecs: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}stats_duration_secs'])!,
      statsTotalSets: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stats_total_sets'])!,
      statsTotalReps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stats_total_reps'])!,
      statsTotalVolume: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}stats_total_volume'])!,
      statsAvgRpe: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stats_avg_rpe']),
      statsExercisesCompleted: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}stats_exercises_completed'])!,
      statsMuscleGroupWorkJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}stats_muscle_group_work_json'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $StrengthSessionsTable createAlias(String alias) {
    return $StrengthSessionsTable(attachedDatabase, alias);
  }
}

class StrengthSessionEntity extends DataClass
    implements Insertable<StrengthSessionEntity> {
  /// Eindeutige ID
  final String id;

  /// Start-Zeitpunkt (Millisekunden seit Epoch)
  final int startTimeMs;

  /// End-Zeitpunkt (optional, Millisekunden seit Epoch)
  final int? endTimeMs;

  /// Link zum Workout (optional)
  final String? workoutId;

  /// Übungen mit ihren Sets als JSON Array (StrengthExerciseRecord objects)
  final String exercisesJson;

  /// Session Stats: Gesamtdauer in Sekunden
  final int statsDurationSecs;

  /// Session Stats: Gesamtanzahl Sets
  final int statsTotalSets;

  /// Session Stats: Gesamtanzahl Wiederholungen
  final int statsTotalReps;

  /// Session Stats: Gesamtvolumen (kg)
  final double statsTotalVolume;

  /// Session Stats: Durchschnittliches RPE
  final int? statsAvgRpe;

  /// Session Stats: Anzahl absolvierter Übungen
  final int statsExercisesCompleted;

  /// Session Stats: Volumen pro Muskelgruppe als JSON Object
  final String statsMuscleGroupWorkJson;

  /// Notizen zur Session
  final String? notes;
  const StrengthSessionEntity(
      {required this.id,
      required this.startTimeMs,
      this.endTimeMs,
      this.workoutId,
      required this.exercisesJson,
      required this.statsDurationSecs,
      required this.statsTotalSets,
      required this.statsTotalReps,
      required this.statsTotalVolume,
      this.statsAvgRpe,
      required this.statsExercisesCompleted,
      required this.statsMuscleGroupWorkJson,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['start_time_ms'] = Variable<int>(startTimeMs);
    if (!nullToAbsent || endTimeMs != null) {
      map['end_time_ms'] = Variable<int>(endTimeMs);
    }
    if (!nullToAbsent || workoutId != null) {
      map['workout_id'] = Variable<String>(workoutId);
    }
    map['exercises_json'] = Variable<String>(exercisesJson);
    map['stats_duration_secs'] = Variable<int>(statsDurationSecs);
    map['stats_total_sets'] = Variable<int>(statsTotalSets);
    map['stats_total_reps'] = Variable<int>(statsTotalReps);
    map['stats_total_volume'] = Variable<double>(statsTotalVolume);
    if (!nullToAbsent || statsAvgRpe != null) {
      map['stats_avg_rpe'] = Variable<int>(statsAvgRpe);
    }
    map['stats_exercises_completed'] = Variable<int>(statsExercisesCompleted);
    map['stats_muscle_group_work_json'] =
        Variable<String>(statsMuscleGroupWorkJson);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  StrengthSessionsCompanion toCompanion(bool nullToAbsent) {
    return StrengthSessionsCompanion(
      id: Value(id),
      startTimeMs: Value(startTimeMs),
      endTimeMs: endTimeMs == null && nullToAbsent
          ? const Value.absent()
          : Value(endTimeMs),
      workoutId: workoutId == null && nullToAbsent
          ? const Value.absent()
          : Value(workoutId),
      exercisesJson: Value(exercisesJson),
      statsDurationSecs: Value(statsDurationSecs),
      statsTotalSets: Value(statsTotalSets),
      statsTotalReps: Value(statsTotalReps),
      statsTotalVolume: Value(statsTotalVolume),
      statsAvgRpe: statsAvgRpe == null && nullToAbsent
          ? const Value.absent()
          : Value(statsAvgRpe),
      statsExercisesCompleted: Value(statsExercisesCompleted),
      statsMuscleGroupWorkJson: Value(statsMuscleGroupWorkJson),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory StrengthSessionEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StrengthSessionEntity(
      id: serializer.fromJson<String>(json['id']),
      startTimeMs: serializer.fromJson<int>(json['startTimeMs']),
      endTimeMs: serializer.fromJson<int?>(json['endTimeMs']),
      workoutId: serializer.fromJson<String?>(json['workoutId']),
      exercisesJson: serializer.fromJson<String>(json['exercisesJson']),
      statsDurationSecs: serializer.fromJson<int>(json['statsDurationSecs']),
      statsTotalSets: serializer.fromJson<int>(json['statsTotalSets']),
      statsTotalReps: serializer.fromJson<int>(json['statsTotalReps']),
      statsTotalVolume: serializer.fromJson<double>(json['statsTotalVolume']),
      statsAvgRpe: serializer.fromJson<int?>(json['statsAvgRpe']),
      statsExercisesCompleted:
          serializer.fromJson<int>(json['statsExercisesCompleted']),
      statsMuscleGroupWorkJson:
          serializer.fromJson<String>(json['statsMuscleGroupWorkJson']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'startTimeMs': serializer.toJson<int>(startTimeMs),
      'endTimeMs': serializer.toJson<int?>(endTimeMs),
      'workoutId': serializer.toJson<String?>(workoutId),
      'exercisesJson': serializer.toJson<String>(exercisesJson),
      'statsDurationSecs': serializer.toJson<int>(statsDurationSecs),
      'statsTotalSets': serializer.toJson<int>(statsTotalSets),
      'statsTotalReps': serializer.toJson<int>(statsTotalReps),
      'statsTotalVolume': serializer.toJson<double>(statsTotalVolume),
      'statsAvgRpe': serializer.toJson<int?>(statsAvgRpe),
      'statsExercisesCompleted':
          serializer.toJson<int>(statsExercisesCompleted),
      'statsMuscleGroupWorkJson':
          serializer.toJson<String>(statsMuscleGroupWorkJson),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  StrengthSessionEntity copyWith(
          {String? id,
          int? startTimeMs,
          Value<int?> endTimeMs = const Value.absent(),
          Value<String?> workoutId = const Value.absent(),
          String? exercisesJson,
          int? statsDurationSecs,
          int? statsTotalSets,
          int? statsTotalReps,
          double? statsTotalVolume,
          Value<int?> statsAvgRpe = const Value.absent(),
          int? statsExercisesCompleted,
          String? statsMuscleGroupWorkJson,
          Value<String?> notes = const Value.absent()}) =>
      StrengthSessionEntity(
        id: id ?? this.id,
        startTimeMs: startTimeMs ?? this.startTimeMs,
        endTimeMs: endTimeMs.present ? endTimeMs.value : this.endTimeMs,
        workoutId: workoutId.present ? workoutId.value : this.workoutId,
        exercisesJson: exercisesJson ?? this.exercisesJson,
        statsDurationSecs: statsDurationSecs ?? this.statsDurationSecs,
        statsTotalSets: statsTotalSets ?? this.statsTotalSets,
        statsTotalReps: statsTotalReps ?? this.statsTotalReps,
        statsTotalVolume: statsTotalVolume ?? this.statsTotalVolume,
        statsAvgRpe: statsAvgRpe.present ? statsAvgRpe.value : this.statsAvgRpe,
        statsExercisesCompleted:
            statsExercisesCompleted ?? this.statsExercisesCompleted,
        statsMuscleGroupWorkJson:
            statsMuscleGroupWorkJson ?? this.statsMuscleGroupWorkJson,
        notes: notes.present ? notes.value : this.notes,
      );
  StrengthSessionEntity copyWithCompanion(StrengthSessionsCompanion data) {
    return StrengthSessionEntity(
      id: data.id.present ? data.id.value : this.id,
      startTimeMs:
          data.startTimeMs.present ? data.startTimeMs.value : this.startTimeMs,
      endTimeMs: data.endTimeMs.present ? data.endTimeMs.value : this.endTimeMs,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
      exercisesJson: data.exercisesJson.present
          ? data.exercisesJson.value
          : this.exercisesJson,
      statsDurationSecs: data.statsDurationSecs.present
          ? data.statsDurationSecs.value
          : this.statsDurationSecs,
      statsTotalSets: data.statsTotalSets.present
          ? data.statsTotalSets.value
          : this.statsTotalSets,
      statsTotalReps: data.statsTotalReps.present
          ? data.statsTotalReps.value
          : this.statsTotalReps,
      statsTotalVolume: data.statsTotalVolume.present
          ? data.statsTotalVolume.value
          : this.statsTotalVolume,
      statsAvgRpe:
          data.statsAvgRpe.present ? data.statsAvgRpe.value : this.statsAvgRpe,
      statsExercisesCompleted: data.statsExercisesCompleted.present
          ? data.statsExercisesCompleted.value
          : this.statsExercisesCompleted,
      statsMuscleGroupWorkJson: data.statsMuscleGroupWorkJson.present
          ? data.statsMuscleGroupWorkJson.value
          : this.statsMuscleGroupWorkJson,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StrengthSessionEntity(')
          ..write('id: $id, ')
          ..write('startTimeMs: $startTimeMs, ')
          ..write('endTimeMs: $endTimeMs, ')
          ..write('workoutId: $workoutId, ')
          ..write('exercisesJson: $exercisesJson, ')
          ..write('statsDurationSecs: $statsDurationSecs, ')
          ..write('statsTotalSets: $statsTotalSets, ')
          ..write('statsTotalReps: $statsTotalReps, ')
          ..write('statsTotalVolume: $statsTotalVolume, ')
          ..write('statsAvgRpe: $statsAvgRpe, ')
          ..write('statsExercisesCompleted: $statsExercisesCompleted, ')
          ..write('statsMuscleGroupWorkJson: $statsMuscleGroupWorkJson, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      startTimeMs,
      endTimeMs,
      workoutId,
      exercisesJson,
      statsDurationSecs,
      statsTotalSets,
      statsTotalReps,
      statsTotalVolume,
      statsAvgRpe,
      statsExercisesCompleted,
      statsMuscleGroupWorkJson,
      notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StrengthSessionEntity &&
          other.id == this.id &&
          other.startTimeMs == this.startTimeMs &&
          other.endTimeMs == this.endTimeMs &&
          other.workoutId == this.workoutId &&
          other.exercisesJson == this.exercisesJson &&
          other.statsDurationSecs == this.statsDurationSecs &&
          other.statsTotalSets == this.statsTotalSets &&
          other.statsTotalReps == this.statsTotalReps &&
          other.statsTotalVolume == this.statsTotalVolume &&
          other.statsAvgRpe == this.statsAvgRpe &&
          other.statsExercisesCompleted == this.statsExercisesCompleted &&
          other.statsMuscleGroupWorkJson == this.statsMuscleGroupWorkJson &&
          other.notes == this.notes);
}

class StrengthSessionsCompanion extends UpdateCompanion<StrengthSessionEntity> {
  final Value<String> id;
  final Value<int> startTimeMs;
  final Value<int?> endTimeMs;
  final Value<String?> workoutId;
  final Value<String> exercisesJson;
  final Value<int> statsDurationSecs;
  final Value<int> statsTotalSets;
  final Value<int> statsTotalReps;
  final Value<double> statsTotalVolume;
  final Value<int?> statsAvgRpe;
  final Value<int> statsExercisesCompleted;
  final Value<String> statsMuscleGroupWorkJson;
  final Value<String?> notes;
  final Value<int> rowid;
  const StrengthSessionsCompanion({
    this.id = const Value.absent(),
    this.startTimeMs = const Value.absent(),
    this.endTimeMs = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.exercisesJson = const Value.absent(),
    this.statsDurationSecs = const Value.absent(),
    this.statsTotalSets = const Value.absent(),
    this.statsTotalReps = const Value.absent(),
    this.statsTotalVolume = const Value.absent(),
    this.statsAvgRpe = const Value.absent(),
    this.statsExercisesCompleted = const Value.absent(),
    this.statsMuscleGroupWorkJson = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StrengthSessionsCompanion.insert({
    required String id,
    required int startTimeMs,
    this.endTimeMs = const Value.absent(),
    this.workoutId = const Value.absent(),
    required String exercisesJson,
    this.statsDurationSecs = const Value.absent(),
    this.statsTotalSets = const Value.absent(),
    this.statsTotalReps = const Value.absent(),
    this.statsTotalVolume = const Value.absent(),
    this.statsAvgRpe = const Value.absent(),
    this.statsExercisesCompleted = const Value.absent(),
    this.statsMuscleGroupWorkJson = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        startTimeMs = Value(startTimeMs),
        exercisesJson = Value(exercisesJson);
  static Insertable<StrengthSessionEntity> custom({
    Expression<String>? id,
    Expression<int>? startTimeMs,
    Expression<int>? endTimeMs,
    Expression<String>? workoutId,
    Expression<String>? exercisesJson,
    Expression<int>? statsDurationSecs,
    Expression<int>? statsTotalSets,
    Expression<int>? statsTotalReps,
    Expression<double>? statsTotalVolume,
    Expression<int>? statsAvgRpe,
    Expression<int>? statsExercisesCompleted,
    Expression<String>? statsMuscleGroupWorkJson,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startTimeMs != null) 'start_time_ms': startTimeMs,
      if (endTimeMs != null) 'end_time_ms': endTimeMs,
      if (workoutId != null) 'workout_id': workoutId,
      if (exercisesJson != null) 'exercises_json': exercisesJson,
      if (statsDurationSecs != null) 'stats_duration_secs': statsDurationSecs,
      if (statsTotalSets != null) 'stats_total_sets': statsTotalSets,
      if (statsTotalReps != null) 'stats_total_reps': statsTotalReps,
      if (statsTotalVolume != null) 'stats_total_volume': statsTotalVolume,
      if (statsAvgRpe != null) 'stats_avg_rpe': statsAvgRpe,
      if (statsExercisesCompleted != null)
        'stats_exercises_completed': statsExercisesCompleted,
      if (statsMuscleGroupWorkJson != null)
        'stats_muscle_group_work_json': statsMuscleGroupWorkJson,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StrengthSessionsCompanion copyWith(
      {Value<String>? id,
      Value<int>? startTimeMs,
      Value<int?>? endTimeMs,
      Value<String?>? workoutId,
      Value<String>? exercisesJson,
      Value<int>? statsDurationSecs,
      Value<int>? statsTotalSets,
      Value<int>? statsTotalReps,
      Value<double>? statsTotalVolume,
      Value<int?>? statsAvgRpe,
      Value<int>? statsExercisesCompleted,
      Value<String>? statsMuscleGroupWorkJson,
      Value<String?>? notes,
      Value<int>? rowid}) {
    return StrengthSessionsCompanion(
      id: id ?? this.id,
      startTimeMs: startTimeMs ?? this.startTimeMs,
      endTimeMs: endTimeMs ?? this.endTimeMs,
      workoutId: workoutId ?? this.workoutId,
      exercisesJson: exercisesJson ?? this.exercisesJson,
      statsDurationSecs: statsDurationSecs ?? this.statsDurationSecs,
      statsTotalSets: statsTotalSets ?? this.statsTotalSets,
      statsTotalReps: statsTotalReps ?? this.statsTotalReps,
      statsTotalVolume: statsTotalVolume ?? this.statsTotalVolume,
      statsAvgRpe: statsAvgRpe ?? this.statsAvgRpe,
      statsExercisesCompleted:
          statsExercisesCompleted ?? this.statsExercisesCompleted,
      statsMuscleGroupWorkJson:
          statsMuscleGroupWorkJson ?? this.statsMuscleGroupWorkJson,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (startTimeMs.present) {
      map['start_time_ms'] = Variable<int>(startTimeMs.value);
    }
    if (endTimeMs.present) {
      map['end_time_ms'] = Variable<int>(endTimeMs.value);
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<String>(workoutId.value);
    }
    if (exercisesJson.present) {
      map['exercises_json'] = Variable<String>(exercisesJson.value);
    }
    if (statsDurationSecs.present) {
      map['stats_duration_secs'] = Variable<int>(statsDurationSecs.value);
    }
    if (statsTotalSets.present) {
      map['stats_total_sets'] = Variable<int>(statsTotalSets.value);
    }
    if (statsTotalReps.present) {
      map['stats_total_reps'] = Variable<int>(statsTotalReps.value);
    }
    if (statsTotalVolume.present) {
      map['stats_total_volume'] = Variable<double>(statsTotalVolume.value);
    }
    if (statsAvgRpe.present) {
      map['stats_avg_rpe'] = Variable<int>(statsAvgRpe.value);
    }
    if (statsExercisesCompleted.present) {
      map['stats_exercises_completed'] =
          Variable<int>(statsExercisesCompleted.value);
    }
    if (statsMuscleGroupWorkJson.present) {
      map['stats_muscle_group_work_json'] =
          Variable<String>(statsMuscleGroupWorkJson.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StrengthSessionsCompanion(')
          ..write('id: $id, ')
          ..write('startTimeMs: $startTimeMs, ')
          ..write('endTimeMs: $endTimeMs, ')
          ..write('workoutId: $workoutId, ')
          ..write('exercisesJson: $exercisesJson, ')
          ..write('statsDurationSecs: $statsDurationSecs, ')
          ..write('statsTotalSets: $statsTotalSets, ')
          ..write('statsTotalReps: $statsTotalReps, ')
          ..write('statsTotalVolume: $statsTotalVolume, ')
          ..write('statsAvgRpe: $statsAvgRpe, ')
          ..write('statsExercisesCompleted: $statsExercisesCompleted, ')
          ..write('statsMuscleGroupWorkJson: $statsMuscleGroupWorkJson, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StrengthPersonalRecordsTable extends StrengthPersonalRecords
    with TableInfo<$StrengthPersonalRecordsTable, StrengthPREntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StrengthPersonalRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _exerciseIdMeta =
      const VerificationMeta('exerciseId');
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
      'exercise_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _weightKgMeta =
      const VerificationMeta('weightKg');
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
      'weight_kg', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
      'reps', aliasedName, false,
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
  static const VerificationMeta _previousWeightKgMeta =
      const VerificationMeta('previousWeightKg');
  @override
  late final GeneratedColumn<double> previousWeightKg = GeneratedColumn<double>(
      'previous_weight_kg', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, exerciseId, weightKg, reps, achievedAt, sessionId, previousWeightKg];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'strength_personal_records';
  @override
  VerificationContext validateIntegrity(Insertable<StrengthPREntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
          _exerciseIdMeta,
          exerciseId.isAcceptableOrUnknown(
              data['exercise_id']!, _exerciseIdMeta));
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(_weightKgMeta,
          weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta));
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
          _repsMeta, reps.isAcceptableOrUnknown(data['reps']!, _repsMeta));
    } else if (isInserting) {
      context.missing(_repsMeta);
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
    if (data.containsKey('previous_weight_kg')) {
      context.handle(
          _previousWeightKgMeta,
          previousWeightKg.isAcceptableOrUnknown(
              data['previous_weight_kg']!, _previousWeightKgMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StrengthPREntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StrengthPREntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      exerciseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exercise_id'])!,
      weightKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight_kg'])!,
      reps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reps'])!,
      achievedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}achieved_at'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id']),
      previousWeightKg: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}previous_weight_kg']),
    );
  }

  @override
  $StrengthPersonalRecordsTable createAlias(String alias) {
    return $StrengthPersonalRecordsTable(attachedDatabase, alias);
  }
}

class StrengthPREntity extends DataClass
    implements Insertable<StrengthPREntity> {
  /// Auto-increment ID
  final int id;

  /// Übungs-ID (Link zur StrengthExercise)
  final String exerciseId;

  /// Gewicht in kg
  final double weightKg;

  /// Wiederholungen (für Tracking: 1RM, 3RM, 5RM, 10RM)
  final int reps;

  /// Datum des PR
  final DateTime achievedAt;

  /// Session-ID (optional, für Verlinkung)
  final String? sessionId;

  /// Vorheriges PR-Gewicht in kg (optional, für History)
  final double? previousWeightKg;
  const StrengthPREntity(
      {required this.id,
      required this.exerciseId,
      required this.weightKg,
      required this.reps,
      required this.achievedAt,
      this.sessionId,
      this.previousWeightKg});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['weight_kg'] = Variable<double>(weightKg);
    map['reps'] = Variable<int>(reps);
    map['achieved_at'] = Variable<DateTime>(achievedAt);
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<String>(sessionId);
    }
    if (!nullToAbsent || previousWeightKg != null) {
      map['previous_weight_kg'] = Variable<double>(previousWeightKg);
    }
    return map;
  }

  StrengthPersonalRecordsCompanion toCompanion(bool nullToAbsent) {
    return StrengthPersonalRecordsCompanion(
      id: Value(id),
      exerciseId: Value(exerciseId),
      weightKg: Value(weightKg),
      reps: Value(reps),
      achievedAt: Value(achievedAt),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
      previousWeightKg: previousWeightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(previousWeightKg),
    );
  }

  factory StrengthPREntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StrengthPREntity(
      id: serializer.fromJson<int>(json['id']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      reps: serializer.fromJson<int>(json['reps']),
      achievedAt: serializer.fromJson<DateTime>(json['achievedAt']),
      sessionId: serializer.fromJson<String?>(json['sessionId']),
      previousWeightKg: serializer.fromJson<double?>(json['previousWeightKg']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'weightKg': serializer.toJson<double>(weightKg),
      'reps': serializer.toJson<int>(reps),
      'achievedAt': serializer.toJson<DateTime>(achievedAt),
      'sessionId': serializer.toJson<String?>(sessionId),
      'previousWeightKg': serializer.toJson<double?>(previousWeightKg),
    };
  }

  StrengthPREntity copyWith(
          {int? id,
          String? exerciseId,
          double? weightKg,
          int? reps,
          DateTime? achievedAt,
          Value<String?> sessionId = const Value.absent(),
          Value<double?> previousWeightKg = const Value.absent()}) =>
      StrengthPREntity(
        id: id ?? this.id,
        exerciseId: exerciseId ?? this.exerciseId,
        weightKg: weightKg ?? this.weightKg,
        reps: reps ?? this.reps,
        achievedAt: achievedAt ?? this.achievedAt,
        sessionId: sessionId.present ? sessionId.value : this.sessionId,
        previousWeightKg: previousWeightKg.present
            ? previousWeightKg.value
            : this.previousWeightKg,
      );
  StrengthPREntity copyWithCompanion(StrengthPersonalRecordsCompanion data) {
    return StrengthPREntity(
      id: data.id.present ? data.id.value : this.id,
      exerciseId:
          data.exerciseId.present ? data.exerciseId.value : this.exerciseId,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      reps: data.reps.present ? data.reps.value : this.reps,
      achievedAt:
          data.achievedAt.present ? data.achievedAt.value : this.achievedAt,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      previousWeightKg: data.previousWeightKg.present
          ? data.previousWeightKg.value
          : this.previousWeightKg,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StrengthPREntity(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('weightKg: $weightKg, ')
          ..write('reps: $reps, ')
          ..write('achievedAt: $achievedAt, ')
          ..write('sessionId: $sessionId, ')
          ..write('previousWeightKg: $previousWeightKg')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, exerciseId, weightKg, reps, achievedAt, sessionId, previousWeightKg);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StrengthPREntity &&
          other.id == this.id &&
          other.exerciseId == this.exerciseId &&
          other.weightKg == this.weightKg &&
          other.reps == this.reps &&
          other.achievedAt == this.achievedAt &&
          other.sessionId == this.sessionId &&
          other.previousWeightKg == this.previousWeightKg);
}

class StrengthPersonalRecordsCompanion
    extends UpdateCompanion<StrengthPREntity> {
  final Value<int> id;
  final Value<String> exerciseId;
  final Value<double> weightKg;
  final Value<int> reps;
  final Value<DateTime> achievedAt;
  final Value<String?> sessionId;
  final Value<double?> previousWeightKg;
  const StrengthPersonalRecordsCompanion({
    this.id = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.reps = const Value.absent(),
    this.achievedAt = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.previousWeightKg = const Value.absent(),
  });
  StrengthPersonalRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String exerciseId,
    required double weightKg,
    required int reps,
    required DateTime achievedAt,
    this.sessionId = const Value.absent(),
    this.previousWeightKg = const Value.absent(),
  })  : exerciseId = Value(exerciseId),
        weightKg = Value(weightKg),
        reps = Value(reps),
        achievedAt = Value(achievedAt);
  static Insertable<StrengthPREntity> custom({
    Expression<int>? id,
    Expression<String>? exerciseId,
    Expression<double>? weightKg,
    Expression<int>? reps,
    Expression<DateTime>? achievedAt,
    Expression<String>? sessionId,
    Expression<double>? previousWeightKg,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (weightKg != null) 'weight_kg': weightKg,
      if (reps != null) 'reps': reps,
      if (achievedAt != null) 'achieved_at': achievedAt,
      if (sessionId != null) 'session_id': sessionId,
      if (previousWeightKg != null) 'previous_weight_kg': previousWeightKg,
    });
  }

  StrengthPersonalRecordsCompanion copyWith(
      {Value<int>? id,
      Value<String>? exerciseId,
      Value<double>? weightKg,
      Value<int>? reps,
      Value<DateTime>? achievedAt,
      Value<String?>? sessionId,
      Value<double?>? previousWeightKg}) {
    return StrengthPersonalRecordsCompanion(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      weightKg: weightKg ?? this.weightKg,
      reps: reps ?? this.reps,
      achievedAt: achievedAt ?? this.achievedAt,
      sessionId: sessionId ?? this.sessionId,
      previousWeightKg: previousWeightKg ?? this.previousWeightKg,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (achievedAt.present) {
      map['achieved_at'] = Variable<DateTime>(achievedAt.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (previousWeightKg.present) {
      map['previous_weight_kg'] = Variable<double>(previousWeightKg.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StrengthPersonalRecordsCompanion(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('weightKg: $weightKg, ')
          ..write('reps: $reps, ')
          ..write('achievedAt: $achievedAt, ')
          ..write('sessionId: $sessionId, ')
          ..write('previousWeightKg: $previousWeightKg')
          ..write(')'))
        .toString();
  }
}

class $ScheduledWorkoutsTable extends ScheduledWorkouts
    with TableInfo<$ScheduledWorkoutsTable, ScheduledWorkoutEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduledWorkoutsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _workoutIdMeta =
      const VerificationMeta('workoutId');
  @override
  late final GeneratedColumn<String> workoutId = GeneratedColumn<String>(
      'workout_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _workoutTypeMeta =
      const VerificationMeta('workoutType');
  @override
  late final GeneratedColumn<String> workoutType = GeneratedColumn<String>(
      'workout_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scheduledDateMeta =
      const VerificationMeta('scheduledDate');
  @override
  late final GeneratedColumn<DateTime> scheduledDate =
      GeneratedColumn<DateTime>('scheduled_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _scheduledTimeMinutesMeta =
      const VerificationMeta('scheduledTimeMinutes');
  @override
  late final GeneratedColumn<int> scheduledTimeMinutes = GeneratedColumn<int>(
      'scheduled_time_minutes', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _completedSessionIdMeta =
      const VerificationMeta('completedSessionId');
  @override
  late final GeneratedColumn<String> completedSessionId =
      GeneratedColumn<String>('completed_session_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        workoutId,
        workoutType,
        scheduledDate,
        scheduledTimeMinutes,
        status,
        completedSessionId,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scheduled_workouts';
  @override
  VerificationContext validateIntegrity(
      Insertable<ScheduledWorkoutEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workout_id')) {
      context.handle(_workoutIdMeta,
          workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta));
    } else if (isInserting) {
      context.missing(_workoutIdMeta);
    }
    if (data.containsKey('workout_type')) {
      context.handle(
          _workoutTypeMeta,
          workoutType.isAcceptableOrUnknown(
              data['workout_type']!, _workoutTypeMeta));
    } else if (isInserting) {
      context.missing(_workoutTypeMeta);
    }
    if (data.containsKey('scheduled_date')) {
      context.handle(
          _scheduledDateMeta,
          scheduledDate.isAcceptableOrUnknown(
              data['scheduled_date']!, _scheduledDateMeta));
    } else if (isInserting) {
      context.missing(_scheduledDateMeta);
    }
    if (data.containsKey('scheduled_time_minutes')) {
      context.handle(
          _scheduledTimeMinutesMeta,
          scheduledTimeMinutes.isAcceptableOrUnknown(
              data['scheduled_time_minutes']!, _scheduledTimeMinutesMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('completed_session_id')) {
      context.handle(
          _completedSessionIdMeta,
          completedSessionId.isAcceptableOrUnknown(
              data['completed_session_id']!, _completedSessionIdMeta));
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
  ScheduledWorkoutEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduledWorkoutEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      workoutId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}workout_id'])!,
      workoutType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}workout_type'])!,
      scheduledDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}scheduled_date'])!,
      scheduledTimeMinutes: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}scheduled_time_minutes']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      completedSessionId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}completed_session_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ScheduledWorkoutsTable createAlias(String alias) {
    return $ScheduledWorkoutsTable(attachedDatabase, alias);
  }
}

class ScheduledWorkoutEntity extends DataClass
    implements Insertable<ScheduledWorkoutEntity> {
  final String id;
  final String workoutId;
  final String workoutType;
  final DateTime scheduledDate;
  final int? scheduledTimeMinutes;
  final String status;
  final String? completedSessionId;
  final DateTime createdAt;
  const ScheduledWorkoutEntity(
      {required this.id,
      required this.workoutId,
      required this.workoutType,
      required this.scheduledDate,
      this.scheduledTimeMinutes,
      required this.status,
      this.completedSessionId,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workout_id'] = Variable<String>(workoutId);
    map['workout_type'] = Variable<String>(workoutType);
    map['scheduled_date'] = Variable<DateTime>(scheduledDate);
    if (!nullToAbsent || scheduledTimeMinutes != null) {
      map['scheduled_time_minutes'] = Variable<int>(scheduledTimeMinutes);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || completedSessionId != null) {
      map['completed_session_id'] = Variable<String>(completedSessionId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ScheduledWorkoutsCompanion toCompanion(bool nullToAbsent) {
    return ScheduledWorkoutsCompanion(
      id: Value(id),
      workoutId: Value(workoutId),
      workoutType: Value(workoutType),
      scheduledDate: Value(scheduledDate),
      scheduledTimeMinutes: scheduledTimeMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledTimeMinutes),
      status: Value(status),
      completedSessionId: completedSessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(completedSessionId),
      createdAt: Value(createdAt),
    );
  }

  factory ScheduledWorkoutEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduledWorkoutEntity(
      id: serializer.fromJson<String>(json['id']),
      workoutId: serializer.fromJson<String>(json['workoutId']),
      workoutType: serializer.fromJson<String>(json['workoutType']),
      scheduledDate: serializer.fromJson<DateTime>(json['scheduledDate']),
      scheduledTimeMinutes:
          serializer.fromJson<int?>(json['scheduledTimeMinutes']),
      status: serializer.fromJson<String>(json['status']),
      completedSessionId:
          serializer.fromJson<String?>(json['completedSessionId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workoutId': serializer.toJson<String>(workoutId),
      'workoutType': serializer.toJson<String>(workoutType),
      'scheduledDate': serializer.toJson<DateTime>(scheduledDate),
      'scheduledTimeMinutes': serializer.toJson<int?>(scheduledTimeMinutes),
      'status': serializer.toJson<String>(status),
      'completedSessionId': serializer.toJson<String?>(completedSessionId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ScheduledWorkoutEntity copyWith(
          {String? id,
          String? workoutId,
          String? workoutType,
          DateTime? scheduledDate,
          Value<int?> scheduledTimeMinutes = const Value.absent(),
          String? status,
          Value<String?> completedSessionId = const Value.absent(),
          DateTime? createdAt}) =>
      ScheduledWorkoutEntity(
        id: id ?? this.id,
        workoutId: workoutId ?? this.workoutId,
        workoutType: workoutType ?? this.workoutType,
        scheduledDate: scheduledDate ?? this.scheduledDate,
        scheduledTimeMinutes: scheduledTimeMinutes.present
            ? scheduledTimeMinutes.value
            : this.scheduledTimeMinutes,
        status: status ?? this.status,
        completedSessionId: completedSessionId.present
            ? completedSessionId.value
            : this.completedSessionId,
        createdAt: createdAt ?? this.createdAt,
      );
  ScheduledWorkoutEntity copyWithCompanion(ScheduledWorkoutsCompanion data) {
    return ScheduledWorkoutEntity(
      id: data.id.present ? data.id.value : this.id,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
      workoutType:
          data.workoutType.present ? data.workoutType.value : this.workoutType,
      scheduledDate: data.scheduledDate.present
          ? data.scheduledDate.value
          : this.scheduledDate,
      scheduledTimeMinutes: data.scheduledTimeMinutes.present
          ? data.scheduledTimeMinutes.value
          : this.scheduledTimeMinutes,
      status: data.status.present ? data.status.value : this.status,
      completedSessionId: data.completedSessionId.present
          ? data.completedSessionId.value
          : this.completedSessionId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledWorkoutEntity(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('workoutType: $workoutType, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('scheduledTimeMinutes: $scheduledTimeMinutes, ')
          ..write('status: $status, ')
          ..write('completedSessionId: $completedSessionId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, workoutId, workoutType, scheduledDate,
      scheduledTimeMinutes, status, completedSessionId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduledWorkoutEntity &&
          other.id == this.id &&
          other.workoutId == this.workoutId &&
          other.workoutType == this.workoutType &&
          other.scheduledDate == this.scheduledDate &&
          other.scheduledTimeMinutes == this.scheduledTimeMinutes &&
          other.status == this.status &&
          other.completedSessionId == this.completedSessionId &&
          other.createdAt == this.createdAt);
}

class ScheduledWorkoutsCompanion
    extends UpdateCompanion<ScheduledWorkoutEntity> {
  final Value<String> id;
  final Value<String> workoutId;
  final Value<String> workoutType;
  final Value<DateTime> scheduledDate;
  final Value<int?> scheduledTimeMinutes;
  final Value<String> status;
  final Value<String?> completedSessionId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ScheduledWorkoutsCompanion({
    this.id = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.workoutType = const Value.absent(),
    this.scheduledDate = const Value.absent(),
    this.scheduledTimeMinutes = const Value.absent(),
    this.status = const Value.absent(),
    this.completedSessionId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScheduledWorkoutsCompanion.insert({
    required String id,
    required String workoutId,
    required String workoutType,
    required DateTime scheduledDate,
    this.scheduledTimeMinutes = const Value.absent(),
    required String status,
    this.completedSessionId = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        workoutId = Value(workoutId),
        workoutType = Value(workoutType),
        scheduledDate = Value(scheduledDate),
        status = Value(status),
        createdAt = Value(createdAt);
  static Insertable<ScheduledWorkoutEntity> custom({
    Expression<String>? id,
    Expression<String>? workoutId,
    Expression<String>? workoutType,
    Expression<DateTime>? scheduledDate,
    Expression<int>? scheduledTimeMinutes,
    Expression<String>? status,
    Expression<String>? completedSessionId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutId != null) 'workout_id': workoutId,
      if (workoutType != null) 'workout_type': workoutType,
      if (scheduledDate != null) 'scheduled_date': scheduledDate,
      if (scheduledTimeMinutes != null)
        'scheduled_time_minutes': scheduledTimeMinutes,
      if (status != null) 'status': status,
      if (completedSessionId != null)
        'completed_session_id': completedSessionId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScheduledWorkoutsCompanion copyWith(
      {Value<String>? id,
      Value<String>? workoutId,
      Value<String>? workoutType,
      Value<DateTime>? scheduledDate,
      Value<int?>? scheduledTimeMinutes,
      Value<String>? status,
      Value<String?>? completedSessionId,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ScheduledWorkoutsCompanion(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      workoutType: workoutType ?? this.workoutType,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      scheduledTimeMinutes: scheduledTimeMinutes ?? this.scheduledTimeMinutes,
      status: status ?? this.status,
      completedSessionId: completedSessionId ?? this.completedSessionId,
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
    if (workoutId.present) {
      map['workout_id'] = Variable<String>(workoutId.value);
    }
    if (workoutType.present) {
      map['workout_type'] = Variable<String>(workoutType.value);
    }
    if (scheduledDate.present) {
      map['scheduled_date'] = Variable<DateTime>(scheduledDate.value);
    }
    if (scheduledTimeMinutes.present) {
      map['scheduled_time_minutes'] = Variable<int>(scheduledTimeMinutes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (completedSessionId.present) {
      map['completed_session_id'] = Variable<String>(completedSessionId.value);
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
    return (StringBuffer('ScheduledWorkoutsCompanion(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('workoutType: $workoutType, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('scheduledTimeMinutes: $scheduledTimeMinutes, ')
          ..write('status: $status, ')
          ..write('completedSessionId: $completedSessionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
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
  late final $StrengthExercisesTable strengthExercises =
      $StrengthExercisesTable(this);
  late final $StrengthWorkoutsTable strengthWorkouts =
      $StrengthWorkoutsTable(this);
  late final $StrengthSessionsTable strengthSessions =
      $StrengthSessionsTable(this);
  late final $StrengthPersonalRecordsTable strengthPersonalRecords =
      $StrengthPersonalRecordsTable(this);
  late final $ScheduledWorkoutsTable scheduledWorkouts =
      $ScheduledWorkoutsTable(this);
  late final SessionDao sessionDao = SessionDao(this as AppDatabase);
  late final WorkoutDao workoutDao = WorkoutDao(this as AppDatabase);
  late final GpxRouteDao gpxRouteDao = GpxRouteDao(this as AppDatabase);
  late final PersonalRecordDao personalRecordDao =
      PersonalRecordDao(this as AppDatabase);
  late final StrengthExerciseDao strengthExerciseDao =
      StrengthExerciseDao(this as AppDatabase);
  late final StrengthWorkoutDao strengthWorkoutDao =
      StrengthWorkoutDao(this as AppDatabase);
  late final StrengthSessionDao strengthSessionDao =
      StrengthSessionDao(this as AppDatabase);
  late final StrengthPRDao strengthPRDao = StrengthPRDao(this as AppDatabase);
  late final ScheduledWorkoutDao scheduledWorkoutDao =
      ScheduledWorkoutDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        trainingSessions,
        dataPoints,
        customWorkouts,
        gpxRoutes,
        personalRecords,
        strengthExercises,
        strengthWorkouts,
        strengthSessions,
        strengthPersonalRecords,
        scheduledWorkouts
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

typedef $$StrengthExercisesTableCreateCompanionBuilder
    = StrengthExercisesCompanion Function({
  required String id,
  required String name,
  required String description,
  required String primaryMusclesJson,
  required String secondaryMusclesJson,
  required String equipment,
  required String formCues,
  Value<String?> videoUrl,
  required String difficulty,
  Value<bool> isCompound,
  Value<int> minimumAge,
  Value<int?> maximumAge,
  Value<bool> requiresModification50Plus,
  Value<String?> modification50PlusNotes,
  Value<int> rowid,
});
typedef $$StrengthExercisesTableUpdateCompanionBuilder
    = StrengthExercisesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> description,
  Value<String> primaryMusclesJson,
  Value<String> secondaryMusclesJson,
  Value<String> equipment,
  Value<String> formCues,
  Value<String?> videoUrl,
  Value<String> difficulty,
  Value<bool> isCompound,
  Value<int> minimumAge,
  Value<int?> maximumAge,
  Value<bool> requiresModification50Plus,
  Value<String?> modification50PlusNotes,
  Value<int> rowid,
});

class $$StrengthExercisesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StrengthExercisesTable,
    StrengthExerciseEntity,
    $$StrengthExercisesTableFilterComposer,
    $$StrengthExercisesTableOrderingComposer,
    $$StrengthExercisesTableCreateCompanionBuilder,
    $$StrengthExercisesTableUpdateCompanionBuilder> {
  $$StrengthExercisesTableTableManager(
      _$AppDatabase db, $StrengthExercisesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$StrengthExercisesTableFilterComposer(ComposerState(db, table)),
          orderingComposer: $$StrengthExercisesTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> primaryMusclesJson = const Value.absent(),
            Value<String> secondaryMusclesJson = const Value.absent(),
            Value<String> equipment = const Value.absent(),
            Value<String> formCues = const Value.absent(),
            Value<String?> videoUrl = const Value.absent(),
            Value<String> difficulty = const Value.absent(),
            Value<bool> isCompound = const Value.absent(),
            Value<int> minimumAge = const Value.absent(),
            Value<int?> maximumAge = const Value.absent(),
            Value<bool> requiresModification50Plus = const Value.absent(),
            Value<String?> modification50PlusNotes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StrengthExercisesCompanion(
            id: id,
            name: name,
            description: description,
            primaryMusclesJson: primaryMusclesJson,
            secondaryMusclesJson: secondaryMusclesJson,
            equipment: equipment,
            formCues: formCues,
            videoUrl: videoUrl,
            difficulty: difficulty,
            isCompound: isCompound,
            minimumAge: minimumAge,
            maximumAge: maximumAge,
            requiresModification50Plus: requiresModification50Plus,
            modification50PlusNotes: modification50PlusNotes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String description,
            required String primaryMusclesJson,
            required String secondaryMusclesJson,
            required String equipment,
            required String formCues,
            Value<String?> videoUrl = const Value.absent(),
            required String difficulty,
            Value<bool> isCompound = const Value.absent(),
            Value<int> minimumAge = const Value.absent(),
            Value<int?> maximumAge = const Value.absent(),
            Value<bool> requiresModification50Plus = const Value.absent(),
            Value<String?> modification50PlusNotes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StrengthExercisesCompanion.insert(
            id: id,
            name: name,
            description: description,
            primaryMusclesJson: primaryMusclesJson,
            secondaryMusclesJson: secondaryMusclesJson,
            equipment: equipment,
            formCues: formCues,
            videoUrl: videoUrl,
            difficulty: difficulty,
            isCompound: isCompound,
            minimumAge: minimumAge,
            maximumAge: maximumAge,
            requiresModification50Plus: requiresModification50Plus,
            modification50PlusNotes: modification50PlusNotes,
            rowid: rowid,
          ),
        ));
}

class $$StrengthExercisesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $StrengthExercisesTable> {
  $$StrengthExercisesTableFilterComposer(super.$state);
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

  ColumnFilters<String> get primaryMusclesJson => $state.composableBuilder(
      column: $state.table.primaryMusclesJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get secondaryMusclesJson => $state.composableBuilder(
      column: $state.table.secondaryMusclesJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get equipment => $state.composableBuilder(
      column: $state.table.equipment,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get formCues => $state.composableBuilder(
      column: $state.table.formCues,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get videoUrl => $state.composableBuilder(
      column: $state.table.videoUrl,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get difficulty => $state.composableBuilder(
      column: $state.table.difficulty,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isCompound => $state.composableBuilder(
      column: $state.table.isCompound,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get minimumAge => $state.composableBuilder(
      column: $state.table.minimumAge,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get maximumAge => $state.composableBuilder(
      column: $state.table.maximumAge,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get requiresModification50Plus =>
      $state.composableBuilder(
          column: $state.table.requiresModification50Plus,
          builder: (column, joinBuilders) =>
              ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get modification50PlusNotes => $state.composableBuilder(
      column: $state.table.modification50PlusNotes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$StrengthExercisesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $StrengthExercisesTable> {
  $$StrengthExercisesTableOrderingComposer(super.$state);
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

  ColumnOrderings<String> get primaryMusclesJson => $state.composableBuilder(
      column: $state.table.primaryMusclesJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get secondaryMusclesJson => $state.composableBuilder(
      column: $state.table.secondaryMusclesJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get equipment => $state.composableBuilder(
      column: $state.table.equipment,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get formCues => $state.composableBuilder(
      column: $state.table.formCues,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get videoUrl => $state.composableBuilder(
      column: $state.table.videoUrl,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get difficulty => $state.composableBuilder(
      column: $state.table.difficulty,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isCompound => $state.composableBuilder(
      column: $state.table.isCompound,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get minimumAge => $state.composableBuilder(
      column: $state.table.minimumAge,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get maximumAge => $state.composableBuilder(
      column: $state.table.maximumAge,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get requiresModification50Plus =>
      $state.composableBuilder(
          column: $state.table.requiresModification50Plus,
          builder: (column, joinBuilders) =>
              ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get modification50PlusNotes =>
      $state.composableBuilder(
          column: $state.table.modification50PlusNotes,
          builder: (column, joinBuilders) =>
              ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$StrengthWorkoutsTableCreateCompanionBuilder
    = StrengthWorkoutsCompanion Function({
  required String id,
  required String name,
  required String description,
  required String intervalsJson,
  required String workoutType,
  required int estimatedDurationMinutes,
  required String difficulty,
  Value<bool> isCustom,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$StrengthWorkoutsTableUpdateCompanionBuilder
    = StrengthWorkoutsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> description,
  Value<String> intervalsJson,
  Value<String> workoutType,
  Value<int> estimatedDurationMinutes,
  Value<String> difficulty,
  Value<bool> isCustom,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$StrengthWorkoutsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StrengthWorkoutsTable,
    StrengthWorkoutEntity,
    $$StrengthWorkoutsTableFilterComposer,
    $$StrengthWorkoutsTableOrderingComposer,
    $$StrengthWorkoutsTableCreateCompanionBuilder,
    $$StrengthWorkoutsTableUpdateCompanionBuilder> {
  $$StrengthWorkoutsTableTableManager(
      _$AppDatabase db, $StrengthWorkoutsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$StrengthWorkoutsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$StrengthWorkoutsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> intervalsJson = const Value.absent(),
            Value<String> workoutType = const Value.absent(),
            Value<int> estimatedDurationMinutes = const Value.absent(),
            Value<String> difficulty = const Value.absent(),
            Value<bool> isCustom = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StrengthWorkoutsCompanion(
            id: id,
            name: name,
            description: description,
            intervalsJson: intervalsJson,
            workoutType: workoutType,
            estimatedDurationMinutes: estimatedDurationMinutes,
            difficulty: difficulty,
            isCustom: isCustom,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String description,
            required String intervalsJson,
            required String workoutType,
            required int estimatedDurationMinutes,
            required String difficulty,
            Value<bool> isCustom = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              StrengthWorkoutsCompanion.insert(
            id: id,
            name: name,
            description: description,
            intervalsJson: intervalsJson,
            workoutType: workoutType,
            estimatedDurationMinutes: estimatedDurationMinutes,
            difficulty: difficulty,
            isCustom: isCustom,
            createdAt: createdAt,
            rowid: rowid,
          ),
        ));
}

class $$StrengthWorkoutsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $StrengthWorkoutsTable> {
  $$StrengthWorkoutsTableFilterComposer(super.$state);
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

  ColumnFilters<String> get intervalsJson => $state.composableBuilder(
      column: $state.table.intervalsJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get workoutType => $state.composableBuilder(
      column: $state.table.workoutType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get estimatedDurationMinutes => $state.composableBuilder(
      column: $state.table.estimatedDurationMinutes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get difficulty => $state.composableBuilder(
      column: $state.table.difficulty,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isCustom => $state.composableBuilder(
      column: $state.table.isCustom,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$StrengthWorkoutsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $StrengthWorkoutsTable> {
  $$StrengthWorkoutsTableOrderingComposer(super.$state);
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

  ColumnOrderings<String> get intervalsJson => $state.composableBuilder(
      column: $state.table.intervalsJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get workoutType => $state.composableBuilder(
      column: $state.table.workoutType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get estimatedDurationMinutes => $state.composableBuilder(
      column: $state.table.estimatedDurationMinutes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get difficulty => $state.composableBuilder(
      column: $state.table.difficulty,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isCustom => $state.composableBuilder(
      column: $state.table.isCustom,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$StrengthSessionsTableCreateCompanionBuilder
    = StrengthSessionsCompanion Function({
  required String id,
  required int startTimeMs,
  Value<int?> endTimeMs,
  Value<String?> workoutId,
  required String exercisesJson,
  Value<int> statsDurationSecs,
  Value<int> statsTotalSets,
  Value<int> statsTotalReps,
  Value<double> statsTotalVolume,
  Value<int?> statsAvgRpe,
  Value<int> statsExercisesCompleted,
  Value<String> statsMuscleGroupWorkJson,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$StrengthSessionsTableUpdateCompanionBuilder
    = StrengthSessionsCompanion Function({
  Value<String> id,
  Value<int> startTimeMs,
  Value<int?> endTimeMs,
  Value<String?> workoutId,
  Value<String> exercisesJson,
  Value<int> statsDurationSecs,
  Value<int> statsTotalSets,
  Value<int> statsTotalReps,
  Value<double> statsTotalVolume,
  Value<int?> statsAvgRpe,
  Value<int> statsExercisesCompleted,
  Value<String> statsMuscleGroupWorkJson,
  Value<String?> notes,
  Value<int> rowid,
});

class $$StrengthSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StrengthSessionsTable,
    StrengthSessionEntity,
    $$StrengthSessionsTableFilterComposer,
    $$StrengthSessionsTableOrderingComposer,
    $$StrengthSessionsTableCreateCompanionBuilder,
    $$StrengthSessionsTableUpdateCompanionBuilder> {
  $$StrengthSessionsTableTableManager(
      _$AppDatabase db, $StrengthSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$StrengthSessionsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$StrengthSessionsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> startTimeMs = const Value.absent(),
            Value<int?> endTimeMs = const Value.absent(),
            Value<String?> workoutId = const Value.absent(),
            Value<String> exercisesJson = const Value.absent(),
            Value<int> statsDurationSecs = const Value.absent(),
            Value<int> statsTotalSets = const Value.absent(),
            Value<int> statsTotalReps = const Value.absent(),
            Value<double> statsTotalVolume = const Value.absent(),
            Value<int?> statsAvgRpe = const Value.absent(),
            Value<int> statsExercisesCompleted = const Value.absent(),
            Value<String> statsMuscleGroupWorkJson = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StrengthSessionsCompanion(
            id: id,
            startTimeMs: startTimeMs,
            endTimeMs: endTimeMs,
            workoutId: workoutId,
            exercisesJson: exercisesJson,
            statsDurationSecs: statsDurationSecs,
            statsTotalSets: statsTotalSets,
            statsTotalReps: statsTotalReps,
            statsTotalVolume: statsTotalVolume,
            statsAvgRpe: statsAvgRpe,
            statsExercisesCompleted: statsExercisesCompleted,
            statsMuscleGroupWorkJson: statsMuscleGroupWorkJson,
            notes: notes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required int startTimeMs,
            Value<int?> endTimeMs = const Value.absent(),
            Value<String?> workoutId = const Value.absent(),
            required String exercisesJson,
            Value<int> statsDurationSecs = const Value.absent(),
            Value<int> statsTotalSets = const Value.absent(),
            Value<int> statsTotalReps = const Value.absent(),
            Value<double> statsTotalVolume = const Value.absent(),
            Value<int?> statsAvgRpe = const Value.absent(),
            Value<int> statsExercisesCompleted = const Value.absent(),
            Value<String> statsMuscleGroupWorkJson = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StrengthSessionsCompanion.insert(
            id: id,
            startTimeMs: startTimeMs,
            endTimeMs: endTimeMs,
            workoutId: workoutId,
            exercisesJson: exercisesJson,
            statsDurationSecs: statsDurationSecs,
            statsTotalSets: statsTotalSets,
            statsTotalReps: statsTotalReps,
            statsTotalVolume: statsTotalVolume,
            statsAvgRpe: statsAvgRpe,
            statsExercisesCompleted: statsExercisesCompleted,
            statsMuscleGroupWorkJson: statsMuscleGroupWorkJson,
            notes: notes,
            rowid: rowid,
          ),
        ));
}

class $$StrengthSessionsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $StrengthSessionsTable> {
  $$StrengthSessionsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get startTimeMs => $state.composableBuilder(
      column: $state.table.startTimeMs,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get endTimeMs => $state.composableBuilder(
      column: $state.table.endTimeMs,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get workoutId => $state.composableBuilder(
      column: $state.table.workoutId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get exercisesJson => $state.composableBuilder(
      column: $state.table.exercisesJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get statsDurationSecs => $state.composableBuilder(
      column: $state.table.statsDurationSecs,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get statsTotalSets => $state.composableBuilder(
      column: $state.table.statsTotalSets,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get statsTotalReps => $state.composableBuilder(
      column: $state.table.statsTotalReps,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get statsTotalVolume => $state.composableBuilder(
      column: $state.table.statsTotalVolume,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get statsAvgRpe => $state.composableBuilder(
      column: $state.table.statsAvgRpe,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get statsExercisesCompleted => $state.composableBuilder(
      column: $state.table.statsExercisesCompleted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get statsMuscleGroupWorkJson =>
      $state.composableBuilder(
          column: $state.table.statsMuscleGroupWorkJson,
          builder: (column, joinBuilders) =>
              ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$StrengthSessionsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $StrengthSessionsTable> {
  $$StrengthSessionsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get startTimeMs => $state.composableBuilder(
      column: $state.table.startTimeMs,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get endTimeMs => $state.composableBuilder(
      column: $state.table.endTimeMs,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get workoutId => $state.composableBuilder(
      column: $state.table.workoutId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get exercisesJson => $state.composableBuilder(
      column: $state.table.exercisesJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get statsDurationSecs => $state.composableBuilder(
      column: $state.table.statsDurationSecs,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get statsTotalSets => $state.composableBuilder(
      column: $state.table.statsTotalSets,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get statsTotalReps => $state.composableBuilder(
      column: $state.table.statsTotalReps,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get statsTotalVolume => $state.composableBuilder(
      column: $state.table.statsTotalVolume,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get statsAvgRpe => $state.composableBuilder(
      column: $state.table.statsAvgRpe,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get statsExercisesCompleted => $state.composableBuilder(
      column: $state.table.statsExercisesCompleted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get statsMuscleGroupWorkJson =>
      $state.composableBuilder(
          column: $state.table.statsMuscleGroupWorkJson,
          builder: (column, joinBuilders) =>
              ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$StrengthPersonalRecordsTableCreateCompanionBuilder
    = StrengthPersonalRecordsCompanion Function({
  Value<int> id,
  required String exerciseId,
  required double weightKg,
  required int reps,
  required DateTime achievedAt,
  Value<String?> sessionId,
  Value<double?> previousWeightKg,
});
typedef $$StrengthPersonalRecordsTableUpdateCompanionBuilder
    = StrengthPersonalRecordsCompanion Function({
  Value<int> id,
  Value<String> exerciseId,
  Value<double> weightKg,
  Value<int> reps,
  Value<DateTime> achievedAt,
  Value<String?> sessionId,
  Value<double?> previousWeightKg,
});

class $$StrengthPersonalRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StrengthPersonalRecordsTable,
    StrengthPREntity,
    $$StrengthPersonalRecordsTableFilterComposer,
    $$StrengthPersonalRecordsTableOrderingComposer,
    $$StrengthPersonalRecordsTableCreateCompanionBuilder,
    $$StrengthPersonalRecordsTableUpdateCompanionBuilder> {
  $$StrengthPersonalRecordsTableTableManager(
      _$AppDatabase db, $StrengthPersonalRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$StrengthPersonalRecordsTableFilterComposer(
              ComposerState(db, table)),
          orderingComposer: $$StrengthPersonalRecordsTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> exerciseId = const Value.absent(),
            Value<double> weightKg = const Value.absent(),
            Value<int> reps = const Value.absent(),
            Value<DateTime> achievedAt = const Value.absent(),
            Value<String?> sessionId = const Value.absent(),
            Value<double?> previousWeightKg = const Value.absent(),
          }) =>
              StrengthPersonalRecordsCompanion(
            id: id,
            exerciseId: exerciseId,
            weightKg: weightKg,
            reps: reps,
            achievedAt: achievedAt,
            sessionId: sessionId,
            previousWeightKg: previousWeightKg,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String exerciseId,
            required double weightKg,
            required int reps,
            required DateTime achievedAt,
            Value<String?> sessionId = const Value.absent(),
            Value<double?> previousWeightKg = const Value.absent(),
          }) =>
              StrengthPersonalRecordsCompanion.insert(
            id: id,
            exerciseId: exerciseId,
            weightKg: weightKg,
            reps: reps,
            achievedAt: achievedAt,
            sessionId: sessionId,
            previousWeightKg: previousWeightKg,
          ),
        ));
}

class $$StrengthPersonalRecordsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $StrengthPersonalRecordsTable> {
  $$StrengthPersonalRecordsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get exerciseId => $state.composableBuilder(
      column: $state.table.exerciseId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get weightKg => $state.composableBuilder(
      column: $state.table.weightKg,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get reps => $state.composableBuilder(
      column: $state.table.reps,
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

  ColumnFilters<double> get previousWeightKg => $state.composableBuilder(
      column: $state.table.previousWeightKg,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$StrengthPersonalRecordsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $StrengthPersonalRecordsTable> {
  $$StrengthPersonalRecordsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get exerciseId => $state.composableBuilder(
      column: $state.table.exerciseId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get weightKg => $state.composableBuilder(
      column: $state.table.weightKg,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get reps => $state.composableBuilder(
      column: $state.table.reps,
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

  ColumnOrderings<double> get previousWeightKg => $state.composableBuilder(
      column: $state.table.previousWeightKg,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$ScheduledWorkoutsTableCreateCompanionBuilder
    = ScheduledWorkoutsCompanion Function({
  required String id,
  required String workoutId,
  required String workoutType,
  required DateTime scheduledDate,
  Value<int?> scheduledTimeMinutes,
  required String status,
  Value<String?> completedSessionId,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$ScheduledWorkoutsTableUpdateCompanionBuilder
    = ScheduledWorkoutsCompanion Function({
  Value<String> id,
  Value<String> workoutId,
  Value<String> workoutType,
  Value<DateTime> scheduledDate,
  Value<int?> scheduledTimeMinutes,
  Value<String> status,
  Value<String?> completedSessionId,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$ScheduledWorkoutsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ScheduledWorkoutsTable,
    ScheduledWorkoutEntity,
    $$ScheduledWorkoutsTableFilterComposer,
    $$ScheduledWorkoutsTableOrderingComposer,
    $$ScheduledWorkoutsTableCreateCompanionBuilder,
    $$ScheduledWorkoutsTableUpdateCompanionBuilder> {
  $$ScheduledWorkoutsTableTableManager(
      _$AppDatabase db, $ScheduledWorkoutsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ScheduledWorkoutsTableFilterComposer(ComposerState(db, table)),
          orderingComposer: $$ScheduledWorkoutsTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> workoutId = const Value.absent(),
            Value<String> workoutType = const Value.absent(),
            Value<DateTime> scheduledDate = const Value.absent(),
            Value<int?> scheduledTimeMinutes = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> completedSessionId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ScheduledWorkoutsCompanion(
            id: id,
            workoutId: workoutId,
            workoutType: workoutType,
            scheduledDate: scheduledDate,
            scheduledTimeMinutes: scheduledTimeMinutes,
            status: status,
            completedSessionId: completedSessionId,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String workoutId,
            required String workoutType,
            required DateTime scheduledDate,
            Value<int?> scheduledTimeMinutes = const Value.absent(),
            required String status,
            Value<String?> completedSessionId = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ScheduledWorkoutsCompanion.insert(
            id: id,
            workoutId: workoutId,
            workoutType: workoutType,
            scheduledDate: scheduledDate,
            scheduledTimeMinutes: scheduledTimeMinutes,
            status: status,
            completedSessionId: completedSessionId,
            createdAt: createdAt,
            rowid: rowid,
          ),
        ));
}

class $$ScheduledWorkoutsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ScheduledWorkoutsTable> {
  $$ScheduledWorkoutsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get workoutId => $state.composableBuilder(
      column: $state.table.workoutId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get workoutType => $state.composableBuilder(
      column: $state.table.workoutType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get scheduledDate => $state.composableBuilder(
      column: $state.table.scheduledDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get scheduledTimeMinutes => $state.composableBuilder(
      column: $state.table.scheduledTimeMinutes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get completedSessionId => $state.composableBuilder(
      column: $state.table.completedSessionId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$ScheduledWorkoutsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ScheduledWorkoutsTable> {
  $$ScheduledWorkoutsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get workoutId => $state.composableBuilder(
      column: $state.table.workoutId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get workoutType => $state.composableBuilder(
      column: $state.table.workoutType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get scheduledDate => $state.composableBuilder(
      column: $state.table.scheduledDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get scheduledTimeMinutes => $state.composableBuilder(
      column: $state.table.scheduledTimeMinutes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get completedSessionId => $state.composableBuilder(
      column: $state.table.completedSessionId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
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
  $$StrengthExercisesTableTableManager get strengthExercises =>
      $$StrengthExercisesTableTableManager(_db, _db.strengthExercises);
  $$StrengthWorkoutsTableTableManager get strengthWorkouts =>
      $$StrengthWorkoutsTableTableManager(_db, _db.strengthWorkouts);
  $$StrengthSessionsTableTableManager get strengthSessions =>
      $$StrengthSessionsTableTableManager(_db, _db.strengthSessions);
  $$StrengthPersonalRecordsTableTableManager get strengthPersonalRecords =>
      $$StrengthPersonalRecordsTableTableManager(
          _db, _db.strengthPersonalRecords);
  $$ScheduledWorkoutsTableTableManager get scheduledWorkouts =>
      $$ScheduledWorkoutsTableTableManager(_db, _db.scheduledWorkouts);
}
