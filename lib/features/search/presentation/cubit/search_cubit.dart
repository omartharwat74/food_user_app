import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/search/domain/repositories/search_repository.dart';
import 'package:food_user_app/features/home/domain/usecases/home_usecases.dart';
import 'package:food_user_app/features/home/domain/entities/tag.dart';
import 'package:food_user_app/features/search/domain/entities/search_log.dart';
import 'package:food_user_app/features/search/domain/entities/search_keyword.dart';
import 'package:food_user_app/features/restaurant/domain/entities/restaurant.dart';
import 'package:dartz/dartz.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository searchRepository;
  final GetTagsUseCase getTagsUseCase;

  List<Tag> tags = [];
  int? selectedTagId;

  SearchCubit({required this.searchRepository, required this.getTagsUseCase})
    : super(const SearchState.initial()) {
    fetchInitialData();
  }

  void toggleTag(int id, String currentQuery) {
    if (selectedTagId == id) {
      selectedTagId = null;
    } else {
      selectedTagId = id;
    }
    search(currentQuery);
  }

  int? fastPrep;
  int? topRated;
  int? hasOffers;

  void resetFilters() {
    selectedTagId = null;
    fastPrep = null;
    topRated = null;
    hasOffers = null;
    fetchInitialData();
  }

  void setFilters({int? fastPrep, int? topRated, int? hasOffers}) {
    this.fastPrep = fastPrep;
    this.topRated = topRated;
    this.hasOffers = hasOffers;
  }

  Future<void> search(String query) async {
    if (query.isEmpty &&
        selectedTagId == null &&
        fastPrep == null &&
        topRated == null &&
        hasOffers == null) {
      state.maybeWhen(
        initialDataLoaded: (h, k, t, m) {
          emit(
            SearchState.initialDataLoaded(
              history: h,
              keywords: k,
              tags: t,
              majorStores: m,
            ),
          );
        },
        orElse: () {
          fetchInitialData();
        },
      );
      return;
    }
    emit(const SearchState.loading());
    final tagIds = selectedTagId != null ? [selectedTagId!] : null;
    final result = await searchRepository.search(
      query,
      tagIds: tagIds,
      fastPrep: fastPrep,
      topRated: topRated,
      hasOffers: hasOffers,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(SearchState.error(failure.message)),
      (searchResult) => emit(SearchState.loaded(searchResult)),
    );
  }

  Future<void> fetchInitialData() async {
    emit(const SearchState.loading());

    final results = await Future.wait([
      searchRepository.getSearchHistory(),
      searchRepository.getSearchKeywords(),
      getTagsUseCase(const GetTagsParams()),
      searchRepository.getMajorStores(),
    ]);

    if (isClosed) return;

    final historyResult = results[0] as Either<Failure, List<SearchLog>>;
    final keywordsResult = results[1] as Either<Failure, List<SearchKeyword>>;
    final tagsResult = results[2] as Either<Failure, List<Tag>>;
    final majorStoresResult = results[3] as Either<Failure, List<Restaurant>>;

    final history = historyResult.fold((l) => <SearchLog>[], (r) => r);
    final keywords = keywordsResult.fold((l) => <SearchKeyword>[], (r) => r);

    // Save tags persistently in Cubit
    tags = tagsResult.fold((l) => <Tag>[], (r) => r);
    final majorStores = majorStoresResult.fold((l) => <Restaurant>[], (r) => r);

    emit(
      SearchState.initialDataLoaded(
        history: history,
        keywords: keywords,
        tags: tags,
        majorStores: majorStores,
      ),
    );
  }

  Future<void> addSearchLog(String term) async {
    // Just call API silently
    await searchRepository.addSearchLog(term);
  }

  Future<void> deleteSearchLog(int id) async {
    final currentState = state;

    state.maybeWhen(
      initialDataLoaded: (history, keywords, tags, majorStores) async {
        final updatedHistory = history.where((log) => log.id != id).toList();
        emit(
          SearchState.initialDataLoaded(
            history: updatedHistory,
            keywords: keywords,
            tags: tags,
            majorStores: majorStores,
          ),
        );

        final result = await searchRepository.deleteSearchLog(id);
        if (result.isLeft()) {
          emit(currentState);
        }
      },
      orElse: () {},
    );
  }

  Future<void> clearSearchLogs() async {
    state.maybeWhen(
      initialDataLoaded: (_, keywords, tags, majorStores) {
        emit(
          SearchState.initialDataLoaded(
            history: const [],
            keywords: keywords,
            tags: tags,
            majorStores: majorStores,
          ),
        );
      },
      orElse: () {
        emit(
          const SearchState.initialDataLoaded(
            history: [],
            keywords: [],
            tags: [],
            majorStores: [],
          ),
        );
      },
    );
    await searchRepository.clearSearchLogs();
  }
}
