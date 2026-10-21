import 'package:equatable/equatable.dart';

class WalletData extends Equatable {
  final String balance;
  final String currency;
  final List<WalletTransaction> items;
  final int currentPage;
  final int lastPage;
  final int total;

  const WalletData({
    required this.balance,
    required this.currency,
    required this.items,
    this.currentPage = 1,
    this.lastPage = 1,
    this.total = 0,
  });

  const WalletData.empty()
      : balance = '0.00',
        currency = 'EGP',
        items = const [],
        currentPage = 1,
        lastPage = 1,
        total = 0;

  WalletData copyWith({
    String? balance,
    String? currency,
    List<WalletTransaction>? items,
    int? currentPage,
    int? lastPage,
    int? total,
  }) {
    return WalletData(
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
    );
  }

  @override
  List<Object?> get props => [
        balance,
        currency,
        items,
        currentPage,
        lastPage,
        total,
      ];
}

class WalletTransaction extends Equatable {
  final String id;
  final String direction;
  final double amount;
  final String note;
  final String createdAt;

  const WalletTransaction({
    required this.id,
    required this.direction,
    required this.amount,
    required this.note,
    required this.createdAt,
  });

  bool get isCredit => direction.toLowerCase() == 'credit';
  bool get isDebit => !isCredit;

  @override
  List<Object?> get props => [id, direction, amount, note, createdAt];
}
