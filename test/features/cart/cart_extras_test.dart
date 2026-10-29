import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/core/usecases/usecase.dart';
import 'package:food_user_app/features/cart/data/models/cart_extra_item_model.dart';
import 'package:food_user_app/features/cart/domain/entities/cart.dart';
import 'package:food_user_app/features/cart/domain/entities/cart_extra_item.dart';
import 'package:food_user_app/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:food_user_app/features/cart/domain/usecases/get_cart_extras_usecase.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_extras_cubit.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_extras_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCartExtrasUseCase extends Mock implements GetCartExtrasUseCase {}

class MockAddToCartUseCase extends Mock implements AddToCartUseCase {}

void main() {
  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(
      const AddToCartParams(productId: '1', quantity: 1, optionValueIds: []),
    );
  });

  group('CartExtraItemModel Parsing Tests', () {
    test('parses extra item with discount offer correctly', () {
      final json = {
        'id': 10,
        'name': 'كولا كانز',
        'main_image': 'https://example.com/coke.png',
        'unit': 'علبة',
        'base_price': 25.0,
        'price_after_discount': 20.0,
        'offer': {
          'id': 1,
          'discount_type': 'fixed',
          'discount_value': 5.0,
        },
        'menu_category': {
          'id': 2,
          'name': 'مشروبات',
          'image': 'https://example.com/drinks.png',
        },
      };

      final model = CartExtraItemModel.fromJson(json);

      expect(model.id, 10);
      expect(model.name, 'كولا كانز');
      expect(model.mainImage, 'https://example.com/coke.png');
      expect(model.unit, 'علبة');
      expect(model.basePrice, 25.0);
      expect(model.priceAfterDiscount, 20.0);
      expect(model.hasDiscount, isTrue);
      expect(model.offer?.discountType, 'fixed');
      expect(model.offer?.discountValue, 5.0);
      expect(model.menuCategory?.name, 'مشروبات');
    });

    test('parses extra item without discount offer correctly', () {
      final json = {
        'id': 11,
        'name': 'بطاطس مقلية',
        'main_image': null,
        'unit': null,
        'base_price': 30.0,
        'price_after_discount': 30.0,
        'offer': null,
        'menu_category': null,
      };

      final model = CartExtraItemModel.fromJson(json);

      expect(model.id, 11);
      expect(model.name, 'بطاطس مقلية');
      expect(model.basePrice, 30.0);
      expect(model.priceAfterDiscount, 30.0);
      expect(model.hasDiscount, isFalse);
      expect(model.offer, isNull);
      expect(model.menuCategory, isNull);
    });
  });

  group('CartExtrasCubit Tests', () {
    late MockGetCartExtrasUseCase mockGetCartExtrasUseCase;
    late MockAddToCartUseCase mockAddToCartUseCase;
    late CartExtrasCubit cubit;

    const testItem = CartExtraItem(
      id: 55,
      name: 'صوص حار',
      basePrice: 15.0,
      priceAfterDiscount: 12.0,
    );

    setUp(() {
      mockGetCartExtrasUseCase = MockGetCartExtrasUseCase();
      mockAddToCartUseCase = MockAddToCartUseCase();
      cubit = CartExtrasCubit(
        getCartExtrasUseCase: mockGetCartExtrasUseCase,
        addToCartUseCase: mockAddToCartUseCase,
      );
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state has empty items and not loading', () {
      expect(cubit.state, const CartExtrasState());
      expect(cubit.state.items, isEmpty);
      expect(cubit.state.isLoading, isFalse);
    });

    blocTest<CartExtrasCubit, CartExtrasState>(
      'loadExtras emits [loading, loaded] on success',
      build: () {
        when(() => mockGetCartExtrasUseCase(any())).thenAnswer(
          (_) async => const Right([testItem]),
        );
        return cubit;
      },
      act: (cubit) => cubit.loadExtras(),
      expect: () => [
        const CartExtrasState(isLoading: true),
        const CartExtrasState(
          isLoading: false,
          items: [testItem],
          errorMessage: null,
        ),
      ],
      verify: (_) {
        verify(() => mockGetCartExtrasUseCase(any())).called(1);
      },
    );

    blocTest<CartExtrasCubit, CartExtrasState>(
      'loadExtras emits empty items on failure without throwing (silent error)',
      build: () {
        when(() => mockGetCartExtrasUseCase(any())).thenAnswer(
          (_) async => const Left(ServerFailure('Failed to fetch extras')),
        );
        return cubit;
      },
      act: (cubit) => cubit.loadExtras(),
      expect: () => [
        const CartExtrasState(isLoading: true),
        const CartExtrasState(
          isLoading: false,
          items: [],
          errorMessage: 'Failed to fetch extras',
        ),
      ],
    );

    test('addExtra calls AddToCartUseCase with quantity 1 and empty options, and refreshes on success', () async {
      when(() => mockAddToCartUseCase(any())).thenAnswer(
        (_) async => const Right(Cart.empty()),
      );
      when(() => mockGetCartExtrasUseCase(any())).thenAnswer(
        (_) async => const Right([]),
      );

      var successCalled = false;
      var errorCalled = false;

      final success = await cubit.addExtra(
        item: testItem,
        onSuccess: () => successCalled = true,
        onError: (_) => errorCalled = true,
      );

      expect(success, isTrue);
      expect(successCalled, isTrue);
      expect(errorCalled, isFalse);

      verify(
        () => mockAddToCartUseCase(
          const AddToCartParams(
            productId: '55',
            quantity: 1,
            optionValueIds: [],
          ),
        ),
      ).called(1);
      verify(() => mockGetCartExtrasUseCase(any())).called(1);
    });

    test('addExtra invokes onError and does not refresh when AddToCartUseCase fails', () async {
      when(() => mockAddToCartUseCase(any())).thenAnswer(
        (_) async => const Left(ServerFailure('يجب اختيار الحجم أولاً')),
      );

      var successCalled = false;
      String? errorMessage;

      final success = await cubit.addExtra(
        item: testItem,
        onSuccess: () => successCalled = true,
        onError: (msg) => errorMessage = msg,
      );

      expect(success, isFalse);
      expect(successCalled, isFalse);
      expect(errorMessage, 'يجب اختيار الحجم أولاً');

      verify(() => mockAddToCartUseCase(any())).called(1);
      verifyNever(() => mockGetCartExtrasUseCase(any()));
    });
  });
}
