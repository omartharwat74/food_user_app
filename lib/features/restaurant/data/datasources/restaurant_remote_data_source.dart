import 'package:dio/dio.dart';
import 'package:food_user_app/core/constants/api_endpoints.dart';
import 'package:food_user_app/core/network/dio_error_mapper.dart';
import 'package:food_user_app/features/restaurant/data/models/branch_dto.dart';
import 'package:food_user_app/features/restaurant/data/models/offer_dto.dart';
import 'package:food_user_app/features/restaurant/data/models/page_response_restaurant_dto.dart';
import 'package:food_user_app/features/restaurant/data/models/restaurant_dto.dart';

abstract class RestaurantRemoteDataSource {
  Future<PageResponseRestaurantDto> getRestaurants({
    int page = 0,
    int size = 20,
    String? categoryId,
  });

  Future<RestaurantDto> getRestaurantDetail(String id);

  /// Fetches full store details from `GET /api/v1/stores/show?id={storeId}`.
  Future<RestaurantDto> getStoreDetails(String storeId);

  Future<List<BranchDto>> getBranches(String restaurantId);

  Future<List<OfferDto>> getOffers(String restaurantId);

  Future<List<RestaurantDto>> getFavorites();

  Future<void> toggleFavorite(String id);
}

class RestaurantRemoteDataSourceImpl implements RestaurantRemoteDataSource {
  final Dio _dio;

  RestaurantRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<PageResponseRestaurantDto> getRestaurants({
    int page = 0,
    int size = 20,
    String? categoryId,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'size': size};
      if (categoryId != null && categoryId.isNotEmpty) {
        queryParams['categoryId'] = categoryId;
      }
      final response = await _dio.get<dynamic>(
        ApiEndpoints.restaurants,
        queryParameters: queryParams,
      );
      final raw = response.data;
      if (raw is! Map<String, dynamic>) {
        throw const FormatException('Expected paginated response');
      }
      return PageResponseRestaurantDto.fromJson(raw);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<RestaurantDto> getRestaurantDetail(String id) async {
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.restaurantDetails(id),
      );
      final raw = response.data;
      if (raw is! Map<String, dynamic>) {
        throw const FormatException('Expected restaurant object');
      }
      return RestaurantDto.fromJson(raw);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<RestaurantDto> getStoreDetails(String storeId) async {
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.storeShow,
        queryParameters: {'id': storeId},
      );
      final raw = response.data;
      if (raw is! Map<String, dynamic> || !raw.containsKey('data')) {
        throw const FormatException('Expected store details envelope');
      }
      return RestaurantDto.fromJson(raw['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<List<BranchDto>> getBranches(String restaurantId) async {
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.restaurantBranches(restaurantId),
      );
      final raw = response.data;
      if (raw is! List) {
        throw const FormatException('Expected list of branches');
      }
      return raw
          .map((json) => BranchDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<List<OfferDto>> getOffers(String restaurantId) async {
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.restaurantOffers(restaurantId),
      );
      final raw = response.data;
      if (raw is! List) {
        throw const FormatException('Expected list of offers');
      }
      return raw
          .map((json) => OfferDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<List<RestaurantDto>> getFavorites() async {
    try {
      final response = await _dio.get<dynamic>(ApiEndpoints.favoritesList);
      final raw = response.data;
      
      List<dynamic> items = [];
      if (raw is List) {
        items = raw;
      } else if (raw is Map<String, dynamic>) {
        if (raw['data'] is List) {
          items = raw['data'] as List<dynamic>;
        } else if (raw['data'] is Map<String, dynamic> && raw['data']['items'] is List) {
          items = raw['data']['items'] as List<dynamic>;
        } else if (raw['items'] is List) {
          items = raw['items'] as List<dynamic>;
        }
      } else {
        throw const FormatException('Expected list of favorite restaurants');
      }

      return items
          .map((json) => RestaurantDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<void> toggleFavorite(String id) async {
    try {
      await _dio.post<dynamic>(
        ApiEndpoints.favoritesToggle,
        data: {'store_id': int.tryParse(id) ?? id},
      );
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }
}
