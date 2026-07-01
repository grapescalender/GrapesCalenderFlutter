import 'package:flutter/material.dart';

import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/dashboard_design.dart';
import '../../../products/domain/entities/product_entity.dart';

class ProductSearchField extends StatelessWidget {
  const ProductSearchField({
    super.key,
    required this.controller,
    required this.results,
    required this.isLoading,
    required this.onChanged,
    required this.onSelected,
    required this.addedProductIds,
  });

  final TextEditingController controller;
  final List<ProductEntity> results;
  final bool isLoading;
  final ValueChanged<String> onChanged;
  final ValueChanged<ProductEntity> onSelected;
  final Set<String> addedProductIds;

  @override
  Widget build(BuildContext context) {
    final query = controller.text.trim();
    final colors = DashboardStyle.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: controller,
          autofocus: true,
          decoration: DashboardField.decoration(
            context: context,
            label: 'Search Product',
            hint: 'Search insecticide, fungicide, fertilizer…',
            icon: Icons.search_rounded,
          ).copyWith(
            suffixIcon: isLoading
                ? const Padding(
                    padding: EdgeInsets.all(AppSpacing.smMd),
                    child: SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : null,
          ),
          onChanged: onChanged,
        ),
        if (query.isNotEmpty && !isLoading) ...[
          const SizedBox(height: AppSpacing.sm),
          Container(
            constraints: const BoxConstraints(maxHeight: 260),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(color: colors.outline),
            ),
            child: results.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Text(
                      'No matching products found.',
                      style: AppTypography.bodyMedium(context).copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                    itemCount: results.take(8).length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: colors.outline,
                    ),
                    itemBuilder: (context, index) {
                      final product = results[index];
                      final isAdded = addedProductIds.contains(product.id);
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                          vertical: AppSpacing.xs,
                        ),
                        child: InkWell(
                          onTap: () => onSelected(product),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.smMd,
                              vertical: AppSpacing.sm,
                            ),
                            decoration: BoxDecoration(
                              color: isAdded
                                  ? colors.primaryContainer
                                      .withValues(alpha: 0.12)
                                  : colors.background,
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.radiusMd),
                              border: Border.all(
                                color: isAdded
                                    ? colors.primary.withValues(alpha: 0.42)
                                    : colors.outline,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          product.name,
                                          style:
                                              AppTypography.titleMedium(context)
                                                  .copyWith(
                                            color: isAdded
                                                ? colors.primary
                                                : colors.onBackground,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      _ProductChip(
                                          label: product.category.displayName),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Icon(
                                  isAdded
                                      ? Icons.check_circle_rounded
                                      : Icons.add_circle_outline_rounded,
                                  color: isAdded
                                      ? AppColors.success
                                      : colors.primary,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ],
    );
  }
}

class _ProductChip extends StatelessWidget {
  const _ProductChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = DashboardStyle.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        label,
        style: AppTypography.labelLarge(context).copyWith(
          color: colors.primary,
        ),
      ),
    );
  }
}
