import 'package:flutter/material.dart';

import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../models/add_schedule_request.dart';

class AddedProductCard extends StatelessWidget {
  const AddedProductCard({
    required this.product,
    required this.onChanged,
    required this.onRemove,
    required this.onEdit,
    required this.onDone,
    required this.isEditing,
    super.key,
    this.showErrors = false,
  });

  final ScheduleProductDraft product;
  final ValueChanged<ScheduleProductDraft> onChanged;
  final VoidCallback onRemove;
  final VoidCallback onEdit;
  final VoidCallback onDone;
  final bool isEditing;
  final bool showErrors;

  @override
  Widget build(BuildContext context) {
    return _SelectedProductSummaryLine(
      product: product,
      onEdit: onEdit,
      onRemove: onRemove,
    );
  }
}

class _SelectedProductSummaryLine extends StatelessWidget {
  const _SelectedProductSummaryLine({
    required this.product,
    required this.onEdit,
    required this.onRemove,
  });

  final ScheduleProductDraft product;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    product.productName,
                    style: AppTypography.cardTitle(context).copyWith(
                      color: AppColors.onBackground,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  tooltip: 'Edit product',
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                  color: AppColors.primary,
                ),
                IconButton(
                  tooltip: 'Remove product',
                  onPressed: onRemove,
                  icon: const Icon(Icons.close_rounded),
                  color: AppColors.error,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _ProductChip(label: product.categoryLabel),
                Text(
                  '${product.dose} ${product.doseUnit} / '
                  '${product.perWaterQuantity} ${product.perWaterUnit}',
                  style: AppTypography.caption(context).copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      );
}

class _ProductChip extends StatelessWidget {
  const _ProductChip({required this.label});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: Text(
          label,
          style: AppTypography.chipText(context).copyWith(
            color: AppColors.primary,
          ),
        ),
      );

  final String label;
}
