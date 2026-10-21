import 'package:flutter_test/flutter_test.dart';
import 'package:food_user_app/features/wallet/data/models/wallet_dto.dart';

void main() {
  group('WalletDto', () {
    test('parses wallet JSON with items and meta correctly', () {
      final json = {
        'status': 200,
        'msg': 'Success',
        'data': {
          'balance': '1106.10',
          'currency': 'EGP',
          'items': [
            {
              'id': 1,
              'direction': 'credit',
              'amount': 250,
              'note': '19453',
              'created_at': '2026/11/1',
            },
            {
              'id': 2,
              'direction': 'debit',
              'amount': 120,
              'note': '19453',
              'created_at': '2026/11/1',
            },
          ],
        },
        'meta': {
          'current_page': 1,
          'last_page': 2,
          'per_page': 10,
          'total': 15,
        },
      };

      final dto = WalletDto.fromJson(json);
      final entity = dto.toEntity();

      expect(entity.balance, '1106.10');
      expect(entity.currency, 'EGP');
      expect(entity.items.length, 2);
      expect(entity.currentPage, 1);
      expect(entity.lastPage, 2);
      expect(entity.total, 15);

      final item1 = entity.items[0];
      expect(item1.id, '1');
      expect(item1.direction, 'credit');
      expect(item1.isCredit, true);
      expect(item1.isDebit, false);
      expect(item1.amount, 250.0);
      expect(item1.note, '19453');
      expect(item1.createdAt, '2026/11/1');

      final item2 = entity.items[1];
      expect(item2.direction, 'debit');
      expect(item2.isDebit, true);
      expect(item2.isCredit, false);
      expect(item2.amount, 120.0);
    });

    test('parses numeric balance and empty items safely', () {
      final json = {
        'data': {
          'balance': 0,
          'currency': 'EGP',
          'items': [],
        },
      };

      final dto = WalletDto.fromJson(json);
      final entity = dto.toEntity();

      expect(entity.balance, '0.00');
      expect(entity.items, isEmpty);
      expect(entity.currentPage, 1);
      expect(entity.lastPage, 1);
    });
  });
}
