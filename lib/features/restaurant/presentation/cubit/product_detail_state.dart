import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:food_user_app/features/restaurant/domain/entities/menu_item.dart';

part 'product_detail_state.freezed.dart';

@freezed
abstract class ProductDetailState with _$ProductDetailState {
  const factory ProductDetailState.initial() = _Initial;
  const factory ProductDetailState.loading() = _Loading;
  const factory ProductDetailState.loaded(MenuItem product) = _Loaded;
  const factory ProductDetailState.error(String message) = _Error;
}
