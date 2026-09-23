import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:food_user_app/features/support/domain/entities/ticket.dart';
import 'package:food_user_app/features/support/domain/usecases/create_ticket_usecase.dart';

part 'support_ticket_state.dart';
part 'support_ticket_cubit.freezed.dart';

class SupportTicketCubit extends Cubit<SupportTicketState> {
  final CreateTicketUseCase _createTicketUseCase;

  SupportTicketCubit(this._createTicketUseCase)
    : super(const SupportTicketState.initial());

  Future<void> createTicket({
    required String subject,
    required String message,
  }) async {
    emit(const SupportTicketState.loading());
    final result = await _createTicketUseCase(
      CreateTicketParams(subject: subject, message: message),
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(SupportTicketState.error(failure.message)),
      (ticket) => emit(SupportTicketState.success(ticket)),
    );
  }
}
