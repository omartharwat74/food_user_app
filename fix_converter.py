with open('lib/features/restaurant/data/models/restaurant_dto.dart', 'r') as f:
    content = f.read()

content = content.replace('@IntBoolConverter()\n    \n    @IntBoolConverter()', '@IntBoolConverter()')
content = content.replace('@IntBoolConverter()\n    @IntBoolConverter()', '@IntBoolConverter()')

with open('lib/features/restaurant/data/models/restaurant_dto.dart', 'w') as f:
    f.write(content)
