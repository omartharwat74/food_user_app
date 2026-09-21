// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MenuCategoryDto _$MenuCategoryDtoFromJson(Map<String, dynamic> json) =>
    _MenuCategoryDto(
      id: json['id'] == null ? '' : _idFromJson(json['id']),
      branchId: json['branchId'] == null ? '' : _idFromJson(json['branchId']),
      name: json['name'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => MenuItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      visible: json['visible'] == null
          ? true
          : const IntBoolConverter().fromJson(json['visible']),
    );

Map<String, dynamic> _$MenuCategoryDtoToJson(_MenuCategoryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'branchId': instance.branchId,
      'name': instance.name,
      'sortOrder': instance.sortOrder,
      'items': instance.items,
      'visible': const IntBoolConverter().toJson(instance.visible),
    };
