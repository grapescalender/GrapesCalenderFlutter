import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
import '../utils/schedule_filter_utils.dart';
import '../widgets/add_schedule_form.dart';
import '../widgets/schedule_context_message.dart';
import '../widgets/schedule_detail_popup.dart';
import '../widgets/schedule_filter_chip.dart';
import '../widgets/schedule_list_item.dart';

/// View All Schedule Page
/// Shows complete list of schedules with filters
/// Compact, modern design inspired by Groww
class ViewAllSchedulePage extends ConsumerStatefulWidget {
  const ViewAllSchedulePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ViewAllSchedulePage> createState() =>
      _ViewAllSchedulePageState();
}

class _ViewAllSchedulePageState extends ConsumerState<ViewAllSchedulePage> {
  @override
  void initState() {
    super.initState();
    // Load all schedules when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadAllSchedules();
      }
    });
  }

  void _loadAllSchedules() {
    final plotState = ref.read(plotNotifierProvider);
    final scheduleNotifier = ref.read(scheduleNotifierProvider.notifier);

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
        // Load all schedules (no limit)
        scheduleNotifier.loadSchedules(
          plotId: plotState.selectedPlotId!,
          plotName: selectedPlot.name,
          filterType: ScheduleType.all,
          limit: null, // No limit - show all
        );
      }
    }
  }

  /// Get date filter, day range, and activity filter from route extra
  Map<String, dynamic>? _getDateFilter() {
    final extra = GoRouterState.of(context).extra;
    if (extra is Map<String, dynamic>) {
      return {
        'startDate': extra['startDate'] as DateTime?,
        'endDate': extra['endDate'] as DateTime?,
        'startDay': extra['startDay'] as int?,
        'endDay': extra['endDay'] as int?,
        'activityId': extra['activityId'] as String?,
        'activityName': extra['activityName'] as String?,
      };
    }
    return null;
  }

  /// Get page title based on context
  String _getPageTitle() {
    final dateFilter = _getDateFilter();
    final activityName = dateFilter?['activityName'] as String?;
    
    if (activityName != null) {
      return '$activityName - Related Schedules';
    }
    return 'All Schedules';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final plotState = ref.watch(plotNotifierProvider);
    final scheduleState = ref.watch(scheduleNotifierProvider);
    final scheduleNotifier = ref.read(scheduleNotifierProvider.notifier);

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
              _getPageTitle(),
              style: AppTypography.headlineMedium(context).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              // Add Schedule Button
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: selectedPlot != null
                    ? () => _showAddScheduleForm(
                          selectedPlot!.id,
                          selectedPlot.name,
                        )
                    : null,
                tooltip: 'Add Schedule',
              ),
            ],
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

                // Schedule Context Message (if date filter is active)
                if (_getDateFilter() != null) ...[
                  ScheduleContextMessage(
                    startDate: _getDateFilter()!['startDate'] as DateTime?,
                    endDate: _getDateFilter()!['endDate'] as DateTime?,
                    startDay: _getDateFilter()!['startDay'] as int?,
                    endDay: _getDateFilter()!['endDay'] as int?,
                    activityName: _getDateFilter()!['activityName'] as String?,
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],

                // Filter Chips (only show if not filtering by activity)
                if (_getDateFilter()?['activityId'] == null) ...[
                  _buildFilterChips(context, scheduleState.selectedFilter, scheduleNotifier),
                  const SizedBox(height: AppSpacing.md),
                ],

                // Schedule List
                Expanded(
                  child: _buildScheduleList(context, scheduleState),
                ),
              ],
            ),
          ),
        ],
      ),
      // Floating Action Button for Add Schedule
      floatingActionButton: selectedPlot != null
          ? FloatingActionButton(
              onPressed: () => _showAddScheduleForm(
                selectedPlot!.id,
                selectedPlot.name,
              ),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  /// Filter Chips
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
              notifier.setFilter(filter);
              // Reload with no limit
              final plotState = ref.read(plotNotifierProvider);
              if (plotState.selectedPlotId != null) {
                final plot = plotState.plots.firstWhere(
                  (p) => p.id == plotState.selectedPlotId,
                  orElse: () => plotState.plots.first,
                );
                notifier.loadSchedules(
                  plotId: plotState.selectedPlotId!,
                  plotName: plot.name,
                  filterType: filter,
                  limit: null,
                );
              }
            },
          );
        },
      ),
    );
  }

  /// Schedule List
  Widget _buildScheduleList(
    BuildContext context,
    ScheduleState scheduleState,
  ) {
    final cs = Theme.of(context).colorScheme;
    if (scheduleState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (scheduleState.errorMessage != null) {
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
                scheduleState.errorMessage!,
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

    // Get date and activity filter if available
    final dateFilter = _getDateFilter();
    List<ScheduleEntity> filteredSchedules = scheduleState.schedules;

    // Apply filtering if provided (from Activity context)
    if (dateFilter != null) {
      final startDate = dateFilter['startDate'] as DateTime?;
      final endDate = dateFilter['endDate'] as DateTime?;
      final activityId = dateFilter['activityId'] as String?;

      // If activity filter is active, use helper function for accurate filtering
      if (activityId != null && startDate != null && endDate != null) {
        filteredSchedules = ScheduleFilterUtils.getSchedulesByActivityAndDate(
          allSchedules: scheduleState.schedules,
          activityId: activityId,
          startDate: startDate,
          endDate: endDate,
        );

        // Debug logging
        ScheduleFilterUtils.debugPrintFilterInfo(
          activityId: activityId,
          startDate: startDate,
          endDate: endDate,
          totalSchedules: scheduleState.schedules.length,
          filteredCount: filteredSchedules.length,
          allSchedules: scheduleState.schedules,
          filteredSchedules: filteredSchedules,
        );
      } else {
        // Fallback: Apply filters separately if not all parameters are available
        if (activityId != null) {
          filteredSchedules = filteredSchedules.where((schedule) {
            return schedule.activityIds.contains(activityId);
          }).toList();
        }

        if (startDate != null || endDate != null) {
          final startDateOnly = startDate != null
              ? DateTime(startDate.year, startDate.month, startDate.day)
              : null;
          final endDateOnly = endDate != null
              ? DateTime(endDate.year, endDate.month, endDate.day)
              : null;

          filteredSchedules = filteredSchedules.where((schedule) {
            final scheduleDateOnly = DateTime(
              schedule.scheduledDate.year,
              schedule.scheduledDate.month,
              schedule.scheduledDate.day,
            );
            
            // Include schedules between startDate and endDate (inclusive)
            if (startDateOnly != null) {
              if (scheduleDateOnly.compareTo(startDateOnly) < 0) {
                return false;
              }
            }
            if (endDateOnly != null) {
              if (scheduleDateOnly.compareTo(endDateOnly) > 0) {
                return false;
              }
            }
            return true;
          }).toList();
        }
      }
    }

    if (filteredSchedules.isEmpty) {
      // Check if we're filtering by activity
      final dateFilter = _getDateFilter();
      final activityName = dateFilter?['activityName'] as String?;
      
      return Padding(
        padding: EdgeInsets.all(AppSpacing.screenHorizontal),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: cs.onSurfaceVariant,
                size: 48,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                activityName != null
                    ? 'No schedules available for this activity period'
                    : 'No schedules found',
                style: AppTypography.bodyMedium(context).copyWith(
                  color: cs.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              if (activityName != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Try selecting a different activity or date range',
                  style: AppTypography.bodySmall(context).copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
      ),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: filteredSchedules.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          thickness: 1,
          indent: AppSpacing.screenHorizontal + 4,
          endIndent: AppSpacing.screenHorizontal,
          color: cs.outline,
        ),
        itemBuilder: (context, index) {
          final schedule = filteredSchedules[index];
          // Get selected plot for pruning date
          final plotState = ref.read(plotNotifierProvider);
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
          
          return ScheduleListItem(
            key: ValueKey('schedule_${schedule.id}'),
            schedule: schedule,
            pruningDate: selectedPlot?.pruningDate,
            onTap: () => _showScheduleDetail(context, schedule),
          );
        },
      ),
    );
  }

  /// Show Schedule Detail Popup
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
