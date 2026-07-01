import 'package:flutter/material.dart';

import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/app_button.dart';

class ScheduleDeleteBottomSheet extends StatefulWidget {
  const ScheduleDeleteBottomSheet({
    super.key,
    required this.onConfirm,
  });

  final Future<bool> Function() onConfirm;

  @override
  State<ScheduleDeleteBottomSheet> createState() =>
      _ScheduleDeleteBottomSheetState();
}

class _ScheduleDeleteBottomSheetState extends State<ScheduleDeleteBottomSheet> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenHorizontal,
          AppSpacing.sm,
          AppSpacing.screenHorizontal,
          AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusHuge),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.errorLight,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(width: AppSpacing.smMd),
                Expanded(
                  child: Text(
                    'Delete Schedule?',
                    style: AppTypography.titleLarge(context).copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.smMd),
            Text(
              'This schedule will be removed from your list.',
              style: AppTypography.bodyMedium(context).copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: AppButton.secondary(
                    label: 'Cancel',
                    onPressed: _isDeleting
                        ? null
                        : () => Navigator.of(context).pop(false),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppButton(
                    label: _isDeleting ? 'Deleting...' : 'Delete',
                    icon: Icons.delete_outline_rounded,
                    backgroundColor: AppColors.error,
                    foregroundColor: cs.onError,
                    isLoading: _isDeleting,
                    onPressed: _isDeleting ? null : _confirm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirm() async {
    setState(() => _isDeleting = true);
    final deleted = await widget.onConfirm();
    if (!mounted) return;
    setState(() => _isDeleting = false);
    if (deleted) Navigator.of(context).pop(true);
  }
}
