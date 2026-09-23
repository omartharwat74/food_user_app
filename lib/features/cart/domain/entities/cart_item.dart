import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String id;
  final String menuItemId;
  final String restaurantId;
  final String name;
  final String description;
  final double price;
  final double unitPrice;
  final double totalPrice;
  final String imageAsset;
  final int quantity;
  final List<dynamic>? selectedModifiers;
  final String? notes;

  const CartItem({
    required this.id,
    this.menuItemId = '',
    this.restaurantId = '',
    required this.name,
    this.description = '',
    required this.price,
    this.unitPrice = 0.0,
    this.totalPrice = 0.0,
    this.imageAsset = '',
    this.quantity = 1,
    this.selectedModifiers,
    this.notes,
  });

  CartItem copyWith({
    String? id,
    String? menuItemId,
    String? restaurantId,
    String? name,
    String? description,
    double? price,
    double? unitPrice,
    double? totalPrice,
    String? imageAsset,
    int? quantity,
    List<dynamic>? selectedModifiers,
    String? notes,
  }) {
    return CartItem(
      id: id ?? this.id,
      menuItemId: menuItemId ?? this.menuItemId,
      restaurantId: restaurantId ?? this.restaurantId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      imageAsset: imageAsset ?? this.imageAsset,
      quantity: quantity ?? this.quantity,
      selectedModifiers: selectedModifiers ?? this.selectedModifiers,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
    id,
    menuItemId,
    restaurantId,
    name,
    description,
    price,
    unitPrice,
    totalPrice,
    imageAsset,
    quantity,
    selectedModifiers,
    notes,
  ];
}
