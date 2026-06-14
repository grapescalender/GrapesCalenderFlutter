# Activity Stepper – Visual Design Specification

## 📐 Design Tokens

### Color Palette

#### Semantic Colors
| State | Primary Color | Icon | Background | Border |
|-------|--------------|------|------------|--------|
| **Completed** | `#2E7D32` (Green) | ✅ Check | `rgba(46, 125, 50, 0.14)` | `rgba(46, 125, 50, 0.3)` |
| **Current** | `#3F51B5` (Indigo) | ⚫ Number | `rgba(63, 81, 181, 0.08)` | `rgba(63, 81, 181, 0.3)` |
| **Upcoming** | `#9E9E9E` (Grey) | ⭕ Number | `transparent` | `rgba(158, 158, 158, 0.3)` |

#### Spacing
```
xs    = 4px    (Icon spacing)
sm    = 8px    (Element padding)
md    = 16px   (Standard spacing)
lg    = 24px   (Section spacing)
xl    = 32px   (Large spacing)
xxl   = 40px   (Extra large)
```

#### Border Radius
```
radiusXs  = 4px   (Badges, small elements)
radiusSm  = 8px   (Buttons)
radiusMd  = 12px  (Inputs)
radiusLg  = 16px  (Cards, major elements)
radiusHuge = 24px (Bottom sheets, modals)
radiusFull = 999px (Pills, circles)
```

---

## 📱 Screen Layouts

### 1. Home Screen – Horizontal Stepper

```
┌─────────────────────────────────────────────────────────────┐
│                        HOME SCREEN                          │
├─────────────────────────────────────────────────────────────┤
│  ≡ Header (Gradient Background)                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  [🌾 Plot Name]                                           │
│                                                             │
│ ─ Section Header "Activities" ────────────────────────     │
│                                                             │
│ ┌─ Horizontal Stepper ──────────────────────────────────┐  │
│ │                                                       │  │
│ │  ⑤──③──②──①──⚬                                       │  │
│ │  ✓ ✓  ✓  ⊙  ○                                        │  │
│ │  (Scrollable →)                                      │  │
│ │                                                       │  │
│ │        [View All Activities →]                       │  │
│ └─────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌─ Selected Activity Card ──────────────────────────────┐ │
│  │                                                       │ │
│  │  🌾 Formation                    [ACTIVE]            │ │
│  │  Farm Plot A                                        │ │
│  │                                                       │ │
│  │  📅 Mar 10 → Mar 24                                 │ │
│  │  [Day 11 - Day 25]                                  │ │
│  │                                                       │ │
│  └─────────────────────────────────────────────────────┘ │
│                                                             │
│  ┌─ Schedule Section ──────────────────────────────────┐  │
│  │  ... (Schedule cards below)                         │  │
│  └─────────────────────────────────────────────────────┘  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Key Dimensions**:
- Step indicators: 36px circles
- Connector lines: 30px width, 2px height
- Card padding: 16px
- Border radius: 16px
- Shadow: Soft (2px offset, 4px blur)

---

### 2. View All Activities – Vertical Stepper

```
┌─────────────────────────────────────────────────────────────┐
│  ← All Activities                                           │
├─────────────────────────────────────────────────────────────┤
│  🌾 Farm Plot A                                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│ ① Activity Timeline                                        │
│ ─────────────────────────────────────────────────────────  │
│                                                             │
│   @  ┌─ Cutting Card ─────────────────────────────────┐   │
│  ✓   │  🔪 Cutting              [COMPLETED]          │   │
│  │   │  Farm Plot A                                  │   │
│  │   │  📅 Mar 01 → Mar 09                            │   │
│  │   │  [Day 1 - Day 9]                              │   │
│  │   └─────────────────────────────────────────────┘   │
│  │                                                       │
│  │   ┌─ Flooring Card ────────────────────────────────┐  │
│  │   │  🌱 Flooring                                  │  │
│  │   │  Farm Plot A                                  │  │
│  │   │  📅 Mar 10 → Mar 12                           │  │
│  │   │  [Day 10 - Day 12]                            │  │
│  │   └─────────────────────────────────────────────┘  │
│  │                                                       │
│  ⊙  ┌─ Formation Card (SELECTED) ─────────────────────┐  │
│  │   │  🏗️ Formation              [ACTIVE]            │  │
│  │   │  Farm Plot A                                  │  │
│  │   │  📅 Mar 13 → (today)                          │  │
│  │   │  [Day 13 - Day 25] (highlighted)              │  │
│  │   └─────────────────────────────────────────────┘  │
│  │                                                       │
│  │   ┌─ Harvesting Card ─────────────────────────────┐  │
│  ○   │  🌾 Harvesting            [PENDING - DISABLED]│  │
│      │  Farm Plot A                                  │  │
│      │  📅 Apr 01 → Apr 15                           │  │
│      │  [Day 26 - Day 40]                            │  │
│      └─────────────────────────────────────────────┘  │
│                                                         │
│      ┌─ Dipping Card ─────────────────────────────────┐ │
│      │  💧 Dipping               [PENDING - DISABLED]│ │
│      │  Farm Plot A                                  │ │
│      │  📅 Apr 16 → Apr 30                           │ │
│      │  [Day 41 - Day 55]                            │ │
│      └─────────────────────────────────────────────┘ │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**Key Dimensions**:
- Step indicators: 44px circles
- Connector lines: 2px width, 60px height
- Card padding: 16px
- Border radius: 16px
- Card height: ~120px
- Shadow: Elevated (8px offset, 12px blur for selected)

---

### 3. Activity Detail Bottom Sheet

```
┌─────────────────────────────────────────────┐
│                                             │
│  ═══════════════════════════════════════    │ ← Handle bar
│                                             │
│  ┌─ Header (Gradient Background) ────────┐ │
│  │                                      │ │
│  │  ┌──────────┐                        │ │
│  │  │    🏗️    │  Formation        ✕   │ │
│  │  │ (Gradient)│                        │ │
│  │  │ Border   │  [IN PROGRESS]          │ │
│  │  └──────────┘  (With border)          │ │
│  │                                      │ │
│  └──────────────────────────────────────┘ │
│                                           │
│ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │
│                                           │
│ ⏱️  Duration: 13 days                     │
│    [Small badge]                         │
│                                           │
│ ▶  Start Date                             │
│    Mar 13, 2026 (Day 13)                 │
│                                           │
│ ⏱  End Date                              │
│    Today (Day 25)                        │
│                                           │
│ 🌾 Plot                                  │
│    Farm Plot A                           │
│                                           │
│ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │
│                                           │
│  [View Related Schedules →]               │
│  (Full width button)                     │
│                                           │
└─────────────────────────────────────────────┘
```

**Key Dimensions**:
- Icon container: 56px × 56px
- Handle bar: 40px width, 4px height
- Content padding: 16px
- Button height: 48px
- Border radius header: 16px
- Border radius button: 8px

---

## 🎨 Component Design Details

### Step Indicator States

#### Completed State
```
      ✅
    ┌────┐
    │ ✓  │  Green (#2E7D32)
    └────┘
  Box shadow for depth
```

#### Current State
```
      ⊙
    ┌────┐
    │ 3  │  Indigo (#3F51B5)
    └────┘  White text/icon
  Box shadow (stronger)
  Highlight effect
```

#### Upcoming State
```
      ⭕
    ┌────┐
    │ 4  │  Grey border (#9E9E9E)
    └────┘  Grey text
  No shadow
  Outlined style
```

---

### Activity Card States

#### Completed Card
```
┌─────────────────────────────┐
│ 🔪 Cutting         [✓ COMPL]│
│ Farm Plot A                 │
│ 📅 Mar 01 → Mar 09          │
│ [Day 1 - Day 9]             │
└─────────────────────────────┘
Light grey background
Normal transparency
```

#### Current/Selected Card
```
╔═════════════════════════════╗ ← Indigo border
║ 🏗️ Formation        [⊙ ACTIVE]║
║ Farm Plot A                 ║
║ 📅 Mar 13 → (today)          ║
║ [Day 13 - Day 25]           ║
╚═════════════════════════════╝
Gradient background (Indigo → Blue)
Enhanced shadow
Border: 2px Indigo with opacity
```

#### Upcoming Card
```
┌─────────────────────────────┐
│ 🌾 Harvesting       [○ PEND] │
│ Farm Plot A                 │
│ 📅 Apr 01 → Apr 15          │
│ [Day 26 - Day 40]           │
└─────────────────────────────┘
Very light/faded
Opacity: 0.6
Non-interactive
```

---

## 📊 Typography Hierarchy

| Element | Style | Size | Weight | Color |
|---------|-------|------|--------|-------|
| Activity Name | labelLarge | 14px | 600 | Primary |
| Plot Name | bodySmall | 12px | 400 | SurfaceVariant |
| Date Range | bodySmall | 12px | 400 | SurfaceVariant |
| Day Count Badge | labelSmall | 12px | 500 | SurfaceVariant |
| Status Badge | labelSmall | 12px | 600 | Dynamic |
| Header Title | headlineMedium | 20px | 600 | Primary (if current) |
| Header Subtitle | bodyMedium | 14px | 400 | OnSurface |

---

## ✨ Animation Specifications

### Tap/Selection Animation
```
Duration: 300ms
Easing: Curves.easeInOut

Changes:
- Opacity: 1.0 → 0.8 (disabled) or 1.0 (enabled)
- Border: Gray → Indigo (2px)
- Shadow: Light → Enhanced
- Background: Transparent → Gradient
- Scale: 1.0 → 1.02 (very subtle)
```

### Step State Change Animation
```
Duration: 300ms
Easing: Curves.easeOut

Changes:
- Icon morphing (check/number)
- Color transition
- Shadow adjustment
- Border animation
```

### Progress Line Fill
```
Duration: 500ms
Easing: Curves.easeInOut

Changes:
- Line color: Grey → Indigo/Green
- Width reduction as steps complete
```

---

## 🎯 Spacing & Layout Grid

### 8pt Grid System
```
All spacing is a multiple of 8px:
- 4px  = xs   (Half unit)
- 8px  = sm   (1 unit)
- 12px = smMd (1.5 units)
- 16px = md   (2 units) ← Standard
- 20px = mdLg (2.5 units)
- 24px = lg   (3 units)
- 32px = xl   (4 units)
- 40px = xxl  (5 units)
- 48px = huge (6 units)
```

### Common Padding
```
Screen edges:      16px (screenHorizontal)
Card internal:     16px (cardPadding)
Button padding:    24px horizontal, 12px vertical
List item spacing: 12px (listItemSpacing)
Icon spacing:      8px (iconSpacing)
```

---

## 🌓 Dark Mode

### Color Adjustments
| Component | Light | Dark |
|-----------|-------|------|
| Completed | Green #2E7D32 | Green #66BB6A |
| Current | Indigo #3F51B5 | Indigo #5C6BC0 |
| Background | White | Dark surface |
| Card | White | Dark surface + elevation |
| Text | OnSurface | OnSurface(inverted) |
| Border | 0.2 opacity | 0.3 opacity |

### Shadow Adjustments
- Light: Soft shadows (0.06-0.08 opacity)
- Dark: Stronger shadows (0.3-0.5 opacity)

---

## 📏 Responsive Breakpoints

### Mobile (< 600px)
```
- Step indicators: 36px
- Connector height: 50px
- Padding: 16px
- Card height: ~100px
- Font sizes: Standard
- Single column layout
```

### Tablet (≥ 600px)
```
- Step indicators: 44px
- Connector height: 70px
- Padding: 20px
- Card height: ~130px
- Font sizes: +2px
- Can adapt to 2-column
```

---

## ♿ Accessibility

### Color Contrast
- Text on colored background: ≥ 4.5:1
- Border on background: ≥ 3:1
- Icons on colored: ≥ 4.5:1

### Touch Targets
- Minimum 48dp × 48dp
- Step indicators: 36-44px ✓
- Cards: Full width ✓
- Buttons: 48px height ✓

### Focus States
- Visible focus ring around tappable elements
- Color change on focus
- Clear indication of active state

---

## 📚 Icon Library

| Activity | Icon | Color(Completed) | Color(Current) |
|----------|------|------------------|----------------|
| Cutting | `Icons.content_cut` | Green | Indigo |
| Flooring | `Icons.landscape` | Green | Indigo |
| Formation | `Icons.agriculture` | Green | Indigo |
| Harvesting | `Icons.eco` | Green | Indigo |
| Dipping | `Icons.water_drop` | Green | Indigo |

---

## 🔄 Interaction Patterns

### Horizontal Stepper Interaction
```
Click On Step:
1. If completed/current → Tap enabled ✓
2. If upcoming → Tap disabled (visual feedback)
3. Card below updates with new activity
4. Animation plays (300ms)
```

### Vertical Stepper Interaction
```
Click On Card:
1. If completed/current → Bottom sheet opens
2. If upcoming → No action (disabled opacity)
3. Show activity details with day counts
4. Enable "View Related Schedules" button
```

### Bottom Sheet Interaction
```
Bottom Sheet Opens:
1. Slide up from bottom (animation)
2. Display activity details
3. Show button to view related schedules
4. On button click: close → navigate to schedules page
```

---

## 📐 Final Specifications Summary

| Aspect | Value |
|--------|-------|
| **Design System** | Material 3 |
| **Primary Color** | Indigo (#3F51B5) |
| **Secondary Color** | Blue (#2196F3) |
| **Success Color** | Green (#2E7D32) |
| **Border Radius** | 16px (cards) |
| **Standard Padding** | 16px |
| **Shadow System** | Material 3 elevation |
| **Animation Duration** | 300ms (state), 500ms (line) |
| **Grid Base** | 8px |
| **Min touch target** | 48dp × 48dp |

---

**Version**: 1.0  
**Design System**: Material 3 + Custom Extensions  
**Status**: ✅ Approved for Implementation
