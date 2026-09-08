import re

with open('lib/features/home/data/models/store_model.dart', 'r') as f:
    content = f.read()

content = content.replace("ratingCount: json['rating_count'] != null ? (json['rating_count'] as num).toInt() : null,", "ratingCount: json['rating_count'] != null ? (json['rating_count'] as num).toInt() : null,\n      availability: json['availability']?.toString() ?? 'open',")

with open('lib/features/home/data/models/store_model.dart', 'w') as f:
    f.write(content)
