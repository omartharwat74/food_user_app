import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:food_user_app/features/restaurant/domain/entities/offer.dart';

import 'package:food_user_app/core/utils/bool_converter.dart';

part 'offer_dto.freezed.dart';
part 'offer_dto.g.dart';

String _idFromJson(dynamic value) => value?.toString() ?? '';
String? _nullableIdFromJson(dynamic value) => value?.toString();

@freezed
abstract class OfferDto with _$OfferDto {
  const factory OfferDto({
    @JsonKey(fromJson: _idFromJson) @Default('') String id,
    @JsonKey(name: 'restaurantId', fromJson: _nullableIdFromJson)
    String? restaurantId,
    String? title,
    int? discountPercent,
    double? minOrderAmount,
    String? description,
    String? expiresAt,
    @IntBoolConverter() bool? active,
  }) = _OfferDto;

  factory OfferDto.fromJson(Map<String, dynamic> json) =>
      _$OfferDtoFromJson(json);
}

extension OfferDtoMapper on OfferDto {
  Offer toEntity() {
    return Offer(
      id: id,
      restaurantId: restaurantId ?? '',
      title: title ?? '',
      discountPercent: discountPercent ?? 0,
      minOrderAmount: minOrderAmount ?? 0.0,
      description: description ?? '',
      expiresAt: expiresAt != null ? DateTime.parse(expiresAt!) : DateTime(0),
      active: active ?? false,
    );
  }
}
