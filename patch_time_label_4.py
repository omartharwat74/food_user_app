with open('lib/core/widgets/shared_store_list_tile.dart', 'r') as f:
    content = f.read()

content = content.replace("fontWeight: FontWeight.w500,", "")
content = content.replace("height: 1.25,", "height: 1.0,")

with open('lib/core/widgets/shared_store_list_tile.dart', 'w') as f:
    f.write(content)
