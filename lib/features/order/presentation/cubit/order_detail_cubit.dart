import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/di/injection_container.dart' as di;
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/features/order/domain/entities/order.dart';
import 'package:food_user_app/features/order/domain/usecases/cancel_order_usecase.dart';
import 'package:food_user_app/features/order/domain/usecases/get_order_detail_usecase.dart';
import 'package:food_user_app/features/order/domain/usecases/rate_order_usecase.dart';
import 'package:food_user_app/features/order/presentation/cubit/order_history_cubit.dart';
import 'order_detail_state.dart';

class OrderDetailCubit extends Cubit<OrderDetailState> {
  final GetOrderDetailUseCase _getOrderDetailUseCase;
  final CancelOrderUseCase _cancelOrderUseCase;
  final RateOrderUseCase? _rateOrderUseCase;

  OrderDetailCubit({
    required GetOrderDetailUseCase getOrderDetailUseCase,
    required CancelOrderUseCase cancelOrderUseCase,
    RateOrderUseCase? rateOrderUseCase,
  })  : _getOrderDetailUseCase = getOrderDetailUseCase,
        _cancelOrderUseCase = cancelOrderUseCase,
        _rateOrderUseCase = rateOrderUseCase,
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

  Future<Either<Failure, void>> submitRating(RateOrderParams params) async {
    final useCase = _rateOrderUseCase ?? di.sl<RateOrderUseCase>();
    final result = await useCase(params);
    result.fold(
      (failure) {
        // Refresh state from server on failure (e.g. 422)
        if (state.order != null) {
          loadOrderDetails(state.order!.id.toString());
        }
      },
      (_) {
        // Locally update is_reviewed and courier rating without requiring manual reload
        if (state.order != null) {
          var updatedOrder = state.order!.copyWith(isReviewed: true);

          if (params.deliveryRating != null && updatedOrder.delivery != null) {
            final currentDelivery = updatedOrder.delivery!;
            final currentRating = currentDelivery.rating;
            final currentCount = currentDelivery.ratingCount;

            final double newRating;
            final int newCount;
            if (currentRating != null && currentRating > 0 && currentCount > 0) {
              newCount = currentCount + 1;
              newRating = double.parse(
                (((currentRating * currentCount) + params.deliveryRating!) /
                        newCount)
                    .toStringAsFixed(1),
              );
            } else if (currentRating != null && currentRating > 0) {
              newCount = 2;
              newRating = double.parse(
                (((currentRating * 1) + params.deliveryRating!) / 2)
                    .toStringAsFixed(1),
              );
            } else {
              newCount = 1;
              newRating = params.deliveryRating!.toDouble();
            }

            final updatedDelivery = currentDelivery.copyWith(
              rating: newRating,
              ratingCount: newCount,
            );
            updatedOrder = updatedOrder.copyWith(delivery: updatedDelivery);
          }

          emit(state.copyWith(order: updatedOrder));
          try {
            if (di.sl.isRegistered<OrderHistoryCubit>()) {
              di.sl<OrderHistoryCubit>().updateOrder(updatedOrder);
            }
          } catch (_) {}

          // Also silently refresh order details from server in the background
          _refreshOrderDetailsInBackground(state.order!.id.toString());
        }
      },
    );
    return result;
  }

  Future<void> _refreshOrderDetailsInBackground(String orderId) async {
    final result = await _getOrderDetailUseCase(orderId);
    if (isClosed) return;
    result.fold(
      (_) {},
      (order) {
        if (isClosed) return;
        final currentDelivery = state.order?.delivery;
        final serverDelivery = order.delivery;
        OrderDelivery? mergedDelivery = serverDelivery;

        if (serverDelivery != null && currentDelivery != null) {
          if ((serverDelivery.rating == null || serverDelivery.rating == 0) &&
              (currentDelivery.rating != null && currentDelivery.rating! > 0)) {
            mergedDelivery = serverDelivery.copyWith(
              rating: currentDelivery.rating,
              ratingCount: currentDelivery.ratingCount,
            );
          }
        }

        emit(state.copyWith(
          order: order.copyWith(
            isReviewed: true,
            delivery: mergedDelivery,
          ),
        ));
      },
    );
  }
}
