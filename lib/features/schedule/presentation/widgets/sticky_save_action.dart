import 'package:flutter/material.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';

class StickySaveAction extends StatelessWidget {
  const StickySaveAction({
    super.key,
    required this.isSaving,
    required this.onSave,
  });

  final bool isSaving;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        AppSpacing.smMd,
        AppSpacing.screenHorizontal,
        AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        border: Border(top: BorderSide(color: cs.outlineVariant)),
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
}
