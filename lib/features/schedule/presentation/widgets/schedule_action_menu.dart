import 'package:flutter/material.dart';

import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';

enum ScheduleAction {
  view,
  edit,
  delete,
}

class ScheduleActionMenu extends StatelessWidget {
  const ScheduleActionMenu({
    super.key,
    required this.onSelected,
    this.enabled = true,
  });

  final ValueChanged<ScheduleAction> onSelected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ScheduleAction>(
      enabled: enabled,
      tooltip: 'Schedule actions',
      icon: const Icon(Icons.more_vert_rounded),
      padding: EdgeInsets.zero,
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      onSelected: onSelected,
      itemBuilder: (context) => [
        _item(
          context,
          action: ScheduleAction.view,
          icon: Icons.visibility_rounded,
          label: 'View Details',
        ),
        _item(
          context,
          action: ScheduleAction.edit,
          icon: Icons.edit_rounded,
          label: 'Edit Schedule',
        ),
        _item(
          context,
          action: ScheduleAction.delete,
          icon: Icons.delete_outline_rounded,
          label: 'Delete Schedule',
          color: AppColors.error,
        ),
      ],
    );
  }

  PopupMenuItem<ScheduleAction> _item(
    BuildContext context, {
    required ScheduleAction action,
    required IconData icon,
    required String label,
    Color? color,
  }) {
    final itemColor = color ?? Theme.of(context).colorScheme.onSurface;
    return PopupMenuItem<ScheduleAction>(
      value: action,
      child: Row(
        children: [
          Icon(icon, color: itemColor),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              label,
              style: AppTypography.bodyMedium(context).copyWith(
                color: itemColor,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
