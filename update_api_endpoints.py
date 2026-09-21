import re

with open('lib/core/constants/api_endpoints.dart', 'r') as f:
    content = f.read()

cart_section = """  // ── Cart ──────────────────────────────────────────────────────────────────
  static const String cart = '/api/v1/cart';
  static const String cartItems = '/api/v1/cart/items';
  static const String applyPromo = '/cart/promo';"""

content = re.sub(r'// ── Cart ──.*?static const String applyPromo = \'/cart/promo\';', cart_section, content, flags=re.DOTALL)

with open('lib/core/constants/api_endpoints.dart', 'w') as f:
    f.write(content)

