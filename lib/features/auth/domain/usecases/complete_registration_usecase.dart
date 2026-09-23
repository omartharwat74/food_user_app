import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// `POST /api/v1/auth/complete-profile` — finish profile for a verified new user.
class CompleteRegistrationUseCase
    extends UseCase<AuthFlowResult, CompleteRegistrationParams> {
  CompleteRegistrationUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, AuthFlowResult>> call(
    CompleteRegistrationParams params,
  ) {
    return _repository.completeRegistration(
      registrationToken: params.registrationToken,
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
      phone: params.phone,
    );
  }
}

class CompleteRegistrationParams extends Equatable {
  final String registrationToken;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;

  const CompleteRegistrationParams({
    required this.registrationToken,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
  });

  @override
  List<Object?> get props => [
    registrationToken,
    firstName,
    lastName,
    email,
    phone,
  ];
}
