import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:food_user_app/core/errors/exceptions.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/core/network/dio_error_mapper.dart';
import 'package:food_user_app/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:food_user_app/features/cart/data/models/cart_response_dto.dart';
import 'package:food_user_app/features/cart/data/models/promo_preview_response_dto.dart';
import 'package:food_user_app/features/cart/domain/entities/cart.dart';
import 'package:food_user_app/features/cart/domain/entities/promo.dart';
import 'package:food_user_app/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Cart>> getCart() async {
    try {
      final dto = await remoteDataSource.getCart();
      return Right(dto.toEntity());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Cart>> addToCart({
    required String productId,
    required int quantity,
    required List<int> optionValueIds,
  }) async {
    try {
      final dto = await remoteDataSource.addItem(
        productId: productId,
        quantity: quantity,
        optionValueIds: optionValueIds,
      );
      return Right(dto.toEntity());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Cart>> updateCartItem({
    required String itemId,
    required int quantity,
  }) async {
    try {
      final dto = await remoteDataSource.updateCartItem(
        itemId: itemId,
        quantity: quantity,
      );
      return Right(dto.toEntity());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Cart>> removeFromCart(String itemId) async {
    try {
      final dto = await remoteDataSource.removeFromCart(itemId);
      return Right(dto.toEntity());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearCart() async {
    try {
      await remoteDataSource.clearCart();
      return const Right(unit);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Promo>> applyPromo({
    required String code,
    required double subtotal,
  }) async {
    try {
      final dto = await remoteDataSource.applyPromo(
        code: code,
        subtotal: subtotal,
      );
      return Right(dto.toEntity(code));
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
