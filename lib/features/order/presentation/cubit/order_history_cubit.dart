import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/order/domain/entities/order.dart';
import 'package:food_user_app/features/order/domain/usecases/get_order_history_usecase.dart';
import 'order_history_state.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  final GetOrderHistoryUseCase _getOrderHistoryUseCase;

  OrderHistoryCubit(this._getOrderHistoryUseCase)
      : super(const OrderHistoryState());

  Future<void> loadOrders({int perPage = 10}) async {
    emit(state.copyWith(
      status: OrderHistoryStatus.loading,
      errorMessage: null,
    ));

    final result = await _getOrderHistoryUseCase(
      GetOrderHistoryParams(perPage: perPage, page: 1),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: OrderHistoryStatus.error,
          errorMessage: failure.message,
        ));
      },
      (data) {
        emit(state.copyWith(
          status: OrderHistoryStatus.loaded,
          orders: data.items,
          currentPage: data.currentPage,
          lastPage: data.lastPage,
          perPage: data.perPage,
          total: data.total,
          hasReachedMax: data.currentPage >= data.lastPage,
        ));
      },
    );
  }

  Future<void> refreshOrders({int perPage = 10}) async {
    final result = await _getOrderHistoryUseCase(
      GetOrderHistoryParams(perPage: perPage, page: 1),
    );

    result.fold(
      (failure) {
        // Keep existing orders on pull-to-refresh error
      },
      (data) {
        emit(state.copyWith(
          status: OrderHistoryStatus.loaded,
          orders: data.items,
          currentPage: data.currentPage,
          lastPage: data.lastPage,
          perPage: data.perPage,
          total: data.total,
          hasReachedMax: data.currentPage >= data.lastPage,
        ));
      },
    );
  }

  Future<void> loadMoreOrders({int perPage = 10}) async {
    if (state.isLoadingMore ||
        state.hasReachedMax ||
        state.status != OrderHistoryStatus.loaded) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.currentPage + 1;
    final result = await _getOrderHistoryUseCase(
      GetOrderHistoryParams(perPage: perPage, page: nextPage),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isLoadingMore: false));
      },
      (data) {
        final updatedOrders = List<Order>.from(state.orders)..addAll(data.items);
        emit(state.copyWith(
          orders: updatedOrders,
          currentPage: data.currentPage,
          lastPage: data.lastPage,
          total: data.total,
          hasReachedMax: data.currentPage >= data.lastPage,
          isLoadingMore: false,
        ));
      },
    );
  }

  void updateOrder(Order updatedOrder) {
    final currentList = List<Order>.from(state.orders);
    final index = currentList.indexWhere((o) => o.id == updatedOrder.id);
    if (index != -1) {
      currentList[index] = updatedOrder;
    } else {
      currentList.insert(0, updatedOrder);
    }
    emit(state.copyWith(orders: currentList));
  }
}
