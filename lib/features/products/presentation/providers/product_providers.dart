import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/mock_product_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';
import 'product_notifier.dart';
import 'product_state.dart';

/// Mock data source (singleton)
final productDataSourceProvider = Provider<ProductApiService>(
  (_) => MockProductDataSource(),
);

/// Repository
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final ds = ref.watch(productDataSourceProvider);
  return ProductRepositoryImpl(dataSource: ds);
});

/// Product list notifier
final productNotifierProvider =
    StateNotifierProvider<ProductNotifier, ProductState>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return ProductNotifier(repository: repo);
});

/// Product detail notifier (autoDispose so each detail page gets fresh state)
final productDetailNotifierProvider =
    StateNotifierProvider.autoDispose<ProductDetailNotifier, ProductDetailState>(
        (ref) {
  final repo = ref.watch(productRepositoryProvider);
  return ProductDetailNotifier(repository: repo);
});
