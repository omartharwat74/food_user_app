import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:food_user_app/core/errors/exceptions.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/core/network/dio_error_mapper.dart';
import 'package:food_user_app/features/restaurant/data/datasources/restaurant_remote_data_source.dart';
import 'package:food_user_app/features/restaurant/data/models/branch_dto.dart';
import 'package:food_user_app/features/restaurant/data/models/offer_dto.dart';
import 'package:food_user_app/features/restaurant/data/models/page_response_restaurant_dto.dart';
import 'package:food_user_app/features/restaurant/data/models/restaurant_dto.dart';
import 'package:food_user_app/features/restaurant/domain/entities/branch.dart';
import 'package:food_user_app/features/restaurant/domain/entities/offer.dart';
import 'package:food_user_app/features/restaurant/domain/entities/page_response_restaurant.dart';
import 'package:food_user_app/features/restaurant/domain/entities/restaurant.dart';
import 'package:food_user_app/features/restaurant/domain/repositories/restaurant_repository.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantRemoteDataSource remoteDataSource;

  RestaurantRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PageResponseRestaurant>> getRestaurants({
    int page = 0,
    int size = 20,
    String? categoryId,
  }) async {
    try {
      final dto = await remoteDataSource.getRestaurants(
        page: page,
        size: size,
        categoryId: categoryId,
      );
      return Right(dto.toEntity());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Restaurant>> getRestaurantDetail(String id) async {
    try {
      final dto = await remoteDataSource.getRestaurantDetail(id);
      return Right(dto.toEntity());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Restaurant>> getStoreDetails(String storeId) async {
    try {
      final dto = await remoteDataSource.getStoreDetails(storeId);
      return Right(dto.toEntity());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<Branch>>> getBranches(String restaurantId) async {
    try {
      final dtos = await remoteDataSource.getBranches(restaurantId);
      return Right(dtos.map((dto) => dto.toEntity()).toList());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<Offer>>> getOffers(String restaurantId) async {
    try {
      final dtos = await remoteDataSource.getOffers(restaurantId);
      return Right(dtos.map((dto) => dto.toEntity()).toList());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<Restaurant>>> getFavorites() async {
    try {
      final dtos = await remoteDataSource.getFavorites();
      return Right(dtos.map((dto) => dto.toEntity()).toList());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> toggleFavorite(String id) async {
    try {
      await remoteDataSource.toggleFavorite(id);
      return const Right(unit);
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
