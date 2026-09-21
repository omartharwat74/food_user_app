import re

with open('lib/features/cart/data/models/cart_response_dto.dart', 'r') as f:
    content = f.read()

# Replace CartItemDto
new_dto = """@JsonSerializable()
class CartItemDto {
  final int? id;
  @JsonKey(name: 'product_id')
  final int? productId;
  final int? quantity;
  final num? price;
  @JsonKey(name: 'unit_price')
  final num? unitPrice;
  final num? total;
  @JsonKey(name: 'total_price')
  final num? totalPrice;
  final String? name;
  final String? image;
  
  @JsonKey(name: 'option_value_ids', defaultValue: [])
  final List<int>? optionValueIds;

  CartItemDto({
    required this.id,
    required this.productId,
    required this.quantity,
    this.price,
    this.unitPrice,
    this.total,
    this.totalPrice,
    required this.name,
    this.image,
    required this.optionValueIds,
  });

  factory CartItemDto.fromJson(Map<String, dynamic> json) =>
      _$CartItemDtoFromJson(json);
}"""

content = re.sub(r'@JsonSerializable\(\)\nclass CartItemDto \{[\s\S]*?_\$CartItemDtoFromJson\(json\);\n\}', new_dto, content)

# Update Mapper
old_mapper = r"""      items: \(data\.items \?\? \[\]\)\.map\(\(item\) => CartItem\(
        id: item\.id\?\.toString\(\) \?\? '',
        menuItemId: item\.productId\?\.toString\(\) \?\? '',
        name: item\.name \?\? '',
        price: \(item\.price \?\? 0\)\.toInt\(\),
        unitPrice: \(item\.price \?\? 0\)\.toDouble\(\),
        totalPrice: \(item\.total \?\? 0\)\.toDouble\(\),
        quantity: item\.quantity \?\? 1,
        selectedModifiers: \(item\.optionValueIds \?\? \[\]\)\.map\(\(id\) => <String, dynamic>\{'option_id': id\}\)\.toList\(\),
        notes: '',
      \)\)\.toList\(\),"""

new_mapper = """      items: (data.items ?? []).map((item) => CartItem(
        id: item.id?.toString() ?? '',
        menuItemId: item.productId?.toString() ?? '',
        name: item.name ?? '',
        price: (item.unitPrice ?? item.price ?? 0).toInt(),
        unitPrice: (item.unitPrice ?? item.price ?? 0).toDouble(),
        totalPrice: (item.totalPrice ?? item.total ?? 0).toDouble(),
        imageAsset: item.image ?? '',
        quantity: item.quantity ?? 1,
        selectedModifiers: (item.optionValueIds ?? []).map((id) => <String, dynamic>{'option_id': id}).toList(),
        notes: '',
      )).toList(),"""

content = re.sub(old_mapper, new_mapper, content)

with open('lib/features/cart/data/models/cart_response_dto.dart', 'w') as f:
    f.write(content)

