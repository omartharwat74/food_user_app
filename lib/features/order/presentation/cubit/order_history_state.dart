import 'package:equatable/equatable.dart';
import 'package:food_user_app/features/order/domain/entities/order.dart';

enum OrderHistoryStatus { initial, loading, loaded, error }

class OrderHistoryState extends Equatable {
  final OrderHistoryStatus status;
  final List<Order> orders;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final String? errorMessage;

  const OrderHistoryState({
    this.status = OrderHistoryStatus.initial,
    this.orders = const [],
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 10,
    this.total = 0,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  OrderHistoryState copyWith({
    OrderHistoryStatus? status,
    List<Order>? orders,
    int? currentPage,
    int? lastPage,
    int? perPage,
    int? total,
    bool? hasReachedMax,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return OrderHistoryState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      perPage: perPage ?? this.perPage,
      total: total ?? this.total,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        orders,
        currentPage,
        lastPage,
        perPage,
        total,
        hasReachedMax,
        isLoadingMore,
        errorMessage,
      ];
}
