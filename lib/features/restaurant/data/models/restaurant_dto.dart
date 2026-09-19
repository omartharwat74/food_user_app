import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:food_user_app/features/restaurant/domain/entities/restaurant.dart';
import 'package:food_user_app/core/utils/json_utils.dart';

part 'restaurant_dto.freezed.dart';
part 'restaurant_dto.g.dart';

// Top-level helper: safely converts any JSON value to String.
String _idFromJson(dynamic value) => value?.toString() ?? '';


@freezed
abstract class RestaurantDto with _$RestaurantDto {
  const factory RestaurantDto({
    @JsonKey(fromJson: _idFromJson) @Default('') String id,
    String? name,
    // List-view fields (legacy camelCase, kept for backward compat)
    String? cuisineType,
    String? coverImageUrl,
    double? rating,
    @JsonKey(name: 'rating_avg') dynamic ratingAvg,
    @JsonKey(name: 'rating_count') int? ratingCount,
    @JsonKey(name: 'prep_time_from') int? deliveryTimeMin,
    @JsonKey(name: 'prep_time_to') int? deliveryTimeMax,
    @JsonKey(name: 'delivery_fee') double? deliveryFee,
    @JsonKey(name: 'is_favorited') bool? isFavorited,
    // Store-detail fields (new API snake_case)
    @JsonKey(name: 'logo') String? logoUrl,
    @JsonKey(name: 'cover') String? coverUrl,
    String? description,
    @JsonKey(name: 'is_available') bool? isAvailable,
    @JsonKey(name: 'is_open') bool? isOpen,
    @JsonKey(name: 'is_major', fromJson: parseBoolFromJson) bool? isMajor,
  }) = _RestaurantDto;


  factory RestaurantDto.fromJson(Map<String, dynamic> json) =>
      _$RestaurantDtoFromJson(json);
}

extension RestaurantDtoMapper on RestaurantDto {
  Restaurant toEntity() {
    return Restaurant(
      id: id,
      name: name ?? '',
      cuisineType: cuisineType ?? '',
      // Prefer the detailed `cover` field, fall back to `coverImageUrl`
      coverImageUrl: coverUrl ?? coverImageUrl ?? '',
      logoUrl: logoUrl ?? '',
      description: description ?? '',
      rating: (ratingAvg is num) 
          ? ratingAvg.toDouble() 
          : (double.tryParse(ratingAvg?.toString() ?? '') ?? rating ?? 0.0),
      ratingCount: ratingCount ?? 0,
      deliveryTimeMin: deliveryTimeMin ?? 0,
      deliveryTimeMax: deliveryTimeMax ?? 0,
      deliveryFee: deliveryFee ?? 0.0,
      isFavorited: isFavorited ?? false,
      isAvailable: isAvailable ?? isOpen ?? true,
      isMajor: isMajor ?? false,
    );
  }
}
