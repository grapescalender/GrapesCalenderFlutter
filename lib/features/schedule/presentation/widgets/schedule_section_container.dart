import 'package:flutter/material.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';

/// Schedule Section Container
/// Wraps the entire schedule list with rounded corners, subtle background, and padding
/// Inspired by Groww's card containers
class ScheduleSectionContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const ScheduleSectionContainer({
    Key? key,
    required this.child,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg), // 16-20 radius
        border: Border.all(
          color: isDark
              ? AppColors.darkOutline.withOpacity(0.1)
              : AppColors.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppSpacing.md), // 12-16 padding
        child: child,
      ),
    );
  }
}
