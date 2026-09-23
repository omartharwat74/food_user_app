import 'package:food_user_app/features/restaurant/domain/entities/menu_category.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_item.dart';

/// Parses the `/api/v1/stores/products/all` response which has the shape:
/// ```json
/// {
///   "data": {
///     "sections": [
///       {
///         "category": { "id": 1, "name": "Burgers" },
///         "products": [
///           {
///             "id": 5,
///             "name": "Classic Burger",
///             "description": "...",
///             "price": 120,
///             "image": "https://...",
///             "is_available": true
///           }
///         ]
///       }
///     ]
///   }
/// }
/// ```
class StoreProductsDto {
  final List<MenuCategory> sections;

  const StoreProductsDto({required this.sections});

  factory StoreProductsDto.fromJson(Map<String, dynamic> json) {
    // Navigate to data.sections
    final data = json['data'];
    List<dynamic> rawSections = [];

    if (data is Map<String, dynamic>) {
      final s = data['sections'];
      if (s is List) rawSections = s;
    } else if (json['sections'] is List) {
      rawSections = json['sections'] as List;
    }

    final sections = rawSections.map((rawSection) {
      final section = rawSection as Map<String, dynamic>;

      // Parse category
      final cat = section['category'] as Map<String, dynamic>? ?? {};
      final categoryId = cat['id']?.toString() ?? '';
      final categoryName = cat['name'] as String? ?? '';

      // Parse products
      final rawProducts = section['products'] as List<dynamic>? ?? [];
      final products = rawProducts.map((rawProduct) {
        final p = rawProduct as Map<String, dynamic>;

        final offer = p['offer'] as Map<String, dynamic>?;
        final discountValue =
            (offer?['discount_value'] as num?)?.toDouble() ?? 0.0;
        final discountType = offer?['discount_type'] as String? ?? '';

        return MenuItem(
          id: p['id']?.toString() ?? '',
          name: p['name'] as String? ?? '',
          description: p['description'] as String? ?? '',
          price:
              (p['price_after_discount'] as num?)?.toDouble() ??
              (p['price'] as num?)?.toDouble() ??
              0.0,
          originalPrice:
              (p['base_price'] as num?)?.toDouble() ??
              (p['original_price'] as num?)?.toDouble() ??
              (p['price'] as num?)?.toDouble() ??
              0.0,
          imageUrl: p['main_image'] as String? ?? p['image'] as String? ?? '',
          available: p['is_available'] as bool? ?? true,
          discountValue: discountValue,
          discountType: discountType,
        );
      }).toList();

      return MenuCategory(
        id: categoryId,
        branchId: '',
        name: categoryName,
        sortOrder: 0,
        items: products,
        visible: true,
      );
    }).toList();

    return StoreProductsDto(sections: sections);
  }
}
