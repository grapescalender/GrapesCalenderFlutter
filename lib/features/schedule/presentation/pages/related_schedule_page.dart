import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../core/design_system/theme/app_semantic_colors.dart';
import '../../domain/entities/schedule_entity.dart';
import '../../../home/domain/entities/plot_entity.dart';
import '../../../home/presentation/providers/plot_notifier.dart';
import '../providers/schedule_notifier.dart';
import '../providers/schedule_providers.dart';
import '../providers/schedule_state.dart';
import '../utils/schedule_filter_utils.dart';
import '../widgets/schedule_detail_popup.dart';

/// Related Schedule Page — premium redesign
/// All business logic preserved exactly.
class RelatedSchedulePage extends ConsumerStatefulWidget {
  const RelatedSchedulePage({super.key});

  @override
  ConsumerState<RelatedSchedulePage> createState() =>
      _RelatedSchedulePageState();
}

class _RelatedSchedulePageState extends ConsumerState<RelatedSchedulePage> {
  ScheduleType _selectedFilter = ScheduleType.all;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadSchedules();
    });
  }

  void _loadSchedules() {
    final plotState = ref.read(plotNotifierProvider);
    final notifier = ref.read(scheduleNotifierProvider.notifier);
    if (plotState.selectedPlotId == null || plotState.plots.isEmpty) return;

    PlotEntity? plot;
    try {
      plot = plotState.plots
          .firstWhere((p) => p.id == plotState.selectedPlotId);
    } catch (_) {
      plot = plotState.plots.first;
    }

    notifier.loadSchedules(
      plotId: plotState.selectedPlotId!,
      plotName: plot.name,
      filterType: null,
      limit: null,
    );
  }

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

  List<ScheduleEntity> _getFilteredSchedules(
      ScheduleState state, Map<String, dynamic>? info) {
    if (info == null) return [];
    final activityId = info['activityId'] as String?;
    final startDate = info['startDate'] as DateTime?;
    final endDate = info['endDate'] as DateTime?;
    if (activityId == null || startDate == null || endDate == null) return [];

    var filtered = ScheduleFilterUtils.getSchedulesByActivityAndDate(
      allSchedules: state.schedules,
      activityId: activityId,
      startDate: startDate,
      endDate: endDate,
    );
    if (_selectedFilter != ScheduleType.all) {
      filtered =
          filtered.where((s) => s.type == _selectedFilter).toList();
    }
    return filtered;
  }

  Map<ScheduleType, int> _getCounts(List<ScheduleEntity> all) => {
        ScheduleType.all: all.length,
        ScheduleType.spray:
            all.where((s) => s.type == ScheduleType.spray).length,
        ScheduleType.nutrition:
            all.where((s) => s.type == ScheduleType.nutrition).length,
        ScheduleType.work:
            all.where((s) => s.type == ScheduleType.work).length,
      };

  @override
  Widget build(BuildContext context) {
    final scheduleState = ref.watch(scheduleNotifierProvider);
    final activityInfo = _getActivityInfo();

    if (activityInfo == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            _PageAppBar(title: 'Related Schedules'),
            Expanded(
              child: _EmptyMessage(
                icon: Icons.calendar_today_outlined,
                title: 'No activity information available',
              ),
            ),
          ],
        ),
      );
    }

    final activityName =
        activityInfo['activityName'] as String? ?? 'Activity';
    final startDate = activityInfo['startDate'] as DateTime?;
    final endDate = activityInfo['endDate'] as DateTime?;
    final startDay = activityInfo['startDay'] as int?;
    final endDay = activityInfo['endDay'] as int?;

    final allFiltered = _getFilteredSchedules(scheduleState, activityInfo);
    final counts = _getCounts(allFiltered);
    final display = _selectedFilter == ScheduleType.all
        ? allFiltered
        : allFiltered.where((s) => s.type == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── App Bar ────────────────────────────────────────────────
          _PageAppBar(title: '$activityName Schedules'),

          // ── Date Range Banner ─────────────────────────────────────
          if (startDate != null && endDate != null)
            _DateRangeBanner(
              activityName: activityName,
              startDate: startDate,
              endDate: endDate,
              startDay: startDay,
              endDay: endDay,
            ),

          // ── Filter Tabs ───────────────────────────────────────────
          _FilterTabs(
            selected: _selectedFilter,
            counts: counts,
            onTap: (t) => setState(() => _selectedFilter = t),
          ),

          // ── List ──────────────────────────────────────────────────
          Expanded(
            child: _buildList(context, scheduleState, display, activityName),
          ),
        ],
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    ScheduleState state,
    List<ScheduleEntity> schedules,
    String activityName,
  ) {
    if (state.isLoading) return _SkeletonList();

    if (state.errorMessage != null) {
      return _EmptyMessage(
        icon: Icons.error_outline_rounded,
        iconColor: AppColors.error,
        title: 'Failed to load schedules',
        subtitle: state.errorMessage,
      );
    }

    if (schedules.isEmpty) {
      return _EmptyMessage(
        icon: Icons.calendar_today_outlined,
        title: _selectedFilter != ScheduleType.all
            ? 'No schedules for selected category'
            : 'No schedules for $activityName',
        subtitle: _selectedFilter != ScheduleType.all
            ? 'Try a different filter'
            : 'Schedules will appear here when added',
      );
    }

    final plotState = ref.read(plotNotifierProvider);
    PlotEntity? plot;
    try {
      plot = plotState.plots
          .firstWhere((p) => p.id == plotState.selectedPlotId);
    } catch (_) {
      if (plotState.plots.isNotEmpty) plot = plotState.plots.first;
    }

    return RefreshIndicator(
      onRefresh: () async {
        _loadSchedules();
        await Future.delayed(const Duration(milliseconds: 400));
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        itemCount: schedules.length,
        separatorBuilder: (_, __) =>
            const SizedBox(height: AppSpacing.smMd),
        itemBuilder: (ctx, i) => _ScheduleCard(
          schedule: schedules[i],
          pruningDate: plot?.pruningDate,
          onTap: () => _showDetail(ctx, schedules[i]),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, ScheduleEntity schedule) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ScheduleDetailPopup(schedule: schedule),
    );
  }
}

// ── Page App Bar ─────────────────────────────────────────────────────────────
class _PageAppBar extends StatelessWidget {
  const _PageAppBar({required this.title});
  final String title;

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
              padding: EdgeInsets.zero,
              icon: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusSm),
                  border: Border.all(color: AppColors.outline),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 16, color: AppColors.onBackground),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: const Icon(Icons.event_note_rounded,
                  color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(title,
                  style: AppTypography.headlineSmall(context)
                      .copyWith(fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Date Range Banner ─────────────────────────────────────────────────────────
class _DateRangeBanner extends StatelessWidget {
  const _DateRangeBanner({
    required this.activityName,
    required this.startDate,
    required this.endDate,
    this.startDay,
    this.endDay,
  });

  final String activityName;
  final DateTime startDate;
  final DateTime endDate;
  final int? startDay;
  final int? endDay;

  String _fmt(DateTime d) => DateFormat('d MMM yyyy').format(d);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(AppSpacing.screenHorizontal, 0,
          AppSpacing.screenHorizontal, AppSpacing.smMd),
      padding: const EdgeInsets.all(AppSpacing.smMd),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: const Icon(Icons.info_outline_rounded,
                color: AppColors.primary, size: 16),
          ),
          const SizedBox(width: AppSpacing.smMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activityName,
                  style: AppTypography.bodySmall(context).copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${_fmt(startDate)} → ${_fmt(endDate)}'
                  '${startDay != null && endDay != null ? '  ·  Day $startDay – Day $endDay' : ''}',
                  style: AppTypography.bodySmall(context).copyWith(
                    color: AppColors.primaryDark,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Filter Tabs ───────────────────────────────────────────────────────────────
class _FilterTabs extends StatelessWidget {
  const _FilterTabs({
    required this.selected,
    required this.counts,
    required this.onTap,
  });

  final ScheduleType selected;
  final Map<ScheduleType, int> counts;
  final ValueChanged<ScheduleType> onTap;

  static const _filters = [
    ScheduleType.all,
    ScheduleType.spray,
    ScheduleType.nutrition,
    ScheduleType.work,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal),
              itemCount: _filters.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppSpacing.sm),
              itemBuilder: (_, i) {
                final f = _filters[i];
                final count = counts[f] ?? 0;
                final isSelected = selected == f;

                return GestureDetector(
                  onTap: () => onTap(f),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.smMd, vertical: 0),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(
                          AppSpacing.radiusFull),
                      border: isSelected
                          ? null
                          : Border.all(color: AppColors.outline),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          f.displayName,
                          style: AppTypography.bodySmall(context).copyWith(
                            color: isSelected
                                ? Colors.white
                                : AppColors.onBackground,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                        ),
                        if (count > 0) ...[
                          const SizedBox(width: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white.withValues(alpha: 0.22)
                                  : AppColors.outline,
                              borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusFull),
                            ),
                            child: Text(
                              '$count',
                              style:
                                  AppTypography.bodySmall(context).copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.onBackground,
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
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
          const SizedBox(height: AppSpacing.smMd),
          const Divider(height: 1, color: AppColors.outline),
        ],
      ),
    );
  }
}

// ── Schedule Card ─────────────────────────────────────────────────────────────
class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({
    required this.schedule,
    required this.onTap,
    this.pruningDate,
  });

  final ScheduleEntity schedule;
  final VoidCallback onTap;
  final DateTime? pruningDate;

  Color _typeColor(BuildContext ctx) {
    final s = Theme.of(ctx).extension<AppSemanticColors>()!;
    if (schedule.type == ScheduleType.spray) return s.info;
    if (schedule.type == ScheduleType.nutrition) return s.warning;
    return AppColors.primary;
  }

  IconData get _typeIcon {
    if (schedule.type == ScheduleType.spray) return Icons.water_drop_outlined;
    if (schedule.type == ScheduleType.nutrition) return Icons.grass_outlined;
    return Icons.construction_outlined;
  }

  String _fmt(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final diff = DateTime(d.year, d.month, d.day).difference(today).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff == -1) return 'Yesterday';
    if (diff > 0 && diff <= 7) return 'In $diff days';
    return DateFormat('d MMM yyyy').format(d);
  }

  @override
  Widget build(BuildContext context) {
    final tc = _typeColor(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.outline),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header strip
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: tc.withValues(alpha: 0.07),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSpacing.radiusLg),
                  topRight: Radius.circular(AppSpacing.radiusLg),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: tc.withValues(alpha: 0.12),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Icon(_typeIcon, color: tc, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      schedule.title,
                      style: AppTypography.titleSmall(context).copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.onBackground,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: tc.withValues(alpha: 0.12),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: Text(
                      schedule.type.displayName,
                      style: AppTypography.bodySmall(context).copyWith(
                        color: tc,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_rounded,
                      size: 14, color: AppColors.onSurface),
                  const SizedBox(width: 5),
                  Text(
                    _fmt(schedule.scheduledDate),
                    style: AppTypography.bodySmall(context).copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (schedule.description != null &&
                      schedule.description!.isNotEmpty) ...[
                    const SizedBox(width: AppSpacing.md),
                    const Icon(Icons.notes_rounded,
                        size: 14, color: AppColors.onSurface),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        schedule.description!,
                        style: AppTypography.bodySmall(context)
                            .copyWith(color: AppColors.onSurface),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                  if (schedule.isCompleted) ...[
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.successLight,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle_rounded,
                              size: 11, color: AppColors.success),
                          const SizedBox(width: 3),
                          Text('Done',
                              style: AppTypography.bodySmall(context)
                                  .copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                              )),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Skeleton List ─────────────────────────────────────────────────────────────
class _SkeletonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.smMd),
      itemBuilder: (_, __) => Container(
        height: 88,
        decoration: BoxDecoration(
          color: AppColors.outline,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
      ),
    );
  }
}

// ── Empty / Error Message ─────────────────────────────────────────────────────
class _EmptyMessage extends StatelessWidget {
  const _EmptyMessage({
    required this.icon,
    required this.title,
    this.iconColor = AppColors.onSurface,
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
              child: Icon(icon, color: iconColor, size: 34),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(title,
                style: AppTypography.headlineSmall(context)
                    .copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(subtitle!,
                  style: AppTypography.bodySmall(context)
                      .copyWith(color: AppColors.onSurface),
                  textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }
}
