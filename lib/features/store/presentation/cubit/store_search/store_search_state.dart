import 'package:equatable/equatable.dart';
import 'package:food_user_app/features/store/data/models/hyper_sections_response.dart';

abstract class StoreSearchState extends Equatable {
  const StoreSearchState();

  @override
  List<Object?> get props => [];
}

class StoreSearchInitial extends StoreSearchState {
  const StoreSearchInitial();
}

class StoreSearchLoading extends StoreSearchState {
  const StoreSearchLoading();
}

class StoreSearchLoaded extends StoreSearchState {
  final List<HyperProduct> products;
  final bool isRandom;

  const StoreSearchLoaded({
    required this.products,
    this.isRandom = false,
  });

  @override
  List<Object?> get props => [products, isRandom];
}

class StoreSearchError extends StoreSearchState {
  final String message;

  const StoreSearchError(this.message);

  @override
  List<Object?> get props => [message];
}
