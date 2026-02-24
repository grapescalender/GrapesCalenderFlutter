import 'package:flutter/material.dart';

/// Indigo/Blue Design System Color Palette
/// Professional fintech-inspired palette (Groww-style)
class AppColors {
  AppColors._();

  // ===== PRIMARY BRAND COLORS (INDIGO) =====
  /// Primary brand color - Indigo
  /// Used for primary actions, CTAs, and brand elements
  static const Color primary = Color(0xFF3F51B5); // Colors.indigo

  /// Primary light variant - Subtle indigo background/highlight
  static const Color primaryLight = Color(0xFFE8EAF6); // Indigo 50

  /// Primary dark variant - Strong indigo for emphasis
  static const Color primaryDark = Color(0xFF283593); // Indigo 800

  /// Primary container - For filled components using primary
  static const Color primaryContainer = Color(0xFFC5CAE9); // Indigo 100

  // ===== SECONDARY BRAND COLORS (BLUE) =====
  /// Secondary color - Blue, for secondary actions and accents
  static const Color secondary = Color(0xFF2196F3); // Colors.blue
  static const Color secondaryLight = Color(0xFFE3F2FD); // Blue 50
  static const Color secondaryDark = Color(0xFF1565C0); // Blue 800

  // ===== SEMANTIC COLORS =====
  /// Success state - Green
  static const Color success = Color(0xFF2E7D32); // Material green 800
  static const Color successLight = Color(0xFFE8F5E9); // Green 50
  static const Color successDark = Color(0xFF1B5E20); // Green 900

  /// Error state - Red
  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color errorDark = Color(0xFFC62828);

  /// Warning state - Amber
  static const Color warning = Color(0xFFFFB300);
  static const Color warningLight = Color(0xFFFFF8E1);
  static const Color warningDark = Color(0xFFFF8F00);

  /// Info state - Blue (aligned with secondary)
  static const Color info = secondary;
  static const Color infoLight = secondaryLight;
  static const Color infoDark = secondaryDark;

  // ===== NEUTRAL COLORS (LIGHT MODE) =====
  /// Background - Soft bluish grey (fintech-style)
  static const Color background = Color(0xFFF5F7FA);

  /// Surface - Pure white for cards and surfaces
  static const Color surface = Color(0xFFFFFFFF);

  /// Surface variant - Slightly tinted surface for containers
  static const Color surfaceVariant = Color(0xFFF3F4F6);

  /// Outline - Subtle borders and dividers
  static const Color outline = Color(0xFFE0E0E0);
  static const Color outlineVariant = Color(0xFFEEEEEE);

  // ===== TEXT COLORS (LIGHT MODE) =====
  /// Primary text - High contrast, dark
  static const Color onBackground = Color(0xFF111827);

  /// Secondary text - Medium contrast
  static const Color onSurface = Color(0xFF1F2933);

  /// Tertiary text - Low contrast, hints
  static const Color onSurfaceVariant = Color(0xFF6B7280);

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
  static const Color shadow = Color(0x1A000000);
  static const Color darkShadow = Color(0x40000000);

  // ===== GRADIENT COLORS =====
  /// Indigo → Blue gradient for headers
  static const Color gradientStart = primary;
  static const Color gradientEnd = secondary;
}
