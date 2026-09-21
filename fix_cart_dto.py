import re

with open('lib/features/cart/data/models/cart_response_dto.dart', 'r') as f:
    content = f.read()

# Let's replace the fields in CartResponseDto
content = re.sub(r'final String message;', r'final String? message;', content)

# In CartSummaryDto
content = re.sub(r'final int id;', r'final int? id;', content)
content = re.sub(r'final int userId;', r'final int? userId;', content)
content = re.sub(r'final double subtotal;', r'final num? subtotal;', content)
content = re.sub(r'final double deliveryFee;', r'final num? deliveryFee;', content)
content = re.sub(r'final double discount;', r'final num? discount;', content)
content = re.sub(r'final double tax;', r'final num? tax;', content)
content = re.sub(r'final double total;', r'final num? total;', content)
content = re.sub(r'final List<CartItemDto> items;', r'final List<CartItemDto>? items;', content)

# In CartItemDto
content = re.sub(r'final int productId;', r'final int? productId;', content)
content = re.sub(r'final int quantity;', r'final int? quantity;', content)
content = re.sub(r'final double price;', r'final num? price;', content)
content = re.sub(r'final double total;\n  final String name;', r'final num? total;\n  final String? name;', content)
content = re.sub(r'final List<int> optionValueIds;', r'final List<int>? optionValueIds;', content)

# In CartStoreBriefDto
content = re.sub(r'final String name;\n  final String\? image;', r'final String? name;\n  final String? image;', content)
content = re.sub(r'final double\? deliveryFee;', r'final num? deliveryFee;', content)
content = re.sub(r'final double\? minOrderAmount;', r'final num? minOrderAmount;', content)

# Replace the extension
extension_code = """extension CartResponseDtoMapper on CartResponseDto {
  Cart toEntity() {
    return Cart(
      id: data.id?.toString() ?? '',
      restaurantId: data.storeId?.toString() ?? data.store?.id?.toString() ?? '',
      restaurantName: data.store?.name ?? '',
      items: (data.items ?? []).map((item) => CartItem(
        id: item.id?.toString() ?? '',
        menuItemId: item.productId?.toString() ?? '',
        name: item.name ?? '',
        price: (item.price ?? 0).toInt(),
        unitPrice: (item.price ?? 0).toDouble(),
        totalPrice: (item.total ?? 0).toDouble(),
        quantity: item.quantity ?? 1,
        selectedModifiers: (item.optionValueIds ?? []).map((id) => <String, dynamic>{'option_id': id}).toList(),
        notes: '',
      )).toList(),
      subtotal: (data.subtotal ?? 0).toDouble(),
      deliveryFee: (data.deliveryFee ?? 0).toDouble(),
      discount: (data.discount ?? 0).toDouble(),
      total: (data.total ?? 0).toDouble(),
    );
  }
}"""

content = re.sub(r'extension CartResponseDtoMapper on CartResponseDto \{[\s\S]*?\}', extension_code, content)

with open('lib/features/cart/data/models/cart_response_dto.dart', 'w') as f:
    f.write(content)
