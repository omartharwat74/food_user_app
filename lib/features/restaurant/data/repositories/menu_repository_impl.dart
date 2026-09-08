import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:food_user_app/core/errors/exceptions.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/core/network/dio_error_mapper.dart';
import 'package:food_user_app/features/restaurant/data/datasources/menu_remote_data_source.dart';
import 'package:food_user_app/features/restaurant/data/models/menu_category_dto.dart';
import 'package:food_user_app/features/restaurant/data/models/item_modifier_dto.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_category.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_item.dart';
import 'package:food_user_app/features/restaurant/domain/entities/modifier.dart';
import 'package:food_user_app/features/restaurant/domain/repositories/menu_repository.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource remoteDataSource;

  MenuRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<MenuCategory>>> getRestaurantMenu(
    String restaurantId,
  ) async {
    try {
      final dtos = await remoteDataSource.getRestaurantMenu(restaurantId);
      final entities = dtos.map((dto) => dto.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<MenuCategory>>> getBranchMenu(
    String branchId,
  ) async {
    try {
      final dtos = await remoteDataSource.getBranchMenu(branchId);
      final entities = dtos.map((dto) => dto.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<Modifier>>> getItemModifiers(
    String itemId,
  ) async {
    try {
      final dtos = await remoteDataSource.getItemModifiers(itemId);
      final entities = dtos.map((dto) => dto.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<MenuCategory>>> getStoreMenu(String storeId) async {
    try {
      final dto = await remoteDataSource.getStoreMenu(storeId);
      return Right(dto.sections);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, MenuItem>> getProductDetail(String productId) async {
    try {
      final item = await remoteDataSource.getProductDetail(productId);
      return Right(item);
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
