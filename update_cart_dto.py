import re

with open('lib/features/cart/data/models/cart_response_dto.dart', 'r') as f:
    content = f.read()

# Replace CartSummaryDto properties and constructor
new_dto_props = """class CartSummaryDto {
  final int? id;
  @JsonKey(name: 'user_id')
  final int? userId;
  @JsonKey(name: 'store_id')
  final int? storeId;

  @JsonKey(name: 'items_subtotal')
  final num? itemsSubtotal;
  @JsonKey(name: 'offer_discount')
  final num? offerDiscount;
  @JsonKey(name: 'coupon_discount')
  final num? couponDiscount;
  final num? delivery;
  final num? tax;
  final num? total;

  @JsonKey(name: 'coupon_code')
  final String? couponCode;
  
  @JsonKey(defaultValue: [])
  final List<CartItemDto>? items;
  
  final CartStoreBriefDto? store;

  CartSummaryDto({
    required this.id,
    required this.userId,
    this.storeId,
    required this.itemsSubtotal,
    required this.offerDiscount,
    required this.couponDiscount,
    required this.delivery,
    required this.tax,
    required this.total,
    this.couponCode,
    required this.items,
    this.store,
  });"""

content = re.sub(r'class CartSummaryDto \{[\s\S]*?    this\.store,\n  \}\);', new_dto_props, content)

# Update toEntity mapper
old_mapper = r"""      subtotal: \(data\.subtotal \?\? 0\)\.toDouble\(\),
      deliveryFee: \(data\.deliveryFee \?\? 0\)\.toDouble\(\),
      discount: \(data\.discount \?\? 0\)\.toDouble\(\),
      total: \(data\.total \?\? 0\)\.toDouble\(\),"""

new_mapper = """      subtotal: (data.itemsSubtotal ?? 0).toDouble(),
      deliveryFee: (data.delivery ?? 0).toDouble(),
      tax: (data.tax ?? 0).toDouble(),
      discount: ((data.offerDiscount ?? 0) + (data.couponDiscount ?? 0)).toDouble(),
      total: (data.total ?? 0).toDouble(),"""

content = re.sub(old_mapper, new_mapper, content)

with open('lib/features/cart/data/models/cart_response_dto.dart', 'w') as f:
    f.write(content)

