import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_user_app/features/cart/domain/entities/cart_extra_item.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_extras_cubit.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_extras_state.dart';
import 'package:food_user_app/features/product/presentation/widgets/product_extras_section.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockCartExtrasCubit extends MockCubit<CartExtrasState>
    implements CartExtrasCubit {}

class FakeCartExtraItem extends Fake implements CartExtraItem {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeCartExtraItem());
  });

  late MockCartExtrasCubit mockCartExtrasCubit;

  setUp(() {
    mockCartExtrasCubit = MockCartExtrasCubit();
  });

  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      locale: const Locale('ar'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: BlocProvider<CartExtrasCubit>.value(
          value: mockCartExtrasCubit,
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

    testWidgets('shows loading indicator on the card currently being added', (tester) async {
      const items = [
        CartExtraItem(
          id: 1,
          name: 'مياه معدنية',
          basePrice: 15.0,
          priceAfterDiscount: 10.0,
        ),
      ];

      when(() => mockCartExtrasCubit.state).thenReturn(
        const CartExtrasState(items: items, addingProductId: 1),
      );

      await tester.pumpWidget(
        buildTestableWidget(const ProductExtrasSection()),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
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

    testWidgets('tapping add button triggers addExtra and shows success snackbar on success', (tester) async {
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
        () => mockCartExtrasCubit.addExtra(
          item: any(named: 'item'),
          onSuccess: any(named: 'onSuccess'),
          onError: any(named: 'onError'),
        ),
      ).thenAnswer((invocation) async {
        final onSuccess = invocation.namedArguments[#onSuccess] as VoidCallback;
        onSuccess();
        return true;
      });

      await tester.pumpWidget(
        buildTestableWidget(const ProductExtrasSection()),
      );
      await tester.pump();

      final button = find.byType(GestureDetector).last;
      await tester.tap(button);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('تم إضافة المنتج للسلة بنجاح'), findsOneWidget);

      // Verify that the snackbar container background color is #0C9D61
      final snackbarContainers = tester.widgetList<Container>(find.byType(Container)).where((container) {
        final decoration = container.decoration;
        if (decoration is BoxDecoration) {
          return decoration.color == const Color(0xFF0C9D61);
        }
        return false;
      });
      expect(snackbarContainers, isNotEmpty);
    });
  });
}
