import 'package:equatable/equatable.dart';

/// Power Zones nach Coggan
class PowerZones extends Equatable {
  final int z1Max; // Active Recovery
  final int z2Max; // Endurance
  final int z3Max; // Tempo
  final int z4Max; // Threshold
  final int z5Max; // VO2max
  final int z6Max; // Anaerobic
  // Z7 = alles über z6Max (Neuromuscular)

  const PowerZones({
    required this.z1Max,
    required this.z2Max,
    required this.z3Max,
    required this.z4Max,
    required this.z5Max,
    required this.z6Max,
  });

  /// Standard-Zonen basierend auf FTP
  factory PowerZones.fromFtp(int ftp) => PowerZones(
        z1Max: (ftp * 0.55).round(),
        z2Max: (ftp * 0.75).round(),
        z3Max: (ftp * 0.90).round(),
        z4Max: (ftp * 1.05).round(),
        z5Max: (ftp * 1.20).round(),
        z6Max: (ftp * 1.50).round(),
      );

  /// Bestimmt die Zone für eine gegebene Wattleistung
  int zoneForPower(int watts) {
    if (watts <= z1Max) return 1;
    if (watts <= z2Max) return 2;
    if (watts <= z3Max) return 3;
    if (watts <= z4Max) return 4;
    if (watts <= z5Max) return 5;
    if (watts <= z6Max) return 6;
    return 7;
  }

  /// Zonengrenzen als Liste [min, max] für eine Zone
  (int, int) boundsForZone(int zone) {
    return switch (zone) {
      1 => (0, z1Max),
      2 => (z1Max + 1, z2Max),
      3 => (z2Max + 1, z3Max),
      4 => (z3Max + 1, z4Max),
      5 => (z4Max + 1, z5Max),
      6 => (z5Max + 1, z6Max),
      7 => (z6Max + 1, 9999),
      _ => (0, 0),
    };
  }

  Map<String, dynamic> toJson() => {
        'z1Max': z1Max,
        'z2Max': z2Max,
        'z3Max': z3Max,
        'z4Max': z4Max,
        'z5Max': z5Max,
        'z6Max': z6Max,
      };

  factory PowerZones.fromJson(Map<String, dynamic> json) => PowerZones(
        z1Max: json['z1Max'] as int,
        z2Max: json['z2Max'] as int,
        z3Max: json['z3Max'] as int,
        z4Max: json['z4Max'] as int,
        z5Max: json['z5Max'] as int,
        z6Max: json['z6Max'] as int,
      );

  @override
  List<Object?> get props => [z1Max, z2Max, z3Max, z4Max, z5Max, z6Max];
}

/// Herzfrequenz-Zonen
class HeartRateZones extends Equatable {
  final int z1Max; // Recovery
  final int z2Max; // Aerobic
  final int z3Max; // Tempo
  final int z4Max; // Threshold
  final int z5Max; // Max

  const HeartRateZones({
    required this.z1Max,
    required this.z2Max,
    required this.z3Max,
    required this.z4Max,
    required this.z5Max,
  });

  /// Standard-Zonen basierend auf max HR
  factory HeartRateZones.fromMaxHr(int maxHr) => HeartRateZones(
        z1Max: (maxHr * 0.60).round(),
        z2Max: (maxHr * 0.70).round(),
        z3Max: (maxHr * 0.80).round(),
        z4Max: (maxHr * 0.90).round(),
        z5Max: maxHr,
      );

  int zoneForHr(int hr) {
    if (hr <= z1Max) return 1;
    if (hr <= z2Max) return 2;
    if (hr <= z3Max) return 3;
    if (hr <= z4Max) return 4;
    return 5;
  }

  Map<String, dynamic> toJson() => {
        'z1Max': z1Max,
        'z2Max': z2Max,
        'z3Max': z3Max,
        'z4Max': z4Max,
        'z5Max': z5Max,
      };

  factory HeartRateZones.fromJson(Map<String, dynamic> json) => HeartRateZones(
        z1Max: json['z1Max'] as int,
        z2Max: json['z2Max'] as int,
        z3Max: json['z3Max'] as int,
        z4Max: json['z4Max'] as int,
        z5Max: json['z5Max'] as int,
      );

  @override
  List<Object?> get props => [z1Max, z2Max, z3Max, z4Max, z5Max];
}

/// Athleten-Profil
class AthleteProfile extends Equatable {
  final String id;
  final String? name;
  final int ftp; // Functional Threshold Power
  final int? maxHr; // Maximale Herzfrequenz
  final int? restingHr; // Ruhepuls
  final int? weight; // Gewicht in kg (für W/kg)
  final PowerZones powerZones;
  final HeartRateZones? hrZones;
  final DateTime? ftpTestDate;
  final List<FtpHistory> ftpHistory;

  const AthleteProfile({
    required this.id,
    this.name,
    required this.ftp,
    this.maxHr,
    this.restingHr,
    this.weight,
    required this.powerZones,
    this.hrZones,
    this.ftpTestDate,
    this.ftpHistory = const [],
  });

  /// W/kg Berechnung
  double? get wattsPerKg {
    if (weight == null || weight == 0) return null;
    return ftp / weight!;
  }

  /// Standard-Profil für neue Nutzer
  factory AthleteProfile.defaultProfile() {
    const defaultFtp = 200;
    return AthleteProfile(
      id: 'default',
      ftp: defaultFtp,
      powerZones: PowerZones.fromFtp(defaultFtp),
    );
  }

  AthleteProfile copyWith({
    String? id,
    String? name,
    int? ftp,
    int? maxHr,
    int? restingHr,
    int? weight,
    PowerZones? powerZones,
    HeartRateZones? hrZones,
    DateTime? ftpTestDate,
    List<FtpHistory>? ftpHistory,
  }) {
    return AthleteProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      ftp: ftp ?? this.ftp,
      maxHr: maxHr ?? this.maxHr,
      restingHr: restingHr ?? this.restingHr,
      weight: weight ?? this.weight,
      powerZones: powerZones ?? this.powerZones,
      hrZones: hrZones ?? this.hrZones,
      ftpTestDate: ftpTestDate ?? this.ftpTestDate,
      ftpHistory: ftpHistory ?? this.ftpHistory,
    );
  }

  /// Aktualisiert FTP und berechnet neue Zonen
  AthleteProfile updateFtp(int newFtp, {bool autoUpdateZones = true}) {
    final newHistory = [
      ...ftpHistory,
      FtpHistory(date: DateTime.now(), ftp: newFtp),
    ];

    return copyWith(
      ftp: newFtp,
      powerZones: autoUpdateZones ? PowerZones.fromFtp(newFtp) : null,
      ftpTestDate: DateTime.now(),
      ftpHistory: newHistory,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'ftp': ftp,
        'maxHr': maxHr,
        'restingHr': restingHr,
        'weight': weight,
        'powerZones': powerZones.toJson(),
        'hrZones': hrZones?.toJson(),
        'ftpTestDate': ftpTestDate?.toIso8601String(),
        'ftpHistory': ftpHistory.map((h) => h.toJson()).toList(),
      };

  factory AthleteProfile.fromJson(Map<String, dynamic> json) => AthleteProfile(
        id: json['id'] as String,
        name: json['name'] as String?,
        ftp: json['ftp'] as int,
        maxHr: json['maxHr'] as int?,
        restingHr: json['restingHr'] as int?,
        weight: json['weight'] as int?,
        powerZones: PowerZones.fromJson(json['powerZones'] as Map<String, dynamic>),
        hrZones: json['hrZones'] != null
            ? HeartRateZones.fromJson(json['hrZones'] as Map<String, dynamic>)
            : null,
        ftpTestDate: json['ftpTestDate'] != null
            ? DateTime.parse(json['ftpTestDate'] as String)
            : null,
        ftpHistory: (json['ftpHistory'] as List<dynamic>?)
                ?.map((h) => FtpHistory.fromJson(h as Map<String, dynamic>))
                .toList() ??
            [],
      );

  @override
  List<Object?> get props => [
        id,
        name,
        ftp,
        maxHr,
        restingHr,
        weight,
        powerZones,
        hrZones,
        ftpTestDate,
        ftpHistory,
      ];
}

/// FTP-Verlauf
class FtpHistory extends Equatable {
  final DateTime date;
  final int ftp;

  const FtpHistory({required this.date, required this.ftp});

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'ftp': ftp,
      };

  factory FtpHistory.fromJson(Map<String, dynamic> json) => FtpHistory(
        date: DateTime.parse(json['date'] as String),
        ftp: json['ftp'] as int,
      );

  @override
  List<Object?> get props => [date, ftp];
}
