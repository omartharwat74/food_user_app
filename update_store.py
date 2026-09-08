import re

with open('lib/features/home/domain/entities/store.dart', 'r') as f:
    content = f.read()

# Add final String availability;
content = content.replace("final int? ratingCount;", "final int? ratingCount;\n  final String availability;")

# Add to constructor
content = content.replace("this.ratingCount,", "this.ratingCount,\n    this.availability = 'open',")

# Add to props
content = content.replace("ratingAvg, ratingCount", "ratingAvg, ratingCount, availability")

with open('lib/features/home/domain/entities/store.dart', 'w') as f:
    f.write(content)

# Update StoreModel (Data layer) to parse availability
with open('lib/features/home/data/models/store_model.dart', 'r') as f:
    content_model = f.read()

content_model = content_model.replace("ratingCount: json['rating_count'] as int?,", "ratingCount: json['rating_count'] as int?,\n      availability: json['availability'] as String? ?? 'open',")

with open('lib/features/home/data/models/store_model.dart', 'w') as f:
    f.write(content_model)

