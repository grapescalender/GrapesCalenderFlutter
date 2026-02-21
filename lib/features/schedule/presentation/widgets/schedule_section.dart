import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../config/router/app_router.dart';
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
  const ScheduleSection({Key? key}) : super(key: key);

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

      if (selectedPlot != null) {
        // Load all schedules (no limit) with current filter to get total count
        scheduleNotifier.loadSchedules(
          plotId: plotState.selectedPlotId!,
          plotName: selectedPlot.name,
          filterType: scheduleState.selectedFilter,
          limit: null, // Load all to check total filtered count
        );
      }
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
                limit: null, // Load all to check total filtered count
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
        // Header with Add Schedule icon button
        ScheduleHeader(
          title: 'Schedules',
          subtitle: plot.name,
          onAddTap: () => _showAddScheduleForm(
            plot.id,
            plot.name,
          ),
        ),
        SizedBox(height: AppSpacing.md),
        
        // Filter Chips
        _buildFilterChips(context, scheduleState.selectedFilter, scheduleNotifier),
        SizedBox(height: AppSpacing.md),
        
        // Schedule List Container
        _buildScheduleListContainer(context, scheduleState, plot),
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
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.sm),
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

  /// Schedule List Container - Wrapped in container with rounded corners
  /// Uses ListView.separated for proper list rendering with deterministic itemCount
  Widget _buildScheduleListContainer(
    BuildContext context,
    ScheduleState scheduleState,
    PlotEntity selectedPlot,
  ) {
    if (scheduleState.isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontal,
          vertical: AppSpacing.xl,
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (scheduleState.errorMessage != null) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.errorLight,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: AppColors.error,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  scheduleState.errorMessage!,
                  style: AppTypography.bodySmall(context).copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // scheduleState.schedules is already filtered by the API based on selectedFilter
    // So we can use it directly for "See More" logic
    final filteredSchedules = scheduleState.schedules;

    if (filteredSchedules.isEmpty) {
      return ScheduleSectionContainer(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.onSurfaceVariant,
                  size: 32,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'No schedules found',
                  style: AppTypography.bodyMedium(context).copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Apply "See More" logic ONLY on filteredSchedules
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
    return ScheduleSectionContainer(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), // Nested scroll
        itemCount: itemCount,
        separatorBuilder: (context, index) {
          // Don't show divider before "See More" row
          if (shouldShowSeeMore && index == displaySchedules.length - 1) {
            return const SizedBox.shrink();
          }
          // Divider between schedule items (indented after icon)
          return Divider(
            height: 1,
            thickness: 1,
            indent: 56, // After icon (40) + spacing (16)
            endIndent: 0,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkOutline.withOpacity(0.3)
                : AppColors.outline.withOpacity(0.3),
          );
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
            onTap: () => _showScheduleDetail(context, schedule),
          );
        },
      ),
    );
  }

  /// Show Schedule Detail Popup (Bottom Sheet)
  void _showScheduleDetail(BuildContext context, ScheduleEntity schedule) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ScheduleDetailPopup(schedule: schedule),
    );
  }

  /// Show Add Schedule Form
  void _showAddScheduleForm(String plotId, String plotName) {
    showModalBottomSheet(
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
