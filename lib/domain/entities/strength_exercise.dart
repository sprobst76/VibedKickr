import 'package:equatable/equatable.dart';

enum MuscleGroup {
  chest,
  back,
  shoulders,
  arms,
  legs,
  core,
  fullBody,
}

enum EquipmentType {
  bodyweight,
  dumbbells,
  barbell,
  kettlebell,
  resistanceBand,
  none,
}

enum DifficultyLevel {
  beginner,
  intermediate,
  advanced,
}

/// Eine einzelne Krafttraining-Übung
class StrengthExercise extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<MuscleGroup> primaryMuscles;
  final List<MuscleGroup> secondaryMuscles;
  final EquipmentType equipment;
  final String formCues;
  final String? videoUrl;
  final DifficultyLevel difficulty;
  final bool isCompound;
  final int minimumAge;
  final int? maximumAge;
  final bool requiresModification50Plus;
  final String? modification50PlusNotes;

  const StrengthExercise({
    required this.id,
    required this.name,
    required this.description,
    required this.primaryMuscles,
    required this.secondaryMuscles,
    required this.equipment,
    required this.formCues,
    this.videoUrl,
    required this.difficulty,
    required this.isCompound,
    required this.minimumAge,
    this.maximumAge,
    required this.requiresModification50Plus,
    this.modification50PlusNotes,
  });

  factory StrengthExercise.fromJson(Map<String, dynamic> json) {
    return StrengthExercise(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      primaryMuscles: (json['primaryMuscles'] as List)
          .map((m) => MuscleGroup.values.firstWhere(
                (mg) => mg.name == m,
                orElse: () => MuscleGroup.fullBody,
              ))
          .toList(),
      secondaryMuscles: (json['secondaryMuscles'] as List)
          .map((m) => MuscleGroup.values.firstWhere(
                (mg) => mg.name == m,
                orElse: () => MuscleGroup.fullBody,
              ))
          .toList(),
      equipment: EquipmentType.values.firstWhere(
        (e) => e.name == json['equipment'],
        orElse: () => EquipmentType.bodyweight,
      ),
      formCues: json['formCues'] as String,
      videoUrl: json['videoUrl'] as String?,
      difficulty: DifficultyLevel.values.firstWhere(
        (d) => d.name == json['difficulty'],
        orElse: () => DifficultyLevel.beginner,
      ),
      isCompound: json['isCompound'] as bool,
      minimumAge: json['minimumAge'] as int? ?? 18,
      maximumAge: json['maximumAge'] as int?,
      requiresModification50Plus: json['requiresModification50Plus'] as bool? ?? false,
      modification50PlusNotes: json['modification50PlusNotes'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'primaryMuscles': primaryMuscles.map((m) => m.name).toList(),
        'secondaryMuscles': secondaryMuscles.map((m) => m.name).toList(),
        'equipment': equipment.name,
        'formCues': formCues,
        'videoUrl': videoUrl,
        'difficulty': difficulty.name,
        'isCompound': isCompound,
        'minimumAge': minimumAge,
        'maximumAge': maximumAge,
        'requiresModification50Plus': requiresModification50Plus,
        'modification50PlusNotes': modification50PlusNotes,
      };

  StrengthExercise copyWith({
    String? id,
    String? name,
    String? description,
    List<MuscleGroup>? primaryMuscles,
    List<MuscleGroup>? secondaryMuscles,
    EquipmentType? equipment,
    String? formCues,
    String? videoUrl,
    DifficultyLevel? difficulty,
    bool? isCompound,
    int? minimumAge,
    int? maximumAge,
    bool? requiresModification50Plus,
    String? modification50PlusNotes,
  }) {
    return StrengthExercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      primaryMuscles: primaryMuscles ?? this.primaryMuscles,
      secondaryMuscles: secondaryMuscles ?? this.secondaryMuscles,
      equipment: equipment ?? this.equipment,
      formCues: formCues ?? this.formCues,
      videoUrl: videoUrl ?? this.videoUrl,
      difficulty: difficulty ?? this.difficulty,
      isCompound: isCompound ?? this.isCompound,
      minimumAge: minimumAge ?? this.minimumAge,
      maximumAge: maximumAge ?? this.maximumAge,
      requiresModification50Plus: requiresModification50Plus ?? this.requiresModification50Plus,
      modification50PlusNotes: modification50PlusNotes ?? this.modification50PlusNotes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        primaryMuscles,
        secondaryMuscles,
        equipment,
        formCues,
        videoUrl,
        difficulty,
        isCompound,
        minimumAge,
        maximumAge,
        requiresModification50Plus,
        modification50PlusNotes,
      ];
}
