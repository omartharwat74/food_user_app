import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_item.dart';

import 'package:food_user_app/core/utils/bool_converter.dart';

part 'menu_item_dto.freezed.dart';
part 'menu_item_dto.g.dart';

// Safely converts any JSON value (int or String) to String.
String _idFromJson(dynamic value) => value?.toString() ?? '';
String? _nullableIdFromJson(dynamic value) => value?.toString();

@freezed
abstract class MenuItemDto with _$MenuItemDto {
  const factory MenuItemDto({
    @JsonKey(fromJson: _idFromJson) @Default('') String id,
    @JsonKey(name: 'categoryId', fromJson: _nullableIdFromJson) String? categoryId,
    String? name,
    String? description,
    @JsonKey(name: 'price_after_discount') double? priceAfterDiscount,
    double? price,
    @JsonKey(name: 'base_price') double? basePrice,
    double? originalPrice,
    @JsonKey(name: 'main_image') String? mainImage,
    String? imageUrl,
    @IntBoolConverter()
    bool? available,
    Map<String, dynamic>? offer,
  }) = _MenuItemDto;

  factory MenuItemDto.fromJson(Map<String, dynamic> json) =>
      _$MenuItemDtoFromJson(json);
}

extension MenuItemDtoMapper on MenuItemDto {
  MenuItem toEntity() {
    final discountValue = (offer?['discount_value'] as num?)?.toDouble() ?? 0.0;
    final discountType = offer?['discount_type'] as String? ?? '';

    return MenuItem(
      id: id,
      name: name ?? '',
      description: description ?? '',
      price: priceAfterDiscount ?? price ?? 0.0,
      originalPrice: basePrice ?? originalPrice ?? price ?? 0.0,
      imageUrl: mainImage ?? imageUrl ?? '',
      available: available ?? false,
      discountValue: discountValue,
      discountType: discountType,
    );
  }
}
