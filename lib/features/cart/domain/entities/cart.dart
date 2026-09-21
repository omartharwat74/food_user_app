import 'package:equatable/equatable.dart';
import 'cart_item.dart';

class Cart extends Equatable {
  final String id;
  final String? restaurantId;
  final String? restaurantName;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double discount;
  final double total;

  const Cart({
    required this.id,
    this.restaurantId,
    this.restaurantName,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.discount,
    required this.total,
  });

  const Cart.empty()
      : id = '',
        restaurantId = null,
        restaurantName = null,
        items = const [],
        subtotal = 0.0,
        deliveryFee = 0.0,
        tax = 0.0,
        discount = 0.0,
        total = 0.0;

  @override
  List<Object?> get props => [
        id,
        restaurantId,
        restaurantName,
        items,
        subtotal,
        deliveryFee,
        tax,
        discount,
        total,
      ];
}
