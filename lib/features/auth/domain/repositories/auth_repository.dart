import 'package:dartz/dartz.dart' show Either, Unit;
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/features/auth/domain/entities/user.dart';
import 'package:food_user_app/features/auth/data/models/general_settings_model.dart';

/// Outcome of verifying a phone OTP in the unified flow.
///
/// - [isAuthenticated] true  → session persisted, [user] is set.
/// - [isAuthenticated] false → new user; navigate to complete-profile.
///   In that case [registrationToken] and [requiredFields] are set.
class AuthFlowResult {
  final bool isAuthenticated;
  final bool needsPhoneVerification;
  final User? user;

  /// One-time token required to call `complete-profile` or `verify-otp`. Non-null when !isAuthenticated.
  final String? registrationToken;

  /// List of required fields for profile completion. Non-null when !isAuthenticated and !needsPhoneVerification.
  final List<String>? requiredFields;

  const AuthFlowResult({
    required this.isAuthenticated,
    this.needsPhoneVerification = false,
    this.user,
    this.registrationToken,
    this.requiredFields,
  });
}

abstract class AuthRepository {


  /// Returns the locally cached user (if any), or `null` when not signed in.
  Future<Either<Failure, User?>> getCachedUser();

  /// Returns the locally cached access token (if any), or `null`.
  Future<Either<Failure, String?>> getCachedToken();

  /// Minimal session check: `true` when both an access token and a cached
  /// user are present. Does NOT validate token expiry or refresh.
  Future<bool> get isLoggedIn;

  /// Calls remote logout when possible, then always clears local session.
  Future<Either<Failure, Unit>> logout();

  // ── Phone OTP Flow (New Plezmo API) ────────────────────────────────────

  /// `POST /api/v1/auth/phone/send-otp` — sends OTP to [phone].
  Future<Either<Failure, void>> sendPhoneOtp({required String phone});

  /// `POST /api/v1/auth/phone/verify-otp` — verifies OTP for [phone].
  /// - Existing user: session persisted, returns [AuthFlowResult.isAuthenticated] = true.
  /// - New user: returns [AuthFlowResult.isAuthenticated] = false with [registrationToken].
  Future<Either<Failure, AuthFlowResult>> verifyPhoneOtp({
    required String phone,
    required String otp,
    String? registrationToken,
  });

  /// `POST /api/v1/auth/complete-profile` — completes profile using [registrationToken].
  Future<Either<Failure, AuthFlowResult>> completeRegistration({
    required String registrationToken,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
  });

  /// `PATCH /api/v1/auth/update-fcm` — registers/updates FCM token.
  Future<Either<Failure, void>> updateFcm({
    required String fcmToken,
  });

  /// Handshake with backend for social login
  Future<Either<Failure, AuthFlowResult>> loginWithFirebase({
    required String idToken,
  });

  /// `GET /api/v1/general-settings`
  Future<Either<Failure, GeneralSettings>> getGeneralSettings();
}
