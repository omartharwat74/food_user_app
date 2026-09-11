import 'package:dio/dio.dart';

import 'package:food_user_app/core/constants/api_endpoints.dart';
import 'package:food_user_app/core/network/dio_error_mapper.dart';
import 'package:food_user_app/core/errors/exceptions.dart';
import 'package:food_user_app/features/auth/data/models/auth_flow_response_model.dart';
import 'package:food_user_app/features/auth/data/models/general_settings_model.dart';
import 'package:food_user_app/core/utils/device_meta_helper.dart';

abstract class AuthRemoteDataSource {
  /// `POST /api/v1/auth/phone/send-otp` — sends OTP to [phone].
  Future<void> sendPhoneOtp({required String phone});

  /// `POST /api/v1/auth/phone/verify-otp` — verifies OTP for [phone].
  /// Returns a [AuthFlowResponseModel] branching on `data.status`.
  Future<AuthFlowResponseModel> verifyPhoneOtp({
    required String phone,
    required String otp,
    String? registrationToken,
  });

  /// `POST /api/v1/auth/complete-profile` — finishes profile for a new user.
  Future<AuthFlowResponseModel> completeProfile({
    required String registrationToken,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
  });

  /// `POST /api/v1/auth/logout` — invalidates the session on the server.
  Future<void> logout();

  /// `PATCH /api/v1/auth/update-fcm` — registers/updates FCM token.
  Future<void> updateFcm({
    required String fcmToken,
  });

  /// `POST /api/v1/auth/social/login` — social login via Firebase ID token.
  Future<AuthFlowResponseModel> loginWithFirebase({
    required String idToken,
  });

  /// `GET /api/v1/general-settings`
  Future<GeneralSettings> getGeneralSettings();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  /// Helper: extracts the `data` map from the unified response envelope
  /// `{ status, msg, data }` and throws [ServerException] on unexpected shapes.
  Map<String, dynamic> _extractData(Response<dynamic> response) {
    final raw = response.data;
    if (raw is! Map<String, dynamic>) {
      throw const ServerException('Invalid response structure');
    }
    // The data field can be null (e.g. send-otp returns data: null)
    final inner = raw['data'];
    if (inner == null) return <String, dynamic>{};
    if (inner is! Map<String, dynamic>) {
      throw const ServerException('Unexpected response data format');
    }
    return inner;
  }

  Future<Map<String, dynamic>> _withDeviceMeta(Map<String, dynamic> data) async {
    final meta = {
      ...data,
      'device_id': await DeviceMetaHelper.getDeviceId(),
      'platform': DeviceMetaHelper.platform,
      'device_name': await DeviceMetaHelper.getDeviceName(),
      'app_version': await DeviceMetaHelper.getAppVersion(),
    };
    return meta;
  }

  @override
  Future<void> sendPhoneOtp({required String phone}) async {
    try {
      await _dio.post<dynamic>(
        ApiEndpoints.sendOtp,
        data: await _withDeviceMeta(<String, dynamic>{'phone': phone}),
      );
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<AuthFlowResponseModel> verifyPhoneOtp({
    required String phone,
    required String otp,
    String? registrationToken,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        ApiEndpoints.verifyOtp,
        data: await _withDeviceMeta(<String, dynamic>{
          'phone': phone,
          'otp': otp,
          if (registrationToken != null && registrationToken.trim().isNotEmpty)
            'registration_token': registrationToken.trim(),
        }),
      );
      final data = _extractData(response);
      return AuthFlowResponseModel.fromDataJson(data);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<AuthFlowResponseModel> completeProfile({
    required String registrationToken,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        ApiEndpoints.completeProfile,
        data: await _withDeviceMeta(<String, dynamic>{
          'registration_token': registrationToken,
          if (firstName != null && firstName.trim().isNotEmpty) 'first_name': firstName.trim(),
          if (lastName != null && lastName.trim().isNotEmpty) 'last_name': lastName.trim(),
          if (email != null && email.trim().isNotEmpty) 'email': email.trim(),
          if (phone != null && phone.trim().isNotEmpty) 'phone': phone.trim(),
        }),
      );
      final data = _extractData(response);
      return AuthFlowResponseModel.fromDataJson(data);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post<dynamic>(
        ApiEndpoints.logout,
        data: await _withDeviceMeta(<String, dynamic>{}),
      );
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<void> updateFcm({
    required String fcmToken,
  }) async {
    try {
      await _dio.patch<dynamic>(
        ApiEndpoints.updateFcm,
        data: await _withDeviceMeta(<String, dynamic>{
          'fcm_token': fcmToken,
        }),
      );
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<AuthFlowResponseModel> loginWithFirebase({
    required String idToken,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        ApiEndpoints.socialLogin,
        data: await _withDeviceMeta(<String, dynamic>{
          'firebase_id_token': idToken,
        }),
      );
      final data = _extractData(response);
      return AuthFlowResponseModel.fromDataJson(data);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<GeneralSettings> getGeneralSettings() async {
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.generalSettings,
        options: Options(headers: {'Accept': 'application/json'}),
      );
      final data = _extractData(response);
      return GeneralSettings.fromJson(data);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }
}
