import 'package:food_user_app/features/user/domain/entities/user_settings.dart';

class UserSettingsDto {
  final String id;
  final String? locale;
  final bool? pushNotifications;
  final bool? smsNotifications;
  final bool? emailNotifications;
  final String? theme;

  const UserSettingsDto({
    required this.id,
    this.locale,
    this.pushNotifications,
    this.smsNotifications,
    this.emailNotifications,
    this.theme,
  });

  factory UserSettingsDto.fromJson(Map<String, dynamic> json) {
    return UserSettingsDto(
      id: json['id']?.toString() ?? '',
      locale: json['locale'] as String?,
      pushNotifications:
          json['is_notify'] as bool? ?? json['pushNotifications'] as bool?,
      smsNotifications: json['smsNotifications'] as bool?,
      emailNotifications: json['emailNotifications'] as bool?,
      theme: json['theme'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'locale': locale,
      'is_notify': pushNotifications,
      'smsNotifications': smsNotifications,
      'emailNotifications': emailNotifications,
      'theme': theme,
    };
  }

  UserSettings toEntity() {
    return UserSettings(
      id: id,
      locale: locale ?? 'ar',
      pushNotifications: pushNotifications ?? false,
      smsNotifications: smsNotifications ?? false,
      emailNotifications: emailNotifications ?? false,
      theme: theme ?? 'light',
    );
  }
}
