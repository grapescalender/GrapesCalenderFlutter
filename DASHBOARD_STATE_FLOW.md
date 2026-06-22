# Dashboard State Flow

## Current Data Dependencies

- Selected plot: `plotNotifierProvider` provides `plots` and `selectedPlotId`.
- Season: no first-class dashboard state exists yet. The plot detail sheet currently uses a local hardcoded season dropdown.
- Active cycle: no first-class cycle model exists yet. The dashboard currently infers cycle state from `PlotEntity.pruningDate`, `PlotEntity.isRunning`, and activity completion.
- Schedule: `scheduleNotifierProvider` loads schedules by selected plot and filter.
- Market intelligence: `CompetitionSection` uses the selected plot as context, then local mock filters and hardcoded market data.

## State Flow

| State | Dependency Signal | Dashboard Behavior |
| --- | --- | --- |
| No Plot | No selected plot or no plot list | Show one setup panel prompting the user to add a plot. Hide market intelligence, schedules, and activities. |
| Plot Exists | Plot exists without pruning date and not running | Show plot context and a season setup panel. Hide cycle-only cards. |
| Season Exists | Plot exists/running but does not have cycle pruning data | Prompt the user to choose April or October cycle details. Hide market intelligence, schedules, and activities. |
| April Cycle Active | Selected plot has pruning date from April through September | Show cycle status, market intelligence, schedules, and activities. |
| October Cycle Active | Selected plot has pruning date from October through March | Show cycle status, market intelligence, schedules, and activities. |
| Season Completed | Plot has pruning history but is not running, or all activities are completed | Show season summary action. Hide active market, schedule, and activity cards. |

## UI Handling Rule

Do not render empty placeholder cards for missing prerequisites. Use one of these states instead:

- Missing plot: setup panel.
- Missing season or cycle: setup panel.
- Active cycle with no schedules: keep the schedule header/add action, hide the empty schedule list card.
- Active cycle with no activities: hide the activity section.
- Completed season: summary panel with next action.

## Follow-up Model Recommendation

Add explicit `Season` and `Cycle` entities when backend data is available. The dashboard should eventually be keyed by:

`selectedPlot -> selectedSeason -> activeCycle -> schedules / activities / market intelligence`
