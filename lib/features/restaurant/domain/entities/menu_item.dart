import 'package:equatable/equatable.dart';

/// A single option within a modifier group (e.g. "Small", "Large").
class ProductOption extends Equatable {
  final String id;
  final String name;
  final double price;

  const ProductOption({
    required this.id,
    required this.name,
    required this.price,
  });

  @override
  List<Object?> get props => [id, name, price];
}

/// A modifier group containing selectable options (e.g. "Size", "Extras").
class ProductModifier extends Equatable {
  final String id;
  final String name;
  final bool required;
  final int maxSelect;
  final String priceType;
  final List<ProductOption> values;

  const ProductModifier({
    required this.id,
    required this.name,
    this.required = false,
    this.maxSelect = 1,
    this.priceType = 'addon',
    this.values = const [],
  });

  @override
  List<Object?> get props => [id, name, required, maxSelect, priceType, values];
}

/// A combo component included with the product (e.g. "Fries", "Drink").
class ProductInclude extends Equatable {
  final String id;
  final String name;
  final String? imageUrl;
  final int quantity;

  const ProductInclude({
    required this.id,
    required this.name,
    this.imageUrl,
    this.quantity = 1,
  });

  @override
  List<Object?> get props => [id, name, imageUrl, quantity];
}

class MenuItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final String imageUrl;
  final bool available;
  final double discountValue;
  final String discountType;
  final List<ProductModifier> options;
  final List<ProductInclude> includes;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.imageUrl,
    required this.available,
    this.discountValue = 0.0,
    this.discountType = '',
    this.options = const [],
    this.includes = const [],
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    originalPrice,
    imageUrl,
    available,
    discountValue,
    discountType,
    options,
    includes,
  ];
}
