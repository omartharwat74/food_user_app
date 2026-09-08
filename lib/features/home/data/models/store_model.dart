import 'package:food_user_app/features/home/domain/entities/store.dart';
import 'tag_model.dart';

/// Data model for a store object inside `GET /api/v1/stores` and
/// `GET /api/v1/stores/major` responses.
///
/// API store shape:
/// ```json
/// {
///   "id": 1,
///   "section_id": 1,
///   "name": "كينج برجر",
///   "logo": "http://.../logo.jpg",
///   "cover": "http://.../cover.jpg",
///   "is_major": false,
///   "prep_time_from": 30,
///   "prep_time_to": 45,
///   "tags": [{ "id": 2, "name": "برجر" }]
/// }
/// ```
class StoreModel extends Store {
  const StoreModel({
    required super.id,
    required super.sectionId,
    required super.name,
    super.logo,
    super.cover,
    super.isMajor,
    super.prepTimeFrom,
    super.prepTimeTo,
    super.tags,
    super.hasOffer,
    super.ratingAvg,
    super.ratingCount,
    super.availability,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    final rawTags = json['tags'];
    final tags = rawTags is List
        ? rawTags.map((t) {
            if (t is Map<String, dynamic>) {
              return TagModel(
                id: (t['id'] as num).toInt(),
                sectionId: json['section_id'] != null ? (json['section_id'] as num).toInt() : 0,
                name: t['name']?.toString() ?? '',
              );
            }
            return const TagModel(id: 0, sectionId: 0, name: '');
          }).toList()
        : <TagModel>[];

    return StoreModel(
      id: (json['id'] as num).toInt(),
      sectionId: json['section_id'] != null ? (json['section_id'] as num).toInt() : 0,
      name: json['name']?.toString() ?? '',
      logo: json['logo']?.toString(),
      cover: json['cover']?.toString(),
      isMajor: json['is_major'] == true,
      prepTimeFrom: json['prep_time_from'] != null ? (json['prep_time_from'] as num).toInt() : null,
      prepTimeTo: json['prep_time_to'] != null ? (json['prep_time_to'] as num).toInt() : null,
      tags: tags,
      hasOffer: json['has_offer'] == true,
      ratingAvg: json['rating_avg'] != null ? (json['rating_avg'] as num).toDouble() : null,
      ratingCount: json['rating_count'] != null ? (json['rating_count'] as num).toInt() : null,
      availability: json['availability']?.toString() ?? 'open',
    );
  }
}

/// Data model for the paginated stores response envelope:
/// ```json
/// {
///   "items": [...],
///   "meta": { "current_page": 1, "last_page": 1, "per_page": 10, "total": 5 },
///   "is_random": false
/// }
/// ```
class StoreListResultModel extends StoreListResult {
  const StoreListResultModel({
    required super.items,
    required super.meta,
    super.isRandom,
  });

  factory StoreListResultModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = rawItems is List
        ? rawItems.whereType<Map<String, dynamic>>().map(StoreModel.fromJson).toList()
        : <StoreModel>[];

    final rawMeta = json['meta'];
    final meta = rawMeta is Map<String, dynamic>
        ? StoreMetaModel.fromJson(rawMeta)
        : const StoreMetaModel(currentPage: 1, lastPage: 1, perPage: 10, total: 0);

    return StoreListResultModel(
      items: items,
      meta: meta,
      isRandom: json['is_random'] == true,
    );
  }
}

class StoreMetaModel extends StoreMeta {
  const StoreMetaModel({
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
  });

  factory StoreMetaModel.fromJson(Map<String, dynamic> json) {
    int i(String key) => json[key] != null ? (json[key] as num).toInt() : 0;
    return StoreMetaModel(
      currentPage: i('current_page'),
      lastPage: i('last_page'),
      perPage: i('per_page'),
      total: i('total'),
    );
  }
}
