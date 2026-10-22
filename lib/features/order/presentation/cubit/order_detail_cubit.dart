import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/di/injection_container.dart' as di;
import 'package:food_user_app/features/order/domain/entities/order.dart';
import 'package:food_user_app/features/order/domain/usecases/cancel_order_usecase.dart';
import 'package:food_user_app/features/order/domain/usecases/get_order_detail_usecase.dart';
import 'package:food_user_app/features/order/presentation/cubit/order_history_cubit.dart';
import 'order_detail_state.dart';

class OrderDetailCubit extends Cubit<OrderDetailState> {
  final GetOrderDetailUseCase _getOrderDetailUseCase;
  final CancelOrderUseCase _cancelOrderUseCase;

  OrderDetailCubit({
    required GetOrderDetailUseCase getOrderDetailUseCase,
    required CancelOrderUseCase cancelOrderUseCase,
  })  : _getOrderDetailUseCase = getOrderDetailUseCase,
        _cancelOrderUseCase = cancelOrderUseCase,
        super(const OrderDetailState());

  Future<void> loadOrderDetails(String orderId, {Order? initialOrder}) async {
    if (initialOrder != null) {
      emit(state.copyWith(
        status: OrderDetailScreenStatus.loaded,
        order: initialOrder,
        errorMessage: null,
      ));
    } else if (state.order == null) {
      emit(state.copyWith(
        status: OrderDetailScreenStatus.loading,
        errorMessage: null,
      ));
    }

    final result = await _getOrderDetailUseCase(orderId);

    result.fold(
      (failure) {
        if (state.order == null) {
          emit(state.copyWith(
            status: OrderDetailScreenStatus.error,
            errorMessage: failure.message,
          ));
        }
      },
      (order) {
        emit(state.copyWith(
          status: OrderDetailScreenStatus.loaded,
          order: order,
          errorMessage: null,
        ));
      },
    );
  }

  Future<void> cancelOrder({
    required String orderId,
    required String reason,
  }) async {
    emit(state.copyWith(
      status: OrderDetailScreenStatus.cancelling,
      errorMessage: null,
      successMessage: null,
    ));

    final result = await _cancelOrderUseCase(
      CancelOrderParams(orderId: orderId, reason: reason),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: OrderDetailScreenStatus.error,
          errorMessage: failure.message,
        ));
        // Refresh order details from server because state might have changed (e.g. store accepted)
        loadOrderDetails(orderId);
      },
      (cancelledOrder) {
        emit(state.copyWith(
          status: OrderDetailScreenStatus.cancelSuccess,
          order: cancelledOrder,
          successMessage: cancelledOrder.message ?? 'تم إلغاء الطلب بنجاح',
        ));
        try {
          if (di.sl.isRegistered<OrderHistoryCubit>()) {
            di.sl<OrderHistoryCubit>().updateOrder(cancelledOrder);
          }
        } catch (_) {}
      },
    );
  }
}
