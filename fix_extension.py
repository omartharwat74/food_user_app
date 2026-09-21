import re

with open('lib/features/cart/data/models/cart_response_dto.dart', 'r') as f:
    content = f.read()

# Strip out everything from `extension CartResponseDtoMapper on CartResponseDto {` to the end of the file
content = re.sub(r'extension CartResponseDtoMapper on CartResponseDto \{[\s\S]*$', '', content)

# Append the correct extension
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
}
"""

with open('lib/features/cart/data/models/cart_response_dto.dart', 'w') as f:
    f.write(content + extension_code)

