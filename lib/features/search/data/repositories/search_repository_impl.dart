import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:food_user_app/core/errors/exceptions.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/core/network/dio_error_mapper.dart';
import 'package:food_user_app/features/search/data/datasources/search_remote_data_source.dart';
import 'package:food_user_app/features/restaurant/data/models/restaurant_dto.dart';
import 'package:food_user_app/features/search/domain/entities/search_log.dart';
import 'package:food_user_app/features/search/domain/entities/search_keyword.dart';
import 'package:food_user_app/features/search/domain/entities/search_result.dart';
import 'package:food_user_app/features/search/domain/repositories/search_repository.dart';

import 'package:food_user_app/features/restaurant/domain/entities/restaurant.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, SearchResult>> search(
    String query, {
    int? sectionId,
    List<int>? tagIds,
    int? fastPrep,
    int? topRated,
    int? hasOffers,
  }) async {
    try {
      final dto = await remoteDataSource.search(
        query,
        sectionId: sectionId,
        tagIds: tagIds,
        fastPrep: fastPrep,
        topRated: topRated,
        hasOffers: hasOffers,
      );
      return Right(dto.toEntity());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<SearchLog>>> getSearchHistory() async {
    try {
      final history = await remoteDataSource.getSearchHistory();
      return Right(history);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SearchLog>> addSearchLog(String term) async {
    try {
      final log = await remoteDataSource.addSearchLog(term);
      return Right(log);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSearchLog(int id) async {
    try {
      await remoteDataSource.deleteSearchLog(id);
      return const Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> clearSearchLogs() async {
    try {
      await remoteDataSource.clearSearchLogs();
      return const Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<SearchKeyword>>> getSearchKeywords() async {
    try {
      final keywords = await remoteDataSource.getSearchKeywords();
      return Right(keywords);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<Restaurant>>> getMajorStores() async {
    try {
      final dtos = await remoteDataSource.getMajorStores();
      final entities = dtos.map((dto) => dto.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  Failure _mapExceptionToFailure(Object error) {
    if (error is DioException) {
      return _mapExceptionToFailure(DioErrorMapper.map(error));
    }
    if (error is ServerException) return ServerFailure(error.message);
    if (error is NetworkException) return NetworkFailure(error.message);
    if (error is TimeoutException) return TimeoutFailure(error.message);
    if (error is UnauthorizedException) {
      return UnauthorizedFailure(error.message);
    }
    if (error is ValidationException) {
      return ValidationFailure(error.message, errors: error.errors);
    }
    if (error is UnknownException) return UnknownFailure(error.message);
    return UnknownFailure(error.toString());
  }
}
