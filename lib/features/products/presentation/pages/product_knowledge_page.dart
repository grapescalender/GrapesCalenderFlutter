import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../core/design_system/theme/app_branding.dart';
import '../../domain/entities/product_entity.dart';
import '../providers/product_notifier.dart';
import '../providers/product_providers.dart';
import '../providers/product_state.dart';
import '../widgets/product_card.dart';
import '../widgets/product_category_chip.dart';
import 'product_details_page.dart';

class ProductKnowledgePage extends ConsumerStatefulWidget {
  const ProductKnowledgePage({super.key});

  @override
  ConsumerState<ProductKnowledgePage> createState() =>
      _ProductKnowledgePageState();
}

class _ProductKnowledgePageState extends ConsumerState<ProductKnowledgePage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _searchFocused = false;

  static const _categories = ProductCategory.values;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(productNotifierProvider.notifier).loadProducts();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    ref.read(productNotifierProvider.notifier).search(query);
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(productNotifierProvider.notifier).clearSearch();
  }

  void _onCategoryTap(ProductCategory category) {
    ref.read(productNotifierProvider.notifier).setCategory(category);
  }

  void _openDetails(ProductEntity product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailsPage(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productNotifierProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Gradient Header ────────────────────────────────
          _buildHeader(context),

          // ── Sticky Search + Filters ────────────────────────
          _buildSearchAndFilters(context, state),

          // ── Product List ───────────────────────────────────
          Expanded(child: _buildBody(context, state)),
        ],
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    final branding = Theme.of(context).extension<AppBranding>()!;
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(gradient: branding.headerGradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenHorizontal,
            AppSpacing.md,
            AppSpacing.screenHorizontal,
            AppSpacing.md,
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: cs.onPrimary.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: const Icon(Icons.inventory_2_rounded,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: AppSpacing.smMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product Knowledge Center',
                      style: AppTypography.headlineMedium(context).copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Explore products used in grape cultivation',
                      style: AppTypography.labelLarge(context).copyWith(
                        color: cs.onPrimary.withValues(alpha: 0.85),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.smMd, vertical: 6),
                decoration: BoxDecoration(
                  color: cs.onPrimary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  border:
                      Border.all(color: cs.onPrimary.withValues(alpha: 0.25)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome_rounded,
                        size: 13, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      'Library',
                      style: AppTypography.labelLarge(context).copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Search + category filters (sticky) ──────────────────────────────────────
  Widget _buildSearchAndFilters(BuildContext context, ProductState state) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.screenHorizontal,
                AppSpacing.smMd, AppSpacing.screenHorizontal, AppSpacing.sm),
            child: Focus(
              onFocusChange: (f) => setState(() => _searchFocused = f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(
                    color:
                        _searchFocused ? AppColors.primary : AppColors.outline,
                    width: _searchFocused ? 1.5 : 1.0,
                  ),
                  boxShadow: _searchFocused
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : [],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearch,
                  style: AppTypography.bodyMedium(context)
                      .copyWith(color: AppColors.onBackground),
                  decoration: InputDecoration(
                    hintText: 'Search Product Name',
                    hintStyle: AppTypography.bodyMedium(context)
                        .copyWith(color: AppColors.onSurfaceVariant),
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: AppColors.onSurfaceVariant, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: _clearSearch,
                            child: const Icon(Icons.cancel_rounded,
                                color: AppColors.onSurfaceVariant, size: 18),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _HeaderIconBtn(
                                icon: Icons.filter_list_rounded,
                                onTap: () {}, // future: filter bottom sheet
                              ),
                              _HeaderIconBtn(
                                icon: Icons.sort_rounded,
                                onTap: () {}, // future: sort bottom sheet
                              ),
                              const SizedBox(width: 4),
                            ],
                          ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: AppSpacing.md),
                  ),
                ),
              ),
            ),
          ),

          // Category chips horizontal scroll
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (_, i) {
                final cat = _categories[i];
                return ProductCategoryChip(
                  category: cat,
                  isSelected: state.selectedCategory == cat,
                  onTap: () => _onCategoryTap(cat),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.smMd),

          // Result count bar
          if (!state.isLoading)
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.screenHorizontal, 0,
                  AppSpacing.screenHorizontal, AppSpacing.sm),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.smMd, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: Text(
                      '${state.products.length} Products',
                      style: AppTypography.labelLarge(context).copyWith(
                        color: AppColors.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (state.searchQuery.isNotEmpty) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'for "${state.searchQuery}"',
                      style: AppTypography.labelLarge(context)
                          .copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ],
              ),
            ),
          const Divider(height: 1, color: AppColors.outline),
        ],
      ),
    );
  }

  // ── Body (loading / empty / list) ────────────────────────────────────────────
  Widget _buildBody(BuildContext context, ProductState state) {
    if (state.isLoading) return const _ProductSkeleton();

    if (state.errorMessage != null) {
      return _ErrorState(
        message: state.errorMessage!,
        onRetry: () =>
            ref.read(productNotifierProvider.notifier).loadProducts(),
      );
    }

    if (state.products.isEmpty) {
      return _EmptyState(query: state.searchQuery);
    }

    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        AppSpacing.md,
        AppSpacing.screenHorizontal,
        AppSpacing.xxl,
      ),
      itemCount: state.products.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.smMd),
      itemBuilder: (_, i) => ProductCard(
        product: state.products[i],
        onTap: () => _openDetails(state.products[i]),
      ),
    );
  }
}

// ── Small helper widgets ─────────────────────────────────────────────────────

class _HeaderIconBtn extends StatelessWidget {
  const _HeaderIconBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Icon(icon, size: 18, color: AppColors.onSurfaceVariant),
        ),
      );
}

class _ProductSkeleton extends StatelessWidget {
  const _ProductSkeleton();
  @override
  Widget build(BuildContext context) => ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.smMd),
        itemBuilder: (_, __) => Container(
          height: 130,
          decoration: BoxDecoration(
            color: AppColors.outline.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
        ),
      );
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                ),
                child: const Icon(Icons.error_outline_rounded,
                    color: AppColors.error, size: 32),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(message,
                  style: AppTypography.bodyMedium(context)
                      .copyWith(color: AppColors.onSurface),
                  textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query});
  final String query;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                ),
                child: const Icon(Icons.inventory_2_outlined,
                    color: AppColors.primary, size: 34),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                query.isNotEmpty
                    ? 'No results for "$query"'
                    : 'No products found',
                style: AppTypography.titleLarge(context)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Try a different search term or category.',
                style: AppTypography.bodyMedium(context)
                    .copyWith(color: AppColors.onSurface),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
}
