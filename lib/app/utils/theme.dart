import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF020B1A);
  static const sidebar = Color(0xFF020A17);
  static const card = Color(0xFF061426);
  static const card2 = Color(0xFF07182C);
  static const border = Color(0xFF102C49);

  static const blue = Color(0xFF079BFF);
  static const cyan = Color(0xFF00E5FF);
  static const purple = Color(0xFF8A2BE2);
  static const green = Color(0xFF32E875);
  static const orange = Color(0xFFFF9D00);
  static const red = Color(0xFFFF2635);
  static const yellow = Color(0xFFFFC400);

  static const text = Color(0xFFF3F7FF);
  static const secondaryText = Color(0xFFAEB9C8);
}

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: AppColors.background,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.blue,
      secondary: AppColors.cyan,
      surface: AppColors.card,
      error: AppColors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: AppColors.text,
      onError: Colors.white,
    ),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.text,
      elevation: 0,
      centerTitle: false,
    ),

    // Text
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: AppColors.text,
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),
      displayMedium: TextStyle(
        color: AppColors.text,
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      displaySmall: TextStyle(
        color: AppColors.text,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),

      headlineLarge: TextStyle(
        color: AppColors.text,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        color: AppColors.text,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      headlineSmall: TextStyle(
        color: AppColors.text,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),

      titleLarge: TextStyle(
        color: AppColors.text,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: TextStyle(
        color: AppColors.text,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        color: AppColors.text,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),

      bodyLarge: TextStyle(color: AppColors.text, fontSize: 16),
      bodyMedium: TextStyle(color: AppColors.text, fontSize: 14),
      bodySmall: TextStyle(color: AppColors.secondaryText, fontSize: 12),

      labelLarge: TextStyle(
        color: AppColors.text,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(color: AppColors.secondaryText, fontSize: 12),
      labelSmall: TextStyle(color: AppColors.secondaryText, fontSize: 10),
    ),

    // Cards
    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(11),
        side: const BorderSide(color: AppColors.border, width: 1),
      ),
    ),

    // Input / Search / TextField
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.card2,

      hintStyle: const TextStyle(color: AppColors.secondaryText, fontSize: 13),

      labelStyle: const TextStyle(color: AppColors.secondaryText),

      prefixIconColor: AppColors.secondaryText,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: AppColors.border),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: AppColors.border),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: AppColors.blue, width: 1.2),
      ),
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.cyan,
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 1,
      space: 1,
    ),

    // Icons
    iconTheme: const IconThemeData(color: AppColors.text, size: 24),

    // Progress
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.cyan,
      linearTrackColor: AppColors.border,
    ),

    // Checkbox
    checkboxTheme: CheckboxThemeData(
      side: const BorderSide(color: AppColors.secondaryText),
      fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.blue;
        }
        return Colors.transparent;
      }),
    ),

    // Switch
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.cyan;
        }
        return AppColors.secondaryText;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.blue.withValues(alpha: .4);
        }
        return AppColors.card2;
      }),
    ),
    
  );
}
