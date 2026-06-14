import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/plot_entity.dart';
import 'plot_state.dart';

/// Plot notifier that manages plot state
class PlotNotifier extends StateNotifier<PlotState> {
  PlotNotifier() : super(PlotState.initial()) {
    _loadPlots();
  }

  /// Load plots (mock data for now)
  Future<void> _loadPlots() async {
    state = state.copyWith(isLoading: true);

    // TODO: Replace with actual data source
    await Future.delayed(const Duration(milliseconds: 500));

    final mockPlots = _generateMockPlots();
    
    state = state.copyWith(
      plots: mockPlots,
      selectedPlotId: mockPlots.isNotEmpty ? mockPlots.first.id : null,
      isLoading: false,
    );

    // Apply sorting
    _sortPlots();
  }

  /// Public reload (used by UI retry states)
  Future<void> loadPlots() => _loadPlots();

  /// Generate mock plots for development
  List<PlotEntity> _generateMockPlots() {
    final now = DateTime.now();
    return [
      PlotEntity(
        id: '1',
        name: 'Plot A',
        area: 2.5,
        location: 'Field A',
        cropType: 'Grapes',
        pruningDate: now.subtract(const Duration(days: 15)),
        isRunning: true,
        createdAt: now.subtract(const Duration(days: 100)),
        updatedAt: now,
      ),
      PlotEntity(
        id: '2',
        name: 'Plot B',
        area: 3.0,
        location: 'Field B',
        cropType: 'Grapes',
        pruningDate: now.subtract(const Duration(days: 8)),
        isRunning: true,
        createdAt: now.subtract(const Duration(days: 90)),
        updatedAt: now,
      ),
      PlotEntity(
        id: '3',
        name: 'Plot C',
        area: 1.8,
        location: 'Field C',
        cropType: 'Grapes',
        pruningDate: now.subtract(const Duration(days: 25)),
        isRunning: true,
        createdAt: now.subtract(const Duration(days: 80)),
        updatedAt: now,
      ),
      PlotEntity(
        id: '4',
        name: 'Plot D',
        area: 2.2,
        location: 'Field D',
        cropType: 'Grapes',
        pruningDate: null, // Not pruned yet
        isRunning: false,
        createdAt: now.subtract(const Duration(days: 70)),
        updatedAt: now,
      ),
    ];
  }

  /// Select a plot
  void selectPlot(String plotId) {
    if (state.plots.any((plot) => plot.id == plotId)) {
      state = state.copyWith(selectedPlotId: plotId);
    }
  }

  /// Toggle sort order
  void toggleSortOrder() {
    final newOrder = state.sortOrder == PlotSortOrder.highToLow
        ? PlotSortOrder.lowToHigh
        : PlotSortOrder.highToLow;
    
    state = state.copyWith(sortOrder: newOrder);
    _sortPlots();
  }

  /// Sort plots based on current sort order
  void _sortPlots() {
    final plots = List<PlotEntity>.from(state.plots);
    
    plots.sort((a, b) {
      if (state.sortOrder == PlotSortOrder.highToLow) {
        return b.daysSincePruning.compareTo(a.daysSincePruning);
      } else {
        return a.daysSincePruning.compareTo(b.daysSincePruning);
      }
    });

    state = state.copyWith(plots: plots);
  }

  /// Get running plots only
  List<PlotEntity> get runningPlots {
    return state.plots.where((plot) => plot.isRunning).toList();
  }

  /// Check if all plots are running
  bool get areAllPlotsRunning {
    if (state.plots.isEmpty) return false;
    return state.plots.every((plot) => plot.isRunning);
  }

  /// Check if there are any running plots
  bool get hasRunningPlots {
    return state.plots.any((plot) => plot.isRunning);
  }
}

/// Plot notifier provider
final plotNotifierProvider = StateNotifierProvider<PlotNotifier, PlotState>((ref) {
  return PlotNotifier();
});
