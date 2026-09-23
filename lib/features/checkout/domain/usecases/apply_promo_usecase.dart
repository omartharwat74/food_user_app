import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:food_user_app/features/cart/domain/entities/promo.dart';
import 'package:food_user_app/features/cart/domain/repositories/cart_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class ApplyPromoParams extends Equatable {
  final String code;
  final double subtotal;

  const ApplyPromoParams({required this.code, required this.subtotal});

  @override
  List<Object?> get props => [code, subtotal];
}

class ApplyPromoUseCase extends UseCase<Promo, ApplyPromoParams> {
  final CartRepository repository;

  ApplyPromoUseCase({required this.repository});

  @override
  Future<Either<Failure, Promo>> call(ApplyPromoParams params) async {
    return await repository.applyPromo(
      code: params.code,
      subtotal: params.subtotal,
    );
  }
}
