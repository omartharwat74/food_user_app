import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/core/usecases/usecase.dart';
import 'package:food_user_app/features/support/domain/entities/support_message.dart';
import 'package:food_user_app/features/support/domain/repositories/support_repository.dart';

class SendMessageParams extends Equatable {
  final String ticketId;
  final String content;

  const SendMessageParams({required this.ticketId, required this.content});

  @override
  List<Object?> get props => [ticketId, content];
}

class SendMessageUseCase implements UseCase<SupportMessage, SendMessageParams> {
  final SupportRepository repository;

  SendMessageUseCase(this.repository);

  @override
  Future<Either<Failure, SupportMessage>> call(SendMessageParams params) async {
    return await repository.sendMessage(
      ticketId: params.ticketId,
      content: params.content,
    );
  }
}
