import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/mock_product_datasource.dart';

/// Product repository implementation — delegates to mock data source
class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({required this.dataSource});
  final ProductApiService dataSource;

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    ProductCategory? category,
  }) async {
    try {
      final models = await dataSource.getProducts(
        category: category?.value,
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(Failure.unknown(
        message: 'Failed to load products: ${e.toString()}',
        error: e,
      ));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(String id) async {
    try {
      final model = await dataSource.getProductById(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(Failure.unknown(
        message: 'Product not found: ${e.toString()}',
        error: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts({
    String? keyword,
    ProductCategory? category,
    String? stage,
    String? company,
  }) async {
    try {
      final models = await dataSource.searchProducts(
        keyword: keyword,
        category: category?.value,
        stage: stage,
        company: company,
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(Failure.unknown(
        message: 'Search failed: ${e.toString()}',
        error: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getRecommendedProducts({
    required String stage,
  }) async {
    try {
      final models = await dataSource.getRecommendedProducts(stage: stage);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(Failure.unknown(
        message: 'Failed to load recommendations: ${e.toString()}',
        error: e,
      ));
    }
  }
}
