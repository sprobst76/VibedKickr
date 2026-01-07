# Contributing - VibedKickr

Vielen Dank für dein Interesse, zu VibedKickr beizutragen! Dieses Dokument erklärt, wie du mithelfen kannst.

## Inhaltsverzeichnis

- [Code of Conduct](#code-of-conduct)
- [Wie kann ich beitragen?](#wie-kann-ich-beitragen)
- [Development Setup](#development-setup)
- [Pull Request Prozess](#pull-request-prozess)
- [Coding Guidelines](#coding-guidelines)
- [Commit Messages](#commit-messages)
- [Testing](#testing)

## Code of Conduct

Dieses Projekt und alle Teilnehmer verpflichten sich zu einem respektvollen und inklusiven Umgang. Belästigung, Diskriminierung oder unangemessenes Verhalten werden nicht toleriert.

## Wie kann ich beitragen?

### Bug Reports

1. **Prüfe bestehende Issues** - Vielleicht wurde der Bug schon gemeldet
2. **Erstelle ein neues Issue** mit:
   - Klare Beschreibung des Problems
   - Schritte zur Reproduktion
   - Erwartetes vs. tatsächliches Verhalten
   - Gerät, OS-Version, App-Version
   - Screenshots/Logs falls hilfreich

### Feature Requests

1. **Prüfe [TODO.md](TODO.md)** - Feature könnte schon geplant sein
2. **Erstelle ein Issue** mit:
   - Beschreibung des Features
   - Use Case / Warum ist es nützlich?
   - Mögliche Implementierungsideen

### Code Contributions

1. **Klein anfangen** - Gute "first issues" sind markiert
2. **Issue kommentieren** - Kündige an, woran du arbeitest
3. **Fork & Branch erstellen**
4. **Änderungen implementieren**
5. **Pull Request erstellen**

## Development Setup

### Voraussetzungen

- Flutter SDK 3.2.0+
- Dart SDK 3.2.0+
- Android Studio / VS Code
- Git
- Java 17 (für Android)

### Installation

```bash
# Repository forken und klonen
git clone https://github.com/DEIN-USERNAME/VibedKickr.git
cd VibedKickr

# Upstream remote hinzufügen
git remote add upstream https://github.com/sprobst76/VibedKickr.git

# Dependencies installieren
flutter pub get

# Code generieren
dart run build_runner build --delete-conflicting-outputs

# Tests ausführen
flutter test

# App starten
flutter run
```

### Empfohlene IDE-Einstellungen

**VS Code Extensions:**
- Dart
- Flutter
- Error Lens
- GitLens

**Einstellungen (`.vscode/settings.json`):**
```json
{
  "dart.previewFlutterUiGuides": true,
  "editor.formatOnSave": true,
  "dart.lineLength": 100
}
```

## Pull Request Prozess

### 1. Branch erstellen

```bash
# Vom aktuellen main branchen
git checkout main
git pull upstream main
git checkout -b feature/mein-feature
```

**Branch-Naming:**
- `feature/beschreibung` - Neue Features
- `fix/beschreibung` - Bug Fixes
- `docs/beschreibung` - Dokumentation
- `refactor/beschreibung` - Code Refactoring

### 2. Entwickeln

- Halte Änderungen fokussiert (ein Feature/Fix pro PR)
- Schreibe Tests für neue Funktionalität
- Aktualisiere Dokumentation falls nötig
- Stelle sicher, dass alle Tests bestehen

### 3. Commit

```bash
git add .
git commit -m "feat: Add power curve analysis"
```

### 4. Push & PR erstellen

```bash
git push origin feature/mein-feature
```

Dann auf GitHub:
1. "Compare & Pull Request" klicken
2. Beschreibung ausfüllen
3. PR Template folgen

### 5. Review

- Reagiere auf Feedback
- Push weitere Commits bei Änderungen
- Squash wenn gewünscht

### 6. Merge

Nach Approval wird der PR gemerged. 🎉

## Coding Guidelines

### Dart Style

Wir folgen dem [Effective Dart](https://dart.dev/guides/language/effective-dart) Style Guide.

```dart
// DO: Klare, beschreibende Namen
final averagePowerInWatts = calculateAverage(powerData);

// DON'T: Kryptische Abkürzungen
final avgPwr = calc(pd);

// DO: Const wo möglich
const defaultFtp = 200;
static const maxHeartRate = 220;

// DO: Nullable Types korrekt verwenden
String? getName() => _name; // Kann null sein
String getName() => _name ?? 'Unknown'; // Nie null
```

### Architektur

- **Feature-basierte Organisation** - Jedes Feature in eigenem Ordner
- **Clean Architecture** - Trennung von Domain, Data, Presentation
- **Single Responsibility** - Eine Klasse, ein Zweck

### Widgets

```dart
// DO: Const Constructor wenn möglich
class PowerDisplay extends StatelessWidget {
  const PowerDisplay({super.key, required this.power});

  final int power;

  @override
  Widget build(BuildContext context) {
    // ...
  }
}

// DO: Widgets in kleine Einheiten aufteilen
// DON'T: Mega-Widgets mit 500+ Zeilen
```

### Riverpod

```dart
// DO: Provider-Namen beschreibend
final athleteProfileProvider = ...

// DO: Ref.watch für reaktive Updates
final profile = ref.watch(athleteProfileProvider);

// DO: Ref.read für einmalige Aktionen
ref.read(sessionRepositoryProvider).saveSession(session);
```

## Commit Messages

Wir verwenden [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Types

| Type | Beschreibung |
|------|-------------|
| `feat` | Neues Feature |
| `fix` | Bug Fix |
| `docs` | Dokumentation |
| `style` | Formatierung (kein Code-Change) |
| `refactor` | Code-Umstrukturierung |
| `test` | Tests hinzufügen/ändern |
| `chore` | Build, Dependencies, etc. |

### Beispiele

```
feat(workouts): Add interval builder drag-and-drop

fix(ble): Resolve reconnection race condition

docs(readme): Update installation instructions

refactor(database): Extract mapper to separate class

test(session): Add unit tests for TSS calculation
```

## Testing

### Tests schreiben

```dart
// Unit Test
test('SessionStats calculates correct TSS', () {
  final dataPoints = [
    DataPoint(power: 200, timestampMs: 0),
    DataPoint(power: 200, timestampMs: 1000),
  ];

  final stats = SessionStats.calculate(dataPoints, ftp: 200);

  expect(stats.tss, greaterThan(0));
});

// Widget Test
testWidgets('PowerGauge shows loading initially', (tester) async {
  await tester.pumpWidget(
    ProviderScope(child: PowerGauge()),
  );

  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

### Tests ausführen

```bash
# Alle Tests
flutter test

# Mit Coverage
flutter test --coverage

# Einzelne Datei
flutter test test/domain/entities/session_stats_test.dart

# Watch Mode
flutter test --watch
```

### Coverage

Wir streben >80% Coverage für:
- Domain Entities
- Business Logic / Services
- Repositories

UI-Widgets haben typischerweise niedrigere Coverage.

## Fragen?

- **GitHub Issues** - Technische Fragen
- **Discussions** - Allgemeine Diskussionen

Vielen Dank für deinen Beitrag! 🚴‍♂️
