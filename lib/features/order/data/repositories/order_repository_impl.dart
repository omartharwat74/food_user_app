import 'package:dartz/dartz.dart' hide Order;
import 'package:dio/dio.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/features/order/data/datasources/order_remote_data_source.dart';
import 'package:food_user_app/features/order/data/models/order_tracking_dto.dart';
import 'package:food_user_app/features/order/data/models/place_order_request.dart';
import 'package:food_user_app/features/order/domain/entities/order.dart';
import 'package:food_user_app/features/order/domain/entities/order_tracking.dart';
import 'package:food_user_app/features/order/domain/entities/orders_paginated_data.dart';
import '../../domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Order>> placeOrder(PlaceOrderRequest request) async {
    try {
      final orderDto = await remoteDataSource.placeOrder(request);
      return Right(orderDto.toEntity());
    } on DioException catch (e) {
      String errorMessage = 'حدث خطأ في إنشاء الطلب';
      final resData = e.response?.data;
      if (resData is Map<String, dynamic>) {
        errorMessage =
            (resData['msg'] ?? resData['message'] ?? errorMessage).toString();
      } else if (e.message != null && e.message!.isNotEmpty) {
        errorMessage = e.message!;
      }
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrdersPaginatedData>> getOrderHistory({
    int perPage = 10,
    int page = 1,
  }) async {
    try {
      final paginatedDto = await remoteDataSource.getOrderHistory(
        perPage: perPage,
        page: page,
      );
      return Right(paginatedDto.toEntity());
    } on DioException catch (e) {
      String errorMessage = 'حدث خطأ أثناء جلب الطلبات';
      final resData = e.response?.data;
      if (resData is Map<String, dynamic>) {
        errorMessage =
            (resData['msg'] ?? resData['message'] ?? errorMessage).toString();
      } else if (e.message != null && e.message!.isNotEmpty) {
        errorMessage = e.message!;
      }
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Order>> getOrderDetails(String orderId) async {
    try {
      final dto = await remoteDataSource.getOrderDetails(orderId);
      return Right(dto.toEntity());
    } on DioException catch (e) {
      String errorMessage = 'الطلب غير موجود';
      final resData = e.response?.data;
      if (resData is Map<String, dynamic>) {
        errorMessage =
            (resData['msg'] ?? resData['message'] ?? errorMessage).toString();
      } else if (e.message != null && e.message!.isNotEmpty) {
        errorMessage = e.message!;
      }
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Order>> cancelOrder({
    required String orderId,
    required String reason,
  }) async {
    try {
      final dto = await remoteDataSource.cancelOrder(
        orderId: orderId,
        reason: reason,
      );
      return Right(dto.toEntity());
    } on DioException catch (e) {
      String errorMessage = 'لا يمكن إلغاء الطلب بعد موافقة المتجر';
      final resData = e.response?.data;
      if (resData is Map<String, dynamic>) {
        errorMessage =
            (resData['msg'] ?? resData['message'] ?? errorMessage).toString();
      } else if (e.message != null && e.message!.isNotEmpty) {
        errorMessage = e.message!;
      }
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderTracking>> trackOrder(String orderId) async {
    try {
      final dto = await remoteDataSource.trackOrder(orderId);
      return Right(dto.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
