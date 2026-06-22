import '../../../../core/error/exceptions.dart';
import '../models/farmer_profile_model.dart';
import '../models/farmer_registration_model.dart';
import '../models/plot_registration_model.dart';
import '../models/season_setup_model.dart';

/// Mock API service for farmer-only registration onboarding.
///
/// Replace this class with a Dio-backed service when the real backend is ready.
class MockFarmerRegistrationApiService {
  static const String sendOtpEndpoint = '/api/v1/auth/send-otp';
  static const String verifyOtpEndpoint = '/api/v1/auth/verify-otp';
  static const String farmerProfileEndpoint = '/api/v1/farmers/profile';
  static String farmerPlotsEndpoint(int farmerId) =>
      '/api/v1/farmers/$farmerId/plots';
  static String farmerPlotsBatchEndpoint(int farmerId) =>
      '/api/v1/farmers/$farmerId/plots/batch';
  static String plotSeasonsEndpoint(int plotId) =>
      '/api/v1/plots/$plotId/seasons';

  static const Duration _mockDelay = Duration(milliseconds: 700);
  static final Map<int, List<PlotRegistrationModel>> _plotsByFarmer = {};
  static int _nextPlotId = 9001;

  Future<FarmerRegistrationModel> sendOtp(
    FarmerRegistrationModel request,
  ) async {
    await Future<void>.delayed(_mockDelay);

    final mobileNumber = request.mobileNumber?.trim() ?? '';
    if (mobileNumber.length != 10) {
      throw const ValidationException(
        'Enter a valid 10 digit mobile number',
        null,
      );
    }

    return FarmerRegistrationModel.sendOtpResponse(
      success: true,
      message: 'OTP sent successfully',
    );
  }

  Future<FarmerRegistrationModel> verifyOtp(
    FarmerRegistrationModel request,
  ) async {
    await Future<void>.delayed(_mockDelay);

    final mobileNumber = request.mobileNumber?.trim() ?? '';
    final otp = request.otp?.trim() ?? '';
    if (mobileNumber.length != 10 || otp.isEmpty) {
      throw const ValidationException(
        'Mobile number and OTP are required',
        null,
      );
    }

    return FarmerRegistrationModel.verifyOtpResponse(
      success: true,
      token: 'mock_token_123',
      userId: 101,
      isProfileCompleted: false,
    );
  }

  Future<FarmerProfileModel> createFarmerProfile(
    FarmerProfileModel request,
  ) async {
    await Future<void>.delayed(_mockDelay);

    if (request.userId == null ||
        (request.farmerName?.trim().isEmpty ?? true) ||
        (request.village?.trim().isEmpty ?? true) ||
        (request.taluka?.trim().isEmpty ?? true) ||
        (request.district?.trim().isEmpty ?? true) ||
        (request.preferredLanguage?.trim().isEmpty ?? true)) {
      throw const ValidationException(
        'Farmer profile details are required',
        null,
      );
    }

    return FarmerProfileModel.response(
      success: true,
      farmerId: 501,
    );
  }

  Future<PlotRegistrationModel> addPlot({
    required int farmerId,
    required PlotRegistrationModel request,
  }) async {
    await Future<void>.delayed(_mockDelay);

    if (farmerId <= 0 ||
        (request.plotName?.trim().isEmpty ?? true) ||
        request.area == null ||
        request.area! <= 0 ||
        (request.variety?.trim().isEmpty ?? true)) {
      throw const ValidationException(
        'Plot name, variety and valid area are required',
        null,
      );
    }

    final savedPlot = PlotRegistrationModel(
      plotId: _nextPlotId++,
      plotName: request.plotName,
      area: request.area,
      variety: request.variety,
      soilType: request.soilType,
      rootType: request.rootType,
      plantationYear: request.plantationYear,
      latitude: request.latitude,
      longitude: request.longitude,
      success: true,
    );
    _plotsByFarmer[farmerId] = [
      ...?_plotsByFarmer[farmerId],
      savedPlot,
    ];

    return PlotRegistrationModel.response(
      success: true,
      plotId: savedPlot.plotId!,
      plotName: savedPlot.plotName,
    );
  }

  Future<List<PlotRegistrationModel>> getPlots({
    required int farmerId,
  }) async {
    await Future<void>.delayed(_mockDelay);
    return List<PlotRegistrationModel>.from(_plotsByFarmer[farmerId] ?? []);
  }

  Future<PlotBatchRegistrationModel> addPlotsBatch({
    required int farmerId,
    required List<PlotRegistrationModel> plots,
  }) async {
    final savedPlots = <PlotRegistrationModel>[];
    for (final plot in plots) {
      final response = await addPlot(farmerId: farmerId, request: plot);
      savedPlots.add(response);
    }

    return PlotBatchRegistrationModel(
      success: true,
      plots: savedPlots,
    );
  }

  Future<SeasonSetupModel> startSeason({
    required int plotId,
    required SeasonSetupModel request,
  }) async {
    await Future<void>.delayed(_mockDelay);

    if (plotId <= 0 ||
        (request.seasonYear?.trim().isEmpty ?? true) ||
        (request.currentCycle?.trim().isEmpty ?? true) ||
        (request.pruningDate?.trim().isEmpty ?? true)) {
      throw const ValidationException(
        'Season details are required',
        null,
      );
    }

    return SeasonSetupModel.response(
      success: true,
      seasonId: 7001,
      dashboardReady: true,
    );
  }
}
