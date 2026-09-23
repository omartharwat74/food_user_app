import 'package:equatable/equatable.dart';
import '../../domain/entities/market_sub_category.dart';
import '../../domain/entities/product.dart';

abstract class MarketCatalogState extends Equatable {
  const MarketCatalogState();

  @override
  List<Object?> get props => [];
}

class MarketCatalogInitial extends MarketCatalogState {
  const MarketCatalogInitial();
}

class MarketCatalogLoading extends MarketCatalogState {
  const MarketCatalogLoading();
}

class MarketCatalogLoaded extends MarketCatalogState {
  final String selectedCategoryId;
  final List<MarketSubCategory> subCategories;
  final String? selectedSubCategoryId;
  final List<Product> products;
  final bool isLoadingProducts;

  const MarketCatalogLoaded({
    required this.selectedCategoryId,
    required this.subCategories,
    this.selectedSubCategoryId,
    required this.products,
    this.isLoadingProducts = false,
  });

  MarketCatalogLoaded copyWith({
    String? selectedCategoryId,
    List<MarketSubCategory>? subCategories,
    String? selectedSubCategoryId,
    List<Product>? products,
    bool? isLoadingProducts,
  }) {
    return MarketCatalogLoaded(
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      subCategories: subCategories ?? this.subCategories,
      selectedSubCategoryId:
          selectedSubCategoryId ?? this.selectedSubCategoryId,
      products: products ?? this.products,
      isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
    );
  }

  @override
  List<Object?> get props => [
    selectedCategoryId,
    subCategories,
    selectedSubCategoryId,
    products,
    isLoadingProducts,
  ];
}

class MarketCatalogError extends MarketCatalogState {
  final String message;

  const MarketCatalogError(this.message);

  @override
  List<Object?> get props => [message];
}
