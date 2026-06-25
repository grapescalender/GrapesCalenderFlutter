import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/dashboard_design.dart';
import '../../domain/entities/schedule_entity.dart';

class AnimatedPlotSummaryCard extends StatelessWidget {
  const AnimatedPlotSummaryCard({
    super.key,
    required this.plotName,
    required this.dayAfterPruning,
    required this.scheduleType,
    required this.stageName,
    required this.productCount,
    required this.pruningDate,
  });

  final String plotName;
  final int? dayAfterPruning;
  final ScheduleType scheduleType;
  final String stageName;
  final int productCount;
  final DateTime? pruningDate;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final typeColor = switch (scheduleType) {
      ScheduleType.spray => AppColors.info,
      ScheduleType.nutrition => AppColors.warning,
      ScheduleType.water => AppColors.primary,
      ScheduleType.work => AppColors.success,
      ScheduleType.all => AppColors.primary,
    };
    final hasProducts = scheduleType == ScheduleType.spray ||
        scheduleType == ScheduleType.nutrition;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SizeTransition(
          sizeFactor: animation,
          axisAlignment: -1,
          child: child,
        ),
      ),
      child: Container(
        key: ValueKey('$plotName-$scheduleType-$productCount'),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.smMd,
        ),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.6)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Row 1: Plot name + DAP badge ──────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // plot icon
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Icon(
                    Icons.agriculture_rounded,
                    size: 16,
                    color: cs.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plotName,
                        style: AppTypography.titleMedium(context).copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        stageName,
                        style: AppTypography.bodyMedium(context).copyWith(
                          color: cs.onSurfaceVariant,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // DAP badge
                if (dayAfterPruning != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  _DapBadge(days: dayAfterPruning!, color: cs.primary),
                ],
              ],
            ),

            const SizedBox(height: AppSpacing.sm),
            Divider(height: 1, color: cs.outlineVariant.withValues(alpha: 0.5)),
            const SizedBox(height: AppSpacing.sm),

            // ── Row 2: Type chip + dates ───────────────────────────────
            Row(
              children: [
                // schedule type pill
                _MiniPill(
                  label: scheduleType.displayName,
                  color: typeColor,
                ),
                if (hasProducts) ...[
                  const SizedBox(width: AppSpacing.xs),
                  _MiniPill(
                    label:
                        '$productCount Product${productCount == 1 ? '' : 's'}',
                    color: cs.primary,
                  ),
                ],
                const Spacer(),
                // dates
                _DateInfo(
                  icon: Icons.today_rounded,
                  label: DateFormat('d MMM').format(DateTime.now()),
                  color: cs.onSurfaceVariant,
                ),
                if (pruningDate != null) ...[
                  const SizedBox(width: AppSpacing.smMd),
                  _DateInfo(
                    icon: Icons.content_cut_rounded,
                    label: DateFormat('d MMM yyyy').format(pruningDate!),
                    color: cs.onSurfaceVariant,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Small helpers ──────────────────────────────────────────────────────────

class _DapBadge extends StatelessWidget {
  const _DapBadge({required this.days, required this.color});
  final int days;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$days',
            style: AppTypography.titleMedium(context).copyWith(
              color: color,
              fontWeight: FontWeight.w800,
              height: 1.0,
            ),
          ),
          Text(
            'DAP',
            style: AppTypography.labelLarge(context).copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 9,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  const _MiniPill({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Text(
        label,
        style: AppTypography.labelLarge(context).copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _DateInfo extends StatelessWidget {
  const _DateInfo({
    required this.icon,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 3),
        Text(
          label,
          style: AppTypography.labelLarge(context).copyWith(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
