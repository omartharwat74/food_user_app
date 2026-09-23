import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/usecases/usecase.dart';
import 'package:food_user_app/features/payment/domain/usecases/delete_card_usecase.dart';
import 'package:food_user_app/features/payment/domain/usecases/get_saved_cards_usecase.dart';
import 'package:food_user_app/features/payment/domain/usecases/save_card_usecase.dart';
import 'package:food_user_app/features/payment/presentation/cubit/payment_method_state.dart';
import 'package:food_user_app/features/payment/domain/entities/payment_card.dart';

class PaymentMethodCubit extends Cubit<PaymentMethodState> {
  final GetSavedCardsUseCase getSavedCardsUseCase;
  final SaveCardUseCase saveCardUseCase;
  final DeleteCardUseCase deleteCardUseCase;

  PaymentMethodCubit({
    required this.getSavedCardsUseCase,
    required this.saveCardUseCase,
    required this.deleteCardUseCase,
  }) : super(const PaymentMethodState.initial());

  Future<void> fetchSavedCards() async {
    emit(const PaymentMethodState.loading());
    final result = await getSavedCardsUseCase(NoParams());
    if (isClosed) return;
    result.fold(
      (failure) => emit(PaymentMethodState.error(failure.message)),
      (cards) => emit(PaymentMethodState.loaded(cards)),
    );
  }

  Future<void> saveCard(SaveCardParams params) async {
    final currentState = state;
    emit(const PaymentMethodState.loading());
    final result = await saveCardUseCase(params);
    if (isClosed) return;
    result.fold(
      (failure) {
        emit(PaymentMethodState.error(failure.message));
        // Restore previous state if possible
        currentState.maybeWhen(
          loaded: (cards) => emit(PaymentMethodState.loaded(cards)),
          orElse: () {},
        );
      },
      (card) {
        currentState.maybeWhen(
          loaded: (cards) {
            emit(PaymentMethodState.loaded([...cards, card]));
          },
          orElse: () {
            emit(PaymentMethodState.loaded([card]));
          },
        );
      },
    );
  }

  Future<void> deleteCard(String cardId) async {
    final currentState = state;
    final List<PaymentCard>? oldCards = currentState.maybeWhen(
      loaded: (cards) => cards,
      orElse: () => null,
    );

    if (oldCards == null) return;

    // Optimistic UI: remove card immediately
    final newCards = oldCards.where((c) => c.id != cardId).toList();
    emit(PaymentMethodState.loaded(newCards));

    final result = await deleteCardUseCase(DeleteCardParams(cardId: cardId));
    if (isClosed) return;
    result.fold(
      (failure) {
        // Rollback on failure
        emit(PaymentMethodState.error(failure.message));
        emit(PaymentMethodState.loaded(oldCards));
      },
      (_) {
        // Success: state is already updated
      },
    );
  }
}
