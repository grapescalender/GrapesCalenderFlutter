import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../config/router/app_router.dart';
import '../../../../shared/widgets/dashboard_design.dart';
import '../../../../shared/widgets/app_ui.dart';
import '../../domain/entities/schedule_entity.dart';
import '../../../home/domain/entities/plot_entity.dart';
import '../../../home/presentation/providers/plot_notifier.dart';
import '../../../home/presentation/providers/plot_state.dart';
import '../providers/schedule_notifier.dart';
import '../providers/schedule_providers.dart';
import '../providers/schedule_state.dart';
import 'add_schedule_form.dart';
import 'schedule_detail_popup.dart';
import 'schedule_filter_chip.dart';
import 'schedule_header.dart';
import 'schedule_list_item.dart';
import 'schedule_section_container.dart';
import 'see_more_row.dart';

/// Schedule Section Widget
/// Compact, modern design inspired by Groww's Volume Shockers
/// Features: Clean header, filter chips, compact list rows in container, detail popup
class ScheduleSection extends ConsumerStatefulWidget {
  const ScheduleSection({super.key});

  @override
  ConsumerState<ScheduleSection> createState() => _ScheduleSectionState();
}

class _ScheduleSectionState extends ConsumerState<ScheduleSection> {
  @override
  void initState() {
    super.initState();
    // Load schedules when plot is selected
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadSchedulesForSelectedPlot();
      }
    });
  }

  void _loadSchedulesForSelectedPlot() {
    final plotState = ref.read(plotNotifierProvider);
    final scheduleNotifier = ref.read(scheduleNotifierProvider.notifier);
    final scheduleState = ref.read(scheduleNotifierProvider);

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

      // Load all schedules (no limit) with current filter to get total count
      scheduleNotifier.loadSchedules(
        plotId: plotState.selectedPlotId!,
        plotName: selectedPlot.name,
        filterType: scheduleState.selectedFilter,
        limit: null, // Load all to check total filtered count
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final plotState = ref.watch(plotNotifierProvider);
    final scheduleState = ref.watch(scheduleNotifierProvider);
    final scheduleNotifier = ref.read(scheduleNotifierProvider.notifier);

    // Listen to plot selection changes in build method
    ref.listen<PlotState>(plotNotifierProvider, (previous, next) {
      if (mounted && previous?.selectedPlotId != next.selectedPlotId) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _loadSchedulesForSelectedPlot();
          }
        });
      }
    });

    // Listen to filter changes and reload schedules
    ref.listen<ScheduleState>(scheduleNotifierProvider, (previous, next) {
      if (mounted && previous?.selectedFilter != next.selectedFilter) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && next.selectedPlotId != null) {
            final plotState = ref.read(plotNotifierProvider);
            PlotEntity? selectedPlot;
            try {
              selectedPlot = plotState.plots.firstWhere(
                (plot) => plot.id == next.selectedPlotId,
              );
            } catch (e) {
              if (plotState.plots.isNotEmpty) {
                selectedPlot = plotState.plots.first;
              }
            }
            if (selectedPlot != null) {
              scheduleNotifier.loadSchedules(
                plotId: next.selectedPlotId!,
                plotName: selectedPlot.name,
                filterType: next.selectedFilter,
              );
            }
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

    // Store in local variable for null safety
    final plot = selectedPlot;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header sits outside the schedule card, matching Competition Analysis.
        ScheduleHeader(
          title: 'Schedules',
          subtitle: plot.name,
        ),
        const SizedBox(height: AppSpacing.xs),
        ScheduleSectionContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFilterActionRow(
                context,
                scheduleState.selectedFilter,
                scheduleNotifier,
                onAddTap: () => _showAddScheduleForm(
                  plot.id,
                  plot.name,
                ),
                showFilters: scheduleState.schedules.isNotEmpty,
              ),
              const SizedBox(height: AppSpacing.smMd),
              _buildScheduleListContainer(context, scheduleState, plot),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterActionRow(
    BuildContext context,
    ScheduleType selectedFilter,
    ScheduleNotifier notifier, {
    required VoidCallback onAddTap,
    required bool showFilters,
  }) {
    return Row(
      children: [
        Expanded(
          child: showFilters
              ? _buildFilterChips(
                  context,
                  selectedFilter,
                  notifier,
                )
              : const SizedBox.shrink(),
        ),
        const SizedBox(width: AppSpacing.sm),
        DashboardIconButton(
          icon: Icons.add_rounded,
          onTap: onAddTap,
          tooltip: 'Add Schedule',
        ),
      ],
    );
  }

  /// Filter Chips - Compact horizontal scroll
  Widget _buildFilterChips(
    BuildContext context,
    ScheduleType selectedFilter,
    ScheduleNotifier notifier,
  ) {
    final filters = [
      ScheduleType.all,
      ScheduleType.spray,
      ScheduleType.nutrition,
      ScheduleType.work,
    ];

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: filters.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final filter = filters[index];
          return ScheduleFilterChip(
            filterType: filter,
            isSelected: selectedFilter == filter,
            onTap: () {
              // Update filter - this will trigger reload via ref.listen
              notifier.setFilter(filter);
            },
          );
        },
      ),
    );
  }

  /// Schedule List Content
  /// Uses ListView.separated for proper list rendering with deterministic itemCount
  Widget _buildScheduleListContainer(
    BuildContext context,
    ScheduleState scheduleState,
    PlotEntity selectedPlot,
  ) {
    AsyncViewStatus status;
    if (scheduleState.isLoading) {
      status = AsyncViewStatus.loading;
    } else if (scheduleState.errorMessage != null) {
      status = AsyncViewStatus.error;
    } else if (scheduleState.schedules.isEmpty) {
      status = AsyncViewStatus.empty;
    } else {
      status = AsyncViewStatus.success;
    }

    return AppAsyncContent(
      status: status,
      errorTitle: 'Failed to load schedules',
      errorMessage: scheduleState.errorMessage,
      onRetry: _loadSchedulesForSelectedPlot,
      inlineError: true,
      emptyIcon: Icons.calendar_today_outlined,
      emptyTitle: 'No schedules added yet',
      emptySubtitle:
          'Create your first spray, nutrition, or work reminder. You can link it with the current activity while adding it.',
      emptyActionLabel: 'Add Schedule',
      onEmptyAction: () => _showAddScheduleForm(
        selectedPlot.id,
        selectedPlot.name,
      ),
      compactEmpty: true,
      loading: const AppLoadingState.listRows(itemHeight: 56),
      builder: (context) =>
          _buildScheduleList(context, scheduleState, selectedPlot),
    );
  }

  Widget _buildScheduleList(
    BuildContext context,
    ScheduleState scheduleState,
    PlotEntity selectedPlot,
  ) {
    final filteredSchedules = scheduleState.schedules;
    // If filteredSchedules.length > 5, show first 5 + "See More"
    // If filteredSchedules.length <= 5, show all + NO "See More"
    final totalFilteredSchedules = filteredSchedules.length;
    final shouldShowSeeMore = totalFilteredSchedules > 5;

    // Get display schedules: show first 5 if more than 5, else show all
    final displaySchedules = shouldShowSeeMore
        ? filteredSchedules.take(5).toList()
        : filteredSchedules;

    // Calculate itemCount: display schedules + (1 if See More should show)
    final itemCount = displaySchedules.length + (shouldShowSeeMore ? 1 : 0);

    // Build list using ListView.separated for proper rendering
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // Nested scroll
      itemCount: itemCount,
      separatorBuilder: (context, index) {
        // Don't show divider before "See More" row
        if (shouldShowSeeMore && index == displaySchedules.length - 1) {
          return const SizedBox.shrink();
        }
        return const SizedBox(height: AppSpacing.xs);
      },
      itemBuilder: (context, index) {
        // If this is the "See More" row index
        if (shouldShowSeeMore && index == displaySchedules.length) {
          return SeeMoreRow(
            onTap: () {
              if (context.mounted) {
                context.push(AppRoutes.viewAllSchedules);
              }
            },
          );
        }

        // Schedule item
        final schedule = displaySchedules[index];
        return ScheduleListItem(
          key: ValueKey('schedule_${schedule.id}'),
          schedule: schedule,
          pruningDate: selectedPlot.pruningDate,
          onTap: () => _showScheduleDetail(
            context,
            schedule,
            pruningDate: selectedPlot.pruningDate,
          ),
        );
      },
    );
  }

  /// Show Schedule Detail Popup (Bottom Sheet)
  void _showScheduleDetail(
    BuildContext context,
    ScheduleEntity schedule, {
    DateTime? pruningDate,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ScheduleDetailPopup(
        schedule: schedule,
        pruningDate: pruningDate,
      ),
    );
  }

  /// Show Add Schedule Form
  void _showAddScheduleForm(String plotId, String plotName) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddScheduleForm(
        plotId: plotId,
        plotName: plotName,
      ),
    );
  }
}
