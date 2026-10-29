import 'package:flutter_test/flutter_test.dart';
import 'package:food_user_app/features/order/data/models/order_dto.dart';
import 'package:food_user_app/features/order/domain/entities/order.dart';
import 'package:food_user_app/features/order/presentation/utils/order_status_mapper.dart';
import 'package:food_user_app/l10n/app_localizations_ar.dart';

void main() {
  group('Order API Updates - Parsing Tests', () {
    test('parses is_reviewed = true and note correctly', () {
      final json = {
        'id': 101,
        'code': 'ORD-101',
        'status': 'delivered',
        'subtotal': 150.0,
        'total': 170.0,
        'created_at': '2026-10-29T10:00:00Z',
        'is_reviewed': true,
        'note': 'يرجى عدم الاتصال بالهاتف والقرع على الباب',
        'items': [],
      };

      final dto = OrderDto.fromJson(json);
      final entity = dto.toEntity();

      expect(dto.isReviewed, isTrue);
      expect(entity.isReviewed, isTrue);
      expect(dto.notes, 'يرجى عدم الاتصال بالهاتف والقرع على الباب');
      expect(entity.notes, 'يرجى عدم الاتصال بالهاتف والقرع على الباب');
    });

    test('defaults is_reviewed to false and note to empty when omitted', () {
      final json = {
        'id': 102,
        'code': 'ORD-102',
        'status': 'pending',
        'subtotal': 80.0,
        'total': 95.0,
        'created_at': '2026-10-29T11:00:00Z',
        'items': [],
      };

      final dto = OrderDto.fromJson(json);
      final entity = dto.toEntity();

      expect(dto.isReviewed, isFalse);
      expect(entity.isReviewed, isFalse);
      expect(dto.notes, isNull);
      expect(entity.notes, isNull);
    });

    test('parses delivery rating_avg and rating_count correctly', () {
      final json = {
        'id': 5,
        'name': 'أحمد السائق',
        'phone': '01012345678',
        'image': 'https://example.com/driver.png',
        'vehicle_type': 'motorcycle',
        'rating_avg': 4.85,
        'rating_count': 42,
      };

      final deliveryDto = OrderDeliveryDto.fromJson(json);
      final entity = deliveryDto.toEntity();

      expect(deliveryDto.rating, 4.85);
      expect(deliveryDto.ratingCount, 42);
      expect(entity.rating, 4.85);
      expect(entity.ratingCount, 42);
    });

    test('parses delivery rating safely when rating_count is 0 or null', () {
      final json = {
        'id': 6,
        'name': 'سائق أسطول المتجر',
        'phone': '01000000000',
        'image': null,
        'vehicle_type': null,
        'rating_avg': null,
        'rating_count': null,
      };

      final deliveryDto = OrderDeliveryDto.fromJson(json);
      final entity = deliveryDto.toEntity();

      expect(deliveryDto.rating, isNull);
      expect(deliveryDto.ratingCount, 0);
      expect(entity.rating, isNull);
      expect(entity.ratingCount, 0);
    });
  });

  group('Order API Updates - Review Button Logic Tests', () {
    final l10n = AppLocalizationsAr();

    test('shows rate action ONLY when status is delivered AND is_reviewed is false', () {
      const order = Order(
        id: 201,
        code: 'ORD-201',
        status: 'delivered',
        paymentMethod: 'cash',
        selfPickup: false,
        summary: OrderSummary(),
        items: [],
        isReviewed: false,
      );

      final uiModel = OrderStatusUiModel.fromStatus(status: order.status, l10n: l10n);
      final canRate = uiModel.showRateAction && !order.isReviewed;

      expect(uiModel.showRateAction, isTrue);
      expect(canRate, isTrue);
    });

    test('hides rate action when status is delivered BUT is_reviewed is true', () {
      const order = Order(
        id: 202,
        code: 'ORD-202',
        status: 'delivered',
        paymentMethod: 'cash',
        selfPickup: false,
        summary: OrderSummary(),
        items: [],
        isReviewed: true,
      );

      final uiModel = OrderStatusUiModel.fromStatus(status: order.status, l10n: l10n);
      final canRate = uiModel.showRateAction && !order.isReviewed;

      expect(canRate, isFalse);
    });

    test('hides rate action when status is not delivered regardless of is_reviewed', () {
      const pendingOrder = Order(
        id: 203,
        code: 'ORD-203',
        status: 'pending',
        paymentMethod: 'cash',
        selfPickup: false,
        summary: OrderSummary(),
        items: [],
        isReviewed: false,
      );

      const courierOnWayOrder = Order(
        id: 204,
        code: 'ORD-204',
        status: 'on_the_way',
        paymentMethod: 'cash',
        selfPickup: false,
        summary: OrderSummary(),
        items: [],
        isReviewed: false,
      );

      final pendingUi = OrderStatusUiModel.fromStatus(status: pendingOrder.status, l10n: l10n);
      final courierUi = OrderStatusUiModel.fromStatus(status: courierOnWayOrder.status, l10n: l10n);

      expect(pendingUi.showRateAction && !pendingOrder.isReviewed, isFalse);
      expect(courierUi.showRateAction && !courierOnWayOrder.isReviewed, isFalse);
    });
  });
}
