import re

with open('lib/features/restaurant/domain/entities/restaurant.dart', 'r') as f:
    content = f.read()

# Add availability and tags to Restaurant
#   final String availability;
#   final List<String> tags;

content = content.replace("final bool isMajor;", "final bool isMajor;\n  final String availability;\n  final List<String> tags;")

# Add to constructor
#     this.availability = 'open',
#     this.tags = const [],

content = content.replace("this.isMajor = false,", "this.isMajor = false,\n    this.availability = 'open',\n    this.tags = const [],")

# Add to props
content = content.replace("isMajor,", "isMajor,\n    availability,\n    tags,")

with open('lib/features/restaurant/domain/entities/restaurant.dart', 'w') as f:
    f.write(content)
