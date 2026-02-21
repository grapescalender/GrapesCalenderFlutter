# Production Refactoring Plan

## Issues Identified

### 1. Duplicate Files
- `lib/router/app_router.dart` vs `lib/config/router/app_router.dart`
- `lib/shared/widgets/app_buttons.dart` vs `lib/shared/widgets/app_button.dart`
- `lib/shared/widgets/plot_card.dart` vs `lib/features/home/presentation/widgets/plot_card.dart`
- `lib/shared/widgets/schedule_card.dart` vs `lib/features/schedule/presentation/widgets/schedule_card.dart`
- Old files: `main_old.dart`, `home_page_refactored.dart`, `home_page_simple.dart`

### 2. Missing Const Constructors
- Many widgets missing const constructors
- Need to add const where possible

### 3. Lint Rules
- Need stricter lint rules for production
- Add performance-related rules

### 4. Memory Optimization
- Check for proper disposal of controllers
- Use const widgets where possible
- Optimize image loading

### 5. Naming Conventions
- Ensure consistent naming
- Fix any violations

### 6. Code Reusability
- Extract duplicate code
- Create shared utilities

## Refactoring Steps

1. ✅ Consolidate duplicate router files
2. ✅ Remove duplicate widgets
3. ✅ Add const constructors
4. ✅ Update lint rules
5. ✅ Optimize memory usage
6. ✅ Fix naming conventions
7. ✅ Clean up old files
8. ✅ Verify all imports
