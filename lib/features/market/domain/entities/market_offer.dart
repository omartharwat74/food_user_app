import 'package:equatable/equatable.dart';

class MarketOffer extends Equatable {
  final String id;
  final String marketId;
  final String title;
  final String? description;
  final String? image;
  final int discountPercent;
  final double minOrderAmount;

  const MarketOffer({
    required this.id,
    required this.marketId,
    required this.title,
    this.description,
    this.image,
    required this.discountPercent,
    required this.minOrderAmount,
  });

  @override
  List<Object?> get props => [
    id,
    marketId,
    title,
    description,
    image,
    discountPercent,
    minOrderAmount,
  ];
}
