import 'package:flutter/material.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../domain/entities/activity_entity.dart';
import '../../../../shared/utils/date_utils.dart' as date_utils;

/// Activity Card Widget
/// Displays activity information in a clean card format
class ActivityCard extends StatelessWidget {
  final ActivityEntity activity;
  final bool isSelected;
  final bool isClickable;
  final VoidCallback? onTap;
  final int dayCount;
  final int startDay;

  const ActivityCard({
    Key? key,
    required this.activity,
    this.isSelected = false,
    this.isClickable = true,
    this.onTap,
    this.dayCount = 0,
    this.startDay = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isCompleted = activity.isCompleted;
    final isActive = activity.isActive;

    return GestureDetector(
      onTap: isClickable ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          gradient: isSelected && isActive
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    cs.primary.withOpacity(0.1),
                    cs.secondary.withOpacity(0.05),
                  ],
                )
              : null,
          color: isSelected && isActive ? null : Colors.white,
          border: Border.all(
            color: isSelected && isActive
                ? cs.primary.withOpacity(0.3)
                : cs.outlineVariant,
            width: isSelected && isActive ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                isSelected && isActive ? 0.08 : 0.04,
              ),
              blurRadius: isSelected && isActive ? 12 : 4,
              offset: isSelected && isActive
                  ? const Offset(0, 4)
                  : const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Activity name and status badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              activity.type.icon,
                              size: 20,
                              color: _getActivityColor(cs, activity.status),
                            ),
                            SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                activity.type.displayName,
                                style: AppTypography.labelLarge(context)
                                    .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isSelected && isActive
                                      ? cs.primary
                                      : cs.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          activity.plotName,
                          style: AppTypography.bodySmall(context).copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  _buildStatusBadge(context, cs, activity.status),
                ],
              ),
              SizedBox(height: AppSpacing.md),

              // Date range
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: cs.onSurfaceVariant,
                  ),
                  SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      '${date_utils.ActivityDateUtils.formatFullDate(activity.startedAt ?? activity.createdAt)} → ${date_utils.ActivityDateUtils.formatFullDate(activity.completedAt ?? DateTime.now())}',
                      style: AppTypography.bodySmall(context).copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.smMd),

              // Day count
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: cs.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Text(
                  dayCount > 0
                      ? 'Day ${startDay + 1} - Day $dayCount'
                      : 'In Progress',
                  style: AppTypography.labelSmall(context).copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get activity color based on status
  Color _getActivityColor(ColorScheme cs, ActivityStatus status) {
    switch (status) {
      case ActivityStatus.completed:
        return cs.secondary; // Green
      case ActivityStatus.active:
        return cs.primary; // Indigo
      case ActivityStatus.pending:
        return cs.outlineVariant; // Grey
    }
  }

  /// Build status badge
  Widget _buildStatusBadge(BuildContext context, ColorScheme cs, ActivityStatus status) {
    final statusLabel = status.value.toUpperCase();
    final statusColor = _getActivityColor(cs, status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        border: Border.all(color: statusColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
      ),
      child: Text(
        statusLabel,
        style: AppTypography.labelSmall(context).copyWith(
          color: statusColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
