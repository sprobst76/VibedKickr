# Kickr Trainer App 🚴‍♂️

Eine Flutter-basierte Indoor-Cycling-App zur Steuerung von Smart Trainern (Wahoo Kickr Core und andere FTMS-kompatible Geräte).

## Features

- 🔗 **BLE-Verbindung** - Automatischer Scan und Verbindung mit FTMS-Trainern
- 📊 **Live-Daten** - Echtzeit-Anzeige von Power, Kadenz, Herzfrequenz
- 🎯 **ERG-Modus** - Automatische Widerstandssteuerung nach Ziel-Watt
- 🏋️ **Intervall-Workouts** - Vordefinierte Trainingsprogramme
- 📈 **Power Zones** - Coggan-basierte Zonen-Berechnung
- 💾 **Session-Tracking** - Aufzeichnung aller Trainingseinheiten
- 🖥️ **Multi-Platform** - Android, Windows, macOS, Linux

## Voraussetzungen

- Flutter SDK 3.2.0 oder höher
- Dart SDK 3.2.0 oder höher
- Android Studio / VS Code mit Flutter Extension
- Für Desktop: Entsprechende Entwicklungstools (Visual Studio für Windows, Xcode für macOS)

## Installation

### 1. Flutter-Projekt initialisieren

```bash
# In einem leeren Verzeichnis:
flutter create --org de.stefan --project-name kickr_trainer --platforms=android,windows,macos,linux .

# Oder in bestehendes Verzeichnis:
cd kickr_trainer_app
flutter create --org de.stefan --project-name kickr_trainer --platforms=android,windows,macos,linux .
```

### 2. Dateien kopieren

Kopiere alle Dateien aus diesem Archiv in das Flutter-Projekt.

### 3. Dependencies installieren

```bash
flutter pub get
```

### 4. Code generieren

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 5. App starten

```bash
# Android
flutter run -d android

# Windows
flutter run -d windows

# macOS  
flutter run -d macos

# Linux
flutter run -d linux
```

## Plattform-spezifische Konfiguration

### Android

In `android/app/src/main/AndroidManifest.xml` hinzufügen:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    
    <!-- BLE Permissions -->
    <uses-permission android:name="android.permission.BLUETOOTH" />
    <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
    <uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
    <uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    
    <uses-feature android:name="android.hardware.bluetooth_le" android:required="true" />
    
    <application ...>
```

### Windows

BLE auf Windows benötigt Windows 10 Version 1803 oder höher.

In `windows/runner/main.cpp` ggf. COM initialisieren:
```cpp
#include <windows.h>
// COM ist für BLE auf Windows erforderlich
CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);
```

### macOS

In `macos/Runner/Info.plist` hinzufügen:

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Diese App benötigt Bluetooth um mit deinem Trainer zu kommunizieren.</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>Diese App benötigt Bluetooth um mit deinem Trainer zu kommunizieren.</string>
```

In `macos/Runner/DebugProfile.entitlements` und `Release.entitlements`:

```xml
<key>com.apple.security.device.bluetooth</key>
<true/>
```

### Linux

BLE auf Linux benötigt BlueZ 5.43 oder höher.

```bash
# Bluetooth-Pakete installieren
sudo apt-get install bluetooth bluez libbluetooth-dev
```

## Projektstruktur

```
lib/
├── main.dart                 # App Entry Point
├── app.dart                  # MaterialApp Setup
├── core/
│   ├── ble/                  # BLE Manager, FTMS Service
│   ├── theme/                # App Theme, Zone Colors
│   └── storage/              # Persistence (TODO)
├── domain/
│   └── entities/             # Workout, Session, Profile
├── features/
│   ├── dashboard/            # Hauptansicht
│   ├── device_connection/    # BLE Scan & Connect
│   ├── workouts/             # Workout Player
│   └── settings/             # Einstellungen
├── providers/                # Riverpod State
└── routing/                  # GoRouter Navigation
```

## Unterstützte Trainer

Alle FTMS-kompatiblen Smart Trainer:

- **Wahoo**: Kickr, Kickr Core, Kickr Snap, Kickr Bike
- **Tacx**: Neo, Flux, Flow
- **Elite**: Direto, Suito, Zumo
- **Saris**: H3, M2
- **Und viele mehr...**

## Power Zones (Coggan)

| Zone | Name | % FTP |
|------|------|-------|
| Z1 | Active Recovery | < 55% |
| Z2 | Endurance | 55-75% |
| Z3 | Tempo | 75-90% |
| Z4 | Threshold | 90-105% |
| Z5 | VO₂max | 105-120% |
| Z6 | Anaerobic | 120-150% |
| Z7 | Neuromuscular | > 150% |

## Roadmap

- [ ] GPX-Import für Streckensimulation
- [ ] FIT-Export für Garmin Connect / TrainingPeaks
- [ ] Strava-Integration
- [ ] Workout Builder
- [ ] Audio Coaching
- [ ] Power Curve Analyse
- [ ] TSS/CTL/ATL Tracking

## Lizenz

MIT License - Siehe LICENSE Datei

## Autor

Stefan - Indoor Cycling Enthusiast 🚴‍♂️
