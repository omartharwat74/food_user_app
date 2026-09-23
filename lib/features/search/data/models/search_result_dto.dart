import 'package:food_user_app/features/restaurant/data/models/restaurant_dto.dart';
import 'package:food_user_app/features/restaurant/data/models/menu_item_dto.dart';
import 'package:food_user_app/features/search/domain/entities/search_result.dart';
import 'package:food_user_app/core/utils/json_utils.dart';

class SearchResultDto {
  final List<RestaurantDto>? restaurants;
  final List<MenuItemDto>? items;
  final bool isRandom;

  const SearchResultDto({this.restaurants, this.items, this.isRandom = false});

  factory SearchResultDto.fromJson(Map<String, dynamic> json) {
    // The new response format: data: { items: [...], is_random: ... }
    final isRandom = json['is_random'] == true;
    final itemsList = json['items'] as List<dynamic>? ?? [];

    // Map Store objects to RestaurantDto objects since UI still uses Restaurant
    final mappedRestaurants = itemsList.map((e) {
      final store = e as Map<String, dynamic>;
      return RestaurantDto(
        id: store['id']?.toString() ?? '',
        name: store['name'] as String?,
        logoUrl: store['logo']?.toString() ?? '',
        coverUrl: store['cover']?.toString() ?? '',
        coverImageUrl: store['cover']?.toString() ?? '',
        deliveryTimeMin: (store['prep_time_from'] as num?)?.toInt(),
        deliveryTimeMax: (store['prep_time_to'] as num?)?.toInt(),
        ratingAvg: store['rating_avg'],
        isMajor: parseBoolFromJson(store['is_major']),
      );
    }).toList();

    return SearchResultDto(
      restaurants: mappedRestaurants,
      items: [], // Search response no longer returns items
      isRandom: isRandom,
    );
  }

  SearchResult toEntity() {
    return SearchResult(
      restaurants:
          restaurants?.map((dto) => dto.toEntity()).toList() ?? const [],
      items: items?.map((dto) => dto.toEntity()).toList() ?? const [],
      isRandom: isRandom,
    );
  }
}
