import 'package:equatable/equatable.dart';
import '../../domain/entities/market.dart';

abstract class MarketsListState extends Equatable {
  const MarketsListState();

  @override
  List<Object?> get props => [];
}

class MarketsListInitial extends MarketsListState {
  const MarketsListInitial();
}

class MarketsListLoading extends MarketsListState {
  const MarketsListLoading();
}

class MarketsListLoaded extends MarketsListState {
  final List<Market> markets;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;
  final String? searchQuery;
  final bool? pickupFilter;
  final bool? availableFilter;

  const MarketsListLoaded({
    required this.markets,
    required this.currentPage,
    required this.hasMore,
    this.isLoadingMore = false,
    this.searchQuery,
    this.pickupFilter,
    this.availableFilter,
  });

  MarketsListLoaded copyWith({
    List<Market>? markets,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
    String? searchQuery,
    bool? pickupFilter,
    bool? availableFilter,
  }) {
    return MarketsListLoaded(
      markets: markets ?? this.markets,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      searchQuery: searchQuery ?? this.searchQuery,
      pickupFilter: pickupFilter ?? this.pickupFilter,
      availableFilter: availableFilter ?? this.availableFilter,
    );
  }

  @override
  List<Object?> get props => [
    markets,
    currentPage,
    hasMore,
    isLoadingMore,
    searchQuery,
    pickupFilter,
    availableFilter,
  ];
}

class MarketsListError extends MarketsListState {
  final String message;

  const MarketsListError(this.message);

  @override
  List<Object?> get props => [message];
}
