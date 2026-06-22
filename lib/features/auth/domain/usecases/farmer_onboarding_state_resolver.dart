import '../entities/farmer_onboarding_state.dart';

class FarmerOnboardingStateResolver {
  const FarmerOnboardingStateResolver();

  FarmerOnboardingState resolve({
    required bool isMobileVerified,
    required bool isProfileCompleted,
    required bool hasPlot,
    required bool hasSeason,
  }) {
    if (!isMobileVerified) {
      return FarmerOnboardingState.mobileNotVerified;
    }
    if (!isProfileCompleted) {
      return FarmerOnboardingState.profilePending;
    }
    if (!hasPlot) {
      return FarmerOnboardingState.plotPending;
    }
    if (!hasSeason) {
      return FarmerOnboardingState.seasonPending;
    }
    return FarmerOnboardingState.completed;
  }
}
