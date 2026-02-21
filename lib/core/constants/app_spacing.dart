/// Groww-Inspired Spacing System
/// Consistent 8pt base unit spacing scale
/// Follows Material Design guidelines
class AppSpacing {
  AppSpacing._(); // Private constructor

  // ===== BASE SPACING SCALE =====
  /// 4 pixels - Ultra small, rarely used
  static const double xs = 4.0;

  /// 8 pixels - Base unit, smallest meaningful spacing
  static const double sm = 8.0;

  /// 12 pixels - Small spacing, common for compact layouts
  static const double smMd = 12.0;

  /// 16 pixels - Standard spacing, most common
  static const double md = 16.0;

  /// 20 pixels - Medium-large spacing
  static const double mdLg = 20.0;

  /// 24 pixels - Large spacing for section separation
  static const double lg = 24.0;

  /// 32 pixels - Extra large spacing for major sections
  static const double xl = 32.0;

  /// 40 pixels - Extra extra large spacing
  static const double xxl = 40.0;

  // ===== COMPONENT-SPECIFIC SPACING =====

  /// Padding inside cards/containers
  static const double cardPadding = 16.0;

  /// Padding inside buttons
  static const double buttonPaddingVertical = 12.0;
  static const double buttonPaddingHorizontal = 24.0;

  /// Horizontal spacing between items
  static const double itemSpacing = 12.0;

  /// Vertical spacing between list items
  static const double listItemSpacing = 16.0;

  /// Space between page sections
  static const double sectionSpacing = 24.0;

  /// Space from screen edges (horizontal padding)
  static const double screenPadding = 16.0;

  /// Space from screen top (vertical padding)
  static const double screenPaddingTop = 16.0;

  /// Space from screen bottom (vertical padding)
  static const double screenPaddingBottom = 24.0;

  // ===== BORDER RADIUS =====
  /// Small border radius - 8pt
  static const double radiusSmall = 8.0;

  /// Medium border radius - 12pt (standard cards)
  static const double radiusMedium = 12.0;

  /// Large border radius - 16pt
  static const double radiusLarge = 16.0;

  /// Extra large border radius - 24pt
  static const double radiusXLarge = 24.0;

  // ===== ELEVATION/SHADOW SPACING =====
  /// Subtle shadow elevation
  static const double elevationSubtle = 1.0;

  /// Medium shadow elevation
  static const double elevationMedium = 2.0;

  /// Prominent shadow elevation
  static const double elevationProminent = 4.0;

  /// Heavy shadow elevation
  static const double elevationHeavy = 8.0;
}
