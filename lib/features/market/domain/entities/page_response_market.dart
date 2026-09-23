import 'package:equatable/equatable.dart';
import 'market.dart';

class PageResponseMarket extends Equatable {
  final List<Market> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool last;

  const PageResponseMarket({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.last,
  });

  @override
  List<Object?> get props => [
    content,
    page,
    size,
    totalElements,
    totalPages,
    last,
  ];
}
