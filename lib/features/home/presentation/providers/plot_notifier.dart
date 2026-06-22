import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/di/injection_container.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/plot_entity.dart';
import 'plot_state.dart';

/// Plot notifier that manages plot state
class PlotNotifier extends StateNotifier<PlotState> {
  PlotNotifier({
    String? username,
    FarmerOnboardingData? onboardingData,
    SharedPreferences? sharedPreferences,
  }) : super(PlotState.initial()) {
    _username = username;
    _onboardingData = onboardingData;
    _sharedPreferences = sharedPreferences;
    _loadPlots();
  }

  late final String? _username;
  late final FarmerOnboardingData? _onboardingData;
  late final SharedPreferences? _sharedPreferences;

  static const String _nextPruningPrefix = 'plot_next_pruning_date_';

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

    activateDueScheduledCycles();

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
          final plotId = isSeasonPlot
              ? 'onboarding-first-plot'
              : 'onboarding-plot-${plot.plotId}';
          return PlotEntity(
            id: plotId,
            name: plot.plotName ?? 'Grape Plot',
            area: plot.area ?? 0,
            location: onboardingData.village,
            cropType: plot.variety ?? 'Table Grapes',
            pruningDate: hasStartedSeason ? onboardingData.pruningDate : null,
            scheduledNextPruningDate: _scheduledNextPruningDate(plotId),
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
          scheduledNextPruningDate:
              _scheduledNextPruningDate('onboarding-first-plot'),
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
        scheduledNextPruningDate: _scheduledNextPruningDate('1'),
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
        scheduledNextPruningDate: _scheduledNextPruningDate('2'),
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
        scheduledNextPruningDate: _scheduledNextPruningDate('3'),
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
        scheduledNextPruningDate: _scheduledNextPruningDate('4'),
        createdAt: now.subtract(const Duration(days: 70)),
        updatedAt: now,
      ),
    ];
  }

  /// Select a plot
  void selectPlot(String plotId) {
    activateDueScheduledCycles();
    if (state.plots.any((plot) => plot.id == plotId)) {
      state = state.copyWith(selectedPlotId: plotId);
    }
  }

  /// Complete the active April cycle and schedule the next pruning date.
  ///
  /// If the selected next pruning date is today or earlier, the next cycle
  /// starts immediately. If it is a future date, the plot keeps that date as a
  /// pending cycle and `activateDueScheduledCycles` will start it when due.
  void completeAprilCycleAndScheduleNext({
    required String plotId,
    required DateTime nextPruningDate,
  }) {
    final today = _dateOnly(DateTime.now());
    final nextDate = _dateOnly(nextPruningDate);

    final plots = state.plots.map((plot) {
      if (plot.id != plotId) return plot;

      final shouldStartNow = !nextDate.isAfter(today);
      if (shouldStartNow) {
        _removeScheduledNextPruningDate(plot.id);
      } else {
        _saveScheduledNextPruningDate(plot.id, nextDate);
      }

      return plot.copyWith(
        pruningDate: shouldStartNow ? nextDate : plot.pruningDate,
        scheduledNextPruningDate: shouldStartNow ? null : nextDate,
        clearScheduledNextPruningDate: shouldStartNow,
        isRunning: shouldStartNow,
        updatedAt: DateTime.now(),
      );
    }).toList();

    state = state.copyWith(plots: plots, errorMessage: null);
    _sortPlots();
  }

  /// Start any scheduled next cycle whose pruning date has arrived.
  void activateDueScheduledCycles() {
    final today = _dateOnly(DateTime.now());
    var changed = false;

    final plots = state.plots.map((plot) {
      final scheduledDate = plot.scheduledNextPruningDate;
      if (scheduledDate == null || _dateOnly(scheduledDate).isAfter(today)) {
        return plot;
      }

      changed = true;
      _removeScheduledNextPruningDate(plot.id);
      return plot.copyWith(
        pruningDate: _dateOnly(scheduledDate),
        clearScheduledNextPruningDate: true,
        isRunning: true,
        updatedAt: DateTime.now(),
      );
    }).toList();

    if (changed) {
      state = state.copyWith(plots: plots, errorMessage: null);
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

  DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  DateTime? _scheduledNextPruningDate(String plotId) {
    final value = _sharedPreferences?.getString('$_nextPruningPrefix$plotId');
    if (value == null) return null;
    return DateTime.tryParse(value);
  }

  Future<void> _saveScheduledNextPruningDate(
    String plotId,
    DateTime date,
  ) async {
    await _sharedPreferences?.setString(
      '$_nextPruningPrefix$plotId',
      _dateOnly(date).toIso8601String(),
    );
  }

  Future<void> _removeScheduledNextPruningDate(String plotId) async {
    await _sharedPreferences?.remove('$_nextPruningPrefix$plotId');
  }
}

/// Plot notifier provider
final plotNotifierProvider =
    StateNotifierProvider<PlotNotifier, PlotState>((ref) {
  final username = ref.watch(authNotifierProvider).maybeWhen(
        authenticated: (user) => user.username,
        orElse: () => null,
      );
  final onboardingData = ref.watch(farmerOnboardingDataProvider);
  final sharedPreferences = ref.watch(sharedPreferencesProvider).valueOrNull;

  return PlotNotifier(
    username: username,
    onboardingData: onboardingData,
    sharedPreferences: sharedPreferences,
  );
});
