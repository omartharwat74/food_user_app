import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String id;
  final String userName;
  final double rating;
  final String comment;
  final String createdAt;

  const Review({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userName, rating, comment, createdAt];
}
