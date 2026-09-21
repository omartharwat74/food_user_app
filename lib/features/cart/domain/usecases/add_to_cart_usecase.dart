import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/core/usecases/usecase.dart';
import 'package:food_user_app/features/cart/domain/entities/cart.dart';
import 'package:food_user_app/features/cart/domain/repositories/cart_repository.dart';

class AddToCartUseCase implements UseCase<Cart, AddToCartParams> {
  final CartRepository repository;

  AddToCartUseCase({required this.repository});

  @override
  Future<Either<Failure, Cart>> call(AddToCartParams params) async {
    return await repository.addToCart(
      productId: params.productId,
      quantity: params.quantity,
      optionValueIds: params.optionValueIds,
    );
  }
}

class AddToCartParams extends Equatable {
  final String productId;
  final int quantity;
  final List<int> optionValueIds;

  const AddToCartParams({
    required this.productId,
    required this.quantity,
    required this.optionValueIds,
  });

  @override
  List<Object?> get props => [productId, quantity, optionValueIds];
}
