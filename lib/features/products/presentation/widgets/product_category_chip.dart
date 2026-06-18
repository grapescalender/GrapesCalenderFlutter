import 'package:flutter/material.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../domain/entities/product_entity.dart';

class ProductCategoryChip extends StatelessWidget {
  const ProductCategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final ProductCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  Color get _accent {
    switch (category) {
      case ProductCategory.pesticides:
        return AppColors.error;
      case ProductCategory.insecticides:
        return AppColors.warning;
      case ProductCategory.fungicides:
        return AppColors.chartBlue;
      case ProductCategory.fertilizers:
        return AppColors.success;
      case ProductCategory.nutrition:
        return AppColors.chartMint;
      case ProductCategory.growthRegulators:
        return AppColors.tertiary;
      case ProductCategory.bioProducts:
        return AppColors.chartGreen;
      case ProductCategory.all:
        return AppColors.primary;
    }
  }

  IconData get _icon {
    switch (category) {
      case ProductCategory.pesticides:
        return Icons.bug_report_rounded;
      case ProductCategory.insecticides:
        return Icons.pest_control_rounded;
      case ProductCategory.fungicides:
        return Icons.coronavirus_rounded;
      case ProductCategory.fertilizers:
        return Icons.grass_rounded;
      case ProductCategory.nutrition:
        return Icons.local_florist_rounded;
      case ProductCategory.growthRegulators:
        return Icons.trending_up_rounded;
      case ProductCategory.bioProducts:
        return Icons.eco_rounded;
      case ProductCategory.all:
        return Icons.apps_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.smMd, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? _accent : _accent.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(
            color: isSelected ? Colors.transparent : _accent.withValues(alpha: 0.3),
            width: 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _accent.withValues(alpha: 0.30),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _icon,
              size: 13,
              color: isSelected ? Colors.white : _accent,
            ),
            const SizedBox(width: 5),
            Text(
              category.displayName,
              style: AppTypography.labelMedium(context).copyWith(
                color: isSelected ? Colors.white : _accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
