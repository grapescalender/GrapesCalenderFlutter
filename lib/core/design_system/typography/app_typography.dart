import 'package:flutter/material.dart';

import '../colors/app_colors.dart';

/// Application typography.
///
/// Only these seven text styles define the application's type scale.
class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Inter';

  static const double _displayLineHeight = 1.20;
  static const double _headlineLineHeight = 1.25;
  static const double _titleLineHeight = 1.30;
  static const double _bodyLineHeight = 1.45;
  static const double _labelLineHeight = 1.30;

  static TextStyle displayLarge(BuildContext? context) => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        height: _displayLineHeight,
        color: AppColors.onBackground,
      );

  static TextStyle headlineMedium(BuildContext? context) => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: _headlineLineHeight,
        color: AppColors.onBackground,
      );

  static TextStyle titleLarge(BuildContext? context) => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: _titleLineHeight,
        color: AppColors.onBackground,
      );

  static TextStyle titleMedium(BuildContext? context) => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: _titleLineHeight,
        color: AppColors.onBackground,
      );

  static TextStyle bodyLarge(BuildContext? context) => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: _bodyLineHeight,
        color: AppColors.onSurface,
      );

  static TextStyle bodyMedium(BuildContext? context) => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: _bodyLineHeight,
        color: AppColors.onSurface,
      );

  static TextStyle labelLarge(BuildContext? context) => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: _labelLineHeight,
        color: AppColors.onSurfaceVariant,
      );
}
