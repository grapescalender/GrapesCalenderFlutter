import 'package:flutter/material.dart';
import '../colors/app_colors.dart';

/// AgriTech SaaS Design System — Typography 2026
///
/// Scale philosophy (mobile-first, no responsive jitter on phones):
///   • Removed the old responsive 3-breakpoint sizing that inflated
///     font sizes on every 600 px+ screen.
///   • Mobile sizes are now the canonical sizes used everywhere
///     (phones 5–7 inch). Tablet gets a single +2 pt bump only.
///   • All sizes are TOKEN-based — widgets must NOT override
///     fontSize directly. Use copyWith(fontWeight:) or
///     copyWith(color:) only.
///
/// Type Scale (Mobile / Tablet):
///   Display Large   26 / 28   Bold      hero numbers, day counts
///   Display Medium  22 / 24   Bold      major hero titles
///   Display Small   20 / 22   SemiBold  section heroes
///   Headline Large  18 / 20   SemiBold  page titles, major cards
///   Headline Medium 16 / 18   SemiBold  section titles, card titles
///   Headline Small  15 / 16   SemiBold  sub-section, widget titles
///   Title Large     14 / 15   SemiBold  prominent list titles
///   Title Medium    13 / 14   Medium    card subtitles, labels
///   Title Small     12 / 13   Medium    small labels, chips
///   Body Large      14 / 15   Regular   primary body copy
///   Body Medium     13 / 14   Regular   standard body (most common)
///   Body Small      12 / 13   Regular   secondary body, captions
///   Label Large     13 / 14   SemiBold  buttons, CTAs
///   Label Medium    11 / 12   Medium    tags, badges
///   Label Small     10 / 11   Medium    overlines, micro labels
///
/// Font family: Inter (declared in pubspec / theme; no fallback needed)

class AppTypography {
  AppTypography._();

  // ─── font family token ───────────────────────────────────────────────────
  static const String fontFamily = 'Inter';

  // ─── shared line heights ─────────────────────────────────────────────────
  static const double _lhDisplay = 1.20;
  static const double _lhHeadline = 1.30;
  static const double _lhTitle = 1.35;
  static const double _lhBody = 1.50;
  static const double _lhLabel = 1.30;

  // ═══════════════════════════════════════════════════════════════
  // DISPLAY
  // ═══════════════════════════════════════════════════════════════

  /// 26 pt Bold — hero numbers, day-count cards
  static TextStyle displayLarge(BuildContext? context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sz(context, 26, 28),
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: _lhDisplay,
        color: AppColors.onBackground,
      );

  /// 22 pt Bold — major hero titles
  static TextStyle displayMedium(BuildContext? context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sz(context, 22, 24),
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        height: _lhDisplay,
        color: AppColors.onBackground,
      );

  /// 20 pt SemiBold — section heroes
  static TextStyle displaySmall(BuildContext? context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sz(context, 20, 22),
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        height: _lhDisplay,
        color: AppColors.onBackground,
      );

  // ═══════════════════════════════════════════════════════════════
  // HEADLINE
  // ═══════════════════════════════════════════════════════════════

  /// 18 pt SemiBold — page titles, major card titles
  static TextStyle headlineLarge(BuildContext? context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sz(context, 18, 20),
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: _lhHeadline,
        color: AppColors.onBackground,
      );

  /// 16 pt SemiBold — section headers, card titles
  static TextStyle headlineMedium(BuildContext? context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sz(context, 16, 18),
        fontWeight: FontWeight.w600,
        letterSpacing: -0.15,
        height: _lhHeadline,
        color: AppColors.onBackground,
      );

  /// 15 pt SemiBold — widget / sub-section titles
  static TextStyle headlineSmall(BuildContext? context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sz(context, 15, 16),
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        height: _lhHeadline,
        color: AppColors.onBackground,
      );

  // ═══════════════════════════════════════════════════════════════
  // TITLE
  // ═══════════════════════════════════════════════════════════════

  /// 14 pt SemiBold — prominent list item titles
  static TextStyle titleLarge(BuildContext? context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sz(context, 14, 15),
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: _lhTitle,
        color: AppColors.onBackground,
      );

  /// 13 pt Medium — card subtitles, compact headers
  static TextStyle titleMedium(BuildContext? context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sz(context, 13, 14),
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: _lhTitle,
        color: AppColors.onSurface,
      );

  /// 12 pt Medium — small labels, filter chips
  static TextStyle titleSmall(BuildContext? context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sz(context, 12, 13),
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: _lhTitle,
        color: AppColors.onSurface,
      );

  // ═══════════════════════════════════════════════════════════════
  // BODY
  // ═══════════════════════════════════════════════════════════════

  /// 14 pt Regular — primary body copy, detail paragraphs
  static TextStyle bodyLarge(BuildContext? context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sz(context, 14, 15),
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: _lhBody,
        color: AppColors.onBackground,
      );

  /// 13 pt Regular — standard body text (most-used in app)
  static TextStyle bodyMedium(BuildContext? context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sz(context, 13, 14),
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: _lhBody,
        color: AppColors.onSurface,
      );

  /// 12 pt Regular — secondary body, captions, hints
  static TextStyle bodySmall(BuildContext? context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sz(context, 12, 13),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        height: _lhBody,
        color: AppColors.onSurfaceVariant,
      );

  // ═══════════════════════════════════════════════════════════════
  // LABEL
  // ═══════════════════════════════════════════════════════════════

  /// 13 pt SemiBold — buttons, CTAs
  static TextStyle labelLarge(BuildContext? context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sz(context, 13, 14),
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: _lhLabel,
        color: Colors.white,
      );

  /// 11 pt Medium — tags, status badges
  static TextStyle labelMedium(BuildContext? context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sz(context, 11, 12),
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        height: _lhLabel,
        color: AppColors.onSurface,
      );

  /// 10 pt Medium — overlines, micro chips
  static TextStyle labelSmall(BuildContext? context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: _sz(context, 10, 11),
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
        height: _lhLabel,
        color: AppColors.onSurfaceVariant,
      );

  // ═══════════════════════════════════════════════════════════════
  // UTILITY HELPERS
  // ═══════════════════════════════════════════════════════════════

  /// Two-tier responsive: mobile (< 600) and tablet (≥ 600).
  /// Desktop is treated same as tablet — this is a mobile-first app.
  static double _sz(BuildContext? context, double mobile, double tablet) {
    if (context == null) return mobile;
    return MediaQuery.of(context).size.width >= 600 ? tablet : mobile;
  }

  /// Convenience: apply a custom color without touching other properties
  static TextStyle withColor(TextStyle style, Color color) =>
      style.copyWith(color: color);

  /// Convenience: apply a custom weight without touching other properties
  static TextStyle withWeight(TextStyle style, FontWeight weight) =>
      style.copyWith(fontWeight: weight);
}
