import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/restaurant/domain/entities/restaurant.dart';
import 'package:food_user_app/features/restaurant/domain/repositories/restaurant_repository.dart';
import 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final RestaurantRepository restaurantRepository;

  FavoriteCubit({required this.restaurantRepository})
    : super(const FavoriteState.initial());

  Future<void> loadFavorites() async {
    emit(const FavoriteState.loading());
    final result = await restaurantRepository.getFavorites();
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        FavoriteState.error(
          favoriteIds: const {},
          favoriteRestaurants: const [],
          message: failure.message,
        ),
      ),
      (restaurants) {
        final ids = restaurants.map((r) => r.id).toSet();
        emit(
          FavoriteState.loaded(
            favoriteIds: ids,
            favoriteRestaurants: restaurants,
          ),
        );
      },
    );
  }

  Future<void> toggleFavorite(String restaurantId) async {
    final currentIds = state.maybeWhen(
      loaded: (ids, restaurants) => ids,
      error: (ids, restaurants, message) => ids,
      orElse: () => const <String>{},
    );
    final currentRestaurants = state.maybeWhen(
      loaded: (ids, list) => list,
      error: (ids, list, message) => list,
      orElse: () => const <Restaurant>[],
    );

    final isFav = currentIds.contains(restaurantId);
    final updatedIds = Set<String>.from(currentIds);
    final updatedRestaurants = List<Restaurant>.from(currentRestaurants);

    if (isFav) {
      updatedIds.remove(restaurantId);
      updatedRestaurants.removeWhere((r) => r.id == restaurantId);
    } else {
      updatedIds.add(restaurantId);
    }
    emit(
      FavoriteState.loaded(
        favoriteIds: updatedIds,
        favoriteRestaurants: updatedRestaurants,
      ),
    );

    final result = await restaurantRepository.toggleFavorite(restaurantId);

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(
          FavoriteState.error(
            favoriteIds: currentIds,
            favoriteRestaurants: currentRestaurants,
            message: failure.message,
          ),
        );
      },
      (_) {
        emit(
          FavoriteState.loaded(
            favoriteIds: updatedIds,
            favoriteRestaurants: updatedRestaurants,
          ),
        );
      },
    );
  }
}
