import 'package:equatable/equatable.dart';

class CartExtraItem extends Equatable {
  final int id;
  final String name;
  final String? mainImage;
  final String? unit;
  final double basePrice;
  final double priceAfterDiscount;
  final CartExtraOffer? offer;
  final CartExtraCategory? menuCategory;

  const CartExtraItem({
    required this.id,
    required this.name,
    this.mainImage,
    this.unit,
    required this.basePrice,
    required this.priceAfterDiscount,
    this.offer,
    this.menuCategory,
  });

  bool get hasDiscount =>
      offer != null || (basePrice > priceAfterDiscount && priceAfterDiscount > 0);

  @override
  List<Object?> get props => [
        id,
        name,
        mainImage,
        unit,
        basePrice,
        priceAfterDiscount,
        offer,
        menuCategory,
      ];
}

class CartExtraOffer extends Equatable {
  final int id;
  final String? discountType;
  final double? discountValue;

  const CartExtraOffer({
    required this.id,
    this.discountType,
    this.discountValue,
  });

  @override
  List<Object?> get props => [id, discountType, discountValue];
}

class CartExtraCategory extends Equatable {
  final int id;
  final String? name;
  final String? image;

  const CartExtraCategory({
    required this.id,
    this.name,
    this.image,
  });

  @override
  List<Object?> get props => [id, name, image];
}
