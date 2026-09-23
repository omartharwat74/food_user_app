import 'package:dartz/dartz.dart' hide Order;
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/core/usecases/usecase.dart';
import 'package:food_user_app/features/order/domain/entities/order.dart';
import 'package:food_user_app/features/order/domain/repositories/order_repository.dart';

class GetOrderHistoryUseCase extends UseCase<List<Order>, NoParams> {
  final OrderRepository repository;

  GetOrderHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<Order>>> call(NoParams params) async {
    return await repository.getOrderHistory();
  }
}
