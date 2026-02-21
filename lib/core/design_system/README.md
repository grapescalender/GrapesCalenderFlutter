# Design System

Modern, minimal design system inspired by Groww's fintech aesthetic, updated for 2026.

## Quick Start

### Using Colors
```dart
import 'package:smart_farm_pruning_manager/core/design_system/colors/app_colors.dart';

Container(
  color: AppColors.primary,
  child: Text('Hello', style: TextStyle(color: AppColors.onBackground)),
)
```

### Using Spacing
```dart
import 'package:smart_farm_pruning_manager/core/design_system/spacing/app_spacing.dart';

Padding(
  padding: EdgeInsets.all(AppSpacing.md),
  child: Widget(),
)
```

### Using Typography
```dart
import 'package:smart_farm_pruning_manager/core/design_system/typography/app_typography.dart';

Text(
  'Hello',
  style: AppTypography.headlineLarge(context),
)
```

### Using Cards
```dart
import 'package:smart_farm_pruning_manager/shared/widgets/app_card.dart';

AppCard.defaultStyle(
  child: Text('Card content'),
)
```

### Using Buttons
```dart
import 'package:smart_farm_pruning_manager/shared/widgets/app_button.dart';

AppButton.primary(
  label: 'Click me',
  onPressed: () {},
)
```

### Using Bottom Navigation
```dart
import 'package:smart_farm_pruning_manager/shared/widgets/app_bottom_nav.dart';

AppBottomNav(
  currentIndex: 0,
  onTap: (index) {},
  items: [
    AppBottomNavItem(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'Home',
    ),
  ],
)
```

## Components

### AppCard
- `AppCard.defaultStyle()` - Standard card with subtle elevation
- `AppCard.elevated()` - Card with medium elevation
- `AppCard.flat()` - Card with no elevation, optional border

### AppButton
- `AppButton.primary()` - Filled button with primary color
- `AppButton.secondary()` - Outlined button
- `AppButton.text()` - Text-only button
- Sizes: `small`, `medium`, `large`
- Supports `isLoading`, `icon`, `isFullWidth`

### AppBottomNav
- Minimal bottom navigation bar
- Supports icons, labels, and badges
- Auto-adapts to light/dark theme

## Theme

The theme is automatically applied via `AppTheme.lightTheme` and `AppTheme.darkTheme`. Use `themeModeProvider` to toggle between themes.

```dart
final themeMode = ref.watch(themeModeProvider);
ref.read(themeModeProvider.notifier).toggleTheme();
```

## Design Tokens

All design tokens (colors, spacing, typography) are centralized in:
- `colors/app_colors.dart`
- `spacing/app_spacing.dart`
- `typography/app_typography.dart`

See `DESIGN_SYSTEM.md` for complete documentation.
