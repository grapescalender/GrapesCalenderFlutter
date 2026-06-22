import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/plot_entity.dart';
import 'plot_state.dart';

/// Plot notifier that manages plot state
class PlotNotifier extends StateNotifier<PlotState> {
  PlotNotifier({
    String? username,
    FarmerOnboardingData? onboardingData,
  }) : super(PlotState.initial()) {
    _username = username;
    _onboardingData = onboardingData;
    _loadPlots();
  }

  late final String? _username;
  late final FarmerOnboardingData? _onboardingData;

  /// Load plots (mock data for now)
  Future<void> _loadPlots() async {
    state = state.copyWith(isLoading: true);

    // TODO: Replace with actual data source
    await Future<void>.delayed(const Duration(milliseconds: 500));

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
    if (_username == 'nodata' || _username == 'registered_farmer_no_plot') {
      return [];
    }

    final onboardingData = _onboardingData;
    if (_username == 'registered_farmer' &&
        onboardingData != null &&
        onboardingData.hasPlot) {
      final now = DateTime.now();
      if (onboardingData.plots.isNotEmpty) {
        return onboardingData.plots.map((plot) {
          final isSeasonPlot =
              plot.plotId == onboardingData.selectedSeasonPlotId;
          final hasStartedSeason =
              onboardingData.startedSeasonPlotIds.contains(plot.plotId);
          return PlotEntity(
            id: isSeasonPlot
                ? 'onboarding-first-plot'
                : 'onboarding-plot-${plot.plotId}',
            name: plot.plotName ?? 'Grape Plot',
            area: plot.area ?? 0,
            location: onboardingData.village,
            cropType: plot.variety ?? 'Table Grapes',
            pruningDate: hasStartedSeason ? onboardingData.pruningDate : null,
            isRunning: hasStartedSeason,
            createdAt: now,
            updatedAt: now,
          );
        }).toList();
      }

      return [
        PlotEntity(
          id: 'onboarding-first-plot',
          name: onboardingData.plotName!,
          area: onboardingData.area ?? 0,
          location: onboardingData.village,
          cropType: onboardingData.variety ?? 'Table Grapes',
          pruningDate: onboardingData.pruningDate,
          isRunning: true,
          createdAt: now,
          updatedAt: now,
        ),
      ];
    }

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
        area: 3,
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

  /// Add a plot to the local mock state
  void addPlot({
    required String name,
    required double area,
    required String location,
    required String cropType,
    required bool isRunning,
    DateTime? pruningDate,
  }) {
    final now = DateTime.now();
    final plot = PlotEntity(
      id: now.microsecondsSinceEpoch.toString(),
      name: name,
      area: area,
      location: location,
      cropType: cropType,
      pruningDate: pruningDate,
      isRunning: isRunning,
      createdAt: now,
      updatedAt: now,
    );

    state = state.copyWith(
      plots: [...state.plots, plot],
      selectedPlotId: plot.id,
      errorMessage: null,
    );
    _sortPlots();
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
    final sortOrder = state.sortOrder;

    plots.sort((a, b) {
      if (sortOrder == PlotSortOrder.highToLow) {
        return b.daysSincePruning.compareTo(a.daysSincePruning);
      } else {
        return a.daysSincePruning.compareTo(b.daysSincePruning);
      }
    });

    state = state.copyWith(plots: plots);
  }

  /// Get running plots only
  List<PlotEntity> get runningPlots =>
      state.plots.where((plot) => plot.isRunning).toList();

  /// Check if all plots are running
  bool get areAllPlotsRunning {
    if (state.plots.isEmpty) {
      return false;
    }
    return state.plots.every((plot) => plot.isRunning);
  }

  /// Check if there are any running plots
  bool get hasRunningPlots => state.plots.any((plot) => plot.isRunning);
}

/// Plot notifier provider
final plotNotifierProvider =
    StateNotifierProvider<PlotNotifier, PlotState>((ref) {
  final username = ref.watch(authNotifierProvider).maybeWhen(
        authenticated: (user) => user.username,
        orElse: () => null,
      );
  final onboardingData = ref.watch(farmerOnboardingDataProvider);

  return PlotNotifier(
    username: username,
    onboardingData: onboardingData,
  );
});
