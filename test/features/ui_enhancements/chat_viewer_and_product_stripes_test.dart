import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/widgets/app_media.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_item.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/product_detail_cubit.dart';
import 'package:food_user_app/features/restaurant/presentation/cubit/product_detail_state.dart';
import 'package:food_user_app/features/product/presentation/pages/product_details_screen.dart';
import 'package:food_user_app/features/support/presentation/pages/help_support_screen.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:food_user_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockProductDetailCubit extends Mock implements ProductDetailCubit {}
class MockCartCubit extends Mock implements CartCubit {}

void main() {
  group('Support Chat Full-screen Image Viewer', () {
    testWidgets('Tapping image message bubble opens full-screen dialog with InteractiveViewer, Hero and close button', (tester) async {
      final message = SupportChatMessage(
        id: 'msg-123',
        text: 'Here is the receipt',
        isMine: false,
        attachments: const ['https://example.com/receipt.jpg'],
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('ar'),
          home: Scaffold(
            body: Center(
              child: ChatMessageBubble(
                message: message,
                text: 'Here is the receipt',
              ),
            ),
          ),
        ),
      );

      // Verify thumbnail is rendered with Hero
      final heroFinder = find.byType(Hero);
      expect(heroFinder, findsOneWidget);
      final Hero heroWidget = tester.widget(heroFinder);
      expect(heroWidget.tag, 'support_chat_image_msg-123_https://example.com/receipt.jpg');

      // Tap thumbnail to open dialog
      await tester.tap(heroFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Verify ChatImageViewerDialog is open
      expect(find.byType(ChatImageViewerDialog), findsOneWidget);

      // Verify InteractiveViewer is present inside Dialog
      expect(find.byType(InteractiveViewer), findsOneWidget);

      // Verify close button is present
      final closeButtonFinder = find.widgetWithIcon(IconButton, Icons.close);
      expect(closeButtonFinder, findsOneWidget);

      // Tap close button and verify Dialog is dismissed
      await tester.tap(closeButtonFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(ChatImageViewerDialog), findsNothing);
    });
  });

  group('Product Details Screen Wavy Stripes', () {
    late MockProductDetailCubit mockProductDetailCubit;
    late MockCartCubit mockCartCubit;

    setUp(() {
      mockProductDetailCubit = MockProductDetailCubit();
      mockCartCubit = MockCartCubit();

      when(() => mockProductDetailCubit.state).thenReturn(
        const ProductDetailState.initial(),
      );
      when(() => mockProductDetailCubit.stream).thenAnswer(
        (_) => const Stream.empty(),
      );

      when(() => mockCartCubit.state).thenReturn(
        const CartState.initial(),
      );
      when(() => mockCartCubit.stream).thenAnswer(
        (_) => const Stream.empty(),
      );
    });

    testWidgets('Renders wavy red stripes behind product image as first child in Stack when imageUrl is provided', (tester) async {
      const itemWithNetworkImage = MenuItem(
        id: '1',
        name: 'Spicy Burger',
        description: 'Delicious hot burger',
        price: 150.0,
        originalPrice: 150.0,
        available: true,
        imageUrl: 'https://example.com/burger.jpg',
      );

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<ProductDetailCubit>.value(value: mockProductDetailCubit),
            BlocProvider<CartCubit>.value(value: mockCartCubit),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('ar'),
            home: const ProductDetailsScreen(item: itemWithNetworkImage),
          ),
        ),
      );

      await tester.pump();

      // Check that stripes image is rendered
      final stripesFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName == AppAssets.productDetailsStripes,
      );
      expect(stripesFinder, findsOneWidget);

      // Verify stripes is inside a Stack and is the first child (bottom layer)
      final Stack parentStack = tester.widget(
        find.ancestor(of: stripesFinder, matching: find.byType(Stack)).first,
      );
      expect(parentStack.children.first, isA<Positioned>());

      // Verify product image is also present in that Stack
      expect(find.byType(AppNetworkImage), findsOneWidget);
    });

    testWidgets('Renders wavy red stripes behind fallback burger image when imageUrl is empty', (tester) async {
      const itemWithoutImage = MenuItem(
        id: '2',
        name: 'Classic Burger',
        description: 'Plain burger without image',
        price: 100.0,
        originalPrice: 100.0,
        available: true,
        imageUrl: '',
      );

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<ProductDetailCubit>.value(value: mockProductDetailCubit),
            BlocProvider<CartCubit>.value(value: mockCartCubit),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('ar'),
            home: const ProductDetailsScreen(item: itemWithoutImage),
          ),
        ),
      );

      await tester.pump();

      // Check that stripes image is rendered
      final stripesFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName == AppAssets.productDetailsStripes,
      );
      expect(stripesFinder, findsOneWidget);

      // Check fallback burger image is rendered
      final fallbackBurgerFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName == AppAssets.productBurgerCombo,
      );
      expect(fallbackBurgerFinder, findsOneWidget);
    });
  });
}
