# Auth Feature - Clean Architecture Implementation

## Overview

Complete authentication feature implemented using Clean Architecture principles with clear separation of concerns.

## Architecture Layers

### 1. Domain Layer (`domain/`)
**Business Logic - Framework Independent**

- **Entities** (`entities/user_entity.dart`)
  - Pure Dart class representing user business object
  - No dependencies on Flutter or external frameworks

- **Repository Interfaces** (`repositories/auth_repository.dart`)
  - Contract defining authentication operations
  - Returns `Either<Failure, T>` for error handling

- **Use Cases** (`usecases/login_usecase.dart`)
  - `LoginUseCase`: Handles login business logic
  - Single responsibility principle
  - Takes `LoginParams` and returns `Either<Failure, UserEntity>`

### 2. Data Layer (`data/`)
**Data Sources & Implementation**

- **Data Sources** (`datasources/`)
  - `AuthRemoteDataSource`: API calls (abstract + implementation)
  - `AuthLocalDataSource`: Local storage (SharedPreferences, SecureStorage)
  - Currently uses mock implementation for development

- **Models** (`models/user_model.dart`)
  - Freezed classes for JSON serialization
  - `UserModel`, `AuthResponse`, `LoginRequest`, etc.

- **Mappers** (`mappers/user_mapper.dart`)
  - Converts between `UserModel` (data) and `UserEntity` (domain)
  - Maintains clean boundaries between layers

- **Repository Implementation** (`repositories/auth_repository_impl.dart`)
  - Implements `AuthRepository` interface
  - Orchestrates remote and local data sources
  - Handles error mapping (exceptions → failures)

### 3. Presentation Layer (`presentation/`)
**UI & State Management**

- **Controllers** (`controllers/login_controller.dart`)
  - `LoginController`: Manages form state and validation
  - Handles username/password input
  - Form validation logic
  - Password visibility toggle

- **Providers** (`providers/`)
  - `auth_providers.dart`: Riverpod providers for dependency injection
  - `auth_notifier.dart`: State notifier for auth state management
  - `auth_state.dart`: Freezed state class

- **Pages** (`pages/login_page.dart`)
  - `LoginPage`: Modern, responsive login UI
  - Form validation
  - Loading states
  - Error handling
  - Navigation to home on success

## Data Flow

```
User Input (LoginPage)
  ↓
LoginController (Form Validation)
  ↓
AuthNotifier.login()
  ↓
LoginUseCase
  ↓
AuthRepository.login()
  ↓
AuthRepositoryImpl
  ↓
AuthRemoteDataSource (API Call)
  ↓
UserModel
  ↓
UserMapper.toEntity()
  ↓
UserEntity
  ↓
AuthState.authenticated(user)
  ↓
Navigation to Home
```

## Components

### LoginController
- Manages form state (username, password, errors)
- Real-time validation
- Password visibility toggle
- Form submission validation

### AuthNotifier
- Manages authentication state
- Handles login/logout operations
- Maps failures to error messages
- Updates state (loading, authenticated, error)

### LoginPage
- Responsive layout (mobile, tablet, desktop)
- Modern UI inspired by Groww
- Form validation with error messages
- Loading state with disabled inputs
- Error handling with snackbar
- Navigation to home on success

## State Management

### AuthState (Freezed)
```dart
- initial: Initial state
- loading: Login in progress
- authenticated: Login successful (contains UserEntity)
- unauthenticated: Not logged in
- error: Login failed (contains error message)
```

### LoginFormState
```dart
- username: String
- password: String
- obscurePassword: bool
- usernameError: String?
- passwordError: String?
```

## Form Validation

### Username
- Required (not empty)
- Minimum 3 characters
- Maximum 50 characters
- Alphanumeric and underscore only

### Password
- Required (not empty)
- Minimum 6 characters
- Maximum 100 characters

## Error Handling

Errors are handled at multiple levels:

1. **Form Validation**: Client-side validation before API call
2. **Repository**: Maps exceptions to failures
3. **Notifier**: Maps failures to user-friendly messages
4. **UI**: Displays errors via snackbar

## Navigation

- **Login Success**: Navigates to `/home` using GoRouter
- **Error**: Shows error snackbar, stays on login page
- **Loading**: Disables form inputs, shows loading indicator

## Responsive Design

- **Mobile**: Full-width form, stacked layout
- **Tablet**: Centered form (max-width: 500px)
- **Desktop**: Centered form (max-width: 450px)

## Usage

### Login Flow
1. User enters username and password
2. Form validates input in real-time
3. User taps "Sign In" button
4. Form validates again
5. AuthNotifier.login() is called
6. Loading state is shown
7. API call is made (or mock response)
8. On success: Navigate to home
9. On error: Show error message

### Example Usage
```dart
// Watch auth state
final authState = ref.watch(authNotifierProvider);

// Perform login
ref.read(authNotifierProvider.notifier).login(username, password);

// Watch form state
final formState = ref.watch(loginControllerProvider);

// Update form
ref.read(loginControllerProvider.notifier).updateUsername('user123');
```

## Testing

### Unit Tests
- Test use cases with mock repositories
- Test form validation logic
- Test error mapping

### Widget Tests
- Test login form UI
- Test validation messages
- Test loading states
- Test error handling

### Integration Tests
- Test complete login flow
- Test navigation
- Test state management

## Future Enhancements

- [ ] Implement actual API integration
- [ ] Add remember me functionality
- [ ] Add biometric authentication
- [ ] Add forgot password flow
- [ ] Add sign up flow
- [ ] Add token refresh logic
- [ ] Add logout functionality
- [ ] Add session management

## File Structure

```
features/auth/
├── data/
│   ├── datasources/
│   │   ├── auth_remote_datasource.dart
│   │   └── auth_local_datasource.dart
│   ├── models/
│   │   └── user_model.dart
│   ├── mappers/
│   │   └── user_mapper.dart
│   └── repositories/
│       └── auth_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── user_entity.dart
│   ├── repositories/
│   │   └── auth_repository.dart
│   └── usecases/
│       └── login_usecase.dart
└── presentation/
    ├── controllers/
    │   └── login_controller.dart
    ├── providers/
    │   ├── auth_providers.dart
    │   ├── auth_notifier.dart
    │   └── auth_state.dart
    └── pages/
        └── login_page.dart
```

## Dependencies

- `flutter_riverpod`: State management
- `go_router`: Navigation
- `freezed`: Immutable state classes
- `dartz`: Functional programming (Either)

---

**This implementation follows Clean Architecture principles with clear separation of concerns and testability.**
