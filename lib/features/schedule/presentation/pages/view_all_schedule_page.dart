import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/dashboard_design.dart';
import '../../domain/entities/schedule_entity.dart';
import '../../../home/domain/entities/plot_entity.dart';
import '../../../home/presentation/providers/plot_notifier.dart';
import '../providers/schedule_notifier.dart';
import '../providers/schedule_providers.dart';
import '../providers/schedule_state.dart';
import '../utils/schedule_filter_utils.dart';
import '../widgets/add_schedule_popup.dart';
import '../widgets/schedule_action_menu.dart';
import '../widgets/schedule_delete_bottom_sheet.dart';
import '../widgets/schedule_context_message.dart';
import '../widgets/schedule_detail_popup.dart';
import '../widgets/schedule_filter_chip.dart';
import '../widgets/schedule_list_item.dart';

/// View All Schedule Page
/// Shows complete list of schedules with filters
/// Compact, modern design inspired by Groww
class ViewAllSchedulePage extends ConsumerStatefulWidget {
  const ViewAllSchedulePage({super.key});

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

      // Load all schedules (no limit)
      scheduleNotifier.loadSchedules(
        plotId: plotState.selectedPlotId!,
        plotName: selectedPlot.name,
        filterType: ScheduleType.all,
        limit: null, // No limit - show all
      );
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
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Modern App Bar
          _ModernAppBar(
            title: _getPageTitle(),
            subtitle: selectedPlot?.name,
            icon: Icons.calendar_month_rounded,
            onAdd: selectedPlot != null
                ? () =>
                    _showAddScheduleForm(selectedPlot!.id, selectedPlot.name)
                : null,
          ),

          // Content
          Expanded(
            child: Column(
              children: [
                // Schedule Context Message (if date filter is active)
                if (_getDateFilter() != null) ...[
                  ScheduleContextMessage(
                    startDate: _getDateFilter()!['startDate'] as DateTime?,
                    endDate: _getDateFilter()!['endDate'] as DateTime?,
                    startDay: _getDateFilter()!['startDay'] as int?,
                    endDay: _getDateFilter()!['endDay'] as int?,
                    activityName: _getDateFilter()!['activityName'] as String?,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],

                // Filter Chips (only show if not filtering by activity)
                if (_getDateFilter()?['activityId'] == null) ...[
                  _buildFilterChips(
                      context, scheduleState.selectedFilter, scheduleNotifier),
                  const SizedBox(height: AppSpacing.sm),
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
      floatingActionButton: selectedPlot != null
          ? FloatingActionButton(
              onPressed: () => _showAddScheduleForm(
                selectedPlot!.id,
                selectedPlot.name,
              ),
              child: const Icon(Icons.add_rounded),
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
      ScheduleType.water,
      ScheduleType.work,
    ];

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
        itemCount: filters.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.sm),
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
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
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
    var filteredSchedules = scheduleState.schedules;

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
          filteredSchedules = filteredSchedules
              .where((schedule) => schedule.activityIds.contains(activityId))
              .toList();
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
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
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
                  style: AppTypography.labelLarge(context).copyWith(
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

    final sortedSchedules = ScheduleFilterUtils.sortLatestFirst(
      filteredSchedules,
    );

    // Get selected plot for pruning date (once)
    final plotState = ref.read(plotNotifierProvider);
    PlotEntity? selectedPlot;
    try {
      selectedPlot = plotState.plots.firstWhere(
        (plot) => plot.id == plotState.selectedPlotId,
      );
    } catch (e) {
      if (plotState.plots.isNotEmpty) selectedPlot = plotState.plots.first;
    }

    return Container(
      color: cs.surface,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: sortedSchedules.length,
        separatorBuilder: (context, index) {
          return Divider(
            height: 1,
            thickness: 1,
            indent: AppSpacing.screenHorizontal + 4,
            endIndent: AppSpacing.screenHorizontal,
            color: cs.outline.withValues(alpha: 0.7),
          );
        },
        itemBuilder: (context, index) {
          final schedule = sortedSchedules[index];
          return ScheduleListItem(
            key: ValueKey('schedule_${schedule.id}'),
            schedule: schedule,
            pruningDate: selectedPlot?.pruningDate,
            actionMenu: ScheduleActionMenu(
              onSelected: (action) => _handleScheduleAction(
                context,
                action,
                schedule,
                selectedPlot,
              ),
            ),
            onTap: () => _showScheduleDetail(
              context,
              schedule,
              pruningDate: selectedPlot?.pruningDate,
            ),
          );
        },
      ),
    );
  }

  void _handleScheduleAction(
    BuildContext context,
    ScheduleAction action,
    ScheduleEntity schedule,
    PlotEntity? selectedPlot,
  ) {
    switch (action) {
      case ScheduleAction.view:
        _showScheduleDetail(
          context,
          schedule,
          pruningDate: selectedPlot?.pruningDate,
        );
        return;
      case ScheduleAction.edit:
        _showEditScheduleForm(schedule, selectedPlot?.name);
        return;
      case ScheduleAction.delete:
        _showDeleteConfirmation(context, schedule);
        return;
    }
  }

  /// Show Schedule Detail Popup
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
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddSchedulePopup(
        plotId: plotId,
        plotName: plotName,
      ),
    );
  }

  void _showEditScheduleForm(ScheduleEntity schedule, String? plotName) {
    showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddSchedulePopup(
        plotId: schedule.plotId,
        plotName: schedule.plotName.isEmpty
            ? plotName ?? schedule.plotId
            : schedule.plotName,
        initialSchedule: schedule,
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    ScheduleEntity schedule,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final errorColor = Theme.of(context).colorScheme.error;
    final deleted = await showModalBottomSheet<bool>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ScheduleDeleteBottomSheet(
        onConfirm: () async {
          final success = await ref
              .read(scheduleNotifierProvider.notifier)
              .deleteSchedule(schedule);
          if (!success && mounted) {
            final message = ref.read(scheduleNotifierProvider).errorMessage ??
                'Failed to delete schedule';
            messenger.showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: errorColor,
              ),
            );
          }
          return success;
        },
      ),
    );
    if (!mounted || deleted != true) return;
    ScaffoldMessenger.of(this.context).showSnackBar(
      const SnackBar(content: Text('Schedule deleted.')),
    );
  }
}

// ── Shared page chrome ────────────────────────────────────────────────────

class _ModernAppBar extends StatelessWidget {
  const _ModernAppBar({
    required this.title,
    this.subtitle,
    this.icon,
    this.onAdd,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.xs, AppSpacing.sm, AppSpacing.md, AppSpacing.sm),
        child: Row(
          children: [
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
            if (onAdd != null)
              DashboardIconButton(
                icon: Icons.add_rounded,
                onTap: onAdd!,
                tooltip: 'Add Schedule',
              ),
          ],
        ),
      ),
    );
  }
}
