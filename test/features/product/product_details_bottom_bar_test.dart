import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_user_app/features/cart/domain/entities/cart.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_item.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/product_detail_cubit.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/product_detail_state.dart';
import 'package:food_user_app/features/product/presentation/pages/product_details_screen.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class _MockCartCubit extends Mock implements CartCubit {}
class _MockProductDetailCubit extends Mock implements ProductDetailCubit {}

void main() {
  late _MockCartCubit mockCartCubit;
  late _MockProductDetailCubit mockProductDetailCubit;

  const testMenuItem = MenuItem(
    id: '1',
    name: 'وجبة برجر',
    description: 'لذيذ',
    price: 150.0,
    originalPrice: 150.0,
    imageUrl: '',
    available: true,
  );

  setUp(() {
    mockCartCubit = _MockCartCubit();
    mockProductDetailCubit = _MockProductDetailCubit();

    when(() => mockProductDetailCubit.state).thenReturn(
      const ProductDetailState.loaded(testMenuItem),
    );
    when(() => mockProductDetailCubit.stream).thenAnswer(
      (_) => const Stream.empty(),
    );

    when(() => mockCartCubit.state).thenReturn(
      const CartState.loaded(cart: Cart.empty()),
    );
    when(() => mockCartCubit.stream).thenAnswer(
      (_) => const Stream.empty(),
    );
  });

  Widget buildScreen() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ar'),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<CartCubit>.value(value: mockCartCubit),
          BlocProvider<ProductDetailCubit>.value(value: mockProductDetailCubit),
        ],
        child: const ProductDetailsScreen(item: testMenuItem),
      ),
    );
  }

  testWidgets('Bottom Add to Cart button does NOT show loading when background CartCubit is loading', (tester) async {
    // When CartCubit emits loading due to background extra addition
    when(() => mockCartCubit.state).thenReturn(const CartState.loading());

    await tester.pumpWidget(buildScreen());
    await tester.pump();

    // The bottom button should still display text and price, NOT a CircularProgressIndicator
    expect(find.text('إضافة الى السلة'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
