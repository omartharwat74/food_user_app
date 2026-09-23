import 'package:dio/dio.dart';
import 'package:food_user_app/core/constants/api_endpoints.dart';
import 'package:food_user_app/core/network/dio_error_mapper.dart';
import 'package:food_user_app/features/address/data/models/address_dto.dart';
import 'package:food_user_app/features/address/data/models/create_address_request.dart';

abstract class AddressRemoteDataSource {
  Future<List<AddressDto>> getAddresses();

  Future<AddressDto> createAddress(CreateAddressRequest request);

  Future<AddressDto> updateAddress({
    required String id,
    required CreateAddressRequest request,
  });

  Future<void> deleteAddress(String id);

  Future<AddressDto> setDefaultAddress(String id);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final Dio _dio;

  AddressRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<List<AddressDto>> getAddresses() async {
    try {
      final response = await _dio.get<dynamic>(ApiEndpoints.userAddressesAll);
      final raw = response.data;
      if (raw is! Map<String, dynamic> || !raw.containsKey('data')) {
        throw const FormatException('Expected unified envelope');
      }
      final data = raw['data'];
      if (data is! List) return [];
      return data
          .map((json) => AddressDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<AddressDto> createAddress(CreateAddressRequest request) async {
    try {
      final response = await _dio.post<dynamic>(
        ApiEndpoints.userAddressesCreate,
        data: FormData.fromMap(request.toJson()),
      );
      final raw = response.data;
      if (raw is! Map<String, dynamic> || !raw.containsKey('data')) {
        throw const FormatException('Expected unified envelope');
      }
      return AddressDto.fromJson(raw['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<AddressDto> updateAddress({
    required String id,
    required CreateAddressRequest request,
  }) async {
    try {
      final data = request.toJson();
      data['id'] = id;

      final response = await _dio.put<dynamic>(
        ApiEndpoints.userAddressesEdit,
        data: data,
      );
      final raw = response.data;
      if (raw is! Map<String, dynamic> || !raw.containsKey('data')) {
        throw const FormatException('Expected unified envelope');
      }
      return AddressDto.fromJson(raw['data'] as Map<String, dynamic>);
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
  Future<AddressDto> setDefaultAddress(String id) async {
    try {
      // Just hit edit with id and type='primary'
      final response = await _dio.put<dynamic>(
        ApiEndpoints.userAddressesEdit,
        data: {'id': id, 'type': 'primary'},
      );
      final raw = response.data;
      if (raw is! Map<String, dynamic> || !raw.containsKey('data')) {
        throw const FormatException('Expected unified envelope');
      }
      return AddressDto.fromJson(raw['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }
}
