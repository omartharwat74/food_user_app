import 'package:food_user_app/core/network/dio_client.dart';
import 'package:food_user_app/core/constants/api_endpoints.dart';
import 'package:food_user_app/core/errors/exceptions.dart';
import 'package:food_user_app/features/order/data/models/order_dto.dart';
import 'package:food_user_app/features/order/data/models/order_tracking_dto.dart';
import 'package:food_user_app/features/order/data/models/orders_paginated_dto.dart';
import 'package:food_user_app/features/order/data/models/place_order_request.dart';

abstract class OrderRemoteDataSource {
  Future<OrderDto> placeOrder(PlaceOrderRequest request);
  Future<OrdersPaginatedDto> getOrderHistory({int perPage = 10, int page = 1});
  Future<OrderDto> getOrderDetails(String orderId);
  Future<OrderTrackingDto> trackOrder(String orderId);
  Future<OrderDto> cancelOrder({
    required String orderId,
    required String reason,
  });
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final DioClient _dioClient;

  OrderRemoteDataSourceImpl(this._dioClient);

  @override
  Future<OrderDto> placeOrder(PlaceOrderRequest request) async {
    final response = await _dioClient.dio.post(
      ApiEndpoints.orders,
      data: request.toJson(),
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final msg = data['msg']?.toString();
      final orderData = data['data'];
      if (orderData is Map<String, dynamic>) {
        return OrderDto.fromJson(orderData, message: msg);
      }
      return OrderDto.fromJson(data, message: msg);
    }
    throw const ServerException('Invalid response format');
  }

  @override
  Future<OrdersPaginatedDto> getOrderHistory({
    int perPage = 10,
    int page = 1,
  }) async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.orders,
      queryParameters: {
        'per_page': perPage,
        'page': page,
      },
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return OrdersPaginatedDto.fromJson(data);
    }
    throw const ServerException('Invalid order history response format');
  }

  @override
  Future<OrderDto> getOrderDetails(String orderId) async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.orderDetail(orderId),
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final msg = data['msg']?.toString();
      final orderData = data['data'];
      if (orderData is Map<String, dynamic>) {
        return OrderDto.fromJson(orderData, message: msg);
      }
      return OrderDto.fromJson(data, message: msg);
    }
    throw const ServerException('Invalid order detail response format');
  }

  @override
  Future<OrderTrackingDto> trackOrder(String orderId) async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.orderTracking(orderId),
    );
    return OrderTrackingDto.fromJson(response.data);
  }

  @override
  Future<OrderDto> cancelOrder({
    required String orderId,
    required String reason,
  }) async {
    final response = await _dioClient.dio.post(
      ApiEndpoints.cancelOrder(orderId),
      data: {'reason': reason},
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final msg = data['msg']?.toString();
      final orderData = data['data'];
      if (orderData is Map<String, dynamic>) {
        return OrderDto.fromJson(orderData, message: msg);
      }
      return OrderDto.fromJson(data, message: msg);
    }
    throw const ServerException('Invalid cancel response format');
  }
}
