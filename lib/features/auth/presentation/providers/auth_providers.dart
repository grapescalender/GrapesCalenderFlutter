import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
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

  bool get hasPlot => plotName != null && plotName!.trim().isNotEmpty;
}

final farmerOnboardingDataProvider =
    StateProvider<FarmerOnboardingData?>((ref) => null);

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

/// Login use case provider
final loginUseCaseProvider = FutureProvider<LoginUseCase>((ref) async {
  final repository = await ref.watch(authRepositoryProvider.future);
  return LoginUseCase(repository);
});

/// Auth state notifier provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
    (ref) => AuthNotifier(() => ref.watch(loginUseCaseProvider.future)));
