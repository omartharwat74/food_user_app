class RestaurantDetailArgs {
  const RestaurantDetailArgs({
    required this.id,
    required this.name,
    required this.description,
    required this.deliveryTime,
    required this.rating,
    required this.logoAsset,
    required this.coverAsset,
    this.deliveryFee,
    this.initialFavorite = false,
  });

  final String id;
  final String name;
  final String description;
  final String deliveryTime;
  final double rating;
  final String logoAsset;
  final String coverAsset;
  final String? deliveryFee;
  final bool initialFavorite;
}
