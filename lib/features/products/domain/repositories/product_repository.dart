import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product_entity.dart';

/// Product repository interface — domain layer contract
abstract class ProductRepository {
  /// Fetch all products, optionally filtered by category
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    ProductCategory? category,
  });

  /// Fetch a single product by id
  Future<Either<Failure, ProductEntity>> getProductById(String id);

  /// Search products by keyword, category, stage, or company
  Future<Either<Failure, List<ProductEntity>>> searchProducts({
    String? keyword,
    ProductCategory? category,
    String? stage,
    String? company,
  });

  /// Fetch products recommended for a given grape growth stage
  Future<Either<Failure, List<ProductEntity>>> getRecommendedProducts({
    required String stage,
  });
}
