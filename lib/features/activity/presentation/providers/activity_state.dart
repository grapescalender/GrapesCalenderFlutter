import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/activity_entity.dart';

part 'activity_state.freezed.dart';

/// Activity state
@freezed
class ActivityState with _$ActivityState {
  const factory ActivityState({
    required List<ActivityEntity> activities,
    required ActivityEntity? activeActivity,
    required String? selectedPlotId,
    required String? selectedPlotName,
    @Default(false) bool isLoading,
    @Default(false) bool isCompleting,
    String? errorMessage,
  }) = _ActivityState;

  factory ActivityState.initial() => const ActivityState(
        activities: [],
        activeActivity: null,
        selectedPlotId: null,
        selectedPlotName: null,
      );
}
