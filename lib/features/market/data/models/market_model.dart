import '../../domain/entities/market.dart';

class MarketModel {
  final String id;
  final String ownerId;
  final String name;
  final String? coverImage;
  final String? logoImage;
  final double rating;
  final int ratingCount;
  final int deliveryTimeMin;
  final int deliveryTimeMax;
  final double deliveryFee;
  final double minimumOrder;
  final bool isAvailable;
  final bool isFavorite;
  final bool pickupAvailable;
  final bool isVisible;

  const MarketModel({
    required this.id,
    required this.ownerId,
    required this.name,
    this.coverImage,
    this.logoImage,
    required this.rating,
    required this.ratingCount,
    required this.deliveryTimeMin,
    required this.deliveryTimeMax,
    required this.deliveryFee,
    required this.minimumOrder,
    required this.isAvailable,
    required this.isFavorite,
    required this.pickupAvailable,
    required this.isVisible,
  });

  factory MarketModel.fromJson(Map<String, dynamic> json) {
    return MarketModel(
      id: json['id']?.toString() ?? '',
      ownerId: json['owner_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      coverImage: json['cover']?.toString() ?? json['coverImage']?.toString(),
      logoImage: json['logo']?.toString() ?? json['logoImage']?.toString(),
      rating: (json['rating_avg'] as num?)?.toDouble() ?? (json['rating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: (json['rating_count'] as num?)?.toInt() ?? (json['ratingCount'] as num?)?.toInt() ?? 0,
      deliveryTimeMin: (json['prep_time_from'] as num?)?.toInt() ?? (json['deliveryTimeMin'] as num?)?.toInt() ?? 0,
      deliveryTimeMax: (json['prep_time_to'] as num?)?.toInt() ?? (json['deliveryTimeMax'] as num?)?.toInt() ?? 0,
      deliveryFee: (json['delivery_fee'] as num?)?.toDouble() ?? (json['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      minimumOrder: (json['minimum_order'] as num?)?.toDouble() ?? (json['minimumOrder'] as num?)?.toDouble() ?? 0.0,
      isAvailable: json['is_available'] == true || json['isAvailable'] == true,
      isFavorite: json['is_favorited'] == true || json['isFavorite'] == true,
      pickupAvailable: json['pickup_available'] == true || json['pickupAvailable'] == true,
      isVisible: json['is_visible'] == true || json['isVisible'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'coverImage': coverImage,
      'logoImage': logoImage,
      'rating': rating,
      'ratingCount': ratingCount,
      'deliveryTimeMin': deliveryTimeMin,
      'deliveryTimeMax': deliveryTimeMax,
      'deliveryFee': deliveryFee,
      'minimumOrder': minimumOrder,
      'isAvailable': isAvailable,
      'isFavorite': isFavorite,
      'pickupAvailable': pickupAvailable,
      'isVisible': isVisible,
    };
  }

  Market toEntity() {
    return Market(
      id: id,
      ownerId: ownerId,
      name: name,
      coverImage: coverImage,
      logoImage: logoImage,
      rating: rating,
      ratingCount: ratingCount,
      deliveryTimeMin: deliveryTimeMin,
      deliveryTimeMax: deliveryTimeMax,
      deliveryFee: deliveryFee,
      minimumOrder: minimumOrder,
      isAvailable: isAvailable,
      isFavorite: isFavorite,
      pickupAvailable: pickupAvailable,
      isVisible: isVisible,
    );
  }

  factory MarketModel.fromEntity(Market entity) {
    return MarketModel(
      id: entity.id,
      ownerId: entity.ownerId,
      name: entity.name,
      coverImage: entity.coverImage,
      logoImage: entity.logoImage,
      rating: entity.rating,
      ratingCount: entity.ratingCount,
      deliveryTimeMin: entity.deliveryTimeMin,
      deliveryTimeMax: entity.deliveryTimeMax,
      deliveryFee: entity.deliveryFee,
      minimumOrder: entity.minimumOrder,
      isAvailable: entity.isAvailable,
      isFavorite: entity.isFavorite,
      pickupAvailable: entity.pickupAvailable,
      isVisible: entity.isVisible,
    );
  }
}
