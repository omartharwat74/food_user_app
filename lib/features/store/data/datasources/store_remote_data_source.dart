import 'package:dio/dio.dart';
import 'package:food_user_app/core/constants/api_endpoints.dart';
import 'package:food_user_app/core/network/dio_error_mapper.dart';
import 'package:food_user_app/features/store/data/models/hyper_categories_response.dart';
import 'package:food_user_app/features/store/data/models/hyper_sections_response.dart';
import 'package:food_user_app/features/store/data/models/store_search_response.dart';

abstract class StoreRemoteDataSource {
  Future<HyperCategoriesResponse> getStoreCategories(String storeId);
  Future<HyperSectionsResponse> getStoreCategorySections({
    required String storeId,
    required String categoryId,
  });
  Future<StoreSearchResponse> searchProducts({
    required String storeId,
    required String query,
    int page = 1,
    int perPage = 10,
  });
}

class StoreRemoteDataSourceImpl implements StoreRemoteDataSource {
  final Dio _dio;

  StoreRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<HyperCategoriesResponse> getStoreCategories(String storeId) async {
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.storeProductCategories,
        queryParameters: {'store_id': storeId},
      );
      final raw = response.data;
      if (raw is! Map<String, dynamic>) {
        throw const FormatException('Expected a JSON object');
      }
      return HyperCategoriesResponse.fromJson(raw);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<HyperSectionsResponse> getStoreCategorySections({
    required String storeId,
    required String categoryId,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.storeProductCategorySections,
        queryParameters: {
          'store_id': storeId,
          'menu_category_id': categoryId,
        },
      );
      final raw = response.data;
      if (raw is! Map<String, dynamic>) {
        throw const FormatException('Expected a JSON object');
      }
      return HyperSectionsResponse.fromJson(raw);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<StoreSearchResponse> searchProducts({
    required String storeId,
    required String query,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.storeProductSearch,
        queryParameters: {
          'store_id': storeId,
          'search': query,
          'page': page,
          'per_page': perPage,
        },
      );
      final raw = response.data;
      if (raw is! Map<String, dynamic>) {
        throw const FormatException('Expected a JSON object');
      }
      return StoreSearchResponse.fromJson(raw);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }
}
