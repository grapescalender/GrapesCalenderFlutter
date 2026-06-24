import 'package:flutter/material.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/dashboard_design.dart';
import '../../../activity/domain/entities/activity_entity.dart';

/// Activity Selector Widget
/// Multi-select widget for selecting 1-2 activities
class ActivitySelectorWidget extends StatelessWidget {
  const ActivitySelectorWidget({
    Key? key,
    required this.activities,
    required this.selectedActivityIds,
    required this.onSelectionChanged,
    this.errorText,
    this.helperText,
  }) : super(key: key);
  final List<ActivityEntity> activities;
  final List<String> selectedActivityIds;
  final void Function(List<String>) onSelectionChanged;
  final String? errorText;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            Text(
              'Linked Activities',
              style: AppTypography.labelLarge(context).copyWith(
                color: AppColors.onBackground,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              '(Select 1-2)',
              style: AppTypography.labelLarge(context).copyWith(
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),

        // Activity Chips
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: activities.map((activity) {
            final isSelected = selectedActivityIds.contains(activity.id);
            final canSelect = selectedActivityIds.length < 2 || isSelected;

            return DashboardPill(
              label: activity.type.displayName,
              icon: activity.type.icon,
              color: AppColors.primary,
              selected: isSelected,
              onTap: canSelect
                  ? () {
                      final newSelection =
                          List<String>.from(selectedActivityIds);
                      if (isSelected) {
                        newSelection.remove(activity.id);
                      } else if (!newSelection.contains(activity.id)) {
                        newSelection.add(activity.id);
                      }
                      onSelectionChanged(newSelection);
                    }
                  : null,
            );
          }).toList(),
        ),

        // Error Text
        if (errorText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            errorText!,
            style: AppTypography.labelLarge(context).copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],

        // Helper Text
        const SizedBox(height: AppSpacing.xs),
        Text(
          helperText ??
              'Select at least 1 activity. Maximum 2 activities allowed.',
          style: AppTypography.labelLarge(context).copyWith(
            color: AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
