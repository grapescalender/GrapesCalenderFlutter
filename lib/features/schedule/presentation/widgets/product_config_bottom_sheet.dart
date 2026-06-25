import 'package:flutter/material.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/dashboard_design.dart';
import '../models/add_schedule_request.dart';
import 'product_dose_editor.dart';

class ProductConfigBottomSheet extends StatelessWidget {
  const ProductConfigBottomSheet({
    super.key,
    required this.draft,
    required this.showErrors,
    required this.onChanged,
    required this.onConfirm,
  });

  final ScheduleProductDraft draft;
  final bool showErrors;
  final ValueChanged<ScheduleProductDraft> onChanged;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return DashboardBottomSheetFrame(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DashboardSheetHeader(
            title: draft.productName,
            subtitle: '${draft.categoryLabel} • ${draft.manufacturer}',
            icon: Icons.tune_rounded,
          ),
          const SizedBox(height: AppSpacing.md),
          _ProductDoseSummary(draft: draft),
          const SizedBox(height: AppSpacing.md),
          ProductDoseEditor(
            product: draft,
            showErrors: showErrors,
            onChanged: onChanged,
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton.primary(
            label: 'Confirm Product',
            icon: Icons.check_rounded,
            onPressed: onConfirm,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }
}

class _ProductDoseSummary extends StatelessWidget {
  const _ProductDoseSummary({required this.draft});

  final ScheduleProductDraft draft;

  @override
  Widget build(BuildContext context) {
    final colors = DashboardStyle.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.smMd),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: colors.outline),
      ),
      child: Row(
        children: [
          Container(
            width: AppSpacing.xxl,
            height: AppSpacing.xxl,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: const Icon(
              Icons.science_outlined,
              color: AppColors.primary,
              size: AppSpacing.mdLg,
            ),
          ),
          const SizedBox(width: AppSpacing.smMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  draft.productName,
                  style: AppTypography.titleMedium(context).copyWith(
                    color: colors.onBackground,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  draft.manufacturer,
                  style: AppTypography.labelLarge(context).copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  draft.dosageSummary,
                  style: AppTypography.labelLarge(context).copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Align(
                  alignment: Alignment.centerLeft,
                  child: DashboardPill(
                    label: draft.categoryLabel,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
