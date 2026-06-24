import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Groww-Inspired Typography System
/// Focuses on clarity, hierarchy, and readability for farming data
class AppTextStyles {
  AppTextStyles._(); // Private constructor

  // ===== HEADING STYLES =====

  /// Page title - Large, bold, primary text
  /// Used for main page headers (Home, Schedule, etc.)
  /// Size: 18, Weight: 800 (ExtraBold)
  static const TextStyle heading1 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    letterSpacing: 0,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// Section title - Medium-large, bold, primary text
  /// Used for major sections within a page
  /// Size: 15, Weight: 800 (ExtraBold)
  static const TextStyle heading2 = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w800,
    letterSpacing: 0,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// Subsection title - Medium, semibold, primary text
  /// Used for smaller sections, card titles
  /// Size: 14, Weight: 800 (ExtraBold)
  static const TextStyle heading3 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    letterSpacing: 0,
    color: AppColors.textPrimary,
    height: 1.35,
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
  /// Size: 11, Weight: 700 (Bold)
  static const TextStyle labelMedium = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// Label text - Small and bold
  /// Used for minimal labels, tags
  /// Size: 10, Weight: 700 (Bold)
  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
    color: AppColors.textSecondary,
    height: 1.2,
  );

  // ===== SPECIAL STYLES =====

  /// Call-to-action text - Button text
  /// Size: 13, Weight: 700 (Bold)
  static const TextStyle button = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    color: Colors.white,
    height: 1.4,
  );

  /// Highlighted/emphasized text
  /// For important numbers or data points
  /// Size: 14, Weight: 800 (ExtraBold)
  static const TextStyle highlight = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    letterSpacing: 0,
    color: AppColors.primaryGreen,
    height: 1.4,
  );

  /// Large data point - For metrics, numbers
  /// E.g., plot area, days since pruning
  /// Size: 14, Weight: 800 (ExtraBold)
  static const TextStyle dataLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    letterSpacing: 0,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  /// Medium data point - Secondary metrics
  /// Size: 13, Weight: 700 (Bold)
  static const TextStyle dataMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // ===== UTILITY METHODS =====

  /// Get text style with custom color override
  static TextStyle withColor(TextStyle style, Color color) =>
      style.copyWith(color: color);

  /// Get text style with custom size override
  static TextStyle withSize(TextStyle style, double fontSize) =>
      style.copyWith(fontSize: fontSize);

  /// Get text style with custom weight override
  static TextStyle withWeight(TextStyle style, FontWeight fontWeight) =>
      style.copyWith(fontWeight: fontWeight);

  static const TextStyle screenTitle = heading1;
  static const TextStyle sectionTitle = heading2;
  static const TextStyle cardTitle = heading3;
  static const TextStyle cardSubtitle = bodySmall;
  static const TextStyle listItemTitle = bodyMedium;
  static const TextStyle listItemBody = bodySmall;
  static const TextStyle listItemMeta = labelSmall;
  static const TextStyle listItemEmphasis = bodySmall;
  static const TextStyle body = bodyMedium;
  static const TextStyle caption = labelSmall;
  static const TextStyle metricValue = dataLarge;
  static const TextStyle metricLabel = labelSmall;
  static const TextStyle chipText = labelSmall;
  static const TextStyle buttonText = button;
  static const TextStyle formLabel = labelMedium;
  static const TextStyle formValue = bodyMedium;
  static const TextStyle errorText = bodySmall;
}
