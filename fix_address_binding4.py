import re

with open('lib/features/checkout/presentation/pages/checkout_screen.dart', 'r') as f:
    content = f.read()

content = content.replace(
    ': (address.title(Localizations.localeOf(context)).isNotEmpty == true)',
    ': (address?.title(Localizations.localeOf(context)).isNotEmpty == true)'
)

with open('lib/features/checkout/presentation/pages/checkout_screen.dart', 'w') as f:
    f.write(content)

