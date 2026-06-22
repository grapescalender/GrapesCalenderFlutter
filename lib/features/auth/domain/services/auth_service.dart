import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../data/datasources/auth_local_datasource.dart';
import '../../data/mappers/user_mapper.dart';
import '../entities/user_entity.dart';
import '../../presentation/providers/auth_state.dart';

/// Centralized authentication persistence service.
///
/// Logout and startup checks go through this service so tokens, cached user
/// profile data, onboarding progress, selected plot, and active season are
/// cleared or validated in one place.
class AuthService {
  const AuthService({
    required this.localDataSource,
  });

  static const String loginRoute = '/login';

  final AuthLocalDataSource localDataSource;

  /// Returns true only when a stored token is paired with a known user session.
  Future<bool> isLoggedIn() async {
    final token = await localDataSource.getToken();
    final cachedUser = await localDataSource.getCachedUser();
    final userId = await localDataSource.getUserId();

    return token != null &&
        token.trim().isNotEmpty &&
        (cachedUser != null || (userId != null && userId.trim().isNotEmpty));
  }

  Future<UserEntity?> getCurrentUser() async {
    final cachedUser = await localDataSource.getCachedUser();
    return cachedUser == null ? null : UserMapper.toEntity(cachedUser);
  }

  Future<AuthState> restoreAuthState() async {
    final loggedIn = await isLoggedIn();
    if (!loggedIn) {
      return const AuthState.unauthenticated();
    }

    final user = await getCurrentUser();
    if (user != null) {
      return AuthState.authenticated(user);
    }

    final userId = await localDataSource.getUserId();
    final mobileNumber = await localDataSource.getAuthMobileNumber() ?? '';
    final now = DateTime.now();
    return AuthState.authenticated(
      UserEntity(
        id: userId ?? '',
        username: 'registered_farmer',
        email: mobileNumber.isEmpty ? '' : '$mobileNumber@example.com',
        phoneNumber: mobileNumber,
        firstName: 'Farmer',
        lastName: '',
        farmName: 'Table Grapes Farm',
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<void> logout({
    BuildContext? context,
    FutureOr<void> Function()? onSessionCleared,
    VoidCallback? navigateToLogin,
  }) async {
    // Destroy the local session before navigation so protected routes cannot
    // be restored by back navigation or after an app restart.
    await localDataSource.clearSession();
    await onSessionCleared?.call();

    if (navigateToLogin != null) {
      navigateToLogin();
    } else if (context != null && context.mounted) {
      context.go(loginRoute);
    }
  }
}
