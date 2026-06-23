import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../home/presentation/providers/plot_notifier.dart';
import '../providers/schedule_providers.dart';
import '../../domain/entities/schedule_entity.dart';
import '../widgets/add_schedule_form.dart';
import '../widgets/schedule_detail_popup.dart';

/// Schedule / Calendar Page — premium redesign
/// Previously a stub. Now shows today's schedules, upcoming list, and
/// a quick-add FAB. All navigation/state is unchanged.
class SchedulePage extends ConsumerStatefulWidget {
  const SchedulePage({super.key});

  @override
  ConsumerState<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends ConsumerState<SchedulePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _load();
    });
  }

  void _load() {
    final plotState = ref.read(plotNotifierProvider);
    final notifier = ref.read(scheduleNotifierProvider.notifier);
    if (plotState.selectedPlotId == null || plotState.plots.isEmpty) return;

    final plot = plotState.plots.firstWhere(
      (p) => p.id == plotState.selectedPlotId,
      orElse: () => plotState.plots.first,
    );
    notifier.loadSchedules(
      plotId: plotState.selectedPlotId!,
      plotName: plot.name,
      filterType: ScheduleType.all,
      limit: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final plotState = ref.watch(plotNotifierProvider);
    final scheduleState = ref.watch(scheduleNotifierProvider);

    final plot = plotState.plots.isNotEmpty
        ? plotState.plots.firstWhere(
            (p) => p.id == plotState.selectedPlotId,
            orElse: () => plotState.plots.first,
          )
        : null;

    final allSchedules = scheduleState.schedules;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final todaySchedules = allSchedules
        .where((s) =>
            DateTime(s.scheduledDate.year, s.scheduledDate.month,
                s.scheduledDate.day) ==
            today)
        .toList();

    final upcoming = allSchedules
        .where((s) =>
            DateTime(s.scheduledDate.year, s.scheduledDate.month,
                    s.scheduledDate.day)
                .isAfter(today) &&
            !s.isCompleted)
        .take(10)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Header ────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: _CalendarHeader(
                plotName: plot?.name,
                onViewAll: () => context.push(AppRoutes.viewAllSchedules),
              ),
            ),

            // ── Today Summary ─────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.screenHorizontal,
                    AppSpacing.smMd, AppSpacing.screenHorizontal, 0),
                child: _TodaySummary(
                    schedules: todaySchedules,
                    isLoading: scheduleState.isLoading),
              ),
            ),

            // ── Upcoming Section ─────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.screenHorizontal,
                    AppSpacing.md, AppSpacing.screenHorizontal, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Upcoming',
                        style: AppTypography.headlineSmall(context)
                            .copyWith(fontWeight: FontWeight.w700)),
                    GestureDetector(
                      onTap: () => context.push(AppRoutes.viewAllSchedules),
                      child: Row(
                        children: [
                          Text('See all',
                              style: AppTypography.bodySmall(context).copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              )),
                          const SizedBox(width: 2),
                          const Icon(Icons.arrow_forward_ios_rounded,
                              size: 11, color: AppColors.primary),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (scheduleState.isLoading)
              SliverToBoxAdapter(child: _SkeletonList())
            else if (upcoming.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: _EmptyTile(
                    icon: Icons.event_available_rounded,
                    message: 'No upcoming schedules',
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => Padding(
                    padding: EdgeInsets.fromLTRB(
                        AppSpacing.screenHorizontal,
                        AppSpacing.smMd,
                        AppSpacing.screenHorizontal,
                        i == upcoming.length - 1 ? AppSpacing.xl : 0),
                    child: _UpcomingCard(
                      schedule: upcoming[i],
                      onTap: () => _showDetail(
                        ctx,
                        upcoming[i],
                        pruningDate: plot?.pruningDate,
                      ),
                    ),
                  ),
                  childCount: upcoming.length,
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: plot != null
          ? FloatingActionButton(
              onPressed: () => _showAddForm(plot.id, plot.name),
              tooltip: 'Add Schedule',
              child: const Icon(Icons.add_rounded),
            )
          : null,
    );
  }

  void _showDetail(
    BuildContext context,
    ScheduleEntity s, {
    DateTime? pruningDate,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ScheduleDetailPopup(
        schedule: s,
        pruningDate: pruningDate,
      ),
    );
  }

  void _showAddForm(String plotId, String plotName) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddScheduleForm(plotId: plotId, plotName: plotName),
    );
  }
}

// ── Calendar Header ────────────────────────────────────────────────────────────
class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({this.plotName, required this.onViewAll});
  final String? plotName;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screenHorizontal,
          AppSpacing.md, AppSpacing.screenHorizontal, 0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: const Icon(Icons.calendar_month_rounded,
                color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: AppSpacing.smMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Calendar',
                    style: AppTypography.headlineMedium(context)
                        .copyWith(fontWeight: FontWeight.w700)),
                Row(
                  children: [
                    const Icon(Icons.today_rounded,
                        size: 12, color: AppColors.onSurface),
                    const SizedBox(width: 3),
                    Text(DateFormat('EEE, d MMM yyyy').format(now),
                        style: AppTypography.bodySmall(context)
                            .copyWith(color: AppColors.onSurface)),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onViewAll,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.smMd, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: Row(
                children: [
                  const Icon(Icons.list_alt_rounded,
                      size: 14, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text('All',
                      style: AppTypography.bodySmall(context).copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Today Summary ──────────────────────────────────────────────────────────────
class _TodaySummary extends StatelessWidget {
  const _TodaySummary({required this.schedules, required this.isLoading});
  final List<ScheduleEntity> schedules;
  final bool isLoading;

  IconData _typeIcon(ScheduleType t) {
    if (t == ScheduleType.spray) return Icons.water_drop_outlined;
    if (t == ScheduleType.nutrition) return Icons.grass_outlined;
    return Icons.construction_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Today's Schedules",
                  style: AppTypography.headlineSmall(context).copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  )),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: Text(
                  isLoading ? '—' : '${schedules.length}',
                  style: AppTypography.bodySmall(context).copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.smMd),
          if (isLoading)
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
            )
          else if (schedules.isEmpty)
            Text('No schedules for today — enjoy your day!',
                style: AppTypography.bodySmall(context).copyWith(
                  color: Colors.white70,
                ))
          else
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: schedules.map((s) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_typeIcon(s.type), size: 13, color: Colors.white),
                      const SizedBox(width: 5),
                      Text(
                        s.title.length > 18
                            ? '${s.title.substring(0, 18)}…'
                            : s.title,
                        style: AppTypography.bodySmall(context).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

// ── Upcoming Card ─────────────────────────────────────────────────────────────
class _UpcomingCard extends StatelessWidget {
  const _UpcomingCard({required this.schedule, required this.onTap});
  final ScheduleEntity schedule;
  final VoidCallback onTap;

  Color _typeColor(BuildContext ctx) {
    if (schedule.type == ScheduleType.spray) return AppColors.info;
    if (schedule.type == ScheduleType.nutrition) return const Color(0xFFF59E0B);
    return AppColors.primary;
  }

  IconData get _typeIcon {
    if (schedule.type == ScheduleType.spray) return Icons.water_drop_outlined;
    if (schedule.type == ScheduleType.nutrition) return Icons.grass_outlined;
    return Icons.construction_outlined;
  }

  String _relDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(schedule.scheduledDate.year,
        schedule.scheduledDate.month, schedule.scheduledDate.day);
    final diff = d.difference(today).inDays;
    if (diff == 1) return 'Tomorrow';
    if (diff <= 7) return 'In $diff days';
    return DateFormat('d MMM').format(schedule.scheduledDate);
  }

  @override
  Widget build(BuildContext context) {
    final tc = _typeColor(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.smMd),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.outline),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: tc.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(_typeIcon, color: tc, size: 18),
            ),
            const SizedBox(width: AppSpacing.smMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(schedule.title,
                      style: AppTypography.titleSmall(context)
                          .copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Row(
                    children: [
                      const Icon(Icons.circle,
                          size: 6, color: AppColors.onSurface),
                      const SizedBox(width: 4),
                      Text(schedule.type.displayName,
                          style: AppTypography.bodySmall(context).copyWith(
                            color: tc,
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          )),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                border: Border.all(color: AppColors.outline),
              ),
              child: Text(_relDate(),
                  style: AppTypography.bodySmall(context).copyWith(
                    color: AppColors.onBackground,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Skeleton ──────────────────────────────────────────────────────────────────
class _SkeletonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        4,
        (i) => Padding(
          padding: EdgeInsets.fromLTRB(AppSpacing.screenHorizontal,
              AppSpacing.smMd, AppSpacing.screenHorizontal, 0),
          child: Container(
            height: 62,
            decoration: BoxDecoration(
              color: AppColors.outline,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Empty Tile ────────────────────────────────────────────────────────────────
class _EmptyTile extends StatelessWidget {
  const _EmptyTile({required this.icon, required this.message});
  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(color: AppColors.outline),
            ),
            child: Icon(icon, color: AppColors.onSurface, size: 30),
          ),
          const SizedBox(height: AppSpacing.smMd),
          Text(message,
              style: AppTypography.bodyMedium(context)
                  .copyWith(color: AppColors.onSurface)),
        ],
      ),
    );
  }
}
