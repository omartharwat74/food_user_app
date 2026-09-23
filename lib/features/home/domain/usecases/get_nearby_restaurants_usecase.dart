import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:food_user_app/features/restaurant/domain/entities/page_response_restaurant.dart';
import 'package:food_user_app/features/restaurant/domain/repositories/restaurant_repository.dart';

class GetRestaurantsParams extends Equatable {
  final int page;
  final int size;
  final String? categoryId;

  const GetRestaurantsParams({this.page = 0, this.size = 20, this.categoryId});

  @override
  List<Object?> get props => [page, size, categoryId];
}

class GetNearbyRestaurantsUseCase
    extends UseCase<PageResponseRestaurant, GetRestaurantsParams> {
  final RestaurantRepository repository;

  GetNearbyRestaurantsUseCase(this.repository);

  @override
  Future<Either<Failure, PageResponseRestaurant>> call(
    GetRestaurantsParams params,
  ) async {
    return await repository.getRestaurants(
      page: params.page,
      size: params.size,
      categoryId: params.categoryId,
    );
  }
}
