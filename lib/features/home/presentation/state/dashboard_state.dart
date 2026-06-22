/// Dashboard lifecycle states.
///
/// This model is intentionally UI-agnostic so it can later be reused by
/// providers, controllers, route guards, tests, or backend-backed state.
enum DashboardStateType {
  noPlot,
  noSeason,
  seasonCreated,
  aprilCycleActive,
  octoberCycleActive,
  seasonCompleted,
}

class DashboardState {
  const DashboardState({
    required this.type,
    this.plotId,
    this.seasonId,
    this.activeCycleId,
    this.metadata = const {},
  });

  const DashboardState.noPlot({
    Map<String, Object?> metadata = const {},
  }) : this(
          type: DashboardStateType.noPlot,
          metadata: metadata,
        );

  const DashboardState.noSeason({
    required String plotId,
    Map<String, Object?> metadata = const {},
  }) : this(
          type: DashboardStateType.noSeason,
          plotId: plotId,
          metadata: metadata,
        );

  const DashboardState.seasonCreated({
    required String plotId,
    required String seasonId,
    Map<String, Object?> metadata = const {},
  }) : this(
          type: DashboardStateType.seasonCreated,
          plotId: plotId,
          seasonId: seasonId,
          metadata: metadata,
        );

  const DashboardState.aprilCycleActive({
    required String plotId,
    required String seasonId,
    required String activeCycleId,
    Map<String, Object?> metadata = const {},
  }) : this(
          type: DashboardStateType.aprilCycleActive,
          plotId: plotId,
          seasonId: seasonId,
          activeCycleId: activeCycleId,
          metadata: metadata,
        );

  const DashboardState.octoberCycleActive({
    required String plotId,
    required String seasonId,
    required String activeCycleId,
    Map<String, Object?> metadata = const {},
  }) : this(
          type: DashboardStateType.octoberCycleActive,
          plotId: plotId,
          seasonId: seasonId,
          activeCycleId: activeCycleId,
          metadata: metadata,
        );

  const DashboardState.seasonCompleted({
    required String plotId,
    required String seasonId,
    Map<String, Object?> metadata = const {},
  }) : this(
          type: DashboardStateType.seasonCompleted,
          plotId: plotId,
          seasonId: seasonId,
          metadata: metadata,
        );

  final DashboardStateType type;
  final String? plotId;
  final String? seasonId;
  final String? activeCycleId;
  final Map<String, Object?> metadata;

  bool hasPlot() => plotId != null && type != DashboardStateType.noPlot;

  bool hasActiveSeason() =>
      seasonId != null &&
      type != DashboardStateType.noPlot &&
      type != DashboardStateType.noSeason;

  bool hasAprilCycle() => type == DashboardStateType.aprilCycleActive;

  bool hasOctoberCycle() => type == DashboardStateType.octoberCycleActive;

  bool isSeasonCompleted() => type == DashboardStateType.seasonCompleted;

  DashboardState copyWith({
    DashboardStateType? type,
    String? plotId,
    String? seasonId,
    String? activeCycleId,
    Map<String, Object?>? metadata,
  }) =>
      DashboardState(
        type: type ?? this.type,
        plotId: plotId ?? this.plotId,
        seasonId: seasonId ?? this.seasonId,
        activeCycleId: activeCycleId ?? this.activeCycleId,
        metadata: metadata ?? this.metadata,
      );
}
