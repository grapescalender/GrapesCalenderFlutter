import 'package:flutter/material.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
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

  Color _statusBg(ActivityStatus s) {
    switch (s) {
      case ActivityStatus.completed:
        return AppColors.successLight;
      case ActivityStatus.active:
        return AppColors.primaryContainer;
      case ActivityStatus.pending:
        return AppColors.background;
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
            color: isSelected && isActive
                ? AppColors.primary
                : AppColors.outline,
            width: isSelected && isActive ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                  alpha: isSelected && isActive ? 0.07 : 0.04),
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
                  horizontal: 14, vertical: 12),
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
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusSm),
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
                          style: AppTypography.headlineSmall(context)
                              .copyWith(
                            fontWeight: FontWeight.w700,
                            color: _statusColor(s),
                            fontSize: 15,
                          ),
                        ),
                        if (activity.plotName.isNotEmpty)
                          Text(
                            activity.plotName,
                            style: AppTypography.bodySmall(context)
                                .copyWith(
                              color: AppColors.onSurface,
                              fontSize: 11,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Status chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusBg(s),
                      borderRadius: BorderRadius.circular(
                          AppSpacing.radiusFull),
                      border: Border.all(
                        color: _statusColor(s).withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_statusIcon(s),
                            size: 12, color: _statusColor(s)),
                        const SizedBox(width: 4),
                        Text(
                          _statusLabel(s),
                          style: AppTypography.bodySmall(context).copyWith(
                            color: _statusColor(s),
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Body ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
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
                          style:
                              AppTypography.bodySmall(context).copyWith(
                            color: AppColors.onSurface,
                            fontSize: 12,
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(
                            AppSpacing.radiusFull),
                      ),
                      child: Text(
                        'Day ${startDay + 1} – Day $dayCount',
                        style: AppTypography.bodySmall(context).copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                        ),
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

  String _dateRange() {
    final start = activity.startedAt ?? activity.createdAt;
    final end = activity.completedAt ?? DateTime.now();
    return '${date_utils.ActivityDateUtils.formatFullDate(start)}  →  ${date_utils.ActivityDateUtils.formatFullDate(end)}';
  }
}
