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
- Mobility/Stretching-Module
- Aktivitäts-Tracking
- Video-Bibliothek für Übungsanleitung

---

## [1.3.0] - 2026-02-03

### Added - Robustes BLE Reconnection System

**Kern-Features:**
- **Exponential Backoff Reconnection** - Intelligente Wiederverbindung nach Bluetooth-Unterbrechung
  - Progressive Verzögerungen: 2s → 4s → 8s → 16s → 32s (max 60s)
  - Max 5 Reconnection-Versuche mit Circuit Breaker Pattern
  - Verhindert Batterie-Verschleiß durch optimierte Wiederholung
  - Concurrent Reconnection Guard gegen Race Conditions

- **Reconnecting State** - Neue Verbindungs-Status für besseres UX
  - New ConnectionStatus enum: `reconnecting`
  - Dashboard-Icon zeigt Status während Reconnection
  - Connection Status Bar mit "Verbindung wird wiederhergestellt..." Text
  - Distinct Feedback während Reconnect vs Disconnect

- **Workout Auto-Pause** - Schutz vor Datenkorruption
  - Automatisches Pausieren bei Trainer-Disconnect
  - Trainings-Daten bleiben konsistent
  - Snackbar-Notification: "Trainer disconnected - auto-pausing"
  - Workout bleibt pausiert nach Reconnect (manuelles Resume erforderlich)

- **Bluetooth Adapter Recovery** - Automatische Wiederherstellung
  - Erkennt wenn Bluetooth-Adapter ausgeschaltet wird
  - Auto-Reconnect wenn Bluetooth wieder eingeschaltet wird
  - Nahtlose Wiederverbindung ohne Benutzerinteraktion

- **App Lifecycle Handling** - Background/Foreground Unterstützung
  - AppLifecycleObserver für Lifecycle-Events
  - Triggered Reconnect beim App-Resume (nach Background)
  - Kritisch für iOS wo BLE bei Background-Transition droppt
  - Proper Cleanup bei App-Pause

- **Settings Integration** - User Control über Auto-Reconnect
  - Auto-Reconnect Toggle in Settings vollständig verdrahtet
  - Deaktivierung stoppt aktive Reconnection-Versuche
  - Persistierung der Einstellung

**Infrastructure:**
- **BleReconnectionManager**: 280+ Zeilen Core-Logik
  - Stream-basierte State Broadcasting
  - Safe Event Handling mit Disposal-Checks
  - Configuration für Max Retries und Backoff
  - Timeout-Management für robuste Fehlerbehandlung

- **Connection Event Logger**: Diagnostic Logging
  - Event-Tracking für Reconnection-Versuche
  - History (max 100 Events) für Debugging
  - JSON Export für Diagnostik
  - Formatted Output für Logs

**Testing:**
- **7 Unit Tests** - Core Reconnection Logic
  - Exponential Backoff Verification
  - Retry Limit Enforcement
  - Concurrent Reconnection Guard
  - State Transitions
  - Cancellation Handling
  - Stream Safety

- **Comprehensive Integration Tests**
  - Complete Reconnection Workflows
  - Edge Case Handling
  - Multi-Device Scenarios
  - Lifecycle Integration

### Changed
- BLE Manager erweitert um Reconnection-Logik
- Workout Player Provider mit BLE Connection Monitoring
- Workout Player Page mit Reconnection UI Feedback
- Dashboard mit Reconnecting State Handling
- Connection Status Bar mit verbesserter Status-Anzeige
- Settings Page mit funktionsfähigem Auto-Reconnect Toggle

### Fixed
- Bluetooth Adapter State wird nun korrekt überwacht
- Manual Disconnect verhindert unerwünschte Auto-Reconnection
- Stream Management mit Safe Disposal
- Race Conditions bei mehreren Disconnect-Events

### Technical
- Build Quality: 0 Fehler, nur Info-Level Linting
- Code Quality: 1,177 Zeilen neuer/verbesserter Code
- 6 neue Dateien, 8 modifizierte Dateien
- Platform-aware für Android, iOS, macOS, Linux
- Non-blocking Backoff für responsive UI

### Security
- Safe Stream Handling bei Disposal
- Concurrent Reconnection Guard
- Manual Disconnect Protection
- Proper Resource Cleanup

---

## [1.0.0] - 2026-02-01

### Added - Krafttraining System (Major Feature)

**Kern-Features:**
- **19+ Übungs-Bibliothek** - Evidenzbasierte Übungen für 40-70 Jahre
  - Compound Movements (Squat, Push, Pull, Hinge, Core)
  - Isolations-Übungen (Curls, Raises, Extensions)
  - Altersgerechte Modifikationen für 50+
  - Detaillierte Form Cues für jede Übung

- **Custom Workout Builder** - Erstelle deine eigenen Programme
  - LoadTarget Pattern (Absolutes Gewicht, % 1RM, RPE, Bodyweight)
  - Flexible Sätze & Wiederholungen (einzeln oder Bereich)
  - Tempo und Anleitung pro Übung
  - Ruhepausen-Vorkonfiguration

- **Session Player** - Trainings-Ausführung mit Smart Features
  - State Machine: Intro → Active → Rest → Complete
  - Rest Timer mit Countdown & Audio Cues
  - RPE Selector & Gewicht-Tracking
  - Quick Rep Buttons (8, 10, 12, 15)
  - Haptic Feedback Integration

- **Progress Tracking** - Visualisiere deine Entwicklung
  - 1RM Schätzung (Epley Formula)
  - PR Tracking (1RM, 3RM, 5RM, 10RM)
  - Gewichts-Progress Charts
  - Session Detail mit Set-by-Set Breakdown
  - Volume & RPE Durchschnitte

- **Progression System** - Intelligente Steigerung
  - Linear Progression (+2,5kg bei Erfolg)
  - Deload Detection (2+ fehlgeschlagene Sessions)
  - Weekly Volume Calculation
  - Personalisierte Empfehlungen basierend auf Verlauf

**Health Integration:**
- **Multi-Activity Health Programs** - Kombination Radfahren + Kraft
  - generateWeeklyProgram50Plus(): 7-Tage Plan optimiert für 50+
  - generateWeeklyProgramAdults(): Intensiveres Programm für 30-49
  - Altersgerechte Sicherheitsgrenzen
  - Evidence-based Frequency & Volume

- **Health Training Tab Refactor**
  - TabBar Navigation: Radfahren | Krafttraining
  - Fitness Scoring für beide Aktivitäten
  - Integrierte Wochenpläne-Ansicht

**Technical Enhancements:**
- **Database Schema v1→v2** - Migration für Kraft-Tabellen
  - StrengthExercises (19 seed exercises)
  - StrengthWorkouts (custom + vordefiniert)
  - StrengthSessions (two-tier: records + stats)
  - StrengthPersonalRecords (PR history)

- **4 neue DAOs** für vollständige CRUD-Operationen
  - StrengthExerciseDao (search, filter by muscle/equipment)
  - StrengthWorkoutDao (CRUD, watch patterns)
  - StrengthSessionDao (date range queries)
  - StrengthPRDao (history, current records)

- **3 neue Services**
  - StrengthRecordService: PR-Erkennung, 1RM-Berechnung
  - StrengthProgressionService: Progression-Logik, Deload-Erkennung
  - StrengthProgramGenerator: Altersbasierte Programme

**UI/UX:**
- **Exercise Library Page** - Browse & Filter 19+ Übungen
  - Real-time Search
  - Multi-Select Filters (Muskelgruppe, Equipment, Schwierigkeit)
  - Sortierung (Name, Difficulty)
  - Detail Modal mit Form Cues & Modifikationen

- **Strength Workout Builder** - Workout-Erstellung
  - Drag-to-reorder Exercises
  - Interval Configuration Pro Übung
  - Tempo & Instructions Support
  - Save/Load Funktionalität

- **Strength Session Player** - 800+ Lines Komplexität
  - Professional State Management
  - Form Cues Display per Exercise
  - Rest Timer mit farblicher Anzeige (Green→Yellow→Red)
  - Session Summary & Stats

- **Progress Dashboard**
  - 3-Column Stats Cards (Sessions/Volume/PRs)
  - Exercise Selector mit Description
  - Date Range Chips (1w/1m/3m/6m/1y)
  - PR Display Table (1RM, 3RM, 5RM, 10RM)

**Testing:**
- **153 Tests - >75% Coverage**
  - 30 Entity Tests (Freezed serialization)
  - 80+ Service Tests (Record detection, progression logic)
  - 40 Seed Data Tests (Exercise library validation)
  - 13 Widget Tests (ExerciseCard rendering & interaction)

- **Key Test Categories**
  - LoadTarget Pattern Tests (4 factory methods)
  - Epley Formula Validation
  - Linear Progression Algorithm
  - Multi-Muscle Exercise Handling
  - Age-Specific Modifications

**Documentation:**
- **STRENGTH_TRAINING_GUIDE.md** - Umfassender Benutzer-Guide
  - Getting Started Anleitung
  - Load Types Erklärung
  - 50+ Best Practices
  - PR & 1RM Erläuterung
  - Sicherheitsrichtlinien
  - Fortgeschrittene Konzepte (Periodization, Deload)

- **README Update** - Kraft Features hinzugefügt
- **Dartdoc Comments** - Public API dokumentiert

### Changed
- Health Training Architecture - Tab-basierte Navigation statt neuer Screen
- HealthActivityType Enum erweitert (cycling, strength, mobility, walking)
- HealthTrainingProgram Entity - Optional strengthWorkoutId Field

### Compatibility
- Database Migration: v1 → v2 (automatic)
- All existing cycling features maintain backward compatibility
- New multi-activity programs available for all users

### Security
- Age-based safety bounds (minimumAge, requiresModification50Plus)
- Form Cue validation pre-load
- Session data integrity checks

### Performance
- Lazy Loading für Exercise Library (on-demand filtering)
- Efficient Stream-based Progress Updates
- Optimized Chart Rendering (fl_chart ready)

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
