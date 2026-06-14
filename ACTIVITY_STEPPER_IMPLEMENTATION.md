# Activity Stepper UI – Complete Implementation Guide

## 📋 Overview

A comprehensive hybrid Activity Stepper UI system for Flutter using Material 3, combining horizontal progress stepper (home screen) and vertical timeline stepper ("View All Activities" page) with full state management and navigation integration.

---

## 🎯 Features Implemented

### 1. **Horizontal Activity Stepper** (Home Screen)
- **Location**: Top of Activity Section on Home Screen
- **Components**:
  - Circular step indicators (Connected with progress lines)
  - Step States:
    - ✅ **Completed**: Green circle with check icon
    - 🔵 **Current**: Indigo circle (highlighted)
    - ⭕ **Upcoming**: Grey outlined circle
  - Progress line animation (filled till current, grey after)
  - Selected activity summary card below stepper
  - "View All Activities" button

**File**: [lib/features/activity/presentation/widgets/horizontal_activity_stepper.dart](lib/features/activity/presentation/widgets/horizontal_activity_stepper.dart)

### 2. **Vertical Activity Stepper** ("View All Activities" Page)
- **Layout**: Vertical timeline with step indicators on left, cards on right
- **Components**:
  - Left vertical line with step indicators
  - Right activity cards with all information
  - Step States:
    - ✅ **Completed**: Green check icon + solid connector
    - 🔵 **Current**: Indigo circle + highlighted gradient card
    - ⭕ **Upcoming**: Grey circle + faded/disabled card
  - Clickable/Tappable for completed & current states
  - Disabled interaction for upcoming states

**File**: [lib/features/activity/presentation/widgets/vertical_activity_stepper.dart](lib/features/activity/presentation/widgets/vertical_activity_stepper.dart)

### 3. **Reusable Widgets**

#### **StepIndicator**
- Circular indicator showing step state
- Supports custom size and icons
- Animated transitions between states
- Clickable with callback support

**File**: [lib/features/activity/presentation/widgets/step_indicator.dart](lib/features/activity/presentation/widgets/step_indicator.dart)

#### **ActivityCard**
- Clean card displaying activity details
- Shows:
  - Activity type with icon
  - Plot name
  - Start Date → End Date range
  - Day count badge
  - Status badge (Pending/Active/Completed)
- Supports selected/highlighted state
- Responsive to activity state

**File**: [lib/features/activity/presentation/widgets/activity_card.dart](lib/features/activity/presentation/widgets/activity_card.dart)

### 4. **Activity Detail Bottom Sheet**
- Enhanced modal with:
  - Activity info header with gradient background (for current activities)
  - Start date / End date with day counts
  - Activity duration badge
  - Plot name
  - "View Related Schedule" button
  - Smooth animations

**File**: [lib/features/activity/presentation/widgets/activity_detail_bottom_sheet.dart](lib/features/activity/presentation/widgets/activity_detail_bottom_sheet.dart)

### 5. **Theme System**
- **ActivityStepperTheme**: Custom theme extension
  - Customizable colors for all states
  - Light & Dark theme presets
  - Consistent color scheme with Material 3

**File**: [lib/core/design_system/theme/activity_stepper_theme.dart](lib/core/design_system/theme/activity_stepper_theme.dart)

---

## 📁 File Structure

```
lib/
├── features/
│   └── activity/
│       ├── presentation/
│       │   ├── widgets/
│       │   │   ├── step_indicator.dart .................... Reusable step indicator
│       │   │   ├── activity_card.dart ..................... Activity info card
│       │   │   ├── horizontal_activity_stepper.dart ....... Home screen stepper
│       │   │   ├── vertical_activity_stepper.dart ......... View all page timeline
│       │   │   ├── activity_detail_bottom_sheet.dart ...... Enhanced bottom sheet
│       │   │   └── activity_section.dart .................. Updated home section
│       │   └── pages/
│       │       └── view_all_activities_page.dart .......... Updated with vertical stepper
│       └── domain/
│           └── entities/
│               └── activity_entity.dart ................... (No changes)
├── core/
│   └── design_system/
│       └── theme/
│           ├── activity_stepper_theme.dart ............... NEW: Theme extension
│           └── app_theme.dart ............................ Updated with new theme
└── config/
    └── router/
        └── app_router.dart .............................. (No changes)
```

---

## 🎨 Design System

### Colors
- **Completed**: `ColorScheme.secondary` (Green - #2E7D32)
- **Current**: `ColorScheme.primary` (Indigo - #3F51B5)
- **Upcoming**: `ColorScheme.outlineVariant` (Grey)

### Spacing
- Step indicators: 36-44 px (diameter)
- Connector lines: 30 px width, 60 px height (vertical)
- Padding: 12-16 px consistent throughout
- Border Radius: 16 px for cards, 8 px for badges

### Typography
- **Activity Name**: Bold, labelLarge
- **Status**: Bold, labelSmall with colored background
- **Dates**: bodySmall with icon
- **Duration**: labelSmall in container badge

### Animations
- Opacity transitions: 300ms
- Scale transitions: 300ms
- Smooth color changes on state update

---

## 🔌 Integration Points

### 1. Home Screen (Activity Section)
```dart
// In activity_section.dart
HorizontalActivityStepper(
  activities: activityState.activities,
  onStepTapped: (activity) => _showActivityDetail(...),
  onViewAllActivities: () => context.push(AppRoutes.viewAllActivities),
  selectedActivity: currentActivity,
)
```

### 2. View All Activities Page
```dart
// In view_all_activities_page.dart
VerticalActivityStepper(
  activities: sortedActivities,
  onActivityTapped: (activity) => _showActivityDetail(...),
)
```

### 3. Activity Detail Navigation
```dart
// Shows bottom sheet with activity info
// On "View Related Schedules" → navigates to RelatedSchedulePage
// with activity date range and filtering
```

### 4. Related Schedule Page
- Receives activity info (dates, day counts, activity name)
- Filters schedules by activity date range
- Shows schedule list filtered by type (All/Spray/Nutrition/Work)

---

## 🎬 User Flows

### Flow 1: Home Screen Activity Selection
1. User sees Horizontal Stepper on home screen
2. Taps any completed/current step
3. Selected activity card updates below
4. Can see current activity details at a glance

### Flow 2: View All Activities
1. User clicks "View All Activities" button
2. Navigates to new page with Vertical Stepper
3. See full timeline of all activities (sorted by sequence)
4. Tap any completed/current activity
5. Bottom sheet opens with activity details

### Flow 3: Activity → Related Schedules
1. From activity detail bottom sheet
2. Click "View Related Schedules"
3. Navigate to schedule list page
4. Schedules filtered by activity date range
5. Can filter by type (Spray/Nutrition/Work)
6. See related work for activity period

---

## 🚀 State Management

### Riverpod Providers Used
- `activityNotifierProvider`: Manages activity list state
- `plotNotifierProvider`: Manages selected plot
- `scheduleNotifierProvider`: Manages schedule filtering

### State Transitions
- **Activities Load**: On plot selection → loadActivities()
- **Activity Selection**: On step tap → _showActivityDetail()
- **Navigation**: On "View All" or "View Related" → push route with extras

---

## 📱 Responsive Design

### Mobile (< 600px)
- Horizontal stepper with scrollable indicators
- Single-column activity cards
- Soft shadow and spacing adjusted

### Tablet (> 600px)
- Larger step indicators (44px)
- More spacious layout
- Bigger fonts and padding

**Utils**: Uses `ResponsiveUtils` from `shared/responsive/responsive_utils.dart`

---

## ✨ Key Features

### 1. **Progress Visualization**
- Horizontal line shows completion progress
- Filled (indigo/green) up to current, grey after
- Visual hierarchy: completed > current > upcoming

### 2. **Interactive States**
- Completed: clickable, takes user to detail
- Current: clickable, highlighted with gradient
- Upcoming: disabled, grey, non-interactive

### 3. **Smart Filtering**
- Activities sorted by natural sequence (Cutting → Flooring → Formation → Harvesting → Dipping)
- Schedules filtered by activity date range
- Multiple category filters (All/Spray/Nutrition/Work)

### 4. **Beautiful Animations**
- Smooth opacity transitions
- Color shift on selection
- Scale transitions on tap
- Shadow depth changes

### 5. **Accessibility**
- Proper icon usage for all states
- Clear status badges
- Good contrast ratios (WCAG AA)
- Touch targets > 48dp

---

## 🔧 Customization

### Theme Customization
```dart
// In app_theme.dart
ActivityStepperTheme.light(colorScheme) // Customize look & feel
```

### Widget Properties
```dart
// Horizontal Stepper
HorizontalActivityStepper(
  activities: [...],
  onStepTapped: callback,
  onViewAllActivities: callback,
  selectedActivity: activity, // Optional, defaults to first
)

// Vertical Stepper
VerticalActivityStepper(
  activities: [...],
  onActivityTapped: callback,
  lineHeight: 2.0, // Customize connector line thickness
)

// Step Indicator
StepIndicator(
  state: StepState.current,
  stepNumber: 1,
  size: 40.0, // Custom size
  isClickable: true,
)
```

---

## 🧪 Testing Considerations

### Unit Tests
- `StepIndicator`: Verify state rendering and callbacks
- `ActivityCard`: Test activity data display
- State transitions in notifiers

### Widget Tests
- Horizontal stepper tap interactions
- Vertical stepper scrolling and selection
- Bottom sheet opening/closing
- Navigation to related schedules

### Integration Tests
- Full user flow: Home → Detail → Related Schedules
- Data consistency across pages
- Loading and error states

---

## 📊 Performance Optimizations

1. **Lazy Loading**: Schedules loaded on-demand
2. **Efficient Filtering**: Uses list filtering with type checks
3. **Memoization**: Activity sorting cached per state update
4. **Animated Opacity**: Uses `AnimatedOpacity` for smooth transitions
5. **SingleChildScrollView**: For long activity lists

---

## 🔒 Data Validation

- Activities sorted by type order (predefined sequence)
- Day count calculations with null safety
- Date range validation for schedule filtering
- Proper null checks for optional dates

---

## 📚 Dependencies

- `flutter_riverpod`: State management
- `go_router`: Navigation
- `Material 3`: Design system
- Built-in Flutter: animations, gestures, responsive

---

## 🎓 Code Standards Applied

✅ **Clean Architecture**: Separation of widget, provider, entity layers
✅ **SOLID Principles**: Single responsibility, Open/closed for extensions
✅ **Material 3**: Modern design tokens and components
✅ **Responsive Design**: Works on phones, tablets, web
✅ **Type Safety**: Full null safety, strong typing
✅ **Code Organization**: Logical file structure, clear imports
✅ **Documentation**: Comments for complex logic
✅ **Reusability**: Widgets work independently and composed

---

## 🚫 What Was Avoided

- ❌ Default Flutter Stepper widget (custom implementation)
- ❌ Hardcoded colors (using theme system)
- ❌ Magic numbers (using spacing constants)
- ❌ Overly complex state management (Riverpod locals)
- ❌ Accessibility issues (proper contrast, touch targets)

---

## 📝 Summary

This implementation provides a polished, production-ready Activity Stepper UI system that:

1. **Shows progress** clearly with horizontal stepper on home
2. **Details timeline** with vertical stepper on dedicated page
3. **Enables navigation** to related activities and schedules
4. **Maintains consistency** across Material 3 design system
5. **Supports responsiveness** on all device sizes
6. **Handles states** properly (loading, error, empty)
7. **Provides accessibility** with proper icons and contrast
8. **Follows architecture** with clean separation of concerns

The system is fully integrated with existing Riverpod providers and navigation, ready for production use.

---

**Last Updated**: 25 February 2026
**Status**: ✅ Complete & Ready for Use
