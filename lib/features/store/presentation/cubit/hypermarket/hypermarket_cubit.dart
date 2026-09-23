import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/store/data/models/hyper_categories_response.dart';
import 'package:food_user_app/features/store/data/models/hyper_sections_response.dart';
import 'package:food_user_app/features/store/domain/repositories/store_repository.dart';

abstract class HypermarketState extends Equatable {
  const HypermarketState();

  @override
  List<Object?> get props => [];
}

class HypermarketInitial extends HypermarketState {
  const HypermarketInitial();
}

class HypermarketLoading extends HypermarketState {
  const HypermarketLoading();
}

class HypermarketLoaded extends HypermarketState {
  final List<HyperCategory> categories;
  final List<HyperSection> sections;
  final String? selectedCategoryId;
  final bool isLoadingSections;

  const HypermarketLoaded({
    required this.categories,
    required this.sections,
    this.selectedCategoryId,
    this.isLoadingSections = false,
  });

  HypermarketLoaded copyWith({
    List<HyperCategory>? categories,
    List<HyperSection>? sections,
    String? selectedCategoryId,
    bool? isLoadingSections,
  }) {
    return HypermarketLoaded(
      categories: categories ?? this.categories,
      sections: sections ?? this.sections,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      isLoadingSections: isLoadingSections ?? this.isLoadingSections,
    );
  }

  @override
  List<Object?> get props => [
    categories,
    sections,
    selectedCategoryId,
    isLoadingSections,
  ];
}

class HypermarketError extends HypermarketState {
  final String message;

  const HypermarketError(this.message);

  @override
  List<Object> get props => [message];
}

class HypermarketCubit extends Cubit<HypermarketState> {
  final StoreRepository _repository;
  String? _storeId;

  HypermarketCubit({required StoreRepository repository})
    : _repository = repository,
      super(const HypermarketInitial());

  Future<void> fetchCategories(String storeId) async {
    _storeId = storeId;
    emit(const HypermarketLoading());

    final result = await _repository.getStoreCategories(storeId);
    if (isClosed) return;

    result.fold((failure) => emit(HypermarketError(failure.message)), (
      response,
    ) {
      final categories = response.data.categories;
      emit(HypermarketLoaded(categories: categories, sections: const []));

      // Optionally auto-fetch the first category
      if (categories.isNotEmpty) {
        fetchSections(categories.first.id.toString());
      }
    });
  }

  Future<void> fetchSections(String categoryId) async {
    if (_storeId == null) return;

    final currentState = state;
    if (currentState is HypermarketLoaded) {
      emit(
        currentState.copyWith(
          selectedCategoryId: categoryId,
          isLoadingSections: true,
        ),
      );
    } else {
      emit(const HypermarketLoading());
    }

    final result = await _repository.getStoreCategorySections(
      storeId: _storeId!,
      categoryId: categoryId,
    );
    if (isClosed) return;

    result.fold(
      (failure) {
        if (state is HypermarketLoaded) {
          emit((state as HypermarketLoaded).copyWith(isLoadingSections: false));
          // You might want to handle error side-effects here
        } else {
          emit(HypermarketError(failure.message));
        }
      },
      (response) {
        if (state is HypermarketLoaded) {
          emit(
            (state as HypermarketLoaded).copyWith(
              sections: response.data.sections,
              isLoadingSections: false,
            ),
          );
        } else {
          emit(
            HypermarketLoaded(
              categories: const [], // if somehow state was lost
              sections: response.data.sections,
              selectedCategoryId: categoryId,
            ),
          );
        }
      },
    );
  }
}
