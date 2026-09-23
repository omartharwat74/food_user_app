import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:food_user_app/features/cart/domain/entities/promo.dart';

part 'promo_preview_response_dto.freezed.dart';
part 'promo_preview_response_dto.g.dart';

@freezed
abstract class PromoPreviewResponseDto with _$PromoPreviewResponseDto {
  const factory PromoPreviewResponseDto({
    required double discountAmount,
    required double total,
  }) = _PromoPreviewResponseDto;

  factory PromoPreviewResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PromoPreviewResponseDtoFromJson(json);
}

extension PromoPreviewResponseDtoMapper on PromoPreviewResponseDto {
  Promo toEntity(String? code) {
    return Promo(discountAmount: discountAmount, total: total, code: code);
  }
}
