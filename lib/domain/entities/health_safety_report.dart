import 'package:equatable/equatable.dart';

/// Sicherheits-Ereignisse die während des Trainings auftreten können
enum SafetyEvent {
  /// HR überschreitet INFO Warnstufe (85%)
  hrInfoWarning,

  /// HR überschreitet WARNING Warnstufe (95%)
  hrWarningWarning,

  /// HR überschreitet CRITICAL Limit (100%)
  hrCritical,

  /// Auto-Pause wurde durch HR-Limit ausgelöst
  autoPauseTriggered,

  /// Benutzer hat notfall Stopp gedrückt
  emergencyStop,

  /// HR ist während Training nicht verfügbar
  hrMonitoringFailed,

  /// Trainingsintensität überschreitet Empfehlung
  intensityWarning,
}

/// Ein einzelnes Sicherheits-Ereignis mit Zeitstempel
class SafetyEventRecord extends Equatable {
  /// Art des Sicherheits-Ereignisses
  final SafetyEvent event;

  /// Zeitstempel im Training (Millisekunden seit Start)
  final int timestamp;

  /// HR zu dem Zeitpunkt (wenn relevant)
  final int? hr;

  /// Aktuelle Trainingsintensität (% des max HR)
  final int? intensityPercent;

  /// Beschreibung des Ereignisses
  final String description;

  const SafetyEventRecord({
    required this.event,
    required this.timestamp,
    this.hr,
    this.intensityPercent,
    required this.description,
  });

  @override
  List<Object?> get props => [
        event,
        timestamp,
        hr,
        intensityPercent,
        description,
      ];
}

/// Sicherheits-Bericht nach Trainingsende
class HealthSafetyReport extends Equatable {
  /// Eindeutige ID des Reports
  final String id;

  /// ID der zugehörigen Trainings-Session
  final String sessionId;

  /// Alle Sicherheits-Ereignisse während des Trainings
  final List<SafetyEventRecord> events;

  /// Gesamte Zeit mit HR über INFO-Limit (Millisekunden)
  final int timeAboveInfoLimit;

  /// Gesamte Zeit mit HR über WARNING-Limit (Millisekunden)
  final int timeAboveWarningLimit;

  /// Wie oft HR-Limit überschritten wurde
  final int limitExceededCount;

  /// Wie oft Auto-Pause ausgelöst wurde
  final int autoPauseTriggerCount;

  /// War ein Notfall-Stopp erforderlich?
  final bool emergencyStopUsed;

  /// Durchschnittliche HR während Trainings
  final int? avgHr;

  /// Peak HR während Trainings
  final int? peakHr;

  /// Altersgerechtes sicheres HR-Limit
  final int safeLimitHr;

  /// Wurde diesen Bericht bereits überprüft/bestätigt?
  final bool reviewed;

  /// Überprüfungszeitpunkt
  final DateTime? reviewedAt;

  /// Notizen zur Sicherheit
  final String? notes;

  const HealthSafetyReport({
    required this.id,
    required this.sessionId,
    this.events = const [],
    this.timeAboveInfoLimit = 0,
    this.timeAboveWarningLimit = 0,
    this.limitExceededCount = 0,
    this.autoPauseTriggerCount = 0,
    this.emergencyStopUsed = false,
    this.avgHr,
    this.peakHr,
    required this.safeLimitHr,
    this.reviewed = false,
    this.reviewedAt,
    this.notes,
  });

  /// Kopiert diesen Report mit optionalen Änderungen
  HealthSafetyReport copyWith({
    String? id,
    String? sessionId,
    List<SafetyEventRecord>? events,
    int? timeAboveInfoLimit,
    int? timeAboveWarningLimit,
    int? limitExceededCount,
    int? autoPauseTriggerCount,
    bool? emergencyStopUsed,
    int? avgHr,
    int? peakHr,
    int? safeLimitHr,
    bool? reviewed,
    DateTime? reviewedAt,
    String? notes,
  }) {
    return HealthSafetyReport(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      events: events ?? this.events,
      timeAboveInfoLimit: timeAboveInfoLimit ?? this.timeAboveInfoLimit,
      timeAboveWarningLimit: timeAboveWarningLimit ?? this.timeAboveWarningLimit,
      limitExceededCount: limitExceededCount ?? this.limitExceededCount,
      autoPauseTriggerCount: autoPauseTriggerCount ?? this.autoPauseTriggerCount,
      emergencyStopUsed: emergencyStopUsed ?? this.emergencyStopUsed,
      avgHr: avgHr ?? this.avgHr,
      peakHr: peakHr ?? this.peakHr,
      safeLimitHr: safeLimitHr ?? this.safeLimitHr,
      reviewed: reviewed ?? this.reviewed,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      notes: notes ?? this.notes,
    );
  }

  /// Bewertet die Sicherheit des Trainings
  SafetyRating getSafetyRating() {
    if (emergencyStopUsed) {
      return SafetyRating.unsafe;
    }

    if (autoPauseTriggerCount > 0) {
      return SafetyRating.warning;
    }

    if (limitExceededCount > 3 || timeAboveWarningLimit > 60000) {
      return SafetyRating.caution;
    }

    if (limitExceededCount == 0 && timeAboveInfoLimit < 30000) {
      return SafetyRating.safe;
    }

    return SafetyRating.acceptable;
  }

  @override
  List<Object?> get props => [
        id,
        sessionId,
        events,
        timeAboveInfoLimit,
        timeAboveWarningLimit,
        limitExceededCount,
        autoPauseTriggerCount,
        emergencyStopUsed,
        avgHr,
        peakHr,
        safeLimitHr,
        reviewed,
        reviewedAt,
        notes,
      ];
}

/// Bewertung der Trainingssicherheit
enum SafetyRating {
  /// Sicheres Training, keine Probleme
  safe,

  /// Akzeptabel, wenige Warnungen
  acceptable,

  /// Vorsicht, mehrere Limitüberschreitungen
  caution,

  /// Warnung, Auto-Pause wurde ausgelöst
  warning,

  /// Unsicher, Notfall-Stopp erforderlich
  unsafe,
}

extension SafetyRatingExtension on SafetyRating {
  String get displayName {
    switch (this) {
      case SafetyRating.safe:
        return 'Sicher';
      case SafetyRating.acceptable:
        return 'Akzeptabel';
      case SafetyRating.caution:
        return 'Vorsicht';
      case SafetyRating.warning:
        return 'Warnung';
      case SafetyRating.unsafe:
        return 'Unsicher';
    }
  }

  String get description {
    switch (this) {
      case SafetyRating.safe:
        return 'Trainingssession war innerhalb sicherer Grenzen.';
      case SafetyRating.acceptable:
        return 'Wenige Warnungen, aber insgesamt akzeptabel.';
      case SafetyRating.caution:
        return 'Mehrere HR-Limitüberschreitungen. Vorsicht ist geboten.';
      case SafetyRating.warning:
        return 'Auto-Pause wurde ausgelöst. Intensität reduzieren.';
      case SafetyRating.unsafe:
        return 'Notfall-Stopp wurde verwendet. Medizinischen Rat einholen.';
    }
  }

  int get priority {
    switch (this) {
      case SafetyRating.safe:
        return 1;
      case SafetyRating.acceptable:
        return 2;
      case SafetyRating.caution:
        return 3;
      case SafetyRating.warning:
        return 4;
      case SafetyRating.unsafe:
        return 5;
    }
  }
}
