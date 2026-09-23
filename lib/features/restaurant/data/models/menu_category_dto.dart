import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:food_user_app/features/restaurant/data/models/menu_item_dto.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_category.dart';

import 'package:food_user_app/core/utils/bool_converter.dart';

part 'menu_category_dto.freezed.dart';
part 'menu_category_dto.g.dart';

// Safely converts any JSON value (int or String) to String.
String _idFromJson(dynamic value) => value?.toString() ?? '';

@freezed
abstract class MenuCategoryDto with _$MenuCategoryDto {
  const factory MenuCategoryDto({
    @JsonKey(fromJson: _idFromJson) @Default('') String id,
    @JsonKey(name: 'branchId', fromJson: _idFromJson)
    @Default('')
    String branchId,
    String? name,
    @Default(0) int sortOrder,
    @Default([]) List<MenuItemDto> items,
    @IntBoolConverter() @Default(true) bool visible,
  }) = _MenuCategoryDto;

  factory MenuCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$MenuCategoryDtoFromJson(json);
}

extension MenuCategoryDtoMapper on MenuCategoryDto {
  MenuCategory toEntity() {
    return MenuCategory(
      id: id,
      branchId: branchId,
      name: name ?? '',
      sortOrder: sortOrder,
      items: items.map((e) => e.toEntity()).toList(),
      visible: visible,
    );
  }
}
