import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_user_app/core/widgets/promo_banner_card.dart';
import 'package:food_user_app/features/home/domain/entities/banner.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

void main() {
  Widget buildTestableWidget(Widget child, {Locale locale = const Locale('ar')}) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 343,
            child: child,
          ),
        ),
      ),
    );
  }

  group('PromoBannerCard Tests', () {
    testWidgets('renders Arabic text and wraps after 3 words on first line', (tester) async {
      bool tapped = false;
      const banner = BannerItem(
        id: 1,
        title: 'خصم 30% على منتجات الفاكهه والخضار',
        type: 'store',
        storeId: 10,
      );

      await tester.pumpWidget(
        buildTestableWidget(
          PromoBannerCard(
            banner: banner,
            onTap: () {
              tapped = true;
            },
          ),
          locale: const Locale('ar'),
        ),
      );
      await tester.pump();

      expect(find.text('عرض خاص'), findsOneWidget);
      // First line has at most 3 words: "خصم 30% على" followed by \n and remaining words
      expect(find.text('خصم 30% على\nمنتجات الفاكهه والخضار'), findsOneWidget);
      expect(find.text('اطلب الآن'), findsOneWidget);

      await tester.tap(find.byType(PromoBannerCard));
      expect(tapped, isTrue);
    });

    testWidgets('renders English text and mirrors in LTR', (tester) async {
      const banner = BannerItem(
        id: 2,
        title: '30% off on all fruits and veg',
        type: 'product',
        productId: 55,
      );

      await tester.pumpWidget(
        buildTestableWidget(
          PromoBannerCard(
            banner: banner,
          ),
          locale: const Locale('en'),
        ),
      );
      await tester.pump();

      expect(find.text('Special offer'), findsOneWidget);
      expect(find.text('30% off on\nall fruits and veg'), findsOneWidget);
      expect(find.text('Order now'), findsOneWidget);

      // Verify Transform.flip is present for LTR mirroring
      final flips = find.byType(Transform);
      expect(flips, findsWidgets);
    });

    testWidgets('responsive layout calculates image offset as 8.5% and uses 21 padding', (tester) async {
      const banner = BannerItem(
        id: 3,
        title: 'عرض محدود',
        type: 'store',
        storeId: 10,
      );

      await tester.pumpWidget(
        buildTestableWidget(
          const PromoBannerCard(banner: banner),
          locale: const Locale('ar'),
        ),
      );
      await tester.pump();

      // Verify LayoutBuilder and Stack are present
      expect(find.byType(LayoutBuilder), findsOneWidget);
      expect(find.byType(Stack), findsWidgets);

      // Verify Positioned widget with left == 343 * 0.085
      final positionedWidgets = tester.widgetList<Positioned>(find.byType(Positioned));
      final imagePositioned = positionedWidgets.firstWhere(
        (p) => p.left != null && p.left! > 20 && p.width == 110,
      );
      expect(imagePositioned.left, closeTo(343 * 0.085, 0.01));

      // Verify image container dimensions
      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      final imageBox = sizedBoxes.firstWhere(
        (s) => s.width == 110 && s.height == 92,
      );
      expect(imageBox, isNotNull);

      // Verify font sizes
      final specialOfferText = tester.widget<Text>(find.text('عرض خاص'));
      expect(specialOfferText.style?.fontSize, 13);

      final titleText = tester.widget<Text>(find.text('عرض محدود'));
      expect(titleText.style?.fontSize, 15);

      final ctaText = tester.widget<Text>(find.text('اطلب الآن'));
      expect(ctaText.style?.fontSize, 14);

      // Verify 21 padding top and bottom
      final paddingWidgets = tester.widgetList<Padding>(find.byType(Padding));
      final textPadding = paddingWidgets.firstWhere(
        (p) => p.padding == const EdgeInsetsDirectional.fromSTEB(18, 21, 6, 21),
      );
      expect(textPadding, isNotNull);
    });
  });
}
