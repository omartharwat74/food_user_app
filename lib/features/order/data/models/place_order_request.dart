class PlaceOrderRequest {
  final String paymentMethod;
  final int? addressId;
  final bool selfPickup;
  final String? couponCode;
  final String? note;

  const PlaceOrderRequest({
    required this.paymentMethod,
    this.addressId,
    this.selfPickup = false,
    this.couponCode,
    this.note,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'payment_method': paymentMethod,
      'self_pickup': selfPickup,
    };
    if (addressId != null) {
      map['address_id'] = addressId;
    }
    if (couponCode != null && couponCode!.trim().isNotEmpty) {
      map['coupon_code'] = couponCode!.trim();
    }
    if (note != null && note!.trim().isNotEmpty) {
      final trimmed = note!.trim();
      map['note'] = trimmed.length > 500 ? trimmed.substring(0, 500) : trimmed;
    }
    return map;
  }
}
