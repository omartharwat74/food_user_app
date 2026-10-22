class PlaceOrderRequest {
  final String paymentMethod;
  final int? addressId;
  final bool selfPickup;
  final String? couponCode;

  const PlaceOrderRequest({
    required this.paymentMethod,
    this.addressId,
    this.selfPickup = false,
    this.couponCode,
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
    return map;
  }
}
