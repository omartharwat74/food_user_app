import 'package:dartz/dartz.dart' hide Order;
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_user_app/core/constants/api_endpoints.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/core/network/dio_client.dart';
import 'package:food_user_app/features/order/data/datasources/order_remote_data_source.dart';
import 'package:food_user_app/features/order/data/models/order_dto.dart';
import 'package:food_user_app/features/order/data/models/orders_paginated_dto.dart';
import 'package:food_user_app/features/order/data/repositories/order_repository_impl.dart';
import 'package:food_user_app/features/order/domain/entities/order.dart';
import 'package:food_user_app/features/order/domain/entities/orders_paginated_data.dart';
import 'package:food_user_app/features/order/domain/repositories/order_repository.dart';
import 'package:food_user_app/features/order/domain/usecases/cancel_order_usecase.dart';
import 'package:food_user_app/features/order/domain/usecases/get_order_detail_usecase.dart';
import 'package:food_user_app/features/order/domain/usecases/get_order_history_usecase.dart';
import 'package:food_user_app/features/order/domain/usecases/rate_order_usecase.dart';
import 'package:food_user_app/features/order/presentation/cubit/order_detail_cubit.dart';
import 'package:food_user_app/features/order/presentation/cubit/order_detail_state.dart';
import 'package:food_user_app/features/order/presentation/cubit/order_history_cubit.dart';
import 'package:food_user_app/features/order/presentation/cubit/order_history_state.dart';
import 'package:food_user_app/features/order/presentation/utils/order_status_mapper.dart';
import 'package:food_user_app/l10n/app_localizations_ar.dart';
import 'package:food_user_app/l10n/app_localizations_en.dart';
import 'package:mocktail/mocktail.dart';

class MockDioClient extends Mock implements DioClient {}

class MockDio extends Mock implements Dio {}

class MockOrderRemoteDataSource extends Mock implements OrderRemoteDataSource {}

class MockOrderRepository extends Mock implements OrderRepository {}

class MockGetOrderHistoryUseCase extends Mock implements GetOrderHistoryUseCase {}

class MockGetOrderDetailUseCase extends Mock implements GetOrderDetailUseCase {}

class MockCancelOrderUseCase extends Mock implements CancelOrderUseCase {}

class MockRateOrderUseCase extends Mock implements RateOrderUseCase {}

void main() {
  setUpAll(() {
    registerFallbackValue(const GetOrderHistoryParams());
    registerFallbackValue(const CancelOrderParams(orderId: '1', reason: 'r'));
    registerFallbackValue(const RateOrderParams(storeId: 1, rating: 5));
  });

  group('OrderStatus normalization & UI Model mapping', () {
    test('maps pending status to waitingAcceptance (1 bar, can cancel)', () {
      expect(normalizeOrderStatus('pending'), OrderNormalizedStatus.waitingAcceptance);
    });

    test('maps confirmed and ready_for_pickup to preparing (2 bars, cannot cancel)', () {
      expect(normalizeOrderStatus('confirmed'), OrderNormalizedStatus.preparing);
      expect(normalizeOrderStatus('ready_for_pickup'), OrderNormalizedStatus.preparing);
    });

    test('maps assigned and on_the_way to courierOnWay (3 bars, show courier)', () {
      expect(normalizeOrderStatus('assigned'), OrderNormalizedStatus.courierOnWay);
      expect(normalizeOrderStatus('on_the_way'), OrderNormalizedStatus.courierOnWay);
    });

    test('maps delivered to delivered (closed, show rate)', () {
      expect(normalizeOrderStatus('delivered'), OrderNormalizedStatus.delivered);
    });

    test('maps cancelled and rejected to cancelled (show cancel reason)', () {
      expect(normalizeOrderStatus('cancelled'), OrderNormalizedStatus.cancelled);
      expect(normalizeOrderStatus('rejected'), OrderNormalizedStatus.cancelled);
    });

    test('OrderStatusUiModel maps cancelled vs rejected in Arabic and English', () {
      final l10nAr = AppLocalizationsAr();
      final l10nEn = AppLocalizationsEn();

      final modelCancelledAr = OrderStatusUiModel.fromStatus(status: 'cancelled', l10n: l10nAr);
      expect(modelCancelledAr.shortStatusLabel, 'طلب ملغي');
      expect(modelCancelledAr.statusLabel, 'لقد قمت بالغاء الطلب');

      final modelCancelledEn = OrderStatusUiModel.fromStatus(status: 'cancelled', l10n: l10nEn);
      expect(modelCancelledEn.shortStatusLabel, 'Cancelled order');
      expect(modelCancelledEn.statusLabel, 'You cancelled the order');

      final modelRejectedAr = OrderStatusUiModel.fromStatus(status: 'rejected', l10n: l10nAr);
      expect(modelRejectedAr.shortStatusLabel, 'طلب ملغي');
      expect(modelRejectedAr.statusLabel, 'تم رفض الطلب من المتجر');

      final modelRejectedEn = OrderStatusUiModel.fromStatus(status: 'rejected', l10n: l10nEn);
      expect(modelRejectedEn.shortStatusLabel, 'Cancelled order');
      expect(modelRejectedEn.statusLabel, 'Order was rejected by store');
    });
  });

  group('OrdersPaginatedDto', () {
    test('parses paginated response with items and meta correctly', () {
      final json = {
        'status': 200,
        'msg': 'تم جلب الطلبات بنجاح',
        'data': {
          'items': [
            {
              'id': 1,
              'code': 'K7M2Q9PA',
              'status': 'pending',
              'payment_method': 'cash',
              'self_pickup': false,
              'summary': {'total': 144, 'delivery': 30},
              'delivery': null,
              'cancel_reason': null,
            },
            {
              'id': 2,
              'code': 'X9Z2Q1AB',
              'status': 'delivered',
              'payment_method': 'wallet',
              'self_pickup': true,
              'summary': {'total': 200, 'delivery': 0},
              'delivery': {
                'id': 4,
                'name': 'أحمد',
                'phone': '01011111111',
                'vehicle_type': 'motorcycle',
              },
              'cancel_reason': null,
            }
          ],
          'meta': {
            'current_page': 1,
            'last_page': 2,
            'per_page': 10,
            'total': 15,
          }
        }
      };

      final dto = OrdersPaginatedDto.fromJson(json);
      expect(dto.items.length, 2);
      expect(dto.currentPage, 1);
      expect(dto.lastPage, 2);
      expect(dto.perPage, 10);
      expect(dto.total, 15);
      expect(dto.items[0].code, 'K7M2Q9PA');
      expect(dto.items[1].delivery?.name, 'أحمد');

      final entity = dto.toEntity();
      expect(entity.items.length, 2);
      expect(entity.items[0].id, 1);
      expect(entity.items[1].delivery?.phone, '01011111111');
      expect(entity.items[1].delivery?.rating, isNull);
    });

    test('parses OrderDeliveryDto with backend rating correctly', () {
      final jsonWithRating = {
        'id': 10,
        'name': 'محمود',
        'phone': '01099998888',
        'vehicle_type': 'motorcycle',
        'rating': 4.8,
      };

      final dto = OrderDeliveryDto.fromJson(jsonWithRating);
      expect(dto.name, 'محمود');
      expect(dto.rating, 4.8);

      final entity = dto.toEntity();
      expect(entity.rating, 4.8);
    });
  });

  group('OrderRemoteDataSourceImpl', () {
    late MockDio mockDio;
    late MockDioClient mockDioClient;
    late OrderRemoteDataSourceImpl dataSource;

    setUp(() {
      mockDio = MockDio();
      mockDioClient = MockDioClient();
      when(() => mockDioClient.dio).thenReturn(mockDio);
      dataSource = OrderRemoteDataSourceImpl(mockDioClient);
    });

    test('getOrderHistory calls GET with pagination queryParameters', () async {
      when(() => mockDio.get(
            ApiEndpoints.orders,
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.orders),
          data: {
            'status': 200,
            'msg': 'تم جلب الطلبات بنجاح',
            'data': {
              'items': [],
              'meta': {'current_page': 1, 'last_page': 1, 'per_page': 10, 'total': 0}
            }
          },
        ),
      );

      final result = await dataSource.getOrderHistory(perPage: 10, page: 1);
      expect(result.items.isEmpty, true);
      verify(() => mockDio.get(
            ApiEndpoints.orders,
            queryParameters: {'per_page': 10, 'page': 1},
          )).called(1);
    });

    test('getOrderDetails calls GET /api/v1/orders/{id}', () async {
      when(() => mockDio.get(ApiEndpoints.orderDetail('5'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.orderDetail('5')),
          data: {
            'status': 200,
            'msg': 'تم جلب الطلب بنجاح',
            'data': {
              'id': 5,
              'code': 'ORDER5',
              'status': 'pending',
              'payment_method': 'cash',
              'self_pickup': false,
              'items': [],
              'summary': {'total': 150},
            }
          },
        ),
      );

      final result = await dataSource.getOrderDetails('5');
      expect(result.id, 5);
      expect(result.code, 'ORDER5');
      verify(() => mockDio.get(ApiEndpoints.orderDetail('5'))).called(1);
    });

    test('cancelOrder calls POST /api/v1/orders/{id}/cancel with reason', () async {
      when(() => mockDio.post(
            ApiEndpoints.cancelOrder('5'),
            data: {'reason': 'غيرت رأيي'},
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.cancelOrder('5')),
          data: {
            'status': 200,
            'msg': 'تم إلغاء الطلب بنجاح',
            'data': {
              'id': 5,
              'code': 'ORDER5',
              'status': 'cancelled',
              'payment_method': 'cash',
              'self_pickup': false,
              'cancel_reason': 'غيرت رأيي',
              'items': [],
              'summary': {'total': 150},
            }
          },
        ),
      );

      final result = await dataSource.cancelOrder(orderId: '5', reason: 'غيرت رأيي');
      expect(result.status, 'cancelled');
      expect(result.cancelReason, 'غيرت رأيي');
      verify(() => mockDio.post(
            ApiEndpoints.cancelOrder('5'),
            data: {'reason': 'غيرت رأيي'},
          )).called(1);
    });

    test('submitReview calls POST /api/v1/reviews with expected payload', () async {
      when(() => mockDio.post(
            ApiEndpoints.reviews,
            data: {
              'store_id': 1,
              'rating': 5,
              'comment': 'الأكل ممتاز',
              'delivery_id': 2,
              'delivery_rating': 4,
              'delivery_comment': 'المندوب سريع',
            },
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.reviews),
          data: {'status': 200, 'msg': 'تم إضافة التقييم بنجاح'},
        ),
      );

      await dataSource.submitReview(
        storeId: 1,
        rating: 5,
        comment: 'الأكل ممتاز',
        deliveryId: 2,
        deliveryRating: 4,
        deliveryComment: 'المندوب سريع',
      );

      verify(() => mockDio.post(
            ApiEndpoints.reviews,
            data: {
              'store_id': 1,
              'rating': 5,
              'comment': 'الأكل ممتاز',
              'delivery_id': 2,
              'delivery_rating': 4,
              'delivery_comment': 'المندوب سريع',
            },
          )).called(1);
    });
  });

  group('OrderRepositoryImpl', () {
    late MockOrderRemoteDataSource mockRemote;
    late OrderRepositoryImpl repository;

    setUp(() {
      mockRemote = MockOrderRemoteDataSource();
      repository = OrderRepositoryImpl(mockRemote);
    });

    test('cancelOrder returns ServerFailure on 422 with msg', () async {
      when(() => mockRemote.cancelOrder(orderId: '3', reason: 'reason')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiEndpoints.cancelOrder('3')),
          response: Response(
            requestOptions: RequestOptions(path: ApiEndpoints.cancelOrder('3')),
            statusCode: 422,
            data: {
              'status': 422,
              'msg': 'لا يمكن إلغاء الطلب بعد موافقة المتجر',
              'data': [],
            },
          ),
        ),
      );

      final result = await repository.cancelOrder(orderId: '3', reason: 'reason');
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'لا يمكن إلغاء الطلب بعد موافقة المتجر'),
        (_) => fail('Should have failed'),
      );
    });

    test('submitReview returns Right(null) when remote dataSource succeeds', () async {
      when(() => mockRemote.submitReview(
            storeId: 1,
            rating: 5,
            comment: 'الأكل ممتاز',
            deliveryId: 2,
            deliveryRating: 4,
            deliveryComment: 'المندوب سريع',
          )).thenAnswer((_) async {});

      final result = await repository.submitReview(
        storeId: 1,
        rating: 5,
        comment: 'الأكل ممتاز',
        deliveryId: 2,
        deliveryRating: 4,
        deliveryComment: 'المندوب سريع',
      );

      expect(result.isRight(), isTrue);
    });

    test('submitReview returns ServerFailure when remote throws DioException', () async {
      when(() => mockRemote.submitReview(
            storeId: 1,
            rating: 5,
            comment: null,
            deliveryId: null,
            deliveryRating: null,
            deliveryComment: null,
          )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiEndpoints.reviews),
          response: Response(
            requestOptions: RequestOptions(path: ApiEndpoints.reviews),
            statusCode: 422,
            data: {
              'msg': 'يرجى تحديد التقييم',
            },
          ),
        ),
      );

      final result = await repository.submitReview(
        storeId: 1,
        rating: 5,
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, 'يرجى تحديد التقييم'),
        (_) => fail('Should fail'),
      );
    });
  });

  group('OrderHistoryCubit', () {
    late MockGetOrderHistoryUseCase mockUseCase;
    late OrderHistoryCubit cubit;

    setUp(() {
      mockUseCase = MockGetOrderHistoryUseCase();
      cubit = OrderHistoryCubit(mockUseCase);
    });

    tearDown(() => cubit.close());

    test('loadOrders emits loaded state when usecase succeeds', () async {
      const order = Order(
        id: 1,
        code: 'ORDER1',
        status: 'pending',
        paymentMethod: 'cash',
        selfPickup: false,
        items: [],
        summary: OrderSummary(total: 100),
      );
      const data = OrdersPaginatedData(
        items: [order],
        currentPage: 1,
        lastPage: 2,
        perPage: 10,
        total: 15,
      );

      when(() => mockUseCase(const GetOrderHistoryParams(perPage: 10, page: 1)))
          .thenAnswer((_) async => const Right(data));

      await cubit.loadOrders();

      expect(cubit.state.status, OrderHistoryStatus.loaded);
      expect(cubit.state.orders.length, 1);
      expect(cubit.state.orders.first.code, 'ORDER1');
      expect(cubit.state.hasReachedMax, false);
    });

    test('updateOrder replaces order in state or prepends it', () {
      const order1 = Order(
        id: 1,
        code: 'ORDER1',
        status: 'pending',
        paymentMethod: 'cash',
        selfPickup: false,
        items: [],
        summary: OrderSummary(total: 100),
      );
      const order1Updated = Order(
        id: 1,
        code: 'ORDER1',
        status: 'cancelled',
        paymentMethod: 'cash',
        selfPickup: false,
        items: [],
        summary: OrderSummary(total: 100),
        cancelReason: 'غيرت رأيي',
      );

      cubit.emit(cubit.state.copyWith(
        status: OrderHistoryStatus.loaded,
        orders: [order1],
      ));

      cubit.updateOrder(order1Updated);
      expect(cubit.state.orders.first.status, 'cancelled');
      expect(cubit.state.orders.first.cancelReason, 'غيرت رأيي');
    });
  });

  group('OrderDetailCubit', () {
    late MockGetOrderDetailUseCase mockGetDetail;
    late MockCancelOrderUseCase mockCancel;
    late MockRateOrderUseCase mockRateOrder;
    late OrderDetailCubit cubit;

    setUp(() {
      mockGetDetail = MockGetOrderDetailUseCase();
      mockCancel = MockCancelOrderUseCase();
      mockRateOrder = MockRateOrderUseCase();
      cubit = OrderDetailCubit(
        getOrderDetailUseCase: mockGetDetail,
        cancelOrderUseCase: mockCancel,
        rateOrderUseCase: mockRateOrder,
      );
    });

    tearDown(() => cubit.close());

    test('loadOrderDetails emits loaded with order', () async {
      const order = Order(
        id: 10,
        code: 'ORDER10',
        status: 'confirmed',
        paymentMethod: 'cash',
        selfPickup: false,
        items: [],
        summary: OrderSummary(total: 250),
      );

      when(() => mockGetDetail('10')).thenAnswer((_) async => const Right(order));

      await cubit.loadOrderDetails('10');
      expect(cubit.state.status, OrderDetailScreenStatus.loaded);
      expect(cubit.state.order?.code, 'ORDER10');
      expect(cubit.state.order?.status, 'confirmed');
    });

    test('cancelOrder succeeds and emits cancelSuccess', () async {
      const cancelledOrder = Order(
        id: 10,
        code: 'ORDER10',
        status: 'cancelled',
        paymentMethod: 'wallet',
        selfPickup: false,
        cancelReason: 'غيرت رأيي',
        items: [],
        summary: OrderSummary(total: 250),
      );

      when(() => mockCancel(const CancelOrderParams(orderId: '10', reason: 'غيرت رأيي')))
          .thenAnswer((_) async => const Right(cancelledOrder));

      await cubit.cancelOrder(orderId: '10', reason: 'غيرت رأيي');
      expect(cubit.state.status, OrderDetailScreenStatus.cancelSuccess);
      expect(cubit.state.order?.status, 'cancelled');
    });

    test('cancelOrder on 422 error emits error and reloads order details', () async {
      const refreshedOrder = Order(
        id: 10,
        code: 'ORDER10',
        status: 'confirmed',
        paymentMethod: 'wallet',
        selfPickup: false,
        items: [],
        summary: OrderSummary(total: 250),
      );

      when(() => mockCancel(const CancelOrderParams(orderId: '10', reason: 'غيرت رأيي')))
          .thenAnswer((_) async => const Left(ServerFailure('لا يمكن إلغاء الطلب بعد موافقة المتجر')));
      when(() => mockGetDetail('10')).thenAnswer((_) async => const Right(refreshedOrder));

      await cubit.cancelOrder(orderId: '10', reason: 'غيرت رأيي');
      expect(cubit.state.errorMessage, 'لا يمكن إلغاء الطلب بعد موافقة المتجر');
      verify(() => mockGetDetail('10')).called(1);
    });

    test('submitRating calls RateOrderUseCase and returns result', () async {
      const params = RateOrderParams(storeId: 1, rating: 5);
      when(() => mockRateOrder(params)).thenAnswer((_) async => const Right(null));

      final result = await cubit.submitRating(params);
      expect(result.isRight(), isTrue);
      verify(() => mockRateOrder(params)).called(1);
    });
  });
}
