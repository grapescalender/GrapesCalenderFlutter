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
    this.focusNode,
  });

  final TextEditingController controller;
  final List<ProductEntity> results;
  final bool isLoading;
  final ValueChanged<String> onChanged;
  final ValueChanged<ProductEntity> onSelected;
  final Set<String> addedProductIds;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final query = controller.text.trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: controller,
          focusNode: focusNode,
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
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: results.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Text(
                      'No matching products found.',
                      style: AppTypography.bodyMedium(context).copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                    itemCount: results.take(8).length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      color: AppColors.outlineVariant,
                    ),
                    itemBuilder: (context, index) {
                      final product = results[index];
                      final isAdded = addedProductIds.contains(product.id);
                      return ListTile(
                        title: Text(
                          product.name,
                          style: AppTypography.bodyMedium(context).copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        subtitle: Text(
                          '${product.description}\n'
                          '${product.category.displayName} • ${product.company}',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Icon(
                          isAdded
                              ? Icons.check_circle_rounded
                              : Icons.add_circle_outline_rounded,
                          color:
                              isAdded ? AppColors.success : AppColors.primary,
                        ),
                        onTap: () => onSelected(product),
                      );
                    },
                  ),
          ),
        ],
      ],
    );
  }
}
