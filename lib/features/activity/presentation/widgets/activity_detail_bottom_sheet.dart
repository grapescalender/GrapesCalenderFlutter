import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../config/router/app_router.dart';
import '../../../../shared/utils/date_utils.dart' as activity_date_utils;
import '../../../../shared/widgets/app_button.dart';
import '../../domain/entities/activity_entity.dart';

/// Activity Detail Bottom Sheet
/// Shows activity details with day calculations and "View Related Schedules" button
class ActivityDetailBottomSheet extends StatelessWidget {
  final ActivityEntity activity;
  final DateTime? pruningDate;
  final VoidCallback? onViewSchedules;

  const ActivityDetailBottomSheet({
    Key? key,
    required this.activity,
    this.pruningDate,
    this.onViewSchedules,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompleted = activity.isCompleted;
    final isCurrent = activity.isActive;

    // Calculate day counts
    final startDay = activity.startedAt != null && pruningDate != null
        ? activity_date_utils.ActivityDateUtils.calculateDay(pruningDate, activity.startedAt!)
        : null;
    
    final endDate = isCurrent ? DateTime.now() : activity.completedAt;
    final endDay = endDate != null && pruningDate != null
        ? activity_date_utils.ActivityDateUtils.calculateDay(pruningDate, endDate)
        : null;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusHuge),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.onSurfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontal,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  // Activity Icon
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? AppColors.primaryLight
                          : isCompleted
                              ? AppColors.successLight
                              : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: Icon(
                      isCompleted
                          ? Icons.check_circle
                          : activity.type.icon,
                      color: isCurrent
                          ? AppColors.primary
                          : isCompleted
                              ? AppColors.success
                              : AppColors.onSurfaceVariant,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  // Title and Status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.type.displayName,
                          style: AppTypography.headlineMedium(context).copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isCurrent
                                ? AppColors.primaryLight
                                : isCompleted
                                    ? AppColors.successLight
                                    : AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                          ),
                          child: Text(
                            isCompleted
                                ? 'Completed'
                                : isCurrent
                                    ? 'In Progress'
                                    : 'Pending',
                            style: AppTypography.labelSmall(context).copyWith(
                              color: isCurrent
                                  ? AppColors.primary
                                  : isCompleted
                                      ? AppColors.success
                                      : AppColors.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Close button
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    iconSize: 20,
                  ),
                ],
              ),
            ),
            
            const Divider(height: 1),
            
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Start Date with Day count
                    if (activity.startedAt != null) ...[
                      _buildDateWithDayRow(
                        context,
                        icon: Icons.play_circle_outline,
                        label: 'Start Date',
                        date: activity.startedAt!,
                        dayCount: startDay,
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    
                    // End Date with Day count
                    if (isCompleted && activity.completedAt != null) ...[
                      _buildDateWithDayRow(
                        context,
                        icon: Icons.check_circle_outline,
                        label: 'End Date',
                        date: activity.completedAt!,
                        dayCount: endDay,
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ] else if (isCurrent) ...[
                      _buildDateWithDayRow(
                        context,
                        icon: Icons.schedule_outlined,
                        label: 'End Date',
                        date: DateTime.now(),
                        dayCount: endDay,
                        isOngoing: true,
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    
                    // Plot Name
                    _buildDetailRow(
                      context,
                      icon: Icons.agriculture,
                      label: 'Plot',
                      value: activity.plotName,
                    ),
                  ],
                ),
              ),
            ),
            
            // View Related Schedules Button
            if (onViewSchedules != null) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
                child: AppButton.primary(
                  label: 'View Related Schedules',
                  onPressed: () {
                    Navigator.of(context).pop();
                    onViewSchedules?.call();
                  },
                  isFullWidth: true,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build date row with day count
  Widget _buildDateWithDayRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required DateTime date,
    int? dayCount,
    bool isOngoing = false,
  }) {
    final dateText = isOngoing
        ? 'Today${dayCount != null ? ' (Day $dayCount)' : ''}'
        : activity_date_utils.ActivityDateUtils.formatDateWithDay(date, dayCount);

    return _buildDetailRow(
      context,
      icon: icon,
      label: label,
      value: dateText,
      valueColor: isOngoing ? AppColors.primary : null,
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.onSurfaceVariant,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.bodySmall(context).copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTypography.bodyMedium(context).copyWith(
                  color: valueColor ?? AppColors.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
