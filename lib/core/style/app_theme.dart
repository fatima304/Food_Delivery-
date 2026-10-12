import 'package:flutter/material.dart';
import 'package:food_delivery/core/constants/app_colors.dart';

/// Shared semantic colors; widgets should read their colors from ThemeData.
class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryGreen,
      brightness: brightness,
      primary: dark ? const Color(0xFF37D995) : AppColors.darkGreen,
      surface: dark ? const Color(0xFF121916) : Colors.white,
      error: dark ? const Color(0xFFFF7777) : AppColors.error,
    );
    final foreground = dark ? const Color(0xFFF3F7F5) : AppColors.textDark;
    final secondary = dark ? const Color(0xFFB1C0BA) : AppColors.textGrey;
    final field = dark ? const Color(0xFF24302A) : AppColors.fieldBackground;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      fontFamily: 'Inter',
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: foreground,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: foreground),
        bodyMedium: TextStyle(color: secondary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: field,
        hintStyle: TextStyle(
          color: dark ? const Color(0xFFAAB7B0) : AppColors.hintGrey,
        ),
      ),
      dividerColor: dark ? const Color(0xFF3A4740) : AppColors.dividerGrey,
      iconTheme: IconThemeData(color: secondary),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: scheme.primary),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? scheme.primary : null,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: dark
            ? const Color(0xFF2C3832)
            : const Color(0xFF323D37),
        contentTextStyle: const TextStyle(color: Colors.white),
      ),
    );
  }
}
