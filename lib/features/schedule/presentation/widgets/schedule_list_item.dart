import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../core/design_system/theme/app_semantic_colors.dart';
import '../../../../core/design_system/theme/app_status_colors.dart';
import '../../domain/entities/schedule_entity.dart';

/// Schedule List Item Widget
/// Compact row design with icon on left, title/subtitle on left, day count on right
/// Fully clickable with ripple effect
class ScheduleListItem extends StatelessWidget {
  final ScheduleEntity schedule;
  final VoidCallback? onTap;
  final DateTime? pruningDate; // Optional pruning date for day count calculation

  const ScheduleListItem({
    Key? key,
    required this.schedule,
    this.onTap,
    this.pruningDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final statusColors = Theme.of(context).extension<AppStatusColors>()!;
    final typeColor = _getTypeColor(context, schedule.type);
    final typeIcon = _getTypeIcon(schedule.type);
    final daysSincePruning = _calculateDaysSincePruning(
      schedule.scheduledDate,
      pruningDate,
    );
    final now = DateTime.now();
    final isUpcoming = !schedule.isCompleted && schedule.scheduledDate.isAfter(now);
    final isPending = !schedule.isCompleted && !isUpcoming;

    final statusLabel = schedule.isCompleted
        ? 'Completed'
        : isUpcoming
            ? 'Upcoming'
            : 'Pending';

    final statusColor = schedule.isCompleted
        ? statusColors.completed
        : isUpcoming
            ? statusColors.upcoming
            : statusColors.pending;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.xs,
        ),
        child: Row(
          children: [
            // Left: Small Icon
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
            const SizedBox(width: AppSpacing.sm),

            // Left: Title and Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title (medium weight)
                  Text(
                    schedule.title,
                    style: AppTypography.titleSmall(context).copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: cs.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  // Subtitle (date)
                  Text(
                    _formatDate(schedule.scheduledDate),
                    style: AppTypography.bodySmall(context).copyWith(
                      color: cs.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Right: Day Count and Secondary Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Status chip (Pending / Completed / Upcoming)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                  ),
                  child: Text(
                    statusLabel,
                    style: AppTypography.labelSmall(context).copyWith(
                      color: schedule.isCompleted
                          ? statusColor
                          : isPending
                              ? statusColor
                              : cs.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // Secondary Info (status or date)
                Text(
                  daysSincePruning != null ? 'Day $daysSincePruning' : _formatRelativeDate(schedule.scheduledDate),
                  style: AppTypography.bodySmall(context).copyWith(
                    color: cs.onSurfaceVariant,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Get type color
  Color _getTypeColor(BuildContext context, ScheduleType type) {
    final cs = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;

    if (type == ScheduleType.spray) {
      return semantic.info;
    } else if (type == ScheduleType.nutrition) {
      return semantic.warning;
    } else if (type == ScheduleType.work) {
      return cs.primary;
    } else {
      return cs.onSurface;
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

  /// Calculate days since pruning (from scheduled date)
  /// If pruning date is provided, calculate: scheduledDate - pruningDate
  /// Otherwise, use a simplified calculation
  int? _calculateDaysSincePruning(DateTime scheduledDate, DateTime? pruningDate) {
    if (pruningDate != null) {
      // Calculate days from pruning date to scheduled date
      final scheduleDate = DateTime(
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day,
      );
      final pruneDate = DateTime(
        pruningDate.year,
        pruningDate.month,
        pruningDate.day,
      );
      final difference = scheduleDate.difference(pruneDate).inDays;
      
      // Only show positive days (future schedules)
      if (difference > 0) {
        return difference;
      }
      return null;
    }
    
    // Fallback: calculate from today (simplified)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final scheduleDate = DateTime(scheduledDate.year, scheduledDate.month, scheduledDate.day);
    final difference = scheduleDate.difference(today).inDays;
    
    // Only show for future dates
    if (difference > 0) {
      return difference;
    }
    return null;
  }

  /// Format date to compact string
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
      return DateFormat('EEE, MMM dd').format(date);
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }

  /// Format relative date for secondary info
  String _formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    final difference = dateOnly.difference(today).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference > 0) {
      return 'In $difference days';
    } else {
      return '${-difference} days ago';
    }
  }
}
