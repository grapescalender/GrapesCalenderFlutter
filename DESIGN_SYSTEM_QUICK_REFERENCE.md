# Design System Quick Reference

## For Developers - Instant Usage Guide

---

## Colors

### Using Colors
```dart
import 'package:smart_farm_pruning_manager/core/constants/app_colors.dart';

// ✅ CORRECT
Container(
  color: AppColors.primaryGreen,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.textPrimary),
  ),
)

// ❌ WRONG
Container(
  color: Color(0xFF10B981),  // No magic numbers!
)
```

### Color Palette Summary
```
Primary     → AppColors.primaryGreen     (#10B981)
Secondary   → AppColors.primaryGreenLight (#D1FAE5)
Backgrounds → AppColors.backgroundWhite, backgroundLight, backgroundGray
Text        → AppColors.textPrimary, textSecondary, textTertiary
Status      → AppColors.errorRed, warningYellow, successGreen
```

---

## Typography

### Using Text Styles
```dart
import 'package:smart_farm_pruning_manager/core/constants/app_text_styles.dart';

// ✅ CORRECT
Text('Page Title', style: AppTextStyles.heading1)
Text('Section', style: AppTextStyles.heading2)
Text('Card Title', style: AppTextStyles.heading3)
Text('Body content', style: AppTextStyles.bodyLarge)
Text('Helper text', style: AppTextStyles.bodySmall)
Text('19 days', style: AppTextStyles.dataLarge)

// ❌ WRONG
Text('Title', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
```

### Text Hierarchy
```
Heading 1   → Page titles (28px, bold)
Heading 2   → Section titles (20px, semibold)
Heading 3   → Card titles (16px, semibold)
Body Large  → Main text (14px)
Body Medium → Secondary text (13px)
Body Small  → Meta info (12px)
```

---

## Spacing

### Using Spacing Constants
```dart
import 'package:smart_farm_pruning_manager/core/constants/app_spacing.dart';

// ✅ CORRECT
Padding(
  padding: EdgeInsets.all(AppSpacing.md),  // 16px
  child: SizedBox(
    height: AppSpacing.itemSpacing,  // 12px
    child: Divider(),
  ),
)

Container(
  margin: EdgeInsets.symmetric(
    horizontal: AppSpacing.screenPadding,  // 16px
    vertical: AppSpacing.lg,  // 24px
  ),
)

// ❌ WRONG
Padding(padding: EdgeInsets.all(15))  // Magic number!
```

### Spacing Quick Reference
```
xs   = 4px     (extra small gaps)
sm   = 8px     (small - most common)
smMd = 12px    (small-medium)
md   = 16px    (standard - very common)
lg   = 24px    (large - section spacing)
xl   = 32px    (extra large)
```

---

## Buttons

### Using Button Components
```dart
import 'package:smart_farm_pruning_manager/shared/widgets/app_buttons.dart';

// Primary button (for main actions)
PrimaryButton(
  label: 'Save Plot',
  onPressed: () { /* save plot */ },
)

// Secondary button (for secondary actions)
SecondaryButton(
  label: 'Cancel',
  onPressed: () { /* cancel */ },
)

// Text button (for minimal actions)
TextButton_(
  label: 'Learn More',
  onPressed: () { /* learn more */ },
)

// With loading state
PrimaryButton(
  label: 'Save',
  onPressed: () { },
  isLoading: isLoading,
)

// Disabled button
PrimaryButton(
  label: 'Save',
  onPressed: () { },
  isEnabled: false,  // No action
)
```

---

## Cards

### Basic Card Usage
```dart
// Standard card with plot info
Card(
  child: Padding(
    padding: EdgeInsets.all(AppSpacing.md),
    child: Column(
      children: [
        Text('Card Title', style: AppTextStyles.heading3),
        SizedBox(height: AppSpacing.md),
        Text('Card content', style: AppTextStyles.bodyLarge),
      ],
    ),
  ),
)

// Using PlotCard component
PlotCard(
  plot: plotModel,
  isSelected: selectedPlot?.id == plotModel.id,
  onTap: () {
    // Update selected plot
    ref.read(selectedPlotProvider.notifier).state = plotModel;
  },
)

// Using ScheduleCard component
ScheduleCard(
  schedule: scheduleModel,
  onTap: () {
    // Show schedule details
  },
)
```

---

## Theme Color Tokens

### Light Mode
```dart
colorScheme: ColorScheme.light(
  primary: AppColors.primaryGreen,
  secondary: AppColors.primaryGreen,
  surface: AppColors.backgroundWhite,
  background: AppColors.backgroundLight,
  error: AppColors.errorRed,
)
```

### Dark Mode
```dart
colorScheme: ColorScheme.dark(
  primary: AppColors.primaryGreen,
  surface: AppColors.darkSurface,
  background: AppColors.darkBackground,
)
```

---

## Layout Patterns

### Typical Page Layout
```dart
Scaffold(
  appBar: AppBar(title: Text('Page Title', style: AppTextStyles.heading2)),
  body: SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section 1
        SectionHeader(title: 'Section Title'),
        SizedBox(height: AppSpacing.md),
        _buildSection1Content(),
        SizedBox(height: AppSpacing.lg),  // Space between sections
        
        // Section 2
        SectionHeader(title: 'Another Section'),
        SizedBox(height: AppSpacing.md),
        _buildSection2Content(),
        
        SizedBox(height: AppSpacing.screenPaddingBottom),
      ],
    ),
  ),
)
```

### Horizontal Scrollable List
```dart
SizedBox(
  height: 200,
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    padding: EdgeInsets.symmetric(
      horizontal: AppSpacing.screenPadding,
    ),
    itemCount: items.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: EdgeInsets.only(right: AppSpacing.itemSpacing),
        child: PlotCard(
          plot: items[index],
          onTap: () { },
        ),
      );
    },
  ),
)
```

### Vertical List with Dividers
```dart
Card(
  margin: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
  child: Column(
    children: [
      ...schedules.asMap().entries.map((entry) {
        final schedule = entry.value;
        final isLast = entry.key == schedules.length - 1;
        
        return Column(
          children: [
            ScheduleCard(schedule: schedule),
            if (!isLast) Divider(height: 0),
          ],
        );
      }),
    ],
  ),
)
```

---

## Typography Examples

### Creating Sections with Headers
```dart
SectionHeader(
  title: 'Your Plots (6)',
  actionLabel: 'View All',
  onActionTap: () { /* navigate */ },
)
```

### Data Display
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Area', style: AppTextStyles.bodySmall),
        SizedBox(height: AppSpacing.sm),
        Text('2.5 acres', style: AppTextStyles.dataLarge),
      ],
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('Since Pruning', style: AppTextStyles.bodySmall),
        SizedBox(height: AppSpacing.sm),
        Text('19 days', style: AppTextStyles.dataLarge),
      ],
    ),
  ],
)
```

---

## Common Patterns

### Empty State
```dart
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.agriculture, size: 64, color: AppColors.textTertiary),
      SizedBox(height: AppSpacing.lg),
      Text('No Plots Found', style: AppTextStyles.heading2),
      SizedBox(height: AppSpacing.md),
      Text('Add your first plot to get started', style: AppTextStyles.bodyMedium),
      SizedBox(height: AppSpacing.lg),
      PrimaryButton(
        label: 'Add Plot',
        onPressed: () { },
      ),
    ],
  ),
)
```

### Loading State
```dart
Center(
  child: CircularProgressIndicator(
    color: AppColors.primaryGreen,
  ),
)
```

### Error State
```dart
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.error, size: 48, color: AppColors.errorRed),
      SizedBox(height: AppSpacing.md),
      Text('Error loading data', style: AppTextStyles.bodyMedium),
      SizedBox(height: AppSpacing.md),
      SecondaryButton(
        label: 'Retry',
        onPressed: () { /* retry */ },
      ),
    ],
  ),
)
```

---

## Component Examples

### Plot Card Usage
```dart
PlotCard(
  plot: PlotModel(
    id: 'plot_1',
    plotName: 'Plot A',
    areaInAcres: 2.5,
    grapeVariety: 'Thompson Seedless',
    pruningDate: DateTime.now().subtract(Duration(days: 19)),
  ),
  isSelected: selectedPlot?.id == 'plot_1',
  onTap: () {
    ref.read(selectedPlotProvider.notifier).state = plot;
  },
)
```

### Schedule Card Usage
```dart
ScheduleCard(
  schedule: MockScheduleModel(
    id: 'sch_1',
    plotId: 'plot_1',
    title: 'Spray Pesticide',
    scheduledDate: DateTime.now().add(Duration(days: 2)),
    type: 'spray',
    isCompleted: false,
  ),
  onTap: () {
    // Show schedule details
  },
)
```

### Section With Content
```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SectionHeader(
      title: 'Upcoming Tasks',
      actionLabel: 'View More',
      onActionTap: () { /* navigate to schedule */ },
    ),
    SizedBox(height: AppSpacing.md),
    // Content goes here
  ],
)
```

---

## Common Mistakes & Fixes

### ❌ Hardcoded Colors
```dart
// WRONG
color: Color(0xFF10B981)
backgroundColor: Color(0xFFF9FAFB)

// RIGHT
color: AppColors.primaryGreen
backgroundColor: AppColors.backgroundLight
```

### ❌ Arbitrary Font Sizes
```dart
// WRONG
style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)

// RIGHT
style: AppTextStyles.heading3
```

### ❌ Magic Padding Numbers
```dart
// WRONG
padding: EdgeInsets.all(15)
margin: EdgeInsets.symmetric(horizontal: 17)

// RIGHT
padding: EdgeInsets.all(AppSpacing.md)
margin: EdgeInsets.symmetric(horizontal: AppSpacing.md)
```

### ❌ Missing Const Constructors
```dart
// WRONG
Container(
  color: AppColors.backgroundWhite,
  child: Text('Hello'),
)

// RIGHT
const Container(
  color: AppColors.backgroundWhite,
  child: Text('Hello'),
)
```

### ❌ Non-Responsive Widths
```dart
// WRONG
SizedBox(width: 300, child: MyWidget())

// RIGHT
SizedBox.expand(child: MyWidget())
// or
Expanded(child: MyWidget())
```

---

## Testing Components

### Testing PlotCard
```dart
testWidgets('PlotCard shows selected state', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: PlotCard(
          plot: testPlot,
          isSelected: true,
          onTap: () {},
        ),
      ),
    ),
  );
  
  expect(find.text('Plot A'), findsOneWidget);
  expect(find.byType(Card), findsOneWidget);
});
```

### Testing AppColors
```dart
test('AppColors has correct hex values', () {
  expect(AppColors.primaryGreen, Color(0xFF10B981));
  expect(AppColors.textPrimary, Color(0xFF111827));
});
```

---

## File Locations

```
Core Design System:
├── lib/core/constants/app_colors.dart
├── lib/core/constants/app_text_styles.dart
├── lib/core/constants/app_spacing.dart
└── lib/core/theme/app_theme.dart

Components:
├── lib/shared/widgets/app_buttons.dart
├── lib/shared/widgets/plot_card.dart
└── lib/shared/widgets/schedule_card.dart

Example Usage:
└── lib/features/home/presentation/pages/home_page_refactored.dart

Documentation:
├── DESIGN_SYSTEM.md
├── CODE_REFACTORING_GUIDE.md
└── IMPROVEMENT_SUGGESTIONS.md
```

---

## Import Statements

### Most Common Imports
```dart
// Design system
import 'package:smart_farm_pruning_manager/core/constants/app_colors.dart';
import 'package:smart_farm_pruning_manager/core/constants/app_text_styles.dart';
import 'package:smart_farm_pruning_manager/core/constants/app_spacing.dart';

// Components
import 'package:smart_farm_pruning_manager/shared/widgets/app_buttons.dart';
import 'package:smart_farm_pruning_manager/shared/widgets/plot_card.dart';
import 'package:smart_farm_pruning_manager/shared/widgets/schedule_card.dart';

// State management
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_farm_pruning_manager/config/providers/app_providers.dart';

// Core
import 'package:smart_farm_pruning_manager/core/services/mock_data_service.dart';
```

---

## Quick Sizes Reference

```
Touch Target:    44px minimum
Card Padding:    16px
Button Height:   40px+
Border Radius:   12px
Icon Size:       20px
Section Gap:     24px
Page Margin:     16px
```

---

## Color Quick Lookup

| Use Case | Color | Variable |
|----------|-------|----------|
| Main buttons | #10B981 | `AppColors.primaryGreen` |
| Card backgrounds | #FFFFFF | `AppColors.backgroundWhite` |
| Page background | #F9FAFB | `AppColors.backgroundLight` |
| Primary text | #111827 | `AppColors.textPrimary` |
| Secondary text | #6B7280 | `AppColors.textSecondary` |
| Disabled/muted | #9CA3AF | `AppColors.textTertiary` |
| Success | #22C55E | `AppColors.successGreen` |
| Error | #EF4444 | `AppColors.errorRed` |
| Warning | #FCD34D | `AppColors.warningYellow` |
| Focus border | #10B981 | `AppColors.primaryGreen` |

---

## Getting Started Checklist

- [ ] Read `DESIGN_SYSTEM.md` (full guide)
- [ ] Read `CODE_REFACTORING_GUIDE.md` (architectural overview)
- [ ] Bookmark this Quick Reference
- [ ] Review color palette screenshot
- [ ] Review typography examples
- [ ] Practice using components on simple page
- [ ] Check existing examples in `home_page_refactored.dart`

---

**Last Updated**: February 18, 2026
**Version**: 1.0
**Status**: Ready for Development
