import 'package:dio/dio.dart';

import 'package:food_user_app/core/constants/api_endpoints.dart';
import 'package:food_user_app/core/network/dio_error_mapper.dart';
import 'package:food_user_app/core/errors/exceptions.dart';
import 'package:food_user_app/features/home/data/models/app_settings_model.dart';
import 'package:food_user_app/features/home/data/models/banner_model.dart';
import 'package:food_user_app/features/home/data/models/section_model.dart';
import 'package:food_user_app/features/home/data/models/tag_model.dart';
import 'package:food_user_app/features/home/data/models/store_model.dart';
import 'package:food_user_app/features/home/data/models/spotlight_dto.dart';

abstract class HomeRemoteDataSource {
  /// `GET /api/v1/general-settings` — public, no auth.
  Future<AppSettingsModel> getGeneralSettings();

  /// `GET /api/v1/banners` — public, no auth.
  Future<List<BannerModel>> getBanners();

  /// `GET /api/v1/sections` — returns active home sections.
  Future<List<SectionModel>> getSections();

  /// `GET /api/v1/tags?section_id={sectionId}` — tags for a section.
  Future<List<TagModel>> getTags({int? sectionId});

  /// `GET /api/v1/stores` — paginated store list with optional filters.
  Future<StoreListResultModel> getStores({
    required int sectionId,
    String? search,
    List<int>? tagIds,
    int page = 1,
    int perPage = 10,
    int? fastPrep,
    int? topRated,
    int? hasOffers,
  });

  /// `GET /api/v1/stores/major` — major/featured stores for a section.
  Future<StoreListResultModel> getMajorStores({
    required int sectionId,
    int page = 1,
    int perPage = 10,
  });

  /// `GET /api/v1/spotlights`
  Future<List<SpotlightDto>> getSpotlights({int? sectionId});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  HomeRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  /// Extracts the `data` object from the unified `{ status, msg, data }` envelope.
  dynamic _extractData(Response<dynamic> response) {
    final raw = response.data;
    if (raw is! Map<String, dynamic>) {
      throw const ServerException('Invalid response structure');
    }
    return raw['data'];
  }

  @override
  Future<AppSettingsModel> getGeneralSettings() async {
    try {
      final response = await _dio.get<dynamic>(ApiEndpoints.generalSettings);
      final data = _extractData(response);
      if (data is! Map<String, dynamic>) {
        throw const ServerException('Invalid settings response');
      }
      return AppSettingsModel.fromJson(data);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<List<BannerModel>> getBanners() async {
    try {
      final response = await _dio.get<dynamic>(ApiEndpoints.banners);
      final data = _extractData(response);
      if (data is! List) return [];
      return data
          .whereType<Map<String, dynamic>>()
          .map(BannerModel.fromJson)
          .toList();
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<List<SectionModel>> getSections() async {
    try {
      final response = await _dio.get<dynamic>(ApiEndpoints.sections);
      final data = _extractData(response);
      if (data is! List) return [];
      return data
          .whereType<Map<String, dynamic>>()
          .map(SectionModel.fromJson)
          .toList();
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<List<TagModel>> getTags({int? sectionId}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (sectionId != null) {
        queryParams['section_id'] = sectionId;
      }
      final response = await _dio.get<dynamic>(
        ApiEndpoints.tags,
        queryParameters: queryParams,
      );
      final data = _extractData(response);
      
      final List<dynamic> listData;
      if (data is List) {
        listData = data;
      } else if (data is Map<String, dynamic> && data['items'] is List) {
        listData = data['items'] as List;
      } else {
        return [];
      }

      return listData
          .whereType<Map<String, dynamic>>()
          .map(TagModel.fromJson)
          .toList();
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<StoreListResultModel> getStores({
    required int sectionId,
    String? search,
    List<int>? tagIds,
    int page = 1,
    int perPage = 10,
    int? fastPrep,
    int? topRated,
    int? hasOffers,
  }) async {
    try {
      final Map<String, dynamic> params = {
        'section_id': sectionId,
        'page': page,
        'per_page': perPage,
        if (search != null && search.isNotEmpty) 'search': search,
        if (fastPrep != null) 'fast_prep': fastPrep,
        if (topRated != null) 'top_rated': topRated,
        if (hasOffers != null) 'has_offers': hasOffers,
      };
      // tag_ids[] as separate query params
      if (tagIds != null && tagIds.isNotEmpty) {
        params['tag_ids[]'] = tagIds;
      }
      final response = await _dio.get<dynamic>(
        ApiEndpoints.stores,
        queryParameters: params,
      );
      final data = _extractData(response);
      if (data is! Map<String, dynamic>) {
        return StoreListResultModel(
          items: [],
          meta: StoreMetaModel(currentPage: 1, lastPage: 1, perPage: perPage, total: 0),
        );
      }
      return StoreListResultModel.fromJson(data);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<StoreListResultModel> getMajorStores({
    required int sectionId,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.majorStores,
        queryParameters: {
          'section_id': sectionId,
          'page': page,
          'per_page': perPage,
        },
      );
      final data = _extractData(response);
      if (data is! Map<String, dynamic>) {
        return StoreListResultModel(
          items: [],
          meta: StoreMetaModel(currentPage: 1, lastPage: 1, perPage: perPage, total: 0),
        );
      }
      return StoreListResultModel.fromJson(data);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<List<SpotlightDto>> getSpotlights({int? sectionId}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (sectionId != null) {
        queryParams['section_id'] = sectionId;
      }
      final response = await _dio.get<dynamic>(
        ApiEndpoints.spotlights,
        queryParameters: queryParams,
      );
      final data = _extractData(response);
      if (data is! List) return [];
      return data
          .whereType<Map<String, dynamic>>()
          .map(SpotlightDto.fromJson)
          .toList();
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }
}
