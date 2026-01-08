# Play Store Veröffentlichung - VibedKickr

Diese Anleitung beschreibt die Schritte zur Veröffentlichung von VibedKickr im Google Play Store.

## Inhaltsverzeichnis

1. [Vorbereitung](#vorbereitung)
2. [Keystore erstellen](#keystore-erstellen)
3. [Signing konfigurieren](#signing-konfigurieren)
4. [Release Build erstellen](#release-build-erstellen)
5. [Play Console Setup](#play-console-setup)
6. [Store Listing](#store-listing)
7. [Checkliste](#checkliste)

---

## Vorbereitung

### Voraussetzungen

- [x] Google Play Developer Account ($25 einmalig)
- [x] App funktioniert fehlerfrei
- [x] App-Icon erstellt
- [x] Version auf 1.2.0 aktualisiert
- [ ] Keystore erstellt
- [ ] Screenshots erstellt
- [ ] Datenschutzerklärung URL

### Application ID

Aktuell: `de.stefan.kickr_trainer`

Empfehlung für Play Store: `de.vibedkickr.app` oder beibehalten.

---

## Keystore erstellen

### 1. Keystore generieren

```bash
# Im Terminal ausführen (NICHT in Repository speichern!)
keytool -genkey -v -keystore ~/vibedkickr-release-key.jks \
  -storetype JKS \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias vibedkickr
```

**Wichtig:**
- Sichere Passwörter verwenden
- Keystore NIEMALS ins Git-Repository einchecken
- Keystore und Passwörter sicher aufbewahren (Backup!)
- Bei Verlust kann die App nicht mehr aktualisiert werden

### 2. key.properties erstellen

Erstelle `android/key.properties` (wird von .gitignore ignoriert):

```properties
storePassword=DEIN_STORE_PASSWORT
keyPassword=DEIN_KEY_PASSWORT
keyAlias=vibedkickr
storeFile=/pfad/zu/vibedkickr-release-key.jks
```

---

## Signing konfigurieren

Die Datei `android/app/build.gradle.kts` ist bereits für Release-Signing vorbereitet.

### Aktuelle Konfiguration

```kotlin
android {
    signingConfigs {
        create("release") {
            val keystorePropertiesFile = rootProject.file("key.properties")
            if (keystorePropertiesFile.exists()) {
                val keystoreProperties = java.util.Properties()
                keystoreProperties.load(java.io.FileInputStream(keystorePropertiesFile))
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}
```

---

## Release Build erstellen

### App Bundle (empfohlen für Play Store)

```bash
# App Bundle für Play Store
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

### APK (für direkten Download)

```bash
# Release APK
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

---

## Play Console Setup

### 1. App erstellen

1. [Play Console](https://play.google.com/console) öffnen
2. "App erstellen" klicken
3. Details eingeben:
   - App-Name: **VibedKickr**
   - Standardsprache: **Deutsch**
   - App oder Spiel: **App**
   - Kostenlos oder kostenpflichtig: **Kostenlos**

### 2. Store-Eintrag

Siehe [Store Listing](#store-listing) unten.

### 3. App-Inhalte

- **Datenschutzerklärung**: URL erforderlich
- **App-Zugriff**: Alle Funktionen ohne Anmeldung verfügbar
- **Anzeigen**: Keine Anzeigen
- **Content-Rating**: Fragebogen ausfüllen (IARC)
- **Zielgruppe**: 18+ (Fitness-App)

### 4. App Release

1. "Produktion" oder "Interne Tests" auswählen
2. App Bundle hochladen
3. Release-Notes eingeben
4. Review starten

---

## Store Listing

### App-Name
**VibedKickr**

### Kurzbeschreibung (80 Zeichen)
```
Indoor-Cycling Training & Smart Trainer Steuerung für Wahoo, Tacx & mehr
```

### Vollständige Beschreibung (4000 Zeichen)

```
🚴 VibedKickr - Dein persönlicher Indoor-Cycling Coach

Verwandle deinen Smart Trainer in ein leistungsstarkes Trainingstool! VibedKickr verbindet sich via Bluetooth mit deinem Wahoo Kickr, Tacx Neo, Elite Direto oder jedem anderen FTMS-kompatiblen Trainer und bietet dir strukturierte Workouts mit automatischer Widerstandssteuerung.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 FEATURES

▸ SMART TRAINER STEUERUNG
• ERG-Modus: Automatische Wattsteuerung
• Verbindung mit allen FTMS-Trainern
• Separate HR-Monitor Unterstützung
• Auto-Reconnect bei Verbindungsabbruch

▸ STRUKTURIERTE WORKOUTS
• Vordefinierte Intervall-Workouts
• FTP-Tests (20min, Ramp Test)
• Sweet Spot & VO2max Training
• Eigene Workouts erstellen
• Audio-Cues bei Intervallwechsel

▸ LIVE-DATEN
• Echtzeit Power, Kadenz, Herzfrequenz
• Farbcodierte Power Zones (Coggan)
• Live-Chart Visualisierung
• Power Gauge mit Zonen-Anzeige

▸ GPX-ROUTEN
• Importiere echte Strecken
• Höhenprofil-Simulation
• Steigungsbasierte Widerstandssteuerung
• Virtuelle Fahrten mit echten Daten

▸ TRAINING LOAD ANALYSE
• TSS (Training Stress Score)
• CTL/ATL/TSB Tracking
• Performance Management Chart
• Personal Records

▸ COMEBACK MODUS
• Strukturierter Wiedereinstieg nach Pause
• Progressive Belastungssteigerung
• Angepasste Workouts

▸ EXPORT & SYNC
• Strava Integration
• FIT & TCX Export
• Session History

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔌 KOMPATIBLE GERÄTE

Smart Trainer:
• Wahoo: Kickr, Kickr Core, Kickr Snap, Kickr Bike
• Tacx: Neo, Neo 2T, Flux, Flow
• Elite: Direto, Suito, Zumo
• Saris: H3, M2
• Alle FTMS-kompatiblen Trainer

Herzfrequenz:
• Alle BLE HR-Monitore (Polar, Garmin, Wahoo, etc.)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 POWER ZONES (COGGAN)

Z1: Active Recovery (< 55% FTP)
Z2: Endurance (55-75% FTP)
Z3: Tempo (75-90% FTP)
Z4: Threshold (90-105% FTP)
Z5: VO₂max (105-120% FTP)
Z6: Anaerobic (120-150% FTP)
Z7: Neuromuscular (> 150% FTP)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔒 DATENSCHUTZ

• Alle Daten lokal auf dem Gerät
• Keine Werbung
• Kein Tracking
• Open Source

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Trainiere smarter, nicht härter! 💪
```

### Kategorie
**Gesundheit & Fitness**

### Tags
- Indoor Cycling
- Smart Trainer
- Wahoo Kickr
- Tacx
- ERG Mode
- Power Training
- FTP
- Cycling Workout
- Bluetooth Trainer
- Zwift Alternative

### Screenshots (erforderlich)

Mindestens 2 Screenshots pro Gerätetyp:

1. **Dashboard** - Live-Daten Übersicht
2. **Workout Player** - Intervall-Training in Aktion
3. **Workout Builder** - Eigene Workouts erstellen
4. **Routes** - GPX Strecken mit Höhenprofil
5. **Training Load** - PMC Chart
6. **Settings** - Trainer-Verbindung

Größen:
- Handy: 1080x1920 oder 1080x2340
- Tablet 7": 1200x1920
- Tablet 10": 1600x2560

### Feature Graphic
1024x500 px - Banner mit App-Logo und Cyclist

### App-Icon
512x512 px - Wird automatisch aus dem App-Icon generiert

---

## Checkliste

### Vor dem Upload

- [ ] Keystore erstellt und sicher gespeichert
- [ ] key.properties konfiguriert
- [ ] Version in pubspec.yaml aktualisiert
- [ ] App Bundle erfolgreich gebaut
- [ ] App auf echtem Gerät getestet
- [ ] Alle Features funktionieren

### Store Listing

- [ ] App-Name: VibedKickr
- [ ] Kurzbeschreibung eingegeben
- [ ] Vollständige Beschreibung eingegeben
- [ ] Kategorie: Gesundheit & Fitness
- [ ] Screenshots hochgeladen (min. 2)
- [ ] Feature Graphic hochgeladen
- [ ] App-Icon hochgeladen

### Rechtliches

- [ ] Datenschutzerklärung URL
- [ ] Content Rating ausgefüllt
- [ ] Zielgruppe definiert
- [ ] Datenerfassung deklariert

### Release

- [ ] Interner Test erfolgreich
- [ ] Beta-Test (optional)
- [ ] Produktions-Release eingereicht
- [ ] Review abwarten (1-7 Tage)

---

## Nützliche Links

- [Flutter Deployment Guide](https://docs.flutter.dev/deployment/android)
- [Play Console](https://play.google.com/console)
- [App Signing](https://support.google.com/googleplay/android-developer/answer/9842756)
- [Store Listing Requirements](https://support.google.com/googleplay/android-developer/answer/9859152)
