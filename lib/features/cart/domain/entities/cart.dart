import 'package:equatable/equatable.dart';
import 'cart_item.dart';

class CartStore extends Equatable {
  final int? id;
  final String? name;
  final String? image;
  final String? address;
  final num? deliveryFee;
  final num? minOrderAmount;

  const CartStore({
    this.id,
    this.name,
    this.image,
    this.address,
    this.deliveryFee,
    this.minOrderAmount,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    image,
    address,
    deliveryFee,
    minOrderAmount,
  ];
}

class Cart extends Equatable {
  final String id;
  final String? restaurantId;
  final String? restaurantName;
  final String? restaurantAddress;
  final CartStore? store;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double discount;
  final double total;
  final bool isSelfPickup;

  const Cart({
    required this.id,
    this.restaurantId,
    this.restaurantName,
    this.restaurantAddress,
    this.store,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.discount,
    required this.total,
    this.isSelfPickup = false,
  });

  const Cart.empty()
    : id = '',
      restaurantId = null,
      restaurantName = null,
      restaurantAddress = null,
      store = null,
      items = const [],
      subtotal = 0.0,
      deliveryFee = 0.0,
      tax = 0.0,
      discount = 0.0,
      total = 0.0,
      isSelfPickup = false;

  Cart copyWith({
    String? id,
    String? restaurantId,
    String? restaurantName,
    String? restaurantAddress,
    CartStore? store,
    List<CartItem>? items,
    double? subtotal,
    double? deliveryFee,
    double? tax,
    double? discount,
    double? total,
    bool? isSelfPickup,
  }) {
    return Cart(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantAddress: restaurantAddress ?? this.restaurantAddress,
      store: store ?? this.store,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      tax: tax ?? this.tax,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      isSelfPickup: isSelfPickup ?? this.isSelfPickup,
    );
  }

  @override
  List<Object?> get props => [
    id,
    restaurantId,
    restaurantName,
    restaurantAddress,
    store,
    items,
    subtotal,
    deliveryFee,
    tax,
    discount,
    total,
    isSelfPickup,
  ];
}
