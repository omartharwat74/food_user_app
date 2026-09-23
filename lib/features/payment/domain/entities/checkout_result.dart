import 'package:equatable/equatable.dart';

class CheckoutResult extends Equatable {
  final String? transactionId;
  final String? paymentIntentId;
  final String? clientSecret;
  final double? amount;
  final String? currency;

  const CheckoutResult({
    this.transactionId,
    this.paymentIntentId,
    this.clientSecret,
    this.amount,
    this.currency,
  });

  @override
  List<Object?> get props => [
    transactionId,
    paymentIntentId,
    clientSecret,
    amount,
    currency,
  ];
}
