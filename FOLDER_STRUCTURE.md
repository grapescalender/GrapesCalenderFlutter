# Complete Folder Structure

## Directory Tree

```
lib/
├── core/                                    # Core infrastructure
│   ├── constants/                          # App-wide constants
│   │   ├── app_colors.dart
│   │   ├── app_constants.dart
│   │   ├── app_spacing.dart
│   │   └── app_text_styles.dart
│   │
│   ├── di/                                 # Dependency injection
│   │   └── injection_container.dart       # Core providers (SharedPreferences, Dio, etc.)
│   │
│   ├── error/                             # Error handling
│   │   ├── exceptions.dart                # Exception classes
│   │   └── failures.dart                  # Failure classes (Freezed)
│   │
│   ├── localization/                      # Localization infrastructure
│   │   └── app_localizations.dart        # Localization service & providers
│   │
│   ├── network/                           # Network layer
│   │   ├── dio_client.dart               # Dio HTTP client with interceptors
│   │   └── network_info.dart              # Network connectivity checker
│   │
│   ├── theme/                             # Theme configuration
│   │   └── app_theme.dart                # Light/Dark theme definitions
│   │
│   ├── usecase/                           # Base use case interfaces
│   │   └── usecase.dart                  # UseCase, UseCaseNoParams, StreamUseCase
│   │
│   └── utils/                             # Utility functions
│       └── app_utils.dart
│
├── features/                               # Feature modules (feature-first)
│   │
│   ├── auth/                              # Authentication feature
│   │   ├── data/                          # Data layer
│   │   │   ├── datasources/              # Data sources
│   │   │   │   ├── auth_remote_datasource.dart      # API calls
│   │   │   │   └── auth_local_datasource.dart       # Local storage
│   │   │   │
│   │   │   ├── models/                    # Data models (Freezed)
│   │   │   │   ├── user_model.dart
│   │   │   │   ├── user_model.freezed.dart
│   │   │   │   └── user_model.g.dart
│   │   │   │
│   │   │   ├── mappers/                   # Entity ↔ Model mappers
│   │   │   │   └── user_mapper.dart
│   │   │   │
│   │   │   └── repositories/               # Repository implementations
│   │   │       └── auth_repository_impl.dart
│   │   │
│   │   ├── domain/                        # Domain layer (business logic)
│   │   │   ├── entities/                  # Domain entities (pure Dart)
│   │   │   │   └── user_entity.dart
│   │   │   │
│   │   │   ├── repositories/              # Repository interfaces
│   │   │   │   └── auth_repository.dart
│   │   │   │
│   │   │   └── usecases/                  # Use cases
│   │   │       └── login_usecase.dart
│   │   │
│   │   └── presentation/                  # Presentation layer (UI)
│   │       ├── pages/                     # Screen widgets
│   │       │   └── login_page.dart
│   │       │
│   │       ├── providers/                 # Riverpod providers
│   │       │   ├── auth_providers.dart    # Provider definitions
│   │       │   ├── auth_state.dart        # State class (Freezed)
│   │       │   └── auth_notifier.dart     # State notifier
│   │       │
│   │       └── widgets/                   # Feature-specific widgets
│   │
│   ├── home/                              # Home feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   ├── mappers/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── plot_entity.dart
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── pages/
│   │       ├── providers/
│   │       └── widgets/
│   │
│   ├── schedule/                          # Schedule feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   ├── mappers/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── schedule_entity.dart
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── pages/
│   │       ├── providers/
│   │       └── widgets/
│   │
│   └── profile/                           # Profile feature
│       ├── data/
│       ├── domain/
│       └── presentation/
│
├── router/                                 # Navigation
│   └── app_router.dart                    # GoRouter configuration
│
├── shared/                                 # Shared components
│   ├── models/                            # Shared models
│   │   └── result_model.dart
│   │
│   ├── responsive/                        # Responsive utilities
│   │   └── responsive_utils.dart          # Breakpoints, responsive helpers
│   │
│   └── widgets/                           # Reusable widgets
│       ├── main_shell.dart                # Bottom navigation shell
│       ├── responsive_wrapper.dart        # Responsive layout wrapper
│       ├── app_buttons.dart
│       ├── plot_card.dart
│       └── schedule_card.dart
│
├── theme/                                  # Theme management
│   ├── app_theme.dart                     # Theme data (moved from core/theme)
│   └── app_theme_provider.dart            # Theme providers (Riverpod)
│
└── main.dart                               # App entry point
```

## Folder Responsibilities

### `core/`
**Purpose**: Shared infrastructure used across all features

- **constants/**: App-wide constants (colors, spacing, text styles, API URLs)
- **di/**: Dependency injection setup with Riverpod providers
- **error/**: Centralized error handling (exceptions, failures)
- **localization/**: Localization infrastructure and providers
- **network/**: Network layer (HTTP client, connectivity checker)
- **theme/**: Theme configuration (colors, text styles)
- **usecase/**: Base interfaces for use cases
- **utils/**: Utility functions

### `features/`
**Purpose**: Feature modules organized by feature (feature-first structure)

Each feature follows Clean Architecture with three layers:

#### `data/` - Data Layer
- **datasources/**: Remote (API) and Local (cache) data sources
- **models/**: Freezed classes for JSON serialization
- **mappers/**: Convert between Models (data) and Entities (domain)
- **repositories/**: Concrete implementations of domain repositories

#### `domain/` - Domain Layer
- **entities/**: Pure Dart classes representing business objects
- **repositories/**: Interfaces defining data operations (contracts)
- **usecases/**: Business logic operations (single responsibility)

#### `presentation/` - Presentation Layer
- **pages/**: Screen widgets
- **providers/**: Riverpod providers for state management
- **widgets/**: Feature-specific UI components

### `router/`
**Purpose**: Navigation configuration using GoRouter

- Defines all routes
- Handles navigation logic
- Manages route guards (authentication, etc.)

### `shared/`
**Purpose**: Reusable components shared across features

- **models/**: Shared data models
- **responsive/**: Responsive layout utilities
- **widgets/**: Reusable UI widgets

### `theme/`
**Purpose**: Theme management with Riverpod

- Theme data definitions
- Theme providers for state management
- Light/Dark mode support

## File Naming Conventions

- **Entities**: `{name}_entity.dart` (e.g., `user_entity.dart`)
- **Models**: `{name}_model.dart` (e.g., `user_model.dart`)
- **Repositories**: `{name}_repository.dart` (interface), `{name}_repository_impl.dart` (implementation)
- **Use Cases**: `{action}_usecase.dart` (e.g., `login_usecase.dart`)
- **Data Sources**: `{name}_remote_datasource.dart`, `{name}_local_datasource.dart`
- **Mappers**: `{name}_mapper.dart`
- **Providers**: `{name}_providers.dart`
- **State**: `{name}_state.dart`
- **Notifiers**: `{name}_notifier.dart`
- **Pages**: `{name}_page.dart`

## Import Conventions

### Within a Feature
```dart
// Use relative imports
import '../domain/entities/user_entity.dart';
import '../../data/models/user_model.dart';
```

### Across Features
```dart
// Use absolute imports
import 'package:smart_farm_pruning_manager/core/error/failures.dart';
import 'package:smart_farm_pruning_manager/shared/widgets/app_buttons.dart';
```

### Core/Shared
```dart
// Use absolute imports
import 'package:smart_farm_pruning_manager/core/constants/app_constants.dart';
```

## Adding a New Feature

1. Create feature folder: `features/new_feature/`
2. Create three-layer structure:
   - `data/` (datasources, models, mappers, repositories)
   - `domain/` (entities, repositories, usecases)
   - `presentation/` (pages, providers, widgets)
3. Follow the same patterns as `auth/` feature
4. Add route in `router/app_router.dart`
