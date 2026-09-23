import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_markets_usecase.dart';
import 'markets_list_state.dart';

class MarketsListCubit extends Cubit<MarketsListState> {
  final GetMarketsUseCase _getMarketsUseCase;

  MarketsListCubit({required GetMarketsUseCase getMarketsUseCase})
    : _getMarketsUseCase = getMarketsUseCase,
      super(const MarketsListInitial());

  String? _currentSearch;
  bool? _pickupFilter;
  bool? _availableFilter;

  Future<void> fetchMarkets({
    String? search,
    bool? pickupAvailable,
    bool? isAvailable,
  }) async {
    _currentSearch = search;
    _pickupFilter = pickupAvailable;
    _availableFilter = isAvailable;

    emit(const MarketsListLoading());

    final result = await _getMarketsUseCase(
      GetMarketsParams(
        search: _currentSearch,
        pickupAvailable: _pickupFilter,
        isAvailable: _availableFilter,
        page: 0,
        size: 20,
      ),
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(MarketsListError(failure.message)),
      (pageData) => emit(
        MarketsListLoaded(
          markets: pageData.content,
          currentPage: pageData.page,
          hasMore: !pageData.last,
          searchQuery: _currentSearch,
          pickupFilter: _pickupFilter,
          availableFilter: _availableFilter,
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! MarketsListLoaded ||
        !currentState.hasMore ||
        currentState.isLoadingMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.currentPage + 1;
    final result = await _getMarketsUseCase(
      GetMarketsParams(
        search: currentState.searchQuery,
        pickupAvailable: currentState.pickupFilter,
        isAvailable: currentState.availableFilter,
        page: nextPage,
        size: 20,
      ),
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(currentState.copyWith(isLoadingMore: false)),
      (pageData) {
        final updatedList = List.of(currentState.markets)
          ..addAll(pageData.content);
        emit(
          currentState.copyWith(
            markets: updatedList,
            currentPage: pageData.page,
            hasMore: !pageData.last,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  void updateSearch(String? search) {
    fetchMarkets(
      search: search,
      pickupAvailable: _pickupFilter,
      isAvailable: _availableFilter,
    );
  }

  void togglePickupFilter() {
    final newValue = _pickupFilter == true ? null : true;
    fetchMarkets(
      search: _currentSearch,
      pickupAvailable: newValue,
      isAvailable: _availableFilter,
    );
  }

  void toggleAvailableFilter() {
    final newValue = _availableFilter == true ? null : true;
    fetchMarkets(
      search: _currentSearch,
      pickupAvailable: _pickupFilter,
      isAvailable: newValue,
    );
  }
}
