import re

with open('lib/features/home/data/models/store_model.dart', 'r') as f:
    content = f.read()

content = content.replace("super.ratingCount,", "super.ratingCount,\n    super.availability,")

with open('lib/features/home/data/models/store_model.dart', 'w') as f:
    f.write(content)
