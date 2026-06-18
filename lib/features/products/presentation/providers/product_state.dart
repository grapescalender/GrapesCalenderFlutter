import '../../domain/entities/product_entity.dart';

/// Product list / search state
class ProductState {
  const ProductState({
    required this.products,
    required this.selectedCategory,
    required this.searchQuery,
    this.isLoading = false,
    this.errorMessage,
  });

  final List<ProductEntity> products;
  final ProductCategory selectedCategory;
  final String searchQuery;
  final bool isLoading;
  final String? errorMessage;

  factory ProductState.initial() => const ProductState(
        products: [],
        selectedCategory: ProductCategory.all,
        searchQuery: '',
      );

  ProductState copyWith({
    List<ProductEntity>? products,
    ProductCategory? selectedCategory,
    String? searchQuery,
    bool? isLoading,
    String? errorMessage,
  }) =>
      ProductState(
        products: products ?? this.products,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        searchQuery: searchQuery ?? this.searchQuery,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage,
      );
}

/// Product detail state
class ProductDetailState {
  const ProductDetailState({
    this.product,
    this.relatedProducts = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final ProductEntity? product;
  final List<ProductEntity> relatedProducts;
  final bool isLoading;
  final String? errorMessage;

  factory ProductDetailState.initial() => const ProductDetailState();

  ProductDetailState copyWith({
    ProductEntity? product,
    List<ProductEntity>? relatedProducts,
    bool? isLoading,
    String? errorMessage,
  }) =>
      ProductDetailState(
        product: product ?? this.product,
        relatedProducts: relatedProducts ?? this.relatedProducts,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage,
      );
}
