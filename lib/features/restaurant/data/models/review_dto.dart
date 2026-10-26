import 'package:equatable/equatable.dart';
import 'package:food_user_app/features/restaurant/domain/entities/review.dart';

class ReviewDto extends Equatable {
  final String id;
  final String? userName;
  final double? rating;
  final String? comment;
  final String? createdAt;

  const ReviewDto({
    this.id = '',
    this.userName,
    this.rating,
    this.comment,
    this.createdAt,
  });

  factory ReviewDto.fromJson(Map<String, dynamic> json) {
    String? userName = json['user_name'] as String?;
    if (userName == null || userName.isEmpty) {
      final user = json['user'];
      if (user is Map) {
        final first = user['first_name']?.toString() ?? '';
        final last = user['last_name']?.toString() ?? '';
        final full = '$first $last'.trim();
        if (full.isNotEmpty) {
          userName = full;
        }
      }
    }

    return ReviewDto(
      id: json['id']?.toString() ?? '',
      userName: userName,
      rating: (json['rating'] as num?)?.toDouble(),
      comment: json['comment']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_name': userName,
        'rating': rating,
        'comment': comment,
        'created_at': createdAt,
      };

  @override
  List<Object?> get props => [id, userName, rating, comment, createdAt];
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
