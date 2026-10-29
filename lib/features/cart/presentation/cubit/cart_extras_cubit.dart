import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/usecases/usecase.dart';
import 'package:food_user_app/features/cart/domain/entities/cart_extra_item.dart';
import 'package:food_user_app/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:food_user_app/features/cart/domain/usecases/get_cart_extras_usecase.dart';
import 'cart_extras_state.dart';

class CartExtrasCubit extends Cubit<CartExtrasState> {
  final GetCartExtrasUseCase _getCartExtrasUseCase;
  final AddToCartUseCase _addToCartUseCase;

  CartExtrasCubit({
    required GetCartExtrasUseCase getCartExtrasUseCase,
    required AddToCartUseCase addToCartUseCase,
  })  : _getCartExtrasUseCase = getCartExtrasUseCase,
        _addToCartUseCase = addToCartUseCase,
        super(const CartExtrasState());

  Future<void> loadExtras() async {
    emit(state.copyWith(isLoading: true));
    final result = await _getCartExtrasUseCase(NoParams());
    if (isClosed) return;
    result.fold(
      (failure) {
        // Silently hide section on failure without breaking the cart screen
        emit(state.copyWith(
          isLoading: false,
          items: const [],
          errorMessage: failure.message,
        ));
      },
      (items) {
        emit(state.copyWith(
          isLoading: false,
          items: items,
          errorMessage: null,
        ));
      },
    );
  }

  Future<bool> addExtra({
    required CartExtraItem item,
    required void Function() onSuccess,
    required void Function(String message) onError,
  }) async {
    if (state.addingProductId != null) {
      // Prevent duplicate parallel requests
      return false;
    }

    emit(state.copyWith(addingProductId: item.id));

    final result = await _addToCartUseCase(
      AddToCartParams(
        productId: item.id.toString(),
        quantity: 1,
        optionValueIds: const [],
      ),
    );

    if (isClosed) return false;

    return result.fold(
      (failure) {
        emit(state.copyWith(clearAdding: true));
        onError(failure.message);
        return false;
      },
      (_) {
        emit(state.copyWith(clearAdding: true));
        onSuccess();
        loadExtras();
        return true;
      },
    );
  }
}
