import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_user_app/features/user/data/models/user_profile_dto.dart';
import 'package:food_user_app/features/user/data/models/user_settings_dto.dart';

abstract class UserLocalDataSource {
  Future<UserProfileDto?> getCachedProfile();
  Future<void> cacheProfile(UserProfileDto profile);

  Future<UserSettingsDto?> getCachedSettings();
  Future<void> cacheSettings(UserSettingsDto settings);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences _prefs;

  UserLocalDataSourceImpl({required SharedPreferences prefs}) : _prefs = prefs;

  static const String _profileKey = 'cached_user_profile';
  static const String _settingsKey = 'cached_user_settings';

  @override
  Future<UserProfileDto?> getCachedProfile() async {
    final str = _prefs.getString(_profileKey);
    if (str != null && str.isNotEmpty) {
      try {
        return UserProfileDto.fromJson(jsonDecode(str));
      } catch (_) {}
    }
    return null;
  }

  @override
  Future<void> cacheProfile(UserProfileDto profile) async {
    await _prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  @override
  Future<UserSettingsDto?> getCachedSettings() async {
    final str = _prefs.getString(_settingsKey);
    if (str != null && str.isNotEmpty) {
      try {
        return UserSettingsDto.fromJson(jsonDecode(str));
      } catch (_) {}
    }
    return null;
  }

  @override
  Future<void> cacheSettings(UserSettingsDto settings) async {
    await _prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
  }
}
