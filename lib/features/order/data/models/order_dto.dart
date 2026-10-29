import 'package:food_user_app/features/order/domain/entities/order.dart';

int _parseInt(dynamic value, [int defaultValue = 0]) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? defaultValue;
  return defaultValue;
}

double _parseDouble(dynamic value, [double defaultValue = 0.0]) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? defaultValue;
  return defaultValue;
}

bool _parseBool(dynamic value, [bool defaultValue = false]) {
  if (value is bool) return value;
  if (value is num) return value == 1;
  if (value is String) {
    final lower = value.toLowerCase();
    return lower == 'true' || lower == '1';
  }
  return defaultValue;
}

class OrderDto {
  final int id;
  final String code;
  final String status;
  final String paymentMethod;
  final bool selfPickup;
  final String? deliveryMode;
  final OrderStoreDto? store;
  final List<OrderItemDto> items;
  final OrderSummaryDto summary;
  final OrderCouponDto? coupon;
  final OrderAddressDto? address;
  final OrderDeliveryDto? delivery;
  final String? cancelReason;
  final DateTime? createdAt;
  final String? message;
  final String? notes;
  final bool isReviewed;

  const OrderDto({
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

  factory OrderDto.fromJson(Map<String, dynamic> json, {String? message}) {
    final Map<String, dynamic> data =
        json.containsKey('data') && json['data'] is Map<String, dynamic>
            ? json['data'] as Map<String, dynamic>
            : json;
    final msg = message ?? (json['msg'] as String?);

    final rawItems = data['items'];
    final itemsList = <OrderItemDto>[];
    if (rawItems is List) {
      for (final item in rawItems) {
        if (item is Map<String, dynamic>) {
          itemsList.add(OrderItemDto.fromJson(item));
        }
      }
    }

    DateTime? parsedCreatedAt;
    final rawDate = data['created_at'];
    if (rawDate != null) {
      parsedCreatedAt = DateTime.tryParse(rawDate.toString())?.toLocal();
    }

    return OrderDto(
      id: _parseInt(data['id']),
      code: data['code']?.toString() ?? '',
      status: data['status']?.toString() ?? 'pending',
      paymentMethod: data['payment_method']?.toString() ?? 'cash',
      selfPickup: _parseBool(data['self_pickup']),
      deliveryMode: data['delivery_mode']?.toString(),
      store: data['store'] is Map<String, dynamic>
          ? OrderStoreDto.fromJson(data['store'] as Map<String, dynamic>)
          : null,
      items: itemsList,
      summary: data['summary'] is Map<String, dynamic>
          ? OrderSummaryDto.fromJson(data['summary'] as Map<String, dynamic>)
          : const OrderSummaryDto(),
      coupon: data['coupon'] is Map<String, dynamic>
          ? OrderCouponDto.fromJson(data['coupon'] as Map<String, dynamic>)
          : null,
      address: data['address'] is Map<String, dynamic>
          ? OrderAddressDto.fromJson(data['address'] as Map<String, dynamic>)
          : null,
      delivery: data['delivery'] is Map<String, dynamic>
          ? OrderDeliveryDto.fromJson(data['delivery'] as Map<String, dynamic>)
          : null,
      cancelReason: data['cancel_reason']?.toString(),
      createdAt: parsedCreatedAt,
      message: msg,
      notes: data['notes']?.toString() ?? data['note']?.toString(),
      isReviewed: _parseBool(data['is_reviewed']),
    );
  }

  Order toEntity() {
    return Order(
      id: id,
      code: code,
      status: status,
      paymentMethod: paymentMethod,
      selfPickup: selfPickup,
      deliveryMode: deliveryMode,
      store: store?.toEntity(),
      items: items.map((e) => e.toEntity()).toList(),
      summary: summary.toEntity(),
      coupon: coupon?.toEntity(),
      address: address?.toEntity(),
      delivery: delivery?.toEntity(),
      cancelReason: cancelReason,
      createdAt: createdAt,
      message: message,
      notes: notes,
      isReviewed: isReviewed,
    );
  }
}

class OrderStoreDto {
  final int id;
  final String name;
  final String? logo;
  final String? availability;
  final bool unavailable;
  final String? unavailableReason;
  final String? deliveryMode;

  const OrderStoreDto({
    required this.id,
    required this.name,
    this.logo,
    this.availability,
    this.unavailable = false,
    this.unavailableReason,
    this.deliveryMode,
  });

  factory OrderStoreDto.fromJson(Map<String, dynamic> json) {
    return OrderStoreDto(
      id: _parseInt(json['id']),
      name: json['name']?.toString() ?? '',
      logo: json['logo']?.toString(),
      availability: json['availability']?.toString(),
      unavailable: _parseBool(json['unavailable']),
      unavailableReason: json['unavailable_reason']?.toString(),
      deliveryMode: json['delivery_mode']?.toString(),
    );
  }

  OrderStore toEntity() => OrderStore(
    id: id,
    name: name,
    logo: logo,
    availability: availability,
    unavailable: unavailable,
    unavailableReason: unavailableReason,
    deliveryMode: deliveryMode,
  );
}

class OrderItemDto {
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

  const OrderItemDto({
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

  factory OrderItemDto.fromJson(Map<String, dynamic> json) {
    return OrderItemDto(
      id: json['id'] != null ? _parseInt(json['id']) : null,
      productId: json['product_id'] != null ? _parseInt(json['product_id']) : null,
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString(),
      quantity: _parseInt(json['quantity'], 1),
      unavailable: _parseBool(json['unavailable']),
      unavailableReason: json['unavailable_reason']?.toString(),
      selectedOptions:
          json['selected_options'] is List ? json['selected_options'] as List : const [],
      unitPriceBeforeOffer: json['unit_price_before_offer'] != null
          ? _parseDouble(json['unit_price_before_offer'])
          : null,
      unitPrice: _parseDouble(json['unit_price']),
      offer: json['offer'],
      lineTotal: _parseDouble(json['line_total']),
      notes: json['notes']?.toString() ?? json['note']?.toString(),
    );
  }

  OrderItem toEntity() => OrderItem(
    id: id,
    productId: productId,
    name: name,
    image: image,
    quantity: quantity,
    unavailable: unavailable,
    unavailableReason: unavailableReason,
    selectedOptions: selectedOptions,
    unitPriceBeforeOffer: unitPriceBeforeOffer,
    unitPrice: unitPrice,
    offer: offer,
    lineTotal: lineTotal,
    notes: notes,
  );
}

class OrderSummaryDto {
  final double itemsSubtotal;
  final double offerDiscount;
  final double itemsTotal;
  final double taxPercent;
  final double tax;
  final double delivery;
  final double couponDiscount;
  final double total;

  const OrderSummaryDto({
    this.itemsSubtotal = 0.0,
    this.offerDiscount = 0.0,
    this.itemsTotal = 0.0,
    this.taxPercent = 0.0,
    this.tax = 0.0,
    this.delivery = 0.0,
    this.couponDiscount = 0.0,
    this.total = 0.0,
  });

  factory OrderSummaryDto.fromJson(Map<String, dynamic> json) {
    return OrderSummaryDto(
      itemsSubtotal: _parseDouble(json['items_subtotal']),
      offerDiscount: _parseDouble(json['offer_discount']),
      itemsTotal: _parseDouble(json['items_total']),
      taxPercent: _parseDouble(json['tax_percent']),
      tax: _parseDouble(json['tax']),
      delivery: _parseDouble(json['delivery']),
      couponDiscount: _parseDouble(json['coupon_discount']),
      total: _parseDouble(json['total']),
    );
  }

  OrderSummary toEntity() => OrderSummary(
    itemsSubtotal: itemsSubtotal,
    offerDiscount: offerDiscount,
    itemsTotal: itemsTotal,
    taxPercent: taxPercent,
    tax: tax,
    delivery: delivery,
    couponDiscount: couponDiscount,
    total: total,
  );
}

class OrderCouponDto {
  final String? code;
  final String? type;
  final double? value;

  const OrderCouponDto({this.code, this.type, this.value});

  factory OrderCouponDto.fromJson(Map<String, dynamic> json) {
    return OrderCouponDto(
      code: json['code']?.toString(),
      type: json['type']?.toString(),
      value: json['value'] != null ? _parseDouble(json['value']) : null,
    );
  }

  OrderCoupon toEntity() => OrderCoupon(code: code, type: type, value: value);
}

class OrderAddressDto {
  final int? id;
  final String? name;
  final String? fullAddress;
  final String? buildingNumber;
  final String? floor;
  final String? apartment;
  final double? lat;
  final double? long;
  final int? regionId;

  const OrderAddressDto({
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

  factory OrderAddressDto.fromJson(Map<String, dynamic> json) {
    return OrderAddressDto(
      id: json['id'] != null ? _parseInt(json['id']) : null,
      name: json['name']?.toString(),
      fullAddress: json['full_address']?.toString(),
      buildingNumber: json['building_number']?.toString(),
      floor: json['floor']?.toString(),
      apartment: json['apartment']?.toString(),
      lat: json['lat'] != null ? _parseDouble(json['lat']) : null,
      long: json['long'] != null ? _parseDouble(json['long']) : null,
      regionId: json['region_id'] != null ? _parseInt(json['region_id']) : null,
    );
  }

  OrderAddress toEntity() => OrderAddress(
    id: id,
    name: name,
    fullAddress: fullAddress,
    buildingNumber: buildingNumber,
    floor: floor,
    apartment: apartment,
    lat: lat,
    long: long,
    regionId: regionId,
  );
}

class OrderDeliveryDto {
  final int? id;
  final String? name;
  final String? phone;
  final String? image;
  final String? vehicleType;
  final double? rating;
  final int ratingCount;

  const OrderDeliveryDto({
    this.id,
    this.name,
    this.phone,
    this.image,
    this.vehicleType,
    this.rating,
    this.ratingCount = 0,
  });

  factory OrderDeliveryDto.fromJson(Map<String, dynamic> json) {
    final rawRating = json['rating'] ??
        json['rate'] ??
        json['rating_avg'] ??
        json['average_rating'] ??
        json['avg_rating'];
    final rawRatingCount = json['rating_count'] ??
        json['ratings_count'] ??
        json['count'];
    return OrderDeliveryDto(
      id: json['id'] != null ? _parseInt(json['id']) : null,
      name: json['name']?.toString(),
      phone: json['phone']?.toString(),
      image: json['image']?.toString(),
      vehicleType: json['vehicle_type']?.toString(),
      rating: rawRating != null ? _parseDouble(rawRating) : null,
      ratingCount: _parseInt(rawRatingCount),
    );
  }

  OrderDelivery toEntity() => OrderDelivery(
    id: id,
    name: name,
    phone: phone,
    image: image,
    vehicleType: vehicleType,
    rating: rating,
    ratingCount: ratingCount,
  );
}
