import 'package:equatable/equatable.dart';
import 'package:food_user_app/features/cart/domain/entities/promo.dart';

class CartCouponResponseDto extends Equatable {
  final double discountAmount;
  final double total;
  final double? subtotal;
  final double? deliveryFee;
  final double? tax;
  final String? code;
  final String? message;

  const CartCouponResponseDto({
    required this.discountAmount,
    required this.total,
    this.subtotal,
    this.deliveryFee,
    this.tax,
    this.code,
    this.message,
  });

  factory CartCouponResponseDto.fromJson(
    Map<String, dynamic> json, {
    String? defaultCode,
  }) {
    final msg = json['msg']?.toString() ?? json['message']?.toString();
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : null;

    final summary = data?['summary'] is Map<String, dynamic>
        ? data!['summary'] as Map<String, dynamic>
        : null;

    final coupon = data?['coupon'] is Map<String, dynamic>
        ? data!['coupon'] as Map<String, dynamic>
        : null;

    final rawDiscount = summary?['coupon_discount'] ??
        summary?['discount'] ??
        summary?['offer_discount'] ??
        coupon?['value'] ??
        0;

    final rawTotal = summary?['total'] ?? 0;
    final rawSubtotal = summary?['items_total'] ?? summary?['items_subtotal'];
    final rawDelivery = summary?['delivery'] ?? summary?['delivery_fee'];
    final rawTax = summary?['tax'];

    final parsedCode = coupon?['code']?.toString() ?? defaultCode;

    return CartCouponResponseDto(
      discountAmount: (rawDiscount is num
              ? rawDiscount
              : num.tryParse(rawDiscount.toString()) ?? 0)
          .toDouble(),
      total: (rawTotal is num
              ? rawTotal
              : num.tryParse(rawTotal.toString()) ?? 0)
          .toDouble(),
      subtotal: rawSubtotal != null
          ? (rawSubtotal is num
                  ? rawSubtotal
                  : num.tryParse(rawSubtotal.toString()) ?? 0)
              .toDouble()
          : null,
      deliveryFee: rawDelivery != null
          ? (rawDelivery is num
                  ? rawDelivery
                  : num.tryParse(rawDelivery.toString()) ?? 0)
              .toDouble()
          : null,
      tax: rawTax != null
          ? (rawTax is num
                  ? rawTax
                  : num.tryParse(rawTax.toString()) ?? 0)
              .toDouble()
          : null,
      code: parsedCode,
      message: msg,
    );
  }

  Promo toPromo() {
    return Promo(
      discountAmount: discountAmount,
      total: total,
      code: code,
    );
  }

  @override
  List<Object?> get props => [
        discountAmount,
        total,
        subtotal,
        deliveryFee,
        tax,
        code,
        message,
      ];
}
