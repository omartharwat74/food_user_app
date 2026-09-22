// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RestaurantDto _$RestaurantDtoFromJson(Map<String, dynamic> json) =>
    _RestaurantDto(
      id: json['id'] == null ? '' : _idFromJson(json['id']),
      name: json['name'] as String?,
      cuisineType: json['cuisineType'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      ratingAvg: json['rating_avg'],
      ratingCount: (json['rating_count'] as num?)?.toInt(),
      deliveryTimeMin: (json['prep_time_from'] as num?)?.toInt(),
      deliveryTimeMax: (json['prep_time_to'] as num?)?.toInt(),
      deliveryFee: (json['delivery_fee'] as num?)?.toDouble(),
      isFavorited: const IntBoolConverter().fromJson(json['is_favorited']),
      logoUrl: json['logo'] as String?,
      coverUrl: json['cover'] as String?,
      description: json['description'] as String?,
      isAvailable: const IntBoolConverter().fromJson(json['is_available']),
      isOpen: const IntBoolConverter().fromJson(json['is_open']),
      isMajor: const IntBoolConverter().fromJson(json['is_major']),
      address: json['address'] as String?,
      ratingDistribution: json['rating_distribution'] as Map<String, dynamic>?,
      reviews:
          (json['reviews'] as List<dynamic>?)
              ?.map((e) => ReviewDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      reviewsHasMore: const IntBoolConverter().fromJson(
        json['reviews_has_more'],
      ),
    );

Map<String, dynamic> _$RestaurantDtoToJson(_RestaurantDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'cuisineType': instance.cuisineType,
      'coverImageUrl': instance.coverImageUrl,
      'rating': instance.rating,
      'rating_avg': instance.ratingAvg,
      'rating_count': instance.ratingCount,
      'prep_time_from': instance.deliveryTimeMin,
      'prep_time_to': instance.deliveryTimeMax,
      'delivery_fee': instance.deliveryFee,
      'is_favorited': _$JsonConverterToJson<dynamic, bool>(
        instance.isFavorited,
        const IntBoolConverter().toJson,
      ),
      'logo': instance.logoUrl,
      'cover': instance.coverUrl,
      'description': instance.description,
      'is_available': _$JsonConverterToJson<dynamic, bool>(
        instance.isAvailable,
        const IntBoolConverter().toJson,
      ),
      'is_open': _$JsonConverterToJson<dynamic, bool>(
        instance.isOpen,
        const IntBoolConverter().toJson,
      ),
      'is_major': _$JsonConverterToJson<dynamic, bool>(
        instance.isMajor,
        const IntBoolConverter().toJson,
      ),
      'address': instance.address,
      'rating_distribution': instance.ratingDistribution,
      'reviews': instance.reviews,
      'reviews_has_more': _$JsonConverterToJson<dynamic, bool>(
        instance.reviewsHasMore,
        const IntBoolConverter().toJson,
      ),
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
