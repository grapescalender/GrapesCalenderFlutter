import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_spacing.dart';

/// Application Theme Configuration
/// Implements Material 3 design system inspired by Groww's minimal fintech style
/// Adapted for farming context with clean, trustworthy design
class AppTheme {
  AppTheme._(); // Private constructor

  /// Light theme (default)
  /// Clean, minimal design with soft green accent
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
          primary: AppColors.primaryGreen,
          secondary: AppColors.primaryGreen,
          tertiary: AppColors.primaryGreen,
          surface: AppColors.backgroundWhite,
          background: AppColors.backgroundLight,
          error: AppColors.errorRed,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: AppColors.textPrimary,
          onSurface: AppColors.textPrimary,
        ),
        scaffoldBackgroundColor: AppColors.backgroundLight,
        // App Bar styling - minimal and clean
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.backgroundWhite,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.textPrimary,
          ),
          scrolledUnderElevation: 0,
        ),
        // Card styling - subtle elevation, rounded corners
        cardTheme: CardThemeData(
          color: AppColors.backgroundWhite,
          elevation: AppSpacing.elevationSubtle,
          shadowColor: AppColors.shadowColor.withOpacity(0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
          margin: EdgeInsets.zero,
        ),
        // Input field styling
        inputDecorationTheme: _buildInputDecorationTheme(),
        // Floating action button
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          elevation: AppSpacing.elevationMedium,
        ),
        // Text theme using centralized text styles
        textTheme: _buildTextTheme(),
        // Divider styling
        dividerTheme: DividerThemeData(
          color: AppColors.dividerLight,
          thickness: 1,
          space: AppSpacing.listItemSpacing,
        ),
      );

  /// Dark theme
  /// Maintains minimal design with adjusted colors for dark mode
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: AppColors.primaryGreen,
          secondary: AppColors.primaryGreen,
          tertiary: AppColors.primaryGreen,
          surface: AppColors.darkSurface,
          background: AppColors.darkBackground,
          error: AppColors.errorRed,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: AppColors.darkTextPrimary,
          onSurface: AppColors.darkTextPrimary,
        ),
        scaffoldBackgroundColor: AppColors.darkBackground,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.darkSurface,
          foregroundColor: AppColors.darkTextPrimary,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.darkTextPrimary,
          ),
          scrolledUnderElevation: 0,
        ),
        cardTheme: CardThemeData(
          color: AppColors.darkSurface,
          elevation: AppSpacing.elevationSubtle,
          shadowColor: Colors.black.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
          margin: EdgeInsets.zero,
        ),
        inputDecorationTheme: _buildInputDecorationThemeDark(),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          elevation: AppSpacing.elevationMedium,
        ),
        textTheme: _buildTextThemeDark(),
        dividerTheme: DividerThemeData(
          color: AppColors.textTertiary.withOpacity(0.2),
          thickness: 1,
          space: AppSpacing.listItemSpacing,
        ),
      );

  /// Build input decoration theme for light mode
  static InputDecorationTheme _buildInputDecorationTheme() =>
      InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.smMd,
        ),
        filled: true,
        fillColor: AppColors.backgroundLightGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          borderSide: BorderSide(
            color: AppColors.primaryGreen,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          borderSide: BorderSide(color: AppColors.errorRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          borderSide: BorderSide(color: AppColors.errorRed, width: 2),
        ),
        hintStyle: AppTextStyles.bodyMedium,
        errorStyle: AppTextStyles.labelLarge.copyWith(
          color: AppColors.errorRed,
        ),
      );

  /// Build input decoration theme for dark mode
  static InputDecorationTheme _buildInputDecorationThemeDark() =>
      InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.smMd,
        ),
        filled: true,
        fillColor: AppColors.darkTextSecondary.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          borderSide: BorderSide(
            color: AppColors.darkTextSecondary.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          borderSide: BorderSide(
            color: AppColors.primaryGreen,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          borderSide: BorderSide(color: AppColors.errorRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          borderSide: BorderSide(color: AppColors.errorRed, width: 2),
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.darkTextSecondary.withOpacity(0.7),
        ),
        errorStyle: AppTextStyles.labelLarge.copyWith(
          color: AppColors.errorRed,
        ),
      );

  /// Build Material 3 text theme for light mode
  static TextTheme _buildTextTheme() => TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayLarge,
        displaySmall: AppTextStyles.titleLarge,
        headlineLarge: AppTextStyles.headlineMedium,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.titleLarge,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.labelLarge,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.labelLarge,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelLarge,
        labelSmall: AppTextStyles.labelLarge,
      );

  /// Build Material 3 text theme for dark mode
  static TextTheme _buildTextThemeDark() => TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        displayMedium: AppTextStyles.displayLarge.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        displaySmall: AppTextStyles.titleLarge.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        headlineLarge: AppTextStyles.headlineMedium.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        headlineSmall: AppTextStyles.titleLarge.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        titleLarge: AppTextStyles.titleLarge.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        titleMedium: AppTextStyles.titleMedium.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        titleSmall: AppTextStyles.labelLarge.copyWith(
          color: AppColors.darkTextSecondary,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.darkTextSecondary,
        ),
        bodySmall: AppTextStyles.labelLarge.copyWith(
          color: AppColors.darkTextSecondary.withOpacity(0.8),
        ),
        labelLarge: AppTextStyles.labelLarge.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        labelMedium: AppTextStyles.labelLarge.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        labelSmall: AppTextStyles.labelLarge.copyWith(
          color: AppColors.darkTextSecondary,
        ),
      );
}
