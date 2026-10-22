import 'package:equatable/equatable.dart';
import 'package:food_user_app/features/order/domain/entities/order.dart';

enum OrderDetailScreenStatus {
  initial,
  loading,
  loaded,
  cancelling,
  cancelSuccess,
  error,
}

class OrderDetailState extends Equatable {
  final OrderDetailScreenStatus status;
  final Order? order;
  final String? errorMessage;
  final String? successMessage;

  const OrderDetailState({
    this.status = OrderDetailScreenStatus.initial,
    this.order,
    this.errorMessage,
    this.successMessage,
  });

  OrderDetailState copyWith({
    OrderDetailScreenStatus? status,
    Order? order,
    String? errorMessage,
    String? successMessage,
  }) {
    return OrderDetailState(
      status: status ?? this.status,
      order: order ?? this.order,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [status, order, errorMessage, successMessage];
}
