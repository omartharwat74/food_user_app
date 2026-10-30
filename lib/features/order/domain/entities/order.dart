import 'package:equatable/equatable.dart';

class Order extends Equatable {
  final int id;
  final String code;
  final String status;
  final String paymentMethod;
  final bool selfPickup;
  final String? deliveryMode;
  final OrderStore? store;
  final List<OrderItem> items;
  final OrderSummary summary;
  final OrderCoupon? coupon;
  final OrderAddress? address;
  final OrderDelivery? delivery;
  final String? cancelReason;
  final DateTime? createdAt;
  final String? message;
  final String? notes;
  final bool isReviewed;

  const Order({
    required this.id,
    required this.code,
    required this.status,
    required this.paymentMethod,
    required this.selfPickup,
    this.deliveryMode,
    this.store,
    required this.items,
    required this.summary,
    this.coupon,
    this.address,
    this.delivery,
    this.cancelReason,
    this.createdAt,
    this.message,
    this.notes,
    this.isReviewed = false,
  });

  Order copyWith({
    int? id,
    String? code,
    String? status,
    String? paymentMethod,
    bool? selfPickup,
    String? deliveryMode,
    OrderStore? store,
    List<OrderItem>? items,
    OrderSummary? summary,
    OrderCoupon? coupon,
    OrderAddress? address,
    OrderDelivery? delivery,
    String? cancelReason,
    DateTime? createdAt,
    String? message,
    String? notes,
    bool? isReviewed,
  }) {
    return Order(
      id: id ?? this.id,
      code: code ?? this.code,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      selfPickup: selfPickup ?? this.selfPickup,
      deliveryMode: deliveryMode ?? this.deliveryMode,
      store: store ?? this.store,
      items: items ?? this.items,
      summary: summary ?? this.summary,
      coupon: coupon ?? this.coupon,
      address: address ?? this.address,
      delivery: delivery ?? this.delivery,
      cancelReason: cancelReason ?? this.cancelReason,
      createdAt: createdAt ?? this.createdAt,
      message: message ?? this.message,
      notes: notes ?? this.notes,
      isReviewed: isReviewed ?? this.isReviewed,
    );
  }

  // Backwards compatibility getters
  String get orderId => id.toString();
  String get restaurantName => store?.name ?? '';
  String get deliveryAddress => address?.fullAddress ?? address?.name ?? '';
  double get total => summary.total;
  double get subtotal => summary.itemsSubtotal;
  double get deliveryFee => summary.delivery;
  double get discount => summary.couponDiscount + summary.offerDiscount;
  String? get driverName => delivery?.name;
  String? get driverPhone => delivery?.phone;
  double? get driverLat => null;
  double? get driverLng => null;
  double? get deliveryLat => address?.lat;
  double? get deliveryLng => address?.long;
  String get customerId => '';
  String get branchId => store?.id.toString() ?? '';
  int? get estimatedMinutes => null;

  @override
  List<Object?> get props => [
    id,
    code,
    status,
    paymentMethod,
    selfPickup,
    deliveryMode,
    store,
    items,
    summary,
    coupon,
    address,
    delivery,
    cancelReason,
    createdAt,
    message,
    notes,
    isReviewed,
  ];
}

class OrderStore extends Equatable {
  final int id;
  final String name;
  final String? logo;
  final String? availability;
  final bool unavailable;
  final String? unavailableReason;
  final String? deliveryMode;

  const OrderStore({
    required this.id,
    required this.name,
    this.logo,
    this.availability,
    this.unavailable = false,
    this.unavailableReason,
    this.deliveryMode,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    logo,
    availability,
    unavailable,
    unavailableReason,
    deliveryMode,
  ];
}

class OrderItem extends Equatable {
  final int? id;
  final int? productId;
  final String name;
  final String? image;
  final int quantity;
  final bool unavailable;
  final String? unavailableReason;
  final List<dynamic> selectedOptions;
  final double? unitPriceBeforeOffer;
  final double unitPrice;
  final dynamic offer;
  final double lineTotal;
  final String? notes;

  const OrderItem({
    this.id,
    this.productId,
    required this.name,
    this.image,
    required this.quantity,
    this.unavailable = false,
    this.unavailableReason,
    this.selectedOptions = const [],
    this.unitPriceBeforeOffer,
    required this.unitPrice,
    this.offer,
    required this.lineTotal,
    this.notes,
  });

  // Backwards compatibility getters
  String get menuItemId => productId?.toString() ?? id?.toString() ?? '';
  String get itemName => name;
  double get totalPrice => lineTotal;
  List<dynamic>? get selectedModifiers => selectedOptions;

  @override
  List<Object?> get props => [
    id,
    productId,
    name,
    image,
    quantity,
    unavailable,
    unavailableReason,
    selectedOptions,
    unitPriceBeforeOffer,
    unitPrice,
    offer,
    lineTotal,
    notes,
  ];
}

class OrderSummary extends Equatable {
  final double itemsSubtotal;
  final double offerDiscount;
  final double itemsTotal;
  final double taxPercent;
  final double tax;
  final double delivery;
  final double couponDiscount;
  final double total;

  const OrderSummary({
    this.itemsSubtotal = 0.0,
    this.offerDiscount = 0.0,
    this.itemsTotal = 0.0,
    this.taxPercent = 0.0,
    this.tax = 0.0,
    this.delivery = 0.0,
    this.couponDiscount = 0.0,
    this.total = 0.0,
  });

  @override
  List<Object?> get props => [
    itemsSubtotal,
    offerDiscount,
    itemsTotal,
    taxPercent,
    tax,
    delivery,
    couponDiscount,
    total,
  ];
}

class OrderCoupon extends Equatable {
  final String? code;
  final String? type;
  final double? value;

  const OrderCoupon({
    this.code,
    this.type,
    this.value,
  });

  @override
  List<Object?> get props => [code, type, value];
}

class OrderAddress extends Equatable {
  final int? id;
  final String? name;
  final String? fullAddress;
  final String? buildingNumber;
  final String? floor;
  final String? apartment;
  final double? lat;
  final double? long;
  final int? regionId;

  const OrderAddress({
    this.id,
    this.name,
    this.fullAddress,
    this.buildingNumber,
    this.floor,
    this.apartment,
    this.lat,
    this.long,
    this.regionId,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    fullAddress,
    buildingNumber,
    floor,
    apartment,
    lat,
    long,
    regionId,
  ];
}

class OrderDelivery extends Equatable {
  final int? id;
  final String? name;
  final String? phone;
  final String? image;
  final String? vehicleType;
  final double? rating;
  final int ratingCount;

  const OrderDelivery({
    this.id,
    this.name,
    this.phone,
    this.image,
    this.vehicleType,
    this.rating,
    this.ratingCount = 0,
  });

  OrderDelivery copyWith({
    int? id,
    String? name,
    String? phone,
    String? image,
    String? vehicleType,
    double? rating,
    int? ratingCount,
  }) {
    return OrderDelivery(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      vehicleType: vehicleType ?? this.vehicleType,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    phone,
    image,
    vehicleType,
    rating,
    ratingCount,
  ];
}
