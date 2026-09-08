import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:food_user_app/core/errors/exceptions.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/core/network/dio_error_mapper.dart';
import 'package:food_user_app/features/home/data/datasources/home_remote_data_source.dart';
import 'package:food_user_app/features/home/domain/entities/app_settings.dart';
import 'package:food_user_app/features/home/domain/entities/section.dart';
import 'package:food_user_app/features/home/domain/entities/store.dart';
import 'package:food_user_app/features/home/domain/entities/tag.dart';
import 'package:food_user_app/features/home/domain/entities/spotlight.dart';
import 'package:food_user_app/features/home/data/models/spotlight_dto.dart';
import 'package:food_user_app/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({required this.remoteDataSource});

  final HomeRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, AppSettings>> getGeneralSettings() async {
    try {
      final settings = await remoteDataSource.getGeneralSettings();
      return Right(settings);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<Section>>> getSections() async {
    try {
      final sections = await remoteDataSource.getSections();
      return Right(sections);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<Tag>>> getTags({int? sectionId}) async {
    try {
      final tags = await remoteDataSource.getTags(sectionId: sectionId);
      return Right(tags);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, StoreListResult>> getStores({
    required int sectionId,
    String? search,
    List<int>? tagIds,
    int page = 1,
    int perPage = 10,
    int? fastPrep,
    int? topRated,
    int? hasOffers,
  }) async {
    try {
      final result = await remoteDataSource.getStores(
        sectionId: sectionId,
        search: search,
        tagIds: tagIds,
        page: page,
        perPage: perPage,
        fastPrep: fastPrep,
        topRated: topRated,
        hasOffers: hasOffers,
      );
      return Right(result);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, StoreListResult>> getMajorStores({
    required int sectionId,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final result = await remoteDataSource.getMajorStores(
        sectionId: sectionId,
        page: page,
        perPage: perPage,
      );
      return Right(result);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<Spotlight>>> getSpotlights({int? sectionId}) async {
    try {
      final spotlightsDto = await remoteDataSource.getSpotlights(sectionId: sectionId);
      final spotlights = spotlightsDto.map((dto) => dto.toEntity()).toList();
      return Right(spotlights);
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
    if (error is UnauthorizedException) return UnauthorizedFailure(error.message);
    if (error is ValidationException) {
      return ValidationFailure(error.message, errors: error.errors);
    }
    if (error is UnknownException) return UnknownFailure(error.message);
    return UnknownFailure(error.toString());
  }
}
