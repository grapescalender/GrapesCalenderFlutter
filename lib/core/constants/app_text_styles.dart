import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Groww-Inspired Typography System
/// Focuses on clarity, hierarchy, and readability for farming data
class AppTextStyles {
  AppTextStyles._(); // Private constructor

  // ===== HEADING STYLES =====
  
  /// Page title - Large, bold, primary text
  /// Used for main page headers (Home, Schedule, etc.)
  /// Size: 28, Weight: 700 (Bold)
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  /// Section title - Medium-large, bold, primary text
  /// Used for major sections within a page
  /// Size: 20, Weight: 600 (SemiBold)
  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// Subsection title - Medium, semibold, primary text
  /// Used for smaller sections, card titles
  /// Size: 16, Weight: 600 (SemiBold)
  static const TextStyle heading3 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.15,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ===== BODY TEXT STYLES =====

  /// Body text - Primary content - Regular size
  /// Main readable content for information
  /// Size: 14, Weight: 400 (Regular)
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// Body text - Secondary content - Small size
  /// Supporting information, descriptions
  /// Size: 13, Weight: 400 (Regular)
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  /// Body text - Tertiary content - Small size
  /// Meta information, timestamps, hints
  /// Size: 12, Weight: 400 (Regular)
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    color: AppColors.textTertiary,
    height: 1.4,
  );

  // ===== LABEL/TAG STYLES =====

  /// Label text - Bold small text
  /// Used for labels, badges, status indicators
  /// Size: 12, Weight: 600 (SemiBold)
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// Label text - Small and bold
  /// Used for minimal labels, tags
  /// Size: 11, Weight: 600 (SemiBold)
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppColors.textSecondary,
    height: 1.2,
  );

  // ===== SPECIAL STYLES =====

  /// Call-to-action text - Button text
  /// Size: 14, Weight: 600 (SemiBold)
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: Colors.white,
    height: 1.4,
  );

  /// Highlighted/emphasized text
  /// For important numbers or data points
  /// Size: 16, Weight: 700 (Bold)
  static const TextStyle highlight = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    color: AppColors.primaryGreen,
    height: 1.4,
  );

  /// Large data point - For metrics, numbers
  /// E.g., plot area, days since pruning
  /// Size: 24, Weight: 700 (Bold)
  static const TextStyle dataLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -1,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  /// Medium data point - Secondary metrics
  /// Size: 18, Weight: 600 (SemiBold)
  static const TextStyle dataMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // ===== UTILITY METHODS =====

  /// Get text style with custom color override
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Get text style with custom size override
  static TextStyle withSize(TextStyle style, double fontSize) {
    return style.copyWith(fontSize: fontSize);
  }

  /// Get text style with custom weight override
  static TextStyle withWeight(TextStyle style, FontWeight fontWeight) {
    return style.copyWith(fontWeight: fontWeight);
  }
}
