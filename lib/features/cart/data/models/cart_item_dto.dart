import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:food_user_app/features/cart/domain/entities/cart_item.dart';

part 'cart_item_dto.freezed.dart';
part 'cart_item_dto.g.dart';

@freezed
abstract class CartItemDto with _$CartItemDto {
  const factory CartItemDto({
    required String id,
    required String menuItemId,
    required String itemName,
    required int quantity,
    required double unitPrice,
    required double totalPrice,
    List<dynamic>? selectedModifiers,
    String? notes,
  }) = _CartItemDto;

  factory CartItemDto.fromJson(Map<String, dynamic> json) =>
      _$CartItemDtoFromJson(json);
}

extension CartItemDtoMapper on CartItemDto {
  CartItem toEntity() {
    return CartItem(
      id: id,
      menuItemId: menuItemId,
      name: itemName,
      description: notes ?? '',
      price: unitPrice.toDouble(),
      unitPrice: unitPrice,
      totalPrice: totalPrice,
      imageAsset: '',
      quantity: quantity,
      selectedModifiers: selectedModifiers,
      notes: notes,
    );
  }
}
