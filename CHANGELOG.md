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
- Krafttraining-Integration (Phase 2)
- Mobility/Stretching-Module
- Aktivitäts-Tracking

---

## [0.11.0] - 2026-02-01

### Added
- **Health Training System** - Wissenschaftlich fundierte Gesundheitsprogramme
  - 5 Health Training Programme (Baseline Assessment, Cardiac Rehab, Age-Optimized Endurance, Stress Test, Recovery Check)
  - Personalisierung nach Alter, Geschlecht, Gewicht und FTP
  - Altersbasierte Sicherheitsgrenzen mit 3-tier HR Warnsystem
  - Progressive Belastungssteigerung mit Audio/Haptic Cues
  - Erweiterbare Architektur für Multi-Activity (Kraft, Mobility)

- **HR Safety Monitoring** (Phase 6)
  - Real-time HR Überwachung während Health Training
  - 4-stufiges Warnsystem (normal, info, warning, critical)
  - Auto-Pause bei HR-Limit-Überschreitung
  - Audio-Warnungen mit Cooldown-Logik

- **Post-Workout Analysis** (Phase 7)
  - HR Recovery Analyse (1-min, 2-min Drops)
  - Fitness-Level Schätzung (poor, fair, good, excellent)
  - Session Comparison mit Trend-Erkennung
  - Intelligente Next-Program Recommendations

- **Safety System** (Phase 8)
  - Medizinischer Disclaimer mit Persistierung
  - Emergency Stop Button mit Bestätigung
  - Sicherheits-Event Reporting
  - 5-stufiges Safety Rating System

- **Comprehensive Testing** (Phase 9)
  - 98 Unit/Integration Tests für Health Training
  - Validierung mit 4 repräsentativen Profilen (25M, 45F, 60M, 75F)
  - Age-Factor Progression Testing
  - Safety Limit Validation

### Technical
- HealthTrainingPersonalizationService mit Max HR Formeln (Tanaka, Gulati)
- HealthSafetyMonitor für Real-time HR Überwachung
- HealthProgramResultAnalyzer für Post-Workout Analyse
- HealthSafetyReport für Event Tracking
- HealthDisclaimerManager für Datenschutz
- Code Quality: 277 analyze issues (all info-level), 0 critical warnings

---

## [0.10.0] - 2026-01-15 (Beta)

### Added
- **App Icon** - Neues VibedKickr Icon mit Zahnrad und Power-Blitz Design
- **Play Store Vorbereitung**
  - Release Signing Konfiguration
  - ProGuard Rules für Code-Optimierung
  - Store Listing Dokumentation (PLAY_STORE.md)

### Changed
- **App umbenannt** zu "VibedKickr"
- **Application ID** geändert zu `de.stefan.vibedkickr`
- Adaptive Icons für Android 8+
- Minify und Shrink Resources aktiviert für Release-Builds
- **Versionierung auf Beta umgestellt** (0.x.x)

---

## [0.8.1] - 2026-01-07

### Fixed
- Analyzer Warnings behoben (unused imports, dead null-aware operators)
- `@override` Annotationen für DAO-Getter in AppDatabase hinzugefügt
- `path` Package als explizite Dependency hinzugefügt

---

## [0.8.0] - 2026-01-07

### Added
- **GitHub Actions CI/CD**
  - Flutter CI Workflow für automatische Builds bei Push/PR
  - Release Workflow für automatische APK-Releases bei Version-Tags
  - APK Artifact Upload für jeden CI-Build
- Umfangreiche Dokumentation (README, CHANGELOG, TODO, ARCHITECTURE, CONTRIBUTING)

---

## [0.7.0] - 2026-01-07

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
