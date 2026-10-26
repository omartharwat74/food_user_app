import 'package:equatable/equatable.dart';

/// A banner card entity returned by `GET /api/v1/banners`.
///
/// New API shape:
/// ```json
/// {
///   "id": 1,
///   "title": "عرض خاص",
///   "image": "http://.../banners/example.jpg",
///   "link": "https://example.com/offer",
///   "status": 1,
///   "sort_order": 0
/// }
/// ```
class BannerItem extends Equatable {
  final int id;
  final String? type;
  final String? title;
  final String? imageUrl;

  /// External link to open when the banner is tapped.
  final String? link;
  final int? storeId;
  final int? productId;
  final int? menuCategoryId;

  /// `1` = active, `0` = inactive.
  final int status;
  final int sortOrder;

  // ── Legacy fields kept for UI compatibility ────────────────────────────────
  final String subtitle;
  final String ctaText;
  final String discountText;
  final String deepLink;

  const BannerItem({
    required this.id,
    this.type,
    this.title,
    this.imageUrl,
    this.link,
    this.storeId,
    this.productId,
    this.menuCategoryId,
    this.status = 1,
    this.sortOrder = 0,
    this.subtitle = '',
    this.ctaText = '',
    this.discountText = '',
    this.deepLink = '',
  });

  bool get isActive => status == 1;

  @override
  List<Object?> get props => [
    id,
    type,
    title,
    imageUrl,
    link,
    storeId,
    productId,
    menuCategoryId,
    status,
    sortOrder,
  ];
}
