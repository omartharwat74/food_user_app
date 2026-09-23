import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_category.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_item.dart';
import 'package:food_user_app/features/restaurant/domain/repositories/menu_repository.dart';
import 'package:food_user_app/features/store/domain/repositories/store_repository.dart';
import 'package:food_user_app/features/search/presentation/models/results_config.dart';

import 'unified_results_state.dart';

class UnifiedResultsCubit extends Cubit<UnifiedResultsState> {
  final MenuRepository _menuRepository;
  final StoreRepository _storeRepository;

  /// All categories loaded from the backend (or mock). Immutable after load.
  List<MenuCategory> _cachedCategories = [];

  /// Whether the screen was opened in pure Search Mode. Never changes after load.
  bool _originalIsSearchMode = false;

  /// Currently selected subcategory tab index (0 = "الكل" / All).
  int _selectedTabIndex = 0;

  /// The active search query text. Empty string means no active search.
  String _activeQuery = '';

  UnifiedResultsCubit({
    required MenuRepository menuRepository,
    required StoreRepository storeRepository,
  }) : _menuRepository = menuRepository,
       _storeRepository = storeRepository,
       super(const UnifiedResultsState.initial());

  // ─── Load ────────────────────────────────────────────────────────────────────

  Future<void> loadResults(ResultsConfig config) async {
    emit(const UnifiedResultsState.loading());

    try {
      final parentId = config.parentId;
      if (parentId == null || parentId.isEmpty) {
        emit(
          const UnifiedResultsState.error('Missing parent store/restaurant ID'),
        );
        return;
      }

      if (config.isCategoryMode) {
        // Fetch Sections
        final result = await _storeRepository.getStoreCategorySections(
          storeId: parentId,
          categoryId: config.categoryId!,
        );
        if (isClosed) return;

        result.fold(
          (failure) => emit(UnifiedResultsState.error(failure.message)),
          (response) {
            _cachedCategories = response.data.sections.map((section) {
              return MenuCategory(
                id: section.category.id.toString(),
                branchId: '',
                name: section.category.name,
                sortOrder: 0,
                visible: true,
                items: section.products
                    .map(
                      (hp) => MenuItem(
                        id: hp.id.toString(),
                        name: hp.name,
                        description: hp.description ?? '',
                        price: hp.priceAfterDiscount ?? hp.price,
                        originalPrice: hp.price,
                        imageUrl: hp.mainImage ?? '',
                        available: hp.isAvailable,
                        discountValue: 0,
                        discountType: 'none',
                        options: const [],
                        includes: const [],
                      ),
                    )
                    .toList(),
              );
            }).toList();
            _finalizeLoad(config);
          },
        );
      } else {
        // Search Mode (Get all products)
        final result = await _menuRepository.getStoreMenu(parentId);
        if (isClosed) return;

        result.fold(
          (failure) => emit(UnifiedResultsState.error(failure.message)),
          (categories) {
            _cachedCategories = categories;
            _finalizeLoad(config);
          },
        );
      }
    } catch (e) {
      if (isClosed) return;
      emit(UnifiedResultsState.error(e.toString()));
    }
  }

  void _finalizeLoad(ResultsConfig config) {
    _originalIsSearchMode = !config
        .isCategoryMode; // If not category mode, treat as search mode to hide tabs
    _selectedTabIndex = 0;
    _activeQuery = config.searchQuery?.trim() ?? '';

    if (_originalIsSearchMode) {
      final results = _scopedFilter(_activeQuery);
      emit(
        UnifiedResultsState.loaded(
          categories: _cachedCategories,
          searchResults: results,
          isSearchMode: true,
          selectedTabIndex: _selectedTabIndex,
          activeQuery: _activeQuery,
        ),
      );
    } else {
      emit(
        UnifiedResultsState.loaded(
          categories: _cachedCategories,
          searchResults: _tabItems(),
          isSearchMode: false,
          selectedTabIndex: _selectedTabIndex,
          activeQuery: _activeQuery,
        ),
      );
    }
  }

  // ─── Search ───────────────────────────────────────────────────────────────────

  void search(String query) {
    _activeQuery = query.trim();
    final results = _scopedFilter(_activeQuery);

    emit(
      UnifiedResultsState.loaded(
        categories: _cachedCategories,
        searchResults: results,
        isSearchMode: _originalIsSearchMode,
        selectedTabIndex: _selectedTabIndex,
        activeQuery: _activeQuery,
      ),
    );
  }

  // ─── Tab change ───────────────────────────────────────────────────────────────

  void changeCategory(int index) {
    _selectedTabIndex = index;

    // Always re-evaluate with the active query scoped to the new tab.
    final results = _activeQuery.isNotEmpty
        ? _scopedFilter(_activeQuery)
        : _tabItems(); // Use tabItems if no search query!

    emit(
      UnifiedResultsState.loaded(
        categories: _cachedCategories,
        searchResults: results,
        isSearchMode: _originalIsSearchMode,
        selectedTabIndex: _selectedTabIndex,
        activeQuery: _activeQuery,
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────────

  List<MenuItem> _tabItems() {
    if (_selectedTabIndex == 0) {
      return _cachedCategories.expand((c) => c.items).toList();
    }
    final catIndex = _selectedTabIndex - 1;
    if (catIndex < _cachedCategories.length) {
      return _cachedCategories[catIndex].items;
    }
    return [];
  }

  List<MenuItem> _scopedFilter(String query) {
    final pool = _tabItems();
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return pool;
    return pool
        .where(
          (item) =>
              item.name.toLowerCase().contains(q) ||
              item.description.toLowerCase().contains(q),
        )
        .toList();
  }
}
