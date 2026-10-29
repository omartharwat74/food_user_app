import 'package:dio/dio.dart';
import 'package:food_user_app/core/constants/api_endpoints.dart';
import 'package:food_user_app/core/network/dio_error_mapper.dart';
import 'package:food_user_app/features/cart/data/models/cart_response_dto.dart';
import 'package:food_user_app/features/cart/data/models/cart_coupon_response_dto.dart';
import 'package:food_user_app/features/cart/data/models/cart_extra_item_model.dart';
import 'package:food_user_app/features/cart/data/models/promo_preview_response_dto.dart';

abstract class CartRemoteDataSource {
  Future<CartResponseDto> getCart();
  Future<List<CartExtraItemModel>> getCartExtras();
  Future<CartResponseDto> addItem({
    required String productId,
    required int quantity,
    required List<int> optionValueIds,
  });
  Future<CartResponseDto> updateCartItem({
    required String itemId,
    required int quantity,
  });
  Future<CartResponseDto> removeFromCart(String itemId);
  Future<CartResponseDto> clearCart();
  Future<PromoPreviewResponseDto> applyPromo({
    required String code,
    required double subtotal,
  });
  Future<CartCouponResponseDto> applyCoupon({
    required String code,
    required bool selfPickup,
    int? addressId,
  });
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final Dio _dio;

  CartRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<CartResponseDto> getCart() async {
    try {
      final response = await _dio.get<dynamic>(ApiEndpoints.cart);
      return CartResponseDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<List<CartExtraItemModel>> getCartExtras() async {
    try {
      final response = await _dio.get<dynamic>(ApiEndpoints.cartExtras);
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final payload = data['data'];
        if (payload is Map<String, dynamic> && payload['items'] is List) {
          final items = payload['items'] as List;
          return items
              .whereType<Map<String, dynamic>>()
              .map(CartExtraItemModel.fromJson)
              .toList();
        }
      }
      return const [];
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<CartResponseDto> addItem({
    required String productId,
    required int quantity,
    required List<int> optionValueIds,
  }) async {
    try {
      final data = <String, dynamic>{
        'product_id': productId,
        'quantity': quantity,
      };
      if (optionValueIds.isNotEmpty) {
        data['option_value_ids'] = optionValueIds;
      }
      final response = await _dio.post<dynamic>(
        ApiEndpoints.cartItems,
        queryParameters: {'self_pickup': 0},
        data: data,
      );
      return CartResponseDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<CartResponseDto> updateCartItem({
    required String itemId,
    required int quantity,
  }) async {
    try {
      final response = await _dio.patch<dynamic>(
        '${ApiEndpoints.cartItems}/$itemId',
        data: {'quantity': quantity},
      );
      return CartResponseDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<CartResponseDto> removeFromCart(String itemId) async {
    try {
      final response = await _dio.delete<dynamic>(
        '${ApiEndpoints.cartItems}/$itemId',
      );
      return CartResponseDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<CartResponseDto> clearCart() async {
    try {
      final response = await _dio.delete<dynamic>(ApiEndpoints.cart);
      return CartResponseDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<PromoPreviewResponseDto> applyPromo({
    required String code,
    required double subtotal,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        ApiEndpoints.applyPromo,
        data: {'code': code, 'subtotal': subtotal},
      );
      return PromoPreviewResponseDto.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }

  @override
  Future<CartCouponResponseDto> applyCoupon({
    required String code,
    required bool selfPickup,
    int? addressId,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'code': code,
        'self_pickup': selfPickup,
      };
      if (!selfPickup && addressId != null) {
        body['address_id'] = addressId;
      }
      final response = await _dio.post<dynamic>(
        ApiEndpoints.cartCoupon,
        data: body,
      );
      return CartCouponResponseDto.fromJson(
        response.data as Map<String, dynamic>,
        defaultCode: code,
      );
    } on DioException catch (e) {
      throw DioErrorMapper.map(e);
    }
  }
}
