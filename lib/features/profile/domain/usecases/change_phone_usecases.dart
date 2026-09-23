import 'package:dartz/dartz.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/core/usecases/usecase.dart';
import 'package:food_user_app/features/user/domain/entities/user_profile.dart';
import 'package:food_user_app/features/user/domain/repositories/user_repository.dart';

class SendCurrentPhoneOtpUseCase extends UseCase<void, NoParams> {
  final UserRepository repository;
  SendCurrentPhoneOtpUseCase(this.repository);
  @override
  Future<Either<Failure, void>> call(NoParams params) =>
      repository.sendCurrentPhoneOtp();
}

class VerifyCurrentPhoneOtpUseCase extends UseCase<String, String> {
  final UserRepository repository;
  VerifyCurrentPhoneOtpUseCase(this.repository);
  @override
  Future<Either<Failure, String>> call(String otp) =>
      repository.verifyCurrentPhoneOtp(otp);
}

class SendNewPhoneOtpParams {
  final String token;
  final String phone;
  SendNewPhoneOtpParams({required this.token, required this.phone});
}

class SendNewPhoneOtpUseCase extends UseCase<void, SendNewPhoneOtpParams> {
  final UserRepository repository;
  SendNewPhoneOtpUseCase(this.repository);
  @override
  Future<Either<Failure, void>> call(SendNewPhoneOtpParams params) =>
      repository.sendNewPhoneOtp(params.token, params.phone);
}

class VerifyNewPhoneOtpParams {
  final String token;
  final String phone;
  final String otp;
  VerifyNewPhoneOtpParams({
    required this.token,
    required this.phone,
    required this.otp,
  });
}

class VerifyNewPhoneOtpUseCase
    extends UseCase<UserProfile, VerifyNewPhoneOtpParams> {
  final UserRepository repository;
  VerifyNewPhoneOtpUseCase(this.repository);
  @override
  Future<Either<Failure, UserProfile>> call(VerifyNewPhoneOtpParams params) =>
      repository.verifyNewPhoneOtp(params.token, params.phone, params.otp);
}
