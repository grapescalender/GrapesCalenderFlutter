import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/utils/date_utils.dart' as activity_date_utils;
import '../../../home/domain/entities/plot_entity.dart';
import '../../../home/presentation/providers/plot_notifier.dart';
import '../../../schedule/presentation/providers/schedule_providers.dart';
import '../../domain/entities/activity_entity.dart';
import '../providers/activity_providers.dart';
import '../providers/activity_state.dart';
import '../widgets/activity_detail_bottom_sheet.dart';
import '../widgets/vertical_activity_stepper.dart';

/// View All Activities Page
/// Shows complete list of activities with vertical stepper
class ViewAllActivitiesPage extends ConsumerStatefulWidget {
  const ViewAllActivitiesPage({super.key});

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

      activityNotifier.loadActivities(
        plotId: plotState.selectedPlotId!,
        plotName: selectedPlot.name,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Modern App Bar
          _ModernAppBar(
            title: 'All Activities',
            subtitle: selectedPlot?.name,
            icon: Icons.timeline_rounded,
          ),

          // Activity List
          Expanded(
            child: _buildActivityList(context, activityState, selectedPlot),
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
    if (activityState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (activityState.errorMessage != null) {
      return _CenteredMessage(
        icon: Icons.error_outline_rounded,
        iconColor: AppColors.error,
        title: 'Failed to load activities',
        subtitle: activityState.errorMessage,
      );
    }

    if (activityState.activities.isEmpty) {
      return _CenteredMessage(
        icon: Icons.timeline_outlined,
        iconColor: AppColors.onSurface,
        title: 'No activities found',
        subtitle: 'Activities will appear once your plot cycle starts',
      );
    }

    // Sort activities by type order
    final orderedTypes = ActivityType.orderedTypes;
    final sortedActivities = <ActivityEntity>[];

    for (final type in orderedTypes) {
      try {
        final activity = activityState.activities.firstWhere(
          (a) => a.type == type,
        );
        sortedActivities.add(activity);
      } catch (e) {
        // Type not found in activities, skip it
      }
    }

    return VerticalActivityStepper(
      activities: sortedActivities,
      onActivityTapped: (activity) => _showActivityDetail(
        context,
        activity,
        selectedPlot?.id ?? '',
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

    showModalBottomSheet<void>(
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
        ? activity_date_utils.ActivityDateUtils.calculateDay(
            pruningDate, startDate)
        : null;
    final endDay = endDate != null && pruningDate != null
        ? activity_date_utils.ActivityDateUtils.calculateDay(
            pruningDate, endDate)
        : null;

    // Load all schedules (will be filtered by date in ViewAllSchedulePage)
    scheduleNotifier.loadSchedules(
      plotId: plotId,
      plotName: selectedPlot.name,
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

// ── Shared page helpers ───────────────────────────────────────────────────

/// Modern app bar used across detail/list pages
class _ModernAppBar extends StatelessWidget {
  const _ModernAppBar({
    required this.title,
    this.subtitle,
    this.icon,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.xs, AppSpacing.sm, AppSpacing.md, AppSpacing.sm),
        child: Row(
          children: [
            // Back button
            IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  border: Border.all(color: AppColors.outline),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 16, color: AppColors.onBackground),
              ),
              padding: EdgeInsets.zero,
            ),
            const SizedBox(width: AppSpacing.sm),
            // Icon badge
            if (icon != null) ...[
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            // Title + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTypography.titleLarge(context).copyWith(
                        color: AppColors.onBackground,
                        fontWeight: FontWeight.w600,
                      )),
                  if (subtitle != null)
                    Row(
                      children: [
                        const Icon(Icons.agriculture_rounded,
                            size: 12, color: AppColors.onSurface),
                        const SizedBox(width: 3),
                        Text(subtitle!,
                            style: AppTypography.labelLarge(context)
                                .copyWith(color: AppColors.onSurfaceVariant)),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Centered icon + title + subtitle state
class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              child: Icon(icon, color: iconColor, size: 36),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(title,
                style: AppTypography.titleLarge(context)
                    .copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(subtitle!,
                  style: AppTypography.labelLarge(context)
                      .copyWith(color: AppColors.onSurface),
                  textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }
}
