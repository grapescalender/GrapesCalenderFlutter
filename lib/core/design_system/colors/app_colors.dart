import 'package:flutter/material.dart';

/// AgriTech SaaS Design System — Color Palette 2026
///
/// Trend direction: Forest + Sage + Warm Stone
/// Inspired by: Linear, Vercel, Notion applied to AgriTech
/// Feeling: Premium · Outdoor-ready · Modern SaaS · Farmer-friendly
///
/// Usage rule: NEVER hardcode Color(0x…) in widgets.
///             ALWAYS reference an AppColors token.
class AppColors {
  AppColors._();

  // ═══════════════════════════════════════════════════════════════
  // PRIMARY — Forest Teal Green
  // Trending: rich, deep green with a teal undertone
  // Inspired by Figma's 2026 AgriTech color direction
  // ═══════════════════════════════════════════════════════════════

  /// #0E7C6B — Forest Teal: sophisticated, outdoor-premium
  static const Color primary = Color(0xFF0E7C6B);

  /// #14A08A — lighter teal, used for hover / active states
  static const Color primaryLight = Color(0xFF14A08A);

  /// #085447 — deep forest, used for dark mode / pressed
  static const Color primaryDark = Color(0xFF085447);

  /// #C8EDE8 — soft teal tint for container fills
  static const Color primaryContainer = Color(0xFFC8EDE8);

  /// #085447 — on-container text / icon
  static const Color onPrimaryContainer = Color(0xFF085447);

  // ═══════════════════════════════════════════════════════════════
  // SECONDARY — Terracotta Clay
  // Trending: earthy, warm accent replacing flat amber
  // Used for: highlights, schedule chips, market data
  // ═══════════════════════════════════════════════════════════════

  /// #C2622A — warm terracotta, earthy & premium
  static const Color secondary = Color(0xFFC2622A);

  static const Color secondaryLight = Color(0xFFFAE0D4);
  static const Color secondaryDark = Color(0xFF8B3E18);
  static const Color secondaryContainer = Color(0xFFF5C4A8);

  // ═══════════════════════════════════════════════════════════════
  // TERTIARY — Sage Olive
  // Trending: muted olive for decorative accents, charts
  // ═══════════════════════════════════════════════════════════════

  /// #6B7C3E — sage olive, harvested-field feel
  static const Color tertiary = Color(0xFF6B7C3E);
  static const Color tertiaryLight = Color(0xFFE8EDD6);
  static const Color tertiaryDark = Color(0xFF455227);
  static const Color tertiaryContainer = Color(0xFFD5DDBC);

  // ═══════════════════════════════════════════════════════════════
  // PLOT SELECTOR
  // ═══════════════════════════════════════════════════════════════

  /// #4A6FA5 — slate blue, distinct from green palette
  static const Color plotSelector = Color(0xFF4A6FA5);

  // ═══════════════════════════════════════════════════════════════
  // SEMANTIC STATE COLORS
  // ═══════════════════════════════════════════════════════════════

  /// Success — deep confident green (not neon)
  static const Color success = Color(0xFF1A8C5B);
  static const Color successLight = Color(0xFFD4F0E4);
  static const Color successDark = Color(0xFF105C3C);

  /// Error — warm red (not harsh pure red)
  static const Color error = Color(0xFFCC3333);
  static const Color errorLight = Color(0xFFFADDDD);
  static const Color errorDark = Color(0xFF8B1A1A);

  /// Warning — terracotta amber (earthy, not neon yellow)
  static const Color warning = Color(0xFFD4880A);
  static const Color warningLight = Color(0xFFFEEDD4);
  static const Color warningDark = Color(0xFF8C5600);

  /// Info — calm steel blue
  static const Color info = Color(0xFF2D6DB0);
  static const Color infoLight = Color(0xFFD6E8F8);
  static const Color infoDark = Color(0xFF1A4578);

  // ═══════════════════════════════════════════════════════════════
  // SURFACE & BACKGROUND — Light Mode
  // Trending: warm stone/sand instead of cold gray
  // ═══════════════════════════════════════════════════════════════

  /// #F6F4F0 — warm stone: the trending 2026 scaffold bg
  static const Color background = Color(0xFFF6F4F0);

  /// #FFFFFF — pure white card surface
  static const Color surface = Color(0xFFFFFFFF);

  /// #F0EDE8 — warm tinted surface for input fills
  static const Color surfaceVariant = Color(0xFFF0EDE8);

  /// #E8F3EF — sage tint for chip backgrounds
  static const Color surfaceTint = Color(0xFFE8F3EF);

  // ═══════════════════════════════════════════════════════════════
  // BORDER & DIVIDER
  // Trending: warm-toned, not cold gray
  // ═══════════════════════════════════════════════════════════════

  /// #E4DDD5 — warm sand border
  static const Color outline = Color(0xFFE4DDD5);

  /// #EDE8E2 — lighter warm border for nested elements
  static const Color outlineVariant = Color(0xFFEDE8E2);

  // ═══════════════════════════════════════════════════════════════
  // TEXT — Light Mode
  // Trending: warm charcoal (not pure black)
  // ═══════════════════════════════════════════════════════════════

  /// #1A1714 — warm charcoal: premium readable primary text
  static const Color onBackground = Color(0xFF1A1714);

  /// #524B44 — warm medium: body text, subtitles
  static const Color onSurface = Color(0xFF524B44);

  /// #9E948A — warm muted: captions, placeholders
  static const Color onSurfaceVariant = Color(0xFF9E948A);

  /// #C8C0B8 — warm disabled text
  static const Color onSurfaceDisabled = Color(0xFFC8C0B8);

  // ═══════════════════════════════════════════════════════════════
  // DARK MODE
  // Trending: warm dark (not cold neutral dark)
  // ═══════════════════════════════════════════════════════════════

  /// #111412 — very deep warm-green dark scaffold
  static const Color darkBackground = Color(0xFF111412);

  /// #1C2421 — deep surface card
  static const Color darkSurface = Color(0xFF1C2421);

  /// #252E2B — surface variant
  static const Color darkSurfaceVariant = Color(0xFF252E2B);

  /// #2E3D38 — border
  static const Color darkOutline = Color(0xFF2E3D38);
  static const Color darkOutlineVariant = Color(0xFF252E2B);

  /// #EDF5F2 — near-white text on dark
  static const Color darkOnBackground = Color(0xFFEDF5F2);

  /// #A8C4BC — muted text on dark
  static const Color darkOnSurface = Color(0xFFA8C4BC);

  /// #607B74 — subtle captions on dark
  static const Color darkOnSurfaceVariant = Color(0xFF607B74);

  /// #394E48 — disabled on dark
  static const Color darkOnSurfaceDisabled = Color(0xFF394E48);

  // ═══════════════════════════════════════════════════════════════
  // INTERACTIVE STATES
  // ═══════════════════════════════════════════════════════════════

  static const Color hover = Color(0xFFEBF6F3);
  static const Color darkHover = Color(0xFF1E2E2A);

  static const Color pressed = Color(0xFFD8EEE9);
  static const Color darkPressed = Color(0xFF253530);

  static const Color focus = primary;
  static const Color darkFocus = primaryLight;

  // ═══════════════════════════════════════════════════════════════
  // OVERLAY & SHADOW
  // ═══════════════════════════════════════════════════════════════

  static const Color scrim = Color(0x55000000);
  static const Color darkScrim = Color(0x77000000);

  /// Use .withValues(alpha:) on this for box shadows
  static const Color shadow = Color(0x0D000000);
  static const Color darkShadow = Color(0x33000000);

  // ═══════════════════════════════════════════════════════════════
  // HEADER GRADIENT
  // Trending: deep teal → forest (no purple, stays earthy)
  // ═══════════════════════════════════════════════════════════════

  /// Forest Teal → Deep Forest
  static const Color gradientStart = primary;
  static const Color gradientEnd = Color(0xFF05403A);

  // ═══════════════════════════════════════════════════════════════
  // CHART PALETTE — 6 accessible, earthy-modern colors
  // ═══════════════════════════════════════════════════════════════

  static const Color chartGreen = primary;              // Forest Teal
  static const Color chartMint = Color(0xFF2DBD9A);     // Fresh Mint
  static const Color chartBlue = Color(0xFF3D8FD4);     // Sky Blue
  static const Color chartAmber = Color(0xFFE8A020);    // Warm Amber
  static const Color chartTerracotta = secondary;       // Terracotta
  static const Color chartGray = Color(0xFFBDB5AC);     // Warm Stone Gray

  // Legacy alias so existing widgets referencing chartViolet don't break
  static const Color chartViolet = Color(0xFF8E7CC3);
}
