import 'package:flutter_test/flutter_test.dart';
import 'package:food_user_app/features/order/data/models/order_dto.dart';
import 'package:food_user_app/features/order/data/models/place_order_request.dart';

void main() {
  group('PlaceOrderRequest', () {
    test('serializes cash payment without coupon correctly', () {
      const request = PlaceOrderRequest(
        paymentMethod: 'cash',
        addressId: 3,
        selfPickup: false,
      );

      final json = request.toJson();
      expect(json['payment_method'], 'cash');
      expect(json['address_id'], 3);
      expect(json['self_pickup'], false);
      expect(json.containsKey('coupon_code'), false);
    });

    test('serializes wallet payment with coupon correctly', () {
      const request = PlaceOrderRequest(
        paymentMethod: 'wallet',
        addressId: 5,
        selfPickup: false,
        couponCode: 'SAVE10',
      );

      final json = request.toJson();
      expect(json['payment_method'], 'wallet');
      expect(json['address_id'], 5);
      expect(json['self_pickup'], false);
      expect(json['coupon_code'], 'SAVE10');
    });

    test('serializes self pickup with empty coupon correctly', () {
      const request = PlaceOrderRequest(
        paymentMethod: 'cash',
        selfPickup: true,
        couponCode: '',
      );

      final json = request.toJson();
      expect(json['payment_method'], 'cash');
      expect(json['self_pickup'], true);
      expect(json.containsKey('address_id'), false);
      expect(json.containsKey('coupon_code'), false);
    });
  });

  group('OrderDto', () {
    test('parses full HTTP 201 backend response correctly', () {
      final json = {
        'status': 201,
        'msg': 'تم إنشاء الطلب بنجاح',
        'data': {
          'id': 1,
          'code': 'K7M2Q9PA',
          'status': 'pending',
          'payment_method': 'cash',
          'self_pickup': false,
          'delivery_mode': 'platform',
          'store': {
            'id': 4,
            'name': 'ستور',
            'logo': null,
            'availability': 'open',
            'unavailable': false,
            'unavailable_reason': null,
            'delivery_mode': 'platform',
          },
          'items': [
            {
              'id': 9,
              'product_id': 12,
              'name': 'برجر',
              'image': null,
              'quantity': 1,
              'unavailable': false,
              'unavailable_reason': null,
              'selected_options': [],
              'unit_price_before_offer': 100,
              'unit_price': 100,
              'offer': null,
              'line_total': 100,
            },
          ],
          'summary': {
            'items_subtotal': 100,
            'offer_discount': 0,
            'items_total': 100,
            'tax_percent': 14,
            'tax': 14,
            'delivery': 30,
            'coupon_discount': 0,
            'total': 144,
          },
          'coupon': null,
          'address': {
            'id': 3,
            'name': 'المنزل',
            'full_address': 'عنوان',
            'building_number': null,
            'floor': null,
            'apartment': null,
            'lat': 30,
            'long': 31,
            'region_id': 1,
          },
          'delivery': null,
          'cancel_reason': null,
          'created_at': '2026-10-13T14:30:00+00:00',
        },
      };

      final dto = OrderDto.fromJson(json);
      final entity = dto.toEntity();

      expect(entity.id, 1);
      expect(entity.code, 'K7M2Q9PA');
      expect(entity.status, 'pending');
      expect(entity.paymentMethod, 'cash');
      expect(entity.selfPickup, false);
      expect(entity.deliveryMode, 'platform');
      expect(entity.message, 'تم إنشاء الطلب بنجاح');

      expect(entity.store?.id, 4);
      expect(entity.store?.name, 'ستور');

      expect(entity.items.length, 1);
      expect(entity.items[0].id, 9);
      expect(entity.items[0].productId, 12);
      expect(entity.items[0].name, 'برجر');
      expect(entity.items[0].quantity, 1);
      expect(entity.items[0].unitPrice, 100.0);
      expect(entity.items[0].lineTotal, 100.0);

      expect(entity.summary.itemsSubtotal, 100.0);
      expect(entity.summary.tax, 14.0);
      expect(entity.summary.delivery, 30.0);
      expect(entity.summary.total, 144.0);

      expect(entity.coupon, isNull);
      expect(entity.address?.id, 3);
      expect(entity.address?.fullAddress, 'عنوان');
      expect(entity.delivery, isNull);
      expect(entity.cancelReason, isNull);

      // Backwards compatibility getters
      expect(entity.orderId, '1');
      expect(entity.restaurantName, 'ستور');
      expect(entity.deliveryAddress, 'عنوان');
      expect(entity.total, 144.0);
      expect(entity.subtotal, 100.0);
      expect(entity.deliveryFee, 30.0);
    });

    test('parses coupon and wallet payment safely', () {
      final json = {
        'status': 201,
        'msg': 'تم إنشاء الطلب بنجاح',
        'data': {
          'id': 2,
          'code': 'XYZ123',
          'status': 'pending',
          'payment_method': 'wallet',
          'self_pickup': true,
          'items': [],
          'summary': {
            'items_subtotal': 100,
            'offer_discount': 0,
            'items_total': 100,
            'tax_percent': 14,
            'tax': 14,
            'delivery': 0,
            'coupon_discount': 10,
            'total': 104,
          },
          'coupon': {
            'code': 'SAVE10',
            'type': 'percent',
            'value': 10,
          },
          'address': null,
          'delivery': null,
          'cancel_reason': null,
        },
      };

      final dto = OrderDto.fromJson(json);
      final entity = dto.toEntity();

      expect(entity.id, 2);
      expect(entity.paymentMethod, 'wallet');
      expect(entity.selfPickup, true);
      expect(entity.coupon?.code, 'SAVE10');
      expect(entity.coupon?.value, 10.0);
      expect(entity.summary.couponDiscount, 10.0);
      expect(entity.summary.total, 104.0);
      expect(entity.address, isNull);
    });
  });
}
