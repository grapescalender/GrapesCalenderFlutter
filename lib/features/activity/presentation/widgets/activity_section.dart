import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../config/router/app_router.dart';
import '../../../../shared/utils/date_utils.dart' as activity_date_utils;
import '../../domain/entities/activity_entity.dart';
import '../../../home/domain/entities/plot_entity.dart';
import '../../../home/presentation/providers/plot_notifier.dart';
import '../../../home/presentation/providers/plot_state.dart';
import '../../../schedule/presentation/providers/schedule_providers.dart';
import '../providers/activity_notifier.dart';
import '../providers/activity_providers.dart';
import '../providers/activity_state.dart';
import 'activity_detail_bottom_sheet.dart';
import 'activity_stepper.dart';

/// Activity Section Widget
/// Modern vertical stepper/timeline UI showing activity progression
class ActivitySection extends ConsumerStatefulWidget {
  const ActivitySection({Key? key}) : super(key: key);

  @override
  ConsumerState<ActivitySection> createState() => _ActivitySectionState();
}

class _ActivitySectionState extends ConsumerState<ActivitySection> {
  @override
  void initState() {
    super.initState();
    // Load activities when plot is selected
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadActivitiesForSelectedPlot();
      }
    });
  }

  void _loadActivitiesForSelectedPlot() {
    if (!mounted) return;
    
    final plotState = ref.read(plotNotifierProvider);
    final activityNotifier = ref.read(activityNotifierProvider.notifier);

    if (plotState.selectedPlotId != null && plotState.plots.isNotEmpty) {
      // Get plot name from plots list
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
    final plotState = ref.watch(plotNotifierProvider);
    final activityState = ref.watch(activityNotifierProvider);

    // Listen to plot selection changes in build method
    ref.listen<PlotState>(plotNotifierProvider, (previous, next) {
      if (mounted && previous?.selectedPlotId != next.selectedPlotId) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _loadActivitiesForSelectedPlot();
          }
        });
      }
    });

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

    if (selectedPlot == null || plotState.selectedPlotId == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        _buildSectionHeader(context, selectedPlot.name),
        SizedBox(height: AppSpacing.md),
        
        // Activity Stepper
        _buildActivityStepper(context, activityState, selectedPlot),
      ],
    );
  }

  /// Section Header
  Widget _buildSectionHeader(BuildContext context, String plotName) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Activities',
                  style: AppTypography.headlineLarge(context),
                ),
                SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(
                      Icons.timeline,
                      size: 16,
                      color: cs.onSurfaceVariant,
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      plotName,
                      style: AppTypography.bodyMedium(context).copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Activity Stepper
  Widget _buildActivityStepper(
    BuildContext context,
    ActivityState activityState,
    PlotEntity selectedPlot,
  ) {
    if (activityState.isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: const CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (activityState.errorMessage != null) {
      final cs = Theme.of(context).colorScheme;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: cs.errorContainer,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: cs.error,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  activityState.errorMessage!,
                  style: AppTypography.bodySmall(context).copyWith(
                    color: cs.onErrorContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
      child: ActivityStepper(
        activities: activityState.activities,
        onActivityTap: (activity) {
          _showActivityDetail(
            context,
            activity,
            selectedPlot.id,
          );
        },
        onViewAll: () {
          if (context.mounted) {
            context.push(AppRoutes.viewAllActivities);
          }
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
