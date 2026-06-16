import 'package:flutter/material.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../core/design_system/theme/app_semantic_colors.dart';
import '../../domain/entities/activity_entity.dart';

/// Activity Step Widget
/// Individual step in the activity timeline
class ActivityStep extends StatelessWidget {

  const ActivityStep({
    Key? key,
    required this.activity,
    required this.isActive,
    required this.isCompleted,
    required this.isLast,
    this.onTap,
  }) : super(key: key);
  final ActivityEntity activity;
  final bool isActive;
  final bool isCompleted;
  final bool isLast;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
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

  /// Timeline indicator (vertical line + icon)
  Widget _buildTimelineIndicator(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
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
            color: _getIndicatorColor(context),
            border: isActive
                ? Border.all(
                    color: cs.primary,
                    width: 3,
                  )
                : null,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: cs.primary.withOpacity(0.22),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            activity.type.icon,
            color: _getIconColor(context),
            size: 24,
          ),
        ),
        // Vertical line (if not last)
        if (!isLast)
          Container(
            width: 2,
            height: 60,
            margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: isCompleted
                  ? semantic.success
                  : cs.outline.withOpacity(0.3),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
      ],
    );
  }

  /// Content card
  Widget _buildContentCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: AppCard.defaultStyle(
        onTap: onTap,
        color: isActive
            ? cs.primary.withOpacity(0.06)
            : null,
        border: isActive
            ? Border.all(
                color: cs.primary,
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
                          ? cs.primary
                          : cs.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Status badge
                _buildStatusBadge(context),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            // Status info
            _buildStatusInfo(context),
          ],
        ),
      ),
    );
  }

  /// Status badge
  Widget _buildStatusBadge(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    if (isCompleted) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: semantic.success.withOpacity(0.14),
          borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              size: 14,
              color: semantic.success,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              'Done',
              style: AppTypography.labelSmall(context).copyWith(
                color: semantic.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    } else if (isActive) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: cs.primary.withOpacity(0.10),
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
                color: cs.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              'Active',
              style: AppTypography.labelSmall(context).copyWith(
                color: cs.primary,
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
    final cs = Theme.of(context).colorScheme;
    if (isCompleted && activity.completedAt != null) {
      return Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 14,
            color: cs.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'Completed ${_formatDate(activity.completedAt!)}',
            style: AppTypography.bodySmall(context).copyWith(
              color: cs.onSurfaceVariant,
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
            color: cs.primary,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'Started ${_formatDate(activity.startedAt!)}',
            style: AppTypography.bodySmall(context).copyWith(
              color: cs.primary,
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
            color: cs.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'Pending',
            style: AppTypography.bodySmall(context).copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      );
    }
  }

  /// Get indicator color
  Color _getIndicatorColor(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    if (isActive) return cs.primary.withOpacity(0.10);
    if (isCompleted) return semantic.success.withOpacity(0.14);
    return cs.surfaceContainerHighest;
  }

  /// Get icon color
  Color _getIconColor(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    if (isActive) return cs.primary;
    if (isCompleted) return semantic.success;
    return cs.onSurface.withOpacity(0.38);
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
