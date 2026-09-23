import 'package:equatable/equatable.dart';

class PaymentMethod extends Equatable {
  final String id;
  final String? gateway;
  final String? brand;
  final String? last4;
  final int? expMonth;
  final int? expYear;
  final bool isDefault;

  const PaymentMethod({
    required this.id,
    this.gateway,
    this.brand,
    this.last4,
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
    expMonth,
    expYear,
    isDefault,
  ];
}
