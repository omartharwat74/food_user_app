import 'package:dartz/dartz.dart';
import 'package:food_user_app/core/errors/exceptions.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/features/store/data/datasources/store_remote_data_source.dart';
import 'package:food_user_app/features/store/data/models/hyper_categories_response.dart';
import 'package:food_user_app/features/store/data/models/hyper_sections_response.dart';
import 'package:food_user_app/features/store/data/models/store_search_response.dart';
import 'package:food_user_app/features/store/domain/repositories/store_repository.dart';

class StoreRepositoryImpl implements StoreRepository {
  final StoreRemoteDataSource remoteDataSource;

  StoreRepositoryImpl({required this.remoteDataSource});

  Failure _mapExceptionToFailure(Object e) {
    if (e is UnauthorizedException) {
      return UnauthorizedFailure(e.message);
    } else if (e is NetworkException) {
      return NetworkFailure(e.message);
    } else if (e is TimeoutException) {
      return TimeoutFailure(e.message);
    } else if (e is ServerException) {
      return ServerFailure(e.message);
    } else if (e is ValidationException) {
      return ValidationFailure(e.message, errors: e.errors);
    } else {
      return UnknownFailure(e.toString());
    }
  }

  @override
  Future<Either<Failure, HyperCategoriesResponse>> getStoreCategories(String storeId) async {
    try {
      final response = await remoteDataSource.getStoreCategories(storeId);
      return Right(response);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, HyperSectionsResponse>> getStoreCategorySections({
    required String storeId,
    required String categoryId,
  }) async {
    try {
      final response = await remoteDataSource.getStoreCategorySections(
        storeId: storeId,
        categoryId: categoryId,
      );
      return Right(response);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, StoreSearchResponse>> searchProducts({
    required String storeId,
    required String query,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final response = await remoteDataSource.searchProducts(
        storeId: storeId,
        query: query,
        page: page,
        perPage: perPage,
      );
      return Right(response);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }
}
