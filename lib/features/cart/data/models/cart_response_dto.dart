import 'package:food_user_app/features/cart/domain/entities/cart.dart';
import 'package:food_user_app/features/cart/domain/entities/cart_item.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:food_user_app/core/utils/bool_converter.dart';

part 'cart_response_dto.g.dart';

@JsonSerializable()
class CartResponseDto {
  @IntBoolConverter()
  final bool status;
  final String? message;
  final CartSummaryDto data;

  CartResponseDto({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CartResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CartResponseDtoFromJson(json);
}

@JsonSerializable()
class CartSummaryDto {
  final int? id;
  @JsonKey(name: 'user_id')
  final int? userId;
  @JsonKey(name: 'store_id')
  final int? storeId;
  final num? subtotal;
  @JsonKey(name: 'delivery_fee')
  final num? deliveryFee;
  final num? discount;
  final num? tax;
  final num? total;
  @JsonKey(name: 'coupon_code')
  final String? couponCode;
  
  @JsonKey(defaultValue: [])
  final List<CartItemDto>? items;
  
  final CartStoreBriefDto? store;

  CartSummaryDto({
    required this.id,
    required this.userId,
    this.storeId,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.tax,
    required this.total,
    this.couponCode,
    required this.items,
    this.store,
  });

  factory CartSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$CartSummaryDtoFromJson(json);
}

@JsonSerializable()
class CartItemDto {
  final int? id;
  @JsonKey(name: 'product_id')
  final int? productId;
  final int? quantity;
  final num? price;
  final num? total;
  final String? name;
  final String? image;
  
  @JsonKey(name: 'option_value_ids', defaultValue: [])
  final List<int>? optionValueIds;

  CartItemDto({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.total,
    required this.name,
    this.image,
    required this.optionValueIds,
  });

  factory CartItemDto.fromJson(Map<String, dynamic> json) =>
      _$CartItemDtoFromJson(json);
}

@JsonSerializable()
class CartStoreBriefDto {
  final int? id;
  final String? name;
  final String? image;
  @JsonKey(name: 'delivery_fee')
  final num? deliveryFee;
  @JsonKey(name: 'min_order_amount')
  final num? minOrderAmount;

  CartStoreBriefDto({
    required this.id,
    required this.name,
    this.image,
    this.deliveryFee,
    this.minOrderAmount,
  });

  factory CartStoreBriefDto.fromJson(Map<String, dynamic> json) =>
      _$CartStoreBriefDtoFromJson(json);
}


extension CartResponseDtoMapper on CartResponseDto {
  Cart toEntity() {
    return Cart(
      id: data.id?.toString() ?? '',
      restaurantId: data.storeId?.toString() ?? data.store?.id?.toString() ?? '',
      restaurantName: data.store?.name ?? '',
      items: (data.items ?? []).map((item) => CartItem(
        id: item.id?.toString() ?? '',
        menuItemId: item.productId?.toString() ?? '',
        name: item.name ?? '',
        price: (item.price ?? 0).toInt(),
        unitPrice: (item.price ?? 0).toDouble(),
        totalPrice: (item.total ?? 0).toDouble(),
        quantity: item.quantity ?? 1,
        selectedModifiers: (item.optionValueIds ?? []).map((id) => <String, dynamic>{'option_id': id}).toList(),
        notes: '',
      )).toList(),
      subtotal: (data.subtotal ?? 0).toDouble(),
      deliveryFee: (data.deliveryFee ?? 0).toDouble(),
      discount: (data.discount ?? 0).toDouble(),
      total: (data.total ?? 0).toDouble(),
    );
  }
}
