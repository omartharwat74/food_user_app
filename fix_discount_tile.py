import re

def process(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    content = content.replace('item.discountValue.toStringAsFixed(0)', 'item.discountValue.toFormattedPrice()')

    with open(filepath, 'w') as f:
        f.write(content)

process('lib/features/restaurant/presentation/widgets/menu_item_tile.dart')

