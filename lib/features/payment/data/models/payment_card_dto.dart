import 'package:food_user_app/features/payment/domain/entities/payment_card.dart';

class PaymentCardDto {
  final String id;
  final String? cardNumber;
  final String? cardNumberMasked;
  final String? lastFour;
  final String? expiryDate;
  final String? expiryMonth;
  final String? expiryYear;

  const PaymentCardDto({
    required this.id,
    this.cardNumber,
    this.cardNumberMasked,
    this.lastFour,
    this.expiryDate,
    this.expiryMonth,
    this.expiryYear,
  });

  factory PaymentCardDto.fromJson(Map<String, dynamic> json) {
    return PaymentCardDto(
      id: json['id']?.toString() ?? '',
      cardNumber: json['card_number']?.toString(),
      cardNumberMasked: json['card_number_masked']?.toString(),
      lastFour: (json['last_four'] ?? json['last4'])?.toString(),
      expiryDate: (json['expiry_date'] ?? json['exp_date'])?.toString(),
      expiryMonth: (json['expiry_month'] ?? json['exp_month'])?.toString(),
      expiryYear: (json['expiry_year'] ?? json['exp_year'])?.toString(),
    );
  }

  PaymentCard toEntity() {
    int? expMonth;
    int? expYear;

    if (expiryMonth != null && expiryYear != null) {
      expMonth = int.tryParse(expiryMonth!);
      expYear = int.tryParse(expiryYear!);
    } else if (expiryDate != null && expiryDate!.contains('/')) {
      final parts = expiryDate!.split('/');
      if (parts.length == 2) {
        expMonth = int.tryParse(parts[0]);
        expYear = int.tryParse(parts[1]);
      }
    } else if (expiryDate != null && expiryDate!.length == 4) {
      // MMYY format
      expMonth = int.tryParse(expiryDate!.substring(0, 2));
      expYear = int.tryParse(expiryDate!.substring(2, 4));
    }

    return PaymentCard(
      id: id,
      gateway: null,
      brand: 'Card',
      last4: lastFour,
      cardNumber: cardNumber,

      expMonth: expMonth,
      expYear: expYear,
      isDefault: false,
    );
  }
}
