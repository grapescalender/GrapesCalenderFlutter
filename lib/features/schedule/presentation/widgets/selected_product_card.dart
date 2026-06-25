import 'package:flutter/material.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/dashboard_design.dart';
import '../models/add_schedule_request.dart';

class SelectedProductCard extends StatelessWidget {
  const SelectedProductCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onRemove,
  });

  final ScheduleProductDraft product;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.smMd),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  product.productName,
                  style: AppTypography.titleMedium(context).copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              IconButton(
                tooltip: 'Edit product dose',
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
                color: cs.primary,
                style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              IconButton(
                tooltip: 'Remove product',
                onPressed: onRemove,
                icon: const Icon(Icons.close_rounded),
                color: cs.error,
                style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  border: Border.all(color: cs.primary.withValues(alpha: 0.16)),
                ),
                child: Text(
                  product.categoryLabel,
                  style: AppTypography.labelLarge(context).copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  '${product.dose} ${product.doseUnit} / '
                  '${product.perWaterQuantity} ${product.perWaterUnit}',
                  style: AppTypography.bodyMedium(context).copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
