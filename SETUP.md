# Development Setup Guide for Drakshsetu

## Quick Start

### 1. Initial Setup

```bash
# Navigate to project directory
cd /Users/swapnil/Desktop/FlutterAppGrapes

# Get Flutter version info
flutter --version

# Clean previous builds
flutter clean

# Get all dependencies
flutter pub get

# Generate code for Freezed and JSON serialization
flutter pub run build_runner build --delete-conflicting-outputs

# (Alternative: use watch mode for development)
flutter pub run build_runner watch --delete-conflicting-outputs
```

### 2. Run the App

```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device_id>

# Run with specific flavor/profile
flutter run --debug

# Run release build
flutter run --release
```

### 3. Generate Builds

#### Android APK
```bash
# Debug APK
flutter build apk

# Release APK
flutter build apk --release

# APK output: build/app/outputs/flutter-apk/app-release.apk
```

#### Android App Bundle
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

#### iOS
```bash
# Build iOS app
flutter build ios --release

# Open Xcode workspace
open ios/Runner.xcworkspace

# Then archive and upload from Xcode
```

## Project Configuration

### AndroidManifest.xml
Ensure permissions are set:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### Info.plist (iOS)
Ensure required entries:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

## Environment Variables

Create `.env` file (if using flutter_dotenv):
```
API_URL=https://api.drakshsetu.com/v1
API_TIMEOUT=30
```

Load in main.dart:
```dart
await dotenv.load(fileName: ".env");
```

## Package Management

### Add a New Package
```bash
flutter pub add package_name
# or for dev dependency
flutter pub add --dev package_name
```

### Update Packages
```bash
# Get latest versions
flutter pub upgrade

# Update specific package
flutter pub upgrade package_name
```

### Remove Package
```bash
flutter pub remove package_name
```

## Code Generation

### Generate All
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Watch Mode (Auto-regenerate on file change)
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Clean Generated Files
```bash
flutter pub run build_runner clean
```

## Testing

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/features/auth/login_test.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
lcov --list coverage/lcov.info
```

## Performance & Profiling

### Run with DevTools
```bash
# Start DevTools
dart devtools

# Or let Flutter start it
flutter run --devtools-server-address http://localhost:9100
```

### Profile Performance
```bash
flutter run --profile
```

### Trace Janky Frames
```bash
flutter run -v --trace-startup
```

## Debugging

### Enable Debug Logging
In main.dart:
```dart
void main() {
  // Enable logging
  Logger().level = Level.debug;
  runApp(const DrakshsetuApp());
}
```

### Flutter DevTools
```bash
# DevTools includes:
# - Widget Inspector
# - Performance View
# - CPU Profiler
# - Memory View
# - Network Tab
# - Logging View
flutter run
# Then press 'd' for DevTools URL
```

### Dart DevTools
```bash
dart devtools
```

## Common Issues

### Issue: Pods not found (iOS)
```bash
cd ios
rm -rf Pods
pod repo update
pod install
cd ..
```

### Issue: Build cache issues
```bash
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: Android build fails
```bash
# Update gradle
./gradlew --version

# Clean gradle
cd android
./gradlew clean
cd ..

flutter build apk --release
```

### Issue: Freezed not generating
```bash
# Watch mode to see errors
flutter pub run build_runner watch --delete-conflicting-outputs

# Check for syntax errors in freezed classes
```

## IDE Setup

### VS Code Extensions
```json
{
  "recommendations": [
    "Dart-Code.dart-code",
    "Dart-Code.flutter",
    "Dart-Code.extension-pack-for-flutter",
    "ms-vscode.cpptools",
    "esbenp.prettier-vscode"
  ]
}
```

### Android Studio
- Install Flutter plugin
- Install Dart plugin
- Configure Flutter SDK path

### Xcode (for iOS)
```bash
# Install Xcode
xcode-select --install

# Accept license
sudo xcode-select --switch /Applications/Xcode.app/xcode-select --reset
```

## Git Workflow

### Initial Setup
```bash
git init
git add .
git commit -m "Initial commit: Drakshsetu app setup"
```

### Feature Development
```bash
# Create feature branch
git checkout -b feature/plot-management

# Make changes and commit
git add .
git commit -m "feat: add plot management screen"

# Push to remote
git push origin feature/plot-management

# Create Pull Request
```

## Documentation Generation

### Generate API Docs
```bash
dartdoc
# Docs will be in doc/api/index.html
```

## Release Management

### Version Update
Update in pubspec.yaml:
```yaml
version: 1.0.1+2
# Format: version+build_number
```

### Create Release Tag
```bash
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

## Continuous Integration

### GitHub Actions Example
Create `.github/workflows/build.yml`:
```yaml
name: Build

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter pub run build_runner build --delete-conflicting-outputs
      - run: flutter build apk --release
```

## Useful Commands Reference

| Command | Purpose |
|---------|---------|
| `flutter doctor` | Check environment setup |
| `flutter devices` | List connected devices |
| `flutter run` | Run app on default device |
| `flutter run -d <id>` | Run on specific device |
| `flutter pub get` | Get dependencies |
| `flutter pub run build_runner build` | Generate code |
| `flutter test` | Run tests |
| `flutter analyze` | Lint code |
| `flutter format lib/` | Format code |
| `flutter clean` | Clean build files |
| `flutter build apk` | Build Android APK |
| `flutter build ios` | Build iOS app |

## Resources

- [Flutter Official Docs](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Riverpod Documentation](https://riverpod.dev)
- [GoRouter Guide](https://pub.dev/packages/go_router)
- [Material 3 Guide](https://m3.material.io/)
- [Flutter Performance](https://flutter.dev/docs/perf)

---

**Happy Coding! 🚀**
