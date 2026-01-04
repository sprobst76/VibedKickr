import 'package:equatable/equatable.dart';

/// Training Load Metriken für einen Tag
class DailyTrainingLoad extends Equatable {
  final DateTime date;
  final int tss; // Training Stress Score des Tages
  final double ctl; // Chronic Training Load (Fitness) - 42 Tage
  final double atl; // Acute Training Load (Fatigue) - 7 Tage
  final double tsb; // Training Stress Balance (Form) = CTL - ATL

  const DailyTrainingLoad({
    required this.date,
    required this.tss,
    required this.ctl,
    required this.atl,
    required this.tsb,
  });

  /// Form-Zustand basierend auf TSB
  TrainingFormState get formState {
    if (tsb > 25) return TrainingFormState.fresh;
    if (tsb > 5) return TrainingFormState.rested;
    if (tsb > -10) return TrainingFormState.optimal;
    if (tsb > -25) return TrainingFormState.tired;
    return TrainingFormState.exhausted;
  }

  /// Empfehlung basierend auf Form
  String get recommendation {
    switch (formState) {
      case TrainingFormState.fresh:
        return 'Sehr erholt - Zeit für intensives Training oder Wettkampf';
      case TrainingFormState.rested:
        return 'Gut erholt - Bereit für hartes Training';
      case TrainingFormState.optimal:
        return 'Optimale Form - Gute Balance zwischen Fitness und Erholung';
      case TrainingFormState.tired:
        return 'Ermüdet - Leichteres Training empfohlen';
      case TrainingFormState.exhausted:
        return 'Übertraining-Risiko - Ruhetag oder sehr leichte Aktivität';
    }
  }

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'tss': tss,
        'ctl': ctl,
        'atl': atl,
        'tsb': tsb,
      };

  factory DailyTrainingLoad.fromJson(Map<String, dynamic> json) {
    return DailyTrainingLoad(
      date: DateTime.parse(json['date'] as String),
      tss: json['tss'] as int,
      ctl: (json['ctl'] as num).toDouble(),
      atl: (json['atl'] as num).toDouble(),
      tsb: (json['tsb'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [date, tss, ctl, atl, tsb];
}

/// Form-Zustände (Training)
enum TrainingFormState {
  fresh, // TSB > 25
  rested, // TSB 5-25
  optimal, // TSB -10 bis 5
  tired, // TSB -25 bis -10
  exhausted, // TSB < -25
}

/// Performance Management Chart (PMC) Daten
class PerformanceManagementData {
  final List<DailyTrainingLoad> history;
  final DailyTrainingLoad? today;

  const PerformanceManagementData({
    required this.history,
    this.today,
  });

  /// Aktueller CTL (Fitness)
  double get currentCtl => today?.ctl ?? history.lastOrNull?.ctl ?? 0;

  /// Aktueller ATL (Ermüdung)
  double get currentAtl => today?.atl ?? history.lastOrNull?.atl ?? 0;

  /// Aktueller TSB (Form)
  double get currentTsb => today?.tsb ?? history.lastOrNull?.tsb ?? 0;

  /// Gesamt-TSS der letzten 7 Tage
  int get weeklyTss {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    return history
        .where((d) => d.date.isAfter(weekAgo))
        .fold(0, (sum, d) => sum + d.tss);
  }

  /// Durchschnittlicher täglicher TSS der letzten 28 Tage
  double get avgDailyTss {
    final now = DateTime.now();
    final monthAgo = now.subtract(const Duration(days: 28));
    final recentDays = history.where((d) => d.date.isAfter(monthAgo)).toList();
    if (recentDays.isEmpty) return 0;
    return recentDays.fold(0, (sum, d) => sum + d.tss) / recentDays.length;
  }

  /// Fitness-Trend (steigend/fallend)
  FitnessTrend get fitnessTrend {
    if (history.length < 7) return FitnessTrend.stable;

    final recent = history.sublist(history.length - 7);
    final firstCtl = recent.first.ctl;
    final lastCtl = recent.last.ctl;
    final change = lastCtl - firstCtl;

    if (change > 2) return FitnessTrend.rising;
    if (change < -2) return FitnessTrend.falling;
    return FitnessTrend.stable;
  }

  /// Peak CTL in der Historie
  double get peakCtl {
    if (history.isEmpty) return 0;
    return history.map((d) => d.ctl).reduce((a, b) => a > b ? a : b);
  }
}

enum FitnessTrend {
  rising,
  stable,
  falling,
}

/// TSS-Zonen für Trainingsintensität
class TssZones {
  static const int recovery = 50; // < 50 TSS
  static const int endurance = 100; // 50-100 TSS
  static const int tempo = 150; // 100-150 TSS
  static const int threshold = 200; // 150-200 TSS
  static const int intense = 250; // 200-250 TSS
  // > 250 = Epic

  static String zoneForTss(int tss) {
    if (tss < recovery) return 'Recovery';
    if (tss < endurance) return 'Endurance';
    if (tss < tempo) return 'Tempo';
    if (tss < threshold) return 'Threshold';
    if (tss < intense) return 'Intense';
    return 'Epic';
  }

  static String descriptionForTss(int tss) {
    if (tss < recovery) return 'Leichte Aktivität, gute Erholung';
    if (tss < endurance) return 'Standard-Ausdauertraining';
    if (tss < tempo) return 'Moderates Training mit Anstrengung';
    if (tss < threshold) return 'Hartes Training, benötigt Erholung';
    if (tss < intense) return 'Sehr hartes Training';
    return 'Extrem hartes Training, mehrere Ruhetage empfohlen';
  }
}
