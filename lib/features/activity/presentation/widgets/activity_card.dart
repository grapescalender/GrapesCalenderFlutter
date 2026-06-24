import 'package:flutter/material.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/dashboard_design.dart';
import '../../domain/entities/activity_entity.dart';
import '../../../../shared/utils/date_utils.dart' as date_utils;

/// Modern Activity Card — used in both horizontal and vertical steppers
class ActivityCard extends StatelessWidget {
  const ActivityCard({
    Key? key,
    required this.activity,
    this.isSelected = false,
    this.isClickable = true,
    this.onTap,
    this.dayCount = 0,
    this.startDay = 0,
  }) : super(key: key);

  final ActivityEntity activity;
  final bool isSelected;
  final bool isClickable;
  final VoidCallback? onTap;
  final int dayCount;
  final int startDay;

  // ── Status helpers ────────────────────────────────────────────────────────
  Color _statusColor(ActivityStatus s) {
    switch (s) {
      case ActivityStatus.completed:
        return AppColors.success;
      case ActivityStatus.active:
        return AppColors.primary;
      case ActivityStatus.pending:
        return AppColors.onSurface;
    }
  }

  String _statusLabel(ActivityStatus s) {
    switch (s) {
      case ActivityStatus.completed:
        return 'Completed';
      case ActivityStatus.active:
        return 'In Progress';
      case ActivityStatus.pending:
        return 'Upcoming';
    }
  }

  IconData _statusIcon(ActivityStatus s) {
    switch (s) {
      case ActivityStatus.completed:
        return Icons.check_circle_rounded;
      case ActivityStatus.active:
        return Icons.radio_button_checked_rounded;
      case ActivityStatus.pending:
        return Icons.radio_button_unchecked_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = activity.status;
    final isActive = activity.isActive;
    final isCompleted = activity.isCompleted;

    return GestureDetector(
      onTap: isClickable ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color:
                isSelected && isActive ? AppColors.primary : AppColors.outline,
            width: isSelected && isActive ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: isSelected && isActive ? 12 : 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header strip ───────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.smMd,
                vertical: AppSpacing.smMd,
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primaryContainer
                    : isCompleted
                        ? AppColors.successLight
                        : AppColors.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSpacing.radiusLg),
                  topRight: Radius.circular(AppSpacing.radiusLg),
                ),
              ),
              child: Row(
                children: [
                  // Icon badge
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _statusColor(s).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Icon(activity.type.icon,
                        color: _statusColor(s), size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.type.displayName,
                          style: AppTypography.cardTitle(context).copyWith(
                            color: _statusColor(s),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (activity.plotName.isNotEmpty)
                          Text(
                            activity.plotName,
                            style: AppTypography.cardSubtitle(context).copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  // Status chip
                  DashboardPill(
                    label: _statusLabel(s),
                    color: _statusColor(s),
                    icon: _statusIcon(s),
                  ),
                ],
              ),
            ),

            // ── Body ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.smMd,
                AppSpacing.smMd,
                AppSpacing.smMd,
                AppSpacing.smMd,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date range row
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          size: 14, color: AppColors.onSurface),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _dateRange(),
                          style: AppTypography.caption(context).copyWith(
                            color: AppColors.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  // Day range pill — only when meaningful
                  if (dayCount > 0) ...[
                    const SizedBox(height: 8),
                    DashboardPill(
                      label: 'Day ${startDay + 1} – Day $dayCount',
                      color: AppColors.primary,
                      selected: false,
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

  String _dateRange() {
    final start = activity.startedAt ?? activity.createdAt;
    final end = activity.completedAt ?? DateTime.now();
    return '${date_utils.ActivityDateUtils.formatFullDate(start)}  →  ${date_utils.ActivityDateUtils.formatFullDate(end)}';
  }
}
