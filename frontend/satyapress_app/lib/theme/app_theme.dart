import 'package:flutter/material.dart';

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

/// AppTheme defines the Material 3 light and dark themes for the application.
class AppTheme {
  AppTheme._();

  static ColorScheme get _lightColorScheme => const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFF2563EB),
        onPrimary: Color(0xFFFFFFFF),
        primaryContainer: Color(0xFFDBEAFE),
        onPrimaryContainer: Color(0xFF1E40AF),
        secondary: Color(0xFF475569),
        onSecondary: Color(0xFFFFFFFF),
        secondaryContainer: Color(0xFFF1F5F9),
        onSecondaryContainer: Color(0xFF0F172A),
        tertiary: Color(0xFF0F766E),
        onTertiary: Color(0xFFFFFFFF),
        tertiaryContainer: Color(0xFFCCFBF1),
        onTertiaryContainer: Color(0xFF115E59),
        error: Color(0xFFEF4444),
        onError: Color(0xFFFFFFFF),
        errorContainer: Color(0xFFFEE2E2),
        onErrorContainer: Color(0xFF991B1B),
        surface: Color(0xFFF8FAFC),
        onSurface: Color(0xFF1E293B),
        surfaceContainerHighest: Color(0xFFE2E8F0),
        onSurfaceVariant: Color(0xFF475569),
        outline: Color(0xFF94A3B8),
        outlineVariant: Color(0xFFE2E8F0),
        shadow: Color(0xFF000000),
        scrim: Color(0xFF000000),
        inverseSurface: Color(0xFF0F172A),
        onInverseSurface: Color(0xFFF8FAFC),
        inversePrimary: Color(0xFF60A5FA),
      );

  static ColorScheme get _darkColorScheme => const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFF63B3ED),
        onPrimary: Color(0xFF0D1117),
        primaryContainer: Color(0xFF1E3A8A),
        onPrimaryContainer: Color(0xFF93C5FD),
        secondary: Color(0xFF94A3B8),
        onSecondary: Color(0xFF0F172A),
        secondaryContainer: Color(0xFF334155),
        onSecondaryContainer: Color(0xFFF1F5F9),
        tertiary: Color(0xFF2DD4BF),
        onTertiary: Color(0xFF0D1117),
        tertiaryContainer: Color(0xFF115E59),
        onTertiaryContainer: Color(0xFFCCFBF1),
        error: Color(0xFFF87171),
        onError: Color(0xFF7F1D1D),
        errorContainer: Color(0xFF991B1B),
        onErrorContainer: Color(0xFFFEE2E2),
        surface: Color(0xFF0D1117),
        onSurface: Color(0xFFE2E8F0),
        surfaceContainerHighest: Color(0xFF1E293B),
        onSurfaceVariant: Color(0xFF94A3B8),
        outline: Color(0xFF475569),
        outlineVariant: Color(0xFF334155),
        shadow: Color(0xFF000000),
        scrim: Color(0xFF000000),
        inverseSurface: Color(0xFFF8FAFC),
        onInverseSurface: Color(0xFF0D1117),
        inversePrimary: Color(0xFF2563EB),
      );

  /// Light theme definition
  static ThemeData get lightTheme {
    final colors = _lightColorScheme;
    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: colors.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        elevation: 0,
        titleTextStyle: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w800,
          color: Color(0xFF0F172A),
          letterSpacing: 0.3,
        ),
        iconTheme: IconThemeData(color: colors.primary),
      ),
      navigationBarTheme: _getNavigationBarTheme(colors),
      cardTheme: _getCardTheme(colors),
      chipTheme: _getChipTheme(colors),
      elevatedButtonTheme: _getElevatedButtonTheme(colors),
      outlinedButtonTheme: _getOutlinedButtonTheme(colors),
      textButtonTheme: _getTextButtonTheme(colors),
      inputDecorationTheme: _getInputDecorationTheme(colors),
    );
  }

  /// Dark theme definition
  static ThemeData get darkTheme {
    final colors = _darkColorScheme;
    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: colors.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        elevation: 0,
        titleTextStyle: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w800,
          color: Color(0xFFF8FAFC),
          letterSpacing: 0.3,
        ),
        iconTheme: IconThemeData(color: colors.primary),
      ),
      navigationBarTheme: _getNavigationBarTheme(colors),
      cardTheme: _getCardTheme(colors),
      chipTheme: _getChipTheme(colors),
      elevatedButtonTheme: _getElevatedButtonTheme(colors),
      outlinedButtonTheme: _getOutlinedButtonTheme(colors),
      textButtonTheme: _getTextButtonTheme(colors),
      inputDecorationTheme: _getInputDecorationTheme(colors),
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
  static CardThemeData _getCardTheme(ColorScheme colors) => CardThemeData(
        color: colors.brightness == Brightness.light ? Colors.white : colors.surfaceContainerHighest,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          side: BorderSide(color: colors.outlineVariant, width: 1.0),
        ),
        margin: const EdgeInsets.all(AppSpacing.sm),
      );

  /// Chip Theme custom styling
  static ChipThemeData _getChipTheme(ColorScheme colors) => ChipThemeData(
        backgroundColor: colors.surfaceContainerHighest,
        disabledColor: colors.surfaceContainerHighest.withValues(alpha: 0.4),
        selectedColor: colors.primaryContainer,
        secondarySelectedColor: colors.secondaryContainer,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        labelStyle: textTheme.labelLarge?.copyWith(color: colors.onSurfaceVariant),
        secondaryLabelStyle: textTheme.labelLarge?.copyWith(color: colors.onSecondaryContainer),
        brightness: colors.brightness,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
        ),
      );

  /// Elevated Button Theme custom styling
  static ElevatedButtonThemeData _getElevatedButtonTheme(ColorScheme colors) => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: colors.onPrimary,
          backgroundColor: colors.primary,
          elevation: 1.0,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          ),
        ),
      );

  /// Outlined Button Theme custom styling
  static OutlinedButtonThemeData _getOutlinedButtonTheme(ColorScheme colors) => OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          side: BorderSide(color: colors.outline, width: 1.0),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          ),
        ),
      );

  /// Text Button Theme custom styling
  static TextButtonThemeData _getTextButtonTheme(ColorScheme colors) => TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          ),
        ),
      );

  /// Input Decoration Theme custom styling
  static InputDecorationTheme _getInputDecorationTheme(ColorScheme colors) => InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceContainerHighest.withValues(alpha: 0.3),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          borderSide: BorderSide(color: colors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          borderSide: BorderSide(color: colors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          borderSide: BorderSide(color: colors.primary, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          borderSide: BorderSide(color: colors.error),
        ),
        labelStyle: TextStyle(color: colors.onSurfaceVariant),
        hintStyle: TextStyle(color: colors.onSurfaceVariant.withValues(alpha: 0.7)),
      );

  static NavigationBarThemeData _getNavigationBarTheme(ColorScheme colors) {
    final isLight = colors.brightness == Brightness.light;
    final Color activeColor = isLight ? const Color(0xFF2563EB) : const Color(0xFF63B3ED);
    final Color inactiveColor = isLight ? const Color(0xFF64748B) : const Color(0xFF94A3B8);
    final Color navBgColor = isLight ? Colors.white : const Color(0xFF1E293B);

    return NavigationBarThemeData(
      backgroundColor: navBgColor,
      elevation: 8.0,
      shadowColor: colors.shadow,
      indicatorColor: activeColor.withValues(alpha: 0.1),
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: activeColor,
          );
        }
        return TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
          color: inactiveColor,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(
            size: 24.0,
            color: activeColor,
          );
        }
        return IconThemeData(
          size: 24.0,
          color: inactiveColor,
        );
      }),
    );
  }
}
