import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

/// Login form controller
/// Manages form state, validation, and user input
class LoginController extends StateNotifier<LoginFormState> {
  LoginController() : super(LoginFormState.initial());

  /// Update username
  void updateUsername(String username) {
    state = state.copyWith(
      username: username,
      usernameError: _validateUsername(username),
    );
  }

  /// Update password
  void updatePassword(String password) {
    state = state.copyWith(
      password: password,
      passwordError: _validatePassword(password),
    );
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  /// Validate form
  bool validateForm() {
    final usernameError = _validateUsername(state.username);
    final passwordError = _validatePassword(state.password);

    state = state.copyWith(
      usernameError: usernameError,
      passwordError: passwordError,
    );

    return usernameError == null && passwordError == null;
  }

  /// Reset form
  void reset() {
    state = LoginFormState.initial();
  }

  /// Validate username
  String? _validateUsername(String username) {
    if (username.isEmpty) {
      return 'Username is required';
    }
    if (username.length < 3) {
      return 'Username must be at least 3 characters';
    }
    if (username.length > 50) {
      return 'Username must be less than 50 characters';
    }
    // Allow alphanumeric and underscore
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
      return 'Username can only contain letters, numbers, and underscore';
    }
    return null;
  }

  /// Validate password
  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (password.length > 100) {
      return 'Password must be less than 100 characters';
    }
    return null;
  }
}

/// Login form state
class LoginFormState {

  const LoginFormState({
    required this.username,
    required this.password,
    required this.obscurePassword,
    this.usernameError,
    this.passwordError,
  });

  factory LoginFormState.initial() {
    return const LoginFormState(
      username: '',
      password: '',
      obscurePassword: true,
      usernameError: null,
      passwordError: null,
    );
  }
  final String username;
  final String password;
  final bool obscurePassword;
  final String? usernameError;
  final String? passwordError;

  LoginFormState copyWith({
    String? username,
    String? password,
    bool? obscurePassword,
    String? usernameError,
    String? passwordError,
  }) => LoginFormState(
      username: username ?? this.username,
      password: password ?? this.password,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      usernameError: usernameError ?? this.usernameError,
      passwordError: passwordError ?? this.passwordError,
    );

  bool get isValid => usernameError == null && passwordError == null && username.isNotEmpty && password.isNotEmpty;
}

/// Login controller provider
final loginControllerProvider = StateNotifierProvider<LoginController, LoginFormState>((ref) => LoginController());
