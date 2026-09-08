import 'package:dartz/dartz.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/features/home/domain/entities/app_settings.dart';
import 'package:food_user_app/features/home/domain/entities/section.dart';
import 'package:food_user_app/features/home/domain/entities/tag.dart';
import 'package:food_user_app/features/home/domain/entities/store.dart';
import 'package:food_user_app/features/home/domain/entities/spotlight.dart';

abstract class HomeRepository {
  /// `GET /api/v1/general-settings`
  Future<Either<Failure, AppSettings>> getGeneralSettings();

  /// `GET /api/v1/sections`
  Future<Either<Failure, List<Section>>> getSections();

  /// `GET /api/v1/tags?section_id={id}`
  Future<Either<Failure, List<Tag>>> getTags({int? sectionId});

  /// `GET /api/v1/stores` with optional search/tag filters and pagination.
  Future<Either<Failure, StoreListResult>> getStores({
    required int sectionId,
    String? search,
    List<int>? tagIds,
    int page = 1,
    int perPage = 10,
    int? fastPrep,
    int? topRated,
    int? hasOffers,
  });

  /// `GET /api/v1/stores/major` — featured stores for a section.
  Future<Either<Failure, StoreListResult>> getMajorStores({
    required int sectionId,
    int page = 1,
    int perPage = 10,
  });

  /// `GET /api/v1/spotlights`
  Future<Either<Failure, List<Spotlight>>> getSpotlights({int? sectionId});
}
