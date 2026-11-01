import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/features/auth/domain/entities/user.dart';
import 'package:food_user_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:food_user_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:food_user_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:food_user_app/features/cart/domain/entities/cart.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:food_user_app/features/product/presentation/pages/product_details_screen.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_item.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/product_detail_cubit.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/product_detail_state.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockProductDetailCubit extends MockCubit<ProductDetailState>
    implements ProductDetailCubit {}

class MockCartCubit extends MockCubit<CartState> implements CartCubit {}

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockProductDetailCubit mockProductDetailCubit;
  late MockCartCubit mockCartCubit;
  late MockAuthBloc mockAuthBloc;

  const testItem = MenuItem(
    id: 'prod-1',
    name: 'برجر دجاج',
    description: 'ساندوتش برجر دجاج لذيذ',
    price: 100.0,
    originalPrice: 100.0,
    imageUrl: '',
    available: true,
    options: [
      ProductModifier(
        id: 'mod-size',
        name: 'الحجم',
        priceType: 'absolute',
        maxSelect: 1,
        required: true,
        values: [
          ProductOption(id: 's1', name: 'سنجل', price: 100.0),
          ProductOption(id: 's2', name: 'دبل', price: 150.0),
        ],
      ),
      ProductModifier(
        id: 'mod-extras',
        name: 'إضافات',
        priceType: 'addon',
        maxSelect: 5,
        required: false,
        values: [
          ProductOption(id: 'e1', name: 'جبنة إضافية', price: 15.0),
          ProductOption(id: 'e2', name: 'صوص باربيكيو', price: 10.0),
        ],
      ),
    ],
  );

  setUp(() {
    mockProductDetailCubit = MockProductDetailCubit();
    mockCartCubit = MockCartCubit();
    mockAuthBloc = MockAuthBloc();

    when(() => mockProductDetailCubit.state).thenReturn(
      const ProductDetailState.loaded(testItem),
    );
    when(() => mockCartCubit.state).thenReturn(
      const CartState.loaded(cart: Cart.empty()),
    );
    when(() => mockAuthBloc.state).thenReturn(
      const Authenticated(User(id: '1', name: 'Omar', phone: '01000000000', email: '')),
    );
  });

  Widget buildTestableWidget(Widget child, {Locale locale = const Locale('ar')}) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ProductDetailCubit>.value(value: mockProductDetailCubit),
          BlocProvider<CartCubit>.value(value: mockCartCubit),
          BlocProvider<AuthBloc>.value(value: mockAuthBloc),
        ],
        child: child,
      ),
    );
  }

  group('ProductDetailsScreen Options & Separators Tests', () {
    testWidgets('translates "إضافات" to "الإضافات" in Arabic and "Extras" in English', (tester) async {
      // 1. Arabic
      await tester.pumpWidget(
        buildTestableWidget(const ProductDetailsScreen(item: testItem), locale: const Locale('ar')),
      );
      await tester.pump();

      expect(find.text('الأحجام'), findsOneWidget);
      expect(find.text('الإضافات'), findsOneWidget);

      // 2. English
      await tester.pumpWidget(
        buildTestableWidget(const ProductDetailsScreen(item: testItem), locale: const Locale('en')),
      );
      await tester.pump();

      expect(find.text('Sizes'), findsOneWidget);
      expect(find.text('Extras'), findsOneWidget);
    });

    testWidgets('renders separators between sizes and between addons', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(const ProductDetailsScreen(item: testItem)),
      );
      await tester.pump();

      // Find Container with ShapeDecoration used as separators
      final separatorContainers = tester.widgetList<Container>(
        find.byWidgetPredicate((widget) {
          if (widget is Container && widget.decoration is ShapeDecoration) {
            final dec = widget.decoration as ShapeDecoration;
            return dec.shape is RoundedRectangleBorder;
          }
          return false;
        }),
      );

      // We have 2 modifier groups: each has 2 values, so each has 1 separator => total 2 separators
      expect(separatorContainers.length, greaterThanOrEqualTo(2));
    });

    testWidgets('renders custom addon checkbox icon when unselected and toggle on tap', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(const ProductDetailsScreen(item: testItem)),
      );
      await tester.pump();

      // Find Image with checkbox_unselected asset
      final unselectedCheckboxFinder = find.byWidgetPredicate((widget) {
        if (widget is Image && widget.image is AssetImage) {
          final asset = widget.image as AssetImage;
          return asset.assetName == AppAssets.productCheckboxUnselected;
        }
        return false;
      });

      // Initially neither addon is selected, so 2 unselected checkboxes
      expect(unselectedCheckboxFinder, findsNWidgets(2));

      // Tap on the first addon 'جبنة إضافية'
      await tester.ensureVisible(find.text('جبنة إضافية'));
      await tester.tap(find.text('جبنة إضافية'));
      await tester.pumpAndSettle();

      // Now 1 is selected (shows check icon) and 1 unselected
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
      expect(unselectedCheckboxFinder, findsNWidgets(1));
    });
  });
}
