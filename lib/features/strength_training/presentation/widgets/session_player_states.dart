/// State enum für Session Player
/// Verwaltet verschiedene Phasen des Workouts
enum SessionPlayerState {
  intro, // Zeigt Übungsinformationen und Form Tipps
  active, // Benutzer führt Set aus
  resting, // Rest Timer läuft
  paused, // Session pausiert
  completed, // Workout abgeschlossen
}
