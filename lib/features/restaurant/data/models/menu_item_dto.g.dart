// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MenuItemDto _$MenuItemDtoFromJson(Map<String, dynamic> json) => _MenuItemDto(
  id: json['id'] == null ? '' : _idFromJson(json['id']),
  categoryId: _nullableIdFromJson(json['categoryId']),
  name: json['name'] as String?,
  description: json['description'] as String?,
  priceAfterDiscount: (json['price_after_discount'] as num?)?.toDouble(),
  price: (json['price'] as num?)?.toDouble(),
  basePrice: (json['base_price'] as num?)?.toDouble(),
  originalPrice: (json['originalPrice'] as num?)?.toDouble(),
  mainImage: json['main_image'] as String?,
  imageUrl: json['imageUrl'] as String?,
  available: const IntBoolConverter().fromJson(json['available']),
  offer: json['offer'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$MenuItemDtoToJson(_MenuItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categoryId': instance.categoryId,
      'name': instance.name,
      'description': instance.description,
      'price_after_discount': instance.priceAfterDiscount,
      'price': instance.price,
      'base_price': instance.basePrice,
      'originalPrice': instance.originalPrice,
      'main_image': instance.mainImage,
      'imageUrl': instance.imageUrl,
      'available': _$JsonConverterToJson<dynamic, bool>(
        instance.available,
        const IntBoolConverter().toJson,
      ),
      'offer': instance.offer,
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
