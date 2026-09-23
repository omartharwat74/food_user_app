import 'package:equatable/equatable.dart';

class SearchLog extends Equatable {
  final int id;
  final String term;
  final String searchedAt;

  const SearchLog({
    required this.id,
    required this.term,
    required this.searchedAt,
  });

  factory SearchLog.fromJson(Map<String, dynamic> json) {
    return SearchLog(
      id: json['id'] as int,
      term: json['term'] as String,
      searchedAt: json['searched_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'term': term, 'searched_at': searchedAt};
  }

  @override
  List<Object?> get props => [id, term, searchedAt];
}
