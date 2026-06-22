import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/utils/date_utils.dart' as activity_date_utils;
import '../../../../shared/widgets/app_ui.dart';
import '../../../home/domain/entities/plot_entity.dart';
import '../../../home/presentation/providers/plot_notifier.dart';
import '../../../home/presentation/providers/plot_state.dart';
import '../../../schedule/presentation/providers/schedule_providers.dart';
import '../../domain/entities/activity_entity.dart';
import '../providers/activity_providers.dart';
import '../providers/activity_state.dart';
import 'activity_detail_bottom_sheet.dart';
import 'horizontal_activity_stepper.dart';

/// Activity Section — home screen widget
/// All functionality preserved; only visual chrome updated.
class ActivitySection extends ConsumerStatefulWidget {
  const ActivitySection({super.key});

  @override
  ConsumerState<ActivitySection> createState() => _ActivitySectionState();
}

class _ActivitySectionState extends ConsumerState<ActivitySection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadActivities();
    });
  }

  void _loadActivities() {
    if (!mounted) return;
    final plotState = ref.read(plotNotifierProvider);
    final notifier = ref.read(activityNotifierProvider.notifier);
    if (plotState.selectedPlotId == null || plotState.plots.isEmpty) return;

    PlotEntity? plot;
    try {
      plot =
          plotState.plots.firstWhere((p) => p.id == plotState.selectedPlotId);
    } catch (_) {
      plot = plotState.plots.first;
    }
    notifier.loadActivities(
        plotId: plotState.selectedPlotId!, plotName: plot.name);
  }

  @override
  Widget build(BuildContext context) {
    final plotState = ref.watch(plotNotifierProvider);
    final activityState = ref.watch(activityNotifierProvider);

    // Reload on plot switch
    ref.listen<PlotState>(plotNotifierProvider, (prev, next) {
      if (mounted && prev?.selectedPlotId != next.selectedPlotId) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _loadActivities();
        });
      }
    });

    PlotEntity? selectedPlot;
    try {
      selectedPlot =
          plotState.plots.firstWhere((p) => p.id == plotState.selectedPlotId);
    } catch (_) {
      if (plotState.plots.isNotEmpty) selectedPlot = plotState.plots.first;
    }

    if (selectedPlot == null || plotState.selectedPlotId == null) {
      return const SizedBox.shrink();
    }

    if (!activityState.isLoading &&
        activityState.errorMessage == null &&
        activityState.activities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(plotName: selectedPlot.name),
        const SizedBox(height: AppSpacing.smMd),
        _buildStepper(context, activityState, selectedPlot),
      ],
    );
  }

  Widget _buildStepper(
      BuildContext context, ActivityState state, PlotEntity plot) {
    AsyncViewStatus status;
    if (state.isLoading) {
      status = AsyncViewStatus.loading;
    } else if (state.errorMessage != null) {
      status = AsyncViewStatus.error;
    } else {
      status = AsyncViewStatus.success;
    }

    return AppAsyncContent(
      status: status,
      errorTitle: 'Failed to load activities',
      errorMessage: state.errorMessage,
      inlineError: true,
      emptyIcon: Icons.timeline_outlined,
      emptyTitle: 'No activities found',
      emptySubtitle: 'Activities will appear once your plot cycle starts',
      compactEmpty: true,
      loading: AppLoadingState.blocks(heights: const [80, 100]),
      builder: (context) => Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
        child: HorizontalActivityStepper(
          activities: state.activities,
          selectedActivity: state.activities.firstWhere(
            (a) => a.isActive,
            orElse: () => state.activities.first,
          ),
          onStepTapped: (a) => _showDetail(context, a, plot.id),
          onViewAllActivities: () {
            if (context.mounted) context.push(AppRoutes.viewAllActivities);
          },
        ),
      ),
    );
  }

  void _showDetail(
      BuildContext context, ActivityEntity activity, String plotId) {
    final plotState = ref.read(plotNotifierProvider);
    PlotEntity? plot;
    try {
      plot = plotState.plots.firstWhere((p) => p.id == plotId);
    } catch (_) {
      if (plotState.plots.isNotEmpty) plot = plotState.plots.first;
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ActivityDetailBottomSheet(
        activity: activity,
        pruningDate: plot?.pruningDate,
        onViewSchedules: () =>
            _navigateToSchedules(context, activity, plotId, plot?.pruningDate),
      ),
    );
  }

  void _navigateToSchedules(BuildContext context, ActivityEntity activity,
      String plotId, DateTime? pruningDate) {
    final plotState = ref.read(plotNotifierProvider);
    PlotEntity? plot;
    try {
      plot = plotState.plots.firstWhere((p) => p.id == plotId);
    } catch (_) {
      if (plotState.plots.isNotEmpty) plot = plotState.plots.first;
    }
    if (plot == null) return;

    final scheduleNotifier = ref.read(scheduleNotifierProvider.notifier);
    scheduleNotifier.loadSchedules(plotId: plotId, plotName: plot.name);

    final startDate = activity.startedAt;
    final endDate = activity.isActive ? DateTime.now() : activity.completedAt;
    if (context.mounted && startDate != null && endDate != null) {
      final startDay = pruningDate != null
          ? activity_date_utils.ActivityDateUtils.calculateDay(
              pruningDate, startDate)
          : null;
      final endDay = pruningDate != null
          ? activity_date_utils.ActivityDateUtils.calculateDay(
              pruningDate, endDate)
          : null;
      context.push(AppRoutes.relatedSchedules, extra: {
        'startDate': startDate,
        'endDate': endDate,
        'startDay': startDay,
        'endDay': endDay,
        'activityId': activity.id,
        'activityName': activity.type.displayName,
      });
    }
  }
}

// ── Section header ────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.plotName});
  final String plotName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon badge
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: const Icon(Icons.timeline_rounded,
                color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Activities',
                    style: AppTypography.headlineSmall(context)
                        .copyWith(fontWeight: FontWeight.w700)),
                Row(
                  children: [
                    const Icon(Icons.agriculture_rounded,
                        size: 12, color: AppColors.onSurface),
                    const SizedBox(width: 3),
                    Text(plotName,
                        style: AppTypography.bodySmall(context)
                            .copyWith(color: AppColors.onSurface)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
