import 'package:flutter/material.dart';

/// Indigo/Blue Design System Color Palette
/// Professional fintech-inspired palette (Groww-style)
class AppColors {
  AppColors._();
  // ===== PRIMARY BRAND COLORS (DEEP VINEYARD GREEN) =====
  /// Primary brand color - Deep Vineyard Green
  /// Used for primary actions, CTAs, and brand elements
  static const Color primary = Color(0xFF0D8A5A);

  /// Primary light variant - subtle green background/highlight
  static const Color primaryLight = Color(0xFFEFF7F1);

  /// Primary dark variant - Strong green for emphasis
  static const Color primaryDark = Color(0xFF154A33);

  /// Primary container - For filled components using primary
  static const Color primaryContainer = Color(0xFFDFF3E9);

  // ===== SECONDARY ACCENT (GRAPE PURPLE) =====
  /// Secondary Accent - Grape Purple (pairs with Vineyard Green)
  static const Color secondary = Color(0xFF5E2D7E);
  static const Color secondaryLight = Color(0xFFF3E8FB);
  static const Color secondaryDark = Color(0xFF3F1B52);

  // ===== PLOT SELECTOR / ACCENT =====
  /// Distinct color used for plot selector chips and selection affordances
  /// Muted indigo: light, professional, and provides good contrast with white text/icons.
  static const Color plotSelector = Color(0xFF5B6EA6);

  // ===== SEMANTIC COLORS =====
  /// Success state - Green (bright)
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFE8F9EE);
  static const Color successDark = Color(0xFF15863B);

  /// Error state - Red
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color errorDark = Color(0xFFC62828);

  /// Warning state - Terracotta/Alert (avoid yellow tones)
  static const Color warning = Color(0xFFEF6C57);
  static const Color warningLight = Color(0xFFFFECE9);
  static const Color warningDark = Color(0xFFB44B3F);

  /// Info state
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = secondaryLight;
  static const Color infoDark = secondaryDark;

  // ===== NEUTRAL COLORS (LIGHT MODE) =====
  /// Background - Soft neutral background matching design spec
  static const Color background = Color(0xFFF5F6F8);

  /// Surface - Pure white for cards and surfaces
  static const Color surface = Color(0xFFFFFFFF);

  /// Surface variant - Slightly tinted surface for containers
  static const Color surfaceVariant = Color(0xFFF1F6F2);

  /// Outline - Subtle borders and dividers
  static const Color outline = Color(0xFFE5E7EB);
  static const Color outlineVariant = Color(0xFFF0F2F0);

  // ===== TEXT COLORS (LIGHT MODE) =====
  /// Primary text - High contrast, dark
  static const Color onBackground = Color(0xFF1F2937);

  /// Secondary text - Medium contrast
  static const Color onSurface = Color(0xFF6B7280);

  /// Tertiary text - Low contrast, hints
  static const Color onSurfaceVariant = Color(0xFF9CA3AF);

  /// Disabled text
  static const Color onSurfaceDisabled = Color(0xFF9CA3AF);

  // ===== DARK MODE COLORS =====
  /// Dark background
  static const Color darkBackground = Color(0xFF121212);

  /// Dark surface
  static const Color darkSurface = Color(0xFF1E1E1E);

  /// Dark surface variant
  static const Color darkSurfaceVariant = Color(0xFF2C2C2C);

  /// Dark outline
  static const Color darkOutline = Color(0xFF3A3A3A);
  static const Color darkOutlineVariant = Color(0xFF2C2C2C);

  /// Dark text colors
  static const Color darkOnBackground = Color(0xFFE5E7EB);
  static const Color darkOnSurface = Color(0xFFE5E7EB);
  static const Color darkOnSurfaceVariant = Color(0xFF9CA3AF);
  static const Color darkOnSurfaceDisabled = Color(0xFF6B7280);

  // ===== INTERACTIVE COLORS =====
  /// Hover state - Subtle gray
  static const Color hover = Color(0xFFF5F5F5);
  static const Color darkHover = Color(0xFF2C2C2C);

  /// Pressed state
  static const Color pressed = Color(0xFFEEEEEE);
  static const Color darkPressed = Color(0xFF3A3A3A);

  /// Focus ring
  static const Color focus = primary;
  static const Color darkFocus = primary;

  // ===== OVERLAY COLORS =====
  /// Scrim/backdrop
  static const Color scrim = Color(0x66000000);
  static const Color darkScrim = Color(0x80000000);

  /// Shadow color
  static const Color shadow = Color(0x0F000000);
  static const Color darkShadow = Color(0x40000000);

  // ===== GRADIENT COLORS =====
  /// Vineyard Green → Grape Purple gradient for headers
  static const Color gradientStart = primary;
  static const Color gradientEnd = secondary;
}
