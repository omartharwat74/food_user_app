import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:food_user_app/features/cart/domain/entities/cart.dart';
import 'cart_item_dto.dart';

part 'cart_dto.freezed.dart';
part 'cart_dto.g.dart';

@freezed
abstract class CartDto with _$CartDto {
  const factory CartDto({
    required String id,
    String? restaurantId,
    String? restaurantName,
    required List<CartItemDto> items,
    required double subtotal,
    required double deliveryFee,
    required double discount,
    required double total,
  }) = _CartDto;

  factory CartDto.fromJson(Map<String, dynamic> json) =>
      _$CartDtoFromJson(json);
}

extension CartDtoMapper on CartDto {
  Cart toEntity() {
    return Cart(
      id: id,
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      items: items.map((item) => item.toEntity()).toList(),
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      tax: 0.0,
      discount: discount,
      total: total,
    );
  }
}
