// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spotlight_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpotlightDto _$SpotlightDtoFromJson(Map<String, dynamic> json) => SpotlightDto(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  hasMore: json['has_more'] as bool? ?? false,
  stores:
      (json['stores'] as List<dynamic>?)
          ?.map((e) => StoreModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);
