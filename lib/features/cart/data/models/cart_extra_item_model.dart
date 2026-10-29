import 'package:food_user_app/features/cart/domain/entities/cart_extra_item.dart';

int _asInt(dynamic value, [int defaultValue = 0]) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? defaultValue;
  return defaultValue;
}

double _asDouble(dynamic value, [double defaultValue = 0.0]) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? defaultValue;
  return defaultValue;
}

class CartExtraItemModel extends CartExtraItem {
  const CartExtraItemModel({
    required super.id,
    required super.name,
    super.mainImage,
    super.unit,
    required super.basePrice,
    required super.priceAfterDiscount,
    super.offer,
    super.menuCategory,
  });

  factory CartExtraItemModel.fromJson(Map<String, dynamic> json) {
    CartExtraOffer? offer;
    if (json['offer'] is Map<String, dynamic>) {
      final o = json['offer'] as Map<String, dynamic>;
      offer = CartExtraOffer(
        id: _asInt(o['id']),
        discountType: o['discount_type']?.toString(),
        discountValue: o['discount_value'] != null
            ? _asDouble(o['discount_value'])
            : null,
      );
    }

    CartExtraCategory? menuCategory;
    if (json['menu_category'] is Map<String, dynamic>) {
      final c = json['menu_category'] as Map<String, dynamic>;
      menuCategory = CartExtraCategory(
        id: _asInt(c['id']),
        name: c['name']?.toString(),
        image: c['image']?.toString(),
      );
    }

    final base = _asDouble(json['base_price']);
    final after = json['price_after_discount'] != null
        ? _asDouble(json['price_after_discount'])
        : base;

    return CartExtraItemModel(
      id: _asInt(json['id']),
      name: json['name']?.toString() ?? '',
      mainImage: json['main_image']?.toString(),
      unit: json['unit']?.toString(),
      basePrice: base,
      priceAfterDiscount: after,
      offer: offer,
      menuCategory: menuCategory,
    );
  }
}
