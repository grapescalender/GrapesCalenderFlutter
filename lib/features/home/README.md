# Home Feature - Base Layout

## Overview

Home page base layout with modern, responsive UI skeleton. No business logic yet - pure UI components.

## Layout Structure

### 1. Header Section
- **Greeting**: "Good Morning" with user name
- **Action Buttons**: Notifications and Search icons
- **Farm Info Card**: Farm name, active plots count, with navigation arrow

### 2. Plots Section
- **Section Header**: "My Plots" with "View All" button
- **Horizontal Scrollable Cards**: 
  - Plot cards with name, status, location, area, last activity
  - Responsive width (75% on mobile, 40% on tablet)
  - Minimum width: 280px, Maximum: 400px

### 3. Schedule Section
- **Section Header**: "Upcoming Schedule" with "View All" button
- **Schedule Cards**: 
  - Type (Spray, Nutrition, Work)
  - Icon with color coding
  - Date and time
  - Navigation arrow

### 4. Activity Section
- **Section Header**: "Recent Activity" with "View All" button
- **Activity List**: 
  - Activity items with icons
  - Activity description
  - Plot and timestamp
  - Dividers between items

### 5. Bottom Navigation
- Handled by `MainShell` widget
- Already integrated in router

## Responsive Design

### Mobile (< 600px)
- Full-width sections
- Plot cards: 75% of screen width
- Standard padding: 16px

### Tablet (600px - 1200px)
- Centered content
- Plot cards: 40% of screen width
- Increased spacing

### Desktop (≥ 1200px)
- Centered content with max-width
- Optimized layout

## Components Used

### Design System
- `AppColors` - Color palette
- `AppSpacing` - Spacing system (8pt grid)
- `AppTypography` - Responsive typography

### Reusable Widgets
- `AppCard` - Card components
- `ResponsiveUtils` - Responsive utilities

## Section Details

### Header Section
```dart
- Greeting text
- User name
- Notification icon button
- Search icon button
- Farm info card with icon
```

### Plots Section
```dart
- Section title with "View All" button
- Horizontal ListView of plot cards
- Each card shows:
  * Plot name
  * Status badge (Active/Inactive)
  * Location
  * Area
  * Last activity date
```

### Schedule Section
```dart
- Section title with "View All" button
- Vertical list of schedule cards
- Each card shows:
  * Schedule type (Spray/Nutrition/Work)
  * Colored icon
  * Date and time
  * Navigation arrow
```

### Activity Section
```dart
- Section title with "View All" button
- Card with activity list
- Each item shows:
  * Activity icon
  * Activity description
  * Plot reference
  * Timestamp
```

## Placeholder Data

Currently using placeholder data:
- 3 plot cards
- 2 schedule cards
- 3 activity items

All TODO comments mark where logic will be added later.

## Navigation

Bottom navigation is handled by `MainShell` widget:
- Home (current)
- Schedule
- Activity
- Profile

## Styling

### Colors
- Primary: Emerald green
- Success: Green (for active status)
- Info: Blue (for spray)
- Warning: Amber (for nutrition)
- Surface variants for backgrounds

### Typography
- Headlines: For section titles
- Body: For content text
- Labels: For badges and small text
- Responsive sizing based on screen width

### Spacing
- Section spacing: 24px
- Card padding: 16px
- Screen padding: 16px horizontal
- Consistent 8pt grid system

## Future Enhancements

- [ ] Add state management (Riverpod)
- [ ] Connect to data sources
- [ ] Add pull-to-refresh
- [ ] Add empty states
- [ ] Add loading states
- [ ] Add error states
- [ ] Add navigation logic
- [ ] Add animations
- [ ] Add skeleton loaders

## File Structure

```
features/home/
└── presentation/
    └── pages/
        └── home_page.dart
```

## Usage

The home page is automatically displayed when navigating to `/home` route. It's wrapped in `MainShell` which provides the bottom navigation.

```dart
// In router
GoRoute(
  path: AppRoutes.home,
  name: 'home',
  builder: (context, state) => const HomePage(),
)
```

---

**This is a UI skeleton - ready for logic integration! 🎨**
