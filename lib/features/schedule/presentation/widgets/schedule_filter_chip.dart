import 'package:flutter/material.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../domain/entities/schedule_entity.dart';

/// Schedule Filter Chip Widget
/// Displays filter options (Spray, Nutrition, Work, All)
class ScheduleFilterChip extends StatelessWidget {
  final ScheduleType filterType;
  final bool isSelected;
  final VoidCallback onTap;

  const ScheduleFilterChip({
    Key? key,
    required this.filterType,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: isSelected
              ? null
              : Border.all(
                  color: AppColors.outline,
                  width: 1,
                ),
        ),
        child: Text(
          filterType.displayName,
          style: AppTypography.bodyMedium(context).copyWith(
            color: isSelected
                ? Colors.white
                : AppColors.onSurface,
            fontWeight: isSelected
                ? FontWeight.w600
                : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
