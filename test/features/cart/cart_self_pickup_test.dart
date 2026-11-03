import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_user_app/core/services/snackbar_service.dart';
import 'package:food_user_app/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:food_user_app/features/cart/data/models/cart_response_dto.dart';
import 'package:food_user_app/features/cart/domain/entities/cart.dart';
import 'package:food_user_app/features/cart/domain/entities/cart_item.dart';
import 'package:food_user_app/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:food_user_app/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:food_user_app/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:food_user_app/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:food_user_app/features/cart/domain/usecases/update_cart_item_usecase.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:food_user_app/features/checkout/domain/usecases/apply_promo_usecase.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetCartUseCase extends Mock implements GetCartUseCase {}
class _MockAddToCartUseCase extends Mock implements AddToCartUseCase {}
class _MockUpdateCartItemUseCase extends Mock implements UpdateCartItemUseCase {}
class _MockRemoveFromCartUseCase extends Mock implements RemoveFromCartUseCase {}
class _MockClearCartUseCase extends Mock implements ClearCartUseCase {}
class _MockApplyPromoUseCase extends Mock implements ApplyPromoUseCase {}
class _MockSnackbarService extends Mock implements SnackbarService {}
class _MockDio extends Mock implements Dio {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const AddToCartParams(
        productId: '1',
        quantity: 1,
        optionValueIds: [],
        selfPickup: false,
      ),
    );
  });

  group('CartResponseDto self_pickup parsing', () {
    test('parses self_pickup: 1 as isSelfPickup = true', () {
      final json = {
        'status': 1,
        'message': 'Success',
        'data': {
          'id': 10,
          'user_id': 2,
          'store_id': 5,
          'self_pickup': 1,
          'summary': {
            'items_subtotal': 100,
            'delivery': 0,
            'tax': 14,
            'total': 114,
          },
          'items': [],
          'store': {
            'id': 5,
            'name': 'عز الشام',
            'address': 'مدينتي، القاهرة',
          },
        },
      };

      final dto = CartResponseDto.fromJson(json);
      final entity = dto.toEntity();

      expect(entity.isSelfPickup, isTrue);
      expect(entity.restaurantAddress, 'مدينتي، القاهرة');
      expect(entity.store, isNotNull);
      expect(entity.store?.address, 'مدينتي، القاهرة');
      expect(entity.store?.name, 'عز الشام');
      expect(dto.data.store, isA<CartStoreDto>());
      expect(dto.data.store?.address, 'مدينتي، القاهرة');
    });

    test('parses self_pickup: false as isSelfPickup = false', () {
      final json = {
        'status': 1,
        'message': 'Success',
        'data': {
          'id': 10,
          'user_id': 2,
          'store_id': 5,
          'self_pickup': false,
          'summary': {
            'items_subtotal': 100,
            'delivery': 20,
            'tax': 14,
            'total': 134,
          },
          'items': [],
        },
      };

      final dto = CartResponseDto.fromJson(json);
      final entity = dto.toEntity();

      expect(entity.isSelfPickup, isFalse);
    });
  });

  group('CartRemoteDataSource addItem with self_pickup', () {
    late _MockDio mockDio;
    late CartRemoteDataSourceImpl dataSource;

    setUp(() {
      mockDio = _MockDio();
      dataSource = CartRemoteDataSourceImpl(dio: mockDio);
    });

    test('sends self_pickup: true in body and no queryParameters', () async {
      when(() => mockDio.post<dynamic>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          )).thenAnswer((invocation) async {
        final body = invocation.namedArguments[#data] as Map<String, dynamic>;
        expect(body['self_pickup'], isTrue);
        expect(body['product_id'], '42');
        expect(body['quantity'], 2);

        // queryParameters should not contain self_pickup
        final queryParams = invocation.namedArguments[#queryParameters] as Map<String, dynamic>?;
        expect(queryParams, isNull);

        return Response<dynamic>(
          requestOptions: RequestOptions(path: '/api/v1/cart/items'),
          statusCode: 200,
          data: {
            'status': 1,
            'message': 'Added',
            'data': {
              'id': 1,
              'user_id': 1,
              'self_pickup': 1,
              'summary': {'total': 100},
              'items': [],
            },
          },
        );
      });

      final result = await dataSource.addItem(
        productId: '42',
        quantity: 2,
        optionValueIds: [],
        selfPickup: true,
      );

      expect(result.data.selfPickup, isTrue);
    });
  });

  group('CartCubit conflict avoidance & intent resolution', () {
    late _MockGetCartUseCase mockGetCartUseCase;
    late _MockAddToCartUseCase mockAddToCartUseCase;
    late _MockUpdateCartItemUseCase mockUpdateCartItemUseCase;
    late _MockRemoveFromCartUseCase mockRemoveFromCartUseCase;
    late _MockClearCartUseCase mockClearCartUseCase;
    late _MockApplyPromoUseCase mockApplyPromoUseCase;
    late _MockSnackbarService mockSnackbarService;
    late CartCubit cubit;

    const dummyItem = CartItem(
      id: '1',
      menuItemId: '10',
      name: 'Burger',
      price: 50,
      unitPrice: 50,
      totalPrice: 50,
      imageAsset: '',
      quantity: 1,
      selectedModifiers: [],
      notes: '',
    );

    setUp(() {
      mockGetCartUseCase = _MockGetCartUseCase();
      mockAddToCartUseCase = _MockAddToCartUseCase();
      mockUpdateCartItemUseCase = _MockUpdateCartItemUseCase();
      mockRemoveFromCartUseCase = _MockRemoveFromCartUseCase();
      mockClearCartUseCase = _MockClearCartUseCase();
      mockApplyPromoUseCase = _MockApplyPromoUseCase();
      mockSnackbarService = _MockSnackbarService();

      cubit = CartCubit(
        getCartUseCase: mockGetCartUseCase,
        addToCartUseCase: mockAddToCartUseCase,
        updateCartItemUseCase: mockUpdateCartItemUseCase,
        removeFromCartUseCase: mockRemoveFromCartUseCase,
        clearCartUseCase: mockClearCartUseCase,
        applyPromoUseCase: mockApplyPromoUseCase,
        snackbarService: mockSnackbarService,
      );
    });

    tearDown(() => cubit.close());

    test('when cart is empty, uses isPickupIntent: true -> selfPickup: true', () async {
      when(() => mockAddToCartUseCase(any())).thenAnswer(
        (_) async => const Right(Cart.empty()),
      );

      await cubit.addItem(
        productId: '10',
        quantity: 1,
        optionValueIds: [],
        isPickupIntent: true,
      );

      final captured = verify(() => mockAddToCartUseCase(captureAny())).captured;
      final params = captured.first as AddToCartParams;
      expect(params.selfPickup, isTrue);
    });

    test('when cart is empty, uses isPickupIntent: false -> selfPickup: false', () async {
      when(() => mockAddToCartUseCase(any())).thenAnswer(
        (_) async => const Right(Cart.empty()),
      );

      await cubit.addItem(
        productId: '10',
        quantity: 1,
        optionValueIds: [],
        isPickupIntent: false,
      );

      final captured = verify(() => mockAddToCartUseCase(captureAny())).captured;
      final params = captured.first as AddToCartParams;
      expect(params.selfPickup, isFalse);
    });

    test('when cart has items with isSelfPickup = false, ignores isPickupIntent: true and preserves selfPickup = false', () async {
      const existingDeliveryCart = Cart(
        id: 'c1',
        restaurantId: 'r1',
        items: [dummyItem],
        subtotal: 50,
        deliveryFee: 20,
        tax: 0,
        discount: 0,
        total: 70,
        isSelfPickup: false,
      );

      cubit.emit(const CartState.loaded(cart: existingDeliveryCart));

      when(() => mockAddToCartUseCase(any())).thenAnswer(
        (_) async => const Right(existingDeliveryCart),
      );

      // User came with isPickupIntent: true, but cart already has delivery items!
      await cubit.addItem(
        productId: '20',
        quantity: 1,
        optionValueIds: [],
        isPickupIntent: true,
      );

      final captured = verify(() => mockAddToCartUseCase(captureAny())).captured;
      final params = captured.first as AddToCartParams;
      // Stays false!
      expect(params.selfPickup, isFalse);
    });

    test('when cart has items with isSelfPickup = true, ignores isPickupIntent: false and preserves selfPickup = true', () async {
      const existingPickupCart = Cart(
        id: 'c1',
        restaurantId: 'r1',
        items: [dummyItem],
        subtotal: 50,
        deliveryFee: 0,
        tax: 0,
        discount: 0,
        total: 50,
        isSelfPickup: true,
      );

      cubit.emit(const CartState.loaded(cart: existingPickupCart));

      when(() => mockAddToCartUseCase(any())).thenAnswer(
        (_) async => const Right(existingPickupCart),
      );

      // User came with isPickupIntent: false, but cart already has pickup items!
      await cubit.addItem(
        productId: '20',
        quantity: 1,
        optionValueIds: [],
        isPickupIntent: false,
      );

      final captured = verify(() => mockAddToCartUseCase(captureAny())).captured;
      final params = captured.first as AddToCartParams;
      // Stays true!
      expect(params.selfPickup, isTrue);
    });
  });
}
