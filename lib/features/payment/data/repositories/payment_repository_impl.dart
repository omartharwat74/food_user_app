import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:food_user_app/core/errors/exceptions.dart';
import 'package:food_user_app/core/network/dio_error_mapper.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/features/payment/data/datasources/payment_remote_data_source.dart';
import 'package:food_user_app/features/payment/data/models/checkout_request_dto.dart';
import 'package:food_user_app/features/payment/data/models/save_card_request_dto.dart';
import 'package:food_user_app/features/payment/data/models/checkout_response_dto.dart';
import 'package:food_user_app/features/payment/domain/entities/checkout_result.dart';
import 'package:food_user_app/features/payment/domain/entities/payment_card.dart';
import 'package:food_user_app/features/payment/domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<PaymentCard>>> getSavedCards() async {
    try {
      final dtos = await remoteDataSource.getSavedCards();
      final entities = dtos.map((dto) => dto.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PaymentCard>> saveCard(
    SaveCardRequestDto request,
  ) async {
    try {
      final dto = await remoteDataSource.saveCard(request);
      return Right(dto.toEntity());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCard(String cardId) async {
    try {
      await remoteDataSource.deleteCard(cardId);
      return const Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, CheckoutResult>> checkout(
    CheckoutRequestDto request,
  ) async {
    try {
      final dto = await remoteDataSource.checkout(request);
      return Right(dto.toEntity());
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
