import 'package:flutter/material.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../domain/entities/schedule_entity.dart';

/// Schedule Filter Chip Widget
/// Displays filter options (Spray, Nutrition, Work, All)
class ScheduleFilterChip extends StatelessWidget {
  const ScheduleFilterChip({
    Key? key,
    required this.filterType,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);
  final ScheduleType filterType;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _filterColor(filterType);
    final foreground = isSelected ? Colors.white : AppColors.onBackground;
    final background = isSelected ? color : color.withValues(alpha: 0.07);
    final border = isSelected ? color : color.withValues(alpha: 0.22);
    final iconBackground = isSelected
        ? Colors.white.withValues(alpha: 0.18)
        : color.withValues(alpha: 0.10);
    final iconColor = isSelected ? Colors.white : color;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 38,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(
          left: AppSpacing.xs,
          right: AppSpacing.smMd,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(color: border),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.18),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(_filterIcon(filterType), size: 14, color: iconColor),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              filterType.displayName,
              style: AppTypography.labelLarge(context).copyWith(
                color: foreground,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Color _filterColor(ScheduleType type) {
    return switch (type) {
      ScheduleType.spray => AppColors.info,
      ScheduleType.nutrition => AppColors.warning,
      ScheduleType.water => AppColors.primary,
      ScheduleType.work => AppColors.success,
      _ => AppColors.primary,
    };
  }

  IconData _filterIcon(ScheduleType type) {
    return switch (type) {
      ScheduleType.spray => Icons.water_drop_outlined,
      ScheduleType.nutrition => Icons.grass_outlined,
      ScheduleType.water => Icons.water_outlined,
      ScheduleType.work => Icons.construction_outlined,
      _ => Icons.tune_rounded,
    };
  }
}
