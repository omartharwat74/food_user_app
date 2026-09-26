import re

filepath = 'lib/features/market/presentation/pages/market_details_screen.dart'
with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

content = re.sub(r"const\s+SnackBar\(\s*content:\s*Text\(\s*AppLocalizations", r"SnackBar(\ncontent: Text(\nAppLocalizations", content)
content = re.sub(r"const\s+Text\(\s*AppLocalizations", r"Text(AppLocalizations", content)

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)

print("Fixed market_details_screen.")
