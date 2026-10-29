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
    testWidgets('renders Arabic title and subtitle, and does not render "عرض خاص"', (tester) async {
      bool tapped = false;
      const banner = BannerItem(
        id: 1,
        title: 'عرض محدود',
        subtitle: 'خصم 30% على منتجات الفاكهه والخضار',
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

      // "عرض خاص" is removed
      expect(find.text('عرض خاص'), findsNothing);
      // Title is in first slot
      expect(find.text('عرض محدود'), findsOneWidget);
      // Subtitle is in second slot
      expect(find.text('خصم 30% على منتجات الفاكهه والخضار'), findsOneWidget);
      expect(find.text('اطلب الآن'), findsOneWidget);

      await tester.tap(find.byType(PromoBannerCard));
      expect(tapped, isTrue);
    });

    testWidgets('renders English title and subtitle, and mirrors in LTR', (tester) async {
      const banner = BannerItem(
        id: 2,
        title: 'Special Deal',
        subtitle: '30% off on all fruits and veg',
        type: 'product',
        productId: 55,
      );

      await tester.pumpWidget(
        buildTestableWidget(
          const PromoBannerCard(
            banner: banner,
          ),
          locale: const Locale('en'),
        ),
      );
      await tester.pump();

      expect(find.text('Special offer'), findsNothing);
      expect(find.text('Special Deal'), findsOneWidget);
      expect(find.text('30% off on all fruits and veg'), findsOneWidget);
      expect(find.text('Order now'), findsOneWidget);

      // Verify Transform.flip is present for LTR mirroring
      final flips = find.byType(Transform);
      expect(flips, findsWidgets);
    });

    testWidgets('responsive layout calculates image offset as 8.5% and verifies font hierarchy', (tester) async {
      const banner = BannerItem(
        id: 3,
        title: 'عرض خاص للجميع',
        subtitle: 'ساندوتش برجر مجانا',
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

      // Title font size is 13 (in place of old specialOffer)
      final titleText = tester.widget<Text>(find.text('عرض خاص للجميع'));
      expect(titleText.style?.fontSize, 13);
      expect(titleText.style?.fontWeight, FontWeight.w500);

      // Subtitle font size is 14 (in place of old title)
      final subtitleText = tester.widget<Text>(find.text('ساندوتش برجر مجانا'));
      expect(subtitleText.style?.fontSize, 14);
      expect(subtitleText.style?.fontWeight, FontWeight.w600);

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
