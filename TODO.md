# TODO - VibedKickr Roadmap

Diese Datei enthält geplante Features, Verbesserungen und bekannte Issues.

## Legende

- 🔴 **Kritisch** - Muss zeitnah umgesetzt werden
- 🟡 **Wichtig** - Sollte bald umgesetzt werden
- 🟢 **Nice-to-have** - Kann später umgesetzt werden
- ✅ **Erledigt** - Bereits implementiert

---

## Kurzfristig (Next Release)

### Bug Fixes
- [ ] 🔴 Reconnect-Logik verbessern bei Bluetooth-Unterbrechung
- [ ] 🟡 Memory-Leak bei langen Sessions prüfen
- [ ] 🟡 Workout-Player pausiert nicht korrekt bei App-Hintergrund

### Verbesserungen
- [ ] 🟡 Bessere Fehlerbehandlung bei BLE-Verbindungsproblemen
- [ ] 🟡 Loading States für alle async Operationen
- [ ] 🟢 Haptic Feedback bei Intervallwechseln

---

## Mittelfristig (v1.2.0)

### Features

#### Erweiterte Workout-Funktionen
- [ ] 🟡 Workout Templates importieren/exportieren (JSON)
- [ ] 🟡 Workout-Bibliothek mit Community-Workouts
- [ ] 🟢 Drag & Drop im Workout Builder
- [ ] 🟢 Workout-Vorschau mit Grafik

#### Analyse & Statistik
- [ ] 🟡 Power Curve Analyse (CP-Kurve)
- [ ] 🟡 W' Balance Tracking
- [ ] 🟡 Fitness-Trend Visualisierung
- [ ] 🟢 Vergleich mit historischen Sessions
- [ ] 🟢 Wöchentliche/Monatliche Zusammenfassungen

#### UX Verbesserungen
- [ ] 🟡 Onboarding-Tutorial für neue Nutzer
- [ ] 🟡 Quick-Actions auf Dashboard
- [ ] 🟢 Widgets für Android Home Screen
- [ ] 🟢 Tastaturkürzel für Desktop

#### Trainer-Steuerung
- [ ] 🟡 SIM-Modus (Steigung statt ERG)
- [ ] 🟡 Resistance-Modus
- [ ] 🟢 Spin-Down Kalibrierung

---

## Langfristig (v2.0.0)

### Neue Plattformen
- [ ] 🟡 iOS Support
- [ ] 🟢 Apple Watch Companion App
- [ ] 🟢 Wear OS Companion App
- [ ] 🟢 Web App (PWA)

### Virtuelle Welten
- [ ] 🟢 3D-Streckenvisualisierung
- [ ] 🟢 Zwift-ähnliche virtuelle Umgebung
- [ ] 🟢 Multiplayer-Gruppenfahrten
- [ ] 🟢 Virtuelle Rennen

### Erweiterte Konnektivität
- [ ] 🟡 ANT+ Unterstützung (via Stick)
- [ ] 🟡 ANT+ FE-C Protokoll
- [ ] 🟢 Direkte TrainingPeaks Integration
- [ ] 🟢 Garmin Connect Sync
- [ ] 🟢 Apple Health / Google Fit Sync

### Coaching & KI
- [ ] 🟢 KI-basierte Workout-Empfehlungen
- [ ] 🟢 Automatische FTP-Erkennung
- [ ] 🟢 Adaptives Training basierend auf Tagesform
- [ ] 🟢 Sprachsteuerung

### Soziale Features
- [ ] 🟢 Leaderboards
- [ ] 🟢 Challenges & Achievements
- [ ] 🟢 Freunde & Gruppen
- [ ] 🟢 Activity Feed

---

## Bekannte Issues

### BLE
- [ ] 🟡 Gelegentliche Verbindungsabbrüche bei schwachem Signal
- [ ] 🟢 Windows BLE teilweise instabil

### UI/UX
- [ ] 🟡 Dark Mode Kontrast optimieren
- [ ] 🟢 Landscape-Layout für Tablets verbessern
- [ ] 🟢 Accessibility verbessern (Screen Reader)

### Performance
- [ ] 🟢 Chart-Rendering bei vielen Datenpunkten optimieren
- [ ] 🟢 Startup-Zeit reduzieren

---

## Technische Schulden

### Code-Qualität
- [ ] 🟡 Test Coverage erhöhen (aktuell ~30%)
- [ ] 🟡 Integration Tests hinzufügen
- [ ] 🟢 E2E Tests mit Patrol
- [ ] 🟢 Dokumentation für alle Public APIs

### Architektur
- [ ] 🟡 BLE-Layer abstrahieren für bessere Testbarkeit
- [ ] 🟢 Feature Flags System implementieren
- [ ] 🟢 Offline-First Architektur

### CI/CD
- [ ] 🟡 Automatische Version-Bumps
- [ ] 🟢 iOS Build Pipeline
- [ ] 🟢 Automatische Screenshots für Store
- [ ] 🟢 Beta-Channel für Tester

---

## Abgeschlossen (v1.1.x)

- ✅ Session Persistence mit Drift SQLite
- ✅ BLE Diagnostic Tool
- ✅ Trainer Simulator für Entwicklung
- ✅ Training Load (TSS/CTL/ATL/TSB)
- ✅ Multi-Device Support
- ✅ Comeback Mode
- ✅ GPX Routes
- ✅ Personal Records
- ✅ Workout Builder
- ✅ Audio Cues
- ✅ Strava Integration
- ✅ FIT/TCX Export
- ✅ Session History
- ✅ GitHub Actions CI/CD
- ✅ Automated Releases

---

## Beitragen

Hast du Ideen für neue Features? Erstelle ein [GitHub Issue](https://github.com/sprobst76/VibedKickr/issues/new)!

Bei der Priorisierung helfen:
- 👍 Upvotes auf bestehende Issues
- Kommentare mit konkreten Use Cases
- Pull Requests sind willkommen!
