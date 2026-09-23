import 'user_model.dart';

/// Envelope for a fully-authenticated session from the Plezmo API.
///
/// Returned by:
/// - `POST /api/v1/auth/phone/verify-otp` when `data.status == "authenticated"`
/// - `POST /api/v1/auth/complete-profile`
/// - `POST /api/v1/auth/firebase` (social login)
///
/// New API shape inside `data`:
/// ```json
/// {
///   "status": "authenticated",
///   "access_token": "...",
///   "user": {
///     "id": 1,
///     "first_name": "Omar",
///     "last_name": "Tharwat",
///     "full_name": "Omar Tharwat",
///     "email": "omar@example.com",
///     "phone": "+201012345678",
///     "auth_provider": "phone",
///     "is_notify": 1
///   }
/// }
/// ```
class AuthResponseModel {
  final String accessToken;
  final UserModel user;

  /// The `status` field from the `data` object, if present.
  final String? status;

  const AuthResponseModel({
    required this.accessToken,
    required this.user,
    this.status,
  });

  /// Parses from the `data` JSON object of a verified/authenticated response.
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    String str(String key) {
      final v = json[key];
      if (v == null) return '';
      return v.toString().trim();
    }

    // access_token may be at root or inside json directly
    final token = str('access_token') != ''
        ? str('access_token')
        : str('accessToken');

    final userJson = json['user'];
    final UserModel user;
    if (userJson is Map<String, dynamic>) {
      user = UserModel.fromJson(userJson);
    } else {
      // Fallback: try to build user from flat fields (backward compat)
      user = UserModel.fromJson(json);
    }

    return AuthResponseModel(
      accessToken: token,
      user: user,
      status: str('status') != '' ? str('status') : null,
    );
  }

  bool get hasAccessToken => accessToken.isNotEmpty;

  // ── Backward compat getters used by AuthRepositoryImpl ────────────────────
  String get userId => user.id;
  String? get email => user.email;
  String? get phone => user.phone;
  String? get role => user.role;

  /// Always false now — new API never returns newUser; instead the `data.status`
  /// field on verify-otp returns `"complete_profile"` for new users.
  bool get newUser => false;
}
