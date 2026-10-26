import 'package:dartz/dartz.dart' hide Order;
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/features/order/data/models/place_order_request.dart';
import 'package:food_user_app/features/order/domain/entities/order.dart';
import 'package:food_user_app/features/order/domain/entities/order_tracking.dart';
import 'package:food_user_app/features/order/domain/entities/orders_paginated_data.dart';

abstract class OrderRepository {
  Future<Either<Failure, Order>> placeOrder(PlaceOrderRequest request);
  Future<Either<Failure, OrdersPaginatedData>> getOrderHistory({
    int perPage = 10,
    int page = 1,
  });
  Future<Either<Failure, Order>> getOrderDetails(String orderId);
  Future<Either<Failure, OrderTracking>> trackOrder(String orderId);
  Future<Either<Failure, Order>> cancelOrder({
    required String orderId,
    required String reason,
  });
  Future<Either<Failure, void>> submitReview({
    required int storeId,
    required int rating,
    String? comment,
    int? deliveryId,
    int? deliveryRating,
    String? deliveryComment,
  });
}
