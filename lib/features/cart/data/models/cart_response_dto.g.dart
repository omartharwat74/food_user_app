// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartResponseDto _$CartResponseDtoFromJson(Map<String, dynamic> json) =>
    CartResponseDto(
      status: const IntBoolConverter().fromJson(json['status']),
      message: json['message'] as String?,
      data: CartSummaryDto.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CartResponseDtoToJson(CartResponseDto instance) =>
    <String, dynamic>{
      'status': const IntBoolConverter().toJson(instance.status),
      'message': instance.message,
      'data': instance.data,
    };

CartSummaryDto _$CartSummaryDtoFromJson(Map<String, dynamic> json) =>
    CartSummaryDto(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      storeId: (json['store_id'] as num?)?.toInt(),
      subtotal: json['subtotal'] as num?,
      deliveryFee: json['delivery_fee'] as num?,
      discount: json['discount'] as num?,
      tax: json['tax'] as num?,
      total: json['total'] as num?,
      couponCode: json['coupon_code'] as String?,
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => CartItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      store: json['store'] == null
          ? null
          : CartStoreBriefDto.fromJson(json['store'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CartSummaryDtoToJson(CartSummaryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'store_id': instance.storeId,
      'subtotal': instance.subtotal,
      'delivery_fee': instance.deliveryFee,
      'discount': instance.discount,
      'tax': instance.tax,
      'total': instance.total,
      'coupon_code': instance.couponCode,
      'items': instance.items,
      'store': instance.store,
    };

CartItemDto _$CartItemDtoFromJson(Map<String, dynamic> json) => CartItemDto(
  id: (json['id'] as num?)?.toInt(),
  productId: (json['product_id'] as num?)?.toInt(),
  quantity: (json['quantity'] as num?)?.toInt(),
  price: json['price'] as num?,
  total: json['total'] as num?,
  name: json['name'] as String?,
  image: json['image'] as String?,
  optionValueIds:
      (json['option_value_ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      [],
);

Map<String, dynamic> _$CartItemDtoToJson(CartItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'quantity': instance.quantity,
      'price': instance.price,
      'total': instance.total,
      'name': instance.name,
      'image': instance.image,
      'option_value_ids': instance.optionValueIds,
    };

CartStoreBriefDto _$CartStoreBriefDtoFromJson(Map<String, dynamic> json) =>
    CartStoreBriefDto(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      image: json['image'] as String?,
      deliveryFee: json['delivery_fee'] as num?,
      minOrderAmount: json['min_order_amount'] as num?,
    );

Map<String, dynamic> _$CartStoreBriefDtoToJson(CartStoreBriefDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'delivery_fee': instance.deliveryFee,
      'min_order_amount': instance.minOrderAmount,
    };
