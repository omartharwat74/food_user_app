import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:food_user_app/features/cart/data/models/cart_coupon_response_dto.dart';
import 'package:food_user_app/features/cart/domain/repositories/cart_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class ApplyPromoParams extends Equatable {
  final String code;
  final double subtotal;
  final bool selfPickup;
  final int? addressId;

  const ApplyPromoParams({
    required this.code,
    required this.subtotal,
    this.selfPickup = false,
    this.addressId,
  });

  @override
  List<Object?> get props => [code, subtotal, selfPickup, addressId];
}

class ApplyPromoUseCase extends UseCase<CartCouponResponseDto, ApplyPromoParams> {
  final CartRepository repository;

  ApplyPromoUseCase({required this.repository});

  @override
  Future<Either<Failure, CartCouponResponseDto>> call(
    ApplyPromoParams params,
  ) async {
    return await repository.applyCoupon(
      code: params.code,
      selfPickup: params.selfPickup,
      addressId: params.addressId,
    );
  }
}
