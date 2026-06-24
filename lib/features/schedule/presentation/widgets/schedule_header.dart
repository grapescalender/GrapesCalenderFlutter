import 'package:flutter/material.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/dashboard_design.dart';

/// Schedule Header Widget
/// Clean header with title on left and Add Schedule icon button on right
/// Minimal, inline design
class ScheduleHeader extends StatelessWidget {
  const ScheduleHeader({
    Key? key,
    required this.title,
    this.subtitle,
    this.onAddTap,
    this.horizontalPadding = AppSpacing.screenHorizontal,
  }) : super(key: key);
  final String title;
  final String? subtitle;
  final VoidCallback? onAddTap;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return DashboardSectionHeader(
      icon: Icons.calendar_month_rounded,
      title: title,
      subtitle: subtitle,
      horizontalPadding: horizontalPadding,
      action: onAddTap == null
          ? null
          : _AddSchedulePill(
              onTap: onAddTap!,
            ),
    );
  }
}

class _AddSchedulePill extends StatelessWidget {
  const _AddSchedulePill({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Add Schedule',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        child: Container(
          height: 38,
          constraints: const BoxConstraints(maxWidth: 124),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            border:
                Border.all(color: AppColors.primary.withValues(alpha: 0.22)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_rounded,
                  size: 13,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  'Add Schedule',
                  style: AppTypography.labelLarge(context).copyWith(
                    color: AppColors.onBackground,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
