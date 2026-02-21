import 'package:flutter/material.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../domain/entities/activity_entity.dart';

/// Activity Step Widget
/// Individual step in the activity timeline
class ActivityStep extends StatelessWidget {
  final ActivityEntity activity;
  final bool isActive;
  final bool isCompleted;
  final bool isLast;
  final VoidCallback? onTap;

  const ActivityStep({
    Key? key,
    required this.activity,
    required this.isActive,
    required this.isCompleted,
    required this.isLast,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          _buildTimelineIndicator(context),
          SizedBox(width: AppSpacing.md),
          // Content card
          Expanded(
            child: _buildContentCard(context),
          ),
        ],
      ),
    );
  }

  /// Timeline indicator (vertical line + icon)
  Widget _buildTimelineIndicator(BuildContext context) {
    return Column(
      children: [
        // Icon circle
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getIndicatorColor(),
            border: isActive
                ? Border.all(
                    color: AppColors.primary,
                    width: 3,
                  )
                : null,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            activity.type.icon,
            color: _getIconColor(),
            size: 24,
          ),
        ),
        // Vertical line (if not last)
        if (!isLast)
          Container(
            width: 2,
            height: 60,
            margin: EdgeInsets.symmetric(vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.success
                  : AppColors.outline.withOpacity(0.3),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
      ],
    );
  }

  /// Content card
  Widget _buildContentCard(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: AppCard.defaultStyle(
        onTap: onTap,
        color: isActive
            ? AppColors.primaryLight.withOpacity(0.2)
            : null,
        border: isActive
            ? Border.all(
                color: AppColors.primary,
                width: 2,
              )
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Expanded(
                  child: Text(
                    activity.type.displayName,
                    style: AppTypography.headlineSmall(context).copyWith(
                      color: isActive
                          ? AppColors.primary
                          : AppColors.onBackground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Status badge
                _buildStatusBadge(context),
              ],
            ),
            SizedBox(height: AppSpacing.sm),
            // Status info
            _buildStatusInfo(context),
          ],
        ),
      ),
    );
  }

  /// Status badge
  Widget _buildStatusBadge(BuildContext context) {
    if (isCompleted) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.successLight,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              size: 14,
              color: AppColors.success,
            ),
            SizedBox(width: AppSpacing.xs),
            Text(
              'Done',
              style: AppTypography.labelSmall(context).copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    } else if (isActive) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: AppSpacing.xs),
            Text(
              'Active',
              style: AppTypography.labelSmall(context).copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  /// Status info
  Widget _buildStatusInfo(BuildContext context) {
    if (isCompleted && activity.completedAt != null) {
      return Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 14,
            color: AppColors.onSurfaceVariant,
          ),
          SizedBox(width: AppSpacing.xs),
          Text(
            'Completed ${_formatDate(activity.completedAt!)}',
            style: AppTypography.bodySmall(context).copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      );
    } else if (isActive && activity.startedAt != null) {
      return Row(
        children: [
          Icon(
            Icons.play_circle_outline,
            size: 14,
            color: AppColors.primary,
          ),
          SizedBox(width: AppSpacing.xs),
          Text(
            'Started ${_formatDate(activity.startedAt!)}',
            style: AppTypography.bodySmall(context).copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Icon(
            Icons.schedule_outlined,
            size: 14,
            color: AppColors.onSurfaceVariant,
          ),
          SizedBox(width: AppSpacing.xs),
          Text(
            'Pending',
            style: AppTypography.bodySmall(context).copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      );
    }
  }

  /// Get indicator color
  Color _getIndicatorColor() {
    if (isActive) {
      return AppColors.primaryLight;
    } else if (isCompleted) {
      return AppColors.successLight;
    } else {
      return AppColors.surfaceVariant;
    }
  }

  /// Get icon color
  Color _getIconColor() {
    if (isActive) {
      return AppColors.primary;
    } else if (isCompleted) {
      return AppColors.success;
    } else {
      return AppColors.onSurfaceDisabled;
    }
  }

  /// Format date
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'today';
    } else if (difference == 1) {
      return 'yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
