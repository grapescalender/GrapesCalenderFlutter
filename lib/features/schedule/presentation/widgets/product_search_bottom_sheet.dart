import 'package:flutter/material.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../shared/widgets/dashboard_design.dart';
import '../../../products/domain/entities/product_entity.dart';
import 'product_search_field.dart';

class ProductSearchBottomSheet extends StatelessWidget {
  const ProductSearchBottomSheet({
    super.key,
    required this.controller,
    required this.results,
    required this.isLoading,
    required this.onChanged,
    required this.onSelected,
    required this.addedProductIds,
    required this.focusNode,
  });

  final TextEditingController controller;
  final List<ProductEntity> results;
  final bool isLoading;
  final ValueChanged<String> onChanged;
  final ValueChanged<ProductEntity> onSelected;
  final Set<String> addedProductIds;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setSheetState) => DashboardBottomSheetFrame(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const DashboardSheetHeader(
              title: 'Add Product',
              subtitle: 'Search catalog, then set dose details.',
              icon: Icons.science_outlined,
            ),
            const SizedBox(height: AppSpacing.md),
            ProductSearchField(
              controller: controller,
              results: results,
              isLoading: isLoading,
              onChanged: onChanged,
              onSelected: onSelected,
              addedProductIds: addedProductIds,
              focusNode: focusNode,
            ),
          ],
        ),
      ),
    );
  }
}
