import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_state.dart';

/// Auth notifier that manages authentication state
class AuthNotifier extends StateNotifier<AuthState> {
  final Future<LoginUseCase> Function() getLoginUseCase;

  AuthNotifier(this.getLoginUseCase) : super(const AuthState.initial()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // TODO: Check if user is already authenticated
    state = const AuthState.unauthenticated();
  }

  Future<void> login(String username, String password) async {
    state = const AuthState.loading();

    try {
      final loginUseCase = await getLoginUseCase();
      final result = await loginUseCase.call(
        LoginParams(username: username, password: password),
      );

      result.fold(
        (failure) {
          state = AuthState.error(_mapFailureToMessage(failure));
        },
        (user) {
          state = AuthState.authenticated(user);
        },
      );
    } catch (e) {
      state = AuthState.error('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    // TODO: Implement logout with use case
    state = const AuthState.unauthenticated();
  }

  String _mapFailureToMessage(Failure failure) {
    return failure.when(
      network: (message, _) => message,
      server: (message, _) => message,
      cache: (message) => message,
      authentication: (message) => message,
      authorization: (message) => message,
      validation: (message, _) => message,
      unknown: (message, _) => message,
    );
  }
}
