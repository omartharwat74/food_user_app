import re

with open('lib/features/restaurant/data/models/restaurant_dto.dart', 'r') as f:
    content = f.read()

# Add import for ReviewDto
if 'review_dto.dart' not in content:
    content = content.replace("import 'package:food_user_app/core/utils/bool_converter.dart';", 
        "import 'package:food_user_app/core/utils/bool_converter.dart';\nimport 'package:food_user_app/features/restaurant/data/models/review_dto.dart';")

# Add fields to the factory constructor
new_fields = """
    @IntBoolConverter()
    @JsonKey(name: 'is_major') bool? isMajor,
    String? address,
    @JsonKey(name: 'rating_distribution') Map<String, dynamic>? ratingDistribution,
    @Default([]) List<ReviewDto> reviews,
    @IntBoolConverter()
    @JsonKey(name: 'reviews_has_more') bool? reviewsHasMore,
"""
content = re.sub(r"@JsonKey\(name: 'is_major'\) bool\? isMajor,\n  }\)", new_fields + "  })", content)

# Update toEntity mapping
to_entity_new = """
      isMajor: isMajor ?? false,
      address: address ?? '',
      ratingDistribution: ratingDistribution ?? const {},
      reviews: reviews.map((r) => r.toEntity()).toList(),
      reviewsHasMore: reviewsHasMore ?? false,
    );
"""
content = re.sub(r"isMajor: isMajor \?\? false,\n    \);", to_entity_new, content)

with open('lib/features/restaurant/data/models/restaurant_dto.dart', 'w') as f:
    f.write(content)

