import 'package:equatable/equatable.dart';

class Ticket extends Equatable {
  final String id;
  final String userId;
  final String subject;
  final String status;
  final String? assigneeId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Ticket({
    required this.id,
    required this.userId,
    required this.subject,
    required this.status,
    this.assigneeId,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    subject,
    status,
    assigneeId,
    createdAt,
    updatedAt,
  ];
}
