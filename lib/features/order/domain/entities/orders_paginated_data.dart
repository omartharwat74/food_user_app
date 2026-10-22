import 'package:equatable/equatable.dart';
import 'package:food_user_app/features/order/domain/entities/order.dart';

class OrdersPaginatedData extends Equatable {
  final List<Order> items;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const OrdersPaginatedData({
    required this.items,
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 10,
    this.total = 0,
  });

  const OrdersPaginatedData.empty()
      : items = const [],
        currentPage = 1,
        lastPage = 1,
        perPage = 10,
        total = 0;

  OrdersPaginatedData copyWith({
    List<Order>? items,
    int? currentPage,
    int? lastPage,
    int? perPage,
    int? total,
  }) {
    return OrdersPaginatedData(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      perPage: perPage ?? this.perPage,
      total: total ?? this.total,
    );
  }

  @override
  List<Object?> get props => [items, currentPage, lastPage, perPage, total];
}
