# Architektur - VibedKickr

Dieses Dokument beschreibt die technische Architektur der VibedKickr App.

## Übersicht

VibedKickr folgt den Prinzipien der **Clean Architecture** kombiniert mit einer **Feature-basierten Organisation**. Dies ermöglicht:

- Klare Trennung von Verantwortlichkeiten
- Einfache Testbarkeit
- Unabhängige Feature-Entwicklung
- Skalierbarkeit bei wachsender Codebasis

## Schichten

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                        │
│  (UI Widgets, Pages, Feature Modules)                       │
├─────────────────────────────────────────────────────────────┤
│                    Application Layer                         │
│  (Providers, State Management, Use Cases)                   │
├─────────────────────────────────────────────────────────────┤
│                      Domain Layer                            │
│  (Entities, Repository Interfaces, Business Logic)          │
├─────────────────────────────────────────────────────────────┤
│                       Data Layer                             │
│  (Repository Implementations, Data Sources)                 │
├─────────────────────────────────────────────────────────────┤
│                    Infrastructure Layer                      │
│  (Database, BLE, External APIs)                             │
└─────────────────────────────────────────────────────────────┘
```

## Projektstruktur

```
lib/
├── main.dart                    # App Entry Point
├── app.dart                     # MaterialApp Setup
│
├── core/                        # Shared Infrastructure
│   ├── ble/                     # Bluetooth Low Energy
│   │   ├── ble_manager.dart     # Connection Management
│   │   ├── ftms_service.dart    # FTMS Protocol
│   │   ├── ftms_parser.dart     # Data Parsing
│   │   ├── mock_ftms_service.dart # Simulator
│   │   └── models/              # BLE Data Models
│   │
│   ├── database/                # SQLite via Drift
│   │   ├── app_database.dart    # Database Class
│   │   ├── tables/              # Table Definitions
│   │   ├── daos/                # Data Access Objects
│   │   └── mappers/             # Entity Mapping
│   │
│   ├── gpx/                     # GPX Processing
│   │   └── gpx_route_service.dart
│   │
│   ├── services/                # Business Services
│   │   ├── training_load_service.dart
│   │   ├── personal_record_service.dart
│   │   └── comeback_service.dart
│   │
│   └── theme/                   # UI Theming
│       └── app_theme.dart
│
├── domain/                      # Business Domain
│   ├── entities/                # Domain Models
│   │   ├── athlete_profile.dart
│   │   ├── training_session.dart
│   │   ├── workout.dart
│   │   ├── gpx_route.dart
│   │   └── ...
│   │
│   └── repositories/            # Repository Interfaces
│       ├── session_repository.dart
│       ├── workout_repository.dart
│       └── ...
│
├── data/                        # Data Layer
│   └── repositories/            # Repository Implementations
│       ├── session_repository_impl.dart
│       └── ...
│
├── features/                    # Feature Modules
│   ├── dashboard/               # Main Dashboard
│   │   └── presentation/
│   │       ├── pages/
│   │       └── widgets/
│   │
│   ├── device_connection/       # BLE Device Management
│   ├── workouts/                # Workout Player & Builder
│   ├── routes/                  # GPX Routes
│   ├── history/                 # Session History
│   ├── training_load/           # PMC Chart
│   ├── comeback/                # Comeback Mode
│   ├── settings/                # App Settings
│   └── debug/                   # Debug Tools
│
├── providers/                   # State Management
│   └── providers.dart           # Riverpod Providers
│
└── routing/                     # Navigation
    └── app_router.dart          # GoRouter Config
```

## State Management

### Riverpod

Die App verwendet **Riverpod** für reaktives State Management:

```dart
// Provider Types
final simpleProvider = Provider<T>((ref) => ...);
final stateProvider = StateProvider<T>((ref) => ...);
final streamProvider = StreamProvider<T>((ref) => ...);
final notifierProvider = NotifierProvider<N, T>((ref) => ...);
```

### Wichtige Provider

```dart
// BLE Connection
bleManagerProvider          // BLE Manager Singleton
bleConnectionStateProvider  // Connection Status Stream
ftmsDataProvider           // Live Trainer Data Stream

// Athlete
athleteProfileProvider     // User Profile
ftpProvider               // FTP Value

// Training
liveTrainingDataProvider   // Aggregated Live Data
activeSessionProvider      // Current Session State
workoutPlayerProvider      // Workout Execution State

// Database
appDatabaseProvider        // Database Instance
sessionRepositoryProvider  // Session Repository
```

### Data Flow

```
BLE Device
    │
    ▼
┌─────────────────┐
│   BLE Manager   │ ──── Device Discovery
└────────┬────────┘       Connection Management
         │
         ▼
┌─────────────────┐
│  FTMS Service   │ ──── Protocol Parsing
└────────┬────────┘       Data Extraction
         │
         ▼
┌─────────────────┐
│  StreamProvider │ ──── Reactive Updates
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│    UI Widget    │ ──── Consumer/Watch
└─────────────────┘
```

## BLE-Schicht

### FTMS Protocol

Die App implementiert das **Fitness Machine Service (FTMS)** BLE-Protokoll:

```
Service UUID: 0x1826 (FTMS)
├── Characteristic: 0x2AD2 (Indoor Bike Data)
│   └── Notifications: Speed, Cadence, Power, HR
├── Characteristic: 0x2AD9 (Fitness Machine Control Point)
│   ├── Request Control
│   ├── Set Target Power (ERG Mode)
│   └── Set Simulation Parameters
└── Characteristic: 0x2ACC (Fitness Machine Feature)
    └── Supported Features Bitmap
```

### Connection Lifecycle

```
┌────────────┐
│   Idle     │
└─────┬──────┘
      │ startScan()
      ▼
┌────────────┐
│  Scanning  │ ◄─── Device Discovery
└─────┬──────┘
      │ connect(device)
      ▼
┌────────────┐
│ Connecting │
└─────┬──────┘
      │ Services Discovered
      ▼
┌────────────┐
│ Connected  │ ◄─── FTMS Data Stream Active
└─────┬──────┘
      │ disconnect() / Connection Lost
      ▼
┌────────────┐
│Disconnected│ ──── Auto-Reconnect (optional)
└────────────┘
```

## Database Layer

### Drift (SQLite)

```dart
@DriftDatabase(
  tables: [TrainingSessions, DataPoints, CustomWorkouts, GpxRoutes, PersonalRecords],
  daos: [SessionDao, WorkoutDao, GpxRouteDao, PersonalRecordDao],
)
class AppDatabase extends _$AppDatabase { ... }
```

### Schema

```
┌─────────────────────┐       ┌─────────────────────┐
│  TrainingSessions   │       │     DataPoints      │
├─────────────────────┤       ├─────────────────────┤
│ id (PK)             │◄──────│ session_id (FK)     │
│ start_time          │       │ timestamp_ms        │
│ end_time            │       │ power               │
│ session_type        │       │ cadence             │
│ workout_id (FK)     │       │ heart_rate          │
│ stats_*             │       │ speed               │
└─────────────────────┘       └─────────────────────┘

┌─────────────────────┐       ┌─────────────────────┐
│   CustomWorkouts    │       │      GpxRoutes      │
├─────────────────────┤       ├─────────────────────┤
│ id (PK)             │       │ id (PK)             │
│ name                │       │ name                │
│ description         │       │ gpx_content         │
│ intervals_json      │       │ total_distance      │
│ total_duration      │       │ total_elevation     │
└─────────────────────┘       └─────────────────────┘
```

### Repository Pattern

```dart
// Interface (Domain Layer)
abstract class SessionRepository {
  Future<void> saveSession(TrainingSession session);
  Future<TrainingSession?> getSession(String id);
  Stream<List<TrainingSession>> watchAllSessions();
}

// Implementation (Data Layer)
class SessionRepositoryImpl implements SessionRepository {
  final AppDatabase _db;

  @override
  Future<void> saveSession(TrainingSession session) async {
    await _db.sessionDao.insertSession(
      SessionMapper.toCompanion(session),
    );
  }
}
```

## Feature Modules

Jedes Feature ist ein eigenständiges Modul:

```
features/workouts/
├── presentation/
│   ├── pages/
│   │   ├── workout_list_page.dart
│   │   ├── workout_player_page.dart
│   │   └── workout_builder_page.dart
│   └── widgets/
│       ├── workout_card.dart
│       ├── interval_progress_bar.dart
│       └── workout_timeline.dart
└── (domain/ & data/ if feature-specific)
```

## Navigation

### GoRouter

```dart
final router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(path: '/', builder: (_, __) => DashboardPage()),
        GoRoute(path: '/workouts', builder: (_, __) => WorkoutListPage()),
        GoRoute(path: '/history', builder: (_, __) => SessionHistoryPage()),
        GoRoute(path: '/settings', builder: (_, __) => SettingsPage()),
      ],
    ),
  ],
);
```

## Code Generation

Die App verwendet mehrere Code-Generatoren:

| Package | Zweck | Generierte Dateien |
|---------|-------|-------------------|
| **freezed** | Immutable Data Classes | `*.freezed.dart` |
| **json_serializable** | JSON Serialization | `*.g.dart` |
| **riverpod_generator** | Type-safe Providers | `*.g.dart` |
| **drift_dev** | Database Code | `*.g.dart` |

Generierung ausführen:
```bash
dart run build_runner build --delete-conflicting-outputs
```

## Testing

### Unit Tests

```dart
// Domain Entity Tests
test('SessionStats calculates TSS correctly', () {
  final stats = SessionStats.calculate(dataPoints, ftp: 200);
  expect(stats.tss, closeTo(75, 1));
});

// Repository Tests (mit Mock Database)
test('SessionRepository saves and retrieves session', () async {
  final repo = SessionRepositoryImpl(mockDb);
  await repo.saveSession(testSession);
  final result = await repo.getSession(testSession.id);
  expect(result, equals(testSession));
});
```

### Widget Tests

```dart
testWidgets('PowerGauge displays current power', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [ftmsDataProvider.overrideWith((_) => mockStream)],
      child: PowerGauge(),
    ),
  );
  expect(find.text('200 W'), findsOneWidget);
});
```

## Performance Optimierungen

1. **Lazy Loading**: Features werden erst bei Bedarf geladen
2. **Stream-basierte Updates**: Nur geänderte Daten triggern Rebuilds
3. **Batch Operations**: DataPoints werden in Batches geschrieben
4. **Efficient Queries**: Pagination für Session History
5. **const Widgets**: Wo immer möglich für Widget-Caching

## Sicherheit

1. **Keine sensiblen Daten** im Code (API Keys etc.)
2. **BLE-Permissions** werden zur Laufzeit angefragt
3. **SQLite** für lokale Datenspeicherung
4. **OAuth2** für Strava mit sicherem Token-Handling

## Erweiterbarkeit

### Neues Feature hinzufügen

1. Feature-Ordner erstellen: `lib/features/new_feature/`
2. Pages und Widgets implementieren
3. Provider in `providers.dart` registrieren
4. Route in `app_router.dart` hinzufügen
5. Navigation in UI verknüpfen

### Neuen Trainer-Typ unterstützen

1. BLE-Service UUID in `ble_manager.dart` hinzufügen
2. Parser in `ftms_parser.dart` erweitern (falls nötig)
3. Daten in `FtmsData` Model mappen
