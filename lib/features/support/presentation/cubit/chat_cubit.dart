import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:food_user_app/features/support/domain/entities/support_message.dart';
import 'package:food_user_app/features/support/domain/usecases/get_messages_usecase.dart';
import 'package:food_user_app/features/support/domain/usecases/send_message_usecase.dart';

part 'chat_state.dart';
part 'chat_cubit.freezed.dart';

class ChatCubit extends Cubit<ChatState> {
  final GetMessagesUseCase _getMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;

  String? _ticketId;

  ChatCubit(this._getMessagesUseCase, this._sendMessageUseCase)
    : super(const ChatState.initial());

  Future<void> fetchMessages(String ticketId) async {
    _ticketId = ticketId;
    emit(const ChatState.loading());
    final result = await _getMessagesUseCase(ticketId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(ChatState.error(failure.message)),
      (messages) => emit(ChatState.loaded(messages)),
    );
  }

  Future<void> sendMessage(String text) async {
    if (_ticketId == null || text.isEmpty) return;

    final currentState = state;
    List<SupportMessage> currentMessages = [];
    if (currentState is _Loaded) {
      currentMessages = List.from(currentState.messages);
    }

    final result = await _sendMessageUseCase(
      SendMessageParams(ticketId: _ticketId!, content: text),
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(ChatState.error(failure.message));
        if (currentMessages.isNotEmpty) {
          emit(ChatState.loaded(currentMessages));
        }
      },
      (newMessage) {
        if (currentState is _Loaded) {
          emit(ChatState.loaded([...currentMessages, newMessage]));
        } else {
          emit(ChatState.loaded([newMessage]));
        }
      },
    );
  }
}
