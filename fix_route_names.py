with open('lib/core/router/route_names.dart', 'r') as f:
    lines = f.readlines()

new_lines = [line for line in lines if "restaurantRate" not in line]

with open('lib/core/router/route_names.dart', 'w') as f:
    f.writelines(new_lines)
