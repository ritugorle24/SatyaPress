import 'package:flutter/material.dart';
import 'app_colors.dart';

/// AppSpacing holds spacing constants for margins and padding.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

/// AppBorderRadius holds border radius constants.
class AppBorderRadius {
  AppBorderRadius._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 28.0;
  static const double circular = 999.0;
}

/// AppTheme defines the Material 3 light theme for the application.
class AppTheme {
  AppTheme._();

  /// Light theme definition
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceContainerHighest: AppColors.surfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        shadow: AppColors.shadow,
        scrim: AppColors.scrim,
        inverseSurface: AppColors.inverseSurface,
        onInverseSurface: AppColors.inverseOnSurface,
        inversePrimary: AppColors.inversePrimary,
      ),
      textTheme: textTheme,
      cardTheme: cardTheme,
      chipTheme: chipTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      outlinedButtonTheme: outlinedButtonTheme,
      textButtonTheme: textButtonTheme,
      inputDecorationTheme: inputDecorationTheme,
    );
  }

  /// Typography scale definitions
  static TextTheme get textTheme => const TextTheme(
        displayLarge: TextStyle(
          fontSize: 57.0,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.25,
          height: 1.12,
        ),
        displayMedium: TextStyle(
          fontSize: 45.0,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.0,
          height: 1.16,
        ),
        displaySmall: TextStyle(
          fontSize: 36.0,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.0,
          height: 1.22,
        ),
        headlineLarge: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.0,
          height: 1.25,
        ),
        headlineMedium: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.0,
          height: 1.29,
        ),
        headlineSmall: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.0,
          height: 1.33,
        ),
        titleLarge: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.0,
          height: 1.27,
        ),
        titleMedium: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
          height: 1.5,
        ),
        titleSmall: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          height: 1.43,
        ),
        bodyLarge: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          height: 1.43,
        ),
        bodySmall: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          height: 1.33,
        ),
        labelLarge: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          height: 1.43,
        ),
        labelMedium: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          height: 1.33,
        ),
        labelSmall: TextStyle(
          fontSize: 11.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          height: 1.45,
        ),
      );

  /// Card Theme custom styling
  static CardThemeData get cardTheme => CardThemeData(
        color: AppColors.surface,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          side: const BorderSide(color: AppColors.outlineVariant, width: 1.0),
        ),
        margin: const EdgeInsets.all(AppSpacing.sm),
      );

  /// Chip Theme custom styling
  static ChipThemeData get chipTheme => ChipThemeData(
        backgroundColor: AppColors.surfaceVariant,
        disabledColor: AppColors.surfaceVariant.withValues(alpha: 0.4),
        selectedColor: AppColors.primaryContainer,
        secondarySelectedColor: AppColors.secondaryContainer,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        labelStyle: textTheme.labelLarge?.copyWith(color: AppColors.onSurfaceVariant),
        secondaryLabelStyle: textTheme.labelLarge?.copyWith(color: AppColors.onSecondaryContainer),
        brightness: Brightness.light,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
        ),
      );

  /// Elevated Button Theme custom styling
  static ElevatedButtonThemeData get elevatedButtonTheme => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColors.onPrimary,
          backgroundColor: AppColors.primary,
          elevation: 1.0,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          ),
        ),
      );

  /// Outlined Button Theme custom styling
  static OutlinedButtonThemeData get outlinedButtonTheme => OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.outline, width: 1.0),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          ),
        ),
      );

  /// Text Button Theme custom styling
  static TextButtonThemeData get textButtonTheme => TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          ),
        ),
      );

  /// Input Decoration Theme custom styling
  static InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant.withValues(alpha: 0.3),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: const TextStyle(color: AppColors.onSurfaceVariant),
        hintStyle: TextStyle(color: AppColors.onSurfaceVariant.withValues(alpha: 0.7)),
      );
}
