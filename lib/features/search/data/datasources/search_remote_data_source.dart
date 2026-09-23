import 'package:dio/dio.dart';
import 'package:food_user_app/core/constants/api_endpoints.dart';
import 'package:food_user_app/core/network/dio_error_mapper.dart';
import 'package:food_user_app/features/search/data/models/search_result_dto.dart';

import 'package:food_user_app/features/search/domain/entities/search_log.dart';
import 'package:food_user_app/features/search/domain/entities/search_keyword.dart';
import 'package:food_user_app/features/restaurant/data/models/restaurant_dto.dart';

abstract class SearchRemoteDataSource {
  Future<SearchResultDto> search(
    String query, {
    List<int>? tagIds,
    int? fastPrep,
    int? topRated,
    int? hasOffers,
  });
  Future<List<SearchLog>> getSearchHistory();
  Future<SearchLog> addSearchLog(String term);
  Future<void> deleteSearchLog(int id);
  Future<void> clearSearchLogs();
  Future<List<SearchKeyword>> getSearchKeywords();
  Future<List<RestaurantDto>> getMajorStores();
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio _dio;

  SearchRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<SearchResultDto> search(
    String query, {
    List<int>? tagIds,
    int? fastPrep,
    int? topRated,
    int? hasOffers,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'search': query,
        'section_id':
            1, // Defaulting to 1 to satisfy required param since search maps to Restaurant domain
      };
      if (tagIds != null && tagIds.isNotEmpty) {
        queryParams['tag_ids[]'] = tagIds;
      }
      if (fastPrep != null) queryParams['fast_prep'] = fastPrep;
      if (topRated != null) queryParams['top_rated'] = topRated;
      if (hasOffers != null) queryParams['has_offers'] = hasOffers;
      final response = await _dio.get<dynamic>(
        ApiEndpoints.stores, // Map legacy search to the stores endpoint
        queryParameters: queryParams,
      );
      final raw = response.data;
      if (raw is! Map<String, dynamic> || !raw.containsKey('data')) {
        throw const FormatException(
          'Expected unified envelope with data object',
        );
      }
      final data = raw['data'] as Map<String, dynamic>;
      return SearchResultDto.fromJson(data);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<List<SearchLog>> getSearchHistory() async {
    try {
      final response = await _dio.get<dynamic>(ApiEndpoints.userSearchLogsAll);
      final raw = response.data;
      if (raw is! Map<String, dynamic> || !raw.containsKey('data')) {
        throw const FormatException('Expected unified envelope');
      }
      final data = raw['data'] as List<dynamic>? ?? [];
      return data
          .map((e) => SearchLog.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<SearchLog> addSearchLog(String term) async {
    try {
      final response = await _dio.post<dynamic>(
        ApiEndpoints.userSearchLogsCreate,
        data: {'term': term},
      );
      final raw = response.data;
      if (raw is! Map<String, dynamic> || !raw.containsKey('data')) {
        throw const FormatException('Expected unified envelope');
      }
      return SearchLog.fromJson(raw['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<void> deleteSearchLog(int id) async {
    try {
      await _dio.delete<dynamic>(
        ApiEndpoints.userSearchLogsDelete,
        queryParameters: {'id': id},
      );
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<void> clearSearchLogs() async {
    try {
      await _dio.delete<dynamic>(ApiEndpoints.userSearchLogsClear);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<List<SearchKeyword>> getSearchKeywords() async {
    try {
      final response = await _dio.get<dynamic>(ApiEndpoints.searchKeywords);
      final raw = response.data;
      if (raw is! Map<String, dynamic> || !raw.containsKey('data')) {
        throw const FormatException('Expected unified envelope');
      }
      final data = raw['data'] as List<dynamic>? ?? [];
      return data
          .map((e) => SearchKeyword.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<List<RestaurantDto>> getMajorStores() async {
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.majorStores,
        queryParameters: {'section_id': 2}, // Hardcoded to 2 as requested
      );
      final raw = response.data;
      if (raw is! Map<String, dynamic> || !raw.containsKey('data')) {
        throw const FormatException('Expected unified envelope');
      }

      final data = raw['data'];
      // The API returns paginated data inside 'data' or a list of items
      final List<dynamic> itemsList;
      if (data is Map<String, dynamic> && data.containsKey('items')) {
        itemsList = data['items'] as List<dynamic>? ?? [];
      } else if (data is List<dynamic>) {
        itemsList = data;
      } else {
        itemsList = [];
      }

      return itemsList.map((e) {
        final store = e as Map<String, dynamic>;
        return RestaurantDto(
          id: store['id']?.toString() ?? '',
          name: store['name'] as String?,
          logoUrl: store['logo']?.toString() ?? '',
          coverUrl: store['cover']?.toString() ?? '',
          coverImageUrl: store['cover']?.toString() ?? '',
          deliveryTimeMin: (store['prep_time_from'] as num?)?.toInt(),
          deliveryTimeMax: (store['prep_time_to'] as num?)?.toInt(),
          ratingAvg: store['rating_avg'],
          isMajor: store['is_major'] == true,
        );
      }).toList();
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }
}
