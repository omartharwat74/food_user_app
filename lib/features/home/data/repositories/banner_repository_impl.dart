import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:food_user_app/core/errors/exceptions.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/core/network/dio_error_mapper.dart';
import 'package:food_user_app/features/home/data/datasources/banner_remote_data_source.dart';
import 'package:food_user_app/features/home/domain/entities/banner.dart';
import 'package:food_user_app/features/home/domain/repositories/banner_repository.dart';

class BannerRepositoryImpl implements BannerRepository {
  final BannerRemoteDataSource remoteDataSource;

  BannerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<BannerItem>>> getActiveBanners() async {
    try {
      // BannerModel extends BannerItem — direct upcast is fine
      final models = await remoteDataSource.getActiveBanners();
      return Right(models);
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
    if (error is UnauthorizedException)
      return UnauthorizedFailure(error.message);
    if (error is ValidationException) {
      return ValidationFailure(error.message, errors: error.errors);
    }
    if (error is UnknownException) return UnknownFailure(error.message);
    return UnknownFailure(error.toString());
  }
}
