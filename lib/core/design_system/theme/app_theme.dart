import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../colors/app_colors.dart';
import '../spacing/app_spacing.dart';
import '../typography/app_typography.dart';
import 'app_semantic_colors.dart';
import 'app_branding.dart';
import 'app_status_colors.dart';
import 'activity_stepper_theme.dart';

/// Modern App Theme Configuration (Material 3)
/// Indigo/Blue fintech-inspired light & dark themes
class AppTheme {
  AppTheme._();

  /// Light Theme
  static ThemeData get lightTheme {
    final colorScheme = _lightColorScheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      fontFamily: AppTypography.fontFamily,
      scaffoldBackgroundColor: AppColors.background,
      extensions: <ThemeExtension<dynamic>>[
        AppSemanticColors.light,
        AppStatusColors.light,
        const AppBranding(
          gradientStart: AppColors.gradientStart,
          gradientEnd: AppColors.gradientEnd,
        ),
        ActivityStepperTheme.light(colorScheme),
      ],

      // App Bar - minimal, surface/transparent background
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        titleTextStyle: AppTypography.titleLarge(null).copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card Theme - compact radius and very soft shadow
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 1,
        shadowColor: colorScheme.shadow.withOpacity(0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.inputPaddingHorizontal,
          vertical: AppSpacing.inputPaddingVertical,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        hintStyle: AppTypography.bodyMedium(null).copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        errorStyle: AppTypography.bodySmall(null).copyWith(
          color: colorScheme.error,
        ),
      ),

      // Elevated Button - primary indigo
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingHorizontal,
            vertical: AppSpacing.buttonPaddingVertical,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          textStyle: AppTypography.labelLarge(null),
        ),
      ),

      // Outlined Button - primary outline
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingHorizontal,
            vertical: AppSpacing.buttonPaddingVertical,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          side: BorderSide(color: colorScheme.primary),
          textStyle: AppTypography.labelLarge(null).copyWith(
            color: colorScheme.primary,
          ),
        ),
      ),

      // Text Button - indigo text
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingHorizontal,
            vertical: AppSpacing.buttonPaddingVertical,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          textStyle: AppTypography.labelLarge(null).copyWith(
            color: colorScheme.primary,
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: AppSpacing.listItemSpacing,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        selectedLabelStyle: AppTypography.labelSmall(null),
        unselectedLabelStyle: AppTypography.labelSmall(null),
        type: BottomNavigationBarType.fixed,
        elevation: 2,
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: 24,
      ),

      // Text Theme (Material 3 structure)
      textTheme: _buildTextTheme(),
    );
  }

  /// Dark Theme
  static ThemeData get darkTheme {
    final colorScheme = _darkColorScheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      fontFamily: AppTypography.fontFamily,
      scaffoldBackgroundColor: AppColors.darkBackground,
      extensions: <ThemeExtension<dynamic>>[
        AppSemanticColors.dark,
        AppStatusColors.dark,
        const AppBranding(
          gradientStart: AppColors.primaryDark,
          gradientEnd: AppColors.gradientEnd,
        ),
        ActivityStepperTheme.dark(colorScheme),
      ],

      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        titleTextStyle: AppTypography.titleLarge(null).copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 1,
        shadowColor: colorScheme.shadow.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.inputPaddingHorizontal,
          vertical: AppSpacing.inputPaddingVertical,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        hintStyle: AppTypography.bodyMedium(null).copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        errorStyle: AppTypography.bodySmall(null).copyWith(
          color: colorScheme.error,
        ),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingHorizontal,
            vertical: AppSpacing.buttonPaddingVertical,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          textStyle: AppTypography.labelLarge(null),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingHorizontal,
            vertical: AppSpacing.buttonPaddingVertical,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          side: BorderSide(color: colorScheme.primary),
          textStyle: AppTypography.labelLarge(null).copyWith(
            color: colorScheme.primary,
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingHorizontal,
            vertical: AppSpacing.buttonPaddingVertical,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          textStyle: AppTypography.labelLarge(null).copyWith(
            color: colorScheme.primary,
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: AppSpacing.listItemSpacing,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        selectedLabelStyle: AppTypography.labelSmall(null),
        unselectedLabelStyle: AppTypography.labelSmall(null),
        type: BottomNavigationBarType.fixed,
        elevation: 2,
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: 24,
      ),

      // Text Theme
      textTheme: _buildDarkTextTheme(),
    );
  }

  /// Light Color Scheme (Material 3, from seed)
  static ColorScheme get _lightColorScheme =>
      ColorScheme.fromSeed(seedColor: AppColors.primary).copyWith(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.secondaryContainer,
        tertiary: AppColors.tertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        surface: AppColors.surface,
        surfaceContainerHighest: AppColors.surfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        error: AppColors.error,
        shadow: AppColors.shadow,
      );

  /// Dark Color Scheme (Material 3, from seed)
  static ColorScheme get _darkColorScheme =>
      ColorScheme.fromSeed(seedColor: AppColors.primary, brightness: Brightness.dark).copyWith(
        primary: AppColors.primaryLight,
        onPrimary: AppColors.primaryDark,
        primaryContainer: AppColors.primaryDark,
        secondary: AppColors.secondary,
        secondaryContainer: AppColors.secondaryDark,
        surface: AppColors.darkSurface,
        surfaceContainerHighest: AppColors.darkSurfaceVariant,
        outline: AppColors.darkOutline,
        outlineVariant: AppColors.darkOutlineVariant,
        error: AppColors.error,
        shadow: AppColors.darkShadow,
      );

  /// Build Text Theme for Light Mode
  static TextTheme _buildTextTheme() => TextTheme(
      displayLarge: AppTypography.displayLarge(null),
      displayMedium: AppTypography.displayMedium(null),
      displaySmall: AppTypography.displaySmall(null),
      headlineLarge: AppTypography.headlineLarge(null),
      headlineMedium: AppTypography.headlineMedium(null),
      headlineSmall: AppTypography.headlineSmall(null),
      titleLarge: AppTypography.titleLarge(null),
      titleMedium: AppTypography.titleMedium(null),
      titleSmall: AppTypography.titleSmall(null),
      bodyLarge: AppTypography.bodyLarge(null),
      bodyMedium: AppTypography.bodyMedium(null),
      bodySmall: AppTypography.bodySmall(null),
      labelLarge: AppTypography.labelLarge(null),
      labelMedium: AppTypography.labelMedium(null),
      labelSmall: AppTypography.labelSmall(null),
    );

  /// Build Text Theme for Dark Mode
  static TextTheme _buildDarkTextTheme() => TextTheme(
      displayLarge: AppTypography.displayLarge(null).copyWith(
        color: AppColors.darkOnBackground,
      ),
      displayMedium: AppTypography.displayMedium(null).copyWith(
        color: AppColors.darkOnBackground,
      ),
      displaySmall: AppTypography.displaySmall(null).copyWith(
        color: AppColors.darkOnBackground,
      ),
      headlineLarge: AppTypography.headlineLarge(null).copyWith(
        color: AppColors.darkOnBackground,
      ),
      headlineMedium: AppTypography.headlineMedium(null).copyWith(
        color: AppColors.darkOnBackground,
      ),
      headlineSmall: AppTypography.headlineSmall(null).copyWith(
        color: AppColors.darkOnBackground,
      ),
      titleLarge: AppTypography.titleLarge(null).copyWith(
        color: AppColors.darkOnSurface,
      ),
      titleMedium: AppTypography.titleMedium(null).copyWith(
        color: AppColors.darkOnSurface,
      ),
      titleSmall: AppTypography.titleSmall(null).copyWith(
        color: AppColors.darkOnSurfaceVariant,
      ),
      bodyLarge: AppTypography.bodyLarge(null).copyWith(
        color: AppColors.darkOnSurface,
      ),
      bodyMedium: AppTypography.bodyMedium(null).copyWith(
        color: AppColors.darkOnSurface,
      ),
      bodySmall: AppTypography.bodySmall(null).copyWith(
        color: AppColors.darkOnSurfaceVariant,
      ),
      labelLarge: AppTypography.labelLarge(null),
      labelMedium: AppTypography.labelMedium(null).copyWith(
        color: AppColors.darkOnSurface,
      ),
      labelSmall: AppTypography.labelSmall(null).copyWith(
        color: AppColors.darkOnSurfaceVariant,
      ),
    );
}
