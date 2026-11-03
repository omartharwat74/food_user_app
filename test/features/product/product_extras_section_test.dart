import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_user_app/features/cart/domain/entities/cart.dart';
import 'package:food_user_app/features/cart/domain/entities/cart_extra_item.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_extras_cubit.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_extras_state.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:food_user_app/features/product/presentation/widgets/product_extras_section.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockCartExtrasCubit extends MockCubit<CartExtrasState>
    implements CartExtrasCubit {}

class MockCartCubit extends MockCubit<CartState> implements CartCubit {}

class FakeCartExtraItem extends Fake implements CartExtraItem {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeCartExtraItem());
  });

  late MockCartExtrasCubit mockCartExtrasCubit;
  late MockCartCubit mockCartCubit;

  setUp(() {
    mockCartExtrasCubit = MockCartExtrasCubit();
    mockCartCubit = MockCartCubit();
    when(() => mockCartCubit.state).thenReturn(
      const CartState.loaded(cart: Cart.empty()),
    );
  });

  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      locale: const Locale('ar'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider<CartExtrasCubit>.value(value: mockCartExtrasCubit),
            BlocProvider<CartCubit>.value(value: mockCartCubit),
          ],
          child: child,
        ),
      ),
    );
  }

  group('ProductExtrasSection Widget Tests', () {
    testWidgets('renders SizedBox.shrink when extras list is empty', (tester) async {
      when(() => mockCartExtrasCubit.state).thenReturn(
        const CartExtrasState(items: []),
      );

      await tester.pumpWidget(
        buildTestableWidget(const ProductExtrasSection()),
      );
      await tester.pump();

      expect(find.text('إضافة شئ اخر ؟'), findsNothing);
      expect(find.text('اختر ما يناسبك من الإضافات'), findsNothing);
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('renders title, subtitle and cards when extras list is not empty', (tester) async {
      const items = [
        CartExtraItem(
          id: 1,
          name: 'مياه معدنية',
          basePrice: 15.0,
          priceAfterDiscount: 10.0,
        ),
        CartExtraItem(
          id: 2,
          name: 'بطاطس مقلية',
          basePrice: 25.0,
          priceAfterDiscount: 25.0,
        ),
      ];

      when(() => mockCartExtrasCubit.state).thenReturn(
        const CartExtrasState(items: items),
      );

      await tester.pumpWidget(
        buildTestableWidget(const ProductExtrasSection()),
      );
      await tester.pump();

      expect(find.text('إضافة شئ اخر ؟'), findsOneWidget);
      expect(find.text('اختر ما يناسبك من الإضافات'), findsOneWidget);
      expect(find.text('مياه معدنية'), findsOneWidget);
      expect(find.text('بطاطس مقلية'), findsOneWidget);
    });

    testWidgets('renders add button as a 28x28 rectangle with rounded corners', (tester) async {
      const items = [
        CartExtraItem(
          id: 1,
          name: 'مياه معدنية',
          basePrice: 15.0,
          priceAfterDiscount: 10.0,
        ),
      ];

      when(() => mockCartExtrasCubit.state).thenReturn(
        const CartExtrasState(items: items),
      );

      await tester.pumpWidget(
        buildTestableWidget(const ProductExtrasSection()),
      );
      await tester.pump();

      // Find the Container used as the add button inside the card's Stack
      final buttonContainers = tester.widgetList<Container>(find.byType(Container)).where((container) {
        final constraints = container.constraints;
        return constraints?.minWidth == 28 && constraints?.minHeight == 28;
      });

      expect(buttonContainers, isNotEmpty);
      final buttonContainer = buttonContainers.first;
      final decoration = buttonContainer.decoration as BoxDecoration?;
      expect(decoration, isNotNull);
      expect(decoration!.shape, equals(BoxShape.rectangle));
      expect(decoration.borderRadius, equals(BorderRadius.circular(4)));
    });

    testWidgets('tapping add button increments quantity optimistically and calls CartCubit.addItem after debounce', (tester) async {
      const items = [
        CartExtraItem(
          id: 1,
          name: 'مياه معدنية',
          basePrice: 15.0,
          priceAfterDiscount: 10.0,
        ),
      ];

      when(() => mockCartExtrasCubit.state).thenReturn(
        const CartExtrasState(items: items),
      );

      when(
        () => mockCartCubit.addItem(
          productId: any(named: 'productId'),
          quantity: any(named: 'quantity'),
          optionValueIds: any(named: 'optionValueIds'),
        ),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(
        buildTestableWidget(const ProductExtrasSection()),
      );
      await tester.pump();

      final button = find.byKey(const ValueKey('extra_add_1'));
      await tester.tap(button);
      await tester.pump();

      // Shows quantity 1 optimistically
      expect(find.text('1'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 600));

      verify(
        () => mockCartCubit.addItem(
          productId: '1',
          quantity: 1,
          optionValueIds: [],
        ),
      ).called(1);
    });
  });
}
