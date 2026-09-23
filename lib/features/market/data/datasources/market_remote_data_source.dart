import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/dio_error_mapper.dart';
import '../../../../core/storage/token_storage.dart';
import '../models/market_category_model.dart';
import '../models/market_model.dart';
import '../models/market_offer_model.dart';
import '../models/market_sub_category_model.dart';
import '../models/page_response_market_model.dart';
import '../models/product_model.dart';

abstract class MarketRemoteDataSource {
  Future<PageResponseMarketModel> getMarkets({
    String? search,
    bool? pickupAvailable,
    bool? isAvailable,
    int page = 0,
    int size = 20,
  });

  Future<MarketModel> getMarketDetails(String id);

  Future<List<MarketCategoryModel>> getMarketCategories(String marketId);

  Future<List<MarketSubCategoryModel>> getMarketSubCategories({
    required String marketId,
    required String categoryId,
  });

  Future<List<ProductModel>> getMarketProducts({
    required String marketId,
    required String categoryId,
    required String subCategoryId,
  });

  Future<List<MarketOfferModel>> getMarketOffers(String marketId);

  Future<List<MarketModel>> getFavoriteMarkets();

  Future<bool> toggleFavoriteMarket(String marketId);
}

class MarketRemoteDataSourceImpl implements MarketRemoteDataSource {
  final DioClient _dioClient;
  final TokenStorage _tokenStorage;

  MarketRemoteDataSourceImpl({
    required DioClient dioClient,
    required TokenStorage tokenStorage,
  }) : _dioClient = dioClient,
       _tokenStorage = tokenStorage;

  Dio get _dio => _dioClient.dio;

  Future<void> _requireAuth() async {
    final token = await _tokenStorage.getAccessToken();
    if (token == null || token.isEmpty) {
      throw const UnauthorizedException('Customer sign in required');
    }
  }

  @override
  Future<PageResponseMarketModel> getMarkets({
    String? search,
    bool? pickupAvailable,
    bool? isAvailable,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'size': size};
      if (search != null && search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
      }
      if (pickupAvailable != null) {
        queryParams['pickupAvailable'] = pickupAvailable;
      }
      if (isAvailable != null) {
        queryParams['isAvailable'] = isAvailable;
      }

      final response = await _dio.get(
        ApiEndpoints.markets,
        queryParameters: queryParams,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final innerData = data['data'] ?? data;
        if (innerData is Map<String, dynamic>) {
          return PageResponseMarketModel.fromJson(innerData);
        }
      }
      throw const ServerException('Invalid response format');
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<MarketModel> getMarketDetails(String id) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.storeShow,
        queryParameters: {'id': id},
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final inner = data['data'] ?? data;
        if (inner is Map<String, dynamic>) {
          return MarketModel.fromJson(inner);
        }
      }
      throw const ServerException('Invalid response format');
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<List<MarketCategoryModel>> getMarketCategories(String marketId) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.storeProductCategories,
        queryParameters: {'store_id': marketId},
      );
      final data = response.data;
      final rawList = data is Map<String, dynamic>
          ? (data['data'] ?? data['categories'] ?? [])
          : data;
      if (rawList is List) {
        return rawList
            .whereType<Map<String, dynamic>>()
            .map((e) => MarketCategoryModel.fromJson(e))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<List<MarketSubCategoryModel>> getMarketSubCategories({
    required String marketId,
    required String categoryId,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.marketSubCategories(marketId, categoryId),
      );
      final data = response.data;
      final rawList = data is Map<String, dynamic>
          ? (data['data'] ?? data['subcategories'] ?? [])
          : data;
      if (rawList is List) {
        return rawList
            .whereType<Map<String, dynamic>>()
            .map((e) => MarketSubCategoryModel.fromJson(e))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<List<ProductModel>> getMarketProducts({
    required String marketId,
    required String categoryId,
    required String subCategoryId,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.marketProducts(marketId, categoryId, subCategoryId),
      );
      final data = response.data;
      final rawList = data is Map<String, dynamic>
          ? (data['data'] ?? data['products'] ?? [])
          : data;
      if (rawList is List) {
        return rawList
            .whereType<Map<String, dynamic>>()
            .map((e) => ProductModel.fromJson(e))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<List<MarketOfferModel>> getMarketOffers(String marketId) async {
    try {
      final response = await _dio.get(ApiEndpoints.restaurantOffers(marketId));
      final data = response.data;
      final rawList = data is Map<String, dynamic>
          ? (data['data'] ?? data['offers'] ?? [])
          : data;
      if (rawList is List) {
        return rawList
            .whereType<Map<String, dynamic>>()
            .map((e) => MarketOfferModel.fromJson(e))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<List<MarketModel>> getFavoriteMarkets() async {
    await _requireAuth();
    try {
      final response = await _dio.get(ApiEndpoints.favoritesList);
      final data = response.data;
      final rawList = data is Map<String, dynamic>
          ? (data['data'] ?? data['favorites'] ?? [])
          : data;
      if (rawList is List) {
        return rawList
            .whereType<Map<String, dynamic>>()
            .map((e) => MarketModel.fromJson(e))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<bool> toggleFavoriteMarket(String marketId) async {
    await _requireAuth();
    try {
      final response = await _dio.post(
        ApiEndpoints.favoritesToggle,
        data: {'store_id': int.tryParse(marketId) ?? marketId},
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final inner = data['data'] ?? data;
        if (inner is Map<String, dynamic> && inner.containsKey('isFavorite')) {
          return inner['isFavorite'] == true;
        }
      }
      return true;
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }
}
