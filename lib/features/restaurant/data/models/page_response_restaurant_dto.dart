import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:food_user_app/features/restaurant/data/models/restaurant_dto.dart';
import 'package:food_user_app/features/restaurant/domain/entities/page_response_restaurant.dart';

import 'package:food_user_app/core/utils/bool_converter.dart';

part 'page_response_restaurant_dto.freezed.dart';
part 'page_response_restaurant_dto.g.dart';

@freezed
abstract class PageResponseRestaurantDto with _$PageResponseRestaurantDto {
  const factory PageResponseRestaurantDto({
    @Default([]) List<RestaurantDto> content,
    @Default(0) int page,
    @Default(0) int size,
    @Default(0) int totalElements,
    @Default(0) int totalPages,
    @IntBoolConverter()
    @Default(true) bool last,
  }) = _PageResponseRestaurantDto;

  factory PageResponseRestaurantDto.fromJson(Map<String, dynamic> json) =>
      _$PageResponseRestaurantDtoFromJson(json);
}

extension PageResponseRestaurantDtoMapper on PageResponseRestaurantDto {
  PageResponseRestaurant toEntity() {
    return PageResponseRestaurant(
      content: content.map((dto) => dto.toEntity()).toList(),
      page: page,
      size: size,
      totalElements: totalElements,
      totalPages: totalPages,
      last: last,
    );
  }
}
