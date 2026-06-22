import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../config/router/app_router.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/responsive_wrapper.dart';
import '../controllers/login_controller.dart';
import '../providers/auth_notifier.dart';
import '../providers/auth_providers.dart';
import '../providers/auth_state.dart';

/// Login Page
/// Modern, responsive login screen with form validation
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    // Pre-fill with hardcoded credentials for development
    _usernameController = TextEditingController(text: 'admin');
    _passwordController = TextEditingController(text: 'password');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginFormState = ref.watch(loginControllerProvider);
    final authState = ref.watch(authNotifierProvider);
    final loginController = ref.read(loginControllerProvider.notifier);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    // Initialize form state with pre-filled values on first build
    if (_usernameController.text.isNotEmpty && 
        (loginFormState.username.isEmpty || loginFormState.username != _usernameController.text)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          loginController.updateUsername(_usernameController.text);
          loginController.updatePassword(_passwordController.text);
        }
      });
    }

    // Handle authentication state changes
    // Use WidgetsBinding to ensure we're in a valid frame
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (!mounted) return;
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !context.mounted) return;
        
        next.maybeWhen(
          authenticated: (user) {
            // Navigate to home on successful login
            if (context.mounted) {
              context.go(AppRoutes.home);
            }
          },
          error: (message) {
            // Show error snackbar
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          orElse: () {},
        );
      });
    });

    return Scaffold(
      body: SafeArea(
        child: ResponsiveWrapper(
          mobile: _buildMobileLayout(
            context,
            loginFormState,
            authState,
            loginController,
            authNotifier,
          ),
          tablet: _buildTabletLayout(
            context,
            loginFormState,
            authState,
            loginController,
            authNotifier,
          ),
          desktop: _buildDesktopLayout(
            context,
            loginFormState,
            authState,
            loginController,
            authNotifier,
          ),
        ),
      ),
    );
  }

  /// Mobile layout
  Widget _buildMobileLayout(
    BuildContext context,
    LoginFormState formState,
    AuthState authState,
    LoginController loginController,
    AuthNotifier authNotifier,
  ) => SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.screenHorizontal),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: AppSpacing.xxl),
            _buildHeader(context),
            SizedBox(height: AppSpacing.xxl),
            _buildLoginForm(
              context,
              formState,
              authState,
              loginController,
              authNotifier,
            ),
            SizedBox(height: AppSpacing.lg),
            _buildFooter(context),
          ],
        ),
      ),
    );

  /// Tablet layout
  Widget _buildTabletLayout(
    BuildContext context,
    LoginFormState formState,
    AuthState authState,
    LoginController loginController,
    AuthNotifier authNotifier,
  ) => Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: AppSpacing.xxl),
                _buildHeader(context),
                SizedBox(height: AppSpacing.xxl),
                _buildLoginForm(
                  context,
                  formState,
                  authState,
                  loginController,
                  authNotifier,
                ),
                SizedBox(height: AppSpacing.lg),
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );

  /// Desktop layout
  Widget _buildDesktopLayout(
    BuildContext context,
    LoginFormState formState,
    AuthState authState,
    LoginController loginController,
    AuthNotifier authNotifier,
  ) => Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: AppSpacing.xxl),
                _buildHeader(context),
                SizedBox(height: AppSpacing.xxl),
                _buildLoginForm(
                  context,
                  formState,
                  authState,
                  loginController,
                  authNotifier,
                ),
                SizedBox(height: AppSpacing.lg),
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );

  /// Header section
  Widget _buildHeader(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        // Logo/Icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: cs.primary.withOpacity(0.10),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Icon(
            Icons.agriculture,
            size: 48,
            color: cs.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // Title
        Text(
          'Welcome Back',
          style: AppTypography.displaySmall(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        // Subtitle
        Text(
          'Sign in to continue to your farm',
          style: AppTypography.bodyMedium(context).copyWith(
            color: cs.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Login form
  Widget _buildLoginForm(
    BuildContext context,
    LoginFormState formState,
    AuthState authState,
    LoginController loginController,
    AuthNotifier authNotifier,
  ) {
    final cs = Theme.of(context).colorScheme;
    final isLoading = authState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    return AppCard.defaultStyle(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Username field
          TextFormField(
            controller: _usernameController,
            focusNode: _usernameFocusNode,
            enabled: !isLoading,
            decoration: InputDecoration(
              labelText: 'Username',
              hintText: 'Enter your username',
              prefixIcon: Icon(Icons.person_outline, color: cs.onSurfaceVariant),
              errorText: formState.usernameError,
              errorMaxLines: 2,
            ),
            textInputAction: TextInputAction.next,
            onChanged: loginController.updateUsername,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_passwordFocusNode);
            },
            validator: (_) => formState.usernameError,
          ),
          const SizedBox(height: AppSpacing.md),
          // Password field
          TextFormField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            enabled: !isLoading,
            obscureText: formState.obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Icon(Icons.lock_outline, color: cs.onSurfaceVariant),
              suffixIcon: IconButton(
                icon: Icon(
                  formState.obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: cs.onSurfaceVariant,
                ),
                onPressed: loginController.togglePasswordVisibility,
              ),
              errorText: formState.passwordError,
              errorMaxLines: 2,
            ),
            textInputAction: TextInputAction.done,
            onChanged: loginController.updatePassword,
            onFieldSubmitted: (_) {
              if (formState.isValid && !isLoading) {
                _handleLogin(loginController, authNotifier, formState);
              }
            },
            validator: (_) => formState.passwordError,
          ),
          const SizedBox(height: AppSpacing.sm),
          // Forgot password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: isLoading ? null : () {
                // TODO: Navigate to forgot password
              },
              child: Text(
                'Forgot Password?',
                style: AppTypography.bodySmall(context).copyWith(
                  color: cs.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Login button
          AppButton.primary(
            label: 'Sign In',
            onPressed: isLoading
                ? null
                : () => _handleLogin(loginController, authNotifier, formState),
            isLoading: isLoading,
            isFullWidth: true,
            icon: Icons.login,
          ),
        ],
      ),
    );
  }

  /// Footer section
  Widget _buildFooter(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: AppTypography.bodyMedium(context).copyWith(
            color: cs.onSurfaceVariant,
          ),
        ),
        TextButton(
          onPressed: () {
            context.push(AppRoutes.farmerRegistration);
          },
          child: Text(
            'Sign Up',
            style: AppTypography.bodyMedium(context).copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  /// Handle login
  void _handleLogin(
    LoginController loginController,
    AuthNotifier authNotifier,
    LoginFormState formState,
  ) {
    // Validate form
    if (!loginController.validateForm()) {
      return;
    }

    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Perform login
    authNotifier.login(formState.username, formState.password);
  }
}
