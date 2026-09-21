// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_response_restaurant_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PageResponseRestaurantDto _$PageResponseRestaurantDtoFromJson(
  Map<String, dynamic> json,
) => _PageResponseRestaurantDto(
  content:
      (json['content'] as List<dynamic>?)
          ?.map((e) => RestaurantDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  page: (json['page'] as num?)?.toInt() ?? 0,
  size: (json['size'] as num?)?.toInt() ?? 0,
  totalElements: (json['totalElements'] as num?)?.toInt() ?? 0,
  totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
  last: json['last'] == null
      ? true
      : const IntBoolConverter().fromJson(json['last']),
);

Map<String, dynamic> _$PageResponseRestaurantDtoToJson(
  _PageResponseRestaurantDto instance,
) => <String, dynamic>{
  'content': instance.content,
  'page': instance.page,
  'size': instance.size,
  'totalElements': instance.totalElements,
  'totalPages': instance.totalPages,
  'last': const IntBoolConverter().toJson(instance.last),
};
