import 'package:dartz/dartz.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/core/usecases/usecase.dart';
import 'package:food_user_app/features/cart/domain/entities/cart_extra_item.dart';
import 'package:food_user_app/features/cart/domain/repositories/cart_repository.dart';

class GetCartExtrasUseCase extends UseCase<List<CartExtraItem>, String> {
  final CartRepository repository;

  GetCartExtrasUseCase({required this.repository});

  @override
  Future<Either<Failure, List<CartExtraItem>>> call(String storeId) async {
    return await repository.getCartExtras(storeId: storeId);
  }
}
