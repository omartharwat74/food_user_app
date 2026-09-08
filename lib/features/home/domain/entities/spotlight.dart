import 'package:equatable/equatable.dart';
import 'store.dart';

class Spotlight extends Equatable {
  final int id;
  final String name;
  final bool hasMore;
  final List<Store> stores;

  const Spotlight({
    required this.id,
    required this.name,
    this.hasMore = false,
    this.stores = const [],
  });

  @override
  List<Object?> get props => [id, name, hasMore, stores];
}
