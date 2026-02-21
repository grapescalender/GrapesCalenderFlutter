import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../domain/entities/schedule_entity.dart';

/// Schedule Detail Popup
/// Modern bottom sheet showing full schedule details
/// Inspired by Groww's detail modals
class ScheduleDetailPopup extends StatelessWidget {
  final ScheduleEntity schedule;

  const ScheduleDetailPopup({
    Key? key,
    required this.schedule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final typeColor = _getTypeColor(schedule.type);

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
                  // Type Icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: typeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: Icon(
                      _getTypeIcon(schedule.type),
                      color: typeColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  // Title and Type
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          schedule.title,
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
                            color: typeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                          ),
                          child: Text(
                            schedule.type.displayName,
                            style: AppTypography.labelSmall(context).copyWith(
                              color: typeColor,
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
                    // Plot Name
                    _buildDetailRow(
                      context,
                      icon: Icons.agriculture,
                      label: 'Plot',
                      value: schedule.plotName,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    
                    // Scheduled Date
                    _buildDetailRow(
                      context,
                      icon: Icons.calendar_today_outlined,
                      label: 'Scheduled Date',
                      value: _formatFullDate(schedule.scheduledDate),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    
                    // Scheduled Time
                    _buildDetailRow(
                      context,
                      icon: Icons.access_time_outlined,
                      label: 'Time',
                      value: _formatTime(schedule.scheduledDate),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    
                    // Days Until
                    if (_calculateDaysUntil(schedule.scheduledDate) != null) ...[
                      _buildDetailRow(
                        context,
                        icon: Icons.event_outlined,
                        label: 'Days Until',
                        value: '${_calculateDaysUntil(schedule.scheduledDate)} days',
                        valueColor: AppColors.primary,
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    
                    // Status
                    _buildDetailRow(
                      context,
                      icon: Icons.check_circle_outline,
                      label: 'Status',
                      value: schedule.isCompleted ? 'Completed' : 'Pending',
                      valueColor: schedule.isCompleted
                          ? AppColors.success
                          : AppColors.warning,
                    ),
                    
                    // Description
                    if (schedule.description != null &&
                        schedule.description!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'Description',
                        style: AppTypography.titleSmall(context).copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurfaceVariant
                              : AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                        child: Text(
                          schedule.description!,
                          style: AppTypography.bodyMedium(context).copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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

  int? _calculateDaysUntil(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final scheduleDate = DateTime(date.year, date.month, date.day);
    final difference = scheduleDate.difference(today).inDays;
    
    if (difference > 0) {
      return difference;
    }
    return null;
  }

  String _formatFullDate(DateTime date) {
    return DateFormat('EEEE, MMMM dd, yyyy').format(date);
  }

  String _formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }
}
