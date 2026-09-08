import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/features/restaurant/domain/repositories/menu_repository.dart';
import 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final MenuRepository _menuRepository;

  ProductDetailCubit({required MenuRepository menuRepository})
      : _menuRepository = menuRepository,
        super(const ProductDetailState.initial());

  Future<void> fetchProductDetails(String productId) async {
    emit(const ProductDetailState.loading());
    final result = await _menuRepository.getProductDetail(productId);
    result.fold(
      (failure) => emit(ProductDetailState.error(failure.message)),
      (product) => emit(ProductDetailState.loaded(product)),
    );
  }
}
