import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/schedule_entity.dart';

part 'schedule_state.freezed.dart';

/// Schedule state
@freezed
class ScheduleState with _$ScheduleState {
  const factory ScheduleState({
    required List<ScheduleEntity> schedules,
    required ScheduleType selectedFilter,
    required String? selectedPlotId,
    required String? selectedPlotName,
    @Default(false) bool isLoading,
    @Default(false) bool isCreating,
    String? errorMessage,
  }) = _ScheduleState;

  factory ScheduleState.initial() => const ScheduleState(
        schedules: [],
        selectedFilter: ScheduleType.all,
        selectedPlotId: null,
        selectedPlotName: null,
      );
}
