// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OfferDto _$OfferDtoFromJson(Map<String, dynamic> json) => _OfferDto(
  id: json['id'] == null ? '' : _idFromJson(json['id']),
  restaurantId: _nullableIdFromJson(json['restaurantId']),
  title: json['title'] as String?,
  discountPercent: (json['discountPercent'] as num?)?.toInt(),
  minOrderAmount: (json['minOrderAmount'] as num?)?.toDouble(),
  description: json['description'] as String?,
  expiresAt: json['expiresAt'] as String?,
  active: const IntBoolConverter().fromJson(json['active']),
);

Map<String, dynamic> _$OfferDtoToJson(_OfferDto instance) => <String, dynamic>{
  'id': instance.id,
  'restaurantId': instance.restaurantId,
  'title': instance.title,
  'discountPercent': instance.discountPercent,
  'minOrderAmount': instance.minOrderAmount,
  'description': instance.description,
  'expiresAt': instance.expiresAt,
  'active': _$JsonConverterToJson<dynamic, bool>(
    instance.active,
    const IntBoolConverter().toJson,
  ),
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
