import 'package:dio/dio.dart';
import 'package:food_user_app/core/constants/api_endpoints.dart';
import 'package:food_user_app/core/utils/phone_formatter.dart';

import 'package:food_user_app/core/network/dio_error_mapper.dart';
import 'package:food_user_app/features/user/data/models/update_user_profile_request.dart';
import 'package:food_user_app/features/user/data/models/update_user_settings_request.dart';
import 'package:food_user_app/features/user/data/models/user_profile_dto.dart';
import 'package:food_user_app/features/user/data/models/user_settings_dto.dart';

abstract class UserRemoteDataSource {
  Future<UserProfileDto> getProfile();

  Future<UserProfileDto> updateProfile(UpdateUserProfileRequest request);

  Future<UserSettingsDto> getSettings();

  Future<UserSettingsDto> updateSettings(UpdateUserSettingsRequest request);

  Future<void> deleteAccount();

  Future<void> sendCurrentPhoneOtp();
  Future<String> verifyCurrentPhoneOtp(String otp);
  Future<void> sendNewPhoneOtp(String token, String newPhone);
  Future<UserProfileDto> verifyNewPhoneOtp(
    String token,
    String newPhone,
    String otp,
  );
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio _dio;

  UserRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<UserProfileDto> getProfile() async {
    try {
      final response = await _dio.get<dynamic>(ApiEndpoints.profileShow);
      final raw = response.data;
      if (raw is! Map<String, dynamic> || !raw.containsKey('data')) {
        throw const FormatException('Expected unified envelope');
      }
      return UserProfileDto.fromJson(raw['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<UserProfileDto> updateProfile(UpdateUserProfileRequest request) async {
    try {
      final response = await _dio.put<dynamic>(
        ApiEndpoints.profileEdit,
        data: request.toJson(),
      );
      final raw = response.data;
      if (raw is! Map<String, dynamic> || !raw.containsKey('data')) {
        throw const FormatException('Expected unified envelope');
      }
      return UserProfileDto.fromJson(raw['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<UserSettingsDto> getSettings() async {
    try {
      final response = await _dio.get<dynamic>(ApiEndpoints.profileShow);
      final raw = response.data;
      if (raw is! Map<String, dynamic> || !raw.containsKey('data')) {
        throw const FormatException('Expected unified envelope');
      }
      return UserSettingsDto.fromJson(raw['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<UserSettingsDto> updateSettings(
    UpdateUserSettingsRequest request,
  ) async {
    try {
      final response = await _dio.put<dynamic>(
        ApiEndpoints.profileNotifications,
        data: request.toJson(),
      );
      final raw = response.data;
      if (raw is! Map<String, dynamic> || !raw.containsKey('data')) {
        throw const FormatException('Expected unified envelope');
      }
      return UserSettingsDto.fromJson(raw['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await _dio.delete<dynamic>(ApiEndpoints.user);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<void> sendCurrentPhoneOtp() async {
    try {
      await _dio.post<dynamic>(ApiEndpoints.phoneSendCurrentOtp);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<String> verifyCurrentPhoneOtp(String otp) async {
    try {
      final response = await _dio.post<dynamic>(
        ApiEndpoints.phoneVerifyCurrentOtp,
        data: {'otp': otp},
      );
      final raw = response.data;
      if (raw is! Map<String, dynamic> || !raw.containsKey('data')) {
        throw const FormatException('Expected unified envelope');
      }
      final data = raw['data'] as Map<String, dynamic>;
      return data['phone_change_token'] as String? ?? '';
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<void> sendNewPhoneOtp(String token, String newPhone) async {
    try {
      await _dio.post<dynamic>(
        ApiEndpoints.phoneSendOtp,
        data: {
          'phone_change_token': token,
          'phone': newPhone.formatAsEgyptianPhone(),
        },
      );
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<UserProfileDto> verifyNewPhoneOtp(
    String token,
    String newPhone,
    String otp,
  ) async {
    try {
      final response = await _dio.post<dynamic>(
        ApiEndpoints.phoneVerifyOtp,
        data: {
          'phone_change_token': token,
          'phone': newPhone.formatAsEgyptianPhone(),
          'otp': otp,
        },
      );
      final raw = response.data;
      if (raw is! Map<String, dynamic> || !raw.containsKey('data')) {
        throw const FormatException('Expected unified envelope');
      }
      return UserProfileDto.fromJson(raw['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }
}
