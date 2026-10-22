import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/checkout/domain/usecases/place_order_usecase.dart';
import 'package:food_user_app/features/order/data/models/place_order_request.dart';
import 'package:food_user_app/features/payment/presentation/cubit/checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final PlaceOrderUseCase placeOrderUseCase;

  CheckoutCubit({required this.placeOrderUseCase})
    : super(const CheckoutState.initial());

  Future<void> checkout({
    String paymentMethod = 'cash',
    int? addressId,
    bool selfPickup = false,
    String? couponCode,
  }) async {
    emit(const CheckoutState.loading());
    final request = PlaceOrderRequest(
      paymentMethod: paymentMethod,
      addressId: addressId,
      selfPickup: selfPickup,
      couponCode: couponCode,
    );
    final result = await placeOrderUseCase(request);
    if (isClosed) return;
    result.fold(
      (failure) => emit(CheckoutState.error(failure.message)),
      (order) => emit(CheckoutState.success(order)),
    );
  }
}
