import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../domain/entities/schedule_entity.dart';
import '../../../home/domain/entities/plot_entity.dart';
import '../../../home/presentation/providers/plot_notifier.dart';
import '../../../home/presentation/providers/plot_state.dart';
import '../providers/schedule_notifier.dart';
import '../providers/schedule_providers.dart';
import '../providers/schedule_state.dart';
import '../utils/schedule_filter_utils.dart';
import '../widgets/schedule_detail_popup.dart';
import '../widgets/schedule_filter_chip.dart';

/// Related Schedule Page
/// Dedicated page for viewing schedules related to a specific activity
/// Clean, minimal design inspired by Groww
class RelatedSchedulePage extends ConsumerStatefulWidget {
  const RelatedSchedulePage({Key? key}) : super(key: key);

  @override
  ConsumerState<RelatedSchedulePage> createState() => _RelatedSchedulePageState();
}

class _RelatedSchedulePageState extends ConsumerState<RelatedSchedulePage> {
  ScheduleType _selectedFilter = ScheduleType.all;

  @override
  void initState() {
    super.initState();
    // Load schedules when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadSchedules();
      }
    });
  }

  void _loadSchedules() {
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
        // Load all schedules (no limit) for filtering
        scheduleNotifier.loadSchedules(
          plotId: plotState.selectedPlotId!,
          plotName: selectedPlot.name,
          filterType: null, // Load all types
          limit: null, // No limit
        );
      }
    }
  }

  /// Get activity info from route extra
  Map<String, dynamic>? _getActivityInfo() {
    final extra = GoRouterState.of(context).extra;
    if (extra is Map<String, dynamic>) {
      return {
        'activityId': extra['activityId'] as String?,
        'activityName': extra['activityName'] as String?,
        'startDate': extra['startDate'] as DateTime?,
        'endDate': extra['endDate'] as DateTime?,
        'startDay': extra['startDay'] as int?,
        'endDay': extra['endDay'] as int?,
      };
    }
    return null;
  }

  /// Get filtered schedules by activity and type
  List<ScheduleEntity> _getFilteredSchedules(
    ScheduleState scheduleState,
    Map<String, dynamic>? activityInfo,
  ) {
    if (activityInfo == null) return [];

    final activityId = activityInfo['activityId'] as String?;
    final startDate = activityInfo['startDate'] as DateTime?;
    final endDate = activityInfo['endDate'] as DateTime?;

    if (activityId == null || startDate == null || endDate == null) {
      return [];
    }

    // Filter by activity and date range
    var filtered = ScheduleFilterUtils.getSchedulesByActivityAndDate(
      allSchedules: scheduleState.schedules,
      activityId: activityId,
      startDate: startDate,
      endDate: endDate,
    );

    // Apply type filter
    if (_selectedFilter != ScheduleType.all) {
      filtered = filtered.where((schedule) {
        return schedule.type == _selectedFilter;
      }).toList();
    }

    return filtered;
  }

  /// Get schedule counts by type
  Map<ScheduleType, int> _getScheduleCounts(
    List<ScheduleEntity> allFilteredSchedules,
  ) {
    return {
      ScheduleType.all: allFilteredSchedules.length,
      ScheduleType.spray: allFilteredSchedules.where((s) => s.type == ScheduleType.spray).length,
      ScheduleType.nutrition: allFilteredSchedules.where((s) => s.type == ScheduleType.nutrition).length,
      ScheduleType.work: allFilteredSchedules.where((s) => s.type == ScheduleType.work).length,
    };
  }

  @override
  Widget build(BuildContext context) {
    final plotState = ref.watch(plotNotifierProvider);
    final scheduleState = ref.watch(scheduleNotifierProvider);
    final activityInfo = _getActivityInfo();

    if (activityInfo == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Related Schedules',
            style: AppTypography.headlineMedium(context).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Center(
          child: Text(
            'No activity information available',
            style: AppTypography.bodyMedium(context).copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    final activityName = activityInfo['activityName'] as String? ?? 'Activity';
    final startDate = activityInfo['startDate'] as DateTime?;
    final endDate = activityInfo['endDate'] as DateTime?;

    // Get all filtered schedules (by activity + date)
    final allFilteredSchedules = _getFilteredSchedules(
      scheduleState,
      activityInfo,
    );

    // Get counts for filter tabs
    final scheduleCounts = _getScheduleCounts(allFilteredSchedules);

    // Apply type filter
    final displaySchedules = _selectedFilter == ScheduleType.all
        ? allFilteredSchedules
        : allFilteredSchedules.where((s) => s.type == _selectedFilter).toList();

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
              '$activityName - Schedule Details',
              style: AppTypography.headlineMedium(context).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Content
          Expanded(
            child: Column(
              children: [
                // Filter Tabs with Counts
                _buildFilterTabs(context, scheduleCounts),
                const SizedBox(height: AppSpacing.md),

                // Schedule List
                Expanded(
                  child: _buildScheduleList(
                    context,
                    scheduleState,
                    displaySchedules,
                    activityName,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Filter Tabs with Counts
  Widget _buildFilterTabs(
    BuildContext context,
    Map<ScheduleType, int> scheduleCounts,
  ) {
    final filters = [
      ScheduleType.all,
      ScheduleType.spray,
      ScheduleType.nutrition,
      ScheduleType.work,
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkSurface
            : AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkOutline.withOpacity(0.2)
                : AppColors.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          itemCount: filters.length,
          separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.sm),
          itemBuilder: (context, index) {
            final filter = filters[index];
            final count = scheduleCounts[filter] ?? 0;
            final isSelected = _selectedFilter == filter;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  border: isSelected
                      ? null
                      : Border.all(
                          color: AppColors.outline,
                          width: 1,
                        ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      filter.displayName,
                      style: AppTypography.bodyMedium(context).copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppColors.onSurface,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                    if (count > 0) ...[
                      const SizedBox(width: AppSpacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withOpacity(0.3)
                              : AppColors.onSurfaceVariant.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                        ),
                        child: Text(
                          count.toString(),
                          style: AppTypography.labelSmall(context).copyWith(
                            color: isSelected
                                ? Colors.white
                                : AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Schedule List
  Widget _buildScheduleList(
    BuildContext context,
    ScheduleState scheduleState,
    List<ScheduleEntity> schedules,
    String activityName,
  ) {
    if (scheduleState.isLoading) {
      return _buildSkeletonLoader(context);
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
                color: AppColors.error,
                size: 48,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                scheduleState.errorMessage!,
                style: AppTypography.bodyMedium(context).copyWith(
                  color: AppColors.error,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (schedules.isEmpty) {
      return _buildEmptyState(context, activityName);
    }

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

    return RefreshIndicator(
      onRefresh: () async {
        _loadSchedules();
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView.separated(
        padding: EdgeInsets.all(AppSpacing.screenHorizontal),
        itemCount: schedules.length,
        separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final schedule = schedules[index];
          return _buildScheduleCard(
            context,
            schedule,
            selectedPlot?.pruningDate,
          );
        },
      ),
    );
  }

  /// Schedule Card
  Widget _buildScheduleCard(
    BuildContext context,
    ScheduleEntity schedule,
    DateTime? pruningDate,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final typeColor = _getTypeColor(schedule.type);
    final typeIcon = _getTypeIcon(schedule.type);

    return AppCard.defaultStyle(
      onTap: () => _showScheduleDetail(context, schedule),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Title and Category Tag
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Icon(
                    typeIcon,
                    size: 20,
                    color: typeColor,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                // Title and Category
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schedule.title,
                        style: AppTypography.titleMedium(context).copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.darkOnSurface
                              : AppColors.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      // Category Tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: typeColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                        ),
                        child: Text(
                          schedule.type.displayName,
                          style: AppTypography.labelSmall(context).copyWith(
                            color: typeColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // Date and Description Row
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: AppColors.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  _formatDate(schedule.scheduledDate),
                  style: AppTypography.bodySmall(context).copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                if (schedule.description != null && schedule.description!.isNotEmpty) ...[
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      schedule.description!,
                      style: AppTypography.bodySmall(context).copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Empty State
  Widget _buildEmptyState(BuildContext context, String activityName) {
    final isFiltered = _selectedFilter != ScheduleType.all;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.screenHorizontal),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              color: AppColors.onSurfaceVariant,
              size: 64,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              isFiltered
                  ? 'No schedules found for selected category'
                  : 'No schedules available for this activity',
              style: AppTypography.titleMedium(context).copyWith(
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              isFiltered
                  ? 'Try selecting a different filter'
                  : 'Schedules will appear here when added for $activityName',
              style: AppTypography.bodySmall(context).copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Skeleton Loader
  Widget _buildSkeletonLoader(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.screenHorizontal),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        );
      },
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

  /// Get type color
  Color _getTypeColor(ScheduleType type) {
    if (type == ScheduleType.spray) {
      return AppColors.info;
    } else if (type == ScheduleType.nutrition) {
      return AppColors.warning;
    } else if (type == ScheduleType.work) {
      return AppColors.primary;
    } else {
      return AppColors.onSurface;
    }
  }

  /// Get type icon
  IconData _getTypeIcon(ScheduleType type) {
    if (type == ScheduleType.spray) {
      return Icons.water_drop_outlined;
    } else if (type == ScheduleType.nutrition) {
      return Icons.grass_outlined;
    } else if (type == ScheduleType.work) {
      return Icons.construction_outlined;
    } else {
      return Icons.list_outlined;
    }
  }

  /// Format date
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    final difference = dateOnly.difference(today).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference == -1) {
      return 'Yesterday';
    } else if (difference > 0 && difference <= 7) {
      return 'In $difference days';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
