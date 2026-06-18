import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../domain/entities/product_entity.dart';
import '../providers/product_providers.dart';
import '../widgets/product_card.dart';
import '../widgets/product_category_chip.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Page
// ─────────────────────────────────────────────────────────────────────────────
class ProductDetailsPage extends ConsumerStatefulWidget {
  const ProductDetailsPage({super.key, required this.product});
  final ProductEntity product;

  @override
  ConsumerState<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends ConsumerState<ProductDetailsPage> {
  final _scrollController = ScrollController();
  bool _showStickyHeader = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref
            .read(productDetailNotifierProvider.notifier)
            .loadProduct(widget.product.id, widget.product.relatedProductIds);
      }
    });
  }

  void _onScroll() {
    // Show sticky header after scrolling past hero (~260 px)
    final show = _scrollController.offset > 220;
    if (show != _showStickyHeader) setState(() => _showStickyHeader = show);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(productDetailNotifierProvider);
    final product = detailState.product ?? widget.product;
    final catColor = productCategoryColor(product.category);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Main scroll view ───────────────────────────────
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Hero image
              SliverToBoxAdapter(
                child: _HeroSection(product: product),
              ),
              // Identity card
              SliverToBoxAdapter(
                child: _IdentityCard(product: product, catColor: catColor),
              ),
              // Stat bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenHorizontal, AppSpacing.md,
                    AppSpacing.screenHorizontal, 0,
                  ),
                  child: _StatBar(product: product, catColor: catColor),
                ),
              ),
              // Overview
              _sectionPad(_OverviewSection(product: product)),
              // Benefits
              _sectionPad(_BenefitsSection(product: product, catColor: catColor)),
              // Recommended Stages
              _sectionPad(_StagesSection(product: product)),
              // Dosage & Application
              _sectionPad(_DosageSection(product: product, catColor: catColor)),
              // Usage Instructions
              _sectionPad(_UsageSection(product: product)),
              // Precautions
              _sectionPad(_PrecautionsSection(product: product)),
              // Used In
              _sectionPad(const _UsedInSection()),
              // Related Products
              if (detailState.relatedProducts.isNotEmpty)
                SliverToBoxAdapter(
                  child: _RelatedSection(
                    products: detailState.relatedProducts,
                    onTap: (p) => Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (_) => ProductDetailsPage(product: p),
                      ),
                    ),
                  ),
                ),
              const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.xxl)),
            ],
          ),

          // ── Sticky mini-header ────────────────────────────
          if (_showStickyHeader)
            _StickyHeader(product: product, catColor: catColor),
        ],
      ),
    );
  }

  SliverToBoxAdapter _sectionPad(Widget child) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenHorizontal, AppSpacing.md,
            AppSpacing.screenHorizontal, 0,
          ),
          child: child,
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// STICKY MINI-HEADER
// ─────────────────────────────────────────────────────────────────────────────
class _StickyHeader extends StatelessWidget {
  const _StickyHeader({required this.product, required this.catColor});
  final ProductEntity product;
  final Color catColor;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
              bottom: BorderSide(color: AppColors.outline, width: 1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.xs, AppSpacing.xs,
                AppSpacing.md, AppSpacing.xs),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 18, color: AppColors.onBackground),
                  padding: EdgeInsets.zero,
                ),
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: catColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Icon(productCategoryIcon(product.category),
                      size: 16, color: catColor),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(product.name,
                          style: AppTypography.titleLarge(context)
                              .copyWith(fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      Text(product.company,
                          style: AppTypography.bodySmall(context)
                              .copyWith(color: AppColors.onSurfaceVariant),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
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
// HERO SECTION — full-bleed image with back button + badges overlaid
// ─────────────────────────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.product});
  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Full-bleed image
        ProductImagePanel(
          category: product.category,
          width: double.infinity,
          height: 260,
          iconSize: 80,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(AppSpacing.radiusHuge),
            bottomRight: Radius.circular(AppSpacing.radiusHuge),
          ),
        ),

        // Back button — top-left
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.smMd),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.30),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.30)),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 17, color: Colors.white),
              ),
            ),
          ),
        ),

        // Badges — top-right
        if (product.isNew || product.isFeatured)
          Positioned(
            top: MediaQuery.of(context).padding.top + AppSpacing.smMd,
            right: AppSpacing.smMd,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (product.isFeatured)
                  _HeroBadge('★ Featured',
                      AppColors.warningLight, AppColors.warning),
                if (product.isFeatured && product.isNew)
                  const SizedBox(width: AppSpacing.sm),
                if (product.isNew)
                  _HeroBadge('NEW', AppColors.successLight, AppColors.success),
              ],
            ),
          ),
      ],
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge(this.label, this.bg, this.color);
  final String label;
  final Color bg;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(label,
            style: AppTypography.labelSmall(context)
                .copyWith(color: color, fontWeight: FontWeight.w800)),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// IDENTITY CARD — name / category / company right below the hero
// ─────────────────────────────────────────────────────────────────────────────
class _IdentityCard extends StatelessWidget {
  const _IdentityCard(
      {required this.product, required this.catColor});
  final ProductEntity product;
  final Color catColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
          AppSpacing.screenHorizontal, AppSpacing.md,
          AppSpacing.screenHorizontal, 0),
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.outline),
        boxShadow: [
          BoxShadow(
            color: catColor.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product name
          Text(
            product.name,
            style: AppTypography.headlineMedium(context).copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.onBackground,
              height: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Category + company row
          Row(
            children: [
              ProductCategoryChip(
                  category: product.category,
                  isSelected: true,
                  onTap: () {}),
              const SizedBox(width: AppSpacing.smMd),
              const Icon(Icons.domain_rounded,
                  size: 12, color: AppColors.onSurfaceVariant),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  product.company,
                  style: AppTypography.bodySmall(context).copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.smMd),

          // Description
          Text(
            product.description,
            style: AppTypography.bodyMedium(context).copyWith(
              color: AppColors.onSurface,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STAT BAR — 3 quick-scan tiles: dosage / method / stages count
// ─────────────────────────────────────────────────────────────────────────────
class _StatBar extends StatelessWidget {
  const _StatBar({required this.product, required this.catColor});
  final ProductEntity product;
  final Color catColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.smMd, vertical: AppSpacing.smMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatTile(
              icon: Icons.science_outlined,
              label: 'Dosage',
              value: product.dosage,
              color: catColor,
            ),
          ),
          _Divider(),
          Expanded(
            child: _StatTile(
              icon: Icons.water_drop_outlined,
              label: 'Method',
              value: product.applicationMethod,
              color: catColor,
            ),
          ),
          _Divider(),
          Expanded(
            child: _StatTile(
              icon: Icons.eco_outlined,
              label: 'Stages',
              value: '${product.recommendedStages.length} stages',
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 15, color: color),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: AppTypography.labelSmall(context).copyWith(
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTypography.labelMedium(context).copyWith(
              color: AppColors.onBackground,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 1, height: 44,
        color: AppColors.outlineVariant,
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED SECTION CARD WRAPPER
// ─────────────────────────────────────────────────────────────────────────────
class _SectionWrapper extends StatelessWidget {
  const _SectionWrapper({
    required this.icon,
    required this.title,
    required this.accentColor,
    required this.child,
  });
  final IconData icon;
  final String title;
  final Color accentColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header with left accent bar
          Container(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.cardPadding, AppSpacing.smMd,
                AppSpacing.cardPadding, AppSpacing.smMd),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSpacing.radiusLg),
                topRight: Radius.circular(AppSpacing.radiusLg),
              ),
              border: Border(
                  bottom: BorderSide(color: AppColors.outlineVariant)),
            ),
            child: Row(
              children: [
                // Left accent bar
                Container(
                  width: 4, height: 20,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: AppSpacing.smMd),
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Icon(icon, size: 16, color: accentColor),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  title,
                  style: AppTypography.titleLarge(context).copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.onBackground,
                  ),
                ),
              ],
            ),
          ),
          // Section body
          Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// OVERVIEW SECTION
// ─────────────────────────────────────────────────────────────────────────────
class _OverviewSection extends StatelessWidget {
  const _OverviewSection({required this.product});
  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return _SectionWrapper(
      icon: Icons.info_outline_rounded,
      title: 'Overview',
      accentColor: AppColors.info,
      child: Column(
        children: [
          _OverviewRow(
              Icons.science_outlined, 'Dosage', product.dosage),
          const SizedBox(height: AppSpacing.smMd),
          _OverviewRow(
              Icons.water_drop_outlined, 'Application', product.applicationMethod),
          const SizedBox(height: AppSpacing.smMd),
          _OverviewRow(
              Icons.eco_outlined, 'Primary Stage', product.primaryStage),
        ],
      ),
    );
  }
}

class _OverviewRow extends StatelessWidget {
  const _OverviewRow(this.icon, this.label, this.value);
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34, height: 34,
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Icon(icon, size: 16, color: AppColors.info),
        ),
        const SizedBox(width: AppSpacing.smMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: AppTypography.labelSmall(context).copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  )),
              const SizedBox(height: 2),
              Text(value,
                  style: AppTypography.bodyMedium(context).copyWith(
                    color: AppColors.onBackground,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BENEFITS SECTION — icon+text cards in a grid-like column
// ─────────────────────────────────────────────────────────────────────────────
class _BenefitsSection extends StatelessWidget {
  const _BenefitsSection(
      {required this.product, required this.catColor});
  final ProductEntity product;
  final Color catColor;

  @override
  Widget build(BuildContext context) {
    return _SectionWrapper(
      icon: Icons.verified_rounded,
      title: 'Benefits',
      accentColor: AppColors.success,
      child: Column(
        children: product.benefits.asMap().entries.map((e) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: e.key < product.benefits.length - 1
                    ? AppSpacing.sm
                    : 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 26, height: 26,
                  margin: const EdgeInsets.only(top: 1),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded,
                      size: 14, color: AppColors.success),
                ),
                const SizedBox(width: AppSpacing.smMd),
                Expanded(
                  child: Text(
                    e.value,
                    style: AppTypography.bodyMedium(context).copyWith(
                      color: AppColors.onSurface,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RECOMMENDED STAGES SECTION — pill row with grape growth lifecycle
// ─────────────────────────────────────────────────────────────────────────────
class _StagesSection extends StatelessWidget {
  const _StagesSection({required this.product});
  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return _SectionWrapper(
      icon: Icons.eco_rounded,
      title: 'Recommended Stages',
      accentColor: AppColors.primary,
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: product.recommendedStages.asMap().entries.map((e) {
          final isFirst = e.key == 0;
          return Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.smMd, vertical: 7),
            decoration: BoxDecoration(
              color: isFirst
                  ? AppColors.primary
                  : AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              boxShadow: isFirst
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.30),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isFirst
                      ? Icons.star_rounded
                      : Icons.eco_outlined,
                  size: 12,
                  color: isFirst
                      ? Colors.white
                      : AppColors.onPrimaryContainer,
                ),
                const SizedBox(width: 5),
                Text(
                  e.value,
                  style: AppTypography.labelMedium(context).copyWith(
                    color: isFirst
                        ? Colors.white
                        : AppColors.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DOSAGE & APPLICATION SECTION
// ─────────────────────────────────────────────────────────────────────────────
class _DosageSection extends StatelessWidget {
  const _DosageSection(
      {required this.product, required this.catColor});
  final ProductEntity product;
  final Color catColor;

  @override
  Widget build(BuildContext context) {
    return _SectionWrapper(
      icon: Icons.science_rounded,
      title: 'Dosage & Application',
      accentColor: AppColors.chartBlue,
      child: Column(
        children: [
          _DosageCard(
            icon: Icons.science_outlined,
            label: 'Dosage',
            value: product.dosage,
            color: catColor,
          ),
          const SizedBox(height: AppSpacing.sm),
          _DosageCard(
            icon: Icons.water_drop_outlined,
            label: 'Application Method',
            value: product.applicationMethod,
            color: catColor,
          ),
          const SizedBox(height: AppSpacing.sm),
          _DosageCard(
            icon: Icons.eco_outlined,
            label: 'Suitable Stages',
            value: product.recommendedStages.join(' · '),
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _DosageCard extends StatelessWidget {
  const _DosageCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.smMd, vertical: AppSpacing.smMd),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(icon, size: 17, color: color),
          ),
          const SizedBox(width: AppSpacing.smMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: AppTypography.labelSmall(context).copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    )),
                const SizedBox(height: 3),
                Text(value,
                    style: AppTypography.bodyMedium(context).copyWith(
                      color: AppColors.onBackground,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// USAGE INSTRUCTIONS SECTION
// ─────────────────────────────────────────────────────────────────────────────
class _UsageSection extends StatelessWidget {
  const _UsageSection({required this.product});
  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    // Split on ". " so each sentence becomes its own step
    final steps = product.usageInstructions
        .split('. ')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    return _SectionWrapper(
      icon: Icons.menu_book_rounded,
      title: 'Usage Instructions',
      accentColor: AppColors.tertiary,
      child: Column(
        children: steps.asMap().entries.map((e) {
          final stepNum = e.key + 1;
          final isLast = e.key == steps.length - 1;
          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.smMd),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step number circle
                Container(
                  width: 26, height: 26,
                  margin: const EdgeInsets.only(top: 1),
                  decoration: BoxDecoration(
                    color: AppColors.tertiary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$stepNum',
                      style: AppTypography.labelSmall(context).copyWith(
                        color: AppColors.tertiary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.smMd),
                Expanded(
                  child: Text(
                    // Re-add period if not last and doesn't already end with one
                    isLast ? e.value : '${e.value}.',
                    style: AppTypography.bodyMedium(context).copyWith(
                      color: AppColors.onSurface,
                      height: 1.55,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PRECAUTIONS SECTION — warning-tinted cards
// ─────────────────────────────────────────────────────────────────────────────
class _PrecautionsSection extends StatelessWidget {
  const _PrecautionsSection({required this.product});
  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return _SectionWrapper(
      icon: Icons.warning_amber_rounded,
      title: 'Precautions',
      accentColor: AppColors.warning,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.smMd),
        decoration: BoxDecoration(
          color: AppColors.warningLight.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
              color: AppColors.warning.withValues(alpha: 0.25)),
        ),
        child: Column(
          children: product.precautions.asMap().entries.map((e) {
            final isLast = e.key == product.precautions.length - 1;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Icon(Icons.error_outline_rounded,
                          size: 13, color: AppColors.warning),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        e.value,
                        style: AppTypography.bodyMedium(context).copyWith(
                          color: AppColors.warningDark,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
                if (!isLast) ...[
                  const SizedBox(height: 4),
                  Divider(height: 1,
                      color: AppColors.warning.withValues(alpha: 0.2)),
                  const SizedBox(height: 4),
                ],
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// USED IN SECTION — 2×2 grid chips showing future integration points
// ─────────────────────────────────────────────────────────────────────────────
class _UsedInSection extends StatelessWidget {
  const _UsedInSection();

  @override
  Widget build(BuildContext context) {
    final integrations = [
      (Icons.water_drop_rounded, 'Spray Schedule', AppColors.info),
      (Icons.local_florist_rounded, 'Nutrition Schedule', AppColors.warning),
      (Icons.person_rounded, 'Consultant Recommendation', AppColors.tertiary),
      (Icons.receipt_long_rounded, 'Expense Entry', AppColors.secondary),
    ];

    return _SectionWrapper(
      icon: Icons.link_rounded,
      title: 'Used In',
      accentColor: AppColors.primary,
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
        childAspectRatio: 2.8,
        children: integrations.map((item) {
          return Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.smMd, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: item.$3.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                  color: item.$3.withValues(alpha: 0.20)),
            ),
            child: Row(
              children: [
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: item.$3.withValues(alpha: 0.14),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Icon(item.$1, size: 14, color: item.$3),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    item.$2,
                    style: AppTypography.labelSmall(context).copyWith(
                      color: AppColors.onBackground,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RELATED PRODUCTS — horizontal scroll so page doesn't grow too long
// ─────────────────────────────────────────────────────────────────────────────
class _RelatedSection extends StatelessWidget {
  const _RelatedSection(
      {required this.products, required this.onTap});
  final List<ProductEntity> products;
  final void Function(ProductEntity) onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenHorizontal, AppSpacing.md,
              AppSpacing.screenHorizontal, AppSpacing.smMd),
          child: Row(
            children: [
              Container(
                width: 4, height: 18,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppSpacing.smMd),
              const Icon(Icons.compare_arrows_rounded,
                  size: 16, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Related Products',
                style: AppTypography.headlineSmall(context)
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontal),
            itemCount: products.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: AppSpacing.smMd),
            itemBuilder: (_, i) {
              final p = products[i];
              final color = productCategoryColor(p.category);
              return GestureDetector(
                onTap: () => onTap(p),
                child: Container(
                  width: 160,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusLg),
                    border: Border.all(color: AppColors.outline),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thumbnail
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppSpacing.radiusLg),
                          topRight: Radius.circular(AppSpacing.radiusLg),
                        ),
                        child: ProductImagePanel(
                          category: p.category,
                          width: 160,
                          height: 90,
                          iconSize: 32,
                        ),
                      ),
                      // Info
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.name,
                              style: AppTypography.titleSmall(context)
                                  .copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.onBackground,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusFull),
                              ),
                              child: Text(
                                p.category.displayName,
                                style: AppTypography.labelSmall(context)
                                    .copyWith(
                                  color: color,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
