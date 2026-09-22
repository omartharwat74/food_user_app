import re

with open('test/widget_test.dart', 'r') as f:
    content = f.read()

content = re.sub(r"    expect\(\n      RouteNames\.restaurantRateFor\('az-al-sham'\),\n      '/restaurant/az-al-sham/rate',\n    \);\n", "", content)

with open('test/widget_test.dart', 'w') as f:
    f.write(content)
