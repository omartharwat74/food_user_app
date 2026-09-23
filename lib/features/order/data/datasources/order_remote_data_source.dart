import 'package:food_user_app/core/network/dio_client.dart';
import 'package:food_user_app/core/constants/api_endpoints.dart';
import 'package:food_user_app/features/order/data/models/order_dto.dart';
import 'package:food_user_app/features/order/data/models/order_tracking_dto.dart';
import 'package:food_user_app/features/order/data/models/place_order_request.dart';

abstract class OrderRemoteDataSource {
  Future<OrderDto> placeOrder(PlaceOrderRequest request);
  Future<List<OrderDto>> getOrderHistory();
  Future<OrderDto> getOrderDetails(String orderId);
  Future<OrderTrackingDto> trackOrder(String orderId);
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
    return OrderDto.fromJson(response.data);
  }

  @override
  Future<List<OrderDto>> getOrderHistory() async {
    final response = await _dioClient.dio.get(ApiEndpoints.orders);
    final data = response.data;
    if (data is Map<String, dynamic> && data['content'] != null) {
      return (data['content'] as List)
          .map((json) => OrderDto.fromJson(json))
          .toList();
    } else if (data is List) {
      return data.map((json) => OrderDto.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<OrderDto> getOrderDetails(String orderId) async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.orderDetail(orderId),
    );
    return OrderDto.fromJson(response.data);
  }

  @override
  Future<OrderTrackingDto> trackOrder(String orderId) async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.orderTracking(orderId),
    );
    return OrderTrackingDto.fromJson(response.data);
  }
}
