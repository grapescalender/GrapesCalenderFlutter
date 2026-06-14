# Activity Stepper – Quick Reference Guide

## 🎯 Quick Start

### 1. Home Screen – Horizontal Stepper
```dart
import 'package:flutter/material.dart';
import 'widgets/horizontal_activity_stepper.dart';

// In ActivitySection widget
HorizontalActivityStepper(
  activities: activityState.activities,
  onStepTapped: (activity) {
    // Handle step tap
    _showActivityDetail(context, activity);
  },
  onViewAllActivities: () {
    // Navigate to View All Activities page
    context.push(AppRoutes.viewAllActivities);
  },
  selectedActivity: currentActivity, // Optional
)
```

### 2. View All Activities – Vertical Stepper
```dart
import 'widgets/vertical_activity_stepper.dart';

// In ViewAllActivitiesPage widget
VerticalActivityStepper(
  activities: sortedActivities,
  onActivityTapped: (activity) {
    // Handle activity selection
    _showActivityDetail(context, activity);
  },
  lineHeight: 2.0, // Optional, customize line thickness
)
```

### 3. Activity Detail Bottom Sheet
```dart
import 'widgets/activity_detail_bottom_sheet.dart';

showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (context) => ActivityDetailBottomSheet(
    activity: selectedActivity,
    pruningDate: plot.pruningDate,
    onViewSchedules: () {
      // Navigate to related schedules
      _navigateToRelatedSchedules(context, activity);
    },
  ),
);
```

---

## 🎨 Component Reference

### StepIndicator
```dart
import 'widgets/step_indicator.dart';

StepIndicator(
  state: StepState.current,        // completed, current, upcoming
  stepNumber: 1,                    // Display number
  icon: Icons.agriculture,          // Optional icon
  size: 40.0,                       // Diameter (default: 40)
  isClickable: true,                // Enable interaction
  isLast: false,                    // Last indicator
  onTap: () { /*callback*/ },       // On tap callback
)
```

**States**:
- `StepState.completed`: Green circle with check
- `StepState.current`: Indigo circle with number
- `StepState.upcoming`: Grey outlined circle

### ActivityCard
```dart
import 'widgets/activity_card.dart';

ActivityCard(
  activity: activity,           // ActivityEntity
  isSelected: false,             // Highlight state
  isClickable: true,             // Enable tap
  onTap: () { /*callback*/ },    // On tap callback
  dayCount: 14,                  // Duration in days
  startDay: 1,                   // Start day from pruning
)
```

**Displays**:
- Activity type with icon
- Plot name
- Date range (Start → End)
- Day count badge
- Status badge (Pending/Active/Completed)

---

## 🔄 State Management

### Activity States
```dart
enum ActivityStatus {
  pending,   // Not started yet
  active,    // Currently in progress
  completed, // Finished
}

enum ActivityType {
  cutting,       // 1st phase
  flooring,      // 2nd phase
  formation,     // 3rd phase
  harvesting,    // 4th phase
  dipping,       // 5th phase
}
```

### Activity Entity
```dart
class ActivityEntity {
  final String id;
  final String plotId;
  final String plotName;
  final ActivityType type;
  final ActivityStatus status;
  final DateTime? startedAt;
  final DateTime? completedAt;
  
  // Getters
  bool get isActive => status == ActivityStatus.active;
  bool get isCompleted => status == ActivityStatus.completed;
  bool get isPending => status == ActivityStatus.pending;
}
```

---

## 🎨 Customizing Colors

### Using Theme Extension
```dart
// Access ActivityStepperTheme in widgets
final stepperTheme = Theme.of(context).extension<ActivityStepperTheme>()!;

// Use colors from theme
Color completedColor = stepperTheme.completedColor;
Color currentColor = stepperTheme.currentColor;
Color upcomingColor = stepperTheme.upcomingColor;
```

### Customize in AppTheme
```dart
// lib/core/design_system/theme/app_theme.dart

// Light theme
ActivityStepperTheme.light(colorScheme),

// Dark theme
ActivityStepperTheme.dark(colorScheme),
```

---

## 📐 Layout & Spacing

### Constants
```dart
import 'core/design_system/spacing/app_spacing.dart';

// Common sizes
AppSpacing.xs    = 4.0   // Extra small
AppSpacing.sm    = 8.0   // Small
AppSpacing.md    = 16.0  // Medium (standard)
AppSpacing.lg    = 24.0  // Large
AppSpacing.xl    = 32.0  // Extra large

// Border radius
AppSpacing.radiusLg = 16.0  // Cards
AppSpacing.radiusSm = 8.0   // Badges
```

---

## 🔗 Navigation Integration

### Navigation Flow
```
Home Screen
  ↓ (click activity or "View All Activities")
View All Activities Page
  ↓ (click activity)
Activity Detail Bottom Sheet
  ↓ (click "View Related Schedules")
Related Schedules Page
```

### Passing Data in Navigation
```dart
// Navigate from ActivitySection to RelatedSchedulePage
context.push(
  AppRoutes.relatedSchedules,
  extra: {
    'activityId': activity.id,
    'activityName': activity.type.displayName,
    'startDate': activity.startedAt,
    'endDate': activity.completedAt,
    'startDay': calculatedStartDay,
    'endDay': calculatedEndDay,
  },
);
```

---

## 📊 Activity Sequence

Activities follow a natural order (not customizable):
```
1️⃣  Cutting
2️⃣  Flooring
3️⃣  Formation
4️⃣  Harvesting
5️⃣  Dipping
```

**Access order**:
```dart
final orderedTypes = ActivityType.orderedTypes;
// Returns: [cutting, flooring, formation, harvesting, dipping]

// Get next activity
final next = ActivityType.getNext(ActivityType.cutting);
// Returns: ActivityType.flooring
```

---

## ⚠️ Common Patterns

### Calculating Day Count
```dart
import 'shared/utils/date_utils.dart' as date_utils;

final dayCount = activity.completedAt != null
    ? activity.completedAt!.difference(activity.startedAt!).inDays + 1
    : 0;

final dayCountFromPruning = activity.startedAt != null && pruningDate != null
    ? date_utils.ActivityDateUtils.calculateDay(pruningDate, activity.startedAt!)
    : null;
```

### Checking Activity Progress
```dart
if (activity.isCompleted) {
  // Show completed state
} else if (activity.isActive) {
  // Show current/in-progress state
} else {
  // Show pending/upcoming state
}
```

### Filtering & Sorting
```dart
// Sort activities by type order
final ordered = ActivityType.orderedTypes;
final sorted = ordered
    .map((type) => activities.firstWhere((a) => a.type == type))
    .toList();

// Filter by status
final completed = activities.where((a) => a.isCompleted).toList();
final current = activities.firstWhere((a) => a.isActive);
final upcoming = activities.where((a) => a.isPending).toList();
```

---

## 🧪 Testing & Debugging

### Checking State
```dart
// Debug activity state
print('Activity: ${activity.type.displayName}');
print('Status: ${activity.status}');
print('Started: ${activity.startedAt}');
print('Completed: ${activity.completedAt}');
```

### Testing Tap
```dart
// Manually trigger interaction
onStepTapped(activity);
onActivityTapped(activity);
onViewAllActivities();
```

### Loading States
```dart
// Handle loading
if (activityState.isLoading) {
  return CircularProgressIndicator();
}

// Handle errors
if (activityState.errorMessage != null) {
  return ErrorWidget(message: activityState.errorMessage!);
}

// Handle empty
if (activityState.activities.isEmpty) {
  return EmptyStateWidget();
}
```

---

## 📱 Responsive Considerations

```dart
// Mobile: Single column, scrollable indicators
// Tablet: Larger spacing, more padding

final isTablet = ResponsiveUtils.isTablet(context);
final isSmallPhone = screenWidth < 360;

// Adjust component sizes
final stepIndicatorSize = isTablet ? 44.0 : 36.0;
final spacingMultiplier = isTablet ? 1.5 : 1.0;
```

---

## 🎓 Best Practices

### ✅ DO
- ✅ Use activity type order (ActivityType.orderedTypes)
- ✅ Calculate day counts with null safety
- ✅ Handle all three activity states
- ✅ Sort activities before displaying
- ✅ Pass activity info through navigation extras
- ✅ Filter schedules by date range
- ✅ Use theme colors for consistency

### ❌ DON'T
- ❌ Hardcode colors (use theme)
- ❌ Modify activity type order
- ❌ Show upcoming activities as clickable
- ❌ Skip null checks on dates
- ❌ Mix manual color codes with theme
- ❌ Override stepper widgets unnecessarily
- ❌ Ignore activity status in UI

---

## 📞 Support & Examples

### Example 1: Simple Activity List
```dart
final activities = ref.watch(activityNotifierProvider).activities;

HorizontalActivityStepper(
  activities: activities,
  onStepTapped: (activity) => print('Tapped: ${activity.type.displayName}'),
  onViewAllActivities: () => print('View all'),
)
```

### Example 2: With Loading State
```dart
final state = ref.watch(activityNotifierProvider);

if (state.isLoading) return LoadingWidget();
if (state.errorMessage != null) return ErrorWidget(state.errorMessage!);
if (state.activities.isEmpty) return EmptyWidget();

return VerticalActivityStepper(
  activities: state.activities,
  onActivityTapped: (a) => showDetail(context, a),
)
```

### Example 3: Activity Filtering
```dart
// Get only completed activities
final completed = activities.where((a) => a.isCompleted).toList();

// Get current activity
final current = activities.firstWhere(
  (a) => a.isActive,
  orElse: () => activities.first,
);

// Sort by sequence
final sorted = ActivityType.orderedTypes
    .map((type) => activities.firstWhere((a) => a.type == type))
    .toList();
```

---

**Version**: 1.0  
**Last Updated**: 25 February 2026  
**Status**: ✅ Production Ready
