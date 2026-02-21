import 'package:flutter/material.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../domain/entities/activity_entity.dart';

/// Activity Item Widget
/// Individual activity node in the vertical stepper
/// Shows circular icon, activity name, and status
class ActivityItem extends StatelessWidget {
  final ActivityEntity activity;
  final bool isCompleted;
  final bool isCurrent;
  final bool isUpcoming;
  final bool showConnector;
  final VoidCallback? onTap;

  const ActivityItem({
    Key? key,
    required this.activity,
    this.isCompleted = false,
    this.isCurrent = false,
    this.isUpcoming = false,
    this.showConnector = true,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: (isCompleted || isCurrent) ? onTap : null,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Circular Icon with Connector
            Column(
              children: [
                _buildCircularIcon(context, isDark),
                if (showConnector) _buildConnector(context, isDark),
              ],
            ),
            const SizedBox(width: AppSpacing.md),
            
            // Right: Activity Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Activity Name
                  Text(
                    activity.type.displayName,
                    style: AppTypography.titleMedium(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: isUpcoming
                          ? (isDark
                              ? AppColors.darkOnSurfaceDisabled
                              : AppColors.onSurfaceDisabled)
                          : (isDark
                              ? AppColors.darkOnSurface
                              : AppColors.onSurface),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Status Label
                  _buildStatusLabel(context, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Circular Icon
  Widget _buildCircularIcon(BuildContext context, bool isDark) {
    Color backgroundColor;
    Color iconColor;
    double size;
    IconData icon;

    if (isCompleted) {
      backgroundColor = AppColors.successLight;
      iconColor = AppColors.success;
      size = 40;
      icon = Icons.check_circle;
    } else if (isCurrent) {
      backgroundColor = AppColors.primaryLight;
      iconColor = AppColors.primary;
      size = 48; // Slightly larger for current
      icon = activity.type.icon;
    } else {
      backgroundColor = isDark
          ? AppColors.darkSurfaceVariant
          : AppColors.surfaceVariant;
      iconColor = isDark
          ? AppColors.darkOnSurfaceDisabled
          : AppColors.onSurfaceDisabled;
      size = 40;
      icon = activity.type.icon;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: isCurrent
            ? Border.all(
                color: AppColors.primary,
                width: 2,
              )
            : null,
        boxShadow: isCurrent
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
        icon,
        color: iconColor,
        size: isCurrent ? 24 : 20,
      ),
    );
  }

  /// Vertical Connector Line
  Widget _buildConnector(BuildContext context, bool isDark) {
    Color lineColor;
    if (isCompleted) {
      lineColor = AppColors.success;
    } else if (isCurrent) {
      lineColor = AppColors.primary.withOpacity(0.3);
    } else {
      lineColor = isDark
          ? AppColors.darkOutline.withOpacity(0.3)
          : AppColors.outline.withOpacity(0.3);
    }

    return Container(
      width: 2,
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: lineColor,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  /// Status Label
  Widget _buildStatusLabel(BuildContext context, bool isDark) {
    if (isCompleted) {
      return Text(
        'Completed',
        style: AppTypography.bodySmall(context).copyWith(
          color: AppColors.success,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      );
    } else if (isCurrent) {
      return Text(
        'In Progress',
        style: AppTypography.bodySmall(context).copyWith(
          color: AppColors.primary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      );
    } else {
      return Text(
        'Upcoming',
        style: AppTypography.bodySmall(context).copyWith(
          color: isDark
              ? AppColors.darkOnSurfaceDisabled
              : AppColors.onSurfaceDisabled,
          fontSize: 12,
        ),
      );
    }
  }
}
