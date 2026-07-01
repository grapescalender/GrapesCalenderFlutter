import 'package:flutter/material.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';

class StickySaveAction extends StatelessWidget {
  const StickySaveAction({
    super.key,
    required this.isSaving,
    required this.onSave,
    this.label = 'Save Schedule',
    this.loadingLabel = 'Saving Schedule...',
  });

  final bool isSaving;
  final VoidCallback? onSave;
  final String label;
  final String loadingLabel;

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
        label: isSaving ? loadingLabel : label,
        icon: Icons.check_rounded,
        onPressed: isSaving ? null : onSave,
        isLoading: isSaving,
        isFullWidth: true,
      ),
    );
  }
}
