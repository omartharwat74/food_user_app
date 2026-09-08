import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/core/usecases/usecase.dart';
import 'package:food_user_app/features/home/domain/entities/section.dart';
import 'package:food_user_app/features/home/domain/entities/tag.dart';
import 'package:food_user_app/features/home/domain/entities/store.dart';
import 'package:food_user_app/features/home/domain/entities/spotlight.dart';
import 'package:food_user_app/features/home/domain/repositories/home_repository.dart';

// ── Sections ──────────────────────────────────────────────────────────────────

/// `GET /api/v1/sections`
class GetSectionsUseCase extends UseCase<List<Section>, NoParams> {
  GetSectionsUseCase(this._repository);
  final HomeRepository _repository;

  @override
  Future<Either<Failure, List<Section>>> call(NoParams params) {
    return _repository.getSections();
  }
}

// ── Tags ──────────────────────────────────────────────────────────────────────

class GetTagsParams extends Equatable {
  final int? sectionId;
  const GetTagsParams({this.sectionId});

  @override
  List<Object?> get props => [sectionId];
}

/// `GET /api/v1/tags?section_id={id}`
class GetTagsUseCase extends UseCase<List<Tag>, GetTagsParams> {
  GetTagsUseCase(this._repository);
  final HomeRepository _repository;

  @override
  Future<Either<Failure, List<Tag>>> call(GetTagsParams params) {
    return _repository.getTags(sectionId: params.sectionId);
  }
}

// ── Stores ────────────────────────────────────────────────────────────────────

class GetStoresParams extends Equatable {
  final int sectionId;
  final String? search;
  final List<int>? tagIds;
  final int page;
  final int perPage;
  final int? fastPrep;
  final int? topRated;
  final int? hasOffers;

  const GetStoresParams({
    required this.sectionId,
    this.search,
    this.tagIds,
    this.page = 1,
    this.perPage = 10,
    this.fastPrep,
    this.topRated,
    this.hasOffers,
  });

  @override
  List<Object?> get props => [sectionId, search, tagIds, page, perPage, fastPrep, topRated, hasOffers];
}

/// `GET /api/v1/stores`
class GetStoresUseCase extends UseCase<StoreListResult, GetStoresParams> {
  GetStoresUseCase(this._repository);
  final HomeRepository _repository;

  @override
  Future<Either<Failure, StoreListResult>> call(GetStoresParams params) {
    return _repository.getStores(
      sectionId: params.sectionId,
      search: params.search,
      tagIds: params.tagIds,
      page: params.page,
      perPage: params.perPage,
      fastPrep: params.fastPrep,
      topRated: params.topRated,
      hasOffers: params.hasOffers,
    );
  }
}

// ── Major Stores ──────────────────────────────────────────────────────────────

class GetMajorStoresParams extends Equatable {
  final int sectionId;
  final int page;
  final int perPage;

  const GetMajorStoresParams({
    required this.sectionId,
    this.page = 1,
    this.perPage = 10,
  });

  @override
  List<Object?> get props => [sectionId, page, perPage];
}

/// `GET /api/v1/stores/major`
class GetMajorStoresUseCase extends UseCase<StoreListResult, GetMajorStoresParams> {
  GetMajorStoresUseCase(this._repository);
  final HomeRepository _repository;

  @override
  Future<Either<Failure, StoreListResult>> call(GetMajorStoresParams params) {
    return _repository.getMajorStores(
      sectionId: params.sectionId,
      page: params.page,
      perPage: params.perPage,
    );
  }
}

// ── Spotlights ────────────────────────────────────────────────────────────────

class GetSpotlightsParams extends Equatable {
  final int? sectionId;
  const GetSpotlightsParams({this.sectionId});

  @override
  List<Object?> get props => [sectionId];
}

/// `GET /api/v1/spotlights`
class GetSpotlightsUseCase extends UseCase<List<Spotlight>, GetSpotlightsParams> {
  GetSpotlightsUseCase(this._repository);
  final HomeRepository _repository;

  @override
  Future<Either<Failure, List<Spotlight>>> call(GetSpotlightsParams params) {
    return _repository.getSpotlights(sectionId: params.sectionId);
  }
}
