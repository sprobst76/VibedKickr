// GENERATED CODE - DO NOT MODIFY BY HAND
// Run: dart run build_runner build --delete-conflicting-outputs

part of 'workout.dart';

// **************************************************************************
// JsonSerializableGenerator - Placeholder
// Diese Datei wird durch build_runner generiert.
// Führe aus: dart run build_runner build --delete-conflicting-outputs
// **************************************************************************

PowerTarget _$PowerTargetFromJson(Map<String, dynamic> json) => PowerTarget._(
      type: $enumDecode(_$PowerTargetTypeEnumMap, json['type']),
      watts: json['watts'] as int?,
      ftpPercent: json['ftpPercent'] as int?,
      minWatts: json['minWatts'] as int?,
      maxWatts: json['maxWatts'] as int?,
    );

Map<String, dynamic> _$PowerTargetToJson(PowerTarget instance) =>
    <String, dynamic>{
      'type': _$PowerTargetTypeEnumMap[instance.type]!,
      'watts': instance.watts,
      'ftpPercent': instance.ftpPercent,
      'minWatts': instance.minWatts,
      'maxWatts': instance.maxWatts,
    };

const _$PowerTargetTypeEnumMap = {
  PowerTargetType.absolute: 'absolute',
  PowerTargetType.ftpPercent: 'ftpPercent',
  PowerTargetType.range: 'range',
  PowerTargetType.free: 'free',
};

WorkoutInterval _$WorkoutIntervalFromJson(Map<String, dynamic> json) =>
    WorkoutInterval(
      name: json['name'] as String,
      duration: Duration(microseconds: json['duration'] as int),
      type: $enumDecode(_$IntervalTypeEnumMap, json['type']),
      powerTarget:
          PowerTarget.fromJson(json['powerTarget'] as Map<String, dynamic>),
      cadenceMin: json['cadenceMin'] as int?,
      cadenceMax: json['cadenceMax'] as int?,
      instructions: json['instructions'] as String?,
    );

Map<String, dynamic> _$WorkoutIntervalToJson(WorkoutInterval instance) =>
    <String, dynamic>{
      'name': instance.name,
      'duration': instance.duration.inMicroseconds,
      'type': _$IntervalTypeEnumMap[instance.type]!,
      'powerTarget': instance.powerTarget.toJson(),
      'cadenceMin': instance.cadenceMin,
      'cadenceMax': instance.cadenceMax,
      'instructions': instance.instructions,
    };

const _$IntervalTypeEnumMap = {
  IntervalType.warmup: 'warmup',
  IntervalType.work: 'work',
  IntervalType.rest: 'rest',
  IntervalType.cooldown: 'cooldown',
  IntervalType.freeRide: 'freeRide',
};

Workout _$WorkoutFromJson(Map<String, dynamic> json) => Workout(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: $enumDecode(_$WorkoutTypeEnumMap, json['type']),
      intervals: (json['intervals'] as List<dynamic>)
          .map((e) => WorkoutInterval.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$WorkoutToJson(Workout instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': _$WorkoutTypeEnumMap[instance.type]!,
      'intervals': instance.intervals.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$WorkoutTypeEnumMap = {
  WorkoutType.endurance: 'endurance',
  WorkoutType.interval: 'interval',
  WorkoutType.hiit: 'hiit',
  WorkoutType.tabata: 'tabata',
  WorkoutType.pyramid: 'pyramid',
  WorkoutType.ramp: 'ramp',
  WorkoutType.ftpTest: 'ftpTest',
  WorkoutType.freeRide: 'freeRide',
  WorkoutType.gpxRoute: 'gpxRoute',
};

T $enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  for (final entry in enumValues.entries) {
    if (entry.value == source) {
      return entry.key;
    }
  }
  throw ArgumentError('Unknown enum value: $source');
}
