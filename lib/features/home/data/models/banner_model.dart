import 'package:food_user_app/features/home/domain/entities/banner.dart';

/// Data model for a banner object from `GET /api/v1/banners`.
///
/// New API shape (array inside unified envelope):
/// ```json
/// {
///   "id": 1,
///   "title": "عرض خاص",
///   "image": "http://.../example.jpg",
///   "link": "https://example.com/offer",
///   "status": 1,
///   "sort_order": 0
/// }
/// ```
class BannerModel extends BannerItem {
  const BannerModel({
    required super.id,
    super.type,
    super.title,
    super.subtitle,
    super.imageUrl,
    super.link,
    super.storeId,
    super.productId,
    super.menuCategoryId,
    super.status,
    super.sortOrder,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      type: json['type']?.toString(),
      title: json['title']?.toString(),
      subtitle: json['subtitle']?.toString().trim() ?? '',
      imageUrl: json['image']?.toString() ?? json['image_url']?.toString(),
      link: json['link']?.toString(),
      storeId: json['store_id'] != null
          ? int.tryParse(json['store_id'].toString())
          : null,
      productId: json['product_id'] != null
          ? int.tryParse(json['product_id'].toString())
          : null,
      menuCategoryId: json['menu_category_id'] != null
          ? int.tryParse(json['menu_category_id'].toString())
          : null,
      status: int.tryParse(json['status']?.toString() ?? '') ?? 1,
      sortOrder: int.tryParse(json['sort_order']?.toString() ?? '') ?? 0,
    );
  }
}
