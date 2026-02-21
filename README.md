# Drakshsetu - Grape Farm Management App

A production-ready Flutter application for grape farmers with comprehensive farm management capabilities.

## Features

### ✨ Core Functionality
- **Authentication**: Secure login with JWT token storage
- **Plot Management**: Manage multiple grape plots with running status tracking
- **Schedule Management**: Spray, nutrition, and work scheduling
- **Activity Tracking**: Sequential lifecycle activities (Pruning → Harvesting → Dipping)
- **Calendar View**: Visual schedule with running day indicators
- **Multi-language Support**: English, Marathi, and Hindi
- **Dark Mode**: Full light and dark theme support
- **Responsive Design**: Optimized for mobile, tablet, and desktop

### 📱 Platform Support
- ✅ Android (APK)
- ✅ iOS
- ✅ Responsive across devices

### 🎨 Design System
- Material 3 design
- Agriculture-themed green accent colors
- Smooth animations
- Accessible components

## Project Structure

```
lib/
├── config/
│   ├── providers/        # Global Riverpod providers
│   └── router/          # GoRouter configuration
├── core/
│   ├── constants/       # App-wide constants
│   ├── localization/    # Localization service
│   ├── network/         # Dio HTTP client & interceptors
│   ├── theme/          # Material 3 theme setup
│   └── utils/          # Utility functions
├── features/
│   ├── auth/           # Authentication feature
│   ├── home/           # Home dashboard
│   ├── schedule/       # Schedule management
│   ├── activity/       # Activity tracking
│   └── profile/        # User profile
├── shared/
│   ├── models/         # Shared data models
│   └── widgets/        # Reusable widgets
└── main.dart           # App entry point
```

## Tech Stack

| Category | Technology | Version |
|----------|-----------|---------|
| Framework | Flutter | 3.x |
| Language | Dart | 3.2+ |
| State Management | Riverpod | 2.5.1 |
| Routing | GoRouter | 13.2.1 |
| Networking | Dio | 5.4.2 |
| Models | Freezed | 2.4.7 |
| Localization | intl | 0.19.0 |
| Security | Flutter Secure Storage | 9.0.0 |
| UI Framework | Material 3 | - |
| Responsive | Responsive Framework | 1.1.0 |

## Getting Started

### Prerequisites
- Flutter SDK (3.x)
- Dart SDK (3.2+)
- Xcode (for iOS)
- Android Studio (for Android)

### Installation

1. **Clone the repository**
```bash
cd /Users/swapnil/Desktop/FlutterAppGrapes
```

2. **Get dependencies**
```bash
flutter pub get
```

3. **Generate code (Freezed, JSON serialization)**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Run the app**

   **Development:**
   ```bash
   flutter run
   ```

   **iOS:**
   ```bash
   flutter run -d iphone
   # or
   flutter run -d "iPhone 15 Pro"
   ```

   **Android:**
   ```bash
   flutter run -d android
   # or
   flutter devices  # to see available devices
   ```

### Build APK/iOS

**Android APK:**
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

**Android App Bundle (Play Store):**
```bash
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
# Then use Xcode to upload to App Store
open ios/Runner.xcworkspace
```

## Configuration

### API Configuration
Update API base URL in `lib/core/constants/app_constants.dart`:
```dart
static const String apiBaseUrl = 'https://your-api-url.com/v1';
```

### Localization
Supported languages in `lib/core/localization/localization_service.dart`:
- English (en)
- Marathi (mr)
- Hindi (hi)

Add translations in `assets/i18n/{language}.json`

### Theme Customization
Modify colors in `lib/core/theme/app_theme.dart`:
```dart
static const Color primaryGreen = Color(0xFF2E7D32);
static const Color accentGreen = Color(0xFF66BB6A);
```

## Architecture

### Clean Architecture with Feature-First Module Structure

**Layers:**
1. **Presentation Layer**: UI components, pages, widgets, providers
2. **Domain Layer**: Business logic, use cases, entity models
3. **Data Layer**: Repositories, data sources, API clients, local storage

**Each Feature Contains:**
```
feature/
├── data/
│   ├── datasources/      # Remote & local data sources
│   ├── models/           # Data models (Freezed)
│   └── repositories/     # Repository implementations
├── domain/
│   └── entities/         # Domain models
└── presentation/
    ├── pages/            # Full screens
    ├── providers/        # Riverpod providers
    └── widgets/          # Feature-specific widgets
```

### State Management (Riverpod)

**Provider Types Used:**
- `StateNotifierProvider`: Mutable state
- `FutureProvider`: Async operations
- `Provider`: Computed/derived state
- `StateProvider`: Simple state

**Example:**
```dart
final userProvider = FutureProvider((ref) async {
  return await ref.watch(authRepositoryProvider).getUser();
});
```

## API Integration

### Network Layer (Dio)

**Interceptors:**
- Token Interceptor: Automatically attaches JWT token
- Error Handling Interceptor: Centralized error handling
- Logging Interceptor: Development logging

**Usage:**
```dart
final response = await ref.watch(dioClientProvider).get('/plots');
```

## Localization

### Adding New Strings
1. Add key-value pair to all JSON files in `assets/i18n/`
2. Use in widgets:
```dart
final localizations = ref.watch(localizationServiceProvider);
final text = localizations.translate('key_name');
```

### Language Switching
```dart
await ref.read(languageProvider.notifier).setLanguage('mr');
```

## Dark Mode

Toggle dark mode:
```dart
ref.read(themeModeProvider.notifier).toggleTheme();
```

Check current theme:
```dart
final isDark = ref.watch(themeModeProvider);
```

## Responsive Design

Use `ResponsiveBuilder` for responsive layouts:
```dart
ResponsiveBuilder(
  builder: (context, constraints, deviceType) {
    if (deviceType == DeviceType.mobile) {
      return MobileLayout();
    } else if (deviceType == DeviceType.tablet) {
      return TabletLayout();
    }
    return DesktopLayout();
  },
)
```

## Security

### Token Management
- JWT tokens stored in `FlutterSecureStorage`
- Automatic token attachment via Dio interceptor
- Token refresh on 401 response

### Best Practices
- Sensitive data encrypted in secure storage
- API calls via HTTPS only
- Input validation on all forms
- SQL injection prevention (using ORM)

## Performance Optimization

1. **Image Caching**: Using `cached_network_image`
2. **Lazy Loading**: Pagination for large lists
3. **Code Splitting**: Feature-based modular structure
4. **State Caching**: Riverpod auto-caching
5. **Efficient Rebuilds**: Strategic Provider placement

## Testing

### Unit Tests
```bash
flutter test test/
```

### Widget Tests
```bash
flutter test test/features/
```

### Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

## Deployment

### Play Store
1. Create app in Google Play Console
2. Build release APK/bundle
3. Upload and configure
4. Submit for review

### App Store
1. Create app in App Store Connect
2. Build iOS release
3. Upload with Xcode
4. Submit for review

## Troubleshooting

### Dependencies Issue
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### iOS Build Issues
```bash
cd ios
pod repo update
pod install
cd ..
```

### Freezed Code Generation
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

## Development Guidelines

### Code Style
- Follow Dart style guide
- Use meaningful variable names
- Add documentation comments
- Use const constructors
- Organize imports alphabetically

### Git Workflow
```bash
git checkout -b feature/feature-name
# Make changes
git commit -m "feat: add feature description"
git push origin feature/feature-name
```

### Commit Messages
- `feat:` New feature
- `fix:` Bug fix
- `refactor:` Code refactoring
- `style:` Code style changes
- `docs:` Documentation
- `test:` Adding tests

## Production Checklist

- [ ] All tests passing
- [ ] No console errors/warnings
- [ ] API endpoint verified
- [ ] Localization complete for all languages
- [ ] Dark mode tested
- [ ] Responsive design verified on multiple devices
- [ ] Performance profiling done
- [ ] Security audit completed
- [ ] Privacy policy added
- [ ] Terms of service added
- [ ] Appropriate permissions set
- [ ] Screenshots for app stores

## Contributing

1. Fork the repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Create Pull Request

## Support

For issues and questions:
- GitHub Issues
- Email: support@drakshsetu.com
- Documentation: [Wiki Link]

## License

This project is licensed under the MIT License - see LICENSE file for details.

## Changelog

### Version 1.0.0 (Initial Release)
- Initial app setup with all core features
- Authentication system
- Plot management
- Schedule management
- Activity tracking
- Multi-language support
- Dark mode support
- Responsive design

---

**Built with ❤️ for Grape Farmers**
