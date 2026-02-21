import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/plot_entity.dart';

part 'plot_state.freezed.dart';

/// Plot sorting order
enum PlotSortOrder {
  highToLow,
  lowToHigh,
}

/// Plot state
@freezed
class PlotState with _$PlotState {
  const factory PlotState({
    required List<PlotEntity> plots,
    required String? selectedPlotId,
    required PlotSortOrder sortOrder,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _PlotState;

  factory PlotState.initial() => const PlotState(
        plots: [],
        selectedPlotId: null,
        sortOrder: PlotSortOrder.highToLow,
      );
}
