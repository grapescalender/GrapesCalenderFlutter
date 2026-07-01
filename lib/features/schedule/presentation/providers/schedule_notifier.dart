import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/schedule_entity.dart';
import '../../domain/usecases/get_schedules_usecase.dart';
import '../../domain/usecases/create_schedule_usecase.dart';
import '../../domain/usecases/complete_schedule_usecase.dart';
import '../../domain/usecases/delete_schedule_usecase.dart';
import '../../domain/usecases/update_schedule_usecase.dart';
import 'schedule_state.dart';

/// Schedule notifier that manages schedule state
class ScheduleNotifier extends StateNotifier<ScheduleState> {
  ScheduleNotifier({
    required this.getGetSchedulesUseCase,
    required this.getCreateScheduleUseCase,
    required this.getCompleteScheduleUseCase,
    required this.getUpdateScheduleUseCase,
    required this.getDeleteScheduleUseCase,
  }) : super(ScheduleState.initial());
  final Future<GetSchedulesUseCase> Function() getGetSchedulesUseCase;
  final Future<CreateScheduleUseCase> Function() getCreateScheduleUseCase;
  final Future<CompleteScheduleUseCase> Function() getCompleteScheduleUseCase;
  final Future<UpdateScheduleUseCase> Function() getUpdateScheduleUseCase;
  final Future<DeleteScheduleUseCase> Function() getDeleteScheduleUseCase;

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
            schedules: _sortLatestFirst(schedules),
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
    bool isCompleted = false,
  }) async {
    state = state.copyWith(
      isCreating: true,
      errorMessage: null,
    );

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
          isCompleted: isCompleted,
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
          final shouldShowInCurrentFilter =
              state.selectedFilter == ScheduleType.all ||
                  state.selectedFilter == schedule.type;
          final nextSchedules = shouldShowInCurrentFilter
              ? _sortLatestFirst([
                  schedule,
                  ...state.schedules.where((item) => item.id != schedule.id),
                ])
              : state.schedules;
          state = state.copyWith(
            schedules: nextSchedules,
            selectedPlotId: plotId,
            selectedPlotName: plotName,
            isCreating: false,
            errorMessage: null,
          );
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

  Future<String?> completeSchedule(ScheduleEntity schedule) async {
    try {
      final completeScheduleUseCase = await getCompleteScheduleUseCase();
      final result = await completeScheduleUseCase(
        CompleteScheduleParams(schedule: schedule),
      );

      return result.fold(
        _mapFailureToMessage,
        (completedSchedule) {
          state = state.copyWith(
            schedules: state.schedules
                .map(
                  (item) => item.id == completedSchedule.id
                      ? completedSchedule
                      : item,
                )
                .toList()
              ..sort(_compareLatestFirst),
            errorMessage: null,
          );
          return null;
        },
      );
    } catch (e) {
      return 'Failed to complete schedule: ${e.toString()}';
    }
  }

  Future<bool> updateSchedule({
    required ScheduleEntity originalSchedule,
    required String plotId,
    required String plotName,
    required ScheduleType type,
    required String title,
    required DateTime scheduledDate,
    String? description,
    List<String> activityIds = const [],
    bool isCompleted = false,
  }) async {
    if (state.isCreating) return false;

    state = state.copyWith(
      isCreating: true,
      errorMessage: null,
    );

    try {
      final updateScheduleUseCase = await getUpdateScheduleUseCase();
      final result = await updateScheduleUseCase(
        UpdateScheduleParams(
          schedule: ScheduleEntity(
            id: originalSchedule.id,
            plotId: plotId,
            plotName: plotName,
            type: type,
            title: title,
            scheduledDate: scheduledDate,
            description: description,
            isCompleted: isCompleted,
            activityIds: activityIds,
            createdAt: originalSchedule.createdAt,
            updatedAt: DateTime.now(),
          ),
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
          final shouldShowInCurrentFilter =
              state.selectedFilter == ScheduleType.all ||
                  state.selectedFilter == schedule.type;
          final nextSchedules = shouldShowInCurrentFilter
              ? _sortLatestFirst([
                  schedule,
                  ...state.schedules.where((item) => item.id != schedule.id),
                ])
              : state.schedules
                  .where((item) => item.id != schedule.id)
                  .toList();

          state = state.copyWith(
            schedules: nextSchedules,
            selectedPlotId: plotId,
            selectedPlotName: plotName,
            isCreating: false,
            errorMessage: null,
          );
          return true;
        },
      );
    } catch (e) {
      state = state.copyWith(
        isCreating: false,
        errorMessage: 'Failed to update schedule: ${e.toString()}',
      );
      return false;
    }
  }

  Future<bool> deleteSchedule(ScheduleEntity schedule) async {
    state = state.copyWith(errorMessage: null);

    try {
      final deleteScheduleUseCase = await getDeleteScheduleUseCase();
      final result = await deleteScheduleUseCase(
        DeleteScheduleParams(scheduleId: schedule.id),
      );

      return result.fold(
        (failure) {
          state = state.copyWith(
            errorMessage: _mapFailureToMessage(failure),
          );
          return false;
        },
        (_) {
          state = state.copyWith(
            schedules: state.schedules
                .where((item) => item.id != schedule.id)
                .toList(),
            errorMessage: null,
          );
          return true;
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to delete schedule: ${e.toString()}',
      );
      return false;
    }
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

  List<ScheduleEntity> _sortLatestFirst(List<ScheduleEntity> schedules) =>
      [...schedules]..sort(_compareLatestFirst);

  int _compareLatestFirst(ScheduleEntity a, ScheduleEntity b) {
    final createdCompare = b.createdAt.compareTo(a.createdAt);
    if (createdCompare != 0) return createdCompare;
    final scheduleCompare = b.scheduledDate.compareTo(a.scheduledDate);
    if (scheduleCompare != 0) return scheduleCompare;
    return b.id.compareTo(a.id);
  }
}
