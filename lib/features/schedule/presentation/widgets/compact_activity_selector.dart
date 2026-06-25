import 'package:flutter/material.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/dashboard_design.dart';
import '../../../activity/domain/entities/activity_entity.dart';

class CompactActivitySelector extends StatelessWidget {
  const CompactActivitySelector({
    super.key,
    required this.selectedActivity,
    required this.onTap,
  });

  final ActivityType selectedActivity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = DashboardStyle.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.smMd,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: colors.outline),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.timeline_rounded, size: 16, color: colors.primary),
            const SizedBox(width: AppSpacing.xs),
            Text(
              selectedActivity.displayName,
              style: AppTypography.labelLarge(context).copyWith(
                color: colors.onBackground,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: colors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
