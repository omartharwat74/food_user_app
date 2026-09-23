import 'package:dio/dio.dart';

import 'package:food_user_app/core/constants/api_endpoints.dart';
import 'package:food_user_app/core/errors/exceptions.dart';
import 'package:food_user_app/core/network/dio_error_mapper.dart';
import 'package:food_user_app/features/profile/data/models/saved_address_dto.dart';

abstract class SavedAddressesRemoteDataSource {
  Future<List<SavedAddressDto>> getAddresses();

  Future<SavedAddressDto> createAddress(SavedAddressRequest request);

  Future<SavedAddressDto> updateAddress({
    required String id,
    required SavedAddressRequest request,
  });

  Future<void> deleteAddress(String id);

  Future<void> setDefaultAddress(String id);
}

class SavedAddressesRemoteDataSourceImpl
    implements SavedAddressesRemoteDataSource {
  const SavedAddressesRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<SavedAddressDto>> getAddresses() async {
    try {
      final response = await _dio.get<dynamic>(ApiEndpoints.userAddressesAll);
      final raw = response.data;
      if (raw is! Map<String, dynamic> || !raw.containsKey('data')) {
        throw const FormatException('Expected unified envelope');
      }
      final list = _extractList(raw['data']);
      return [
        for (final item in list)
          if (item is Map<String, dynamic>) SavedAddressDto.fromJson(item),
      ].where((address) => address.id.isNotEmpty).toList(growable: false);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<SavedAddressDto> createAddress(SavedAddressRequest request) async {
    final requestBody = FormData.fromMap(request.toJson());
    try {
      final response = await _dio.post<dynamic>(
        ApiEndpoints.userAddressesCreate,
        data: requestBody,
      );
      if (response.data is! Map<String, dynamic> ||
          !response.data.containsKey('data')) {
        throw const FormatException('Expected unified envelope');
      }
      return _parseAddress(response.data['data']);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<SavedAddressDto> updateAddress({
    required String id,
    required SavedAddressRequest request,
  }) async {
    try {
      final data = request.toJson();
      data['id'] = id;
      final response = await _dio.put<dynamic>(
        ApiEndpoints.userAddressesEdit,
        data: data,
      );
      if (response.data is! Map<String, dynamic> ||
          !response.data.containsKey('data')) {
        throw const FormatException('Expected unified envelope');
      }
      return _parseAddress(response.data['data']);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<void> deleteAddress(String id) async {
    try {
      await _dio.delete<dynamic>(ApiEndpoints.userAddressDelete(id));
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<void> setDefaultAddress(String id) async {
    try {
      await _dio.put<dynamic>(
        ApiEndpoints.userAddressesEdit,
        data: {'id': id, 'type': 'primary'},
      );
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  static List<dynamic> _extractList(dynamic raw) {
    if (raw is List) return raw;
    if (raw is Map<String, dynamic>) {
      final data = raw['data'];
      if (data is List) return data;
      final addresses = raw['addresses'];
      if (addresses is List) return addresses;
      final content = raw['content'];
      if (content is List) return content;
    }
    return const [];
  }

  static SavedAddressDto _parseAddress(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      final data = raw['data'];
      if (data is Map<String, dynamic>) return SavedAddressDto.fromJson(data);
      return SavedAddressDto.fromJson(raw);
    }
    throw const ServerException('Invalid address response');
  }
}
