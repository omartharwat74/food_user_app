import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String subCategoryId;
  final String name;
  final String? description;
  final String? image;
  final double price;
  final double? originalPrice;
  final List<String> customizations;

  const Product({
    required this.id,
    required this.subCategoryId,
    required this.name,
    this.description,
    this.image,
    required this.price,
    this.originalPrice,
    required this.customizations,
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  @override
  List<Object?> get props => [
    id,
    subCategoryId,
    name,
    description,
    image,
    price,
    originalPrice,
    customizations,
  ];
}
