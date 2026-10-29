import 'package:flutter_test/flutter_test.dart';
import 'package:food_user_app/features/home/data/models/banner_model.dart';

void main() {
  group('BannerModel Tests', () {
    test('parses Home banner JSON correctly', () {
      final json = {
        'id': 1,
        'type': 'store',
        'title': 'عرض خاص على المطعم',
        'image': 'https://example.com/banner.png',
        'link': 'https://example.com',
        'store_id': 42,
        'status': 1,
        'sort_order': 2,
      };

      final banner = BannerModel.fromJson(json);

      expect(banner.id, equals(1));
      expect(banner.type, equals('store'));
      expect(banner.title, equals('عرض خاص على المطعم'));
      expect(banner.imageUrl, equals('https://example.com/banner.png'));
      expect(banner.storeId, equals(42));
      expect(banner.productId, isNull);
      expect(banner.menuCategoryId, isNull);
      expect(banner.status, equals(1));
      expect(banner.sortOrder, equals(2));
    });

    test('parses Hyper banner JSON with product_id and string IDs safely', () {
      final json = {
        'id': '10',
        'type': 'product',
        'title': 'خصم على البرجر',
        'image': 'https://example.com/product.png',
        'product_id': '99',
        'menu_category_id': null,
      };

      final banner = BannerModel.fromJson(json);

      expect(banner.id, equals(10));
      expect(banner.type, equals('product'));
      expect(banner.title, equals('خصم على البرجر'));
      expect(banner.productId, equals(99));
      expect(banner.menuCategoryId, isNull);
    });

    test('parses Hyper banner JSON with category_id', () {
      final json = {
        'id': 15,
        'type': 'category',
        'title': 'قسم الخضار والفاكهة',
        'image': 'https://example.com/cat.png',
        'menu_category_id': 7,
      };

      final banner = BannerModel.fromJson(json);

      expect(banner.id, equals(15));
      expect(banner.type, equals('category'));
      expect(banner.menuCategoryId, equals(7));
      expect(banner.productId, isNull);
    });

    test('parses banner with subtitle correctly', () {
      final json = {
        'id': 20,
        'type': 'link',
        'title': 'عرض خاص',
        'subtitle': 'خصم كبير',
        'image': 'https://example.com/banner.png',
        'link': 'https://example.com/offer',
      };

      final banner = BannerModel.fromJson(json);

      expect(banner.id, equals(20));
      expect(banner.title, equals('عرض خاص'));
      expect(banner.subtitle, equals('خصم كبير'));
    });

    test('parses banner without subtitle as empty string safely', () {
      final json = {
        'id': 21,
        'type': 'store',
        'title': 'متجر مميز',
        'subtitle': null,
        'image': 'https://example.com/store.png',
      };

      final banner = BannerModel.fromJson(json);

      expect(banner.id, equals(21));
      expect(banner.title, equals('متجر مميز'));
      expect(banner.subtitle, isEmpty);
    });
  });
}
