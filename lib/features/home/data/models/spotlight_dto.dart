import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:food_user_app/features/home/data/models/store_model.dart';
import 'package:food_user_app/features/home/domain/entities/spotlight.dart';

part 'spotlight_dto.g.dart';

@JsonSerializable(createToJson: false)
class SpotlightDto {
  final int id;
  final String name;
  @JsonKey(name: 'has_more')
  final bool hasMore;
  final List<StoreModel> stores;

  const SpotlightDto({
    required this.id,
    required this.name,
    this.hasMore = false,
    this.stores = const [],
  });

  factory SpotlightDto.fromJson(Map<String, dynamic> json) =>
      _$SpotlightDtoFromJson(json);
}

extension SpotlightDtoExtension on SpotlightDto {
  Spotlight toEntity() {
    return Spotlight(
      id: id,
      name: name,
      hasMore: hasMore,
      stores: stores, // StoreModel is a subtype of Store
    );
  }
}
