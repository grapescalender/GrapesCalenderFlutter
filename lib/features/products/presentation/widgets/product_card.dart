import 'package:flutter/material.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../domain/entities/product_entity.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Shared category helpers (used by card + details page)
// ─────────────────────────────────────────────────────────────────────────────
Color productCategoryColor(ProductCategory cat) {
  switch (cat) {
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

IconData productCategoryIcon(ProductCategory cat) {
  switch (cat) {
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
      return Icons.inventory_2_rounded;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Product Image Panel — reused in card AND details page hero
// ─────────────────────────────────────────────────────────────────────────────
class ProductImagePanel extends StatelessWidget {
  const ProductImagePanel({
    super.key,
    required this.category,
    required this.width,
    required this.height,
    this.iconSize = 36,
    this.borderRadius,
  });

  final ProductCategory category;
  final double width;
  final double height;
  final double iconSize;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final icon = productCategoryIcon(category);
    final gradients = _gradientForCategory(category);
    final catColor = productCategoryColor(category);

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Real product image — original colours, no overlay ──
            Image.asset(
              'assets/images/sectin.jpeg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                // fallback: gradient only when image fails to load
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradients,
                  ),
                ),
              ),
            ),

            // ── Category icon badge — bottom-left corner ───
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                width: iconSize * 0.85,
                height: iconSize * 0.85,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.90),
                  border: Border.all(
                    color: catColor.withValues(alpha: 0.30),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: iconSize * 0.45,
                  color: catColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static List<Color> _gradientForCategory(ProductCategory cat) {
    switch (cat) {
      case ProductCategory.pesticides:
        return [const Color(0xFFCC3333), const Color(0xFF8B1A1A)];
      case ProductCategory.insecticides:
        return [const Color(0xFFD4880A), const Color(0xFF8C5600)];
      case ProductCategory.fungicides:
        return [const Color(0xFF3D8FD4), const Color(0xFF1A4578)];
      case ProductCategory.fertilizers:
        return [const Color(0xFF1A8C5B), const Color(0xFF105C3C)];
      case ProductCategory.nutrition:
        return [const Color(0xFF2DBD9A), const Color(0xFF0E7C6B)];
      case ProductCategory.growthRegulators:
        return [const Color(0xFF6B7C3E), const Color(0xFF455227)];
      case ProductCategory.bioProducts:
        return [const Color(0xFF0E7C6B), const Color(0xFF05403A)];
      case ProductCategory.all:
        return [AppColors.primary, AppColors.primaryDark];
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Product Card
// ─────────────────────────────────────────────────────────────────────────────
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final ProductEntity product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final catColor = productCategoryColor(product.category);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.outline),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
            BoxShadow(
              color: catColor.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Left: image panel ──────────────────────────
                ProductImagePanel(
                  category: product.category,
                  width: 88,
                  height: double.infinity,
                  iconSize: 32,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSpacing.radiusLg),
                    bottomLeft: Radius.circular(AppSpacing.radiusLg),
                  ),
                ),

                // ── Right: content ─────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.smMd,
                      AppSpacing.smMd,
                      AppSpacing.smMd,
                      AppSpacing.smMd,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row 1: Name + badges
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                style: AppTypography.titleLarge(context)
                                    .copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.onBackground,
                                  height: 1.25,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (product.isNew) ...[
                              const SizedBox(width: 4),
                              _Pill(
                                'NEW',
                                AppColors.success,
                                AppColors.successLight,
                              ),
                            ],
                            if (product.isFeatured) ...[
                              const SizedBox(width: 4),
                              _Pill(
                                '★',
                                AppColors.warning,
                                AppColors.warningLight,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 5),

                        // Row 2: Category badge + company
                        Row(
                          children: [
                            _CategoryPill(
                              label: product.category.displayName,
                              color: catColor,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.domain_rounded,
                                    size: 11,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 3),
                                  Expanded(
                                    child: Text(
                                      product.company,
                                      style: AppTypography.bodySmall(context)
                                          .copyWith(
                                        color: AppColors.onSurfaceVariant,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),

                        // Row 3: Short description
                        Text(
                          product.description,
                          style: AppTypography.bodySmall(context).copyWith(
                            color: AppColors.onSurface,
                            height: 1.5,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.smMd),

                        // Row 4: Stage + Dosage pills
                        Row(
                          children: [
                            _InfoChip(
                              icon: Icons.eco_outlined,
                              label: product.primaryStage,
                              color: AppColors.primary,
                              bg: AppColors.primaryContainer,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: _InfoChip(
                                icon: Icons.science_outlined,
                                label: product.dosage,
                                color: catColor,
                                bg: catColor.withValues(alpha: 0.08),
                                flex: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.smMd),

                        // Row 5: Divider + View Details CTA
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: AppColors.outlineVariant,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'View Details',
                              style: AppTypography.labelMedium(context)
                                  .copyWith(
                                color: catColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 10,
                              color: catColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Small reusable badge widgets
// ─────────────────────────────────────────────────────────────────────────────
class _Pill extends StatelessWidget {
  const _Pill(this.label, this.color, this.bg);
  final String label;
  final Color color;
  final Color bg;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall(context).copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
      );
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(
            color: color.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall(context).copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.bg,
    this.flex = false,
  });
  final IconData icon;
  final String label;
  final Color color;
  final Color bg;
  final bool flex;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Row(
          mainAxisSize: flex ? MainAxisSize.max : MainAxisSize.min,
          children: [
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: AppTypography.labelSmall(context).copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      );
}
