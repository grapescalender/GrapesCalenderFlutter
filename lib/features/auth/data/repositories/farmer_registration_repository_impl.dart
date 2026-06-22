import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/farmer_onboarding_state.dart';
import '../../domain/repositories/farmer_registration_repository.dart';
import '../../domain/usecases/farmer_onboarding_state_resolver.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/mock_farmer_registration_api_service.dart';
import '../models/farmer_profile_model.dart';
import '../models/farmer_registration_model.dart';
import '../models/plot_registration_model.dart';
import '../models/season_setup_model.dart';

/// Mock-backed implementation for farmer registration onboarding.
class FarmerRegistrationRepositoryImpl implements FarmerRegistrationRepository {
  const FarmerRegistrationRepositoryImpl({
    required this.apiService,
    required this.localDataSource,
    this.stateResolver = const FarmerOnboardingStateResolver(),
  });

  final MockFarmerRegistrationApiService apiService;
  final AuthLocalDataSource localDataSource;
  final FarmerOnboardingStateResolver stateResolver;

  @override
  Future<Either<Failure, FarmerOnboardingState>> getOnboardingState() async {
    try {
      return Right(await localDataSource.getOnboardingState());
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } on Object catch (e) {
      return Left(Failure.unknown(
        message: 'Failed to get onboarding state: ${e.toString()}',
        error: e,
      ));
    }
  }

  @override
  Future<Either<Failure, FarmerRegistrationModel>> sendOtp({
    required String mobileNumber,
  }) async {
    try {
      final response = await apiService.sendOtp(
        FarmerRegistrationModel.sendOtpRequest(mobileNumber: mobileNumber),
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } on Object catch (e) {
      return Left(Failure.unknown(
        message: 'Failed to send OTP: ${e.toString()}',
        error: e,
      ));
    }
  }

  @override
  Future<Either<Failure, FarmerRegistrationModel>> verifyOtp({
    required String mobileNumber,
    required String otp,
  }) async {
    try {
      final response = await apiService.verifyOtp(
        FarmerRegistrationModel.verifyOtpRequest(
          mobileNumber: mobileNumber,
          otp: otp,
        ),
      );

      if (response.token != null) {
        await localDataSource.saveToken(response.token!);
      }
      await localDataSource.saveAuthMobileNumber(mobileNumber);
      if (response.userId != null) {
        await localDataSource.saveUserId(response.userId!.toString());
      }
      await localDataSource.saveOnboardingState(
        stateResolver.resolve(
          isMobileVerified: response.success ?? false,
          isProfileCompleted: response.isProfileCompleted ?? false,
          hasPlot: false,
          hasSeason: false,
        ),
      );

      return Right(response);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } on Object catch (e) {
      return Left(Failure.unknown(
        message: 'Failed to verify OTP: ${e.toString()}',
        error: e,
      ));
    }
  }

  @override
  Future<Either<Failure, FarmerProfileModel>> createFarmerProfile(
    FarmerProfileModel request,
  ) async {
    try {
      final response = await apiService.createFarmerProfile(request);
      if (response.farmerId != null) {
        await localDataSource.saveFarmerId(response.farmerId!.toString());
      }
      await localDataSource.saveOnboardingState(
        stateResolver.resolve(
          isMobileVerified: true,
          isProfileCompleted: response.success ?? false,
          hasPlot: false,
          hasSeason: false,
        ),
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } on Object catch (e) {
      return Left(Failure.unknown(
        message: 'Failed to create farmer profile: ${e.toString()}',
        error: e,
      ));
    }
  }

  @override
  Future<Either<Failure, PlotRegistrationModel>> addPlot({
    required int farmerId,
    required PlotRegistrationModel request,
  }) async {
    try {
      final response = await apiService.addPlot(
        farmerId: farmerId,
        request: request,
      );
      if (response.plotId != null) {
        await localDataSource.savePlotId(response.plotId!.toString());
      }
      await localDataSource.saveOnboardingState(
        stateResolver.resolve(
          isMobileVerified: true,
          isProfileCompleted: true,
          hasPlot: false,
          hasSeason: false,
        ),
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } on Object catch (e) {
      return Left(Failure.unknown(
        message: 'Failed to add plot: ${e.toString()}',
        error: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<PlotRegistrationModel>>> getPlots({
    required int farmerId,
  }) async {
    try {
      final response = await apiService.getPlots(farmerId: farmerId);
      return Right(response);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } on Object catch (e) {
      return Left(Failure.unknown(
        message: 'Failed to get plots: ${e.toString()}',
        error: e,
      ));
    }
  }

  @override
  Future<Either<Failure, PlotBatchRegistrationModel>> addPlotsBatch({
    required int farmerId,
    required List<PlotRegistrationModel> plots,
  }) async {
    try {
      final response = await apiService.addPlotsBatch(
        farmerId: farmerId,
        plots: plots,
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } on Object catch (e) {
      return Left(Failure.unknown(
        message: 'Failed to add plots: ${e.toString()}',
        error: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> continueToSeasonSetup() async {
    try {
      await localDataSource.saveOnboardingState(
        FarmerOnboardingState.seasonPending,
      );
      return const Right(null);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } on Object catch (e) {
      return Left(Failure.unknown(
        message: 'Failed to continue to season setup: ${e.toString()}',
        error: e,
      ));
    }
  }

  @override
  Future<Either<Failure, SeasonSetupModel>> startSeason({
    required int plotId,
    required SeasonSetupModel request,
  }) async {
    try {
      final response = await apiService.startSeason(
        plotId: plotId,
        request: request,
      );
      if (response.seasonId != null) {
        await localDataSource.saveSeasonId(response.seasonId!.toString());
      }
      await localDataSource.saveOnboardingState(
        stateResolver.resolve(
          isMobileVerified: true,
          isProfileCompleted: true,
          hasPlot: true,
          hasSeason: response.dashboardReady ?? false,
        ),
      );
      return Right(response);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } on Object catch (e) {
      return Left(Failure.unknown(
        message: 'Failed to start season: ${e.toString()}',
        error: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> completeWithoutPlot() async {
    try {
      await localDataSource.saveOnboardingState(
        FarmerOnboardingState.completed,
      );
      return const Right(null);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } on Object catch (e) {
      return Left(Failure.unknown(
        message: 'Failed to skip plot: ${e.toString()}',
        error: e,
      ));
    }
  }

  Failure _mapExceptionToFailure(AppException exception) {
    if (exception is ValidationException) {
      return Failure.validation(
        message: exception.message,
        errors: exception.errors,
      );
    }
    if (exception is AuthenticationException) {
      return Failure.authentication(message: exception.message);
    }
    if (exception is NetworkException) {
      return Failure.network(
        message: exception.message,
        statusCode: exception.statusCode,
      );
    }
    if (exception is ServerException) {
      return Failure.server(
        message: exception.message,
        statusCode: exception.statusCode,
      );
    }
    if (exception is CacheException) {
      return Failure.cache(message: exception.message);
    }
    return Failure.unknown(
      message: exception.message,
      error: exception,
    );
  }
}
