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
    super.title,
    super.imageUrl,
    super.link,
    super.status,
    super.sortOrder,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: (json['id'] as num).toInt(),
      title: json['title']?.toString(),
      imageUrl: json['image']?.toString(),
      link: json['link']?.toString(),
      status: json['status'] != null ? (json['status'] as num).toInt() : 1,
      sortOrder: json['sort_order'] != null
          ? (json['sort_order'] as num).toInt()
          : 0,
    );
  }
}
