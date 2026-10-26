import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_user_app/features/order/domain/entities/order.dart';
import 'package:food_user_app/features/order/presentation/widgets/order_item_tile.dart';
import 'package:food_user_app/features/order/presentation/widgets/product_notes_dialog.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

void main() {
  Widget buildTestableWidget(Widget child, {Locale locale = const Locale('ar')}) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: child,
      ),
    );
  }

  group('OrderItemTile Tests', () {
    testWidgets('displays Spicy Tag when value_name == "حار"', (tester) async {
      const spicyItem = OrderItem(
        id: 1,
        name: 'كريب كرانشي',
        quantity: 2,
        unitPrice: 170,
        lineTotal: 340,
        selectedOptions: [
          {'name': 'الحجم', 'value_name': 'وسط'},
          {'name': 'النكهة', 'value_name': 'حار'},
          {'name': 'إضافات', 'value_name': 'علبة طحينة'},
        ],
      );

      await tester.pumpWidget(
        buildTestableWidget(
          Builder(
            builder: (context) {
              return OrderItemTile(
                item: spicyItem,
                l10n: AppLocalizations.of(context)!,
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('كريب كرانشي'), findsOneWidget);
      expect(find.text('حار'), findsOneWidget);
      expect(find.text('وسط • علبة طحينة'), findsOneWidget);
    });

    testWidgets('does not display Spicy Tag when no spicy option', (tester) async {
      const normalItem = OrderItem(
        id: 2,
        name: 'كريب عادي',
        quantity: 1,
        unitPrice: 100,
        lineTotal: 100,
        selectedOptions: [
          {'name': 'الحجم', 'value_name': 'سمول'},
          {'name': 'إضافات', 'value_name': 'مخلل'},
        ],
      );

      await tester.pumpWidget(
        buildTestableWidget(
          Builder(
            builder: (context) {
              return OrderItemTile(
                item: normalItem,
                l10n: AppLocalizations.of(context)!,
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('كريب عادي'), findsOneWidget);
      expect(find.text('حار'), findsNothing);
      expect(find.text('سمول • مخلل'), findsOneWidget);
    });

    testWidgets('shows notes button and opens ProductNotesDialog on tap', (tester) async {
      const itemWithNotes = OrderItem(
        id: 3,
        name: 'شاورما دجاج',
        quantity: 2,
        unitPrice: 80,
        lineTotal: 160,
        notes: 'بدون بصل وبدون كاتشب',
      );

      await tester.pumpWidget(
        buildTestableWidget(
          Builder(
            builder: (context) {
              return OrderItemTile(
                item: itemWithNotes,
                l10n: AppLocalizations.of(context)!,
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // "ملاحظاتك" button is visible
      final notesBtn = find.text('ملاحظاتك');
      expect(notesBtn, findsOneWidget);

      // Tap on notes button
      await tester.tap(notesBtn);
      await tester.pumpAndSettle();

      // Dialog opens with title "ملاحظاتك على المنتج :" and the note content
      expect(find.text('ملاحظاتك على المنتج :'), findsOneWidget);
      expect(find.text('بدون بصل وبدون كاتشب'), findsOneWidget);
      expect(find.byType(ProductNotesDialog), findsOneWidget);
    });

    testWidgets('does not show notes button when item.notes is null', (tester) async {
      const itemWithoutNotes = OrderItem(
        id: 4,
        name: 'برجر لحم',
        quantity: 1,
        unitPrice: 120,
        lineTotal: 120,
        notes: null,
      );

      await tester.pumpWidget(
        buildTestableWidget(
          Builder(
            builder: (context) {
              return OrderItemTile(
                item: itemWithoutNotes,
                l10n: AppLocalizations.of(context)!,
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('ملاحظاتك'), findsNothing);
    });
  });
}
