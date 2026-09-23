import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_market_products_usecase.dart';
import '../../domain/usecases/get_market_sub_categories_usecase.dart';
import 'market_catalog_state.dart';

class MarketCatalogCubit extends Cubit<MarketCatalogState> {
  final GetMarketSubCategoriesUseCase _getSubCategoriesUseCase;
  final GetMarketProductsUseCase _getProductsUseCase;

  MarketCatalogCubit({
    required GetMarketSubCategoriesUseCase getSubCategoriesUseCase,
    required GetMarketProductsUseCase getProductsUseCase,
  }) : _getSubCategoriesUseCase = getSubCategoriesUseCase,
       _getProductsUseCase = getProductsUseCase,
       super(const MarketCatalogInitial());

  Future<void> selectCategory({
    required String marketId,
    required String categoryId,
  }) async {
    emit(const MarketCatalogLoading());

    final subCatResult = await _getSubCategoriesUseCase(
      GetMarketSubCategoriesParams(marketId: marketId, categoryId: categoryId),
    );

    if (isClosed) return;

    await subCatResult.fold(
      (failure) async {
        if (isClosed) return;
        emit(MarketCatalogError(failure.message));
      },
      (subCats) async {
        if (isClosed) return;
        if (subCats.isEmpty) {
          emit(
            MarketCatalogLoaded(
              selectedCategoryId: categoryId,
              subCategories: const [],
              selectedSubCategoryId: null,
              products: const [],
              isLoadingProducts: false,
            ),
          );
          return;
        }

        final firstSubId = subCats.first.id;
        final productsResult = await _getProductsUseCase(
          GetMarketProductsParams(
            marketId: marketId,
            categoryId: categoryId,
            subCategoryId: firstSubId,
          ),
        );

        if (isClosed) return;

        productsResult.fold(
          (failure) => emit(MarketCatalogError(failure.message)),
          (products) => emit(
            MarketCatalogLoaded(
              selectedCategoryId: categoryId,
              subCategories: subCats,
              selectedSubCategoryId: firstSubId,
              products: products,
              isLoadingProducts: false,
            ),
          ),
        );
      },
    );
  }

  Future<void> selectSubCategory({
    required String marketId,
    required String categoryId,
    required String subCategoryId,
  }) async {
    final currentState = state;
    if (currentState is! MarketCatalogLoaded) return;

    emit(
      currentState.copyWith(
        selectedSubCategoryId: subCategoryId,
        isLoadingProducts: true,
      ),
    );

    final productsResult = await _getProductsUseCase(
      GetMarketProductsParams(
        marketId: marketId,
        categoryId: categoryId,
        subCategoryId: subCategoryId,
      ),
    );

    if (isClosed) return;

    productsResult.fold(
      (failure) => emit(currentState.copyWith(isLoadingProducts: false)),
      (products) => emit(
        currentState.copyWith(products: products, isLoadingProducts: false),
      ),
    );
  }
}
