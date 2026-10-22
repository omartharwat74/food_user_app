import 'package:dartz/dartz.dart' hide Order;
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/core/usecases/usecase.dart';
import 'package:food_user_app/features/order/data/models/place_order_request.dart';
import 'package:food_user_app/features/order/domain/entities/order.dart';
import 'package:food_user_app/features/order/domain/repositories/order_repository.dart';

class PlaceOrderUseCase implements UseCase<Order, PlaceOrderRequest> {
  final OrderRepository repository;

  PlaceOrderUseCase({required this.repository});

  @override
  Future<Either<Failure, Order>> call(PlaceOrderRequest params) {
    return repository.placeOrder(params);
  }
}
