import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/store/domain/repositories/store_repository.dart';
import 'store_search_state.dart';

class StoreSearchCubit extends Cubit<StoreSearchState> {
  final StoreRepository _repository;

  Timer? _debounce;
  String? _lastStoreId;
  String? _lastQuery;

  StoreSearchCubit({required StoreRepository repository})
    : _repository = repository,
      super(const StoreSearchInitial());

  /// Triggers a debounced product search (300 ms window).
  /// If the query is empty, it resets to the initial state.
  void search(String storeId, String query) {
    _debounce?.cancel();

    final trimmed = query.trim();

    // Reset to initial when the field is cleared
    if (trimmed.isEmpty) {
      _lastQuery = null;
      emit(const StoreSearchInitial());
      return;
    }

    // Skip re-emitting if nothing changed
    if (trimmed == _lastQuery &&
        storeId == _lastStoreId &&
        state is StoreSearchLoaded) {
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 300), () {
      _performSearch(storeId, trimmed);
    });
  }

  Future<void> _performSearch(String storeId, String query) async {
    if (isClosed) return;
    _lastQuery = query;
    _lastStoreId = storeId;

    emit(const StoreSearchLoading());

    final result = await _repository.searchProducts(
      storeId: storeId,
      query: query,
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(StoreSearchError(failure.message)),
      (response) => emit(
        StoreSearchLoaded(
          products: response.data.products,
          isRandom: response.meta?.isRandom ?? false,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
