import 'package:freezed_annotation/freezed_annotation.dart';

part 'place_order_request.freezed.dart';
part 'place_order_request.g.dart';

@freezed
abstract class PlaceOrderRequest with _$PlaceOrderRequest {
  const factory PlaceOrderRequest({
    required String branchId,
    required List<OrderItemRequest> items,
    String? addressId,
    String? deliveryAddress,
    double? deliveryLat,
    double? deliveryLng,
    String? paymentMethod,
    String? promoCode,
    String? specialInstructions,
  }) = _PlaceOrderRequest;

  factory PlaceOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$PlaceOrderRequestFromJson(json);
}

@freezed
abstract class OrderItemRequest with _$OrderItemRequest {
  const factory OrderItemRequest({
    required String menuItemId,
    required int quantity,
    List<dynamic>? selectedModifiers,
    String? notes,
  }) = _OrderItemRequest;

  factory OrderItemRequest.fromJson(Map<String, dynamic> json) =>
      _$OrderItemRequestFromJson(json);
}
