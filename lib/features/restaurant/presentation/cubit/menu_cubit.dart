import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/restaurant/domain/repositories/menu_repository.dart';
import 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final MenuRepository menuRepository;

  MenuCubit({required this.menuRepository}) : super(const MenuState.initial());

  Future<void> getRestaurantMenu(String restaurantId) async {
    emit(const MenuState.loading());
    final result = await menuRepository.getRestaurantMenu(restaurantId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(MenuState.error(failure.message)),
      (categories) => emit(MenuState.loaded(categories: categories)),
    );
  }

  Future<void> getBranchMenu(String branchId) async {
    emit(const MenuState.loading());
    final result = await menuRepository.getBranchMenu(branchId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(MenuState.error(failure.message)),
      (categories) => emit(MenuState.loaded(categories: categories)),
    );
  }

  Future<void> getItemModifiers(String itemId) async {
    emit(const MenuState.loading());
    final result = await menuRepository.getItemModifiers(itemId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(MenuState.error(failure.message)),
      (modifiers) => emit(MenuState.modifiersLoaded(modifiers: modifiers)),
    );
  }
}
