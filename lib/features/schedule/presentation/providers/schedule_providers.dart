import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart';
import '../../data/datasources/schedule_remote_datasource.dart';
import '../../data/repositories/schedule_repository_impl.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../../domain/usecases/get_schedules_usecase.dart';
import '../../domain/usecases/create_schedule_usecase.dart';
import '../../domain/usecases/complete_schedule_usecase.dart';
import '../../domain/usecases/delete_schedule_usecase.dart';
import '../../domain/usecases/update_schedule_usecase.dart';
import 'schedule_notifier.dart';
import 'schedule_state.dart';

/// Schedule remote data source provider
final scheduleRemoteDataSourceProvider =
    Provider<ScheduleRemoteDataSource>((ref) => ScheduleRemoteDataSourceImpl());

/// Schedule repository provider
final scheduleRepositoryProvider =
    FutureProvider<ScheduleRepository>((ref) async {
  final remoteDataSource = ref.watch(scheduleRemoteDataSourceProvider);
  final networkInfo = await ref.watch(networkInfoProvider.future);

  return ScheduleRepositoryImpl(
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});

/// Get schedules use case provider
final getSchedulesUseCaseProvider =
    FutureProvider<GetSchedulesUseCase>((ref) async {
  final repository = await ref.watch(scheduleRepositoryProvider.future);
  return GetSchedulesUseCase(repository);
});

/// Create schedule use case provider
final createScheduleUseCaseProvider =
    FutureProvider<CreateScheduleUseCase>((ref) async {
  final repository = await ref.watch(scheduleRepositoryProvider.future);
  return CreateScheduleUseCase(repository);
});

final completeScheduleUseCaseProvider =
    FutureProvider<CompleteScheduleUseCase>((ref) async {
  final repository = await ref.watch(scheduleRepositoryProvider.future);
  return CompleteScheduleUseCase(repository);
});

final updateScheduleUseCaseProvider =
    FutureProvider<UpdateScheduleUseCase>((ref) async {
  final repository = await ref.watch(scheduleRepositoryProvider.future);
  return UpdateScheduleUseCase(repository);
});

final deleteScheduleUseCaseProvider =
    FutureProvider<DeleteScheduleUseCase>((ref) async {
  final repository = await ref.watch(scheduleRepositoryProvider.future);
  return DeleteScheduleUseCase(repository);
});

/// Schedule notifier provider
/// Note: Uses async providers - notifier fetches use cases when needed
final scheduleNotifierProvider =
    StateNotifierProvider<ScheduleNotifier, ScheduleState>(
        (ref) => ScheduleNotifier(
              getGetSchedulesUseCase: () =>
                  ref.watch(getSchedulesUseCaseProvider.future),
              getCreateScheduleUseCase: () =>
                  ref.watch(createScheduleUseCaseProvider.future),
              getCompleteScheduleUseCase: () =>
                  ref.watch(completeScheduleUseCaseProvider.future),
              getUpdateScheduleUseCase: () =>
                  ref.watch(updateScheduleUseCaseProvider.future),
              getDeleteScheduleUseCase: () =>
                  ref.watch(deleteScheduleUseCaseProvider.future),
            ));
