# VibedKickr 🚴‍♂️

Eine leistungsstarke Flutter-App für Indoor-Cycling-Training mit Smart Trainer Steuerung.

[![Flutter CI](https://github.com/sprobst76/VibedKickr/actions/workflows/flutter-ci.yml/badge.svg)](https://github.com/sprobst76/VibedKickr/actions/workflows/flutter-ci.yml)
[![Release](https://github.com/sprobst76/VibedKickr/actions/workflows/release.yml/badge.svg)](https://github.com/sprobst76/VibedKickr/releases)
[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)
[![Commercial License Available](https://img.shields.io/badge/Commercial%20License-Available-green.svg)](LICENSE.COMMERCIAL)

## Übersicht

VibedKickr verbindet sich via Bluetooth Low Energy (BLE) mit FTMS-kompatiblen Smart Trainern und bietet strukturiertes Training mit Echtzeit-Datenvisualisierung, automatischer Widerstandssteuerung und umfassender Trainingsanalyse.

## Features

### Geräteverbindung
- 🔗 **BLE-Verbindung** - Automatischer Scan und Verbindung mit FTMS-Trainern
- 📱 **Multi-Device Support** - Gleichzeitige Verbindung mit Trainer und separatem HR-Monitor
- 🔄 **Auto-Reconnect** - Automatische Wiederverbindung bei Verbindungsabbruch
- 🧪 **Simulator-Modus** - Entwickeln und Testen ohne physischen Trainer

### Live-Training
- 📊 **Echtzeit-Daten** - Power, Kadenz, Herzfrequenz, Geschwindigkeit
- 🎯 **ERG-Modus** - Automatische Widerstandssteuerung nach Ziel-Watt
- 📈 **Live-Charts** - Visualisierung der Leistungsdaten in Echtzeit
- 🎨 **Power Zones** - Farbcodierte Coggan-basierte Zonen-Anzeige

### Workouts
- 🏋️ **Vordefinierte Workouts** - FTP-Tests, Sweet Spot, VO2max Intervalle
- 🛠️ **Workout Builder** - Eigene strukturierte Workouts erstellen
- 🔊 **Audio Cues** - Akustische Hinweise bei Intervallwechseln
- ⏱️ **Intervall-Timer** - Visuelle Fortschrittsanzeige

### Routen
- 🗺️ **GPX-Import** - Virtuelle Fahrten mit echten Höhenprofilen
- ⛰️ **Elevation Profile** - Steigungssimulation basierend auf GPX-Daten
- 🚵 **Simulation Mode** - Realistisches Fahrverhalten mit Steigungswiderstand

### Analyse & Statistik
- 💾 **Session History** - Aufzeichnung aller Trainingseinheiten
- 📊 **Performance Management Chart** - TSS/CTL/ATL/TSB Tracking
- 🏆 **Personal Records** - Automatische Erkennung von Bestleistungen
- 📤 **Export** - FIT und TCX Format für Garmin/TrainingPeaks

### Comeback-Modus
- 🏥 **Return to Training** - Strukturierter Wiedereinstieg nach Krankheit/Pause
- 📉 **Progressive Load** - Automatische Anpassung der Trainingsbelastung
- ⚠️ **Warnungen** - Hinweise bei zu hoher Belastung

### Krafttraining (Strength Training)
- 💪 **Exercise Library** - 19+ evidenzbasierte Übungen für 40-70 Jährige
- 🏗️ **Workout Builder** - Erstelle eigene Krafttrainingsprogramme
- ⏱️ **Rest Timer** - Intelligente Ruhepausenzähler mit Audio Cues
- 📊 **Progress Tracking** - 1RM Schätzung und persönliche Rekorde (1RM, 3RM, 5RM, 10RM)
- 📈 **Linear Progression** - Automatische Steigerung (+2,5kg) beim Erfolg
- 🏥 **50+ Modifications** - Altersgerechte Variationen für ältere Athleten
- 🔄 **Multi-Activity Programs** - Kombinierte Wochenpläne (Radfahren + Kraft)

### Integrationen
- 🔄 **Strava Sync** - Automatischer Upload von Aktivitäten
- 📱 **Multi-Platform** - Android, Windows, macOS, Linux

## Screenshots

*Coming soon*

## Installation

### Voraussetzungen

- Flutter SDK 3.2.0 oder höher
- Dart SDK 3.2.0 oder höher
- Android Studio / VS Code mit Flutter Extension
- Java 17 (für Android Build)

### APK Download

Die neueste Version kann direkt von den [GitHub Releases](https://github.com/sprobst76/VibedKickr/releases) heruntergeladen werden.

### Aus Quellcode bauen

```bash
# Repository klonen
git clone https://github.com/sprobst76/VibedKickr.git
cd VibedKickr

# Dependencies installieren
flutter pub get

# Code generieren (Riverpod, Freezed, Drift)
dart run build_runner build --delete-conflicting-outputs

# App starten
flutter run -d android

# Oder Release APK bauen
flutter build apk --release
```

## Plattform-Konfiguration

### Android

BLE-Berechtigungen sind bereits in `AndroidManifest.xml` konfiguriert:
- `BLUETOOTH`, `BLUETOOTH_ADMIN`
- `BLUETOOTH_SCAN`, `BLUETOOTH_CONNECT`
- `ACCESS_FINE_LOCATION`

### macOS

In `macos/Runner/Info.plist`:
```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Diese App benötigt Bluetooth um mit deinem Trainer zu kommunizieren.</string>
```

### Linux

BlueZ 5.43+ erforderlich:
```bash
sudo apt-get install bluetooth bluez libbluetooth-dev
```

### Windows

BLE benötigt Windows 10 Version 1803 oder höher.

## Unterstützte Geräte

### Smart Trainer (FTMS-kompatibel)

| Hersteller | Modelle |
|------------|---------|
| **Wahoo** | Kickr, Kickr Core, Kickr Snap, Kickr Bike |
| **Tacx** | Neo, Neo 2T, Flux, Flow |
| **Elite** | Direto, Suito, Zumo |
| **Saris** | H3, M2 |
| **Andere** | Alle FTMS-kompatiblen Geräte |

### Herzfrequenz-Monitore

Alle BLE Heart Rate Monitore werden unterstützt (Polar, Garmin, Wahoo, etc.)

## Power Zones (Coggan)

| Zone | Name | % FTP | Beschreibung |
|------|------|-------|--------------|
| Z1 | Active Recovery | < 55% | Lockeres Pedalieren |
| Z2 | Endurance | 55-75% | Grundlagenausdauer |
| Z3 | Tempo | 75-90% | Zügiges Fahren |
| Z4 | Threshold | 90-105% | Schwellentraining |
| Z5 | VO₂max | 105-120% | Hochintensiv |
| Z6 | Anaerobic | 120-150% | Kurze Maximalbelastung |
| Z7 | Neuromuscular | > 150% | Sprints |

## Architektur

Das Projekt folgt Clean Architecture Prinzipien:

```
lib/
├── core/
│   ├── ble/          # BLE Manager, FTMS Service
│   ├── database/     # Drift SQLite Layer
│   ├── gpx/          # GPX Parsing & Route Service
│   ├── services/     # Business Services
│   └── theme/        # App Theme, Zone Colors
├── domain/
│   ├── entities/     # Domain Models
│   └── repositories/ # Repository Interfaces
├── data/
│   └── repositories/ # Repository Implementations
├── features/
│   ├── dashboard/    # Hauptansicht mit Live-Daten
│   ├── device_connection/ # BLE Scan & Connect
│   ├── workouts/     # Workout Player & Builder
│   ├── routes/       # GPX Routes Feature
│   ├── history/      # Session History
│   ├── training_load/ # PMC Chart
│   ├── comeback/     # Comeback Mode
│   ├── settings/     # App Settings
│   └── debug/        # BLE Diagnostic Tools
├── providers/        # Riverpod State Management
└── routing/          # GoRouter Navigation
```

Siehe [ARCHITECTURE.md](ARCHITECTURE.md) für Details.

## Entwicklung

### Projektstruktur

- **State Management**: Riverpod mit Code-Generierung
- **Immutable Data**: Freezed für Domain-Entities
- **Database**: Drift (SQLite) für Persistenz
- **Routing**: GoRouter mit Shell Routes
- **BLE**: flutter_blue_plus

### Commands

```bash
# Code generieren (nach Änderungen an Freezed/Riverpod/Drift)
dart run build_runner build --delete-conflicting-outputs

# Watch-Modus für kontinuierliche Generierung
dart run build_runner watch --delete-conflicting-outputs

# Tests ausführen
flutter test

# Analyse
flutter analyze

# Release Build
JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 flutter build apk --release
```

## Contributing

Beiträge sind willkommen! Siehe [CONTRIBUTING.md](CONTRIBUTING.md) für Guidelines.

## Changelog

Siehe [CHANGELOG.md](CHANGELOG.md) für die vollständige Versionshistorie.

## Roadmap

Siehe [TODO.md](TODO.md) für geplante Features.

## Lizensierung

### Für Community & Open Source

**GNU Affero General Public License v3 (AGPL v3)**

VibedKickr ist unter AGPL v3 lizenziert. Das bedeutet:

✅ **Kostenlos für:**
- Privates Training und Entwicklung
- Fitness-Studios (interne Nutzung)
- Open Source Projekte
- Lehreinrichtungen
- Gemeinnützige Organisationen

❌ **Nicht erlaubt ohne Lizenz:**
- Als SaaS/Web-App kommerziell anbieten
- In Premium-Apps integrieren und verkaufen
- Gewinnbringende Nutzung ohne Offenlegung des Codes
- Kommerzielle Modifikationen ohne Code-Offenlegung

Wenn du AGPL v3 verwendest, musst du alle Modifikationen und den gesamten Code offenlegen.

### Für kommerzielle Nutzung

**Commercial License** - Bezahlte Lizenz für Unternehmen

Falls du VibedKickr kommerziell nutzen möchtest, ist eine Commercial License erforderlich. Diese ermöglicht:

✅ **Mit Commercial License darfst du:**
- VibedKickr als SaaS anbieten
- Proprietary Extensions und Modifikationen machen
- Code geheim halten
- In kommerzielle Produkte integrieren
- Für Fitness-Studios/Premium-Apps nutzen

**Pricing:** Nach Anfrage (basierend auf Nutzungsart und Skalierung)

📧 **Kontakt für Commercial Licenses:**
```
Email: license@vibekickr.dev
Subject: Commercial License Inquiry
```

Bitte angeben:
- Unternehmensname und Beschreibung
- Geplante Nutzung (SaaS, embedded, white-label, etc.)
- Geschätzte Skalierung (Benutzer, Standorte, Regionen)
- Support-Anforderungen

Siehe [LICENSE.COMMERCIAL](LICENSE.COMMERCIAL) für vollständige Terms & Conditions.

---

**Lizenz-Übersicht:**

| Feature | AGPL v3 (Kostenlos) | Commercial License |
|---------|-------------------|-------------------|
| Privates Nutzung | ✅ | ✅ |
| Modifikationen erlaubt | ✅ | ✅ |
| Code muss offengelegt | ✅ | ❌ |
| SaaS/kommerzielle Nutzung | ❌* | ✅ |
| Proprietary Extensions | ❌ | ✅ |
| Support | Community | Bezahlt |

*Mit AGPL v3: Nur wenn allen Code offenlegst

---

Siehe [LICENSE](LICENSE) für die vollständige AGPL v3 Lizenztext

## Autor

Stefan Probst - Indoor Cycling Enthusiast 🚴‍♂️

---

*Built with Flutter & ❤️*
