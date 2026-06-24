import 'package:flutter/material.dart';

import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';

class StickySaveButton extends StatelessWidget {
  const StickySaveButton({
    super.key,
    required this.isSaving,
    required this.onSave,
  });

  final bool isSaving;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenHorizontal,
          AppSpacing.smMd,
          AppSpacing.screenHorizontal,
          AppSpacing.sm,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.outlineVariant)),
        ),
        child: AppButton.primary(
          label: isSaving ? 'Saving Schedule...' : 'Save Schedule',
          icon: Icons.check_rounded,
          onPressed: isSaving ? null : onSave,
          isLoading: isSaving,
          isFullWidth: true,
        ),
      );
}
