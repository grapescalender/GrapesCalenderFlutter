import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/dashboard_design.dart';
import '../../../home/presentation/providers/plot_notifier.dart';
import '../providers/activity_providers.dart';
import '../../domain/entities/activity_entity.dart';

/// Activity / Reports Page — premium redesign
/// Previously a stub. Now shows a summary dashboard with quick-access cards
/// and navigates to ViewAllActivitiesPage. All navigation/state unchanged.
class ActivityPage extends ConsumerWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plotState = ref.watch(plotNotifierProvider);
    final activityState = ref.watch(activityNotifierProvider);

    final plotName = plotState.plots.isNotEmpty
        ? (plotState.plots
                .where((p) => p.id == plotState.selectedPlotId)
                .firstOrNull
                ?.name ??
            plotState.plots.first.name)
        : null;

    final activities = activityState.activities;
    final completed = activities.where((a) => a.isCompleted).length;
    final active = activities.where((a) => a.isActive).firstOrNull;
    final pending = activities.where((a) => a.isPending).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Header ──────────────────────────────────────────────
            SliverToBoxAdapter(
              child: _Header(plotName: plotName),
            ),

            // ── Summary Metrics ──────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.screenHorizontal,
                    AppSpacing.smMd, AppSpacing.screenHorizontal, 0),
                child: Row(
                  children: [
                    _MetricCard(
                      label: 'Completed',
                      value: '$completed',
                      icon: Icons.check_circle_rounded,
                      iconColor: AppColors.success,
                      bg: AppColors.successLight,
                    ),
                    const SizedBox(width: AppSpacing.smMd),
                    _MetricCard(
                      label: 'In Progress',
                      value: active != null ? '1' : '0',
                      icon: Icons.radio_button_checked_rounded,
                      iconColor: AppColors.primary,
                      bg: AppColors.primaryContainer,
                    ),
                    const SizedBox(width: AppSpacing.smMd),
                    _MetricCard(
                      label: 'Upcoming',
                      value: '$pending',
                      icon: Icons.schedule_rounded,
                      iconColor: AppColors.warning,
                      bg: AppColors.warningLight,
                    ),
                  ],
                ),
              ),
            ),

            // ── Active Activity Card ─────────────────────────────────
            if (active != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenHorizontal,
                      AppSpacing.md,
                      AppSpacing.screenHorizontal,
                      0),
                  child: _ActiveActivityCard(activity: active),
                ),
              ),

            // ── Quick Actions ────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.screenHorizontal,
                    AppSpacing.md, AppSpacing.screenHorizontal, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quick Actions',
                        style: AppTypography.titleLarge(context)
                            .copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: AppSpacing.smMd),
                    Row(
                      children: [
                        Expanded(
                          child: _ActionCard(
                            icon: Icons.timeline_rounded,
                            label: 'All Activities',
                            subtitle: 'View timeline',
                            onTap: () =>
                                context.push(AppRoutes.viewAllActivities),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.smMd),
                        Expanded(
                          child: _ActionCard(
                            icon: Icons.calendar_month_rounded,
                            label: 'All Schedules',
                            subtitle: 'View calendar',
                            onTap: () =>
                                context.push(AppRoutes.viewAllSchedules),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Cycle Progress ───────────────────────────────────────
            if (activities.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenHorizontal,
                      AppSpacing.md,
                      AppSpacing.screenHorizontal,
                      AppSpacing.xl),
                  child: _CycleProgress(activities: activities),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  const _Header({this.plotName});
  final String? plotName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screenHorizontal,
          AppSpacing.md, AppSpacing.screenHorizontal, AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: const Icon(Icons.bar_chart_rounded,
                color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: AppSpacing.smMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reports',
                    style: AppTypography.titleLarge(context).copyWith(
                      color: AppColors.onBackground,
                      fontWeight: FontWeight.w600,
                    )),
                if (plotName != null)
                  Row(
                    children: [
                      const Icon(Icons.agriculture_rounded,
                          size: 12, color: AppColors.onSurface),
                      const SizedBox(width: 3),
                      Text(plotName!,
                          style: AppTypography.labelLarge(context)
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

// ── Metric Card ───────────────────────────────────────────────────────────────
class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.bg,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DashboardCard(
        padding: const EdgeInsets.all(AppSpacing.smMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(icon, color: iconColor, size: 16),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(value,
                style: AppTypography.titleLarge(context).copyWith(
                  color: AppColors.onBackground,
                  fontWeight: FontWeight.w600,
                  height: 1.0,
                )),
            Text(label,
                style: AppTypography.labelLarge(context).copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
      ),
    );
  }
}

// ── Active Activity Card ──────────────────────────────────────────────────────
class _ActiveActivityCard extends StatelessWidget {
  const _ActiveActivityCard({required this.activity});
  final ActivityEntity activity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(activity.type.icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: AppSpacing.smMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current Activity',
                    style: AppTypography.labelLarge(context).copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    )),
                Text(activity.type.displayName,
                    style: AppTypography.titleLarge(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark,
                    )),
                if (activity.startedAt != null)
                  Text(
                    'Started ${_daysAgo(activity.startedAt!)}',
                    style: AppTypography.labelLarge(context).copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
          const DashboardPill(
            label: 'Active',
            color: AppColors.primary,
            icon: Icons.radio_button_checked_rounded,
          ),
        ],
      ),
    );
  }

  String _daysAgo(DateTime d) {
    final diff = DateTime.now().difference(d).inDays;
    if (diff == 0) return 'today';
    if (diff == 1) return '1 day ago';
    return '$diff days ago';
  }
}

// ── Action Card ───────────────────────────────────────────────────────────────
class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DashboardCard(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(icon, color: AppColors.primary, size: 18),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(label,
                style: AppTypography.labelLarge(context).copyWith(
                  color: AppColors.onBackground,
                  fontWeight: FontWeight.w600,
                )),
            Text(subtitle,
                style: AppTypography.labelLarge(context).copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
      ),
    );
  }
}

// ── Cycle Progress ────────────────────────────────────────────────────────────
class _CycleProgress extends StatelessWidget {
  const _CycleProgress({required this.activities});
  final List<ActivityEntity> activities;

  @override
  Widget build(BuildContext context) {
    final completed = activities.where((a) => a.isCompleted).length;
    final total = activities.length;
    final pct = total > 0 ? completed / total : 0.0;

    return DashboardCard(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Cycle Progress',
                  style: AppTypography.titleLarge(context).copyWith(
                    color: AppColors.onBackground,
                    fontWeight: FontWeight.w600,
                  )),
              Text('$completed / $total',
                  style: AppTypography.labelLarge(context).copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
          const SizedBox(height: AppSpacing.smMd),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 10,
              backgroundColor: AppColors.outline,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: AppSpacing.smMd),
          Text(
            '${(pct * 100).toStringAsFixed(0)}% of the cycle complete',
            style: AppTypography.labelLarge(context)
                .copyWith(color: AppColors.onSurface),
          ),
        ],
      ),
    );
  }
}
