import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:food_user_app/features/order/domain/entities/order.dart';

part 'order_dto.freezed.dart';
part 'order_dto.g.dart';

@freezed
abstract class OrderDto with _$OrderDto {
  const factory OrderDto({
    required String id,
    required String customerId,
    required String branchId,
    required String status,
    required double subtotal,
    required double deliveryFee,
    required double total,
    required double discount,
    required List<OrderItemDto> items,
    required DateTime createdAt,
    String? restaurantName,
    String? deliveryAddress,
    double? deliveryLat,
    double? deliveryLng,
    String? paymentMethod,
    int? estimatedMinutes,
    String? driverName,
    String? driverPhone,
    double? driverLat,
    double? driverLng,
  }) = _OrderDto;

  factory OrderDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDtoFromJson(json);
}

@freezed
abstract class OrderItemDto with _$OrderItemDto {
  const factory OrderItemDto({
    required String menuItemId,
    required String itemName,
    required int quantity,
    required double unitPrice,
    required double totalPrice,
    List<dynamic>? selectedModifiers,
    String? notes,
  }) = _OrderItemDto;

  factory OrderItemDto.fromJson(Map<String, dynamic> json) =>
      _$OrderItemDtoFromJson(json);
}

extension OrderDtoMapper on OrderDto {
  Order toEntity() {
    return Order(
      id: id,
      customerId: customerId,
      branchId: branchId,
      status: status,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      total: total,
      discount: discount,
      items: items.map((e) => e.toEntity()).toList(),
      createdAt: createdAt,
      restaurantName: restaurantName ?? '',
      deliveryAddress: deliveryAddress ?? '',
      deliveryLat: deliveryLat,
      deliveryLng: deliveryLng,
      paymentMethod: paymentMethod ?? 'CASH',
      estimatedMinutes: estimatedMinutes,
      driverName: driverName,
      driverPhone: driverPhone,
      driverLat: driverLat,
      driverLng: driverLng,
    );
  }
}

extension OrderItemDtoMapper on OrderItemDto {
  OrderItem toEntity() {
    return OrderItem(
      menuItemId: menuItemId,
      itemName: itemName,
      quantity: quantity,
      unitPrice: unitPrice,
      totalPrice: totalPrice,
      selectedModifiers: selectedModifiers,
      notes: notes,
    );
  }
}
