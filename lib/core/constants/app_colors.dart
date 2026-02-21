import 'package:flutter/material.dart';

/// Groww-Inspired Farming App Color System
/// Minimal fintech aesthetic with farming green accent
class AppColors {
  AppColors._(); // Private constructor

  // ===== PRIMARY COLORS =====
  /// Soft, trustworthy green - primary action color
  static const Color primaryGreen = Color(0xFF10B981);
  
  /// Lighter green for hover/secondary states
  static const Color primaryGreenLight = Color(0xFFD1FAE5);
  
  /// Darker green for emphasis/active states
  static const Color primaryGreenDark = Color(0xFF047857);

  // ===== ACCENT COLORS =====
  /// Warm accent for highlights (optional, rarely used)
  static const Color accentOrange = Color(0xFFF59E0B);
  
  /// Status/warning color
  static const Color warningYellow = Color(0xFFFCD34D);
  
  /// Error/alert color
  static const Color errorRed = Color(0xFFEF4444);
  
  /// Success indicator
  static const Color successGreen = Color(0xFF22C55E);

  // ===== BACKGROUND COLORS =====
  /// Main app background - crisp white
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  
  /// Secondary background for sections
  static const Color backgroundLight = Color(0xFFF9FAFB);
  
  /// Very subtle gray for hover states
  static const Color backgroundLightGray = Color(0xFFF3F4F6);
  
  /// Slightly darker for inactive elements
  static const Color backgroundGray = Color(0xFFE5E7EB);

  // ===== TEXT COLORS =====
  /// Primary text - high contrast, dark
  static const Color textPrimary = Color(0xFF111827);
  
  /// Secondary text - for descriptions, meta info
  static const Color textSecondary = Color(0xFF6B7280);
  
  /// Tertiary text - placeholder, disabled
  static const Color textTertiary = Color(0xFF9CA3AF);
  
  /// Disabled/muted state
  static const Color textDisabled = Color(0xFFD1D5DB);

  // ===== DIVIDER/BORDER COLORS =====
  /// Subtle line dividers
  static const Color dividerLight = Color(0xFFE5E7EB);
  
  /// Slightly more prominent dividers
  static const Color dividerMedium = Color(0xFFD1D5DB);
  
  /// Card borders
  static const Color borderColor = Color(0xFFE5E7EB);

  // ===== SPECIAL COLORS =====
  /// Overlay/scrim color for modals
  static const Color scrimColor = Color(0xFF000000);
  
  /// Shadow color (used with elevation)
  static const Color shadowColor = Color(0xFF000000);

  // ===== DARK MODE COLORS =====
  /// Dark mode background
  static const Color darkBackground = Color(0xFF0F172A);
  
  /// Dark mode card surface
  static const Color darkSurface = Color(0xFF1E293B);
  
  /// Dark mode text primary
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  
  /// Dark mode text secondary
  static const Color darkTextSecondary = Color(0xFFCBD5E1);

  // ===== FARMING CONTEXT SPECIFIC =====
  /// Plot/field active state
  static const Color plotActive = Color(0xFF10B981);
  
  /// Plot/field inactive state
  static const Color plotInactive = Color(0xFFD1D5DB);
  
  /// Scheduling - urgency indicator (soon due)
  static const Color scheduleUrgent = Color(0xFFF59E0B);
  
  /// Scheduling - overdue
  static const Color scheduleOverdue = Color(0xFFEF4444);
  
  /// Scheduling - completed
  static const Color scheduleCompleted = Color(0xFF10B981);
}
