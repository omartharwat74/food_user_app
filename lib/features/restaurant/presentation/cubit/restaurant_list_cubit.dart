import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/restaurant/domain/entities/restaurant.dart';
import 'package:food_user_app/features/home/domain/usecases/get_nearby_restaurants_usecase.dart';
import 'restaurant_list_state.dart';

class RestaurantListCubit extends Cubit<RestaurantListState> {
  final GetNearbyRestaurantsUseCase getNearbyRestaurantsUseCase;
  List<Restaurant> _restaurants = [];
  bool _hasMore = true;
  int _currentPage = 0;

  RestaurantListCubit({required this.getNearbyRestaurantsUseCase})
    : super(const RestaurantListState.initial());

  Future<void> getRestaurants({
    int page = 0,
    int size = 20,
    String? categoryId,
  }) async {
    emit(const RestaurantListState.loading());
    final result = await getNearbyRestaurantsUseCase(
      GetRestaurantsParams(page: page, size: size, categoryId: categoryId),
    );
    if (isClosed) return;
    result.fold((failure) => emit(RestaurantListState.error(failure.message)), (
      pageResponse,
    ) {
      _restaurants = pageResponse.content;
      _hasMore = !pageResponse.last;
      _currentPage = pageResponse.page;
      emit(
        RestaurantListState.loaded(
          restaurants: _restaurants,
          hasMore: _hasMore,
          currentPage: _currentPage,
        ),
      );
    });
  }

  Future<void> loadMore({int size = 20, String? categoryId}) async {
    if (!_hasMore) return;
    final nextPage = _currentPage + 1;
    final result = await getNearbyRestaurantsUseCase(
      GetRestaurantsParams(page: nextPage, size: size, categoryId: categoryId),
    );
    if (isClosed) return;
    result.fold((failure) => emit(RestaurantListState.error(failure.message)), (
      pageResponse,
    ) {
      _restaurants = [..._restaurants, ...pageResponse.content];
      _hasMore = !pageResponse.last;
      _currentPage = pageResponse.page;
      emit(
        RestaurantListState.loaded(
          restaurants: _restaurants,
          hasMore: _hasMore,
          currentPage: _currentPage,
        ),
      );
    });
  }
}
