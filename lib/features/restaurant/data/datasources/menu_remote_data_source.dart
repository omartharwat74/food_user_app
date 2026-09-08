import 'package:dio/dio.dart';
import 'package:food_user_app/core/constants/api_endpoints.dart';
import 'package:food_user_app/core/network/dio_error_mapper.dart';
import 'package:food_user_app/features/restaurant/data/models/menu_category_dto.dart';
import 'package:food_user_app/features/restaurant/data/models/item_modifier_dto.dart';
import 'package:food_user_app/features/restaurant/data/models/product_detail_dto.dart';
import 'package:food_user_app/features/restaurant/data/models/store_products_dto.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_item.dart';

abstract class MenuRemoteDataSource {
  Future<List<MenuCategoryDto>> getRestaurantMenu(String restaurantId);
  Future<List<MenuCategoryDto>> getBranchMenu(String branchId);
  Future<List<ItemModifierDto>> getItemModifiers(String itemId);

  /// Fetches menu from `GET /api/v1/stores/products/all?store_id={storeId}`.
  Future<StoreProductsDto> getStoreMenu(String storeId);

  /// Fetches full product details from `GET /api/v1/stores/products/show?id={productId}`.
  Future<MenuItem> getProductDetail(String productId);
}

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  final Dio _dio;

  MenuRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<List<MenuCategoryDto>> getRestaurantMenu(String restaurantId) async {
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.restaurantMenu(restaurantId),
      );
      final raw = response.data;
      if (raw is! List) {
        throw const FormatException('Expected a list of menu categories');
      }
      return raw
          .map((json) => MenuCategoryDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<List<MenuCategoryDto>> getBranchMenu(String branchId) async {
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.branchMenu(branchId),
      );
      final raw = response.data;
      if (raw is! List) {
        throw const FormatException('Expected a list of menu categories');
      }
      return raw
          .map((json) => MenuCategoryDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<List<ItemModifierDto>> getItemModifiers(String itemId) async {
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.itemModifiers(itemId),
      );
      final raw = response.data;
      if (raw is! List) {
        throw const FormatException('Expected a list of item modifiers');
      }
      return raw
          .map((json) => ItemModifierDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<StoreProductsDto> getStoreMenu(String storeId) async {
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.storeProducts,
        queryParameters: {'store_id': storeId},
      );
      final raw = response.data;
      if (raw is! Map<String, dynamic>) {
        throw const FormatException('Expected store products envelope');
      }
      return StoreProductsDto.fromJson(raw);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<MenuItem> getProductDetail(String productId) async {
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.storeProductShow,
        queryParameters: {'id': productId},
      );
      final raw = response.data;
      if (raw is! Map<String, dynamic>) {
        throw const FormatException('Expected product detail object');
      }
      return ProductDetailDto.fromJson(raw);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }
}
