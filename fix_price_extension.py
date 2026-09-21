import os
import re

def process(filepath):
    if not os.path.exists(filepath): return
    with open(filepath, 'r') as f:
        content = f.read()

    # Update import
    content = content.replace("import 'package:food_user_app/core/utils/price_formatter.dart';", "import 'package:food_user_app/core/utils/price_extension.dart';")

    # Replace PriceFormatter.format(x) -> x.toFormattedPrice()
    content = re.sub(r'PriceFormatter\.format\(([^)]+)\)', r'(\1).toFormattedPrice()', content)
    
    # Replace PriceFormatter.formatNum(x) -> x.toFormattedPrice()
    content = re.sub(r'PriceFormatter\.formatNum\(([^)]+)\)', r'(\1).toFormattedPrice()', content)

    with open(filepath, 'w') as f:
        f.write(content)

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            process(os.path.join(root, file))

