/// Groww-Inspired Spacing System
/// Consistent 8pt base unit spacing scale
/// Follows Material Design guidelines
class AppSpacing {
  AppSpacing._(); // Private constructor

  // ===== BASE SPACING SCALE =====
  /// 4 pixels - Ultra small, rarely used
  static const double xs = 4;

  /// 8 pixels - Base unit, smallest meaningful spacing
  static const double sm = 8;

  /// 12 pixels - Small spacing, common for compact layouts
  static const double smMd = 12;

  /// 16 pixels - Standard spacing, most common
  static const double md = 16;

  /// 20 pixels - Medium-large spacing
  static const double mdLg = 20;

  /// 24 pixels - Large spacing for section separation
  static const double lg = 24;

  /// 32 pixels - Extra large spacing for major sections
  static const double xl = 32;

  /// 40 pixels - Extra extra large spacing
  static const double xxl = 40;

  // ===== COMPONENT-SPECIFIC SPACING =====

  /// Padding inside cards/containers
  static const double cardPadding = 16;

  /// Padding inside buttons
  static const double buttonPaddingVertical = 12;
  static const double buttonPaddingHorizontal = 24;

  /// Horizontal spacing between items
  static const double itemSpacing = 12;

  /// Vertical spacing between list items
  static const double listItemSpacing = 16;

  /// Space between page sections
  static const double sectionSpacing = 24;

  /// Space from screen edges (horizontal padding)
  static const double screenPadding = 16;

  /// Space from screen top (vertical padding)
  static const double screenPaddingTop = 16;

  /// Space from screen bottom (vertical padding)
  static const double screenPaddingBottom = 24;

  // ===== BORDER RADIUS =====
  /// Small border radius - 8pt
  static const double radiusSmall = 8;

  /// Medium border radius - 12pt (standard cards)
  static const double radiusMedium = 12;

  /// Large border radius - 16pt
  static const double radiusLarge = 16;

  /// Extra large border radius - 24pt
  static const double radiusXLarge = 24;

  // ===== ELEVATION/SHADOW SPACING =====
  /// Subtle shadow elevation
  static const double elevationSubtle = 1;

  /// Medium shadow elevation
  static const double elevationMedium = 2;

  /// Prominent shadow elevation
  static const double elevationProminent = 4;

  /// Heavy shadow elevation
  static const double elevationHeavy = 8;
}
