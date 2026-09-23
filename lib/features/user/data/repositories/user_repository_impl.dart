// ignore_for_file: unused_import
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:food_user_app/core/errors/exceptions.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/core/network/dio_error_mapper.dart';
import 'package:food_user_app/features/user/data/datasources/user_remote_data_source.dart';
import 'package:food_user_app/features/user/data/models/update_user_profile_request.dart';
import 'package:food_user_app/features/user/data/models/update_user_settings_request.dart';
import 'package:food_user_app/features/user/data/models/user_profile_dto.dart';
import 'package:food_user_app/features/user/data/models/user_settings_dto.dart';
import 'package:food_user_app/features/user/domain/entities/user_profile.dart';
import 'package:food_user_app/features/user/domain/entities/user_settings.dart';
import 'package:food_user_app/features/user/domain/models/update_profile_request.dart';
import 'package:food_user_app/features/user/domain/models/update_settings_request.dart';
import 'package:food_user_app/features/user/domain/repositories/user_repository.dart';

import 'package:food_user_app/features/user/data/datasources/user_local_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  /// Maps a pure-domain [UpdateProfileRequest] to the data-layer DTO.
  UpdateUserProfileRequest _toProfileDto(UpdateProfileRequest r) =>
      UpdateUserProfileRequest(
        firstName: r.firstName,
        lastName: r.lastName,
        email: r.email,
        avatar: r.avatar,
        locale: r.locale,
      );

  /// Maps a pure-domain [UpdateSettingsRequest] to the data-layer DTO.
  UpdateUserSettingsRequest _toSettingsDto(UpdateSettingsRequest r) =>
      UpdateUserSettingsRequest(
        locale: r.locale,
        pushNotifications: r.pushNotifications,
        smsNotifications: r.smsNotifications,
        emailNotifications: r.emailNotifications,
        theme: r.theme,
      );

  @override
  Future<Either<Failure, UserProfile>> getProfile() async {
    try {
      final dto = await remoteDataSource.getProfile();
      await localDataSource.cacheProfile(dto);
      return Right(dto.toEntity());
    } catch (e) {
      final cached = await localDataSource.getCachedProfile();
      if (cached != null) {
        return Right(cached.toEntity());
      }
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateProfile(
    UpdateProfileRequest request,
  ) async {
    try {
      final dto = await remoteDataSource.updateProfile(_toProfileDto(request));
      await localDataSource.cacheProfile(dto);
      return Right(dto.toEntity());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UserSettings>> getSettings() async {
    try {
      final dto = await remoteDataSource.getSettings();
      await localDataSource.cacheSettings(dto);
      return Right(dto.toEntity());
    } catch (e) {
      final cached = await localDataSource.getCachedSettings();
      if (cached != null) {
        return Right(cached.toEntity());
      }
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UserSettings>> updateSettings(
    UpdateSettingsRequest request,
  ) async {
    try {
      final dto = await remoteDataSource.updateSettings(
        _toSettingsDto(request),
      );
      await localDataSource.cacheSettings(dto);
      return Right(dto.toEntity());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAccount() async {
    try {
      await remoteDataSource.deleteAccount();
      return const Right(unit);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> sendCurrentPhoneOtp() async {
    try {
      await remoteDataSource.sendCurrentPhoneOtp();
      return const Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> verifyCurrentPhoneOtp(String otp) async {
    try {
      final token = await remoteDataSource.verifyCurrentPhoneOtp(otp);
      return Right(token);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> sendNewPhoneOtp(
    String token,
    String newPhone,
  ) async {
    try {
      await remoteDataSource.sendNewPhoneOtp(token, newPhone);
      return const Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> verifyNewPhoneOtp(
    String token,
    String newPhone,
    String otp,
  ) async {
    try {
      final dto = await remoteDataSource.verifyNewPhoneOtp(
        token,
        newPhone,
        otp,
      );
      await localDataSource.cacheProfile(dto);
      return Right(dto.toEntity());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UserProfile?>> getCachedProfile() async {
    try {
      final cached = await localDataSource.getCachedProfile();
      return Right(cached?.toEntity());
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UserSettings?>> getCachedSettings() async {
    try {
      final cached = await localDataSource.getCachedSettings();
      return Right(cached?.toEntity());
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
