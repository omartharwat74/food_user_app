import 'package:dartz/dartz.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/features/cart/domain/entities/cart.dart';
import 'package:food_user_app/features/cart/domain/entities/promo.dart';

abstract class CartRepository {
  Future<Either<Failure, Cart>> getCart();
  Future<Either<Failure, Cart>> addToCart({
    required String productId,
    required int quantity,
    required List<int> optionValueIds,
  });
  Future<Either<Failure, Cart>> updateCartItem({
    required String itemId,
    required int quantity,
  });
  Future<Either<Failure, Cart>> removeFromCart(String itemId);
  Future<Either<Failure, Unit>> clearCart();
  Future<Either<Failure, Promo>> applyPromo({
    required String code,
    required double subtotal,
  });
}
