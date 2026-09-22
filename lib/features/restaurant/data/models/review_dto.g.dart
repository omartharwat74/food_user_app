// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReviewDto _$ReviewDtoFromJson(Map<String, dynamic> json) => _ReviewDto(
  id: json['id'] as String? ?? '',
  userName: json['user_name'] as String?,
  rating: (json['rating'] as num?)?.toDouble(),
  comment: json['comment'] as String?,
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$ReviewDtoToJson(_ReviewDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_name': instance.userName,
      'rating': instance.rating,
      'comment': instance.comment,
      'created_at': instance.createdAt,
    };
