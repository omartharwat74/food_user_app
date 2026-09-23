import 'package:equatable/equatable.dart';

class Order extends Equatable {
  final String id;
  final String customerId;
  final String branchId;
  final String status;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final double discount;
  final List<OrderItem> items;
  final DateTime createdAt;
  final String restaurantName;
  final String deliveryAddress;
  final double? deliveryLat;
  final double? deliveryLng;
  final String paymentMethod;
  final int? estimatedMinutes;
  final String? driverName;
  final String? driverPhone;
  final double? driverLat;
  final double? driverLng;

  const Order({
    required this.id,
    required this.customerId,
    required this.branchId,
    required this.status,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.discount,
    required this.items,
    required this.createdAt,
    required this.restaurantName,
    required this.deliveryAddress,
    this.deliveryLat,
    this.deliveryLng,
    required this.paymentMethod,
    this.estimatedMinutes,
    this.driverName,
    this.driverPhone,
    this.driverLat,
    this.driverLng,
  });

  @override
  List<Object?> get props => [
    id,
    customerId,
    branchId,
    status,
    subtotal,
    deliveryFee,
    total,
    discount,
    items,
    createdAt,
    restaurantName,
    deliveryAddress,
    deliveryLat,
    deliveryLng,
    paymentMethod,
    estimatedMinutes,
    driverName,
    driverPhone,
    driverLat,
    driverLng,
  ];
}

class OrderItem extends Equatable {
  final String menuItemId;
  final String itemName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final List<dynamic>? selectedModifiers;
  final String? notes;

  const OrderItem({
    required this.menuItemId,
    required this.itemName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.selectedModifiers,
    this.notes,
  });

  @override
  List<Object?> get props => [
    menuItemId,
    itemName,
    quantity,
    unitPrice,
    totalPrice,
    selectedModifiers,
    notes,
  ];
}
