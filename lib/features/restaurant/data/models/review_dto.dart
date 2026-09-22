import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:food_user_app/features/restaurant/domain/entities/review.dart';

part 'review_dto.freezed.dart';
part 'review_dto.g.dart';

@freezed
abstract class ReviewDto with _$ReviewDto {
  const factory ReviewDto({
    @Default('') String id,
    @JsonKey(name: 'user_name') String? userName,
    double? rating,
    String? comment,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _ReviewDto;

  factory ReviewDto.fromJson(Map<String, dynamic> json) =>
      _$ReviewDtoFromJson(json);
}

extension ReviewDtoMapper on ReviewDto {
  Review toEntity() {
    return Review(
      id: id,
      userName: userName ?? 'مستخدم',
      rating: rating ?? 0.0,
      comment: comment ?? '',
      createdAt: createdAt ?? '',
    );
  }
}
