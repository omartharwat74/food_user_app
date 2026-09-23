import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/page_response_market.dart';
import '../repositories/market_repository.dart';

class GetMarketsParams extends Equatable {
  final String? search;
  final bool? pickupAvailable;
  final bool? isAvailable;
  final int page;
  final int size;

  const GetMarketsParams({
    this.search,
    this.pickupAvailable,
    this.isAvailable,
    this.page = 0,
    this.size = 20,
  });

  @override
  List<Object?> get props => [search, pickupAvailable, isAvailable, page, size];
}

class GetMarketsUseCase
    implements UseCase<PageResponseMarket, GetMarketsParams> {
  final MarketRepository repository;

  GetMarketsUseCase(this.repository);

  @override
  Future<Either<Failure, PageResponseMarket>> call(GetMarketsParams params) {
    return repository.getMarkets(
      search: params.search,
      pickupAvailable: params.pickupAvailable,
      isAvailable: params.isAvailable,
      page: params.page,
      size: params.size,
    );
  }
}
