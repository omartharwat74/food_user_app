import 'package:equatable/equatable.dart';
import 'package:food_user_app/features/cart/domain/entities/cart_extra_item.dart';

class CartExtrasState extends Equatable {
  final List<CartExtraItem> items;
  final bool isLoading;
  final int? addingProductId;
  final String? errorMessage;

  const CartExtrasState({
    this.items = const [],
    this.isLoading = false,
    this.addingProductId,
    this.errorMessage,
  });

  bool get isEmpty => items.isEmpty;

  CartExtrasState copyWith({
    List<CartExtraItem>? items,
    bool? isLoading,
    int? addingProductId,
    bool clearAdding = false,
    String? errorMessage,
  }) {
    return CartExtrasState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      addingProductId: clearAdding ? null : (addingProductId ?? this.addingProductId),
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [items, isLoading, addingProductId, errorMessage];
}
