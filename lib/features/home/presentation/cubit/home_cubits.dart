import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_user_app/core/usecases/usecase.dart';
import 'package:food_user_app/features/home/domain/entities/app_settings.dart';
import 'package:food_user_app/features/home/domain/entities/section.dart';
import 'package:food_user_app/features/home/domain/entities/tag.dart';
import 'package:food_user_app/features/home/domain/entities/store.dart';
import 'package:food_user_app/features/home/domain/entities/spotlight.dart';
import 'package:food_user_app/features/home/domain/usecases/get_general_settings_usecase.dart';
import 'package:food_user_app/features/home/domain/usecases/home_usecases.dart';

// ══════════════════════════════════════════════════════════════════════════════
// SettingsCubit
// ══════════════════════════════════════════════════════════════════════════════

abstract class SettingsState extends Equatable {
  const SettingsState();
  @override
  List<Object?> get props => [];
}
class SettingsInitial extends SettingsState { const SettingsInitial(); }
class SettingsLoading extends SettingsState { const SettingsLoading(); }
class SettingsLoaded extends SettingsState {
  final AppSettings settings;
  const SettingsLoaded(this.settings);
  @override List<Object?> get props => [settings];
}
class SettingsError extends SettingsState {
  final String message;
  const SettingsError(this.message);
  @override List<Object?> get props => [message];
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({required this.getGeneralSettingsUseCase}) : super(const SettingsInitial());

  final GetGeneralSettingsUseCase getGeneralSettingsUseCase;

  Future<void> fetchSettings() async {
    emit(const SettingsLoading());
    final result = await getGeneralSettingsUseCase(const NoParams());
    if (isClosed) return;
    result.fold(
      (f) => emit(SettingsError(f.message)),
      (s) => emit(SettingsLoaded(s)),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SectionsCubit
// ══════════════════════════════════════════════════════════════════════════════

abstract class SectionsState extends Equatable {
  const SectionsState();
  @override List<Object?> get props => [];
}
class SectionsInitial extends SectionsState { const SectionsInitial(); }
class SectionsLoading extends SectionsState { const SectionsLoading(); }
class SectionsLoaded extends SectionsState {
  final List<Section> sections;
  const SectionsLoaded(this.sections);
  @override List<Object?> get props => [sections];
}
class SectionsError extends SectionsState {
  final String message;
  const SectionsError(this.message);
  @override List<Object?> get props => [message];
}

class SectionsCubit extends Cubit<SectionsState> {
  SectionsCubit({required this.getSectionsUseCase}) : super(const SectionsInitial());

  final GetSectionsUseCase getSectionsUseCase;

  Future<void> fetchSections() async {
    emit(const SectionsLoading());
    final result = await getSectionsUseCase(const NoParams());
    if (isClosed) return;
    result.fold(
      (f) => emit(SectionsError(f.message)),
      (s) => emit(SectionsLoaded(s)),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// TagsCubit
// ══════════════════════════════════════════════════════════════════════════════

abstract class TagsState extends Equatable {
  const TagsState();
  @override List<Object?> get props => [];
}
class TagsInitial extends TagsState { const TagsInitial(); }
class TagsLoading extends TagsState { const TagsLoading(); }
class TagsLoaded extends TagsState {
  final List<Tag> tags;
  final int sectionId;
  const TagsLoaded({required this.tags, required this.sectionId});
  @override List<Object?> get props => [tags, sectionId];
}
class TagsError extends TagsState {
  final String message;
  const TagsError(this.message);
  @override List<Object?> get props => [message];
}

class TagsCubit extends Cubit<TagsState> {
  TagsCubit({required this.getTagsUseCase}) : super(const TagsInitial());

  final GetTagsUseCase getTagsUseCase;

  Future<void> fetchTags({required int sectionId}) async {
    emit(const TagsLoading());
    final result = await getTagsUseCase(GetTagsParams(sectionId: sectionId));
    if (isClosed) return;
    result.fold(
      (f) => emit(TagsError(f.message)),
      (t) => emit(TagsLoaded(tags: t, sectionId: sectionId)),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// StoresCubit
// ══════════════════════════════════════════════════════════════════════════════

abstract class StoresState extends Equatable {
  const StoresState();
  @override List<Object?> get props => [];
}
class StoresInitial extends StoresState { const StoresInitial(); }
class StoresLoading extends StoresState { const StoresLoading(); }
class StoresLoaded extends StoresState {
  final List<Store> items;
  final StoreMeta meta;
  final bool isRandom;
  const StoresLoaded({required this.items, required this.meta, this.isRandom = false});
  @override List<Object?> get props => [items, meta, isRandom];
}
class StoresError extends StoresState {
  final String message;
  const StoresError(this.message);
  @override List<Object?> get props => [message];
}

class StoresCubit extends Cubit<StoresState> {
  StoresCubit({required this.getStoresUseCase}) : super(const StoresInitial());

  final GetStoresUseCase getStoresUseCase;

  Future<void> fetchStores({
    required int sectionId,
    String? search,
    List<int>? tagIds,
    int page = 1,
    int perPage = 10,
    int? fastPrep,
    int? topRated,
    int? hasOffers,
  }) async {
    emit(const StoresLoading());
    final result = await getStoresUseCase(
      GetStoresParams(
        sectionId: sectionId,
        search: search,
        tagIds: tagIds,
        page: page,
        perPage: perPage,
        fastPrep: fastPrep,
        topRated: topRated,
        hasOffers: hasOffers,
      ),
    );
    if (isClosed) return;
    result.fold(
      (f) => emit(StoresError(f.message)),
      (r) => emit(StoresLoaded(items: r.items, meta: r.meta, isRandom: r.isRandom)),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// MajorStoresCubit
// ══════════════════════════════════════════════════════════════════════════════

abstract class MajorStoresState extends Equatable {
  const MajorStoresState();
  @override List<Object?> get props => [];
}
class MajorStoresInitial extends MajorStoresState { const MajorStoresInitial(); }
class MajorStoresLoading extends MajorStoresState { const MajorStoresLoading(); }
class MajorStoresLoaded extends MajorStoresState {
  final List<Store> items;
  final StoreMeta meta;
  const MajorStoresLoaded({required this.items, required this.meta});
  @override List<Object?> get props => [items, meta];
}
class MajorStoresError extends MajorStoresState {
  final String message;
  const MajorStoresError(this.message);
  @override List<Object?> get props => [message];
}

class MajorStoresCubit extends Cubit<MajorStoresState> {
  MajorStoresCubit({required this.getMajorStoresUseCase}) : super(const MajorStoresInitial());

  final GetMajorStoresUseCase getMajorStoresUseCase;

  Future<void> fetchMajorStores({
    required int sectionId,
    int page = 1,
    int perPage = 10,
  }) async {
    emit(const MajorStoresLoading());
    final result = await getMajorStoresUseCase(
      GetMajorStoresParams(sectionId: sectionId, page: page, perPage: perPage),
    );
    if (isClosed) return;
    result.fold(
      (f) => emit(MajorStoresError(f.message)),
      (r) => emit(MajorStoresLoaded(items: r.items, meta: r.meta)),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SpotlightsCubit
// ══════════════════════════════════════════════════════════════════════════════

abstract class SpotlightsState extends Equatable {
  const SpotlightsState();
  @override List<Object?> get props => [];
}
class SpotlightsInitial extends SpotlightsState { const SpotlightsInitial(); }
class SpotlightsLoading extends SpotlightsState { const SpotlightsLoading(); }
class SpotlightsLoaded extends SpotlightsState {
  final List<Spotlight> spotlights;
  const SpotlightsLoaded(this.spotlights);
  @override List<Object?> get props => [spotlights];
}
class SpotlightsError extends SpotlightsState {
  final String message;
  const SpotlightsError(this.message);
  @override List<Object?> get props => [message];
}

class SpotlightsCubit extends Cubit<SpotlightsState> {
  SpotlightsCubit({required this.getSpotlightsUseCase}) : super(const SpotlightsInitial());

  final GetSpotlightsUseCase getSpotlightsUseCase;

  Future<void> fetchSpotlights({int? sectionId}) async {
    emit(const SpotlightsLoading());
    final result = await getSpotlightsUseCase(GetSpotlightsParams(sectionId: sectionId));
    if (isClosed) return;
    result.fold(
      (f) => emit(SpotlightsError(f.message)),
      (s) => emit(SpotlightsLoaded(s)),
    );
  }
}
