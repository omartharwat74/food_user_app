import 'package:equatable/equatable.dart';
import 'package:food_user_app/features/auth/domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthStateInitial extends AuthState {
  const AuthStateInitial();
}

class LogoutInProgress extends AuthState {
  const LogoutInProgress();
}

// ── Social Login ─────────────────────────────────────────────────────────────

class SocialLoginInProgress extends AuthState {
  const SocialLoginInProgress();
}

class SocialLoginNewUser extends AuthState {
  final String firstName;
  final String lastName;
  final String email;

  const SocialLoginNewUser({
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  @override
  List<Object?> get props => [firstName, lastName, email];
}

class SocialLoginFailure extends AuthState {
  final String message;

  const SocialLoginFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// ── Session status ────────────────────────────────────────────────────────────

class Authenticated extends AuthState {
  final User user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// User chose to browse without an account.
class AuthGuest extends AuthState {
  const AuthGuest();
}

// ── Phone OTP Flow (New Plezmo API) ──────────────────────────────────────────

// Send OTP
class PhoneOtpSendInProgress extends AuthState {
  const PhoneOtpSendInProgress();
}

/// OTP sent successfully — UI navigates to OTP input screen.
class PhoneOtpSent extends AuthState {
  final String phone;

  const PhoneOtpSent({required this.phone});

  @override
  List<Object?> get props => [phone];
}

class PhoneOtpSendFailure extends AuthState {
  final String message;

  const PhoneOtpSendFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// Verify OTP
class PhoneOtpVerifyInProgress extends AuthState {
  const PhoneOtpVerifyInProgress();
}

/// Existing account verified → session persisted, user signed in.
class PhoneOtpLoginSuccess extends Authenticated {
  const PhoneOtpLoginSuccess(super.user);
}

/// New phone verified → navigate to complete-profile screen.
/// Carries the [registrationToken] and optional [requiredFields] from the API.
class PhoneOtpCompleteProfile extends AuthState {
  final String registrationToken;
  final List<String> requiredFields;

  const PhoneOtpCompleteProfile({
    required this.registrationToken,
    this.requiredFields = const [],
  });

  @override
  List<Object?> get props => [registrationToken, requiredFields];
}

class PhoneOtpVerifyFailure extends AuthState {
  final String message;

  const PhoneOtpVerifyFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Phone needs verification after social login or profile completion.
class PhoneOtpVerificationRequired extends AuthState {
  final String registrationToken;
  final String phone;

  const PhoneOtpVerificationRequired({
    required this.registrationToken,
    required this.phone,
  });

  @override
  List<Object?> get props => [registrationToken, phone];
}

// Complete registration
class CompleteRegistrationInProgress extends AuthState {
  const CompleteRegistrationInProgress();
}

class CompleteRegistrationSuccess extends Authenticated {
  const CompleteRegistrationSuccess(super.user);
}

class CompleteRegistrationFailure extends AuthState {
  final String message;

  const CompleteRegistrationFailure(this.message);

  @override
  List<Object?> get props => [message];
}
