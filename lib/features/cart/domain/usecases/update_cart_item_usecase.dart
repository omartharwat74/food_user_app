import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:food_user_app/features/cart/domain/entities/cart.dart';
import 'package:food_user_app/features/cart/domain/repositories/cart_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class UpdateCartItemParams extends Equatable {
  final String itemId;
  final int quantity;

  const UpdateCartItemParams({required this.itemId, required this.quantity});

  @override
  List<Object?> get props => [itemId, quantity];
}

class UpdateCartItemUseCase extends UseCase<Cart, UpdateCartItemParams> {
  final CartRepository repository;

  UpdateCartItemUseCase({required this.repository});

  @override
  Future<Either<Failure, Cart>> call(UpdateCartItemParams params) async {
    return await repository.updateCartItem(
      itemId: params.itemId,
      quantity: params.quantity,
    );
  }
}
