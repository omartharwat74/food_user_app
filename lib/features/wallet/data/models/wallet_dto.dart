import 'package:food_user_app/features/wallet/domain/entities/wallet_data.dart';

class WalletDto {
  final String balance;
  final String currency;
  final List<WalletTransactionDto> items;
  final WalletMetaDto? meta;

  const WalletDto({
    required this.balance,
    required this.currency,
    required this.items,
    this.meta,
  });

  factory WalletDto.fromJson(Map<String, dynamic> json) {
    // Determine where data is nested
    final Map<String, dynamic> dataMap;
    if (json['data'] is Map<String, dynamic>) {
      dataMap = json['data'] as Map<String, dynamic>;
    } else {
      dataMap = json;
    }

    // Parse balance
    final rawBalance = dataMap['balance'] ?? json['balance'];
    String parsedBalance = '0.00';
    if (rawBalance is num) {
      parsedBalance = rawBalance.toStringAsFixed(2);
    } else if (rawBalance is String) {
      final val = double.tryParse(rawBalance);
      parsedBalance = val != null ? val.toStringAsFixed(2) : rawBalance;
    }

    // Parse currency
    final parsedCurrency =
        (dataMap['currency'] ?? json['currency'] ?? 'EGP').toString();

    // Parse items
    final rawItems = dataMap['items'] ?? json['items'] ?? [];
    final itemsList = <WalletTransactionDto>[];
    if (rawItems is List) {
      for (final item in rawItems) {
        if (item is Map<String, dynamic>) {
          itemsList.add(WalletTransactionDto.fromJson(item));
        }
      }
    }

    // Parse meta
    WalletMetaDto? parsedMeta;
    final rawMeta = json['meta'] ?? dataMap['meta'];
    if (rawMeta is Map<String, dynamic>) {
      parsedMeta = WalletMetaDto.fromJson(rawMeta);
    }

    return WalletDto(
      balance: parsedBalance,
      currency: parsedCurrency,
      items: itemsList,
      meta: parsedMeta,
    );
  }

  WalletData toEntity() {
    return WalletData(
      balance: balance,
      currency: currency,
      items: items.map((e) => e.toEntity()).toList(),
      currentPage: meta?.currentPage ?? 1,
      lastPage: meta?.lastPage ?? 1,
      total: meta?.total ?? items.length,
    );
  }
}

class WalletTransactionDto {
  final String id;
  final String direction;
  final double amount;
  final String note;
  final String createdAt;

  const WalletTransactionDto({
    required this.id,
    required this.direction,
    required this.amount,
    required this.note,
    required this.createdAt,
  });

  factory WalletTransactionDto.fromJson(Map<String, dynamic> json) {
    final rawId = json['id']?.toString() ?? '';
    final rawDirection = json['direction']?.toString() ?? 'credit';

    final rawAmount = json['amount'];
    double parsedAmount = 0.0;
    if (rawAmount is num) {
      parsedAmount = rawAmount.toDouble();
    } else if (rawAmount is String) {
      parsedAmount = double.tryParse(rawAmount) ?? 0.0;
    }

    final rawNote = json['note']?.toString() ?? '';
    final rawCreatedAt = json['created_at']?.toString() ?? '';

    return WalletTransactionDto(
      id: rawId,
      direction: rawDirection,
      amount: parsedAmount,
      note: rawNote,
      createdAt: rawCreatedAt,
    );
  }

  WalletTransaction toEntity() {
    return WalletTransaction(
      id: id,
      direction: direction,
      amount: amount,
      note: note,
      createdAt: createdAt,
    );
  }
}

class WalletMetaDto {
  final int currentPage;
  final int lastPage;
  final int? perPage;
  final int? total;

  const WalletMetaDto({
    required this.currentPage,
    required this.lastPage,
    this.perPage,
    this.total,
  });

  factory WalletMetaDto.fromJson(Map<String, dynamic> json) {
    return WalletMetaDto(
      currentPage: (json['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (json['last_page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
    );
  }
}
