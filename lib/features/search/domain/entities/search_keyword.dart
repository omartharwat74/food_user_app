import 'package:equatable/equatable.dart';

class SearchKeyword extends Equatable {
  final int id;
  final String term;
  final int sortOrder;

  const SearchKeyword({
    required this.id,
    required this.term,
    required this.sortOrder,
  });

  factory SearchKeyword.fromJson(Map<String, dynamic> json) {
    return SearchKeyword(
      id: json['id'] as int,
      term: json['term'] as String,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'term': term, 'sort_order': sortOrder};
  }

  @override
  List<Object?> get props => [id, term, sortOrder];
}
