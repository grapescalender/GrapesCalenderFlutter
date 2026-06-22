import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/activity_entity.dart';
import '../../domain/usecases/get_activities_usecase.dart';
import '../../domain/usecases/start_activity_usecase.dart';
import '../../domain/usecases/complete_activity_usecase.dart';
import 'activity_state.dart';

/// Activity notifier that manages activity state
class ActivityNotifier extends StateNotifier<ActivityState> {
  ActivityNotifier({
    required this.getGetActivitiesUseCase,
    required this.getStartActivityUseCase,
    required this.getCompleteActivityUseCase,
  }) : super(ActivityState.initial());
  final Future<GetActivitiesUseCase> Function() getGetActivitiesUseCase;
  final Future<StartActivityUseCase> Function() getStartActivityUseCase;
  final Future<CompleteActivityUseCase> Function() getCompleteActivityUseCase;

  /// Load activities for selected plot
  Future<void> loadActivities({
    required String plotId,
    required String plotName,
  }) async {
    state = state.copyWith(
      selectedPlotId: plotId,
      selectedPlotName: plotName,
      isLoading: true,
      errorMessage: null,
    );

    try {
      final getActivitiesUseCase = await getGetActivitiesUseCase();
      final result = await getActivitiesUseCase(
        GetActivitiesParams(plotId: plotId),
      );

      result.fold(
        (failure) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: _mapFailureToMessage(failure),
          );
        },
        (activities) {
          // Update plot names
          final updatedActivities = activities
              .map((activity) => ActivityEntity(
                    id: activity.id,
                    plotId: activity.plotId,
                    plotName: plotName,
                    type: activity.type,
                    status: activity.status,
                    startedAt: activity.startedAt,
                    completedAt: activity.completedAt,
                    createdAt: activity.createdAt,
                    updatedAt: activity.updatedAt,
                  ))
              .toList();

          if (updatedActivities.isEmpty) {
            state = state.copyWith(
              activities: const [],
              activeActivity: null,
              isLoading: false,
              errorMessage: null,
            );
            return;
          }

          final activeActivity = updatedActivities.firstWhere(
            (activity) => activity.isActive,
            orElse: () => updatedActivities.firstWhere(
              (activity) => activity.isPending,
              orElse: () => updatedActivities.first,
            ),
          );

          state = state.copyWith(
            activities: updatedActivities,
            activeActivity: activeActivity,
            isLoading: false,
            errorMessage: null,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load activities: ${e.toString()}',
      );
    }
  }

  /// Complete an activity and auto-start next
  Future<bool> completeActivity(String activityId) async {
    state = state.copyWith(isCompleting: true, errorMessage: null);

    try {
      final completeActivityUseCase = await getCompleteActivityUseCase();
      final result = await completeActivityUseCase(
        CompleteActivityParams(activityId: activityId),
      );

      return result.fold(
        (failure) {
          state = state.copyWith(
            isCompleting: false,
            errorMessage: _mapFailureToMessage(failure),
          );
          return false;
        },
        (completedActivity) async {
          // Reload activities to get updated state
          if (state.selectedPlotId != null && state.selectedPlotName != null) {
            await loadActivities(
              plotId: state.selectedPlotId!,
              plotName: state.selectedPlotName!,
            );
          }

          // Auto-start next activity if available
          final currentActivity = state.activities.firstWhere(
            (a) => a.id == activityId,
            orElse: () => completedActivity,
          );

          final nextType = ActivityType.getNext(currentActivity.type);
          if (nextType != null && state.selectedPlotId != null) {
            await startActivity(
              plotId: state.selectedPlotId!,
              type: nextType,
            );
          }

          state = state.copyWith(isCompleting: false);
          return true;
        },
      );
    } catch (e) {
      state = state.copyWith(
        isCompleting: false,
        errorMessage: 'Failed to complete activity: ${e.toString()}',
      );
      return false;
    }
  }

  /// Start an activity
  Future<bool> startActivity({
    required String plotId,
    required ActivityType type,
  }) async {
    try {
      final startActivityUseCase = await getStartActivityUseCase();
      final result = await startActivityUseCase(
        StartActivityParams(plotId: plotId, type: type),
      );

      return result.fold(
        (failure) {
          state = state.copyWith(
            errorMessage: _mapFailureToMessage(failure),
          );
          return false;
        },
        (activity) async {
          // Reload activities to get updated state
          if (state.selectedPlotId != null && state.selectedPlotName != null) {
            await loadActivities(
              plotId: state.selectedPlotId!,
              plotName: state.selectedPlotName!,
            );
          }
          return true;
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to start activity: ${e.toString()}',
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
}
