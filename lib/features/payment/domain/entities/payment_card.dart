import 'package:equatable/equatable.dart';

class PaymentCard extends Equatable {
  final String id;
  final String? gateway;
  final String? brand;
  final String? last4;
  final String? cardNumber;
  final int? expMonth;
  final int? expYear;
  final bool isDefault;

  const PaymentCard({
    required this.id,
    this.gateway,
    this.brand,
    this.last4,
    this.cardNumber,
    this.expMonth,
    this.expYear,
    this.isDefault = false,
  });

  @override
  List<Object?> get props => [
    id,
    gateway,
    brand,
    last4,
    cardNumber,
    expMonth,
    expYear,
    isDefault,
  ];
}
