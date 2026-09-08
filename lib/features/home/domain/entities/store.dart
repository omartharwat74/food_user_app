import 'package:equatable/equatable.dart';
import 'tag.dart';

/// A store card entity returned by `GET /api/v1/stores` and `GET /api/v1/stores/major`.
class Store extends Equatable {
  final int id;
  final int sectionId;
  final String name;
  final String? logo;
  final String? cover;

  /// True when this store is a "major" (featured) store.
  final bool isMajor;

  final int? prepTimeFrom;
  final int? prepTimeTo;

  /// Tags attached to this store (cuisine, category…).
  final List<Tag> tags;
  final bool hasOffer;
  final double? ratingAvg;
  final int? ratingCount;
  final String availability;

  const Store({
    required this.id,
    required this.sectionId,
    required this.name,
    this.logo,
    this.cover,
    this.isMajor = false,
    this.prepTimeFrom,
    this.prepTimeTo,
    this.tags = const [],
    this.hasOffer = false,
    this.ratingAvg,
    this.ratingCount,
    this.availability = 'open',
  });

  @override
  List<Object?> get props => [id, sectionId, name, logo, cover, isMajor, prepTimeFrom, prepTimeTo, tags, hasOffer, ratingAvg, ratingCount, availability];
}

/// The paginated result for stores including the `is_random` flag.
class StoreListResult extends Equatable {
  final List<Store> items;
  final StoreMeta meta;

  /// `true` when the backend returned random suggestions because the search
  /// query yielded no direct matches.
  final bool isRandom;

  const StoreListResult({
    required this.items,
    required this.meta,
    this.isRandom = false,
  });

  @override
  List<Object?> get props => [items, meta, isRandom];
}

class StoreMeta extends Equatable {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const StoreMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  bool get hasNextPage => currentPage < lastPage;

  @override
  List<Object?> get props => [currentPage, lastPage, perPage, total];
}
