import re

filepath = 'lib/features/home/presentation/pages/home_screen.dart'
with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace the extra closing bracket sequence
content = content.replace("        ),\n      ),\n    );\n  }\n}", "        ),\n    );\n  }\n}")

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)
