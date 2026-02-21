# Home Widgets

## Plots Section Components

### PlotsSection
Main widget that orchestrates the horizontal scrolling plot cards section.

**Features:**
- Horizontal scrolling plot cards
- Sorting (High to Low / Low to High)
- First plot selected by default
- Add/Start Plot card at the end
- Responsive design

### PlotCard
Individual plot card widget.

**Displays:**
- Plot name
- Pruning date (formatted)
- Days since pruning (highlighted)
- Running status badge
- Animated selection effect

**Selection:**
- Visual highlight with border and background color
- Smooth animation on selection change

### AddPlotCard
Card for adding new plots or starting plots.

**States:**
- "Add Running Plot" - when there are running plots
- "Start Plot" - when no running plots exist
- Disabled state - when all plots are running

## State Management

### PlotState (Freezed)
```dart
- plots: List<PlotEntity>
- selectedPlotId: String?
- sortOrder: PlotSortOrder
- isLoading: bool
- errorMessage: String?
```

### PlotNotifier
Manages plot state and business logic:
- Loads plots (currently mock data)
- Selects plot
- Toggles sort order
- Filters running plots
- Checks if all plots are running

## Usage

```dart
// In home page
PlotsSection()

// The section automatically:
// - Loads plots
// - Selects first plot
// - Handles sorting
// - Shows appropriate add card
```

## Code Generation

Run code generation for Freezed files:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate:
- `plot_state.freezed.dart`

## Features

✅ Horizontal scrolling
✅ Plot selection with animation
✅ Sorting (High to Low / Low to High)
✅ Dynamic day count calculation
✅ Add/Start Plot card logic
✅ Responsive design
✅ Modern, clean UI
