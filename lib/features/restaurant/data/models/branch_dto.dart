import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:food_user_app/features/restaurant/domain/entities/branch.dart';

import 'package:food_user_app/core/utils/bool_converter.dart';

part 'branch_dto.freezed.dart';
part 'branch_dto.g.dart';

String _idFromJson(dynamic value) => value?.toString() ?? '';
String? _nullableIdFromJson(dynamic value) => value?.toString();

@freezed
abstract class BranchDto with _$BranchDto {
  const factory BranchDto({
    @JsonKey(fromJson: _idFromJson) @Default('') String id,
    @JsonKey(name: 'restaurantId', fromJson: _nullableIdFromJson)
    String? restaurantId,
    String? address,
    double? lat,
    double? lng,
    Map<String, dynamic>? operatingHours,
    @IntBoolConverter() bool? active,
  }) = _BranchDto;

  factory BranchDto.fromJson(Map<String, dynamic> json) =>
      _$BranchDtoFromJson(json);
}

extension BranchDtoMapper on BranchDto {
  Branch toEntity() {
    return Branch(
      id: id,
      restaurantId: restaurantId ?? '',
      address: address ?? '',
      lat: lat ?? 0.0,
      lng: lng ?? 0.0,
      operatingHours: operatingHours ?? {},
      active: active ?? false,
    );
  }
}
