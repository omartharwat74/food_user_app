import '../../domain/entities/page_response_market.dart';
import 'market_model.dart';

class PageResponseMarketModel {
  final List<MarketModel> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool last;

  const PageResponseMarketModel({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.last,
  });

  factory PageResponseMarketModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['content'] ?? json['items'] ?? json['data'] ?? [];
    List<MarketModel> markets = [];
    if (rawList is List) {
      markets = rawList
          .whereType<Map<String, dynamic>>()
          .map((e) => MarketModel.fromJson(e))
          .toList();
    }

    final pageNum =
        (json['page'] as num?)?.toInt() ??
        (json['pageNumber'] as num?)?.toInt() ??
        0;
    final sizeNum =
        (json['size'] as num?)?.toInt() ??
        (json['pageSize'] as num?)?.toInt() ??
        markets.length;
    final totalElems =
        (json['totalElements'] as num?)?.toInt() ??
        (json['total'] as num?)?.toInt() ??
        markets.length;
    final totalPg =
        (json['totalPages'] as num?)?.toInt() ??
        (sizeNum > 0 ? (totalElems / sizeNum).ceil() : 1);
    final isLast =
        json['last'] == true ||
        json['isLast'] == true ||
        (pageNum + 1 >= totalPg);

    return PageResponseMarketModel(
      content: markets,
      page: pageNum,
      size: sizeNum,
      totalElements: totalElems,
      totalPages: totalPg,
      last: isLast,
    );
  }

  PageResponseMarket toEntity() {
    return PageResponseMarket(
      content: content.map((e) => e.toEntity()).toList(),
      page: page,
      size: size,
      totalElements: totalElements,
      totalPages: totalPages,
      last: last,
    );
  }
}
