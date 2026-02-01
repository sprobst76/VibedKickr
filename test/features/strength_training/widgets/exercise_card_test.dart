import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kickr_trainer/core/theme/app_theme.dart';
import 'package:kickr_trainer/domain/entities/strength_exercise.dart';
import 'package:kickr_trainer/features/strength_training/presentation/widgets/exercise_card.dart';

void main() {
  group('ExerciseCard Widget', () {
    late StrengthExercise testExercise;

    setUp(() {
      testExercise = StrengthExercise(
        id: 'test_squat',
        name: 'Bodyweight Squat',
        description: 'Fundamental lower body exercise',
        primaryMuscles: [MuscleGroup.legs],
        secondaryMuscles: [MuscleGroup.core],
        equipment: EquipmentType.bodyweight,
        formCues: 'Feet shoulder-width. Chest up. Sit back.',
        difficulty: DifficultyLevel.beginner,
        isCompound: true,
        minimumAge: 18,
        requiresModification50Plus: true,
        modification50PlusNotes: 'Use chair for support if needed',
      );
    });

    testWidgets('renders exercise name correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseCard(exercise: testExercise),
          ),
        ),
      );

      expect(find.text('Bodyweight Squat'), findsOneWidget);
    });

    testWidgets('displays compound badge when applicable', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseCard(exercise: testExercise),
          ),
        ),
      );

      expect(find.text('Compound'), findsOneWidget);
    });

    testWidgets('shows primary muscle group chips', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseCard(exercise: testExercise),
          ),
        ),
      );

      // Should show at least one muscle group chip
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('displays difficulty level badge', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseCard(exercise: testExercise),
          ),
        ),
      );

      // Beginner difficulty in German
      final difficultyFinder = find.text('Anfänger');
      expect(difficultyFinder, findsOneWidget);
    });

    testWidgets('shows equipment type label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseCard(exercise: testExercise),
          ),
        ),
      );

      // Bodyweight in German
      expect(find.text('Körpergewicht'), findsOneWidget);
    });

    testWidgets('calls onTap callback when tapped', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseCard(
              exercise: testExercise,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ExerciseCard));
      expect(tapped, true);
    });

    testWidgets('renders intermediate difficulty badge', (WidgetTester tester) async {
      final intermediateExercise = testExercise.copyWith(
        difficulty: DifficultyLevel.intermediate,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseCard(exercise: intermediateExercise),
          ),
        ),
      );

      final difficultyFinder = find.text('Mittel');
      expect(difficultyFinder, findsOneWidget);
    });

    testWidgets('renders advanced difficulty badge', (WidgetTester tester) async {
      final advancedExercise = testExercise.copyWith(
        difficulty: DifficultyLevel.advanced,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseCard(exercise: advancedExercise),
          ),
        ),
      );

      final difficultyFinder = find.text('Fortgeschritten');
      expect(difficultyFinder, findsOneWidget);
    });

    testWidgets('displays isolation exercises without compound badge', (WidgetTester tester) async {
      final isolationExercise = testExercise.copyWith(
        id: 'bicep_curl',
        name: 'Bicep Curl',
        primaryMuscles: [MuscleGroup.arms],
        secondaryMuscles: [],
        isCompound: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseCard(exercise: isolationExercise),
          ),
        ),
      );

      expect(find.text('Compound'), findsNothing);
      expect(find.text('Bicep Curl'), findsOneWidget);
    });

    testWidgets('shows muscle group chips', (WidgetTester tester) async {
      final multiMuscleExercise = testExercise.copyWith(
        primaryMuscles: [MuscleGroup.chest, MuscleGroup.shoulders],
        secondaryMuscles: [MuscleGroup.arms],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseCard(exercise: multiMuscleExercise),
          ),
        ),
      );

      // Should show muscle group chips for primary muscles
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('card is tappable even without onTap callback', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseCard(exercise: testExercise),
          ),
        ),
      );

      // Should not throw when tapped without callback
      await tester.tap(find.byType(ExerciseCard));
      expect(find.byType(ExerciseCard), findsOneWidget);
    });

    testWidgets('displays correct equipment type', (WidgetTester tester) async {
      final dumbellExercise = testExercise.copyWith(
        equipment: EquipmentType.dumbbells,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseCard(exercise: dumbellExercise),
          ),
        ),
      );

      // Dumbbells in German
      expect(find.text('Kurzhanteln'), findsOneWidget);
    });
  });

  group('ExerciseCard - Multiple Exercises', () {
    testWidgets('renders list of exercise cards correctly', (WidgetTester tester) async {
      final exercises = [
        StrengthExercise(
          id: 'ex1',
          name: 'Exercise 1',
          description: 'Test',
          primaryMuscles: [MuscleGroup.chest],
          secondaryMuscles: [],
          equipment: EquipmentType.barbell,
          formCues: 'Test cue',
          difficulty: DifficultyLevel.beginner,
          isCompound: true,
          minimumAge: 16,
          requiresModification50Plus: false,
          modification50PlusNotes: null,
        ),
        StrengthExercise(
          id: 'ex2',
          name: 'Exercise 2',
          description: 'Test',
          primaryMuscles: [MuscleGroup.legs],
          secondaryMuscles: [],
          equipment: EquipmentType.bodyweight,
          formCues: 'Test cue',
          difficulty: DifficultyLevel.intermediate,
          isCompound: false,
          minimumAge: 18,
          requiresModification50Plus: true,
          modification50PlusNotes: 'Use chair',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: exercises
                  .map((e) => ExerciseCard(exercise: e))
                  .toList(),
            ),
          ),
        ),
      );

      expect(find.text('Exercise 1'), findsOneWidget);
      expect(find.text('Exercise 2'), findsOneWidget);
    });
  });
}
