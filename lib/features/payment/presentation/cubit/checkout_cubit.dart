import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/usecases/usecase.dart';
import 'package:food_user_app/features/checkout/domain/usecases/place_order_usecase.dart';
import 'package:food_user_app/features/payment/presentation/cubit/checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final PlaceOrderUseCase placeOrderUseCase;

  CheckoutCubit({required this.placeOrderUseCase})
    : super(const CheckoutState.initial());

  Future<void> checkout() async {
    emit(const CheckoutState.loading());
    final result = await placeOrderUseCase(NoParams());
    if (isClosed) return;
    result.fold(
      (failure) => emit(CheckoutState.error(failure.message)),
      (order) => emit(CheckoutState.success(order)),
    );
  }
}
