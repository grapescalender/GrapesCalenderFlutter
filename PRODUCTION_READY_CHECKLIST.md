# Production Ready Checklist

## ✅ Completed

### 1. Router Consolidation
- ✅ Removed duplicate `lib/router/app_router.dart`
- ✅ All imports updated to use `config/router/app_router.dart`
- ✅ Debug logging disabled for production

### 2. Lint Rules
- ✅ Updated `analysis_options.yaml` with strict rules
- ✅ Added strict type checking
- ✅ Enabled all performance-related rules

### 3. Code Quality
- ✅ Const constructors in most widgets
- ✅ Consistent naming conventions
- ✅ Proper error handling

## 📋 Remaining Tasks

### 4. Duplicate Widgets
- [ ] Check `app_button.dart` vs `app_buttons.dart` - decide which to keep
- [ ] Check `shared/widgets/plot_card.dart` vs `features/home/presentation/widgets/plot_card.dart`
- [ ] Check `shared/widgets/schedule_card.dart` vs `features/schedule/presentation/widgets/schedule_card.dart`
- [ ] Remove unused duplicates

### 5. Old Files
- [ ] Remove `lib/main_old.dart`
- [ ] Remove `lib/features/home/presentation/pages/home_page_refactored.dart`
- [ ] Remove `lib/features/home/presentation/pages/home_page_simple.dart`

### 6. Const Constructors
- [ ] Audit all widgets for missing const
- [ ] Add const where possible

### 7. Memory Optimization
- [ ] Verify all controllers are disposed
- [ ] Check for memory leaks
- [ ] Optimize image loading

### 8. Build Verification
- [ ] Run `flutter analyze` and fix all issues
- [ ] Run `flutter build apk --release` (Android)
- [ ] Run `flutter build ios --release` (iOS)
- [ ] Test on real devices

## 🎯 Production Build Commands

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Verification
```bash
flutter analyze
flutter test
```

## 📝 Notes

- All router imports now use `config/router/app_router.dart`
- Lint rules are production-ready
- Need to verify no circular dependencies
- Need to ensure all imports resolve correctly
