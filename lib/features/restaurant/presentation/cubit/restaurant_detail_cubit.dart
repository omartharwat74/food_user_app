import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/restaurant/domain/entities/branch.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_category.dart';
import 'package:food_user_app/features/restaurant/domain/entities/offer.dart';
import 'package:food_user_app/features/restaurant/domain/repositories/restaurant_repository.dart';
import 'package:food_user_app/features/restaurant/domain/repositories/menu_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'restaurant_detail_state.dart';

class RestaurantDetailCubit extends Cubit<RestaurantDetailState> {
  final RestaurantRepository restaurantRepository;
  final MenuRepository menuRepository;

  RestaurantDetailCubit({
    required this.restaurantRepository,
    required this.menuRepository,
  }) : super(const RestaurantDetailState.initial());

  /// Fetches store details from the legacy endpoint (used by older screens).
  Future<void> getRestaurantDetail(String id) async {
    emit(const RestaurantDetailState.loading());
    final detailResult = await restaurantRepository.getRestaurantDetail(id);
    if (isClosed) return;

    detailResult.fold(
      (failure) => emit(RestaurantDetailState.error(failure.message)),
      (restaurant) async {
        final branchesResult = await restaurantRepository.getBranches(
          restaurant.id,
        );
        if (isClosed) return;
        final offersResult = await restaurantRepository.getOffers(
          restaurant.id,
        );
        if (isClosed) return;

        final branches = branchesResult.fold((_) => <Branch>[], (list) => list);
        final offers = offersResult.fold((_) => <Offer>[], (list) => list);

        emit(
          RestaurantDetailState.loaded(
            restaurant: restaurant,
            branches: branches,
            offers: offers,
          ),
        );
      },
    );
  }

  /// Fetches store details AND menu concurrently using the new
  /// `/api/v1/stores/show` and `/api/v1/stores/products/all` endpoints.
  Future<void> fetchStoreData(String storeId) async {
    emit(const RestaurantDetailState.loading());

    final results = await Future.wait([
      restaurantRepository.getStoreDetails(storeId),
      menuRepository.getStoreMenu(storeId),
    ]);
    if (isClosed) return;

    final storeResult = results[0] as Either<Failure, dynamic>;
    final menuResult = results[1] as Either<Failure, dynamic>;

    // If store details fail, surface the error
    storeResult.fold(
      (failure) => emit(RestaurantDetailState.error(failure.message)),
      (restaurant) {
        final menuCategories = menuResult.fold(
          (_) => <MenuCategory>[],
          (cats) => cats as List<MenuCategory>,
        );
        emit(
          RestaurantDetailState.loaded(
            restaurant: restaurant,
            menuCategories: menuCategories,
          ),
        );
      },
    );
  }
}
