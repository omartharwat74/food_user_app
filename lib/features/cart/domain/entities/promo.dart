import 'package:equatable/equatable.dart';

class Promo extends Equatable {
  final double discountAmount;
  final double total;
  final String? code;

  const Promo({required this.discountAmount, required this.total, this.code});

  @override
  List<Object?> get props => [discountAmount, total, code];
}
