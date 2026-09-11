import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:food_user_app/core/errors/exceptions.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/core/network/dio_error_mapper.dart';
import 'package:food_user_app/core/network/network_info.dart';
import 'package:food_user_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:food_user_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:food_user_app/features/auth/data/models/auth_response_model.dart';
import 'package:food_user_app/features/auth/data/models/general_settings_model.dart';
import 'package:food_user_app/features/auth/domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  // ── Session helpers ──────────────────────────────────────────────────────

  @override
  Future<Either<Failure, User?>> getCachedUser() async {
    try {
      final user = await localDataSource.getCachedUser();
      return Right(user);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getCachedToken() async {
    try {
      final token = await localDataSource.getAccessToken();
      return Right(token);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<bool> get isLoggedIn async {
    try {
      final token = await localDataSource.getAccessToken();
      if (token == null || token.isEmpty) return false;
      final user = await localDataSource.getCachedUser();
      return user != null;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    // Best-effort remote logout — local session is cleared regardless.
    if (await networkInfo.isConnected) {
      try {
        // device_id is empty string as best-effort — caller can pass it via updateFcm separately
        await remoteDataSource.logout();
      } catch (_) {}
    }
    await _clearLocalSession();
    return const Right(unit);
  }

  // ── Phone OTP Flow ────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, void>> sendPhoneOtp({required String phone}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      await remoteDataSource.sendPhoneOtp(phone: phone);
      return const Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, AuthFlowResult>> verifyPhoneOtp({
    required String phone,
    required String otp,
    String? registrationToken,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final result = await remoteDataSource.verifyPhoneOtp(
        phone: phone,
        otp: otp,
        registrationToken: registrationToken,
      );

      if (result.isAuthenticated && result.authResponse != null) {
        await _persistSession(result.authResponse!);
        return Right(
          AuthFlowResult(
            isAuthenticated: true,
            user: result.authResponse!.user,
          ),
        );
      }

      // status == "complete_profile"
      return Right(
        AuthFlowResult(
          isAuthenticated: false,
          registrationToken: result.registrationToken,
          requiredFields: result.requiredFields,
        ),
      );
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, AuthFlowResult>> completeRegistration({
    required String registrationToken,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final authFlow = await remoteDataSource.completeProfile(
        registrationToken: registrationToken,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
      );

      if (authFlow.isAuthenticated && authFlow.authResponse != null) {
        await _persistSession(authFlow.authResponse!);
      }

      return Right(AuthFlowResult(
        isAuthenticated: authFlow.isAuthenticated,
        needsPhoneVerification: authFlow.needsPhoneVerification,
        user: authFlow.authResponse?.user,
        registrationToken: authFlow.registrationToken,
        requiredFields: authFlow.requiredFields,
      ));
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateFcm({
    required String fcmToken,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      await remoteDataSource.updateFcm(
        fcmToken: fcmToken,
      );
      return const Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, AuthFlowResult>> loginWithFirebase({
    required String idToken,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final authFlow = await remoteDataSource.loginWithFirebase(
        idToken: idToken,
      );
      
      if (authFlow.isAuthenticated && authFlow.authResponse != null) {
        await _persistSession(authFlow.authResponse!);
      }

      return Right(AuthFlowResult(
        isAuthenticated: authFlow.isAuthenticated,
        needsPhoneVerification: authFlow.needsPhoneVerification,
        user: authFlow.authResponse?.user,
        registrationToken: authFlow.registrationToken,
        requiredFields: authFlow.requiredFields,
      ));
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  // ── Private helpers ──────────────────────────────────────────────────────

  Future<void> _clearLocalSession() async {
    await localDataSource.clearTokens();
    await localDataSource.clearCachedUser();
  }

  Future<void> _persistSession(AuthResponseModel auth) async {
    if (auth.hasAccessToken) {
      await localDataSource.cacheAccessToken(auth.accessToken);
    }
    await localDataSource.cacheUser(auth.user);
  }

  Failure _mapExceptionToFailure(Object error) {
    if (error is DioException) {
      return _mapExceptionToFailure(DioErrorMapper.map(error));
    }
    if (error is AuthException) return AuthFailure(error.message);
    if (error is ServerException) return ServerFailure(error.message);
    if (error is NetworkException) return NetworkFailure(error.message);
    if (error is TimeoutException) return TimeoutFailure(error.message);
    if (error is UnauthorizedException) return UnauthorizedFailure(error.message);
    if (error is ValidationException) {
      return ValidationFailure(error.message, errors: error.errors);
    }
    if (error is UnknownException) return UnknownFailure(error.message);
    if (error is CacheException) return CacheFailure(error.message);
    return UnknownFailure(error.toString());
  }

  @override
  Future<Either<Failure, GeneralSettings>> getGeneralSettings() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final result = await remoteDataSource.getGeneralSettings();
      return Right(result);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }
}
