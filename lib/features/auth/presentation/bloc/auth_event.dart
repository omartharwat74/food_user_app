import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Splash-time session check. Reads cached token + user and emits either
/// [Authenticated] or [Unauthenticated].
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class SocialLoginRequested extends AuthEvent {
  final String provider;

  const SocialLoginRequested({required this.provider});

  @override
  List<Object?> get props => [provider];
}

// ── Phone OTP Flow (New Plezmo API) ──────────────────────────────────────────

/// `POST /api/v1/auth/phone/send-otp` — request a code for [phone].
class PhoneOtpRequested extends AuthEvent {
  final String phone;

  const PhoneOtpRequested({required this.phone});

  @override
  List<Object?> get props => [phone];
}

/// `POST /api/v1/auth/phone/verify-otp` — verify [otp] for [phone].
class PhoneOtpVerifySubmitted extends AuthEvent {
  final String phone;
  final String otp;
  final String? registrationToken;

  const PhoneOtpVerifySubmitted({
    required this.phone,
    required this.otp,
    this.registrationToken,
  });

  @override
  List<Object?> get props => [phone, otp, registrationToken];
}

/// `POST /api/v1/auth/complete-profile` — finish profile for a new user.
class CompleteRegistrationSubmitted extends AuthEvent {
  /// One-time token received from the verify-otp `complete_profile` response.
  final String registrationToken;

  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;

  const CompleteRegistrationSubmitted({
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
