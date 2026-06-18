import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import 'product_state.dart';

// ── Product List Notifier ────────────────────────────────────────────────────

class ProductNotifier extends StateNotifier<ProductState> {
  ProductNotifier({required this.repository}) : super(ProductState.initial());

  final ProductRepository repository;

  /// Load all products, optionally filtered by category
  Future<void> loadProducts({ProductCategory? category}) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      selectedCategory: category ?? state.selectedCategory,
    );
    final result = await repository.getProducts(
      category: (category ?? state.selectedCategory) == ProductCategory.all
          ? null
          : (category ?? state.selectedCategory),
    );
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.when(
          network: (m, _) => m,
          server: (m, _) => m,
          cache: (m) => m,
          authentication: (m) => m,
          authorization: (m) => m,
          validation: (m, _) => m,
          unknown: (m, _) => m,
        ),
      ),
      (products) => state = state.copyWith(
        isLoading: false,
        products: products,
      ),
    );
  }

  /// Set category filter and reload
  Future<void> setCategory(ProductCategory category) async {
    if (state.selectedCategory == category && state.products.isNotEmpty) return;
    state = state.copyWith(selectedCategory: category, searchQuery: '');
    await loadProducts(category: category);
  }

  /// Live search
  Future<void> search(String query) async {
    state = state.copyWith(searchQuery: query, isLoading: true, errorMessage: null);
    if (query.trim().isEmpty) {
      await loadProducts(category: state.selectedCategory);
      return;
    }
    final result = await repository.searchProducts(
      keyword: query,
      category: state.selectedCategory == ProductCategory.all
          ? null
          : state.selectedCategory,
    );
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.when(
          network: (m, _) => m,
          server: (m, _) => m,
          cache: (m) => m,
          authentication: (m) => m,
          authorization: (m) => m,
          validation: (m, _) => m,
          unknown: (m, _) => m,
        ),
      ),
      (products) => state = state.copyWith(isLoading: false, products: products),
    );
  }

  /// Clear search
  void clearSearch() {
    state = state.copyWith(searchQuery: '');
    loadProducts(category: state.selectedCategory);
  }
}

// ── Product Detail Notifier ──────────────────────────────────────────────────

class ProductDetailNotifier extends StateNotifier<ProductDetailState> {
  ProductDetailNotifier({required this.repository})
      : super(ProductDetailState.initial());

  final ProductRepository repository;

  Future<void> loadProduct(String id, List<String> relatedIds) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await repository.getProductById(id);
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.when(
          network: (m, _) => m,
          server: (m, _) => m,
          cache: (m) => m,
          authentication: (m) => m,
          authorization: (m) => m,
          validation: (m, _) => m,
          unknown: (m, _) => m,
        ),
      ),
      (product) async {
        state = state.copyWith(isLoading: false, product: product);
        // Load related products
        if (relatedIds.isNotEmpty) {
          final related = <ProductEntity>[];
          for (final rid in relatedIds.take(4)) {
            final res = await repository.getProductById(rid);
            res.fold((_) {}, (p) => related.add(p));
          }
          state = state.copyWith(relatedProducts: related);
        }
      },
    );
  }

  void reset() => state = ProductDetailState.initial();
}
