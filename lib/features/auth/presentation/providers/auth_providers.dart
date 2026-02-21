import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/network/network_info.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_state.dart';
import 'auth_notifier.dart';

/// Auth remote data source provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  // TODO: Inject DioClient when implementing actual API calls
  return AuthRemoteDataSourceImpl();
});

/// Auth local data source provider
final authLocalDataSourceProvider = FutureProvider<AuthLocalDataSource>((ref) async {
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
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(() => ref.watch(loginUseCaseProvider.future));
});
