import 'package:flutter/material.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../core/design_system/theme/app_semantic_colors.dart';
import '../../domain/entities/activity_entity.dart';

/// Activity Item Widget
/// Individual activity node in the vertical stepper
/// Shows circular icon, activity name, and status
class ActivityItem extends StatelessWidget {
  const ActivityItem({
    Key? key,
    required this.activity,
    this.isCompleted = false,
    this.isCurrent = false,
    this.isUpcoming = false,
    this.showConnector = true,
    this.onTap,
  }) : super(key: key);
  final ActivityEntity activity;
  final bool isCompleted;
  final bool isCurrent;
  final bool isUpcoming;
  final bool showConnector;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

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
                    style: AppTypography.cardTitle(context).copyWith(
                      color: isUpcoming
                          ? cs.onSurface.withOpacity(0.38)
                          : cs.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
    final cs = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    Color backgroundColor;
    Color iconColor;
    double size;
    IconData icon;

    if (isCompleted) {
      backgroundColor = semantic.success.withOpacity(0.14);
      iconColor = semantic.success;
      size = 40;
      icon = Icons.check_circle;
    } else if (isCurrent) {
      backgroundColor = cs.primary.withOpacity(0.10);
      iconColor = cs.primary;
      size = 48; // Slightly larger for current
      icon = activity.type.icon;
    } else {
      backgroundColor = cs.surfaceContainerHighest;
      iconColor = cs.onSurface.withOpacity(0.38);
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
                color: cs.primary,
                width: 2,
              )
            : null,
        boxShadow: isCurrent
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
        icon,
        color: iconColor,
        size: isCurrent ? 24 : 20,
      ),
    );
  }

  /// Vertical Connector Line
  Widget _buildConnector(BuildContext context, bool isDark) {
    final cs = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    Color lineColor;
    if (isCompleted) {
      lineColor = semantic.success;
    } else if (isCurrent) {
      lineColor = cs.primary.withOpacity(0.3);
    } else {
      lineColor = cs.outline.withOpacity(0.3);
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
    final cs = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    if (isCompleted) {
      return Text(
        'Completed',
        style: AppTypography.caption(context).copyWith(
          color: semantic.success,
        ),
      );
    } else if (isCurrent) {
      return Text(
        'In Progress',
        style: AppTypography.caption(context).copyWith(
          color: cs.primary,
        ),
      );
    } else {
      return Text(
        'Upcoming',
        style: AppTypography.caption(context).copyWith(
          color: cs.onSurface.withOpacity(0.38),
        ),
      );
    }
  }
}
