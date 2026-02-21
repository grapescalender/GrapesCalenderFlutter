import 'package:flutter/material.dart';

/// Modern Design System Color Palette
/// Inspired by Groww's minimal fintech aesthetic, updated for 2026
/// Clean, trustworthy, and modern color system
class AppColors {
  AppColors._();

  // ===== PRIMARY BRAND COLORS =====
  /// Primary brand color - Modern emerald green
  /// Used for primary actions, CTAs, and brand elements
  static const Color primary = Color(0xFF00C853); // Vibrant emerald
  
  /// Primary light variant - For backgrounds and subtle highlights
  static const Color primaryLight = Color(0xFFE8F5E9);
  
  /// Primary dark variant - For hover states and emphasis
  static const Color primaryDark = Color(0xFF00A043);
  
  /// Primary container - Subtle background for primary elements
  static const Color primaryContainer = Color(0xFFC8E6C9);

  // ===== SEMANTIC COLORS =====
  /// Success state - Green
  static const Color success = Color(0xFF00C853);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color successDark = Color(0xFF00A043);
  
  /// Error state - Red
  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color errorDark = Color(0xFFC62828);
  
  /// Warning state - Amber
  static const Color warning = Color(0xFFFFB300);
  static const Color warningLight = Color(0xFFFFF8E1);
  static const Color warningDark = Color(0xFFFF8F00);
  
  /// Info state - Blue
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFFE3F2FD);
  static const Color infoDark = Color(0xFF1976D2);

  // ===== NEUTRAL COLORS (Light Mode) =====
  /// Background - Pure white
  static const Color background = Color(0xFFFFFFFF);
  
  /// Surface - Slightly off-white for cards
  static const Color surface = Color(0xFFFAFAFA);
  
  /// Surface variant - For elevated surfaces
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  
  /// Outline - Borders and dividers
  static const Color outline = Color(0xFFE0E0E0);
  static const Color outlineVariant = Color(0xFFEEEEEE);

  // ===== TEXT COLORS (Light Mode) =====
  /// Primary text - High contrast, dark
  static const Color onBackground = Color(0xFF1A1A1A);
  
  /// Secondary text - Medium contrast
  static const Color onSurface = Color(0xFF424242);
  
  /// Tertiary text - Low contrast, hints
  static const Color onSurfaceVariant = Color(0xFF757575);
  
  /// Disabled text
  static const Color onSurfaceDisabled = Color(0xFFBDBDBD);

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
  static const Color darkOnBackground = Color(0xFFE0E0E0);
  static const Color darkOnSurface = Color(0xFFBDBDBD);
  static const Color darkOnSurfaceVariant = Color(0xFF9E9E9E);
  static const Color darkOnSurfaceDisabled = Color(0xFF616161);

  // ===== INTERACTIVE COLORS =====
  /// Hover state - Subtle gray
  static const Color hover = Color(0xFFF5F5F5);
  static const Color darkHover = Color(0xFF2C2C2C);
  
  /// Pressed state
  static const Color pressed = Color(0xFFEEEEEE);
  static const Color darkPressed = Color(0xFF3A3A3A);
  
  /// Focus ring
  static const Color focus = Color(0xFF00C853);
  static const Color darkFocus = Color(0xFF00C853);

  // ===== OVERLAY COLORS =====
  /// Scrim/backdrop
  static const Color scrim = Color(0x66000000);
  static const Color darkScrim = Color(0x80000000);
  
  /// Shadow color
  static const Color shadow = Color(0x1A000000);
  static const Color darkShadow = Color(0x40000000);

  // ===== GRADIENT COLORS =====
  /// Primary gradient start
  static const Color gradientStart = Color(0xFF00C853);
  
  /// Primary gradient end
  static const Color gradientEnd = Color(0xFF00A043);
}
