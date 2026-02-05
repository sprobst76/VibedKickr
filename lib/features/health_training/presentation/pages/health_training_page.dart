import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../widgets/cycling_health_training_tab.dart';
import '../widgets/morning_workout_tab.dart';
import '../widgets/strength_training_tab.dart';

/// Hauptseite für Gesundheitstraining mit TabBar für Radfahren und Krafttraining
class HealthTrainingPage extends ConsumerWidget {
  const HealthTrainingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gesundheitstraining'),
          elevation: 0,
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textMuted,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(
                icon: const Icon(Icons.wb_sunny),
                text: 'Morgen',
              ),
              Tab(
                icon: const Icon(Icons.directions_bike),
                text: 'Radfahren',
              ),
              Tab(
                icon: const Icon(Icons.fitness_center),
                text: 'Kraft',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MorningWorkoutTab(),
            CyclingHealthTrainingTab(),
            StrengthTrainingTab(),
          ],
        ),
      ),
    );
  }
}
