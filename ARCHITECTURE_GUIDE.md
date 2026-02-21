# Clean Architecture Guide

## Overview

This Flutter application follows **Clean Architecture** principles with a **feature-first** folder structure. The architecture is designed to be scalable, maintainable, and testable.

## Folder Structure

```
lib/
├── core/                    # Core functionality shared across features
│   ├── constants/          # App-wide constants
│   ├── di/                 # Dependency injection setup
│   ├── error/              # Error handling (failures, exceptions)
│   ├── localization/       # Localization infrastructure
│   ├── network/            # Network layer (Dio, network info)
│   ├── theme/              # Theme configuration
│   ├── usecase/            # Base use case interfaces
│   └── utils/              # Utility functions
│
├── features/               # Feature modules (feature-first structure)
│   ├── auth/               # Authentication feature
│   │   ├── data/           # Data layer
│   │   │   ├── datasources/    # Remote & local data sources
│   │   │   ├── models/         # Data models (Freezed)
│   │   │   ├── mappers/        # Entity ↔ Model mappers
│   │   │   └── repositories/   # Repository implementations
│   │   ├── domain/         # Domain layer (business logic)
│   │   │   ├── entities/       # Domain entities
│   │   │   ├── repositories/   # Repository interfaces
│   │   │   └── usecases/        # Use cases
│   │   └── presentation/   # Presentation layer (UI)
│   │       ├── pages/          # Screen widgets
│   │       ├── providers/      # Riverpod providers & notifiers
│   │       └── widgets/        # Feature-specific widgets
│   │
│   ├── home/               # Home feature
│   ├── schedule/            # Schedule feature
│   └── profile/            # Profile feature
│
├── router/                 # Navigation configuration (GoRouter)
│   └── app_router.dart
│
├── shared/                 # Shared components across features
│   ├── models/             # Shared models
│   ├── responsive/         # Responsive utilities
│   └── widgets/            # Reusable widgets
│
├── theme/                  # Theme configuration
│   ├── app_theme.dart
│   └── app_theme_provider.dart
│
└── main.dart               # App entry point
```

## Layer Responsibilities

### 1. Domain Layer (Business Logic)
**Location:** `features/{feature}/domain/`

- **Entities**: Pure Dart classes representing business objects
- **Repositories**: Interfaces defining data operations (contracts)
- **Use Cases**: Business logic operations (single responsibility)

**Rules:**
- No dependencies on Flutter or external frameworks
- Pure Dart code
- Defines what the app needs, not how to implement it

**Example:**
```dart
// domain/entities/user_entity.dart
class UserEntity {
  final String id;
  final String email;
  // ... pure Dart class
}

// domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String username, String password);
}

// domain/usecases/login_usecase.dart
class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;
  // ... business logic
}
```

### 2. Data Layer (Data Sources & Implementation)
**Location:** `features/{feature}/data/`

- **Data Sources**: Remote (API) and Local (cache/database) implementations
- **Models**: Freezed classes for JSON serialization
- **Mappers**: Convert between Models (data) and Entities (domain)
- **Repository Implementations**: Concrete implementations of domain repositories

**Rules:**
- Handles all data operations (API calls, local storage)
- Converts external data formats to domain entities
- Implements repository interfaces from domain layer

**Example:**
```dart
// data/models/user_model.dart
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
  }) = _UserModel;
  
  factory UserModel.fromJson(Map<String, dynamic> json) => ...
}

// data/datasources/auth_remote_datasource.dart
abstract class AuthRemoteDataSource {
  Future<UserModel> login(String username, String password);
}

// data/mappers/user_mapper.dart
class UserMapper {
  static UserEntity toEntity(UserModel model) { ... }
  static UserModel toModel(UserEntity entity) { ... }
}

// data/repositories/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  // ... implements domain repository interface
}
```

### 3. Presentation Layer (UI & State Management)
**Location:** `features/{feature}/presentation/`

- **Pages**: Screen widgets
- **Providers**: Riverpod providers for state management
- **Widgets**: Feature-specific UI components

**Rules:**
- Depends on domain layer (use cases, entities)
- Uses Riverpod for state management
- UI components are reactive to state changes

**Example:**
```dart
// presentation/providers/auth_providers.dart
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final loginUseCase = ref.watch(loginUseCaseProvider);
  return AuthNotifier(loginUseCase);
});

// presentation/providers/auth_notifier.dart
class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;
  // ... manages auth state
}

// presentation/pages/login_page.dart
class LoginPage extends ConsumerWidget {
  // ... UI that watches authNotifierProvider
}
```

## Data Flow

### Request Flow (User Action → Data)
```
UI (LoginPage)
  ↓ (calls)
AuthNotifier.login()
  ↓ (calls)
LoginUseCase()
  ↓ (calls)
AuthRepository.login()
  ↓ (calls)
AuthRepositoryImpl.login()
  ↓ (checks network)
NetworkInfo.isConnected
  ↓ (if connected)
AuthRemoteDataSource.login()
  ↓ (API call)
Server
  ↓ (response)
UserModel
  ↓ (mapped to)
UserEntity
  ↓ (cached)
AuthLocalDataSource.cacheUser()
  ↓ (returns)
AuthState.authenticated(user)
  ↓ (UI updates)
LoginPage rebuilds
```

### Response Flow (Data → UI)
```
Server Response
  ↓
RemoteDataSource
  ↓
Repository Implementation
  ↓ (maps)
Entity
  ↓
Use Case
  ↓
State Notifier
  ↓
Riverpod Provider
  ↓
UI Widget (ConsumerWidget)
```

## State Management Flow (Riverpod)

### Provider Types

1. **Provider**: Simple value provider
   ```dart
   final themeProvider = Provider<ThemeData>((ref) => AppTheme.lightTheme);
   ```

2. **StateProvider**: Mutable state
   ```dart
   final counterProvider = StateProvider<int>((ref) => 0);
   ```

3. **StateNotifierProvider**: Complex state management
   ```dart
   final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
     return AuthNotifier(ref.watch(loginUseCaseProvider));
   });
   ```

4. **FutureProvider**: Async operations
   ```dart
   final userProvider = FutureProvider<User?>((ref) async {
     return await fetchUser();
   });
   ```

### Provider Dependencies

Providers can depend on other providers using `ref.watch()`:

```dart
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});
```

### Reading Providers in Widgets

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    // ... use authState
  }
}
```

## Dependency Injection

### How It Works

1. **Core Providers** (`core/di/injection_container.dart`):
   - SharedPreferences
   - SecureStorage
   - NetworkInfo
   - DioClient
   - Router

2. **Feature Providers** (`features/{feature}/presentation/providers/`):
   - Data sources
   - Repositories
   - Use cases
   - State notifiers

### Dependency Chain Example

```
authNotifierProvider
  ↓ depends on
loginUseCaseProvider
  ↓ depends on
authRepositoryProvider
  ↓ depends on
authRemoteDataSourceProvider
authLocalDataSourceProvider
networkInfoProvider
  ↓ depends on
connectivityProvider
```

### Initialization Order

1. Core providers are initialized first (in `injection_container.dart`)
2. Feature providers depend on core providers
3. Widgets consume feature providers

## Navigation (GoRouter)

### Router Setup

```dart
// router/app_router.dart
class AppRouter {
  final Ref ref;
  AppRouter(this.ref);
  
  GoRouter get router => _router;
  // ... route definitions
}
```

### Route Structure

- **Authentication Routes**: `/login`
- **Main App Routes**: Wrapped in `ShellRoute` with bottom navigation
  - `/home`
  - `/schedule`
  - `/activity`
  - `/profile`

### Navigation in Code

```dart
// Using GoRouter
context.go(AppRoutes.home);
context.push(AppRoutes.profile);
context.pop();
```

## Theme Configuration

### Theme Providers

```dart
// theme/app_theme_provider.dart
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier(ref);
});
```

### Using Theme

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final theme = ref.watch(themeDataProvider);
    // ... use theme
  }
}
```

## Localization

### Setup

1. **Translation Files**: `assets/i18n/{language}.json`
2. **Localization Provider**: `core/localization/app_localizations.dart`
3. **Supported Languages**: English (en), Marathi (mr), Hindi (hi)

### Using Translations

```dart
// In widgets
context.tr('welcome_message');
context.trArgs('greeting', {'name': 'John'});
```

## Responsive Layout

### Responsive Utilities

```dart
// shared/responsive/responsive_utils.dart
ResponsiveUtils.isMobile(context);
ResponsiveUtils.isTablet(context);
ResponsiveUtils.isDesktop(context);
```

### Responsive Widgets

```dart
ResponsiveWrapper(
  mobile: MobileLayout(),
  tablet: TabletLayout(),
  desktop: DesktopLayout(),
)
```

## Scaling the Architecture

### Adding a New Feature

1. **Create Feature Folder Structure**:
   ```
   features/new_feature/
   ├── data/
   │   ├── datasources/
   │   ├── models/
   │   ├── mappers/
   │   └── repositories/
   ├── domain/
   │   ├── entities/
   │   ├── repositories/
   │   └── usecases/
   └── presentation/
       ├── pages/
       ├── providers/
       └── widgets/
   ```

2. **Define Domain Layer**:
   - Create entities
   - Define repository interfaces
   - Create use cases

3. **Implement Data Layer**:
   - Create models (Freezed)
   - Implement data sources
   - Create mappers
   - Implement repository

4. **Build Presentation Layer**:
   - Create state (Freezed)
   - Create notifier
   - Create providers
   - Build UI pages

5. **Add Routes**:
   - Add route in `router/app_router.dart`

### Best Practices for Scaling

1. **Feature Independence**: Each feature should be self-contained
2. **Shared Code**: Put reusable code in `shared/` or `core/`
3. **Dependency Direction**: Always point inward (UI → Domain ← Data)
4. **Testing**: Test each layer independently
5. **Code Generation**: Use Freezed for models and state classes

## Testing Strategy

### Unit Tests
- **Domain Layer**: Test use cases and entities
- **Data Layer**: Test repositories and data sources
- **Presentation Layer**: Test state notifiers

### Widget Tests
- Test UI components in isolation
- Mock providers using `ProviderScope`

### Integration Tests
- Test complete user flows
- Test navigation
- Test state management

## Common Patterns

### Error Handling

```dart
final result = await useCase(params);
result.fold(
  (failure) => showError(failure.message),
  (data) => showSuccess(data),
);
```

### Loading States

```dart
final state = ref.watch(authNotifierProvider);
state.when(
  loading: () => CircularProgressIndicator(),
  authenticated: (user) => UserWidget(user),
  error: (message) => ErrorWidget(message),
  // ...
);
```

### Network-Aware Operations

```dart
final isConnected = await networkInfo.isConnected;
if (!isConnected) {
  // Use cached data or show offline message
}
```

## Summary

This Clean Architecture provides:

✅ **Separation of Concerns**: Each layer has a clear responsibility  
✅ **Testability**: Each layer can be tested independently  
✅ **Scalability**: Easy to add new features  
✅ **Maintainability**: Clear structure and dependencies  
✅ **Reusability**: Shared components in `core/` and `shared/`  
✅ **Type Safety**: Freezed for models and state  
✅ **State Management**: Riverpod for reactive state  
✅ **Navigation**: GoRouter for declarative routing  
