import 'package:flutter/material.dart';

/// Power Zone Farben nach Coggan
class ZoneColors {
  static const z1ActiveRecovery = Color(0xFF9E9E9E); // Grau
  static const z2Endurance = Color(0xFF2196F3); // Blau
  static const z3Tempo = Color(0xFF4CAF50); // Grün
  static const z4Threshold = Color(0xFFFFEB3B); // Gelb
  static const z5Vo2Max = Color(0xFFFF9800); // Orange
  static const z6Anaerobic = Color(0xFFF44336); // Rot
  static const z7Neuromuscular = Color(0xFF9C27B0); // Violett

  static Color forZone(int zone) {
    return switch (zone) {
      1 => z1ActiveRecovery,
      2 => z2Endurance,
      3 => z3Tempo,
      4 => z4Threshold,
      5 => z5Vo2Max,
      6 => z6Anaerobic,
      7 => z7Neuromuscular,
      _ => z1ActiveRecovery,
    };
  }

  static String zoneName(int zone) {
    return switch (zone) {
      1 => 'Active Recovery',
      2 => 'Endurance',
      3 => 'Tempo',
      4 => 'Threshold',
      5 => 'VO₂max',
      6 => 'Anaerobic',
      7 => 'Neuromuscular',
      _ => 'Unknown',
    };
  }
}

/// App Farben
class AppColors {
  // Primärfarben
  static const primary = Color(0xFF00B4D8);
  static const primaryDark = Color(0xFF0077B6);
  static const secondary = Color(0xFF90E0EF);

  // Hintergrund
  static const background = Color(0xFF0D1117);
  static const surface = Color(0xFF161B22);
  static const surfaceLight = Color(0xFF21262D);

  // Status
  static const success = Color(0xFF2EA043);
  static const warning = Color(0xFFF0883E);
  static const error = Color(0xFFF85149);

  // Text
  static const textPrimary = Color(0xFFE6EDF3);
  static const textSecondary = Color(0xFF8B949E);
  static const textMuted = Color(0xFF6E7681);

  // Akzent
  static const accent = Color(0xFF58A6FF);

  // BLE Status
  static const connected = success;
  static const disconnected = error;
  static const scanning = warning;
}

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.background,

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),

      // Cards
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: AppColors.surfaceLight,
            width: 1,
          ),
        ),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Text
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 72,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: AppColors.textMuted,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
      ),

      // Input
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),

      // Navigation
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primaryDark,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.surfaceLight,
        thickness: 1,
      ),

      // Icons
      iconTheme: const IconThemeData(
        color: AppColors.textSecondary,
      ),

      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
    );
  }
}
