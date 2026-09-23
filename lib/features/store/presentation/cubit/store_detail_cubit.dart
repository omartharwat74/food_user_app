import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_item.dart';
import 'package:food_user_app/features/restaurant/domain/repositories/menu_repository.dart';
import 'package:food_user_app/features/restaurant/domain/repositories/restaurant_repository.dart';
import 'store_detail_state.dart';

class StoreDetailCubit extends Cubit<StoreDetailState> {
  final RestaurantRepository _restaurantRepository;
  final MenuRepository _menuRepository;

  StoreDetailCubit({
    required RestaurantRepository restaurantRepository,
    required MenuRepository menuRepository,
  }) : _restaurantRepository = restaurantRepository,
       _menuRepository = menuRepository,
       super(const StoreDetailState.initial());

  Future<void> loadStoreDetails(String storeId) async {
    emit(const StoreDetailState.loading());
    try {
      final restaurantResult = await _restaurantRepository.getRestaurantDetail(
        storeId,
      );
      if (isClosed) return;
      final menuResult = await _menuRepository.getRestaurantMenu(storeId);
      if (isClosed) return;

      restaurantResult.fold(
        (failure) => emit(StoreDetailState.error(failure.message)),
        (restaurant) {
          menuResult.fold(
            (failure) => emit(StoreDetailState.error(failure.message)),
            (categories) {
              final List<MenuItem> featuredProducts = categories
                  .expand((cat) => cat.items)
                  .take(10)
                  .toList();

              emit(
                StoreDetailState.loaded(
                  store: restaurant,
                  categories: categories,
                  featuredProducts: featuredProducts,
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      if (isClosed) return;
      emit(StoreDetailState.error(e.toString()));
    }
  }
}
