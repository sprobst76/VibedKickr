/// Extension für Duration-Formatierung
/// Ersetzt duplizierte _formatDuration() Funktionen im gesamten Projekt
extension DurationFormatter on Duration {
  /// Formatiert als Timer-Anzeige: "HH:MM:SS" oder "MM:SS"
  /// Verwendet für Live-Anzeigen (Dashboard, Workout Player)
  String toTimerString() {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Formatiert als kurze Anzeige: "MM:SS"
  /// Verwendet für Intervall-Anzeigen
  String toMinutesSeconds() {
    final minutes = inMinutes;
    final seconds = inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Formatiert kompakt: "30s", "5min", oder "5:30"
  /// Verwendet für Timeline/kompakte Anzeigen
  String toCompactString() {
    final minutes = inMinutes;
    final seconds = inSeconds.remainder(60);

    if (minutes == 0) return '${seconds}s';
    if (seconds == 0) return '${minutes}min';
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  /// Formatiert mit Einheiten: "30 min" oder "1:30 h"
  /// Verwendet für Workout-Listen
  String toDisplayString() {
    final totalMinutes = inMinutes;
    if (totalMinutes < 60) return '$totalMinutes min';

    final hours = totalMinutes ~/ 60;
    final remainingMinutes = totalMinutes % 60;
    return '$hours:${remainingMinutes.toString().padLeft(2, '0')} h';
  }
}
