import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/market_repository.dart';

class GetMarketProductsParams extends Equatable {
  final String marketId;
  final String categoryId;
  final String subCategoryId;

  const GetMarketProductsParams({
    required this.marketId,
    required this.categoryId,
    required this.subCategoryId,
  });

  @override
  List<Object?> get props => [marketId, categoryId, subCategoryId];
}

class GetMarketProductsUseCase
    implements UseCase<List<Product>, GetMarketProductsParams> {
  final MarketRepository repository;

  GetMarketProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(GetMarketProductsParams params) {
    return repository.getMarketProducts(
      marketId: params.marketId,
      categoryId: params.categoryId,
      subCategoryId: params.subCategoryId,
    );
  }
}
