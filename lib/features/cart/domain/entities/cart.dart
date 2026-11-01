import 'package:equatable/equatable.dart';
import 'cart_item.dart';

class Cart extends Equatable {
  final String id;
  final String? restaurantId;
  final String? restaurantName;
  final String? restaurantAddress;
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
    this.restaurantAddress,
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
      restaurantAddress = null,
      items = const [],
      subtotal = 0.0,
      deliveryFee = 0.0,
      tax = 0.0,
      discount = 0.0,
      total = 0.0;

  Cart copyWith({
    String? id,
    String? restaurantId,
    String? restaurantName,
    String? restaurantAddress,
    List<CartItem>? items,
    double? subtotal,
    double? deliveryFee,
    double? tax,
    double? discount,
    double? total,
  }) {
    return Cart(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantAddress: restaurantAddress ?? this.restaurantAddress,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      tax: tax ?? this.tax,
      discount: discount ?? this.discount,
      total: total ?? this.total,
    );
  }

  @override
  List<Object?> get props => [
    id,
    restaurantId,
    restaurantName,
    restaurantAddress,
    items,
    subtotal,
    deliveryFee,
    tax,
    discount,
    total,
  ];
}
