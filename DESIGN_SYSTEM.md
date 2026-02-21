# Design System Documentation

## Overview

Modern, minimal design system inspired by Groww's fintech aesthetic, updated for 2026. Clean, trustworthy, and optimized for mobile-first experiences.

## Color Palette

### Primary Colors
- **Primary**: `#00C853` - Vibrant emerald green (brand color)
- **Primary Light**: `#E8F5E9` - Light background variant
- **Primary Dark**: `#00A043` - Darker variant for emphasis
- **Primary Container**: `#C8E6C9` - Subtle background

### Semantic Colors
- **Success**: `#00C853` (green)
- **Error**: `#E53935` (red)
- **Warning**: `#FFB300` (amber)
- **Info**: `#2196F3` (blue)

### Neutral Colors (Light Mode)
- **Background**: `#FFFFFF` - Pure white
- **Surface**: `#FAFAFA` - Off-white for cards
- **Surface Variant**: `#F5F5F5` - Elevated surfaces
- **Outline**: `#E0E0E0` - Borders and dividers

### Text Colors (Light Mode)
- **On Background**: `#1A1A1A` - Primary text (high contrast)
- **On Surface**: `#424242` - Secondary text
- **On Surface Variant**: `#757575` - Tertiary text, hints
- **On Surface Disabled**: `#BDBDBD` - Disabled text

### Dark Mode Colors
- **Dark Background**: `#121212`
- **Dark Surface**: `#1E1E1E`
- **Dark Surface Variant**: `#2C2C2C`
- **Dark Outline**: `#3A3A3A`
- **Dark Text Primary**: `#E0E0E0`
- **Dark Text Secondary**: `#BDBDBD`
- **Dark Text Tertiary**: `#9E9E9E`

## Typography System

### Display Text
- **Display Large**: 32px (mobile) / 36px (tablet) / 40px (desktop), Bold
- **Display Medium**: 28px / 32px / 36px, Bold
- **Display Small**: 24px / 28px / 32px, SemiBold

### Headline Text
- **Headline Large**: 20px / 22px / 24px, SemiBold
- **Headline Medium**: 18px / 20px / 22px, SemiBold
- **Headline Small**: 16px / 18px / 20px, SemiBold

### Title Text
- **Title Large**: 16px / 18px / 20px, Medium
- **Title Medium**: 14px / 16px / 18px, Medium
- **Title Small**: 12px / 14px / 16px, Medium

### Body Text
- **Body Large**: 16px / 18px / 20px, Regular
- **Body Medium**: 14px / 16px / 18px, Regular (most common)
- **Body Small**: 12px / 14px / 16px, Regular

### Label Text
- **Label Large**: 14px / 16px / 18px, Medium (buttons)
- **Label Medium**: 12px / 14px / 16px, Medium (tags)
- **Label Small**: 11px / 12px / 14px, Medium (small tags)

### Responsive Text Scaling
Text sizes automatically scale based on screen width:
- **Mobile**: < 600px
- **Tablet**: 600px - 1200px
- **Desktop**: ≥ 1200px

## Spacing System (8pt Grid)

### Base Spacing Scale
- **None**: 0px
- **XS**: 4px (0.5x base)
- **SM**: 8px (1x base) - Most common
- **SM-MD**: 12px (1.5x base)
- **MD**: 16px (2x base) - Standard spacing
- **MD-LG**: 20px (2.5x base)
- **LG**: 24px (3x base) - Section spacing
- **XL**: 32px (4x base)
- **XXL**: 40px (5x base)
- **Huge**: 48px (6x base)
- **XHuge**: 64px (8x base)

### Component-Specific Spacing
- **Screen Padding**: 16px horizontal, 16px vertical
- **Card Padding**: 16px (standard), 20px (large)
- **Button Padding**: 12px vertical, 24px horizontal
- **Input Padding**: 14px vertical, 16px horizontal
- **List Item Spacing**: 12px (standard), 16px (large)
- **Section Spacing**: 24px (standard), 32px (large)
- **Icon Spacing**: 8px (standard), 12px (large)

## Border Radius

- **XS**: 4px
- **SM**: 8px (buttons, chips)
- **MD**: 12px (cards, inputs) - Standard
- **LG**: 16px (large cards)
- **XL**: 20px
- **Huge**: 24px (modals, sheets)
- **Full**: 999px (pills, avatars)

## Elevation System

- **None**: 0 - Flat elements
- **Subtle**: 1 - Cards at rest
- **Low**: 2 - Hovered cards
- **Medium**: 4 - Raised buttons, floating elements
- **High**: 8 - Dialogs, modals
- **Very High**: 16 - Tooltips, dropdowns

## Card Styling

### Default Card
- Background: Surface color
- Elevation: Subtle (1)
- Border Radius: 12px (medium)
- Padding: 16px
- Shadow: Subtle shadow with blur

### Elevated Card
- Elevation: Medium (4)
- More prominent shadow
- Used for interactive or important content

### Flat Card
- Elevation: 0
- Optional border
- Used for minimal, borderless designs

## Button Styling

### Primary Button
- Background: Primary color
- Text: White
- Elevation: Medium (4)
- Border Radius: 8px
- Padding: 12px vertical, 24px horizontal

### Secondary Button (Outlined)
- Background: Transparent
- Border: Primary color
- Text: Primary color
- Border Radius: 8px

### Text Button
- Background: Transparent
- Text: Primary color
- Border Radius: 8px
- No border or elevation

### Button Sizes
- **Small**: Compact padding
- **Medium**: Standard padding (default)
- **Large**: Larger padding

## Icon Style

- **Size**: 24px (standard)
- **Color**: On Surface color (adapts to theme)
- **Spacing**: 8px from adjacent elements
- **Style**: Material Icons (outlined for unselected, filled for selected)

## Bottom Navigation Pattern

### Design
- **Height**: 64px (including SafeArea)
- **Background**: Surface color
- **Elevation**: Medium shadow on top
- **Item Layout**: Icons with labels below
- **Selected State**: Primary color, bold label
- **Unselected State**: Tertiary color, regular weight
- **Badge Support**: Red circular badge with count

### Spacing
- Horizontal padding: 8px
- Item spacing: Equal distribution
- Icon size: 24px
- Label size: 11px

## Usage Examples

### Card
```dart
AppCard.defaultStyle(
  child: Column(
    children: [
      Text('Card Title', style: AppTypography.headlineSmall(context)),
      SizedBox(height: AppSpacing.sm),
      Text('Card content', style: AppTypography.bodyMedium(context)),
    ],
  ),
)
```

### Button
```dart
AppButton.primary(
  label: 'Submit',
  onPressed: () {},
  icon: Icons.check,
  isFullWidth: true,
)
```

### Bottom Navigation
```dart
AppBottomNav(
  currentIndex: 0,
  onTap: (index) {},
  items: [
    AppBottomNavItem(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'Home',
    ),
    // ... more items
  ],
)
```

### Typography
```dart
Text(
  'Hello World',
  style: AppTypography.headlineLarge(context),
)
```

### Responsive Text
```dart
Text(
  'Responsive Text',
  style: AppTypography.bodyMedium(context), // Auto-scales
)
```

## Theme Configuration

### Light Theme
- Background: White
- Surface: Off-white
- Text: Dark gray
- Primary: Emerald green

### Dark Theme
- Background: Dark gray (#121212)
- Surface: Lighter dark (#1E1E1E)
- Text: Light gray
- Primary: Same emerald green

## Design Principles

1. **Minimal**: Clean, uncluttered interfaces
2. **Consistent**: 8pt grid system throughout
3. **Accessible**: High contrast ratios, readable text
4. **Responsive**: Scales across mobile, tablet, desktop
5. **Modern**: 2026 design trends (rounded corners, subtle shadows)
6. **Trustworthy**: Professional color palette and typography

## File Structure

```
lib/
├── core/
│   └── design_system/
│       ├── colors/
│       │   └── app_colors.dart
│       ├── spacing/
│       │   └── app_spacing.dart
│       ├── typography/
│       │   └── app_typography.dart
│       └── theme/
│           ├── app_theme.dart
│           └── app_theme_provider.dart
└── shared/
    └── widgets/
        ├── app_card.dart
        ├── app_button.dart
        └── app_bottom_nav.dart
```
