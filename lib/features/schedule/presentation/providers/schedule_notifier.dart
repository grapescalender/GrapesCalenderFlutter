import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/schedule_entity.dart';
import '../../domain/usecases/get_schedules_usecase.dart';
import '../../domain/usecases/create_schedule_usecase.dart';
import 'schedule_state.dart';

/// Schedule notifier that manages schedule state
class ScheduleNotifier extends StateNotifier<ScheduleState> {

  ScheduleNotifier({
    required this.getGetSchedulesUseCase,
    required this.getCreateScheduleUseCase,
  }) : super(ScheduleState.initial());
  final Future<GetSchedulesUseCase> Function() getGetSchedulesUseCase;
  final Future<CreateScheduleUseCase> Function() getCreateScheduleUseCase;

  /// Load schedules for selected plot
  Future<void> loadSchedules({
    required String plotId,
    required String plotName,
    ScheduleType? filterType,
    int? limit,
  }) async {
    // Update selected plot
    state = state.copyWith(
      selectedPlotId: plotId,
      selectedPlotName: plotName,
      isLoading: true,
      errorMessage: null,
    );

    try {
      final getSchedulesUseCase = await getGetSchedulesUseCase();
      final result = await getSchedulesUseCase(
        GetSchedulesParams(
          plotId: plotId,
          filterType: filterType ?? state.selectedFilter,
          limit: limit,
        ),
      );

      result.fold(
        (failure) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: _mapFailureToMessage(failure),
          );
        },
        (schedules) {
          state = state.copyWith(
            schedules: schedules,
            isLoading: false,
            errorMessage: null,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load schedules: ${e.toString()}',
      );
    }
  }

  /// Set filter type
  void setFilter(ScheduleType filterType) {
    if (state.selectedPlotId == null) return;

    // Update filter in state
    state = state.copyWith(selectedFilter: filterType);
    
    // Note: Actual reload will be handled by ref.listen in the widget
    // This ensures we load all schedules (no limit) to properly calculate "See More"
  }

  /// Create new schedule
  Future<bool> createSchedule({
    required String plotId,
    required String plotName,
    required ScheduleType type,
    required String title,
    required DateTime scheduledDate,
    String? description,
    List<String> activityIds = const [],
  }) async {
    state = state.copyWith(isCreating: true, errorMessage: null);

    try {
      final createScheduleUseCase = await getCreateScheduleUseCase();
      final result = await createScheduleUseCase(
        CreateScheduleParams(
          plotId: plotId,
          type: type,
          title: title,
          scheduledDate: scheduledDate,
          description: description,
          activityIds: activityIds,
        ),
      );

      return result.fold(
        (failure) {
          state = state.copyWith(
            isCreating: false,
            errorMessage: _mapFailureToMessage(failure),
          );
          return false;
        },
        (schedule) {
          // Reload schedules after creation
          loadSchedules(
            plotId: plotId,
            plotName: plotName,
            filterType: state.selectedFilter,
            limit: 5,
          );
          state = state.copyWith(isCreating: false);
          return true;
        },
      );
    } catch (e) {
      state = state.copyWith(
        isCreating: false,
        errorMessage: 'Failed to create schedule: ${e.toString()}',
      );
      return false;
    }
  }

  /// Refresh schedules
  Future<void> refresh() async {
    if (state.selectedPlotId == null) return;

    await loadSchedules(
      plotId: state.selectedPlotId!,
      plotName: state.selectedPlotName ?? '',
      filterType: state.selectedFilter,
      limit: 5,
    );
  }

  String _mapFailureToMessage(Failure failure) => failure.when(
      network: (message, _) => message,
      server: (message, _) => message,
      cache: (message) => message,
      authentication: (message) => message,
      authorization: (message) => message,
      validation: (message, _) => message,
      unknown: (message, _) => message,
    );
}
