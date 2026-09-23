import 'package:equatable/equatable.dart';

class Market extends Equatable {
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

  const Market({
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

  Market copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? coverImage,
    String? logoImage,
    double? rating,
    int? ratingCount,
    int? deliveryTimeMin,
    int? deliveryTimeMax,
    double? deliveryFee,
    double? minimumOrder,
    bool? isAvailable,
    bool? isFavorite,
    bool? pickupAvailable,
    bool? isVisible,
  }) {
    return Market(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      coverImage: coverImage ?? this.coverImage,
      logoImage: logoImage ?? this.logoImage,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      deliveryTimeMin: deliveryTimeMin ?? this.deliveryTimeMin,
      deliveryTimeMax: deliveryTimeMax ?? this.deliveryTimeMax,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      minimumOrder: minimumOrder ?? this.minimumOrder,
      isAvailable: isAvailable ?? this.isAvailable,
      isFavorite: isFavorite ?? this.isFavorite,
      pickupAvailable: pickupAvailable ?? this.pickupAvailable,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  List<Object?> get props => [
    id,
    ownerId,
    name,
    coverImage,
    logoImage,
    rating,
    ratingCount,
    deliveryTimeMin,
    deliveryTimeMax,
    deliveryFee,
    minimumOrder,
    isAvailable,
    isFavorite,
    pickupAvailable,
    isVisible,
  ];
}
