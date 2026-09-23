import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:food_user_app/core/errors/exceptions.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/core/network/dio_error_mapper.dart';
import 'package:food_user_app/features/address/data/datasources/address_remote_data_source.dart';
import 'package:food_user_app/features/address/data/models/create_address_request.dart';
import 'package:food_user_app/features/address/domain/entities/address.dart';
import 'package:food_user_app/features/address/domain/models/address_request.dart';
import 'package:food_user_app/features/address/domain/repositories/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource remoteDataSource;

  AddressRepositoryImpl({required this.remoteDataSource});

  /// Maps a pure-domain [AddressRequest] into the data-layer DTO.
  CreateAddressRequest _toDto(AddressRequest r) => CreateAddressRequest(
    name: r.label,
    fullAddress: r.fullAddress,
    buildingNumber: r.buildingNumber,
    floor: r.floor,
    apartment: r.apartment,
    lat: r.lat,
    lng: r.lng,
    type: r.addressType?.toLowerCase() == 'primary'
        ? 'primary'
        : r.addressType?.toLowerCase() == 'work'
        ? 'work'
        : 'other',
  );

  @override
  Future<Either<Failure, List<Address>>> getAddresses() async {
    try {
      final dtos = await remoteDataSource.getAddresses();
      final entities = dtos.map((dto) => dto.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Address>> createAddress(AddressRequest request) async {
    try {
      final dto = await remoteDataSource.createAddress(_toDto(request));
      return Right(dto.toEntity());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Address>> updateAddress({
    required String id,
    required AddressRequest request,
  }) async {
    try {
      final dto = await remoteDataSource.updateAddress(
        id: id,
        request: _toDto(request),
      );
      return Right(dto.toEntity());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAddress(String id) async {
    try {
      await remoteDataSource.deleteAddress(id);
      return const Right(unit);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Address>> setDefaultAddress(String id) async {
    try {
      final dto = await remoteDataSource.setDefaultAddress(id);
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
