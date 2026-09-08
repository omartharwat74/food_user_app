import re

with open('lib/core/router/route_names.dart', 'r') as f:
    content = f.read()

content = re.sub(r"\s*static const storeDetail = '/store/:id';", "", content)
content = re.sub(r"\s*static String storeDetailFor\(String id\) => '/store/\$id';", "", content)

with open('lib/core/router/route_names.dart', 'w') as f:
    f.write(content)
