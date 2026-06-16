import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/network/network_info.dart';
import '../../data/datasources/activity_remote_datasource.dart';
import '../../data/repositories/activity_repository_impl.dart';
import '../../domain/repositories/activity_repository.dart';
import '../../domain/usecases/get_activities_usecase.dart';
import '../../domain/usecases/start_activity_usecase.dart';
import '../../domain/usecases/complete_activity_usecase.dart';
import 'activity_notifier.dart';
import 'activity_state.dart';

/// Activity remote data source provider
final activityRemoteDataSourceProvider = Provider<ActivityRemoteDataSource>((ref) => ActivityRemoteDataSourceImpl());

/// Activity repository provider
final activityRepositoryProvider = FutureProvider<ActivityRepository>((ref) async {
  final remoteDataSource = ref.watch(activityRemoteDataSourceProvider);
  final networkInfo = await ref.watch(networkInfoProvider.future);
  
  return ActivityRepositoryImpl(
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});

/// Get activities use case provider
final getActivitiesUseCaseProvider = FutureProvider<GetActivitiesUseCase>((ref) async {
  final repository = await ref.watch(activityRepositoryProvider.future);
  return GetActivitiesUseCase(repository);
});

/// Start activity use case provider
final startActivityUseCaseProvider = FutureProvider<StartActivityUseCase>((ref) async {
  final repository = await ref.watch(activityRepositoryProvider.future);
  return StartActivityUseCase(repository);
});

/// Complete activity use case provider
final completeActivityUseCaseProvider = FutureProvider<CompleteActivityUseCase>((ref) async {
  final repository = await ref.watch(activityRepositoryProvider.future);
  return CompleteActivityUseCase(repository);
});

/// Activity notifier provider
/// Note: Uses async providers - notifier fetches use cases when needed
final activityNotifierProvider = StateNotifierProvider<ActivityNotifier, ActivityState>((ref) => ActivityNotifier(
    getGetActivitiesUseCase: () => ref.read(getActivitiesUseCaseProvider.future),
    getStartActivityUseCase: () => ref.read(startActivityUseCaseProvider.future),
    getCompleteActivityUseCase: () => ref.read(completeActivityUseCaseProvider.future),
  ));
