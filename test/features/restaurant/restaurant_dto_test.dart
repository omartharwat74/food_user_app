import 'package:flutter_test/flutter_test.dart';
import 'package:food_user_app/features/restaurant/data/models/restaurant_dto.dart';
import 'package:food_user_app/features/restaurant/data/models/review_dto.dart';
import 'package:food_user_app/features/restaurant/data/models/store_products_dto.dart';

void main() {
  group('RestaurantDto & ReviewDto Backend Real Response Parsing', () {
    test('parses عز الشام store show response without any type cast exception', () {
      final json = {
        "id": 1,
        "section_id": 1,
        "name": "عز الشام",
        "description": "مطعم مشويات ووجبات سريعة",
        "logo": "https://mycar.msarweb.net/storage/stores/logos/ezz-sham-logo.png",
        "cover": "https://mycar.msarweb.net/storage/stores/covers/ezz-sham-cover.png",
        "phone": "01010000001",
        "address": "مدينتي، القاهرة",
        "lat": 30.095,
        "lng": 31.63,
        "is_major": false,
        "prep_time_from": 25,
        "prep_time_to": 50,
        "availability": "open",
        "rating_avg": 5,
        "rating_count": 1,
        "rating_distribution": {"5": 1, "4": 0, "3": 0, "2": 0, "1": 0},
        "reviews": [
          {
            "id": 1,
            "store_id": 1,
            "rating": 5,
            "comment": "alo",
            "created_at": "2026-10-26 20:15:48",
            "user": {"id": 1, "first_name": "omar", "last_name": "tharwat"}
          }
        ],
        "reviews_has_more": false,
        "is_fav": true,
        "tags": [
          {"id": 1, "name": "برجر"},
          {"id": 2, "name": "بيتزا"},
          {"id": 4, "name": "مشويات"}
        ],
        "working_hours": [
          {
            "day": "friday",
            "is_open": true,
            "is_24h": false,
            "from_time": "10:00:00",
            "to_time": "23:00:00"
          }
        ]
      };

      final dto = RestaurantDto.fromJson(json);
      expect(dto.id, '1');
      expect(dto.name, 'عز الشام');
      expect(dto.cuisineType, 'برجر • بيتزا • مشويات');
      expect(dto.isFavorited, isTrue);
      expect(dto.isOpen, isTrue);
      expect(dto.isAvailable, isTrue);
      expect(dto.availability, 'open');
      expect(dto.reviews.length, 1);

      final review = dto.reviews.first;
      expect(review.id, '1');
      expect(review.userName, 'omar tharwat');
      expect(review.rating, 5.0);
      expect(review.comment, 'alo');

      final entity = dto.toEntity();
      expect(entity.id, '1');
      expect(entity.name, 'عز الشام');
      expect(entity.isFavorited, isTrue);
      expect(entity.cuisineType, 'برجر • بيتزا • مشويات');
      expect(entity.isAvailable, isTrue);
      expect(entity.availability, 'open');
      expect(entity.reviews.first.userName, 'omar tharwat');
    });

    test('parses busy and closed availability properly', () {
      final busyDto = RestaurantDto.fromJson({'id': 2, 'availability': 'busy'});
      expect(busyDto.availability, 'busy');
      expect(busyDto.toEntity().availability, 'busy');

      final closedDto =
          RestaurantDto.fromJson({'id': 3, 'availability': 'closed'});
      expect(closedDto.availability, 'closed');
      expect(closedDto.isAvailable, isFalse);
      expect(closedDto.toEntity().availability, 'closed');
      expect(closedDto.toEntity().isAvailable, isFalse);
    });

    test('ReviewDto handles both string id and int id with user map or user_name', () {
      final reviewFromInt = ReviewDto.fromJson({
        'id': 42,
        'rating': 4,
        'comment': 'Good',
        'user': {'first_name': 'Ahmed', 'last_name': 'Ali'},
      });
      expect(reviewFromInt.id, '42');
      expect(reviewFromInt.userName, 'Ahmed Ali');
      expect(reviewFromInt.rating, 4.0);

      final reviewFromString = ReviewDto.fromJson({
        'id': '99',
        'user_name': 'Mona',
        'rating': 4.5,
        'comment': 'Nice',
      });
      expect(reviewFromString.id, '99');
      expect(reviewFromString.userName, 'Mona');
      expect(reviewFromString.rating, 4.5);
    });

    test('StoreProductsDto parses backend response with products and offers correctly', () {
      final json = {
        "status": 200,
        "msg": "تم جلب منتجات المتجر بنجاح",
        "data": {
          "store_id": 1,
          "is_major": false,
          "sections": [
            {
              "category": {"id": 1, "name": "بيتزا", "image": null},
              "products": [
                {
                  "id": 1,
                  "name": "شاورما فراخ",
                  "main_image":
                      "https://mycar.msarweb.net/storage/placeholder/products/store-1/classic-burger-main.jpg",
                  "unit": "piece",
                  "base_price": 55,
                  "price_after_discount": 41.25,
                  "offer": {
                    "id": 1,
                    "discount_type": "percent",
                    "discount_value": 25
                  }
                }
              ]
            }
          ]
        }
      };

      final dto = StoreProductsDto.fromJson(json);
      expect(dto.sections.length, 1);
      expect(dto.sections.first.name, 'بيتزا');
      expect(dto.sections.first.items.first.name, 'شاورما فراخ');
      expect(dto.sections.first.items.first.price, 41.25);
      expect(dto.sections.first.items.first.originalPrice, 55.0);
      expect(dto.sections.first.items.first.available, isTrue);
    });
  });
}
