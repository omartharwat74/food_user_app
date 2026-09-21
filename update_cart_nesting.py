import re

with open('lib/features/cart/data/models/cart_response_dto.dart', 'r') as f:
    content = f.read()

details_class = """@JsonSerializable()
class CartSummaryDetailsDto {
  @JsonKey(name: 'items_subtotal')
  final num? itemsSubtotal;
  @JsonKey(name: 'offer_discount')
  final num? offerDiscount;
  @JsonKey(name: 'coupon_discount')
  final num? couponDiscount;
  final num? delivery;
  final num? tax;
  final num? total;

  CartSummaryDetailsDto({
    this.itemsSubtotal,
    this.offerDiscount,
    this.couponDiscount,
    this.delivery,
    this.tax,
    this.total,
  });

  factory CartSummaryDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$CartSummaryDetailsDtoFromJson(json);
}

@JsonSerializable()
class CartSummaryDto {"""

content = re.sub(r'@JsonSerializable\(\)\nclass CartSummaryDto \{', details_class, content)

# Update CartSummaryDto fields
old_fields = """  @JsonKey(name: 'items_subtotal')
  final num? itemsSubtotal;
  @JsonKey(name: 'offer_discount')
  final num? offerDiscount;
  @JsonKey(name: 'coupon_discount')
  final num? couponDiscount;
  final num? delivery;
  final num? tax;
  final num? total;"""

new_fields = "  final CartSummaryDetailsDto? summary;"

content = content.replace(old_fields, new_fields)

# Update CartSummaryDto constructor
old_constructor = """    required this.itemsSubtotal,
    required this.offerDiscount,
    required this.couponDiscount,
    required this.delivery,
    required this.tax,
    required this.total,"""

new_constructor = "    this.summary,"

content = content.replace(old_constructor, new_constructor)

# Update Mapper
old_mapper = """      subtotal: (data.itemsSubtotal ?? 0).toDouble(),
      deliveryFee: (data.delivery ?? 0).toDouble(),
      tax: (data.tax ?? 0).toDouble(),
      discount: ((data.offerDiscount ?? 0) + (data.couponDiscount ?? 0)).toDouble(),
      total: (data.total ?? 0).toDouble(),"""

new_mapper = """      subtotal: (data.summary?.itemsSubtotal ?? 0).toDouble(),
      deliveryFee: (data.summary?.delivery ?? 0).toDouble(),
      tax: (data.summary?.tax ?? 0).toDouble(),
      discount: ((data.summary?.offerDiscount ?? 0) + (data.summary?.couponDiscount ?? 0)).toDouble(),
      total: (data.summary?.total ?? 0).toDouble(),"""

content = content.replace(old_mapper, new_mapper)

with open('lib/features/cart/data/models/cart_response_dto.dart', 'w') as f:
    f.write(content)

