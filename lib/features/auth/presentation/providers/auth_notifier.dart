import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_state.dart';

/// Auth notifier that manages authentication state
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this.getLoginUseCase) : super(const AuthState.initial()) {
    _checkAuthStatus();
  }
  final Future<LoginUseCase> Function() getLoginUseCase;

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
    } on Object catch (e) {
      state = AuthState.error('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    // TODO: Implement logout with use case
    state = const AuthState.unauthenticated();
  }

  void completeFarmerRegistration({
    required String mobileNumber,
    required String farmerName,
    required bool hasPlot,
  }) {
    final now = DateTime.now();
    final nameParts = farmerName.trim().split(RegExp(r'\s+'));
    final firstName = nameParts.isEmpty ? farmerName : nameParts.first;
    final lastName = nameParts.length > 1 ? nameParts.skip(1).join(' ') : '';

    state = AuthState.authenticated(
      UserEntity(
        id: now.microsecondsSinceEpoch.toString(),
        username: hasPlot ? 'registered_farmer' : 'registered_farmer_no_plot',
        email: '$mobileNumber@example.com',
        phoneNumber: mobileNumber,
        firstName: firstName,
        lastName: lastName,
        farmName: 'Table Grapes Farm',
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  String _mapFailureToMessage(Failure failure) => failure.when(
        network: (message, _) => message,
        server: (message, _) => message,
        cache: (message) => message,
        authentication: (message) => message,
        authorization: (message) => message,
        validation: (message, _) => message,
        unknown: (message, _) => message,
      );
}
