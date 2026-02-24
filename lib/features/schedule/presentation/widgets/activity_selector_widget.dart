import 'package:flutter/material.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../activity/domain/entities/activity_entity.dart';

/// Activity Selector Widget
/// Multi-select widget for selecting 1-2 activities
class ActivitySelectorWidget extends StatelessWidget {
  final List<ActivityEntity> activities;
  final List<String> selectedActivityIds;
  final Function(List<String>) onSelectionChanged;
  final String? errorText;

  const ActivitySelectorWidget({
    Key? key,
    required this.activities,
    required this.selectedActivityIds,
    required this.onSelectionChanged,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            Text(
              'Linked Activities',
              style: AppTypography.bodyMedium(context).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              '(Select 1-2)',
              style: AppTypography.bodySmall(context).copyWith(
                color: cs.onSurfaceVariant,
                fontSize: 12,
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

            return FilterChip(
              label: Text(activity.type.displayName),
              selected: isSelected,
              onSelected: canSelect
                  ? (selected) {
                      final newSelection = List<String>.from(selectedActivityIds);
                      if (selected) {
                        if (!newSelection.contains(activity.id)) {
                          newSelection.add(activity.id);
                        }
                      } else {
                        newSelection.remove(activity.id);
                      }
                      onSelectionChanged(newSelection);
                    }
                  : null,
              selectedColor: cs.primary.withOpacity(0.10),
              checkmarkColor: cs.primary,
              labelStyle: AppTypography.bodySmall(context).copyWith(
                color: isSelected
                    ? cs.primary
                    : cs.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              avatar: Icon(
                activity.type.icon,
                size: 18,
                color: isSelected
                    ? cs.primary
                    : cs.onSurfaceVariant,
              ),
            );
          }).toList(),
        ),
        
        // Error Text
        if (errorText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            errorText!,
            style: AppTypography.bodySmall(context).copyWith(
              color: cs.error,
              fontSize: 12,
            ),
          ),
        ],
        
        // Helper Text
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Select at least 1 activity. Maximum 2 activities allowed.',
          style: AppTypography.bodySmall(context).copyWith(
            color: cs.onSurfaceVariant,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
