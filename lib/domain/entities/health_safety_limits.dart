import 'package:equatable/equatable.dart';

/// Sicherheitsgrenzen für Health Training Programme
class HealthSafetyLimits extends Equatable {
  /// Maximale Herzfrequenz als Prozentsatz des age-predicted max HR
  final int maxHrPercent;

  /// HR-Limit in Prozent bei dem automatisch pausiert wird
  final int autoPauseHrPercent;

  /// Ist ein HR Monitor für dieses Programm erforderlich?
  final bool requiresHrMonitor;

  /// Erwarteter HR-Rückgang (in bpm) in der ersten Minute nach einer Anstrengungsphase
  final int? minRecoveryHrDrop;

  /// Stop-Bedingungen (Symptome bei denen sofort gestoppt werden sollte)
  final List<String> stopConditions;

  /// Zusätzliche Sicherheitshinweise
  final String? additionalWarning;

  const HealthSafetyLimits({
    required this.maxHrPercent,
    required this.autoPauseHrPercent,
    required this.requiresHrMonitor,
    this.minRecoveryHrDrop,
    this.stopConditions = const [],
    this.additionalWarning,
  });

  /// Standard-Sicherheitsgrenzen basierend auf Alter
  factory HealthSafetyLimits.forAge(int age) {
    if (age < 40) {
      return const HealthSafetyLimits(
        maxHrPercent: 90,
        autoPauseHrPercent: 95,
        requiresHrMonitor: false,
        minRecoveryHrDrop: 15,
        stopConditions: [
          'Brustschmerzen oder -druck',
          'Schwindel oder Benommenheit',
          'Ungewöhnliche Kurzatmigkeit',
          'Übelkeit',
          'Unregelmäßiger Herzschlag',
        ],
      );
    } else if (age < 50) {
      return const HealthSafetyLimits(
        maxHrPercent: 85,
        autoPauseHrPercent: 90,
        requiresHrMonitor: false,
        minRecoveryHrDrop: 12,
        stopConditions: [
          'Brustschmerzen oder -druck',
          'Schwindel oder Benommenheit',
          'Ungewöhnliche Kurzatmigkeit',
          'Übelkeit',
          'Unregelmäßiger Herzschlag',
        ],
      );
    } else if (age < 60) {
      return const HealthSafetyLimits(
        maxHrPercent: 80,
        autoPauseHrPercent: 85,
        requiresHrMonitor: true,
        minRecoveryHrDrop: 10,
        stopConditions: [
          'Brustschmerzen oder -druck',
          'Schwindel oder Benommenheit',
          'Ungewöhnliche Kurzatmigkeit',
          'Übelkeit',
          'Unregelmäßiger Herzschlag',
        ],
        additionalWarning:
            'Ab 50 Jahren wird HR-Monitoring dringend empfohlen. Konsultiere vor Programmen deinen Arzt.',
      );
    } else if (age < 70) {
      return const HealthSafetyLimits(
        maxHrPercent: 75,
        autoPauseHrPercent: 80,
        requiresHrMonitor: true,
        minRecoveryHrDrop: 10,
        stopConditions: [
          'Brustschmerzen oder -druck',
          'Schwindel oder Benommenheit',
          'Ungewöhnliche Kurzatmigkeit',
          'Übelkeit',
          'Unregelmäßiger Herzschlag',
          'Gelenkschmerzen',
        ],
        additionalWarning:
            'Ältere Athleten sollten längere Warm-ups und Cool-downs durchführen. Konsultiere vor Training deinen Arzt.',
      );
    } else {
      return const HealthSafetyLimits(
        maxHrPercent: 70,
        autoPauseHrPercent: 75,
        requiresHrMonitor: true,
        minRecoveryHrDrop: 8,
        stopConditions: [
          'Brustschmerzen oder -druck',
          'Schwindel oder Benommenheit',
          'Ungewöhnliche Kurzatmigkeit',
          'Übelkeit',
          'Unregelmäßiger Herzschlag',
          'Gelenkschmerzen',
          'Muskelschmerzen',
        ],
        additionalWarning:
            'Sehr konservative Trainingsintensität empfohlen. Ärztliche Freigabe ist wichtig.',
      );
    }
  }

  @override
  List<Object?> get props => [
        maxHrPercent,
        autoPauseHrPercent,
        requiresHrMonitor,
        minRecoveryHrDrop,
        stopConditions,
        additionalWarning,
      ];
}
