import 'package:food_user_app/features/auth/domain/entities/user.dart';

/// Data model for the user JSON object returned by the Plezmo API.
///
/// New API shape:
/// ```json
/// {
///   "id": 1,
///   "first_name": "Omar",
///   "last_name": "Tharwat",
///   "full_name": "Omar Tharwat",
///   "email": "omar@example.com",
///   "phone": "+201012345678",
///   "auth_provider": "phone",
///   "is_notify": 1
/// }
/// ```
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    super.firstName,
    super.lastName,
    super.email,
    super.phone,
    super.authProvider,
    super.isNotify,
    super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String? str(String key) {
      final v = json[key];
      if (v == null) return null;
      final s = v.toString().trim();
      return s.isEmpty ? null : s;
    }

    // Compose display name: prefer full_name, then first+last, then name
    String composeName() {
      final full = str('full_name') ?? str('fullName');
      if (full != null && full.isNotEmpty) return full;
      final parts = [
        str('first_name') ?? str('firstName'),
        str('last_name') ?? str('lastName'),
      ].where((p) => p != null && p.isNotEmpty).cast<String>().toList();
      if (parts.isNotEmpty) return parts.join(' ');
      return str('name') ?? '';
    }

    // is_notify can be bool or int (1/0)
    bool? parseIsNotify() {
      final v = json['is_notify'];
      if (v is bool) return v;
      if (v is int) return v != 0;
      return null;
    }

    final rawId = json['id'];

    return UserModel(
      id: rawId?.toString() ?? '',
      name: composeName(),
      firstName: str('first_name') ?? str('firstName'),
      lastName: str('last_name') ?? str('lastName'),
      email: str('email'),
      phone: str('phone'),
      authProvider: str('auth_provider') ?? str('authProvider'),
      isNotify: parseIsNotify(),
      role: str('role'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (authProvider != null) 'auth_provider': authProvider,
      if (isNotify != null) 'is_notify': isNotify! ? 1 : 0,
      if (role != null) 'role': role,
    };
  }
}
