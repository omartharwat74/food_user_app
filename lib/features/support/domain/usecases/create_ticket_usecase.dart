import 'package:dartz/dartz.dart';
import 'package:food_user_app/core/errors/failures.dart';
import 'package:food_user_app/core/usecases/usecase.dart';
import 'package:food_user_app/features/support/domain/entities/ticket.dart';
import 'package:food_user_app/features/support/domain/repositories/support_repository.dart';

class CreateTicketUseCase implements UseCase<Ticket, CreateTicketParams> {
  final SupportRepository repository;

  CreateTicketUseCase(this.repository);

  @override
  Future<Either<Failure, Ticket>> call(CreateTicketParams params) async {
    return await repository.createTicket(
      subject: params.subject,
      message: params.message,
    );
  }
}

class CreateTicketParams {
  final String subject;
  final String message;

  const CreateTicketParams({required this.subject, required this.message});
}
