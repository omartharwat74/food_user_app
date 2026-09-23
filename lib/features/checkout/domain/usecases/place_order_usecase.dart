import 'package:dartz/dartz.dart' hide Order;
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/core/usecases/usecase.dart';
import 'package:food_user_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:food_user_app/features/order/data/models/place_order_request.dart';
import 'package:food_user_app/features/order/domain/entities/order.dart';
import 'package:food_user_app/features/order/domain/repositories/order_repository.dart';
import 'package:food_user_app/features/payment/domain/repositories/payment_repository.dart';
import 'package:food_user_app/features/address/domain/repositories/address_repository.dart';

class PlaceOrderUseCase extends UseCase<Order, NoParams> {
  final OrderRepository orderRepository;
  final CartRepository cartRepository;
  final PaymentRepository paymentRepository;
  final AddressRepository addressRepository;

  PlaceOrderUseCase({
    required this.orderRepository,
    required this.cartRepository,
    required this.paymentRepository,
    required this.addressRepository,
  });

  @override
  Future<Either<Failure, Order>> call(NoParams params) async {
    final cartResult = await cartRepository.getCart();
    return cartResult.fold<Future<Either<Failure, Order>>>(
      (failure) async => Left(failure),
      (cart) async {
        if (cart.items.isEmpty) {
          return const Left(ServerFailure('Cart is empty'));
        }

        final addressResult = await addressRepository.getAddresses();
        return addressResult.fold<Future<Either<Failure, Order>>>(
          (failure) async => Left(failure),
          (addresses) async {
            final defaultAddress = addresses.firstWhere(
              (a) => a.isDefault,
              orElse: () => addresses.isNotEmpty
                  ? addresses.first
                  : throw Exception('No address found'),
            ); // In a real app we might pass selected address ID

            final paymentResult = await paymentRepository.getSavedCards();
            return paymentResult.fold<Future<Either<Failure, Order>>>(
              (failure) async => Left(failure),
              (payments) async {
                final defaultPayment = payments.firstWhere(
                  (p) => p.isDefault,
                  orElse: () => payments.isNotEmpty
                      ? payments.first
                      : throw Exception('No payment found'),
                );

                final request = PlaceOrderRequest(
                  branchId: cart.restaurantId ?? '',
                  items: cart.items
                      .map(
                        (e) => OrderItemRequest(
                          menuItemId: e.menuItemId,
                          quantity: e.quantity,
                          selectedModifiers: e.selectedModifiers,
                          notes: e.notes,
                        ),
                      )
                      .toList(),
                  addressId: defaultAddress.id,
                  paymentMethod: defaultPayment.gateway ?? 'CASH',
                  promoCode: null,
                );

                return await orderRepository.placeOrder(request);
              },
            );
          },
        );
      },
    );
  }
}
