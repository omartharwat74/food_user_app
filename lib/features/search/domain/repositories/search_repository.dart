import 'package:dartz/dartz.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/features/search/domain/entities/search_result.dart';

import 'package:food_user_app/features/search/domain/entities/search_log.dart';
import 'package:food_user_app/features/search/domain/entities/search_keyword.dart';
import 'package:food_user_app/features/restaurant/domain/entities/restaurant.dart';

abstract class SearchRepository {
  Future<Either<Failure, SearchResult>> search(
    String query, {
    int? sectionId,
    List<int>? tagIds,
    int? fastPrep,
    int? topRated,
    int? hasOffers,
  });
  Future<Either<Failure, List<SearchLog>>> getSearchHistory();
  Future<Either<Failure, SearchLog>> addSearchLog(String term);
  Future<Either<Failure, void>> deleteSearchLog(int id);
  Future<Either<Failure, void>> clearSearchLogs();
  Future<Either<Failure, List<SearchKeyword>>> getSearchKeywords();
  Future<Either<Failure, List<Restaurant>>> getMajorStores();
}
