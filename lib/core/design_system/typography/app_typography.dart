import 'package:flutter/material.dart';
import '../colors/app_colors.dart';
import '../spacing/app_spacing.dart';

/// Modern Typography System
/// Responsive, accessible, and optimized for readability
/// Inspired by Groww's clean typography with 2026 updates
class AppTypography {
  AppTypography._();

  // ===== DISPLAY TEXT =====
  
  /// Display Large - 32px, Bold
  /// For hero sections, landing pages
  static TextStyle displayLarge(BuildContext? context) => TextStyle(
    fontSize: _responsiveSize(context, 32, 36, 40),
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
    color: AppColors.onBackground,
  );
  
  /// Display Medium - 28px, Bold
  /// For major page titles
  static TextStyle displayMedium(BuildContext? context) => TextStyle(
    fontSize: _responsiveSize(context, 28, 32, 36),
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.25,
    color: AppColors.onBackground,
  );
  
  /// Display Small - 24px, SemiBold
  /// For section headers
  static TextStyle displaySmall(BuildContext? context) => TextStyle(
    fontSize: _responsiveSize(context, 24, 28, 32),
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.3,
    color: AppColors.onBackground,
  );

  // ===== HEADLINE TEXT =====
  
  /// Headline Large - 20px, SemiBold
  /// For card titles, major sections
  static TextStyle headlineLarge(BuildContext? context) => TextStyle(
    fontSize: _responsiveSize(context, 20, 22, 24),
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.3,
    color: AppColors.onBackground,
  );
  
  /// Headline Medium - 18px, SemiBold
  /// For subsection titles
  static TextStyle headlineMedium(BuildContext? context) => TextStyle(
    fontSize: _responsiveSize(context, 18, 20, 22),
    fontWeight: FontWeight.w600,
    letterSpacing: -0.15,
    height: 1.35,
    color: AppColors.onBackground,
  );
  
  /// Headline Small - 16px, SemiBold
  /// For small section titles
  static TextStyle headlineSmall(BuildContext? context) => TextStyle(
    fontSize: _responsiveSize(context, 16, 18, 20),
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    height: 1.4,
    color: AppColors.onBackground,
  );

  // ===== TITLE TEXT =====
  
  /// Title Large - 16px, Medium
  /// For emphasized content
  static TextStyle titleLarge(BuildContext? context) => TextStyle(
    fontSize: _responsiveSize(context, 16, 18, 20),
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.4,
    color: AppColors.onBackground,
  );
  
  /// Title Medium - 14px, Medium
  /// For card subtitles
  static TextStyle titleMedium(BuildContext? context) => TextStyle(
    fontSize: _responsiveSize(context, 14, 16, 18),
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.45,
    color: AppColors.onSurface,
  );
  
  /// Title Small - 12px, Medium
  /// For small labels
  static TextStyle titleSmall(BuildContext? context) => TextStyle(
    fontSize: _responsiveSize(context, 12, 14, 16),
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.4,
    color: AppColors.onSurface,
  );

  // ===== BODY TEXT =====
  
  /// Body Large - 16px, Regular
  /// Primary body text
  static TextStyle bodyLarge(BuildContext? context) => TextStyle(
    fontSize: _responsiveSize(context, 16, 18, 20),
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.5,
    color: AppColors.onBackground,
  );
  
  /// Body Medium - 14px, Regular
  /// Standard body text (most common)
  static TextStyle bodyMedium(BuildContext? context) => TextStyle(
    fontSize: _responsiveSize(context, 14, 16, 18),
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.5,
    color: AppColors.onSurface,
  );
  
  /// Body Small - 12px, Regular
  /// Secondary body text, captions
  static TextStyle bodySmall(BuildContext? context) => TextStyle(
    fontSize: _responsiveSize(context, 12, 14, 16),
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    height: 1.45,
    color: AppColors.onSurfaceVariant,
  );

  // ===== LABEL TEXT =====
  
  /// Label Large - 14px, Medium
  /// For buttons, CTAs
  static TextStyle labelLarge(BuildContext? context) => TextStyle(
    fontSize: _responsiveSize(context, 14, 16, 18),
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.4,
    color: Colors.white,
  );
  
  /// Label Medium - 12px, Medium
  /// For tags, badges
  static TextStyle labelMedium(BuildContext? context) => TextStyle(
    fontSize: _responsiveSize(context, 12, 14, 16),
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    height: 1.35,
    color: AppColors.onSurface,
  );
  
  /// Label Small - 11px, Medium
  /// For small tags, overlines
  static TextStyle labelSmall(BuildContext? context) => TextStyle(
    fontSize: _responsiveSize(context, 11, 12, 14),
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4,
    height: 1.3,
    color: AppColors.onSurfaceVariant,
  );

  // ===== UTILITY METHODS =====
  
  /// Responsive text size based on screen width
  /// Returns different sizes for mobile, tablet, desktop
  static double _responsiveSize(
    BuildContext? context,
    double mobile,
    double tablet,
    double desktop,
  ) {
    if (context == null) return mobile; // Default to mobile size when no context
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return desktop;
    if (width >= 600) return tablet;
    return mobile;
  }
  
  /// Get text style with custom color
  static TextStyle withColor(TextStyle style, Color color) => style.copyWith(color: color);
  
  /// Get text style with custom weight
  static TextStyle withWeight(TextStyle style, FontWeight weight) => style.copyWith(fontWeight: weight);
}
