/// Modern 8pt Grid Spacing System
/// Consistent spacing scale based on 8px base unit
/// Follows Material Design 3 and modern design principles
class AppSpacing {
  AppSpacing._();

  // ===== BASE SPACING SCALE (8pt Grid) =====
  /// 0px - No spacing
  static const double none = 0.0;
  
  /// 4px - Extra small (0.5x base)
  static const double xs = 4.0;
  
  /// 8px - Small (1x base) - Most common
  static const double sm = 8.0;
  
  /// 12px - Small-medium (1.5x base)
  static const double smMd = 12.0;
  
  /// 16px - Medium (2x base) - Standard spacing
  static const double md = 16.0;
  
  /// 20px - Medium-large (2.5x base)
  static const double mdLg = 20.0;
  
  /// 24px - Large (3x base) - Section spacing
  static const double lg = 24.0;
  
  /// 32px - Extra large (4x base)
  static const double xl = 32.0;
  
  /// 40px - Extra extra large (5x base)
  static const double xxl = 40.0;
  
  /// 48px - Huge (6x base)
  static const double huge = 48.0;
  
  /// 64px - Extra huge (8x base)
  static const double xhuge = 64.0;

  // ===== COMPONENT-SPECIFIC SPACING =====
  
  /// Screen edge padding
  static const double screenHorizontal = 16.0;
  static const double screenVertical = 16.0;
  
  /// Card internal padding
  static const double cardPadding = 16.0;
  static const double cardPaddingLarge = 20.0;
  
  /// Button padding
  static const double buttonPaddingVertical = 12.0;
  static const double buttonPaddingHorizontal = 24.0;
  static const double buttonPaddingHorizontalSmall = 16.0;
  
  /// Input field padding
  static const double inputPaddingVertical = 14.0;
  static const double inputPaddingHorizontal = 16.0;
  
  /// List item spacing
  static const double listItemSpacing = 12.0;
  static const double listItemSpacingLarge = 16.0;
  
  /// Section spacing
  static const double sectionSpacing = 24.0;
  static const double sectionSpacingLarge = 32.0;
  
  /// Icon spacing
  static const double iconSpacing = 8.0;
  static const double iconSpacingLarge = 12.0;
  
  /// Avatar spacing
  static const double avatarSpacing = 12.0;

  // ===== BORDER RADIUS =====
  /// 4px - Extra small radius
  static const double radiusXs = 4.0;
  
  /// 8px - Small radius (buttons, chips)
  static const double radiusSm = 8.0;
  
  /// 12px - Medium radius (cards, inputs) - Standard
  static const double radiusMd = 12.0;
  
  /// 16px - Large radius (large cards)
  static const double radiusLg = 16.0;
  
  /// 20px - Extra large radius
  static const double radiusXl = 20.0;
  
  /// 24px - Huge radius (modals, sheets)
  static const double radiusHuge = 24.0;
  
  /// 999px - Fully rounded (pills, avatars)
  static const double radiusFull = 999.0;

  // ===== ELEVATION SYSTEM =====
  /// 0 - No elevation (flat)
  static const double elevationNone = 0.0;
  
  /// 1 - Subtle elevation (cards at rest)
  static const double elevationSubtle = 1.0;
  
  /// 2 - Low elevation (hovered cards)
  static const double elevationLow = 2.0;
  
  /// 4 - Medium elevation (raised buttons, floating elements)
  static const double elevationMedium = 4.0;
  
  /// 8 - High elevation (dialogs, modals)
  static const double elevationHigh = 8.0;
  
  /// 16 - Very high elevation (tooltips, dropdowns)
  static const double elevationVeryHigh = 16.0;
}
