import 'package:food_user_app/features/order/data/models/order_dto.dart';
import 'package:food_user_app/features/order/domain/entities/orders_paginated_data.dart';

int _parseInt(dynamic value, [int defaultValue = 0]) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? defaultValue;
  return defaultValue;
}

class OrdersPaginatedDto {
  final List<OrderDto> items;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final String? message;

  const OrdersPaginatedDto({
    required this.items,
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 10,
    this.total = 0,
    this.message,
  });

  factory OrdersPaginatedDto.fromJson(Map<String, dynamic> json) {
    final msg = json['msg']?.toString();
    final rawData = json['data'];

    List<dynamic> rawItems = const [];
    Map<String, dynamic>? rawMeta;

    if (rawData is Map<String, dynamic>) {
      if (rawData['items'] is List) {
        rawItems = rawData['items'] as List;
      }
      if (rawData['meta'] is Map<String, dynamic>) {
        rawMeta = rawData['meta'] as Map<String, dynamic>;
      }
    } else if (rawData is List) {
      rawItems = rawData;
    } else if (json['content'] is List) {
      rawItems = json['content'] as List;
    }

    final items = rawItems
        .whereType<Map<String, dynamic>>()
        .map((e) => OrderDto.fromJson(e))
        .toList();

    return OrdersPaginatedDto(
      items: items,
      currentPage: rawMeta != null ? _parseInt(rawMeta['current_page'], 1) : 1,
      lastPage: rawMeta != null ? _parseInt(rawMeta['last_page'], 1) : 1,
      perPage: rawMeta != null ? _parseInt(rawMeta['per_page'], 10) : 10,
      total: rawMeta != null ? _parseInt(rawMeta['total'], items.length) : items.length,
      message: msg,
    );
  }

  OrdersPaginatedData toEntity() {
    return OrdersPaginatedData(
      items: items.map((e) => e.toEntity()).toList(),
      currentPage: currentPage,
      lastPage: lastPage,
      perPage: perPage,
      total: total,
    );
  }
}
