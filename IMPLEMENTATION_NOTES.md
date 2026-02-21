# Implementation Notes

## Important: Async Provider Initialization

The current implementation uses `FutureProvider` for async dependencies (SharedPreferences, repositories). This requires special handling in the notifier.

### Current Pattern (Simplified)

The `authNotifierProvider` currently uses a workaround pattern. For production, consider one of these approaches:

### Option 1: Use AsyncNotifierProvider (Recommended)

```dart
final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

class AuthNotifier extends AsyncNotifier<AuthState> {
  LoginUseCase? _loginUseCase;

  @override
  Future<AuthState> build() async {
    // Initialize use case here
    final repository = await ref.read(authRepositoryProvider.future);
    _loginUseCase = LoginUseCase(repository);
    return const AuthState.initial();
  }

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await _loginUseCase!.call(
        LoginParams(username: username, password: password),
      );
      return result.fold(
        (failure) => AuthState.error(_mapFailureToMessage(failure)),
        (user) => AuthState.authenticated(user),
      );
    });
  }
}
```

### Option 2: Initialize in main.dart

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies
  final prefs = await SharedPreferences.getInstance();
  final secureStorage = const FlutterSecureStorage();
  final localDataSource = AuthLocalDataSourceImpl(
    sharedPreferences: prefs,
    secureStorage: secureStorage,
  );
  
  // Store in a global or use a different DI pattern
  // Then use regular Provider instead of FutureProvider
  
  runApp(const ProviderScope(child: MyApp()));
}
```

### Option 3: Use Provider.override

```dart
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  // Override with synchronous providers after initialization
  return AuthNotifier(ref.watch(loginUseCaseProvider));
});
```

## Code Generation Required

Before running the app, you need to generate Freezed and JSON serialization code:

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate:
- `failures.freezed.dart`
- `auth_state.freezed.dart`
- All `.g.dart` files for JSON serialization

## Missing Dependencies

The following dependencies need to be added to `pubspec.yaml`:

```yaml
dependencies:
  dartz: ^0.10.1  # Already added
  connectivity_plus: ^5.0.0  # Already added
```

## Next Steps

1. **Run code generation**:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. **Fix async provider pattern**:
   - Choose one of the options above
   - Update `auth_providers.dart` and `auth_notifier.dart`

3. **Implement actual API calls**:
   - Update `AuthRemoteDataSourceImpl` with real Dio calls
   - Add proper error handling

4. **Complete other features**:
   - Follow the same pattern for `home`, `schedule`, `profile`
   - Create domain entities, repositories, use cases

5. **Add tests**:
   - Unit tests for use cases
   - Widget tests for UI
   - Integration tests for flows

## Testing the Architecture

### Unit Test Example

```dart
void main() {
  group('LoginUseCase', () {
    late MockAuthRepository mockRepository;
    late LoginUseCase useCase;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = LoginUseCase(mockRepository);
    });

    test('should return UserEntity when login is successful', () async {
      // Arrange
      when(mockRepository.login(...)).thenAnswer((_) async => Right(userEntity));

      // Act
      final result = await useCase(LoginParams(...));

      // Assert
      expect(result, Right(userEntity));
    });
  });
}
```

### Widget Test Example

```dart
void main() {
  testWidgets('LoginPage shows error on failed login', (tester) async {
    // Arrange
    final container = ProviderContainer(
      overrides: [
        authNotifierProvider.overrideWith((ref) => MockAuthNotifier()),
      ],
    );

    // Act
    await tester.pumpWidget(
      ProviderScope(
        parent: container,
        child: MaterialApp(home: LoginPage()),
      ),
    );

    // Assert
    expect(find.text('Login'), findsOneWidget);
  });
}
```
