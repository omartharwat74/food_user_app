import 'package:equatable/equatable.dart';
import 'package:food_user_app/features/restaurant/domain/entities/review.dart';

class Restaurant extends Equatable {
  final String id;
  final String name;
  final String cuisineType;
  final String coverImageUrl;
  final String logoUrl;
  final String description;
  final double rating;
  final int ratingCount;
  final int deliveryTimeMin;
  final int deliveryTimeMax;
  final double deliveryFee;
  final bool isFavorited;
  final bool isAvailable;
  final bool isMajor;
  final String availability;
  final List<String> tags;
  final String address;
  final Map<String, dynamic> ratingDistribution;
  final List<Review> reviews;
  final bool reviewsHasMore;

  const Restaurant({
    required this.id,
    required this.name,
    required this.cuisineType,
    required this.coverImageUrl,
    this.logoUrl = '',
    this.description = '',
    required this.rating,
    this.ratingCount = 0,
    required this.deliveryTimeMin,
    required this.deliveryTimeMax,
    required this.deliveryFee,
    required this.isFavorited,
    this.isAvailable = true,
    this.isMajor = false,
    this.availability = 'open',
    this.tags = const [],
    this.address = '',
    this.ratingDistribution = const {},
    this.reviews = const [],
    this.reviewsHasMore = false,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    cuisineType,
    coverImageUrl,
    logoUrl,
    description,
    rating,
    ratingCount,
    deliveryTimeMin,
    deliveryTimeMax,
    deliveryFee,
    isFavorited,
    isAvailable,
    isMajor,
    availability,
    tags,
    address,
    ratingDistribution,
    reviews,
    reviewsHasMore,
  ];
}
