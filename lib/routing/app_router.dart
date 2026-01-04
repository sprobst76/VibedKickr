import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/device_connection/presentation/pages/device_scan_page.dart';
import '../features/history/presentation/pages/session_detail_page.dart';
import '../features/history/presentation/pages/session_history_page.dart';
import '../features/workouts/presentation/pages/workout_list_page.dart';
import '../features/workouts/presentation/pages/workout_player_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';

/// Route Namen
class AppRoutes {
  static const dashboard = '/';
  static const deviceScan = '/devices';
  static const workouts = '/workouts';
  static const workoutPlayer = '/workouts/player';
  static const history = '/history';
  static const settings = '/settings';
}

/// GoRouter Provider
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    routes: [
      // Shell Route für Bottom Navigation
      ShellRoute(
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.workouts,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: WorkoutListPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.history,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SessionHistoryPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.settings,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsPage(),
            ),
          ),
        ],
      ),
      // Fullscreen Routes (außerhalb der Shell)
      GoRoute(
        path: AppRoutes.deviceScan,
        builder: (context, state) => const DeviceScanPage(),
      ),
      GoRoute(
        path: AppRoutes.workoutPlayer,
        builder: (context, state) {
          final workoutId = state.uri.queryParameters['workoutId'];
          return WorkoutPlayerPage(workoutId: workoutId);
        },
      ),
      GoRoute(
        path: '${AppRoutes.history}/:sessionId',
        builder: (context, state) {
          final sessionId = state.pathParameters['sessionId']!;
          return SessionDetailPage(sessionId: sessionId);
        },
      ),
    ],
  );
});

/// Main Shell mit Bottom Navigation
class MainShell extends ConsumerWidget {
  final Widget child;

  const MainShell({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const _BottomNavBar(),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    int currentIndex = 0;
    if (location.startsWith(AppRoutes.workouts)) {
      currentIndex = 1;
    } else if (location.startsWith(AppRoutes.history)) {
      currentIndex = 2;
    } else if (location == AppRoutes.settings) {
      currentIndex = 3;
    }

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            context.go(AppRoutes.dashboard);
            break;
          case 1:
            context.go(AppRoutes.workouts);
            break;
          case 2:
            context.go(AppRoutes.history);
            break;
          case 3:
            context.go(AppRoutes.settings);
            break;
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        NavigationDestination(
          icon: Icon(Icons.fitness_center_outlined),
          selectedIcon: Icon(Icons.fitness_center),
          label: 'Workouts',
        ),
        NavigationDestination(
          icon: Icon(Icons.history_outlined),
          selectedIcon: Icon(Icons.history),
          label: 'Verlauf',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
