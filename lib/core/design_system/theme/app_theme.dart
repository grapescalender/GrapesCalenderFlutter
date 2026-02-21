import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../colors/app_colors.dart';
import '../spacing/app_spacing.dart';
import '../typography/app_typography.dart';

/// Modern App Theme Configuration
/// Light and Dark themes with Material 3 design system
/// Minimal, clean, and modern aesthetic
class AppTheme {
  AppTheme._();

  /// Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: _lightColorScheme,
      scaffoldBackgroundColor: AppColors.background,
      
      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          color: AppColors.onBackground,
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: AppSpacing.elevationSubtle,
        shadowColor: AppColors.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        margin: EdgeInsets.zero,
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.inputPaddingHorizontal,
          vertical: AppSpacing.inputPaddingVertical,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: AppColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        hintStyle: AppTypography.bodyMedium(null).copyWith(
          color: AppColors.onSurfaceVariant,
        ),
        errorStyle: AppTypography.bodySmall(null).copyWith(
          color: AppColors.error,
        ),
      ),
      
      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: AppSpacing.elevationMedium,
          padding: EdgeInsets.symmetric(
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
          foregroundColor: AppColors.primary,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingHorizontal,
            vertical: AppSpacing.buttonPaddingVertical,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          side: BorderSide(color: AppColors.primary),
          textStyle: AppTypography.labelLarge(null).copyWith(
            color: AppColors.primary,
          ),
        ),
      ),
      
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingHorizontal,
            vertical: AppSpacing.buttonPaddingVertical,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          textStyle: AppTypography.labelLarge(null).copyWith(
            color: AppColors.primary,
          ),
        ),
      ),
      
      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: AppSpacing.elevationMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
      
      // Divider
      dividerTheme: DividerThemeData(
        color: AppColors.outline,
        thickness: 1,
        space: AppSpacing.listItemSpacing,
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.onSurfaceVariant,
        selectedLabelStyle: AppTypography.labelSmall(null),
        unselectedLabelStyle: AppTypography.labelSmall(null),
        type: BottomNavigationBarType.fixed,
        elevation: AppSpacing.elevationMedium,
      ),
      
      // Icon Theme
      iconTheme: IconThemeData(
        color: AppColors.onSurface,
        size: 24,
      ),
      
      // Text Theme (using Material 3 structure)
      textTheme: _buildTextTheme(),
    );
  }

  /// Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: _darkColorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      
      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkOnBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: AppTypography.headlineLarge(null).copyWith(
          color: AppColors.darkOnBackground,
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: AppSpacing.elevationSubtle,
        shadowColor: AppColors.darkShadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        margin: EdgeInsets.zero,
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceVariant,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.inputPaddingHorizontal,
          vertical: AppSpacing.inputPaddingVertical,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: AppColors.darkOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        hintStyle: AppTypography.bodyMedium(null).copyWith(
          color: AppColors.darkOnSurfaceVariant,
        ),
        errorStyle: AppTypography.bodySmall(null).copyWith(
          color: AppColors.error,
        ),
      ),
      
      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: AppSpacing.elevationMedium,
          padding: EdgeInsets.symmetric(
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
          foregroundColor: AppColors.primary,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingHorizontal,
            vertical: AppSpacing.buttonPaddingVertical,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          side: BorderSide(color: AppColors.primary),
          textStyle: AppTypography.labelLarge(null).copyWith(
            color: AppColors.primary,
          ),
        ),
      ),
      
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingHorizontal,
            vertical: AppSpacing.buttonPaddingVertical,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          textStyle: AppTypography.labelLarge(null).copyWith(
            color: AppColors.primary,
          ),
        ),
      ),
      
      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: AppSpacing.elevationMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
      
      // Divider
      dividerTheme: DividerThemeData(
        color: AppColors.darkOutline,
        thickness: 1,
        space: AppSpacing.listItemSpacing,
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.darkOnSurfaceVariant,
        selectedLabelStyle: AppTypography.labelSmall(null),
        unselectedLabelStyle: AppTypography.labelSmall(null),
        type: BottomNavigationBarType.fixed,
        elevation: AppSpacing.elevationMedium,
      ),
      
      // Icon Theme
      iconTheme: IconThemeData(
        color: AppColors.darkOnSurface,
        size: 24,
      ),
      
      // Text Theme
      textTheme: _buildDarkTextTheme(),
    );
  }

  /// Light Color Scheme
  static ColorScheme get _lightColorScheme => ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.primaryDark,
    secondary: AppColors.primary,
    onSecondary: Colors.white,
    error: AppColors.error,
    onError: Colors.white,
    errorContainer: AppColors.errorLight,
    onErrorContainer: AppColors.errorDark,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    surfaceVariant: AppColors.surfaceVariant,
    onSurfaceVariant: AppColors.onSurfaceVariant,
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,
    shadow: AppColors.shadow,
    scrim: AppColors.scrim,
    inverseSurface: AppColors.darkSurface,
    onInverseSurface: AppColors.darkOnBackground,
  );

  /// Dark Color Scheme
  static ColorScheme get _darkColorScheme => ColorScheme.dark(
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: AppColors.primaryDark,
    onPrimaryContainer: AppColors.primaryLight,
    secondary: AppColors.primary,
    onSecondary: Colors.white,
    error: AppColors.error,
    onError: Colors.white,
    errorContainer: AppColors.errorDark,
    onErrorContainer: AppColors.errorLight,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkOnSurface,
    surfaceVariant: AppColors.darkSurfaceVariant,
    onSurfaceVariant: AppColors.darkOnSurfaceVariant,
    outline: AppColors.darkOutline,
    outlineVariant: AppColors.darkOutlineVariant,
    shadow: AppColors.darkShadow,
    scrim: AppColors.darkScrim,
    inverseSurface: AppColors.surface,
    onInverseSurface: AppColors.onBackground,
  );

  /// Build Text Theme for Light Mode
  static TextTheme _buildTextTheme() {
    return TextTheme(
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
  }

  /// Build Text Theme for Dark Mode
  static TextTheme _buildDarkTextTheme() {
    return TextTheme(
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
}
