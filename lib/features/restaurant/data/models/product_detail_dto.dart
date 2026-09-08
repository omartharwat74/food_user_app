import 'package:food_user_app/features/restaurant/domain/entities/menu_item.dart';

/// Parses the `GET /api/v1/stores/products/show?id={productId}` response.
///
/// Response shape:
/// ```json
/// {
///   "data": {
///     "id": 5,
///     "name": "Classic Burger",
///     "description": "...",
///     "main_image": "https://...",
///     "base_price": 120.0,
///     "price_after_discount": 100.0,
///     "is_available": true,
///     "offer": { "discount_value": 20, "discount_type": "fixed" },
///     "options": [
///       {
///         "id": 1,
///         "name": "Size",
///         "required": true,
///         "items": [
///           { "id": 10, "name": "Medium", "price": 0 },
///           { "id": 11, "name": "Large",  "price": 20 }
///         ]
///       }
///     ],
///     "includes": [
///       { "id": 3, "name": "Fries",  "image": "https://...", "quantity": 1 },
///       { "id": 4, "name": "Drink",  "image": null,          "quantity": 1 }
///     ]
///   }
/// }
/// ```
class ProductDetailDto {
  const ProductDetailDto._();

  static MenuItem fromJson(Map<String, dynamic> json) {
    // Unwrap envelope: top-level may already be the product or wrapped in "data"
    final Map<String, dynamic> p =
        (json['data'] is Map<String, dynamic>) ? json['data'] as Map<String, dynamic> : json;

    final offer = p['offer'] as Map<String, dynamic>?;
    final discountValue = (offer?['discount_value'] as num?)?.toDouble() ?? 0.0;
    final discountType = offer?['discount_type'] as String? ?? '';

    // Parse options (modifier groups)
    final rawOptions = p['options'] as List<dynamic>? ?? [];
    final options = rawOptions.map((rawGroup) {
      final g = rawGroup as Map<String, dynamic>;
      final rawItems = (g['values'] ?? g['items'] ?? g['options']) as List<dynamic>? ?? [];
      return ProductModifier(
        id: g['id']?.toString() ?? '',
        name: g['name'] as String? ?? '',
        required: g['is_required'] == true || g['required'] == true,
        maxSelect: (g['max_select'] as num?)?.toInt() ?? (g['maxSelect'] as num?)?.toInt() ?? 1,
        priceType: g['price_type'] as String? ?? 'addon',
        values: rawItems.map((rawItem) {
          final i = rawItem as Map<String, dynamic>;
          return ProductOption(
            id: i['id']?.toString() ?? '',
            name: i['name'] as String? ?? '',
            price: (i['price'] as num?)?.toDouble() ?? 0.0,
          );
        }).toList(),
      );
    }).toList();

    // Parse includes (combo components)
    final rawIncludes = p['includes'] as List<dynamic>? ?? [];
    final includes = rawIncludes.map((rawInclude) {
      final i = rawInclude as Map<String, dynamic>;
      return ProductInclude(
        id: i['id']?.toString() ?? '',
        name: i['name'] as String? ?? '',
        imageUrl: i['image'] as String?,
        quantity: (i['quantity'] as num?)?.toInt() ?? 1,
      );
    }).toList();

    return MenuItem(
      id: p['id']?.toString() ?? '',
      name: p['name'] as String? ?? '',
      description: p['description'] as String? ?? '',
      price: (p['price_after_discount'] as num?)?.toDouble() ??
          (p['price'] as num?)?.toDouble() ??
          0.0,
      originalPrice: (p['base_price'] as num?)?.toDouble() ??
          (p['price'] as num?)?.toDouble() ??
          0.0,
      imageUrl: p['main_image'] as String? ?? '',
      available: p['is_available'] as bool? ?? true,
      discountValue: discountValue,
      discountType: discountType,
      options: options,
      includes: includes,
    );
  }
}
