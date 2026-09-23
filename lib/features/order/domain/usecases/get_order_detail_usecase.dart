import 'package:dartz/dartz.dart' hide Order;
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/core/usecases/usecase.dart';
import 'package:food_user_app/features/order/domain/entities/order.dart';
import 'package:food_user_app/features/order/domain/repositories/order_repository.dart';

class GetOrderDetailUseCase extends UseCase<Order, String> {
  final OrderRepository repository;

  GetOrderDetailUseCase(this.repository);

  @override
  Future<Either<Failure, Order>> call(String params) async {
    return await repository.getOrderDetails(params);
  }
}
