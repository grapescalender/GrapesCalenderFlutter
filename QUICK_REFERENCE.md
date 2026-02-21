# 🚀 QUICK REFERENCE - DRAKSHSETU

## Essential Commands

### 🔧 Setup
```bash
cd /Users/swapnil/Desktop/FlutterAppGrapes
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### ▶️ Run
```bash
# Default device
flutter run

# Release build
flutter run --release

# Specific device
flutter run -d <device_id>

# Get device list
flutter devices
```

### 📦 Build
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# List available build commands
flutter build --help
```

### 🧪 Test & Analyze
```bash
# Run all tests
flutter test

# Analyze code
flutter analyze

# Check dependencies
flutter pub outdated

# Format code
flutter format lib/
```

### 🔄 Code Generation
```bash
# Generate once
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate)
flutter pub run build_runner watch --delete-conflicting-outputs

# Clean generated files
flutter pub run build_runner clean
```

### 📱 Device Management
```bash
# List devices
flutter devices

# Launch emulator
flutter emulators --launch <emulator_id>

# Create emulator
flutter emulators create --name test_device

# Check device info
flutter devices -v
```

### 🐛 Debugging
```bash
# Run with verbose output
flutter run -v

# DevTools
dart devtools

# Profile performance
flutter run --profile

# Trace startup
flutter run -v --trace-startup > startup_trace.txt
```

## Project Navigation

### 📁 Key Directories
```
lib/
  core/                 # Core systems (theme, network, utils)
  features/             # Feature modules
  config/               # Global configuration
  shared/               # Shared components
assets/
  i18n/                 # Translations
  fonts/                # Custom fonts
  images/               # App images
```

### 🌐 Important URLs

| Resource | URL |
|----------|-----|
| Flutter | https://flutter.dev |
| Dart Docs | https://dart.dev |
| Pub.dev | https://pub.dev |
| Material 3 | https://m3.material.io |
| Riverpod | https://riverpod.dev |
| GoRouter | https://pub.dev/packages/go_router |

## File Reference

### Configuration Files
| File | Purpose |
|------|---------|
| `pubspec.yaml` | Dependencies & app info |
| `analysis_options.yaml` | Lint rules |
| `main.dart` | App entry point |

### Core Files
| File | Purpose |
|------|---------|
| `core/theme/app_theme.dart` | Theme setup |
| `core/network/dio_client.dart` | HTTP client |
| `core/localization/localization_service.dart` | i18n |
| `core/constants/app_constants.dart` | Constants |

### Feature Files
| Feature | Main Files |
|---------|-----------|
| Auth | `features/auth/presentation/pages/login_page.dart` |
| Home | `features/home/presentation/pages/home_page.dart` |
| Schedule | `features/schedule/presentation/pages/schedule_page.dart` |
| Activity | `features/activity/presentation/pages/activity_page.dart` |
| Profile | `features/profile/presentation/pages/profile_page.dart` |

## Documentation

### Read These First
1. **README.md** - Project overview
2. **SETUP.md** - Environment setup
3. **ARCHITECTURE.md** - Design patterns
4. **IMPLEMENTATION_GUIDE.md** - Next steps

### Reference Docs
- **PROJECT_INVENTORY.md** - File listing
- **DELIVERY_SUMMARY.md** - Completion status

## Localization

### Supported Languages
- English (en)
- Marathi (mr)
- Hindi (hi)

### Add Translation
1. Add key-value to `assets/i18n/en.json`
2. Add same key to `assets/i18n/mr.json` and `assets/i18n/hi.json`
3. Use: `localizationService.translate('key_name')`

### Change Language
```dart
await ref.read(languageProvider.notifier).setLanguage('mr');
```

## Theme Control

### Toggle Dark Mode
```dart
ref.read(themeModeProvider.notifier).toggleTheme();
```

### Check Current Theme
```dart
final isDark = ref.watch(themeModeProvider);
```

## Navigation

### Go to Route
```dart
GoRouter.of(context).go('/home');
```

### Named Routes
```dart
// Define in app_router.dart
GoRoute(path: '/home', name: 'home', ...)

// Navigate
context.goNamed('home');
```

### Routes Available
- `/login` - Login screen
- `/home` - Home dashboard
- `/schedule` - Schedule page
- `/activity` - Activity page
- `/profile` - Profile page

## State Management (Riverpod)

### Use Provider
```dart
final value = ref.watch(someProvider);
```

### Update State
```dart
ref.read(themeModeProvider.notifier).toggleTheme();
```

### Async Provider
```dart
final data = ref.watch(futureProvider);
// Handle: loading, data, error
```

## API Integration

### Network Client
```dart
final dio = ref.watch(dioClientProvider);
final response = await dio.get('/endpoint');
```

### Error Handling
```dart
try {
  // API call
} catch (e) {
  // Handle error
}
```

## Common Tasks

### Add New Page
1. Create file in `features/feature_name/presentation/pages/`
2. Add route in `lib/config/router/app_router.dart`
3. Import & register page

### Add New Model
1. Create in `features/feature_name/data/models/`
2. Use `@freezed` annotation
3. Run code generator

### Add New Provider
1. Create in `features/feature_name/presentation/providers/`
2. Define provider function
3. Use `ref.watch()` in UI

### Add Translation
1. Add key to all JSON files in `assets/i18n/`
2. Use `localizationService.translate('key')`
3. Rebuild app

## Troubleshooting Quick Fixes

### Dependencies Error
```bash
flutter clean
flutter pub get
```

### Build Failed
```bash
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

### Generated Code Missing
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### iOS Build Issues
```bash
cd ios
rm -rf Pods
pod install
cd ..
flutter run
```

### Hot Reload Not Working
- Press `R` to hot reload
- Press `F` for full restart
- Or: Stop and `flutter run` again

## Performance Tips

1. Use `const` constructors everywhere
2. Avoid rebuilding unnecessary widgets
3. Use `RepaintBoundary` for complex widgets
4. Profile with `flutter run --profile`
5. Check DevTools for performance issues

## Security Reminders

✅ Do:
- Store tokens in secure storage
- Use HTTPS for API calls
- Validate user input
- Handle errors gracefully
- Log errors (not sensitive data)

❌ Don't:
- Store passwords in plain text
- Commit API keys to git
- Log sensitive information
- Use deprecated APIs
- Ignore error handling

## File Size Optimization

### Check Build Size
```bash
flutter build apk --release
ls -lh build/app/outputs/flutter-apk/
```

### Reduce APK Size
- Remove unused assets
- Use ProGuard (Android)
- Strip symbols
- Remove unused packages

## Version Management

### Update Version
Edit `pubspec.yaml`:
```yaml
version: 1.0.0+1
# Format: version+build_number
```

### Create Git Tag
```bash
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

## Daily Development Workflow

```bash
# 1. Start watch mode for code generation
flutter pub run build_runner watch --delete-conflicting-outputs

# 2. In another terminal, run app in watch mode
flutter run

# 3. Code and save - hot reload happens automatically
# 4. For major changes, press R or F in terminal
# 5. Run tests
flutter test

# 6. Before commit
flutter analyze
flutter format lib/
```

## Pre-Commit Checklist

- [ ] No lint errors: `flutter analyze`
- [ ] Code formatted: `flutter format lib/`
- [ ] Tests pass: `flutter test`
- [ ] App runs: `flutter run`
- [ ] No console errors
- [ ] Dark mode works
- [ ] All languages work

## Emergency Commands

```bash
# Nuclear option - complete reset
flutter clean
rm -rf ios/Pods
rm -rf ios/Podfile.lock
flutter pub get
cd ios && pod install && cd ..
flutter pub run build_runner build --delete-conflicting-outputs
flutter run --release

# Check everything
flutter doctor
```

## Resource Links

### Documentation
- [README.md](README.md) - Overview
- [SETUP.md](SETUP.md) - Setup guide
- [ARCHITECTURE.md](ARCHITECTURE.md) - Architecture
- [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) - Next steps

### Official Docs
- [Flutter](https://flutter.dev)
- [Dart](https://dart.dev)
- [Riverpod](https://riverpod.dev)
- [GoRouter](https://pub.dev/packages/go_router)

---

**Quick Reference v1.0**
**Updated**: February 17, 2026
**For Drakshsetu v1.0.0**

💡 **Pro Tip**: Bookmark this file for quick access during development!
