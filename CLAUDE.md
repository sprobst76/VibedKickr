# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

VibedKickr is a Flutter-based indoor cycling training app that controls smart trainers (Wahoo Kickr Core and other FTMS-compatible devices) via Bluetooth Low Energy. It provides structured interval workouts with real-time power zone tracking and session recording.

## Build Commands

```bash
# Install dependencies
flutter pub get

# Generate code (Riverpod, Freezed, JSON serializable, Drift) - required before first run
dart run build_runner build --delete-conflicting-outputs

# Run on specific platform
flutter run -d android
flutter run -d macos
flutter run -d linux

# Lint
flutter analyze

# Run tests
flutter test

# Run a single test file
flutter test test/path/to/test_file.dart
```

## Architecture

**Clean Architecture with Feature-Based Organization:**

- `lib/core/ble/` - Bluetooth Low Energy layer
  - `ble_manager.dart` - Singleton orchestrating device scanning, connection lifecycle, auto-reconnect
  - `ftms_service.dart` - FTMS (Fitness Machine Service) protocol parser for trainer data
- `lib/domain/entities/` - Core domain models (AthleteProfile, Workout, TrainingSession)
- `lib/features/` - Feature modules (dashboard, device_connection, workouts, settings)
- `lib/providers/providers.dart` - Centralized Riverpod provider definitions
- `lib/routing/app_router.dart` - GoRouter navigation with shell routes

**State Management:**
- Riverpod for reactive state management
- Stream-based data flows for BLE device discovery and FTMS trainer data
- Key providers: `bleManagerProvider`, `bleConnectionStateProvider`, `ftmsDataProvider`, `athleteProfileProvider`, `liveTrainingDataProvider`

**Code Generation:**
- Freezed for immutable data classes
- Riverpod Generator for providers
- Drift for type-safe SQLite database layer

## Platform Notes

- **Android**: Primary platform, full BLE support
- **macOS/Linux**: BLE supported (Linux requires BlueZ 5.43+)
- **Windows**: BLE not supported - code handles gracefully with error messages

## Key Domain Concepts

- **Power Zones**: 7-zone Coggan model calculated from athlete's FTP
- **Heart Rate Zones**: 5-zone model from max heart rate
- **Workouts**: Templated intervals with power targets (absolute watts, FTP percentage, or ranges)
- **FTMS Protocol**: Standard BLE protocol for smart trainers providing power, cadence, speed data
