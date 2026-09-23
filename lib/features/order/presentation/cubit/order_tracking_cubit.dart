import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/order/domain/usecases/get_order_tracking_usecase.dart';
import 'order_tracking_state.dart';

class OrderTrackingCubit extends Cubit<OrderTrackingState> {
  final GetOrderTrackingUseCase getOrderTrackingUseCase;
  Timer? _timer;

  OrderTrackingCubit({required this.getOrderTrackingUseCase})
    : super(const OrderTrackingState.initial());

  Future<void> startTracking(String orderId) async {
    emit(const OrderTrackingState.loading());
    await _fetchTracking(orderId);

    // Poll every 10 seconds for live tracking updates
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _fetchTracking(orderId);
    });
  }

  Future<void> _fetchTracking(String orderId) async {
    final result = await getOrderTrackingUseCase(orderId);
    if (isClosed) return;
    result.fold((failure) {
      emit(OrderTrackingState.error(failure.message));
    }, (tracking) => emit(OrderTrackingState.loaded(tracking)));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
