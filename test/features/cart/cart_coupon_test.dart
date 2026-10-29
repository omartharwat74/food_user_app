import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_user_app/core/constants/api_endpoints.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/core/services/snackbar_service.dart';
import 'package:food_user_app/core/usecases/usecase.dart';
import 'package:food_user_app/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:food_user_app/features/cart/data/models/cart_coupon_response_dto.dart';
import 'package:food_user_app/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:food_user_app/features/cart/domain/entities/cart.dart';
import 'package:food_user_app/features/cart/domain/entities/cart_item.dart';
import 'package:food_user_app/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:food_user_app/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:food_user_app/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:food_user_app/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:food_user_app/features/cart/domain/usecases/update_cart_item_usecase.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:food_user_app/features/cart/presentation/widgets/cart_summary.dart';
import 'package:food_user_app/features/checkout/domain/usecases/apply_promo_usecase.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class _MockDio extends Mock implements Dio {}

class _MockCartRemoteDataSource extends Mock
    implements CartRemoteDataSource {}

class _MockCartRepository extends Mock implements CartRepositoryImpl {}

class _MockGetCartUseCase extends Mock implements GetCartUseCase {}

class _MockAddToCartUseCase extends Mock implements AddToCartUseCase {}

class _MockUpdateCartItemUseCase extends Mock
    implements UpdateCartItemUseCase {}

class _MockRemoveFromCartUseCase extends Mock
    implements RemoveFromCartUseCase {}

class _MockClearCartUseCase extends Mock implements ClearCartUseCase {}

class _MockApplyPromoUseCase extends Mock implements ApplyPromoUseCase {}

class _MockSnackbarService extends Mock implements SnackbarService {}

void main() {
  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(
      const ApplyPromoParams(code: 'SAVE10', subtotal: 100),
    );
  });

  group('CartCouponResponseDto', () {
    test('parses success response payload correctly', () {
      final json = {
        'status': 200,
        'msg': 'تم التحقق من الكوبون بنجاح',
        'data': {
          'summary': {
            'items_total': 100,
            'coupon_discount': 10,
            'delivery': 15,
            'tax': 5,
            'total': 110,
          },
          'coupon': {
            'id': 1,
            'code': 'SAVE10',
            'type': 'percent',
            'value': 10,
          },
        },
      };

      final dto = CartCouponResponseDto.fromJson(json, defaultCode: 'FALLBACK');
      expect(dto.discountAmount, 10.0);
      expect(dto.total, 110.0);
      expect(dto.subtotal, 100.0);
      expect(dto.deliveryFee, 15.0);
      expect(dto.tax, 5.0);
      expect(dto.code, 'SAVE10');
      expect(dto.message, 'تم التحقق من الكوبون بنجاح');

      final promo = dto.toPromo();
      expect(promo.code, 'SAVE10');
      expect(promo.discountAmount, 10.0);
      expect(promo.total, 110.0);
    });

    test('parses error response safely with defaults', () {
      final json = {
        'status': 422,
        'msg': 'الكوبون غير صالح',
        'data': [],
      };

      final dto = CartCouponResponseDto.fromJson(json, defaultCode: 'INVALID');
      expect(dto.discountAmount, 0.0);
      expect(dto.total, 0.0);
      expect(dto.code, 'INVALID');
      expect(dto.message, 'الكوبون غير صالح');
    });
  });

  group('CartRemoteDataSourceImpl.applyCoupon', () {
    late _MockDio mockDio;
    late CartRemoteDataSourceImpl dataSource;

    setUp(() {
      mockDio = _MockDio();
      dataSource = CartRemoteDataSourceImpl(dio: mockDio);
    });

    test('sends self_pickup: true without address_id when selfPickup is true', () async {
      when(
        () => mockDio.post<dynamic>(
          ApiEndpoints.cartCoupon,
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response<dynamic>(
          requestOptions: RequestOptions(path: ApiEndpoints.cartCoupon),
          statusCode: 200,
          data: {
            'status': 200,
            'msg': 'تم تطبيق الكوبون',
            'data': {
              'summary': {
                'items_total': 50,
                'coupon_discount': 5,
                'total': 45,
              },
            },
          },
        ),
      );

      final result = await dataSource.applyCoupon(
        code: 'SELF10',
        selfPickup: true,
        addressId: 123, // Should NOT be included in data
      );

      verify(
        () => mockDio.post<dynamic>(
          ApiEndpoints.cartCoupon,
          data: {
            'code': 'SELF10',
            'self_pickup': true,
          },
        ),
      ).called(1);

      expect(result.discountAmount, 5.0);
      expect(result.total, 45.0);
    });

    test('sends self_pickup: false and address_id when selfPickup is false', () async {
      when(
        () => mockDio.post<dynamic>(
          ApiEndpoints.cartCoupon,
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response<dynamic>(
          requestOptions: RequestOptions(path: ApiEndpoints.cartCoupon),
          statusCode: 200,
          data: {
            'status': 200,
            'msg': 'تم تطبيق الكوبون',
            'data': {
              'summary': {
                'items_total': 80,
                'coupon_discount': 10,
                'total': 70,
              },
            },
          },
        ),
      );

      final result = await dataSource.applyCoupon(
        code: 'DELIVERY10',
        selfPickup: false,
        addressId: 456,
      );

      verify(
        () => mockDio.post<dynamic>(
          ApiEndpoints.cartCoupon,
          data: {
            'code': 'DELIVERY10',
            'self_pickup': false,
            'address_id': 456,
          },
        ),
      ).called(1);

      expect(result.discountAmount, 10.0);
      expect(result.total, 70.0);
    });
  });

  group('CartRepositoryImpl.applyCoupon', () {
    late _MockCartRemoteDataSource mockRemoteDataSource;
    late CartRepositoryImpl repository;

    setUp(() {
      mockRemoteDataSource = _MockCartRemoteDataSource();
      repository = CartRepositoryImpl(remoteDataSource: mockRemoteDataSource);
    });

    test('returns Right(CartCouponResponseDto) on success', () async {
      const expectedDto = CartCouponResponseDto(
        discountAmount: 15,
        total: 85,
        code: 'PROMO15',
      );

      when(
        () => mockRemoteDataSource.applyCoupon(
          code: 'PROMO15',
          selfPickup: false,
          addressId: 99,
        ),
      ).thenAnswer((_) async => expectedDto);

      final result = await repository.applyCoupon(
        code: 'PROMO15',
        selfPickup: false,
        addressId: 99,
      );

      expect(result, const Right(expectedDto));
    });

    test('returns Left(Failure) on exception', () async {
      when(
        () => mockRemoteDataSource.applyCoupon(
          code: 'BADCODE',
          selfPickup: true,
          addressId: null,
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiEndpoints.cartCoupon),
          response: Response(
            requestOptions: RequestOptions(path: ApiEndpoints.cartCoupon),
            statusCode: 422,
            data: {'message': 'الكوبون غير صالح'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      final result = await repository.applyCoupon(
        code: 'BADCODE',
        selfPickup: true,
      );

      expect(result.isLeft(), isTrue);
    });
  });

  group('ApplyPromoUseCase', () {
    late _MockCartRepository mockRepository;
    late ApplyPromoUseCase useCase;

    setUp(() {
      mockRepository = _MockCartRepository();
      useCase = ApplyPromoUseCase(repository: mockRepository);
    });

    test('delegates to repository.applyCoupon with correct parameters', () async {
      const dto = CartCouponResponseDto(discountAmount: 20, total: 80);
      when(
        () => mockRepository.applyCoupon(
          code: 'TEST',
          selfPickup: true,
          addressId: null,
        ),
      ).thenAnswer((_) async => const Right(dto));

      final result = await useCase(
        const ApplyPromoParams(code: 'TEST', subtotal: 100, selfPickup: true),
      );

      expect(result, const Right(dto));
      verify(
        () => mockRepository.applyCoupon(
          code: 'TEST',
          selfPickup: true,
          addressId: null,
        ),
      ).called(1);
    });
  });

  group('CartCubit.applyPromoCode', () {
    late _MockGetCartUseCase mockGetCart;
    late _MockAddToCartUseCase mockAddToCart;
    late _MockUpdateCartItemUseCase mockUpdateCartItem;
    late _MockRemoveFromCartUseCase mockRemoveFromCart;
    late _MockClearCartUseCase mockClearCart;
    late _MockApplyPromoUseCase mockApplyPromo;
    late _MockSnackbarService mockSnackbarService;
    late CartCubit cubit;

    const testItem = CartItem(
      id: '1',
      menuItemId: '10',
      name: 'Burger',
      price: 100.0,
      quantity: 1,
    );

    const initialCart = Cart(
      id: 'c1',
      items: [testItem],
      subtotal: 100.0,
      deliveryFee: 15.0,
      tax: 5.0,
      discount: 0.0,
      total: 120.0,
    );

    setUp(() {
      mockGetCart = _MockGetCartUseCase();
      mockAddToCart = _MockAddToCartUseCase();
      mockUpdateCartItem = _MockUpdateCartItemUseCase();
      mockRemoveFromCart = _MockRemoveFromCartUseCase();
      mockClearCart = _MockClearCartUseCase();
      mockApplyPromo = _MockApplyPromoUseCase();
      mockSnackbarService = _MockSnackbarService();

      when(() => mockGetCart(any())).thenAnswer(
        (_) async => const Right(initialCart),
      );

      cubit = CartCubit(
        getCartUseCase: mockGetCart,
        addToCartUseCase: mockAddToCart,
        updateCartItemUseCase: mockUpdateCartItem,
        removeFromCartUseCase: mockRemoveFromCart,
        clearCartUseCase: mockClearCart,
        applyPromoUseCase: mockApplyPromo,
        snackbarService: mockSnackbarService,
      );
    });

    tearDown(() => cubit.close());

    test('updates cart values and returns true on success', () async {
      await cubit.loadCart();

      const couponDto = CartCouponResponseDto(
        discountAmount: 20.0,
        total: 100.0,
        subtotal: 100.0,
        deliveryFee: 15.0,
        tax: 5.0,
        code: 'SAVE20',
      );

      when(() => mockApplyPromo(any())).thenAnswer(
        (_) async => const Right(couponDto),
      );

      final success = await cubit.applyPromoCode(
        'SAVE20',
        selfPickup: false,
        addressId: 1,
      );

      expect(success, isTrue);

      cubit.state.maybeWhen(
        loaded: (cart, promo, updatingId) {
          expect(cart.discount, 20.0);
          expect(cart.total, 100.0);
          expect(promo?.code, 'SAVE20');
        },
        orElse: () => fail('State should be CartLoaded'),
      );
    });

    test('emits error state and returns false on failure', () async {
      await cubit.loadCart();

      when(() => mockApplyPromo(any())).thenAnswer(
        (_) async => const Left(ServerFailure('الكوبون غير صالح')),
      );

      final success = await cubit.applyPromoCode(
        'BADCODE',
        selfPickup: true,
      );

      expect(success, isFalse);

      cubit.state.maybeWhen(
        error: (cart, promo, message) {
          expect(message, 'الكوبون غير صالح');
        },
        orElse: () => fail('State should be CartError'),
      );
    });
  });

  group('CartSummary Delivery Mode and Coupon UI', () {
    testWidgets('renders delivery by default without mode selector', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('ar'),
          home: Scaffold(
            body: CartSummary(
              subtotal: 50,
              delivery: 15,
              tax: 2,
              discount: 0,
              total: 67,
              onCheckout: () {},
              onAddMore: () {},
              isSelfPickup: false,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Mode selector is removed; delivery row is present in summary
      expect(find.text('استلام من الفرع'), findsNothing);
      expect(find.text('التوصيل'), findsOneWidget); // Only in summary bill
    });
  });
}
