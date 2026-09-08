import 'package:dartz/dartz.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/features/restaurant/domain/entities/branch.dart';
import 'package:food_user_app/features/restaurant/domain/entities/offer.dart';
import 'package:food_user_app/features/restaurant/domain/entities/page_response_restaurant.dart';
import 'package:food_user_app/features/restaurant/domain/entities/restaurant.dart';

abstract class RestaurantRepository {
  Future<Either<Failure, PageResponseRestaurant>> getRestaurants({
    int page = 0,
    int size = 20,
    String? categoryId,
  });

  Future<Either<Failure, Restaurant>> getRestaurantDetail(String id);

  /// Fetches full store data from `/api/v1/stores/show?id={storeId}`.
  Future<Either<Failure, Restaurant>> getStoreDetails(String storeId);

  Future<Either<Failure, List<Branch>>> getBranches(String restaurantId);

  Future<Either<Failure, List<Offer>>> getOffers(String restaurantId);

  Future<Either<Failure, List<Restaurant>>> getFavorites();

  Future<Either<Failure, Unit>> toggleFavorite(String id);
}
