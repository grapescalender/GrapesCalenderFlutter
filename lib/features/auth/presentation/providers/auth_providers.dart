import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/mock_farmer_registration_api_service.dart';
import '../../data/models/plot_registration_model.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/farmer_registration_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/farmer_registration_repository.dart';
import '../../domain/services/auth_service.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_notifier.dart';
import 'auth_state.dart';

/// Temporary in-app onboarding data until the registration API is connected.
class FarmerOnboardingData {
  const FarmerOnboardingData({
    required this.mobileNumber,
    required this.farmerName,
    required this.village,
    required this.taluka,
    required this.district,
    required this.preferredLanguage,
    this.plotName,
    this.area,
    this.variety,
    this.soilType,
    this.rootType,
    this.plantationYear,
    this.latitude,
    this.longitude,
    this.seasonYear,
    this.currentCycle,
    this.pruningDate,
    this.plots = const [],
    this.selectedSeasonPlotId,
    this.startedSeasonPlotIds = const [],
  });

  final String mobileNumber;
  final String farmerName;
  final String village;
  final String taluka;
  final String district;
  final String preferredLanguage;
  final String? plotName;
  final double? area;
  final String? variety;
  final String? soilType;
  final String? rootType;
  final String? plantationYear;
  final String? latitude;
  final String? longitude;
  final String? seasonYear;
  final String? currentCycle;
  final DateTime? pruningDate;
  final List<PlotRegistrationModel> plots;
  final int? selectedSeasonPlotId;
  final List<int> startedSeasonPlotIds;

  bool get hasPlot =>
      plots.isNotEmpty || (plotName != null && plotName!.trim().isNotEmpty);
}

final farmerOnboardingDataProvider =
    StateProvider<FarmerOnboardingData?>((ref) => null);

/// Mock farmer registration API service provider
final mockFarmerRegistrationApiServiceProvider =
    Provider<MockFarmerRegistrationApiService>(
  (ref) => MockFarmerRegistrationApiService(),
);

/// Auth remote data source provider
final authRemoteDataSourceProvider =
    Provider<AuthRemoteDataSource>((ref) => AuthRemoteDataSourceImpl());

/// Auth local data source provider
final authLocalDataSourceProvider =
    FutureProvider<AuthLocalDataSource>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthLocalDataSourceImpl(
    sharedPreferences: prefs,
    secureStorage: secureStorage,
  );
});

/// Centralized auth service for session checks and logout cleanup.
final authServiceProvider = FutureProvider<AuthService>((ref) async {
  final localDataSource = await ref.watch(authLocalDataSourceProvider.future);
  return AuthService(localDataSource: localDataSource);
});

/// Auth repository provider
final authRepositoryProvider = FutureProvider<AuthRepository>((ref) async {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final localDataSource = await ref.watch(authLocalDataSourceProvider.future);
  final networkInfo = await ref.watch(networkInfoProvider.future);

  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    networkInfo: networkInfo,
  );
});

/// Farmer registration repository provider
final farmerRegistrationRepositoryProvider =
    FutureProvider<FarmerRegistrationRepository>((ref) async {
  final apiService = ref.watch(mockFarmerRegistrationApiServiceProvider);
  final localDataSource = await ref.watch(authLocalDataSourceProvider.future);

  return FarmerRegistrationRepositoryImpl(
    apiService: apiService,
    localDataSource: localDataSource,
  );
});

/// Login use case provider
final loginUseCaseProvider = FutureProvider<LoginUseCase>((ref) async {
  final repository = await ref.watch(authRepositoryProvider.future);
  return LoginUseCase(repository);
});

/// Auth state notifier provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(
    getLoginUseCase: () => ref.watch(loginUseCaseProvider.future),
    getAuthService: () => ref.watch(authServiceProvider.future),
  ),
);
