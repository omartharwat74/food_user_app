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
      isFavorited: json['is_favorited'] as bool?,
      logoUrl: json['logo'] as String?,
      coverUrl: json['cover'] as String?,
      description: json['description'] as String?,
      isAvailable: json['is_available'] as bool?,
      isOpen: json['is_open'] as bool?,
      isMajor: parseBoolFromJson(json['is_major']),
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
      'is_favorited': instance.isFavorited,
      'logo': instance.logoUrl,
      'cover': instance.coverUrl,
      'description': instance.description,
      'is_available': instance.isAvailable,
      'is_open': instance.isOpen,
      'is_major': instance.isMajor,
    };
