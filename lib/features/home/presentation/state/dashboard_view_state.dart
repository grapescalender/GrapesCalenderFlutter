import '../../../activity/domain/entities/activity_entity.dart';
import '../../domain/entities/plot_entity.dart';
import '../providers/plot_state.dart';

enum DashboardViewPhase {
  noPlot,
  plotExists,
  seasonExists,
  aprilCycleActive,
  octoberCycleActive,
  seasonCompleted,
}

class DashboardViewState {
  const DashboardViewState({
    required this.phase,
    this.selectedPlot,
  });

  final DashboardViewPhase phase;
  final PlotEntity? selectedPlot;

  bool get hasPlot => selectedPlot != null;

  bool get hasActiveCycle =>
      phase == DashboardViewPhase.aprilCycleActive ||
      phase == DashboardViewPhase.octoberCycleActive;

  bool get needsSetup =>
      phase == DashboardViewPhase.noPlot ||
      phase == DashboardViewPhase.plotExists ||
      phase == DashboardViewPhase.seasonExists;

  bool get isCompleted => phase == DashboardViewPhase.seasonCompleted;

  String get cycleLabel {
    switch (phase) {
      case DashboardViewPhase.aprilCycleActive:
        return 'April cycle active';
      case DashboardViewPhase.octoberCycleActive:
        return 'October cycle active';
      case DashboardViewPhase.seasonCompleted:
        return 'Season completed';
      case DashboardViewPhase.seasonExists:
        return 'Season ready';
      case DashboardViewPhase.plotExists:
        return 'Plot ready';
      case DashboardViewPhase.noPlot:
        return 'No plot';
    }
  }

  factory DashboardViewState.from({
    required PlotState plotState,
    List<ActivityEntity> activities = const [],
  }) {
    final selectedPlot = _selectedPlot(plotState);
    if (selectedPlot == null || plotState.selectedPlotId == null) {
      return const DashboardViewState(phase: DashboardViewPhase.noPlot);
    }

    if (!selectedPlot.hasPruningDate && !selectedPlot.isRunning) {
      return DashboardViewState(
        phase: DashboardViewPhase.plotExists,
        selectedPlot: selectedPlot,
      );
    }

    final allActivitiesCompleted = activities.isNotEmpty &&
        activities.every((activity) => activity.isCompleted);
    if ((!selectedPlot.isRunning && selectedPlot.hasPruningDate) ||
        allActivitiesCompleted) {
      return DashboardViewState(
        phase: DashboardViewPhase.seasonCompleted,
        selectedPlot: selectedPlot,
      );
    }

    if (!selectedPlot.hasPruningDate) {
      return DashboardViewState(
        phase: DashboardViewPhase.seasonExists,
        selectedPlot: selectedPlot,
      );
    }

    final pruningMonth = selectedPlot.pruningDate!.month;
    if (pruningMonth >= DateTime.april && pruningMonth <= DateTime.september) {
      return DashboardViewState(
        phase: DashboardViewPhase.aprilCycleActive,
        selectedPlot: selectedPlot,
      );
    }

    return DashboardViewState(
      phase: DashboardViewPhase.octoberCycleActive,
      selectedPlot: selectedPlot,
    );
  }

  static PlotEntity? _selectedPlot(PlotState state) {
    if (state.plots.isEmpty) return null;
    if (state.selectedPlotId == null) return null;

    try {
      return state.plots.firstWhere((plot) => plot.id == state.selectedPlotId);
    } catch (_) {
      return state.plots.first;
    }
  }
}
