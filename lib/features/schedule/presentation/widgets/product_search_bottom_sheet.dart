import 'package:flutter/material.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../shared/widgets/dashboard_design.dart';
import '../../../products/domain/entities/product_entity.dart';
import 'product_search_field.dart';

class ProductSearchBottomSheet extends StatefulWidget {
  const ProductSearchBottomSheet({
    super.key,
    required this.results,
    required this.isLoading,
    required this.onChanged,
    required this.onSelected,
    required this.addedProductIds,
  });

  final List<ProductEntity> results;
  final bool isLoading;
  final ValueChanged<String> onChanged;
  final ValueChanged<ProductEntity> onSelected;
  final Set<String> addedProductIds;

  @override
  State<ProductSearchBottomSheet> createState() =>
      _ProductSearchBottomSheetState();
}

class _ProductSearchBottomSheetState extends State<ProductSearchBottomSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardBottomSheetFrame(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DashboardSheetHeader(
            title: 'Add Product',
            subtitle: 'Search catalog, then set dose details.',
          ),
          const SizedBox(height: AppSpacing.md),
          ProductSearchField(
            controller: _controller,
            results: widget.results,
            isLoading: widget.isLoading,
            onChanged: widget.onChanged,
            onSelected: widget.onSelected,
            addedProductIds: widget.addedProductIds,
          ),
        ],
      ),
    );
  }
}
