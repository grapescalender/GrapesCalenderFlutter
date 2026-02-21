import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final typeColor = _getTypeColor(schedule.type);
    final typeIcon = _getTypeIcon(schedule.type);
    final daysSincePruning = _calculateDaysSincePruning(
      schedule.scheduledDate,
      pruningDate,
    );

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
                      color: isDark ? AppColors.darkOnSurface : AppColors.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  // Subtitle (date)
                  Text(
                    _formatDate(schedule.scheduledDate),
                    style: AppTypography.bodySmall(context).copyWith(
                      color: isDark
                          ? AppColors.darkOnSurfaceVariant
                          : AppColors.onSurfaceVariant,
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
                // Day Count (highlighted)
                if (daysSincePruning != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: typeColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                    ),
                    child: Text(
                      'Day $daysSincePruning',
                      style: AppTypography.labelSmall(context).copyWith(
                        color: typeColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurfaceVariant
                          : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                    ),
                    child: Text(
                      schedule.isCompleted ? 'Done' : 'Pending',
                      style: AppTypography.labelSmall(context).copyWith(
                        color: isDark
                            ? AppColors.darkOnSurfaceVariant
                            : AppColors.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
                // Secondary Info (status or date)
                Text(
                  schedule.isCompleted
                      ? 'Completed'
                      : _formatRelativeDate(schedule.scheduledDate),
                  style: AppTypography.bodySmall(context).copyWith(
                    color: isDark
                        ? AppColors.darkOnSurfaceVariant
                        : AppColors.onSurfaceVariant,
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
  Color _getTypeColor(ScheduleType type) {
    if (type == ScheduleType.spray) {
      return AppColors.info;
    } else if (type == ScheduleType.nutrition) {
      return AppColors.warning;
    } else if (type == ScheduleType.work) {
      return AppColors.primary;
    } else {
      return AppColors.onSurface;
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
