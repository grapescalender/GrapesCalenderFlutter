import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/farmer_profile_model.dart';
import '../../data/models/farmer_registration_model.dart';
import '../../data/models/plot_registration_model.dart';
import '../../data/models/season_setup_model.dart';
import '../entities/farmer_onboarding_state.dart';

/// Repository contract for farmer-only registration onboarding.
abstract class FarmerRegistrationRepository {
  Future<Either<Failure, FarmerOnboardingState>> getOnboardingState();

  Future<Either<Failure, FarmerRegistrationModel>> sendOtp({
    required String mobileNumber,
  });

  Future<Either<Failure, FarmerRegistrationModel>> verifyOtp({
    required String mobileNumber,
    required String otp,
  });

  Future<Either<Failure, FarmerProfileModel>> createFarmerProfile(
    FarmerProfileModel request,
  );

  Future<Either<Failure, PlotRegistrationModel>> addPlot({
    required int farmerId,
    required PlotRegistrationModel request,
  });

  Future<Either<Failure, List<PlotRegistrationModel>>> getPlots({
    required int farmerId,
  });

  Future<Either<Failure, PlotBatchRegistrationModel>> addPlotsBatch({
    required int farmerId,
    required List<PlotRegistrationModel> plots,
  });

  Future<Either<Failure, void>> continueToSeasonSetup();

  Future<Either<Failure, SeasonSetupModel>> startSeason({
    required int plotId,
    required SeasonSetupModel request,
  });

  Future<Either<Failure, void>> completeWithoutPlot();
}
