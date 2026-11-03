import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_user_app/features/cart/data/models/cart_response_dto.dart';
import 'package:food_user_app/features/cart/domain/entities/cart_item.dart';
import 'package:food_user_app/features/cart/presentation/widgets/cart_item_tile.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

void main() {
  group('Cart Notes Tests', () {
    test('CartItemDto parses note and CartResponseDto maps it to CartItem.notes', () {
      final json = {
        'data': {
          'id': 1,
          'store_id': 10,
          'items': [
            {
              'id': 123,
              'product_id': 456,
              'name': 'برجر دجاج',
              'price': 150.0,
              'quantity': 1,
              'image': 'https://example.com/burger.png',
              'note': 'بدون بصل وبدون كاتشب',
            }
          ],
          'subtotal': 150.0,
          'delivery_fee': 20.0,
          'tax': 0.0,
          'discount': 0.0,
          'total': 170.0,
        }
      };

      final responseDto = CartResponseDto.fromJson(json);
      expect(responseDto.data.items!.first.note, 'بدون بصل وبدون كاتشب');

      final entity = responseDto.toEntity();
      expect(entity.items.first.notes, 'بدون بصل وبدون كاتشب');
    });

    testWidgets('CartItemTile displays note in small text below price', (tester) async {
      const itemWithNote = CartItem(
        id: '1',
        menuItemId: '10',
        name: 'برجر دجاج',
        price: 150.0,
        quantity: 1,
        notes: 'بدون بصل ومخلل زيادة',
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('ar'),
          home: Scaffold(
            body: CartItemTile(
              item: itemWithNote,
              onIncrement: () {},
              onDecrement: () {},
              isUpdating: false,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('بدون بصل ومخلل زيادة'), findsOneWidget);
    });

    testWidgets('CartItemTile does not display note when notes is null or empty', (tester) async {
      const itemWithoutNote = CartItem(
        id: '2',
        menuItemId: '11',
        name: 'برجر لحم',
        price: 180.0,
        quantity: 1,
        notes: null,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('ar'),
          home: Scaffold(
            body: CartItemTile(
              item: itemWithoutNote,
              onIncrement: () {},
              onDecrement: () {},
              isUpdating: false,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('برجر لحم'), findsOneWidget);
    });
  });
}
