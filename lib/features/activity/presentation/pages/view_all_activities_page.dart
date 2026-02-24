import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../config/router/app_router.dart';
import '../../../../shared/utils/date_utils.dart' as activity_date_utils;
import '../../../home/domain/entities/plot_entity.dart';
import '../../../home/presentation/providers/plot_notifier.dart';
import '../../../home/presentation/providers/plot_state.dart';
import '../../../schedule/presentation/providers/schedule_notifier.dart';
import '../../../schedule/presentation/providers/schedule_providers.dart';
import '../../domain/entities/activity_entity.dart';
import '../providers/activity_notifier.dart';
import '../providers/activity_providers.dart';
import '../providers/activity_state.dart';
import '../widgets/activity_detail_bottom_sheet.dart';
import '../widgets/activity_item.dart';

/// View All Activities Page
/// Shows complete list of activities with vertical stepper
class ViewAllActivitiesPage extends ConsumerStatefulWidget {
  const ViewAllActivitiesPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ViewAllActivitiesPage> createState() =>
      _ViewAllActivitiesPageState();
}

class _ViewAllActivitiesPageState extends ConsumerState<ViewAllActivitiesPage> {
  @override
  void initState() {
    super.initState();
    // Load all activities when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadAllActivities();
      }
    });
  }

  void _loadAllActivities() {
    final plotState = ref.read(plotNotifierProvider);
    final activityNotifier = ref.read(activityNotifierProvider.notifier);

    if (plotState.selectedPlotId != null && plotState.plots.isNotEmpty) {
      PlotEntity? selectedPlot;
      try {
        selectedPlot = plotState.plots.firstWhere(
          (plot) => plot.id == plotState.selectedPlotId,
        );
      } catch (e) {
        selectedPlot = plotState.plots.first;
      }

      if (selectedPlot != null) {
        activityNotifier.loadActivities(
          plotId: plotState.selectedPlotId!,
          plotName: selectedPlot.name,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final plotState = ref.watch(plotNotifierProvider);
    final activityState = ref.watch(activityNotifierProvider);

    // Get selected plot name
    PlotEntity? selectedPlot;
    try {
      selectedPlot = plotState.plots.firstWhere(
        (plot) => plot.id == plotState.selectedPlotId,
      );
    } catch (e) {
      if (plotState.plots.isNotEmpty) {
        selectedPlot = plotState.plots.first;
      }
    }

    return Scaffold(
      body: Column(
        children: [
          // App Bar
          AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'All Activities',
              style: AppTypography.headlineMedium(context).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Content
          Expanded(
            child: Column(
              children: [
                // Plot Name Subtitle
                if (selectedPlot != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenHorizontal,
                      vertical: AppSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.agriculture,
                          size: 16,
                          color: cs.onSurfaceVariant,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          selectedPlot.name,
                          style: AppTypography.bodySmall(context).copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Activity List
                Expanded(
                  child: _buildActivityList(context, activityState, selectedPlot),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Activity List
  Widget _buildActivityList(
    BuildContext context,
    ActivityState activityState,
    PlotEntity? selectedPlot,
  ) {
    final cs = Theme.of(context).colorScheme;
    if (activityState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (activityState.errorMessage != null) {
      return Padding(
        padding: EdgeInsets.all(AppSpacing.screenHorizontal),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: cs.error,
                size: 48,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                activityState.errorMessage!,
                style: AppTypography.bodyMedium(context).copyWith(
                  color: cs.error,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (activityState.activities.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(AppSpacing.screenHorizontal),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.timeline_outlined,
                color: cs.onSurfaceVariant,
                size: 48,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'No activities found',
                style: AppTypography.bodyMedium(context).copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Sort activities by order
    final orderedTypes = ActivityType.orderedTypes;
    final sortedActivities = orderedTypes
        .map((type) => activityState.activities.firstWhere(
              (activity) => activity.type == type,
              orElse: () => activityState.activities.first,
            ))
        .toList();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: sortedActivities.length,
        separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          final activity = sortedActivities[index];
          final isLast = index == sortedActivities.length - 1;

          return ActivityItem(
            key: ValueKey('activity_${activity.id}'),
            activity: activity,
            isCompleted: activity.isCompleted,
            isCurrent: activity.isActive,
            isUpcoming: activity.isPending,
            showConnector: !isLast,
            onTap: (activity.isCompleted || activity.isActive)
                ? () => _showActivityDetail(
                      context,
                      activity,
                      selectedPlot?.id ?? '',
                    )
                : null,
          );
        },
      ),
    );
  }

  /// Show Activity Detail Bottom Sheet
  void _showActivityDetail(
    BuildContext context,
    ActivityEntity activity,
    String plotId,
  ) {
    // Get plot for pruning date
    final plotState = ref.read(plotNotifierProvider);
    PlotEntity? selectedPlot;
    try {
      selectedPlot = plotState.plots.firstWhere(
        (plot) => plot.id == plotId,
      );
    } catch (e) {
      if (plotState.plots.isNotEmpty) {
        selectedPlot = plotState.plots.first;
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ActivityDetailBottomSheet(
        activity: activity,
        pruningDate: selectedPlot?.pruningDate,
        onViewSchedules: () => _navigateToRelatedSchedules(
          context,
          activity,
          plotId,
          selectedPlot?.pruningDate,
        ),
      ),
    );
  }

  /// Navigate to Related Schedules with date filtering
  void _navigateToRelatedSchedules(
    BuildContext context,
    ActivityEntity activity,
    String plotId,
    DateTime? pruningDate,
  ) {
    final scheduleNotifier = ref.read(scheduleNotifierProvider.notifier);
    final plotState = ref.read(plotNotifierProvider);
    
    PlotEntity? selectedPlot;
    try {
      selectedPlot = plotState.plots.firstWhere(
        (plot) => plot.id == plotId,
      );
    } catch (e) {
      if (plotState.plots.isNotEmpty) {
        selectedPlot = plotState.plots.first;
      }
    }

    if (selectedPlot == null) return;

    // Calculate day counts
    final startDate = activity.startedAt;
    final endDate = activity.isActive ? DateTime.now() : activity.completedAt;
    
    final startDay = startDate != null && pruningDate != null
        ? activity_date_utils.ActivityDateUtils.calculateDay(pruningDate, startDate)
        : null;
    final endDay = endDate != null && pruningDate != null
        ? activity_date_utils.ActivityDateUtils.calculateDay(pruningDate, endDate)
        : null;

    // Load all schedules (will be filtered by date in ViewAllSchedulePage)
    scheduleNotifier.loadSchedules(
      plotId: plotId,
      plotName: selectedPlot.name,
      filterType: null, // Show all types
      limit: null, // Show all
    );

    // Navigate to RelatedSchedulePage with activity date range, day counts, and activity info
    if (context.mounted && startDate != null && endDate != null) {
      context.push(
        AppRoutes.relatedSchedules,
        extra: {
          'startDate': startDate,
          'endDate': endDate,
          'startDay': startDay,
          'endDay': endDay,
          'activityId': activity.id,
          'activityName': activity.type.displayName,
        },
      );
    }
  }
}
