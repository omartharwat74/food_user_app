import 'package:dartz/dartz.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/core/usecases/usecase.dart';
import 'package:food_user_app/features/cart/domain/entities/cart_extra_item.dart';
import 'package:food_user_app/features/cart/domain/repositories/cart_repository.dart';

class GetCartExtrasUseCase extends UseCase<List<CartExtraItem>, NoParams> {
  final CartRepository repository;

  GetCartExtrasUseCase({required this.repository});

  @override
  Future<Either<Failure, List<CartExtraItem>>> call(NoParams params) async {
    return await repository.getCartExtras();
  }
}
