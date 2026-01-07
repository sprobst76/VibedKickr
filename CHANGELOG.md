# Changelog

Alle wichtigen Änderungen an diesem Projekt werden in dieser Datei dokumentiert.

Das Format basiert auf [Keep a Changelog](https://keepachangelog.com/de/1.0.0/),
und dieses Projekt folgt [Semantic Versioning](https://semver.org/lang/de/).

## [Unreleased]

### Geplant
- iOS Support
- Apple Watch Companion App
- Zwift-ähnliche virtuelle Welten
- ANT+ Unterstützung

---

## [1.1.1] - 2026-01-07

### Fixed
- Analyzer Warnings behoben (unused imports, dead null-aware operators)
- `@override` Annotationen für DAO-Getter in AppDatabase hinzugefügt
- `path` Package als explizite Dependency hinzugefügt

---

## [1.1.0] - 2026-01-07

### Added
- **GitHub Actions CI/CD**
  - Flutter CI Workflow für automatische Builds bei Push/PR
  - Release Workflow für automatische APK-Releases bei Version-Tags
  - APK Artifact Upload für jeden CI-Build

### Changed
- Version auf 1.1.0+2 aktualisiert

---

## [1.0.0] - 2026-01-07

### Added

#### Session Persistence
- **Drift SQLite Database** - Vollständige Datenbankschicht für Trainingsdaten
- Tabellen: `TrainingSessions`, `DataPoints`, `CustomWorkouts`, `GpxRoutes`, `PersonalRecords`
- DAOs mit CRUD-Operationen und reaktiven Watch-Methoden
- Mapper für Domain <-> Database Konvertierung
- Repository Pattern Implementation

#### BLE Verbesserungen
- **BLE Diagnostic Tool** - Debug-Seite für Bluetooth-Problemanalyse
- Fix: Scan-Ergebnisse werden jetzt korrekt dedupliziert (Map statt List)
- Fix: FTMS-Daten werden nach Verbindungsaufbau korrekt angezeigt
- Fix: Substring-Fehler bei Service-UUID-Parsing behoben

#### Trainer Simulator
- **Mock FTMS Service** - Simulierte Trainerdaten für Entwicklung
- Realistische Power-Simulation mit Varianz
- Kadenz- und Herzfrequenz-Simulation
- Aktivierbar in Settings ohne physischen Trainer

#### Training Load Feature
- **Performance Management Chart (PMC)**
- TSS (Training Stress Score) Berechnung
- CTL (Chronic Training Load) - Fitness
- ATL (Acute Training Load) - Ermüdung
- TSB (Training Stress Balance) - Form
- Interaktiver Chart mit Zoom und Pan

#### Multi-Device Support
- Gleichzeitige Verbindung mit Trainer und HR-Monitor
- Separate Device-Auswahl für jeden Sensor-Typ
- Automatisches Pairing bei Wiederverbindung

#### Comeback Mode
- Strukturierter Wiedereinstieg nach Trainingsunterbrechung
- Progressive Belastungssteigerung
- Warnungen bei zu hoher Intensität
- Empfohlene Workouts basierend auf Comeback-Phase

#### GPX Routes
- GPX-Datei Import für virtuelle Strecken
- Höhenprofil-Visualisierung
- Steigungssimulation via ERG-Modus
- Distanz- und Höhenmeter-Tracking

#### Personal Records
- Automatische Erkennung von Bestleistungen
- Power Records: 5s, 1min, 5min, 20min, 60min
- Historische Entwicklung der Records
- Benachrichtigung bei neuen Records

#### Workout Builder
- Eigene strukturierte Workouts erstellen
- Intervall-basierter Editor
- Power-Targets: Absolute Watt, % FTP, Bereiche
- Warmup/Cooldown Templates

#### Audio Cues
- Akustische Hinweise bei Intervallwechseln
- Countdown vor Intervallende
- Konfigurierbare Sounds

#### Strava Integration
- OAuth2 Authentifizierung
- Automatischer Activity Upload
- Manuelle Sync-Option

#### Session Export
- FIT-Format Export (Garmin Connect kompatibel)
- TCX-Format Export
- Share-Funktion für externe Apps

#### Session History
- Übersicht aller Trainingseinheiten
- Detail-Ansicht mit Charts
- Power-Kurve Visualisierung
- Filterfunktionen

### Infrastructure
- Clean Architecture mit Feature-Based Organization
- Riverpod State Management
- GoRouter Navigation
- Freezed für immutable Data Classes
- Drift für SQLite Persistence
- flutter_blue_plus für BLE

---

## [0.1.0] - 2026-01-04

### Added
- **Initial Release**
- Grundlegende BLE-Verbindung mit FTMS-Trainern
- Live-Daten Anzeige (Power, Kadenz, HR, Speed)
- ERG-Modus Widerstandssteuerung
- Vordefinierte Interval-Workouts
- Power Zones nach Coggan
- Session Recording
- Athleten-Profil mit FTP-Einstellung
- Multi-Platform Support (Android, Windows, macOS, Linux)

---

## Versionsschema

- **Major (X.0.0)**: Breaking Changes, große neue Features
- **Minor (0.X.0)**: Neue Features, abwärtskompatibel
- **Patch (0.0.X)**: Bug Fixes, kleine Verbesserungen

## Links

- [GitHub Releases](https://github.com/sprobst76/VibedKickr/releases)
- [Issue Tracker](https://github.com/sprobst76/VibedKickr/issues)
