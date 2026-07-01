import '../entities/farmer_onboarding_state.dart';
import '../entities/onboarding_routing_state.dart';
import '../services/auth_service.dart';

/// Resolves the single destination that is safe to render after app launch or
/// authentication. Protected pages must not be built before this completes.
class OnboardingRouteResolver {
  const OnboardingRouteResolver({
    required this.authService,
  });

  final AuthService authService;

  Future<OnboardingRoutingState> resolve() async {
    if (!await authService.isLoggedIn()) {
      return OnboardingRoutingState.unauthenticated;
    }

    final onboardingState =
        await authService.localDataSource.getOnboardingState();

    switch (onboardingState) {
      case FarmerOnboardingState.profilePending:
        return OnboardingRoutingState.profilePending;
      case FarmerOnboardingState.plotPending:
        return OnboardingRoutingState.plotPending;
      case FarmerOnboardingState.seasonPending:
        return OnboardingRoutingState.seasonPending;
      case FarmerOnboardingState.completed:
        return OnboardingRoutingState.completed;
      case FarmerOnboardingState.mobileNotVerified:
        // A normal login can restore a legacy/returning account that predates
        // onboarding-state persistence. A cached account is already registered
        // and must not be sent through signup again.
        final existingUser = await authService.getCurrentUser();
        return existingUser == null
            ? OnboardingRoutingState.profilePending
            : OnboardingRoutingState.completed;
    }
  }
}
