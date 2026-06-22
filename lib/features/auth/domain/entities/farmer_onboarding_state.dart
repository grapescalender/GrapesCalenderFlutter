enum FarmerOnboardingState {
  mobileNotVerified,
  profilePending,
  plotPending,
  seasonPending,
  completed,
}

extension FarmerOnboardingStateX on FarmerOnboardingState {
  String get storageValue {
    switch (this) {
      case FarmerOnboardingState.mobileNotVerified:
        return 'mobileNotVerified';
      case FarmerOnboardingState.profilePending:
        return 'profilePending';
      case FarmerOnboardingState.plotPending:
        return 'plotPending';
      case FarmerOnboardingState.seasonPending:
        return 'seasonPending';
      case FarmerOnboardingState.completed:
        return 'completed';
    }
  }

  static FarmerOnboardingState fromStorageValue(String? value) {
    switch (value) {
      case 'profilePending':
        return FarmerOnboardingState.profilePending;
      case 'plotPending':
        return FarmerOnboardingState.plotPending;
      case 'seasonPending':
        return FarmerOnboardingState.seasonPending;
      case 'completed':
        return FarmerOnboardingState.completed;
      case 'mobileNotVerified':
      default:
        return FarmerOnboardingState.mobileNotVerified;
    }
  }
}
